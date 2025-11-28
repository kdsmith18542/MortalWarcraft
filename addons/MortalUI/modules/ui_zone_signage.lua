-- ==================================================
-- Project Mortal Warcraft
-- Feature: Zone Signage (Client-Side)
-- Description: Visual banners, icons, and warning text at zone borders
-- Spec: 03-risk-zones.md section 4.1
-- ==================================================

local ZoneSignageFrame = CreateFrame("Frame", "MortalUIZoneSignage", UIParent)
ZoneSignageFrame:SetFrameStrata("TOOLTIP")
ZoneSignageFrame:SetSize(500, 200)
ZoneSignageFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
ZoneSignageFrame:Hide()

-- Background with colored border
local bg = ZoneSignageFrame:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.85)
ZoneSignageFrame.bg = bg

-- Border frame
local border = CreateFrame("Frame", nil, ZoneSignageFrame)
border:SetAllPoints()
border:SetBackdrop({
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
ZoneSignageFrame.border = border

-- Skull icon for Red zones
local skullIcon = ZoneSignageFrame:CreateTexture(nil, "OVERLAY")
skullIcon:SetSize(64, 64)
skullIcon:SetPoint("LEFT", ZoneSignageFrame, "LEFT", 20, 0)
skullIcon:SetTexture("Interface\\Icons\\INV_Misc_Bone_01")
skullIcon:Hide()
ZoneSignageFrame.skullIcon = skullIcon

-- Main title text
local title = ZoneSignageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
title:SetPoint("TOP", ZoneSignageFrame, "TOP", 0, -20)
title:SetText("")
ZoneSignageFrame.title = title

-- Subtitle with zone name
local subtitle = ZoneSignageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
subtitle:SetPoint("TOP", title, "BOTTOM", 0, -10)
subtitle:SetText("")
ZoneSignageFrame.subtitle = subtitle

-- Warning text
local warning = ZoneSignageFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
warning:SetPoint("TOP", subtitle, "BOTTOM", 0, -15)
warning:SetWidth(460)
warning:SetJustifyH("CENTER")
warning:SetJustifyV("TOP")
warning:SetText("")
ZoneSignageFrame.warning = warning

-- Show zone signage
local function ShowZoneSignage(zoneType, zoneName, fromZoneType)
    if zoneType == "green" then
        ZoneSignageFrame:Hide()
        return
    end
    
    local color, titleText, subtitleText, warningText
    
    if zoneType == "red" then
        color = "FF0000"  -- Red
        titleText = "|cFF" .. color .. "⚠ FULL-LOOT ZONE ⚠|r"
        subtitleText = "|cFF" .. color .. "Entering: " .. (zoneName or "Red Zone") .. "|r"
        warningText = "|cFF" .. color .. "YOU ARE ENTERING A FULL-LOOT ZONE!\n\n" ..
                     "• All items drop on death\n" ..
                     "• PvP is always enabled\n" ..
                     "• Friendly fire is active\n" ..
                     "• No guards or safe zones|r"
        skullIcon:Show()
    elseif zoneType == "yellow" then
        color = "FFFF00"  -- Yellow
        titleText = "|cFF" .. color .. "⚠ MID-RISK ZONE ⚠|r"
        subtitleText = "|cFF" .. color .. "Entering: " .. (zoneName or "Yellow Zone") .. "|r"
        warningText = "|cFF" .. color .. "MID-RISK ZONE\n\n" ..
                     "• Attacking innocents flags you as Criminal\n" ..
                     "• Criminals drop all items on death\n" ..
                     "• Partial loot for innocents|r"
        skullIcon:Hide()
    else
        return
    end
    
    -- Update text
    ZoneSignageFrame.title:SetText(titleText)
    ZoneSignageFrame.subtitle:SetText(subtitleText)
    ZoneSignageFrame.warning:SetText(warningText)
    
    -- Update border color
    local r = tonumber("0x" .. color:sub(1, 2)) / 255
    local g = tonumber("0x" .. color:sub(3, 4)) / 255
    local b = tonumber("0x" .. color:sub(5, 6)) / 255
    border:SetBackdropBorderColor(r, g, b, 1)
    
    -- Show frame
    ZoneSignageFrame:Show()
    
    -- Play sound effect
    if zoneType == "red" then
        PlaySound(8959)  -- Aggro sound
    else
        PlaySound(8957)  -- Alert sound
    end
    
    -- Auto-hide after 8 seconds
    C_Timer.After(8, function()
        ZoneSignageFrame:Hide()
    end)
end

-- Listen for zone change events
local ZoneChangeFrame = CreateFrame("Frame")
ZoneChangeFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ZoneChangeFrame:RegisterEvent("CHAT_MSG_ADDON")

local lastZone = nil

ZoneChangeFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ZONE_CHANGED_NEW_AREA" then
        local newZone = GetRealZoneText()
        if newZone and newZone ~= lastZone then
            lastZone = newZone
            -- Request zone type from server
            if C_ChatInfo then
                C_ChatInfo.SendAddonMessage("MORTAL_PACKET", "QUERY_ZONE_TYPE", "WHISPER", UnitName("player"))
            end
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == "MORTAL_RISK_ZONE" then
            -- Parse message: "riskTier:zoneName:fromZoneType"
            local riskTierStr, zoneName, fromZoneType = strsplit(":", message)
            local riskTier = tonumber(riskTierStr) or 0
            
            local zoneType = "green"
            if riskTier == 2 then
                zoneType = "red"
            elseif riskTier == 1 then
                zoneType = "yellow"
            end
            
            ShowZoneSignage(zoneType, zoneName, fromZoneType)
        end
    end
end)

-- Export
MortalUIZoneSignage = {
    ShowZoneSignage = ShowZoneSignage
}

print("[MortalUI] Zone Signage loaded")

