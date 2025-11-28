-- ==================================================
-- HandyNotes (Embedded Minimal Implementation)
-- Provides core HandyNotes API for MortalUI map pins
-- This is a simplified version that provides only the functionality needed
-- ==================================================

local LibStub = LibStub
if not LibStub then
    error("HandyNotes (Embedded) requires LibStub")
    return
end

-- Create HandyNotes namespace
-- Check if external HandyNotes is already loaded
if _G.HandyNotes and _G.HandyNotes.RegisterPluginDB then
    -- External HandyNotes found, don't override it
    return
end

local HandyNotes = LibStub:NewLibrary("HandyNotes", 1)
if not HandyNotes then
    return -- Already loaded (shouldn't happen, but safety check)
end

-- Plugin registry
local plugins = {}
local enabledPlugins = {}

-- Map file to map ID cache (simplified)
local mapFileToMapID = {}

-- Initialize map file cache
local function InitializeMapCache()
    -- This is a simplified version - in production you'd want a full mapping
    -- For now, we'll use zone IDs directly
end

-- Get map ID from map file
function HandyNotes:GetMapFiletoMapID(mapFile)
    if not mapFile then
        return nil
    end
    
    -- Try cache first
    if mapFileToMapID[mapFile] then
        return mapFileToMapID[mapFile]
    end
    
    -- Simplified: Try to extract from map file name
    -- Format is usually "WorldMap_<ZoneName>" or similar
    -- For now, return nil and let plugins handle zone IDs directly
    return nil
end

-- Register a plugin
function HandyNotes:RegisterPluginDB(name, plugin, options)
    if not name or not plugin then
        return false
    end
    
    plugins[name] = {
        plugin = plugin,
        options = options or {},
        enabled = true
    }
    
    enabledPlugins[name] = plugin
    
    -- Notify plugin it's registered
    if plugin.OnEnable then
        plugin:OnEnable()
    end
    
    return true
end

-- Unregister a plugin
function HandyNotes:UnregisterPluginDB(name)
    if plugins[name] then
        if enabledPlugins[name] and enabledPlugins[name].OnDisable then
            enabledPlugins[name]:OnDisable()
        end
        plugins[name] = nil
        enabledPlugins[name] = nil
    end
end

-- Check if addon is enabled
function HandyNotes:IsEnabled()
    return true -- Always enabled when embedded
end

-- Get all nodes for a map
function HandyNotes:GetNodes(mapFile, minimap, level)
    local nodes = {}
    
    for name, pluginData in pairs(plugins) do
        if pluginData.enabled and pluginData.plugin.GetNodes then
            local pluginNodes = pluginData.plugin:GetNodes(mapFile, minimap, level)
            if pluginNodes then
                for coord, data in pairs(pluginNodes) do
                    nodes[coord] = data
                end
            end
        end
    end
    
    return nodes
end

-- Send update notification
function HandyNotes:SendMessage(message, ...)
    -- Simplified message system
    -- In full HandyNotes, this would use AceEvent
    -- For embedded version, we'll trigger updates directly
    if message == "HandyNotes_NotifyUpdate" then
        -- Trigger map refresh
        if WorldMapFrame and WorldMapFrame:IsShown() then
            -- Refresh world map
            if WorldMapFrame.RefreshAllDataProviders then
                WorldMapFrame:RefreshAllDataProviders()
            end
        end
        
        -- Refresh minimap if available
        if Minimap then
            Minimap:Update()
        end
    end
end

-- NewModule function (for compatibility with external HandyNotes)
function HandyNotes:NewModule(name, ...)
    -- Create a simple module object
    local module = {
        name = name,
        points = {}
    }
    
    -- Mix in any provided mixins
    for i = 1, select("#", ...) do
        local mixin = select(i, ...)
        if type(mixin) == "string" then
            -- Handle mixin strings (like "AceEvent-3.0")
            -- For embedded version, we'll skip this
        end
    end
    
    return module
end

-- Create HandyNotes frame for event handling
local HandyNotesFrame = CreateFrame("Frame")
HandyNotesFrame:RegisterEvent("ADDON_LOADED")
HandyNotesFrame:RegisterEvent("WORLD_MAP_UPDATE")
HandyNotesFrame:RegisterEvent("PLAYER_LOGIN")

HandyNotesFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" then
        if addonName == "MortalUI" or addonName == "HandyNotes" then
            InitializeMapCache()
        end
    elseif event == "WORLD_MAP_UPDATE" then
        -- Refresh nodes when map updates
        -- This is handled by the plugin system
    elseif event == "PLAYER_LOGIN" then
        InitializeMapCache()
    end
end)

-- Initialize
InitializeMapCache()

-- Export global (only if not already set by external HandyNotes)
if not _G.HandyNotes then
    _G.HandyNotes = HandyNotes
    print("|cff00FF00[HandyNotes]: Embedded version loaded for MortalUI.|r")
else
    -- External HandyNotes found, use that instead
    print("|cff00FF00[MortalUI]: Using external HandyNotes addon.|r")
end

