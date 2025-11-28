-- ==================================================
-- Mortal UI: Core Logic & Config Enforcer
-- Description: Handles data sync and forces Addon settings.
-- Version: 21.3
-- ==================================================

MortalUI = LibStub("AceAddon-3.0"):NewAddon("MortalUI", "AceConsole-3.0", "AceEvent-3.0")

MortalUI.State = {
    CurrentWeight = 0,
    MaxWeight = 250,
    Hunger = 100
}

function MortalUI:OnInitialize()
    self:RegisterEvent("CHAT_MSG_ADDON")
    self:RegisterEvent("PLAYER_LOGIN")
    
    -- Register slash commands
    self:RegisterChatCommand("mortalui", "SlashCommand")
    self:RegisterChatCommand("mu", "SlashCommand")
    
    print("|cffFF0000Mortal UI Loaded.|r")
end

function MortalUI:PLAYER_LOGIN()
    if not MortalUIDB then 
        MortalUIDB = {} 
    end
    
    -- Check if we have configured this character before
    if not MortalUIDB.IsConfigured then
        self:ApplyDefaultSettings()
        
        -- Action Cam Default: Enabled unless user opted out
        if MortalUIDB.EnableActionCam == nil then
            MortalUIDB.EnableActionCam = true
            self:ToggleActionCam(true)
        end
        
        MortalUIDB.IsConfigured = true
        print("|cff00FF00[MortalUI]: Interface calibrated for survival.|r")
        ReloadUI()
    else
        -- Already configured, restore ActionCam state
        if MortalUIDB.EnableActionCam then
            self:ToggleActionCam(true)
        end
    end
end

function MortalUI:ToggleActionCam(enable)
    if enable then
        -- ConsolePort / DynamicCam activation logic
        SetCVar("ActionCam", "full") -- Note: 3.3.5 needs specific console commands or addon calls
        
        -- If using DynamicCam backport, call its enable function:
        if DynamicCam then 
            DynamicCam:Enable() 
        end
        
        print("|cff00FF00[MortalUI]: Action Camera Enabled. Type /mortal cam off to disable.|r")
    else
        SetCVar("ActionCam", "none")
        
        if DynamicCam then 
            DynamicCam:Disable() 
        end
        
        print("|cffFFFF00[MortalUI]: Action Camera Disabled.|r")
    end
end

function MortalUI:ApplyDefaultSettings()
    -- Configure Bagnon (Force One Bag)
    if Bagnon then
        if not BagnonDB then
            BagnonDB = {}
        end
        
        if not BagnonDB.profiles then
            BagnonDB.profiles = {}
        end
        
        local profile = BagnonDB.profiles.Default or {}
        BagnonDB.profiles.Default = profile
        
        -- Force single bag window
        profile.oneBag = true
        profile.oneBagFrame = true
        
        -- Reload Bagnon if it's already loaded
        if Bagnon:IsEnabled() then
            Bagnon:Reload()
        end
        
        print("|cff00FF00[MortalUI]: Bagnon configured (Single Bag Window).|r")
    end
    
    -- Configure Bartender4 (Minimal UI)
    if Bartender4 then
        if not Bartender4DB then
            Bartender4DB = {}
        end
        
        if not Bartender4DB.namespace then
            Bartender4DB.namespace = {}
        end
        
        -- Hide micro menu
        if Bartender4DB.namespace.MicroMenu then
            Bartender4DB.namespace.MicroMenu.enabled = false
        end
        
        -- Hide bag bar
        if Bartender4DB.namespace.BagBar then
            Bartender4DB.namespace.BagBar.enabled = false
        end
        
        print("|cff00FF00[MortalUI]: Bartender4 configured (Minimal UI).|r")
    end
    
    -- Configure Mapster (if available)
    if MapsterDB then
        MapsterDB.minimap = {
            hide = false,
            scale = 1.0
        }
        print("|cff00FF00[MortalUI]: Mapster configured.|r")
    end
end

-- Handle addon messages from server
function MortalUI:CHAT_MSG_ADDON(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_DATA" and prefix ~= "MORTAL_ITEM" and prefix ~= "MORTAL_ZONE" then
        return
    end

    -- Parse weight/hunger updates
    if prefix == "MORTAL_DATA" then
        local dataType, value = message:match("^(%S+):(.+)$")
        value = tonumber(value)

        if not dataType or not value then
            return
        end

        if dataType == "WEIGHT" then
            self.State.CurrentWeight = value or 0
            if self.UpdateBagDisplay then
                self:UpdateBagDisplay()
            end
        elseif dataType == "MAX_WEIGHT" then
            self.State.MaxWeight = value or 250
            if self.UpdateBagDisplay then
                self:UpdateBagDisplay()
            end
        elseif dataType == "HUNGER" then
            self.State.Hunger = value or 100
        end
    elseif prefix == "MORTAL_ZONE" then
        -- Handle zone change notifications
        local messageType, data = message:match("^(%d+):(.*)$")
        messageType = tonumber(messageType)

        if messageType == 1 then  -- MSG_ZONE_CHANGE
            local riskLevel, zoneName = data:match("^(%d+):(.*)$")
            riskLevel = tonumber(riskLevel)

            -- Show zone change notification
            self:ShowZoneChangeNotification(riskLevel, zoneName)
        end
    end
end

-- Show zone change notification
function MortalUI:ShowZoneChangeNotification(riskLevel, zoneName)
    if not zoneName or zoneName == "" then
        zoneName = "Unknown Zone"
    end

    local riskText, color
    if riskLevel == 0 then
        riskText = "Safe Zone"
        color = "00FF00"  -- Green
    elseif riskLevel == 1 then
        riskText = "Mid-Risk Zone"
        color = "FFFF00"  -- Yellow
    elseif riskLevel == 2 then
        riskText = "Full-Loot Zone"
        color = "FF0000"  -- Red
    else
        riskText = "Unknown Risk"
        color = "FFFFFF"  -- White
    end

    print(string.format("|cff%s[MortalUI]: Entered %s - %s|r", color, zoneName, riskText))
end

-- Slash command handler
function MortalUI:SlashCommand(input)
    local command, arg = input:match("^(%S+)%s*(.*)$")
    command = command or input
    
    if command == "cam" or command == "camera" then
        if arg == "off" or arg == "disable" then
            MortalUIDB.EnableActionCam = false
            self:ToggleActionCam(false)
        elseif arg == "on" or arg == "enable" then
            MortalUIDB.EnableActionCam = true
            self:ToggleActionCam(true)
        else
            print("|cffFFFF00[MortalUI]: Usage: /mortal cam [on|off]|r")
        end
    elseif command == "reload" then
        ReloadUI()
    elseif command == "config" then
        print("|cffFFFF00[MortalUI]: Configuration Status:|r")
        print(string.format("  Action Camera: %s", MortalUIDB.EnableActionCam and "|cff00FF00Enabled|r" or "|cffFF0000Disabled|r"))
        print(string.format("  Weight: %.1f / %.1f lbs", self.State.CurrentWeight, self.State.MaxWeight))
        print(string.format("  Hunger: %d%%", self.State.Hunger))
    else
        print("|cffFFFF00[MortalUI]: Commands:|r")
        print("  /mortal cam [on|off] - Toggle Action Camera")
        print("  /mortal reload - Reload UI")
        print("  /mortal config - Show configuration status")
    end
end
