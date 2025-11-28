-- ==================================================
-- Mortal UI: Stats Overlay
-- Milestone 1: Progression & Stats Foundation
-- ==================================================
-- Displays derived level, attribute totals, and skill summaries
-- ==================================================

local MortalUI_StatsOverlay = CreateFrame("Frame", "MortalUI_StatsOverlay", UIParent)
MortalUI_StatsOverlay:SetFrameStrata("HIGH")
MortalUI_StatsOverlay:SetWidth(200)
MortalUI_StatsOverlay:SetHeight(100)
MortalUI_StatsOverlay:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 20, -20)
MortalUI_StatsOverlay:SetMovable(true)
MortalUI_StatsOverlay:EnableMouse(true)
MortalUI_StatsOverlay:RegisterForDrag("LeftButton")
MortalUI_StatsOverlay:SetScript("OnDragStart", function(self) self:StartMoving() end)
MortalUI_StatsOverlay:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Background
local bg = MortalUI_StatsOverlay:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.7)
MortalUI_StatsOverlay.bg = bg

-- Title
local title = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", 0, -5)
title:SetText("|cFF00FF00Mortal Stats|r")
MortalUI_StatsOverlay.title = title

-- Derived Level Display
local levelLabel = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
levelLabel:SetPoint("TOPLEFT", 10, -25)
levelLabel:SetText("Level:")

local levelValue = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
levelValue:SetPoint("LEFT", levelLabel, "RIGHT", 5, 0)
levelValue:SetText("1")
MortalUI_StatsOverlay.levelValue = levelValue

-- Attribute Total Display
local attrLabel = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
attrLabel:SetPoint("TOPLEFT", 10, -40)
attrLabel:SetText("Attributes:")

local attrValue = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
attrValue:SetPoint("LEFT", attrLabel, "RIGHT", 5, 0)
attrValue:SetText("0/400")
MortalUI_StatsOverlay.attrValue = attrValue

-- Skill Points Display
local skillLabel = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
skillLabel:SetPoint("TOPLEFT", 10, -55)
skillLabel:SetText("Skill Points:")

local skillValue = MortalUI_StatsOverlay:CreateFontString(nil, "OVERLAY", "GameFontNormal")
skillValue:SetPoint("LEFT", skillLabel, "RIGHT", 5, 0)
skillValue:SetText("0/1200")
MortalUI_StatsOverlay.skillValue = skillValue

-- Update function (called from server via addon message)
local function UpdateStats(level, attrTotal, attrMax, skillTotal, skillMax)
    MortalUI_StatsOverlay.levelValue:SetText(tostring(level))
    
    local attrColor = "FFFFFF"
    if attrTotal >= attrMax then
        attrColor = "FF0000"  -- Red if at cap
    elseif attrTotal >= attrMax * 0.9 then
        attrColor = "FFFF00"  -- Yellow if near cap
    end
    
    MortalUI_StatsOverlay.attrValue:SetText(string.format("|cFF%s%d/%d|r", attrColor, attrTotal, attrMax))
    MortalUI_StatsOverlay.skillValue:SetText(string.format("%d/%d", skillTotal, skillMax))
end

-- Listen for addon messages from server
local function OnAddonMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_STATS" then
        return
    end
    
    -- Parse message: "level:attrTotal:attrMax:skillTotal:skillMax"
    local level, attrTotal, attrMax, skillTotal, skillMax = strsplit(":", message)
    UpdateStats(tonumber(level) or 1, 
                tonumber(attrTotal) or 0, 
                tonumber(attrMax) or 400,
                tonumber(skillTotal) or 0,
                tonumber(skillMax) or 1200)
end

MortalUI_StatsOverlay:RegisterEvent("CHAT_MSG_ADDON")
MortalUI_StatsOverlay:SetScript("OnEvent", OnAddonMessage)

-- Show on login
MortalUI_StatsOverlay:RegisterEvent("PLAYER_LOGIN")
MortalUI_StatsOverlay:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        self:Show()
    end
end)

print("[MortalUI] Stats Overlay loaded")

