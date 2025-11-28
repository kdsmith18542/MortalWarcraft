-- ==================================================
-- Project Mortal Warcraft
-- Feature: MortalUI Meta-Addon
-- Description: Main addon file for MortalUI
-- Spec: 15-ui-client.md
-- ==================================================

local MortalUI = CreateFrame("Frame")
MortalUI:RegisterEvent("ADDON_LOADED")
MortalUI:RegisterEvent("PLAYER_LOGIN")

-- Addon version
local ADDON_VERSION = "1.0.0"

-- Initialize addon
local function Initialize()
    print("|cff00FF00MortalUI|r v" .. ADDON_VERSION .. " loaded")
    
    -- Load modules
    -- Modules are loaded via embeds.xml
    
    -- Initialize config enforcer
    if MortalUIConfigEnforcer then
        MortalUIConfigEnforcer.Initialize()
    end
    
    -- Initialize new UI modules
    if MortalUIFactionPanel then
        print("|cff00FF00MortalUI|r: Faction panel loaded")
    end
    if MortalUISeasonPanel then
        print("|cff00FF00MortalUI|r: Season challenges loaded")
    end
    if MortalUIRunesPanel then
        print("|cff00FF00MortalUI|r: Runes & augments loaded")
    end
    if MortalUIBuildPresetsPanel then
        print("|cff00FF00MortalUI|r: Build presets loaded")
    end
    if MortalUIFishingPanel then
        print("|cff00FF00MortalUI|r: Fishing & First Aid loaded")
    end

    -- Initialize advanced signage system
    if addonTable and addonTable.AdvancedSignage then
        addonTable.AdvancedSignage.Initialize()
        print("|cff00FF00MortalUI|r: Advanced signage system loaded")
    end
end

-- Event handler
MortalUI:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "MortalUI" then
        -- Addon loaded, wait for player login
    elseif event == "PLAYER_LOGIN" then
        Initialize()
    end
end)

-- Export
MortalUI_Global = MortalUI

