-- ==================================================
-- Project Mortal Warcraft
-- Feature: Season Challenge UI
-- Description: Client-side UI for season challenges and progression
-- Spec: 52-season-of-the-frontier.md
-- ==================================================

local MortalUISeason = CreateFrame("Frame", "MortalUISeasonPanel", UIParent)
MortalUISeason:SetSize(500, 600)
MortalUISeason:SetPoint("CENTER")
MortalUISeason:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MortalUISeason:SetBackdropColor(0, 0, 0, 0.9)
MortalUISeason:Hide()
MortalUISeason:SetMovable(true)
MortalUISeason:EnableMouse(true)
MortalUISeason:RegisterForDrag("LeftButton")
MortalUISeason:SetScript("OnDragStart", MortalUISeason.StartMoving)
MortalUISeason:SetScript("OnDragStop", MortalUISeason.StopMovingOrSizing)

-- Title
local title = MortalUISeason:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("Season Challenges")

-- Close button
local closeBtn = CreateFrame("Button", nil, MortalUISeason, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUISeason:Hide() end)

-- Season info
local seasonInfo = MortalUISeason:CreateFontString(nil, "OVERLAY", "GameFontNormal")
seasonInfo:SetPoint("TOP", 0, -40)
seasonInfo:SetText("Season 1: The Frontier")

-- Progress bar
local progressBar = CreateFrame("StatusBar", nil, MortalUISeason)
progressBar:SetSize(450, 20)
progressBar:SetPoint("TOP", 0, -60)
progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
progressBar:SetStatusBarColor(0, 1, 0, 1)
progressBar:SetMinMaxValues(0, 100)
progressBar:SetValue(0)

local progressText = progressBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
progressText:SetPoint("CENTER")
progressText:SetText("0 / 100 XP")

-- Challenge tabs
local dailyTab = CreateFrame("Button", nil, MortalUISeason, "UIPanelButtonTemplate")
dailyTab:SetSize(100, 30)
dailyTab:SetPoint("TOPLEFT", 20, -90)
dailyTab:SetText("Daily")
dailyTab:SetScript("OnClick", function()
    MortalUISeason.ShowChallenges("DAILY")
end)

local weeklyTab = CreateFrame("Button", nil, MortalUISeason, "UIPanelButtonTemplate")
weeklyTab:SetSize(100, 30)
weeklyTab:SetPoint("LEFT", dailyTab, "RIGHT", 10, 0)
weeklyTab:SetText("Weekly")
weeklyTab:SetScript("OnClick", function()
    MortalUISeason.ShowChallenges("WEEKLY")
end)

local seasonalTab = CreateFrame("Button", nil, MortalUISeason, "UIPanelButtonTemplate")
seasonalTab:SetSize(100, 30)
seasonalTab:SetPoint("LEFT", weeklyTab, "RIGHT", 10, 0)
seasonalTab:SetText("Seasonal")
seasonalTab:SetScript("OnClick", function()
    MortalUISeason.ShowChallenges("SEASONAL")
end)

-- Challenge list
local challengeScrollFrame = CreateFrame("ScrollFrame", "MortalUISeasonScroll", MortalUISeason, "UIPanelScrollFrameTemplate")
challengeScrollFrame:SetPoint("TOPLEFT", 20, -130)
challengeScrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)

local challengeContent = CreateFrame("Frame", nil, challengeScrollFrame)
challengeContent:SetSize(450, 400)
challengeScrollFrame:SetScrollChild(challengeContent)

local challengeButtons = {}
local currentChallengeType = "DAILY"

local function CreateChallengeButton(parent, index, challengeData)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(430, 80)
    btn:SetPoint("TOPLEFT", 0, -(index - 1) * 85)
    
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SilverButton",
        edgeFile = "Interface\\Buttons\\UI-SilverButton",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    
    -- Completed state
    if challengeData.completed then
        btn:SetBackdropColor(0, 0.5, 0, 0.8)
    else
        btn:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
    end
    
    -- Challenge name
    local nameText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("LEFT", 10, 10)
    nameText:SetText(challengeData.name or "Unknown")
    
    -- Description
    local descText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    descText:SetPoint("LEFT", 10, -10)
    descText:SetText(challengeData.description or "")
    
    -- Progress
    local progressText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    progressText:SetPoint("RIGHT", -10, 0)
    progressText:SetText(string.format("%d / %d", challengeData.progress or 0, challengeData.target or 0))
    
    -- Reward
    local rewardText = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    rewardText:SetPoint("BOTTOMLEFT", 10, -5)
    rewardText:SetText(string.format("Reward: %d XP", challengeData.xp_reward or 0))
    
    challengeButtons[index] = btn
    return btn
end

function MortalUISeason.ShowChallenges(challengeType)
    currentChallengeType = challengeType
    
    -- Request challenges from server
    if AIO then
        AIO.Handle("Mortal", "RequestChallenges", challengeType)
    end
end

function MortalUISeason.UpdateChallenges(challenges)
    -- Clear existing buttons
    for i, btn in ipairs(challengeButtons) do
        btn:Hide()
    end
    
    -- Create buttons for each challenge
    for i, challenge in ipairs(challenges or {}) do
        if not challengeButtons[i] then
            CreateChallengeButton(challengeContent, i, challenge)
        else
            challengeButtons[i]:Show()
        end
    end
    
    challengeContent:SetHeight(math.max(400, #challenges * 85))
end

function MortalUISeason.UpdateProgress(currentXP, maxXP, rank)
    progressBar:SetMinMaxValues(0, maxXP)
    progressBar:SetValue(currentXP)
    progressText:SetText(string.format("%d / %d XP (Rank %d)", currentXP, maxXP, rank or 1))
end

-- Register AIO handlers
if AIO then
    AIO.AddAddon("Mortal", function()
        -- Receive challenges
        AIO.Handle("Mortal", "UpdateChallenges", function(challenges)
            MortalUISeason.UpdateChallenges(challenges)
        end)
        
        -- Update progress
        AIO.Handle("Mortal", "UpdateSeasonProgress", function(currentXP, maxXP, rank)
            MortalUISeason.UpdateProgress(currentXP, maxXP, rank)
        end)
        
        -- Show season panel
        AIO.Handle("Mortal", "ShowSeasonPanel", function()
            MortalUISeason:Show()
            MortalUISeason.ShowChallenges("DAILY")
        end)
    end)
end

-- Export
MortalUISeasonPanel = MortalUISeason

