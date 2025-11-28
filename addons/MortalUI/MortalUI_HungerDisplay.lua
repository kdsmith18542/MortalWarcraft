-- ==================================================
-- Mortal UI: Hunger Display
-- Milestone 1: Progression & Stats Foundation
-- ==================================================
-- Displays hunger bar above player frame
-- ==================================================

local MortalUI_HungerDisplay = CreateFrame("Frame", "MortalUI_HungerDisplay", UIParent)
MortalUI_HungerDisplay:SetFrameStrata("MEDIUM")
MortalUI_HungerDisplay:SetWidth(120)
MortalUI_HungerDisplay:SetHeight(12)
MortalUI_HungerDisplay:SetPoint("BOTTOM", PlayerFrame, "TOP", 0, 30)
MortalUI_HungerDisplay:Hide()

-- Background bar
local bg = MortalUI_HungerDisplay:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0.2, 0.2, 0.2, 0.8)
MortalUI_HungerDisplay.bg = bg

-- Hunger bar
local bar = CreateFrame("StatusBar", nil, MortalUI_HungerDisplay)
bar:SetAllPoints()
bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
bar:SetMinMaxValues(0, 100)
bar:SetValue(100)
MortalUI_HungerDisplay.bar = bar

-- Set bar color based on hunger level
local function UpdateBarColor(hunger)
    if hunger >= 80 then
        bar:SetStatusBarColor(0, 1, 0, 1)  -- Green
    elseif hunger >= 50 then
        bar:SetStatusBarColor(1, 1, 0, 1)  -- Yellow
    elseif hunger >= 20 then
        bar:SetStatusBarColor(1, 0.5, 0, 1)  -- Orange
    else
        bar:SetStatusBarColor(1, 0, 0, 1)  -- Red (critical)
    end
end

-- Label
local label = MortalUI_HungerDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
label:SetPoint("BOTTOM", MortalUI_HungerDisplay, "TOP", 0, 2)
label:SetText("Hunger")
MortalUI_HungerDisplay.label = label

-- Update function
local function UpdateHunger(hunger)
    hunger = math.max(0, math.min(100, hunger or 100))
    bar:SetValue(hunger)
    UpdateBarColor(hunger)
    
    if hunger > 0 then
        MortalUI_HungerDisplay:Show()
    end
end

-- Listen for addon messages from server
local function OnAddonMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_HUNGER" then
        return
    end
    
    local hunger = tonumber(message) or 100
    UpdateHunger(hunger)
end

MortalUI_HungerDisplay:RegisterEvent("CHAT_MSG_ADDON")
MortalUI_HungerDisplay:SetScript("OnEvent", OnAddonMessage)

-- Show on login
MortalUI_HungerDisplay:RegisterEvent("PLAYER_LOGIN")
MortalUI_HungerDisplay:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        self:Show()
        UpdateHunger(100)  -- Default to full
    end
end)

print("[MortalUI] Hunger Display loaded")

