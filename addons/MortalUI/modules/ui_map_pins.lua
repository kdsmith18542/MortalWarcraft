-- ==================================================
-- Project Mortal Warcraft
-- Feature: Map Pins (Client-Side)
-- Description: Custom map overlays for territory, caravans, etc.
-- Spec: 15-ui-client.md
-- ==================================================

-- Requires HandyNotes addon
if not HandyNotes then
    return
end

local MapPins = {}

-- Helper functions for HandyNotes integration
function MapPins.GetPluginHandler(pinType)
    return {
        iter = function(t, prev)
            local db = HandyNotes.plugins[pinType].db
            if not db then return end
            return next(db, prev)
        end,
        icon = function(coord, v)
            return v.icon
        end,
        GetNodes2 = function(uiMapID, minimap)
            local db = HandyNotes.plugins[pinType].db
            if not db or not db[uiMapID] then return end
            return db[uiMapID]
        end
    }
end

function MapPins.GetPinIcon(pinType)
    local icons = {
        guild_sovereignty = "Interface\\Icons\\INV_Banner_01",
        stronghold_vulnerability = "Interface\\Icons\\Ability_Warrior_ShieldWall",
        tcp = "Interface\\Icons\\INV_Misc_Map_01",
        world_boss = "Interface\\Icons\\Achievement_Boss_Illidan",
        kill_hotspot = "Interface\\Icons\\Ability_DualWield",
        caravan_route = "Interface\\Icons\\INV_Misc_Map_01",
        caravan_patrol = "Interface\\Icons\\Ability_Rogue_Sprint",
        resource_bloom = "Interface\\Icons\\INV_Misc_Gem_01",
        hellgate = "Interface\\Icons\\Spell_Shadow_SoulLeech_1",
        outlaw_hotspot = "Interface\\Icons\\Ability_Rogue_Disguise"
    }
    return icons[pinType] or "Interface\\Icons\\INV_Misc_Map_01"
end

function MapPins.GetPinTitle(pinType, data)
    local titles = {
        guild_sovereignty = "Guild Territory",
        stronghold_vulnerability = "Vulnerable Stronghold",
        tcp = "Control Point",
        world_boss = "World Boss",
        kill_hotspot = "Kill Hotspot",
        caravan_route = "Caravan Route",
        caravan_patrol = "Caravan Patrol",
        resource_bloom = "Resource Bloom",
        hellgate = "Hellgate",
        outlaw_hotspot = "Outlaw Activity"
    }
    return titles[pinType] or pinType
end

function MapPins.GetPinDescription(pinType, data)
    if data and data ~= "" then
        return data
    end
    return "MortalUI map pin"
end

-- Register map pin types
local PIN_TYPES = {
    GUILD_SOVEREIGNTY = "guild_sovereignty",
    STRONGHOLD_VULNERABILITY = "stronghold_vulnerability",
    TERRITORY_CONTROL_POINT = "tcp",
    ACTIVE_WORLD_BOSS = "world_boss",
    KILL_HOTSPOT = "kill_hotspot",
    CARAVAN_ROUTE = "caravan_route",
    CARAVAN_PATROL = "caravan_patrol",
    RESOURCE_BLOOM = "resource_bloom",
    HELLGATE_ENTRANCE = "hellgate",
    OUTLAW_HOTSPOT = "outlaw_hotspot"
}

-- Add map pin
function MapPins.AddPin(pinType, mapId, x, y, data)
    if not HandyNotes then
        return
    end

    -- Register plugin database if not already registered
    if not HandyNotes.plugins[pinType] then
        HandyNotes:RegisterPluginDB(pinType, MapPins.GetPluginHandler(pinType), {
            type = "Database",
            category = "MortalUI",
            description = string.format("MortalUI %s pins", pinType),
            default = true
        })
    end

    -- Add pin to database
    local db = HandyNotes.plugins[pinType].db
    if not db then return end

    db[mapId] = db[mapId] or {}
    db[mapId][string.format("%.3f,%.3f", x, y)] = {
        icon = MapPins.GetPinIcon(pinType),
        title = MapPins.GetPinTitle(pinType, data),
        desc = MapPins.GetPinDescription(pinType, data)
    }

    -- Refresh HandyNotes display
    HandyNotes:SendMessage("HandyNotes_NotifyUpdate", pinType)
end

-- Remove map pin
function MapPins.RemovePin(pinType, mapId, x, y)
    if not HandyNotes or not HandyNotes.plugins[pinType] then
        return
    end

    local db = HandyNotes.plugins[pinType].db
    if not db or not db[mapId] then return end

    local coord = string.format("%.3f,%.3f", x, y)
    if db[mapId][coord] then
        db[mapId][coord] = nil
        -- Refresh HandyNotes display
        HandyNotes:SendMessage("HandyNotes_NotifyUpdate", pinType)
    end
end

-- Update map pins from server data
function MapPins.UpdateFromServer(data)
    -- Data format: { type, mapId, x, y, data }
    if not data or #data < 4 then return end

    local pinType = data[1]
    local mapId = tonumber(data[2])
    local x = tonumber(data[3])
    local y = tonumber(data[4])
    local pinData = data[5] or ""

    if pinType and mapId and x and y then
        MapPins.AddPin(pinType, mapId, x, y, pinData)
    end
end

-- Register for custom packets
local function OnMapPinsPacket(data)
    if #data >= 1 then
        -- Parse pin data (format: type:mapId:x:y:data)
        local pinsStr = data[1]
        if pinsStr then
            for pinData in string.gmatch(pinsStr, "([^|]+)") do
                local parts = {}
                for part in string.gmatch(pinData, "([^:]+)") do
                    table.insert(parts, part)
                end
                if #parts >= 4 then
                    local pinType = parts[1]
                    local mapId = tonumber(parts[2])
                    local x = tonumber(parts[3])
                    local y = tonumber(parts[4])
                    local pinData = parts[5] or ""
                    MapPins.AddPin(pinType, mapId, x, y, pinData)
                end
            end
        end
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.MAP_PINS, OnMapPinsPacket)
end

-- Fog-of-War System for World Map
-- Per spec 15-ui-client.md section 13.3
local function ApplyFogOfWar(zoneType)
    -- Red zones: POIs hidden until discovered
    -- Yellow zones: POIs visible but not auto-exposed
    -- Green zones: Full visibility
    if zoneType == "red" then
        -- Hide all POIs until discovered
        print("[MortalUI] Fog-of-War: Red zone - POIs hidden until discovered")
    elseif zoneType == "yellow" then
        -- Conditional POI visibility
        print("[MortalUI] Fog-of-War: Yellow zone - Conditional POI visibility")
    else
        -- Full visibility
        print("[MortalUI] Fog-of-War: Green zone - Full visibility")
    end
end

-- POI Visibility Rules
-- Per spec 15-ui-client.md section 13.3
local POI_VISIBILITY = {
    NEVER_AUTO_EXPOSED = {
        "secret_dungeons",
        "black_market",
        "hidden_shrines"
    },
    CONDITIONALLY_EXPOSED = {
        "task_boards",
        "regional_banks",
        "strongholds"
    },
    ALWAYS_EXPOSED = {
        "capital_cities",
        "major_hubs",
        "shrines"
    }
}

-- Export
MortalUIMapPins = MapPins
MortalUIMapPins.ApplyFogOfWar = ApplyFogOfWar
MortalUIMapPins.POI_VISIBILITY = POI_VISIBILITY

