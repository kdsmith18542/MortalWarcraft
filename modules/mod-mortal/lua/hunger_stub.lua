-- Mortal Warcraft Overhaul - Hunger Stub
-- Placeholder for hunger system AIO bridge
-- Spec ref: 01-progression.md, 84-mortal-core-stats.md

local HungerDisplay = {}
local frame = nil

function HungerDisplay:Initialize()
    if not frame then
        frame = CreateFrame("Frame", "MortalHungerFrame", UIParent)
        frame:SetSize(150, 20)
        frame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -5)

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture(0.3, 0.3, 0.3, 0.7)
        bg:SetAllPoints()

        local fill = frame:CreateTexture(nil, "ARTWORK")
        fill:SetTexture(0.8, 0.5, 0.1, 0.8)
        fill:SetAllPoints()

        local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        text:SetText("Hunger")
    end
end

function HungerDisplay:Update(hungerValue, maxHunger)
    if not frame then self:Initialize() end
    local fill = frame:GetRegions()
    if fill then
        local pct = hungerValue / math.max(maxHunger, 1)
        fill:SetWidth(frame:GetWidth() * pct)
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
    HungerDisplay:Initialize()
    print("|cff00ff00[Mortal Warcraft] Hunger display loaded|r")
end)
