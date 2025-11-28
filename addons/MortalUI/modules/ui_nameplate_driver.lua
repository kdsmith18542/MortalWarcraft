-- ==================================================
-- Project Mortal Warcraft
-- Feature: Nameplate Driver (Client-Side)
-- Description: Custom nameplate rendering for Mortal systems
-- Spec: 15-ui-client.md
-- ==================================================

-- Requires nameplate addon (TidyPlates or similar)
local NameplateDriver = {}

-- Nameplate styles
local NAMEPLATE_STYLES = {
    innocent = { color = { r = 1, g = 1, b = 1 } },
    suspect = { color = { r = 1, g = 1, b = 0 } },
    criminal = { color = { r = 1, g = 0.5, b = 0 } },
    outlaw = { color = { r = 1, g = 0, b = 0 } },
    infamous = { color = { r = 1, g = 0, b = 0 }, icon = "skull" }
}

-- Update nameplate (called from nameplate addon)
function NameplateDriver.UpdateNameplate(nameplate, unit)
    if not unit or not UnitIsPlayer(unit) then
        return
    end
    
    -- Get player data from server via custom packet
    local playerName = UnitName(unit)
    if playerName and MortalPacketHandler then
        C_ChatInfo.SendAddonMessage("MORTAL_PACKET", "QUERY_NAMEPLATE:" .. playerName, "WHISPER", UnitName("player"))
    end
    
    -- Cache for player data
    local playerDataCache = NameplateDriver.playerDataCache or {}
    local cachedData = playerDataCache[playerName]
    
    if cachedData then
            local style = NAMEPLATE_STYLES.innocent
        if cachedData.notoriety >= 4 then
            style = NAMEPLATE_STYLES.infamous
        elseif cachedData.notoriety == 3 then
            style = NAMEPLATE_STYLES.outlaw
        elseif cachedData.notoriety == 2 then
            style = NAMEPLATE_STYLES.criminal
        elseif cachedData.notoriety == 1 then
            style = NAMEPLATE_STYLES.suspect
        end
        
        -- Apply color to nameplate
        if nameplate and nameplate.healthBar then
            nameplate.healthBar:SetStatusBarColor(style.color.r, style.color.g, style.color.b, 1)
        end
    end
end

-- Handle nameplate data packet
local function OnNameplatePacket(data)
    if #data >= 2 then
        local playerName = data[1]
        local playerDataCache = NameplateDriver.playerDataCache or {}
        playerDataCache[playerName] = {
            notoriety = tonumber(data[2]) or 0,
            derivedLevel = tonumber(data[3]) or 0,
            hasBounty = data[4] == "1",
            isEncumbered = data[5] == "1"
        }
        NameplateDriver.playerDataCache = playerDataCache
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.NAMEPLATE, OnNameplatePacket)
end

-- Register with nameplate addon (TidyPlates example)
if TidyPlates then
    TidyPlates:RegisterCallback("TidyPlates_UpdateNameplateWidget", NameplateDriver.UpdateNameplate)
end

-- Export
MortalUINameplateDriver = NameplateDriver

