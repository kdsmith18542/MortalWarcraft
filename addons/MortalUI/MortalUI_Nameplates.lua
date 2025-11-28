-- ==================================================
-- Mortal UI: Nameplate Driver
-- Description: Overrides TidyPlates colors based on Guild Politics.
-- Version: 25.0
-- ==================================================

local MortalUI = LibStub("AceAddon-3.0"):GetAddon("MortalUI")

-- War targets cache (synced from server)
MortalUI.WarTargets = MortalUI.WarTargets or {}
MortalUI.CriminalTargets = MortalUI.CriminalTargets or {}

-- Check if TidyPlates is available
if not TidyPlates then
    print("|cffFF0000[MortalUI]: TidyPlates not found. Nameplate driver disabled.|r")
    return
end

-- Update nameplate color based on war status
local function UpdatePlateColor(plate)
    if not plate or not plate.unit then 
        return 
    end
    
    local unit = plate.unit
    local name = UnitName(unit)
    
    if not name then
        return
    end
    
    -- Check Local State (Synced from Server)
    local warStatus = MortalUI.WarTargets[name]
    local isCriminal = MortalUI.CriminalTargets[name]
    
    -- Priority: War Status > Criminal Status > Default
    if warStatus == "ENEMY" then
        -- Force Red Healthbar
        if plate.healthbar then
            plate.healthbar:SetStatusBarColor(1, 0, 0) -- Red
        end
        
        -- Add "WAR TARGET" text
        if plate.name then
            plate.name:SetText("|cffFF0000[WAR] " .. name .. "|r")
        end
    elseif warStatus == "ALLY" then
        -- Force Blue/Green Healthbar
        if plate.healthbar then
            plate.healthbar:SetStatusBarColor(0, 0.5, 1) -- Blue
        end
        
        if plate.name then
            plate.name:SetText("|cff00AAFF[ALLY] " .. name .. "|r")
        end
    elseif isCriminal then
        -- Yellow for criminals
        if plate.healthbar then
            plate.healthbar:SetStatusBarColor(1, 1, 0) -- Yellow
        end
        
        if plate.name then
            plate.name:SetText("|cffFFFF00[CRIMINAL] " .. name .. "|r")
        end
    end
end

-- Hook TidyPlates Update
if TidyPlates then
    -- Hook the update function (varies by TidyPlates version)
    if TidyPlates.OnUpdate then
        hooksecurefunc(TidyPlates, "OnUpdate", UpdatePlateColor)
    end
    
    -- Hook OnShow to catch new plates instantly
    if TidyPlates.OnShow then
        hooksecurefunc(TidyPlates, "OnShow", UpdatePlateColor)
    end
    
    -- Alternative: Hook the theme update function
    if TidyPlates.UpdatePlate then
        hooksecurefunc(TidyPlates, "UpdatePlate", UpdatePlateColor)
    end
    
    -- Force update all plates when war data changes
    local function ForcePlateUpdate()
        if TidyPlates.ForceUpdate then
            TidyPlates:ForceUpdate()
        elseif TidyPlates.UpdateAllPlates then
            TidyPlates:UpdateAllPlates()
        end
    end
    
    -- Store force update function
    MortalUI.ForcePlateUpdate = ForcePlateUpdate
end

-- Server Sync: Update war status
function MortalUI:SyncWarData(targetName, status)
    if not targetName then
        return
    end
    
    MortalUI.WarTargets = MortalUI.WarTargets or {}
    
    if status == "NONE" or status == "" then
        MortalUI.WarTargets[targetName] = nil
    else
        MortalUI.WarTargets[targetName] = status
    end
    
    -- Trigger plate refresh
    if MortalUI.ForcePlateUpdate then
        MortalUI.ForcePlateUpdate()
    end
end

-- Server Sync: Update criminal status
function MortalUI:SyncCriminalData(targetName, isCriminal)
    if not targetName then
        return
    end
    
    MortalUI.CriminalTargets = MortalUI.CriminalTargets or {}
    
    if isCriminal then
        MortalUI.CriminalTargets[targetName] = true
    else
        MortalUI.CriminalTargets[targetName] = nil
    end
    
    -- Trigger plate refresh
    if MortalUI.ForcePlateUpdate then
        MortalUI.ForcePlateUpdate()
    end
end

-- Handle addon messages from server
local function OnNameplateMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_NAMEPLATE" then
        return
    end
    
    -- Parse message: WAR:NAME:STATUS or CRIMINAL:NAME:STATUS
    if message:find("^WAR:") then
        local targetName, status = message:match("^WAR:(.+):(.+)$")
        if targetName and status then
            MortalUI:SyncWarData(targetName, status)
        end
    elseif message:find("^CRIMINAL:") then
        local targetName, isCriminal = message:match("^CRIMINAL:(.+):(%d+)$")
        if targetName then
            MortalUI:SyncCriminalData(targetName, tonumber(isCriminal) == 1)
        end
    end
end

-- Register for addon messages
MortalUI:RegisterEvent("CHAT_MSG_ADDON", OnNameplateMessage)

print("|cff00FF00[MortalUI]: Nameplate Driver loaded (TidyPlates).|r")

