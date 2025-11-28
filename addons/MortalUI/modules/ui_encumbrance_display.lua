-- ==================================================
-- Project Mortal Warcraft
-- Feature: Encumbrance Display (Client-Side)
-- Description: Display total weight and encumbrance status
-- Spec: 15-ui-client.md
-- ==================================================

local EncumbranceFrame = CreateFrame("Frame", "MortalUIEncumbrance", UIParent)
EncumbranceFrame:SetSize(150, 30)
EncumbranceFrame:SetPoint("TOP", UIParent, "TOP", 0, -50)
EncumbranceFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
EncumbranceFrame:SetBackdropColor(0, 0, 0, 0.8)

-- Weight text
local WeightText = EncumbranceFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
WeightText:SetPoint("CENTER", EncumbranceFrame, "CENTER", 0, 0)
WeightText:SetText("Weight: 0 / 100")

-- Update encumbrance (called from server)
local function UpdateEncumbrance(currentWeight, maxWeight, isOverloaded)
    local percentage = (currentWeight / maxWeight) * 100
    local color = "FFFFFF"
    
    if isOverloaded then
        color = "FF0000"
        -- Flash red
        EncumbranceFrame:SetBackdropColor(1, 0, 0, 0.8)
    elseif percentage > 80 then
        color = "FFFF00"
        EncumbranceFrame:SetBackdropColor(0, 0, 0, 0.8)
    else
        color = "FFFFFF"
        EncumbranceFrame:SetBackdropColor(0, 0, 0, 0.8)
    end
    
    WeightText:SetText(string.format("|cff%sWeight: %d / %d|r", color, currentWeight, maxWeight))
end

-- Register for custom packets
local function OnEncumbrancePacket(data)
    if #data >= 3 then
        local currentWeight = tonumber(data[1]) or 0
        local maxWeight = tonumber(data[2]) or 100
        local isOverloaded = data[3] == "1"
        UpdateEncumbrance(currentWeight, maxWeight, isOverloaded)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.ENCUMBRANCE, OnEncumbrancePacket)
end

-- Export
MortalUIEncumbrance = {
    UpdateEncumbrance = UpdateEncumbrance
}

