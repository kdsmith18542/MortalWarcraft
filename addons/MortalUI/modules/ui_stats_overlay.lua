-- ==================================================
-- Project Mortal Warcraft
-- Feature: Stats Overlay (Client-Side)
-- Description: Display Derived Level and skill summaries
-- Spec: 15-ui-client.md
-- ==================================================

local StatsOverlay = {}

-- Create stats frame
local StatsFrame = CreateFrame("Frame", "MortalUIStatsOverlay", CharacterFrame)
StatsFrame:SetSize(200, 300)
StatsFrame:SetPoint("TOPLEFT", CharacterFrame, "TOPRIGHT", 10, 0)
StatsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
StatsFrame:SetBackdropColor(0, 0, 0, 0.8)
StatsFrame:Hide()

-- Derived Level text
local DerivedLevelText = StatsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
DerivedLevelText:SetPoint("TOP", StatsFrame, "TOP", 0, -20)
DerivedLevelText:SetText("Derived Level: 0")

-- Attribute caps text
local AttributeCapsText = StatsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
AttributeCapsText:SetPoint("TOP", DerivedLevelText, "BOTTOM", 0, -10)
AttributeCapsText:SetText("Attribute Caps: 0/400")

-- Skills section
local SkillsHeader = StatsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
SkillsHeader:SetPoint("TOP", AttributeCapsText, "BOTTOM", 0, -15)
SkillsHeader:SetText("Skills:")

-- Skills container frame
local SkillsFrame = CreateFrame("Frame", nil, StatsFrame)
SkillsFrame:SetSize(180, 200)
SkillsFrame:SetPoint("TOP", SkillsHeader, "BOTTOM", 0, -5)

-- Update stats (called from server)
function StatsOverlay.UpdateStats(derivedLevel, attributeCaps, skills)
    -- Animate level changes
    local currentLevel = tonumber(DerivedLevelText:GetText():match("Derived Level: (%d+)")) or 0
    if derivedLevel ~= currentLevel then
        StatsOverlay.AnimateLevelChange(DerivedLevelText, currentLevel, derivedLevel)
    else
        DerivedLevelText:SetText(string.format("Derived Level: %d", derivedLevel))
    end

    AttributeCapsText:SetText(string.format("Attribute Caps: %d/400", attributeCaps))

    -- Display skill summaries with animations
    -- Clear existing skill texts
    if SkillsFrame.skillTexts then
        for _, text in ipairs(SkillsFrame.skillTexts) do
            text:Hide()
        end
    end
    SkillsFrame.skillTexts = SkillsFrame.skillTexts or {}

    -- Create/update skill text objects
    for i, skill in ipairs(skills) do
        local skillText = SkillsFrame.skillTexts[i]
        if not skillText then
            skillText = SkillsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            SkillsFrame.skillTexts[i] = skillText
        end

        -- Get skill name from ID (simplified mapping)
        local skillName = GetSkillName(skill.id) or string.format("Skill %d", skill.id)
        skillText:SetText(string.format("%s: %.1f", skillName, skill.value))
        skillText:SetPoint("TOPLEFT", SkillsFrame, "TOPLEFT", 0, -((i-1) * 15))
        skillText:SetAlpha(0)
        skillText:Show()

        -- Fade in animation
        UIFrameFadeIn(skillText, 0.5, 0, 1)
    end

    -- Hide unused skill texts
    for i = #skills + 1, #SkillsFrame.skillTexts do
        UIFrameFadeOut(SkillsFrame.skillTexts[i], 0.3, 1, 0)
    end
end

-- Animate level changes
function StatsOverlay.AnimateLevelChange(textElement, oldLevel, newLevel)
    local change = newLevel - oldLevel
    local color = change > 0 and "00FF00" or "FF0000"
    local symbol = change > 0 and "+" or ""

    textElement:SetText(string.format("Derived Level: %d |cff%s(%s%d)|r", newLevel, color, symbol, change))

    -- Flash animation
    local flashFrame = CreateFrame("Frame")
    flashFrame:SetAllPoints(textElement)
    flashFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    flashFrame:SetBackdropColor(1, 1, 0, 0.3)
    flashFrame:Show()

    UIFrameFadeOut(flashFrame, 1.0, 0.3, 0)

    -- Remove color after animation
    C_Timer.After(2, function()
        textElement:SetText(string.format("Derived Level: %d", newLevel))
    end)
end

-- Show stats frame
function StatsOverlay.Show()
    StatsFrame:Show()
end

-- Hide stats frame
function StatsOverlay.Hide()
    StatsFrame:Hide()
end

-- Hook into character frame
CharacterFrame:HookScript("OnShow", function()
    StatsOverlay.Show()
end)

CharacterFrame:HookScript("OnHide", function()
    StatsOverlay.Hide()
end)

-- Register for custom packets
local function OnStatsPacket(data)
    if #data >= 2 then
        local derivedLevel = tonumber(data[1]) or 0
        local attributeCaps = tonumber(data[2]) or 0
        local skills = {}
        if #data > 2 then
            -- Parse skills (format: skillId:value,skillId:value,...)
            local skillsStr = data[3]
            if skillsStr then
                for skillPair in string.gmatch(skillsStr, "([^,]+)") do
                    local skillId, value = string.match(skillPair, "(%d+):([%d%.]+)")
                    if skillId and value then
                        table.insert(skills, { id = tonumber(skillId), value = tonumber(value) })
                    end
                end
            end
        end
        StatsOverlay.UpdateStats(derivedLevel, attributeCaps, skills)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.STATS, OnStatsPacket)
end

-- Export
MortalUIStatsOverlay = StatsOverlay

