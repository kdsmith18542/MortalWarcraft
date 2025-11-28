-- ==================================================
-- Project Mortal Warcraft
-- Feature: Mortal Packet Handler (Client-Side)
-- Description: Unified packet system for MortalUI addon communication
-- ==================================================

local MortalPacketHandler = CreateFrame("Frame")
MortalPacketHandler:RegisterEvent("ADDON_LOADED")
MortalPacketHandler:RegisterEvent("CHAT_MSG_ADDON")

-- Packet types
local PACKET_TYPES = {
    ENCUMBRANCE = "ENCUMBRANCE",
    HUNGER = "HUNGER",
    STATS = "STATS",
    MAP_PINS = "MAP_PINS",
    TOOLTIP = "TOOLTIP",
    NAMEPLATE = "NAMEPLATE",
    ZONE_TYPE = "ZONE_TYPE",
    CRIME_STATUS = "CRIME_STATUS",
    NOTIFICATION = "NOTIFICATION"
}

-- Packet handlers
local PacketHandlers = {}

-- Register packet handler
function MortalPacketHandler:RegisterHandler(packetType, handler)
    PacketHandlers[packetType] = handler
end

-- Parse packet data
local function ParsePacket(message)
    if not message or message == "" then
        return nil, nil
    end
    
    -- Format: "PACKET_TYPE:data1:data2:..."
    local parts = {}
    for part in string.gmatch(message, "([^:]+)") do
        table.insert(parts, part)
    end
    
    if #parts < 1 then
        return nil, nil
    end
    
    local packetType = parts[1]
    local data = {}
    for i = 2, #parts do
        table.insert(data, parts[i])
    end
    
    return packetType, data
end

-- Handle incoming addon message
local function OnAddonMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_PACKET" then
        return
    end
    
    local packetType, data = ParsePacket(message)
    if not packetType then
        return
    end
    
    local handler = PacketHandlers[packetType]
    if handler then
        handler(data)
    end
end

MortalPacketHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and select(1, ...) == "MortalUI" then
        -- Initialize packet system
        C_ChatInfo.RegisterAddonMessagePrefix("MORTAL_PACKET")
    elseif event == "CHAT_MSG_ADDON" then
        OnAddonMessage(event, ...)
    end
end)

-- Export
MortalPacketHandler.PACKET_TYPES = PACKET_TYPES
MortalPacketHandler.RegisterHandler = MortalPacketHandler.RegisterHandler

_G.MortalPacketHandler = MortalPacketHandler

