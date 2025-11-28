-- ==================================================
-- Mortal UI: Encumbrance Display
-- Milestone 1: Progression & Stats Foundation
-- ==================================================
-- Displays encumbrance/weight above player frame
-- ==================================================

local MortalUI_EncumbranceDisplay = CreateFrame("Frame", "MortalUI_EncumbranceDisplay", UIParent)
MortalUI_EncumbranceDisplay:SetFrameStrata("MEDIUM")
MortalUI_EncumbranceDisplay:SetWidth(120)
MortalUI_EncumbranceDisplay:SetHeight(12)
MortalUI_EncumbranceDisplay:SetPoint("BOTTOM", MortalUI_HungerDisplay, "TOP", 0, 5)
MortalUI_EncumbranceDisplay:Hide()

-- Background bar
local bg = MortalUI_EncumbranceDisplay:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0.2, 0.2, 0.2, 0.8)
MortalUI_EncumbranceDisplay.bg = bg

-- Encumbrance bar
local bar = CreateFrame("StatusBar", nil, MortalUI_EncumbranceDisplay)
bar:SetAllPoints()
bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
bar:SetMinMaxValues(0, 100)
bar:SetValue(0)
MortalUI_EncumbranceDisplay.bar = bar

-- Set bar color based on encumbrance level
local function UpdateBarColor(ratio)
    ratio = ratio or 0
    local percent = ratio * 100
    
    if percent <= 25 then
        bar:SetStatusBarColor(0, 1, 0, 1)  -- Green (Light)
    elseif percent <= 50 then
        bar:SetStatusBarColor(1, 1, 0, 1)  -- Yellow (Medium)
    elseif percent <= 75 then
        bar:SetStatusBarColor(1, 0.5, 0, 1)  -- Orange (Heavy)
    else
        bar:SetStatusBarColor(1, 0, 0, 1)  -- Red (Overloaded/Overburdened)
    end
end

-- Label
local label = MortalUI_EncumbranceDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
label:SetPoint("BOTTOM", MortalUI_EncumbranceDisplay, "TOP", 0, 2)
label:SetText("Weight")
MortalUI_EncumbranceDisplay.label = label

-- Tier text
local tierText = MortalUI_EncumbranceDisplay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
tierText:SetPoint("LEFT", MortalUI_EncumbranceDisplay, "RIGHT", 5, 0)
tierText:SetText("")
MortalUI_EncumbranceDisplay.tierText = tierText

-- Update function
local function UpdateEncumbrance(ratio, tier)
    ratio = math.max(0, math.min(1, ratio or 0))
    local percent = ratio * 100
    
    bar:SetValue(percent)
    UpdateBarColor(ratio)
    
    -- Update tier text
    tier = tier or "Light"
    local tierColor = "FFFFFF"
    if tier == "Overloaded" or tier == "Overburdened" then
        tierColor = "FF0000"  -- Red
    elseif tier == "Heavy" then
        tierColor = "FF8800"  -- Orange
    elseif tier == "Medium" then
        tierColor = "FFFF00"  -- Yellow
    else
        tierColor = "00FF00"  -- Green
    end
    
    tierText:SetText(string.format("|cFF%s%s|r (%.0f%%)", tierColor, tier, percent))
    
    -- Flash red if overloaded
    if ratio > 0.75 then
        -- Create flash effect
        local flash = MortalUI_EncumbranceDisplay:CreateTexture(nil, "OVERLAY")
        flash:SetAllPoints()
        flash:SetColorTexture(1, 0, 0, 0.3)
        flash:SetBlendMode("ADD")
        
        local fadeOut = flash:CreateAnimationGroup()
        local alpha = fadeOut:CreateAnimation("Alpha")
        alpha:SetFromAlpha(0.3)
        alpha:SetToAlpha(0)
        alpha:SetDuration(0.5)
        fadeOut:SetScript("OnFinished", function() flash:Hide() end)
        fadeOut:Play()
    end
    
    MortalUI_EncumbranceDisplay:Show()
end

-- Listen for addon messages from server
local function OnAddonMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_ENCUMBRANCE" then
        return
    end
    
    -- Parse message: "ratio:tier"
    local ratioStr, tier = strsplit(":", message)
    local ratio = tonumber(ratioStr) or 0
    tier = tier or "Light"
    
    UpdateEncumbrance(ratio, tier)
end

MortalUI_EncumbranceDisplay:RegisterEvent("CHAT_MSG_ADDON")
MortalUI_EncumbranceDisplay:SetScript("OnEvent", OnAddonMessage)

-- Show on login
MortalUI_EncumbranceDisplay:RegisterEvent("PLAYER_LOGIN")
MortalUI_EncumbranceDisplay:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        self:Show()
        UpdateEncumbrance(0, "Light")  -- Default to empty
    end
end)

print("[MortalUI] Encumbrance Display loaded")

