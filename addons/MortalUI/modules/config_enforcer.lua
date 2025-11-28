-- ==================================================
-- Project Mortal Warcraft
-- Feature: Config Enforcer
-- Description: Ensures critical UI settings cannot be disabled
-- Spec: 15-ui-client.md
-- ==================================================

local ConfigEnforcer = {}

-- Enforced settings
local ENFORCED_SETTINGS = {
    nameplatesAlwaysOn = true,
    combatTextStyle = "default",
    mapOverlaysActive = true,
    actionBarsNeverHidden = true,
    tooltipFormattingRequired = true,
    hungerDisplayCannotDisable = true,
    encumbranceDisplayCannotDisable = true
}

-- Initialize config enforcer
function ConfigEnforcer.Initialize()
    -- Enforce settings on login and periodically
    ConfigEnforcer.EnforceSettings()
    
    -- Periodic enforcement
    local frame = CreateFrame("Frame")
    frame:SetScript("OnUpdate", function(self, elapsed)
        self.timer = (self.timer or 0) + elapsed
        if self.timer >= 5 then -- Every 5 seconds
            ConfigEnforcer.EnforceSettings()
            self.timer = 0
        end
    end)
end

-- Enforce settings
function ConfigEnforcer.EnforceSettings()
    -- Nameplates always on in Yellow/Red zones
    ConfigEnforcer.EnforceNameplatesByZone()

    -- Action bars never hidden
    if MainMenuBar then
        MainMenuBar:Show()
    end

    -- Tooltip formatting required
    ConfigEnforcer.EnforceTooltipAddon()

    -- Hunger/encumbrance display cannot be disabled
    if MortalUIHunger then
        MortalUIHunger:Show()
    end
    if MortalUIEncumbrance then
        MortalUIEncumbrance:Show()
    end
end

-- Check zone type and enforce nameplates
function ConfigEnforcer.EnforceNameplatesByZone()
    local zoneType = ConfigEnforcer.GetZoneType()
    if zoneType == "red" or zoneType == "yellow" then
        -- Force nameplates to always show
        SetCVar("nameplateShowAll", 1)
        SetCVar("nameplateShowEnemies", 1)
        SetCVar("nameplateShowFriends", 1)
        -- Additional nameplate settings for visibility
        SetCVar("nameplateMaxDistance", 60)
        SetCVar("nameplateOtherTopInset", -1)
        SetCVar("nameplateOtherBottomInset", -1)
    end
end

-- Get current zone type (from server data)
function ConfigEnforcer.GetZoneType()
    -- Zone type is stored from server packets
    return ConfigEnforcer.currentZoneType or "green"
end

-- Set zone type (called from server packet)
function ConfigEnforcer.SetZoneType(zoneType)
    ConfigEnforcer.currentZoneType = zoneType
end

-- Ensure tooltip addon is loaded
function ConfigEnforcer.EnforceTooltipAddon()
    -- Check if tooltip injector is loaded
    if not MortalUITooltipInjector then
        -- Try to load the tooltip injector module
        if MortalUI and MortalUI.modules and MortalUI.modules.ui_tooltip_injector then
            MortalUI.modules.ui_tooltip_injector:Initialize()
        end
    end
end

-- Register for zone type packets
local function OnZoneTypePacket(data)
    if #data >= 1 then
        local zoneType = data[1]
        ConfigEnforcer.SetZoneType(zoneType)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.ZONE_TYPE, OnZoneTypePacket)
end

-- Export
MortalUIConfigEnforcer = ConfigEnforcer

