-- Mortal Warcraft Overhaul - Stats Overlay
-- Spec ref: 01-progression.md
-- Displays derived level and attribute totals

local StatsOverlay = {}
local frame = nil

function StatsOverlay:Initialize()
    if not frame then
        frame = CreateFrame("Frame", "MortalStatsFrame", UIParent)
        frame:SetSize(200, 80)
        frame:SetPoint("TOPRIGHT", -10, -200)

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture(0, 0, 0, 0.6)
        bg:SetAllPoints()

        local levelText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        levelText:SetPoint("TOPLEFT", 5, -5)
        frame.levelText = levelText

        local skillText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        skillText:SetPoint("TOPLEFT", 5, -28)
        frame.skillText = skillText

        local attrText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        attrText:SetPoint("TOPLEFT", 5, -48)
        frame.attrText = attrText
    end
end

function StatsOverlay:Update(derivedLevel, totalSkillPoints, strength, agility, stamina, intellect, spirit)
    if not frame then self:Initialize() end
    frame.levelText:SetText(("|cffffcc00Level|r %d"):format(derivedLevel or 1))
    frame.skillText:SetText(("|cff00ff00Skills|r: %d / 1200"):format(totalSkillPoints or 0))
    frame.attrText:SetText(("Str %d | Agi %d | Sta %d | Int %d | Spi %d"):format(
        strength or 0, agility or 0, stamina or 0, intellect or 0, spirit or 0))
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_LEVEL_UP")
eventFrame:RegisterEvent("UNIT_SKILL")
eventFrame:SetScript("OnEvent", function()
    if event == "PLAYER_ENTERING_WORLD" then
        StatsOverlay:Initialize()
    end
    StatsOverlay:Update(UnitLevel("player"), UnitLevel("player") * 48, 0, 0, 0, 0, 0)
end)

print("|cff00ff00[Mortal Warcraft] Stats overlay loaded|r")
