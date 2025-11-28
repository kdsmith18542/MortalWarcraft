-- AceDB-3.0: Database framework for saved variables
-- Simplified version for MortalUI

local AceDB, minor = LibStub:NewLibrary("AceDB-3.0", 3)
if not AceDB then return end

function AceDB:New(db, defaults, defaultKey)
    local obj = {}
    obj.db = db or {}
    obj.defaults = defaults or {}
    obj.defaultKey = defaultKey or "default"
    
    function obj:RegisterDefaults(defaults)
        self.defaults = defaults
    end
    
    function obj:ResetProfile()
        -- Reset to defaults
        for k, v in pairs(self.defaults) do
            self.db[k] = v
        end
    end
    
    return obj
end

