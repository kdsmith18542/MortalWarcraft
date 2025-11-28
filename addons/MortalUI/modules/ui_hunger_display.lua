-- ==================================================
-- Project Mortal Warcraft
-- Feature: Hunger Display (Client-Side)
-- Description: Display hunger bar above player frame
-- Spec: 15-ui-client.md
-- ==================================================

local HungerFrame = CreateFrame("Frame", "MortalUIHunger", UIParent)
HungerFrame:SetSize(200, 20)
HungerFrame:SetPoint("BOTTOM", PlayerFrame, "TOP", 0, 10)
HungerFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
HungerFrame:SetBackdropColor(0, 0, 0, 0.8)

-- Hunger bar
local HungerBar = CreateFrame("StatusBar", nil, HungerFrame)
HungerBar:SetSize(180, 12)
HungerBar:SetPoint("CENTER", HungerFrame, "CENTER", 0, 0)
HungerBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
HungerBar:SetMinMaxValues(0, 100)
HungerBar:SetValue(100)

-- Hunger text
local HungerText = HungerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
HungerText:SetPoint("CENTER", HungerBar, "CENTER", 0, 0)
HungerText:SetText("Hunger: 100%")

-- Update hunger (called from server)
local function UpdateHunger(hungerValue)
    hungerValue = hungerValue or 100
    HungerBar:SetValue(hungerValue)
    
    local color = { r = 0, g = 1, b = 0 } -- Green
    if hungerValue < 30 then
        color = { r = 1, g = 0, b = 0 } -- Red
    elseif hungerValue < 60 then
        color = { r = 1, g = 1, b = 0 } -- Yellow
    end
    
    HungerBar:SetStatusBarColor(color.r, color.g, color.b, 1)
    HungerText:SetText(string.format("Hunger: %d%%", hungerValue))
end

-- Register for custom packets
local function OnHungerPacket(data)
    if #data >= 1 then
        local hungerValue = tonumber(data[1]) or 100
        UpdateHunger(hungerValue)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.HUNGER, OnHungerPacket)
end

-- Export
MortalUIHunger = {
    UpdateHunger = UpdateHunger
}

