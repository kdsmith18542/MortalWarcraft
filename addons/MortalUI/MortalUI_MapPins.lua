-- ==================================================
-- Mortal UI: Map Pin System
-- Description: Bridges Server Data -> HandyNotes for Map Icons.
-- Requires: HandyNotes (Embedded)
-- Version: 25.0
-- ==================================================

local MortalUI = LibStub("AceAddon-3.0"):GetAddon("MortalUI")

-- HandyNotes is now embedded (loaded via embeds.xml before this file)
-- Prefer external version if player has it installed, otherwise use embedded
local HandyNotes = _G.HandyNotes
if not HandyNotes then
    -- Embedded version should be loaded, but wait a moment if needed
    -- This handles load order edge cases
    local waitFrame = CreateFrame("Frame")
    waitFrame:RegisterEvent("ADDON_LOADED")
    waitFrame:SetScript("OnEvent", function(self, event, addonName)
        if addonName == "MortalUI" then
            HandyNotes = _G.HandyNotes
            if HandyNotes then
                waitFrame:UnregisterAllEvents()
            end
        end
    end)
    
    -- Fallback: check after a short delay
    C_Timer.After(0.5, function()
        HandyNotes = _G.HandyNotes
    end)
end

-- Create HandyNotes plugin
-- Use embedded HandyNotes or external if available
local MortalPins = {}
MortalPins.points = {} -- [MapID] = { [Coord] = Data }

