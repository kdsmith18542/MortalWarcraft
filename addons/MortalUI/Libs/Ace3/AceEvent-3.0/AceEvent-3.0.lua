-- AceEvent-3.0: Event handling framework
-- Simplified version for MortalUI

local AceEvent, minor = LibStub:NewLibrary("AceEvent-3.0", 3)
if not AceEvent then return end

local eventFrame = CreateFrame("Frame")
local eventHandlers = {}

function AceEvent:RegisterEvent(object, event, method)
    if not eventHandlers[event] then
        eventHandlers[event] = {}
        eventFrame:RegisterEvent(event)
    end
    table.insert(eventHandlers[event], {
        object = object,
        method = method or event
    })
end

function AceEvent:UnregisterEvent(object, event)
    if eventHandlers[event] then
        for i, handler in ipairs(eventHandlers[event]) do
            if handler.object == object then
                table.remove(eventHandlers[event], i)
                break
            end
        end
    end
end

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if eventHandlers[event] then
        for _, handler in ipairs(eventHandlers[event]) do
            local method = handler.method
            if type(method) == "string" then
                method = handler.object[method]
            end
            if method then
                method(handler.object, event, ...)
            end
        end
    end
end)

