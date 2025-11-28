-- ==================================================
-- Project Mortal Warcraft
-- Feature: Tooltip Injector (Client-Side)
-- Description: Inject custom data into item tooltips
-- Spec: 15-ui-client.md
-- ==================================================

local TooltipInjector = {}

-- Hook into tooltip events
local TooltipFrame = CreateFrame("Frame")
TooltipFrame:RegisterEvent("ADDON_LOADED")

TooltipFrame:SetScript("OnEvent", function(self, event)
    if event == "ADDON_LOADED" then
        -- Hook into GameTooltip
        GameTooltip:HookScript("OnTooltipSetItem", function(self)
            TooltipInjector.OnItemTooltip(self)
        end)
    end
end)

-- Inject item data into tooltip
function TooltipInjector.OnItemTooltip(tooltip)
    local name, link = tooltip:GetItem()
    if not name or not link then
        return
    end
    
    -- Get item ID
    local itemId = tonumber(link:match("item:(%d+)"))
    if not itemId then
        return
    end
    
    -- Query item data from server via custom packet
    -- Request item data (will be sent via packet)
    if MortalPacketHandler then
        C_ChatInfo.SendAddonMessage("MORTAL_PACKET", "QUERY_TOOLTIP:" .. itemId, "WHISPER", UnitName("player"))
    end
    
    -- Cache for item data
    local itemDataCache = TooltipInjector.itemDataCache or {}
    local cachedData = itemDataCache[itemId]
    
    if cachedData then
            -- Inject lines
        if cachedData.weight then
            tooltip:AddLine(string.format("Weight: %.1f", cachedData.weight), 1, 1, 1)
        end
        if cachedData.material then
            tooltip:AddLine(string.format("Material: %s", cachedData.material), 0.8, 0.8, 0.8)
        end
        if cachedData.skillReq then
            tooltip:AddLine(string.format("Requires: %s (%d)", cachedData.skillName or "Skill", cachedData.skillReq), 1, 0.5, 0)
        end
        if cachedData.dropsOnDeath then
            tooltip:AddLine("|cffFF0000Drops on death: Yes|r", 1, 0, 0)
        end
    end
end

-- Handle tooltip data packet
local function OnTooltipPacket(data)
    if #data >= 2 then
        local itemId = tonumber(data[1])
        if itemId then
            local itemDataCache = TooltipInjector.itemDataCache or {}
            itemDataCache[itemId] = {
                weight = tonumber(data[2]),
                material = data[3],
                skillId = tonumber(data[4]),
                skillName = data[5],
                skillReq = tonumber(data[6]),
                dropsOnDeath = data[7] == "1"
            }
            TooltipInjector.itemDataCache = itemDataCache
        end
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.TOOLTIP, OnTooltipPacket)
end

-- Export
MortalUITooltipInjector = TooltipInjector

