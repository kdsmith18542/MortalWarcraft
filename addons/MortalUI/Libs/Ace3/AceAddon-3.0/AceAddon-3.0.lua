-- AceAddon-3.0: Addon framework for WoW
-- Simplified version for MortalUI
-- This is a minimal implementation - full Ace3 should be downloaded separately

local AceAddon, minor = LibStub:NewLibrary("AceAddon-3.0", 3)
if not AceAddon then return end

local AceEvent = LibStub("AceEvent-3.0", true)
local AceConsole = LibStub("AceConsole-3.0", true)
local AceDB = LibStub("AceDB-3.0", true)

local addons = {}
local addonsToEnable = {}

local function initializeAddon(addon)
    if addon.OnInitialize then
        addon:OnInitialize()
    end
    if addon.OnEnable then
        table.insert(addonsToEnable, addon)
    end
end

function AceAddon:NewAddon(name, ...)
    local addon = {
        name = name,
        baseName = name,
    }
    
    -- Mix in optional modules
    for i = 1, select("#", ...) do
        local mixin = select(i, ...)
        if type(mixin) == "string" then
            local lib = LibStub(mixin, true)
            if lib then
                for k, v in pairs(lib) do
                    if type(v) == "function" and not addon[k] then
                        addon[k] = v
                    end
                end
            end
        end
    end
    
    -- Set up event handling if AceEvent is available
    if AceEvent then
        addon.RegisterEvent = function(self, event, method)
            AceEvent.RegisterEvent(self, event, method or event)
        end
        addon.UnregisterEvent = function(self, event)
            AceEvent.UnregisterEvent(self, event)
        end
    end
    
    -- Set up console commands if AceConsole is available
    if AceConsole then
        addon.RegisterChatCommand = function(self, command, method)
            AceConsole.RegisterChatCommand(self, command, method)
        end
    end
    
    -- Set up database if AceDB is available
    if AceDB then
        addon.SetDefaultModuleState = function(self, state)
            -- Placeholder
        end
    end
    
    addons[name] = addon
    
    -- Initialize if already loaded
    if GetAddOnMetadata(name, "Version") then
        initializeAddon(addon)
    end
    
    return addon
end

function AceAddon:GetAddon(name)
    return addons[name]
end

-- Enable all addons after initialization
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addons[addonName] then
        initializeAddon(addons[addonName])
    end
end)

-- Enable phase
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        for _, addon in ipairs(addonsToEnable) do
            if addon.OnEnable then
                addon:OnEnable()
            end
        end
        addonsToEnable = {}
    end
end)

