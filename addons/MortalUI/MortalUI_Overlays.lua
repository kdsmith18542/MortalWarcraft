-- ==================================================
-- Mortal UI: Overlays Module
-- Description: Handles UI overlays (Weight, Hunger, etc.)
-- Version: 21.0
-- ==================================================

local MortalUI = LibStub("AceAddon-3.0"):GetAddon("MortalUI")

-- Initialize Bagnon integration
function MortalUI:InitBags()
    if not Bagnon then return end
    
    hooksecurefunc(Bagnon.Frame, "New", function(self, id)
        if id == "inventory" then
            local weightFrame = CreateFrame("Frame", nil, self)
            weightFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -40, 10)
            weightFrame:SetSize(100, 20)
            
            local text = weightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            text:SetPoint("CENTER")
            self.WeightText = text
            
            MortalUI:UpdateBagDisplay()
        end
    end)
end

-- Update bag weight display
function MortalUI:UpdateBagDisplay()
    local frame = Bagnon and Bagnon.Frames and Bagnon.Frames["inventory"]
    if frame and frame.WeightText then
        local w = self.State.CurrentWeight or 0
        local max = self.State.MaxWeight or 100
        
        local color = "|cff00FF00" -- Green
        if w > max then 
            color = "|cffFF0000" -- Red
        elseif w > (max * 0.8) then 
            color = "|cffFFFF00" -- Yellow
        end
        
        -- Update to "lbs"
        frame.WeightText:SetText(string.format("%sWeight: %.1f / %.1f lbs|r", color, w, max))
    end
end

-- Create hunger bar overlay (if not using AIO)
function MortalUI:CreateHungerOverlay()
    -- Hunger bar is primarily handled by ui_survival_feedback.lua via AIO
    -- This is a fallback if AIO is not available
    if ReputationWatchBar then
        -- Repurpose reputation bar for hunger display
        if not self.HungerText then
            self.HungerText = ReputationWatchBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            self.HungerText:SetPoint("CENTER", ReputationWatchBar, "CENTER", 0, 0)
            self.HungerText:SetTextColor(1, 1, 1, 1)
        end
    end
end

-- Update hunger display
function MortalUI:UpdateHungerDisplay()
    local hunger = self.State.Hunger or 100
    local maxHunger = self.State.MaxHunger or 100
    
    if maxHunger == 0 then
        maxHunger = 100
    end
    
    local ratio = hunger / maxHunger
    local percentage = math.floor(ratio * 100)
    
    -- Color based on hunger
    local r, g, b = 0.5, 1, 0.5 -- Light Green (Well Fed)
    if ratio < 0.2 then
        r, g, b = 0.8, 0, 0 -- Dark Red (Starving)
    elseif ratio < 0.4 then
        r, g, b = 1, 0.5, 0 -- Orange (Very Hungry)
    elseif ratio < 0.6 then
        r, g, b = 1, 0.7, 0.3 -- Light Orange (Hungry)
    elseif ratio < 0.8 then
        r, g, b = 0.8, 0.6, 0.3 -- Brown (Satisfied)
    end
    
    -- Update reputation bar if available
    if ReputationWatchBar then
        ReputationWatchBar:SetMinMaxValues(0, maxHunger)
        ReputationWatchBar:SetValue(hunger)
        ReputationWatchBar:SetStatusBarColor(r, g, b, 1)
        
        if self.HungerText then
            self.HungerText:SetTextColor(r, g, b, 1)
            self.HungerText:SetText(string.format("Satiety: %d%%", percentage))
        end
    end
    
    -- Also update XP bar if reputation bar not available
    if MainMenuExpBar and not ReputationWatchBar then
        MainMenuExpBar:SetMinMaxValues(0, maxHunger)
        MainMenuExpBar:SetValue(hunger)
        MainMenuExpBar:SetStatusBarColor(r, g, b, 1)
    end
end

-- Initialize Bagnon integration on login
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function() 
    MortalUI:InitBags()
end)

-- Update weight when items change
local function OnInventoryChange()
    -- Weight will be updated via server message
    -- This is just a trigger to refresh display
    MortalUI:UpdateBagDisplay()
end

-- Register for inventory events
local frame = CreateFrame("Frame")
frame:RegisterEvent("BAG_UPDATE")
frame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
frame:RegisterEvent("BAG_UPDATE_DELAYED")
frame:SetScript("OnEvent", OnInventoryChange)

