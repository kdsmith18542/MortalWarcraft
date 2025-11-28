-- AceConsole-3.0: Console command framework
-- Simplified version for MortalUI

local AceConsole, minor = LibStub:NewLibrary("AceConsole-3.0", 3)
if not AceConsole then return end

local commands = {}

function AceConsole:RegisterChatCommand(command, method, handler)
    if type(handler) == "string" then
        handler = _G[handler]
    end
    if type(handler) == "function" then
        commands[command] = handler
        _G["SLASH_" .. command:upper() .. "1"] = "/" .. command
        _G["SLASH_" .. command:upper() .. "2"] = "/" .. command:sub(1, 2)
        SlashCmdList[command:upper()] = function(msg)
            handler(msg)
        end
    end
end