-- Icon Definitions
MortalPins.icons = {
    ["TASK"] = "Interface\\GossipFrame\\AvailableQuestIcon",
    ["BOSS"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8",
    ["SIEGE"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_4",
    ["STRONGHOLD"] = "Interface\\GroupFrame\\UI-Group-MasterLooter",
    ["WARFRONT"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_1",
    ["BOUNTY"] = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"
}

-- Pin type mapping
local PIN_TYPE_MAP = {
    [1] = "TASK",
    [2] = "BOSS",
    [3] = "SIEGE",
    [4] = "STRONGHOLD",
    [5] = "WARFRONT"
}

-- Helper: Convert game coordinates to map UI coordinates (0-1)
-- Note: This is a simplified version. Full implementation requires zone-specific mapping
local function GameCoordsToMapCoords(mapId, x, y)
    -- For now, we'll use a simple approximation
    -- In production, you'd need zone-specific coordinate mapping
    -- This would typically use Astrolabe or similar library
    
    -- Get zone info
    local zoneInfo = C_Map.GetMapInfo(mapId)
    if not zoneInfo then
        return 0.5, 0.5 -- Default to center
    end
    
    -- Approximate conversion (this is a placeholder)
    -- Real implementation would use zone boundaries
    local uiX = (x + 17000) / 34000 -- Approximate for Eastern Kingdoms/Kalimdor
    local uiY = (y + 17000) / 34000
    
    -- Clamp to 0-1
    uiX = math.max(0, math.min(1, uiX))
    uiY = math.max(0, math.min(1, uiY))
    
    return uiX, uiY
end

-- Helper: Get HandyNotes coordinate from UI coords
local function GetHandyNotesCoord(uiX, uiY)
    -- HandyNotes uses a coordinate system based on map file
    -- For now, we'll use a simple hash-based approach
    local coord = math.floor(uiX * 10000) * 10000 + math.floor(uiY * 10000)
    return coord
end

-- Update map pin from server data
function MortalUI:UpdateMapPin(mapId, x, y, type, label, data)
    if not mapId or not x or not y then
        return
    end
    
    -- Convert game coords to map UI coords (0-1)
    local uiX, uiY = GameCoordsToMapCoords(mapId, x, y)
    
    -- Get HandyNotes coordinate
    local coord = GetHandyNotesCoord(uiX, uiY)
    
    -- Get pin type string
    local pinType = PIN_TYPE_MAP[type] or "TASK"
    
    -- Initialize map table if needed
    if not MortalPins.points[mapId] then
        MortalPins.points[mapId] = {}
    end
    
    -- Store pin data
    MortalPins.points[mapId][coord] = {
        title = label or "Unknown",
        icon = MortalPins.icons[pinType] or MortalPins.icons["TASK"],
        type = pinType,
        data = data
    }
    
    -- Notify HandyNotes to update
    if HandyNotes and HandyNotes.SendMessage then
        HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MortalPins")
    end
    
    -- Also try to refresh world map if open
    if WorldMapFrame and WorldMapFrame:IsShown() then
        -- Trigger a refresh
        WorldMapFrame:RefreshAllDataProviders()
    end
end

-- Clear all pins for a map
function MortalUI:ClearMapPins(mapId)
    if MortalPins.points[mapId] then
        MortalPins.points[mapId] = {}
        if HandyNotes and HandyNotes.SendMessage then
            HandyNotes:SendMessage("HandyNotes_NotifyUpdate", "MortalPins")
        end
        
        -- Refresh world map if open
        if WorldMapFrame and WorldMapFrame:IsShown() then
            WorldMapFrame:RefreshAllDataProviders()
        end
    end
end

-- HandyNotes API: GetNodes
function MortalPins:GetNodes(mapFile, minimap, level)
    if not mapFile then
        return {}
    end
    
    -- Try to get map ID from map file
    local mapId = nil
    if HandyNotes and HandyNotes.GetMapFiletoMapID then
        mapId = HandyNotes:GetMapFiletoMapID(mapFile)
    end
    
    -- If we can't get map ID from map file, try to extract from file name
    -- or use a fallback method
    if not mapId then
        -- For embedded version, we'll use zone IDs directly
        -- Map files are typically "WorldMap_<ZoneName>" format
        -- We'll need to map these, but for now return all points
        -- In production, you'd want a proper map file to zone ID mapping
        local allPoints = {}
        for zoneId, zonePoints in pairs(self.points) do
            for coord, data in pairs(zonePoints) do
                allPoints[coord] = data
            end
        end
        return allPoints
    end
    
    return self.points[mapId] or {}
end

-- HandyNotes API: OnEnter (tooltip on hover)
function MortalPins:OnEnter(mapFile, coord)
    local mapId = nil
    if HandyNotes and HandyNotes.GetMapFiletoMapID then
        mapId = HandyNotes:GetMapFiletoMapID(mapFile)
    end
    
    -- Find pin data (try by map ID or search all zones)
    local pin = nil
    if mapId and self.points[mapId] and self.points[mapId][coord] then
        pin = self.points[mapId][coord]
    else
        -- Search all zones for this coord
        for zoneId, zonePoints in pairs(self.points) do
            if zonePoints[coord] then
                pin = zonePoints[coord]
                break
            end
        end
    end
    
    if not pin then
        return
    end
    
    GameTooltip:SetOwner(WorldMapButton, "ANCHOR_RIGHT")
    GameTooltip:SetText(pin.title, 1, 1, 1)
    
    if pin.type == "STRONGHOLD" and pin.data then
        -- Show guild info if available
        GameTooltip:AddLine("Controlled by Guild ID: " .. pin.data, 0.7, 0.7, 0.7)
    elseif pin.type == "SIEGE" and pin.data then
        -- Show siege info
        GameTooltip:AddLine("Siege ID: " .. pin.data, 0.7, 0.7, 0.7)
    end
    
    GameTooltip:Show()
end

-- HandyNotes API: OnLeave
function MortalPins:OnLeave(mapFile, coord)
    GameTooltip:Hide()
end

-- Initialize plugin
function MortalPins:OnEnable()
    -- Register with HandyNotes (embedded or external)
    if HandyNotes and HandyNotes.RegisterPluginDB then
        HandyNotes:RegisterPluginDB("MortalPins", self, {
            type = "map",
            GetNodes = function(mapFile, minimap, level)
                return self:GetNodes(mapFile, minimap, level)
            end,
            OnEnter = function(mapFile, coord)
                return self:OnEnter(mapFile, coord)
            end,
            OnLeave = function(mapFile, coord)
                return self:OnLeave(mapFile, coord)
            end
        })
        print("|cff00FF00[MortalUI]: Map Pins module loaded (HandyNotes embedded).|r")
    else
        print("|cffFF0000[MortalUI]: HandyNotes not available. Map pins disabled.|r")
    end
end

-- Handle addon messages from server
local function OnMapPinMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_MAP" then
        return
    end
    
    -- Parse message: PIN:TYPE:ZONEID:X:Y:Z:LABEL:DATA
    local pinType, zoneId, x, y, z, label, data = message:match("^PIN:(%d+):(%d+):([^:]+):([^:]+):([^:]+):([^:]*):(.*)$")
    
    if pinType and zoneId and x and y then
        MortalUI:UpdateMapPin(
            tonumber(zoneId),
            tonumber(x),
            tonumber(y),
            tonumber(pinType),
            label ~= "" and label or nil,
            data ~= "" and data or nil
        )
    end
end

-- Register for addon messages
MortalUI:RegisterEvent("CHAT_MSG_ADDON", OnMapPinMessage)

-- Initialize when HandyNotes is ready (embedded or external)
local function InitializeMortalPins()
    HandyNotes = _G.HandyNotes -- Refresh reference
    if HandyNotes and HandyNotes:IsEnabled() then
        MortalPins:OnEnable()
    end
end

-- Try to initialize immediately
if HandyNotes then
    InitializeMortalPins()
else
    -- Wait for HandyNotes to load (embedded should be loaded by now, but handle edge cases)
    local initFrame = CreateFrame("Frame")
    initFrame:RegisterEvent("ADDON_LOADED")
    initFrame:RegisterEvent("PLAYER_LOGIN")
    initFrame:SetScript("OnEvent", function(self, event, addonName)
        HandyNotes = _G.HandyNotes
        if HandyNotes and HandyNotes:IsEnabled() then
            InitializeMortalPins()
            initFrame:UnregisterAllEvents()
        end
    end)
    
    -- Fallback: try after a delay
    C_Timer.After(1, function()
        HandyNotes = _G.HandyNotes
        if HandyNotes then
            InitializeMortalPins()
        else
            print("|cffFF0000[MortalUI]: HandyNotes failed to load. Map pins disabled.|r")
        end
    end)
end
