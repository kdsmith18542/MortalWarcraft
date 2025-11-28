-- ==================================================
-- Project Mortal Warcraft
-- Feature: Fishing & First Aid UI
-- Description: Client-side UI for fishing and first aid systems
-- Spec: 50-lifeskills-fishing-and-first-aid.md
-- ==================================================

local MortalUIFishing = CreateFrame("Frame", "MortalUIFishingPanel", UIParent)
MortalUIFishing:SetSize(400, 300)
MortalUIFishing:SetPoint("CENTER")
MortalUIFishing:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MortalUIFishing:SetBackdropColor(0, 0, 0, 0.9)
MortalUIFishing:Hide()
MortalUIFishing:SetMovable(true)
MortalUIFishing:EnableMouse(true)
MortalUIFishing:RegisterForDrag("LeftButton")
MortalUIFishing:SetScript("OnDragStart", MortalUIFishing.StartMoving)
MortalUIFishing:SetScript("OnDragStop", MortalUIFishing.StopMovingOrSizing)

-- Title
local title = MortalUIFishing:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("Fishing")

-- Close button
local closeBtn = CreateFrame("Button", nil, MortalUIFishing, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUIFishing:Hide() end)

-- Skill lines
local skillLines = {
    { name = "Fishing: Coastal", skill = 3001 },
    { name = "Fishing: Inland", skill = 3002 },
    { name = "Fishing: Deep Sea", skill = 3003 },
    { name = "Fishing: Planar", skill = 3004 }
}

local skillFrames = {}
for i, skillData in ipairs(skillLines) do
    local frame = CreateFrame("Frame", nil, MortalUIFishing)
    frame:SetSize(350, 40)
    frame:SetPoint("TOPLEFT", 20, -50 - (i - 1) * 45)
    
    local nameText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("LEFT", 0, 0)
    nameText:SetText(skillData.name)
    
    local levelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    levelText:SetPoint("RIGHT", 0, 0)
    levelText:SetText("0")
    
    skillFrames[i] = { frame = frame, nameText = nameText, levelText = levelText, skillId = skillData.skill }
end

function MortalUIFishing.UpdateSkills(skills)
    for i, skillFrame in ipairs(skillFrames) do
        local skill = skills[skillFrame.skillId]
        if skill then
            skillFrame.levelText:SetText(tostring(skill.level or 0))
        end
    end
end

-- Register AIO handlers
if AIO then
    AIO.AddAddon("Mortal", function()
        -- Receive fishing skills
        AIO.Handle("Mortal", "UpdateFishingSkills", function(skills)
            MortalUIFishing.UpdateSkills(skills)
        end)
        
        -- Show fishing panel
        AIO.Handle("Mortal", "ShowFishingPanel", function()
            MortalUIFishing:Show()
        end)
    end)
end

-- First Aid UI
local MortalUIFirstAid = CreateFrame("Frame", "MortalUIFirstAidPanel", UIParent)
MortalUIFirstAid:SetSize(400, 300)
MortalUIFirstAid:SetPoint("CENTER")
MortalUIFirstAid:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MortalUIFirstAid:SetBackdropColor(0, 0, 0, 0.9)
MortalUIFirstAid:Hide()
MortalUIFirstAid:SetMovable(true)
MortalUIFirstAid:EnableMouse(true)
MortalUIFirstAid:RegisterForDrag("LeftButton")
MortalUIFirstAid:SetScript("OnDragStart", MortalUIFirstAid.StartMoving)
MortalUIFirstAid:SetScript("OnDragStop", MortalUIFirstAid.StopMovingOrSizing)

-- Title
local firstAidTitle = MortalUIFirstAid:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
firstAidTitle:SetPoint("TOP", 0, -15)
firstAidTitle:SetText("First Aid")

-- Close button
local firstAidCloseBtn = CreateFrame("Button", nil, MortalUIFirstAid, "UIPanelCloseButton")
firstAidCloseBtn:SetPoint("TOPRIGHT", -5, -5)
firstAidCloseBtn:SetScript("OnClick", function() MortalUIFirstAid:Hide() end)

-- First Aid skill lines
local firstAidSkills = {
    { name = "Field Medicine", skill = 4001 },
    { name = "Trauma Care", skill = 4002 },
    { name = "Toxicology", skill = 4003 }
}

local firstAidFrames = {}
for i, skillData in ipairs(firstAidSkills) do
    local frame = CreateFrame("Frame", nil, MortalUIFirstAid)
    frame:SetSize(350, 40)
    frame:SetPoint("TOPLEFT", 20, -50 - (i - 1) * 45)
    
    local nameText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("LEFT", 0, 0)
    nameText:SetText(skillData.name)
    
    local levelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    levelText:SetPoint("RIGHT", 0, 0)
    levelText:SetText("0")
    
    firstAidFrames[i] = { frame = frame, nameText = nameText, levelText = levelText, skillId = skillData.skill }
end

function MortalUIFirstAid.UpdateSkills(skills)
    for i, skillFrame in ipairs(firstAidFrames) do
        local skill = skills[skillFrame.skillId]
        if skill then
            skillFrame.levelText:SetText(tostring(skill.level or 0))
        end
    end
end

-- Register AIO handlers
if AIO then
    AIO.AddAddon("Mortal", function()
        -- Receive first aid skills
        AIO.Handle("Mortal", "UpdateFirstAidSkills", function(skills)
            MortalUIFirstAid.UpdateSkills(skills)
        end)
        
        -- Show first aid panel
        AIO.Handle("Mortal", "ShowFirstAidPanel", function()
            MortalUIFirstAid:Show()
        end)
    end)
end

-- Export
MortalUIFishingPanel = MortalUIFishing
MortalUIFirstAidPanel = MortalUIFirstAid

