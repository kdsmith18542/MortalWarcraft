-- Mortal Warcraft Overhaul - Encumbrance Stub
-- Spec ref: 01-progression.md, 84-mortal-core-stats.md

local EncumbranceDisplay = {}
local frame = nil

function EncumbranceDisplay:Initialize()
    if not frame then
        frame = CreateFrame("Frame", "MortalEncumbranceFrame", UIParent)
        frame:SetSize(150, 20)
        frame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 0, -28)

        local bg = frame:CreateTexture(nil, "BACKGROUND")
        bg:SetTexture(0.3, 0.3, 0.3, 0.7)
        bg:SetAllPoints()

        local fill = frame:CreateTexture(nil, "ARTWORK")
        fill:SetTexture(0.1, 0.5, 0.8, 0.8)
        fill:SetAllPoints()

        local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetPoint("CENTER")
        text:SetText("Encumbrance")
    end
end

function EncumbranceDisplay:Update(weight, maxWeight)
    if not frame then self:Initialize() end
    local fill = frame:GetRegions()
    if fill then
        local pct = weight / math.max(maxWeight, 1)
        fill:SetWidth(frame:GetWidth() * pct)
    end
end

function EncumbranceDisplay:GetWeight()
    local total = 0
    for i = 0, 4 do
        local bag = GetContainerNumSlots(i)
        if bag > 0 then
            for j = 1, bag do
                local link = GetContainerItemLink(i, j)
                if link then
                    local _, _, _, _, _, _, count = strfind(link, "|c%x+|Hitem:(%d+):.*|h%[.*%]|h|r")
                    if count then total = total + (tonumber(count) or 1) end
                end
            end
        end
    end
    return total
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:SetScript("OnEvent", function()
    if eventFrame:GetScript and event == "PLAYER_ENTERING_WORLD" then
        EncumbranceDisplay:Initialize()
    end
    EncumbranceDisplay:Update(EncumbranceDisplay:GetWeight(), 100)
end)
print("|cff00ff00[Mortal Warcraft] Encumbrance display loaded|r")
