-- Mortal Warcraft Overhaul - Crime Status Display
-- Spec ref: 02-combat.md, 11-pvp-systems.md

local CrimeDisplay = {}
local frame = nil

function CrimeDisplay:Initialize()
    if not frame then
        frame = CreateFrame("Frame", "MortalCrimeFrame", UIParent)
        frame:SetSize(150, 25)
        frame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -51)

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture(0.3, 0.3, 0.3, 0.7)
        bg:SetAllPoints()

        local fill = frame:CreateTexture(nil, "ARTWORK")
        fill:SetColorTexture(1, 0, 0, 0.6)
        fill:SetAllPoints()
        fill:Hide()
        frame.fill = fill

        local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        frame.text = text
    end
end

function CrimeDisplay:Update(notoriety, isCriminal, isOutlaw)
    if not frame then self:Initialize() end
    if isCriminal or isOutlaw then
        frame.text:SetText(isOutlaw and "|cffff0000OUTLAW|r" or "|cffff6600CRIMINAL|r")
        frame.fill:Show()
        frame:SetWidth(150)
    else
        frame.text:SetText("|cff00ff00Lawful|r")
        frame.fill:Hide()
        frame:SetWidth(80)
    end
end

print("|cff00ff00[Mortal Warcraft] Crime display loaded|r")
