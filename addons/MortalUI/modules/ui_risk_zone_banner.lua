-- ==================================================
-- Project Mortal Warcraft
-- Feature: Risk Zone Banner (Client-Side)
-- Description: Large banner when entering Yellow/Red zones
-- Spec: 15-ui-client.md
-- ==================================================

local RiskBannerFrame = CreateFrame("Frame", "MortalUIRiskBanner", UIParent)
RiskBannerFrame:SetSize(600, 150)
RiskBannerFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
RiskBannerFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
RiskBannerFrame:Hide()

-- Banner text
local BannerText = RiskBannerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
BannerText:SetPoint("CENTER", RiskBannerFrame, "CENTER", 0, 0)
BannerText:SetText("")

-- Show risk zone banner
local function ShowRiskBanner(zoneType, lootRules, crimeConsequences)
    if zoneType == "green" then
        RiskBannerFrame:Hide()
        return
    end

    local color = zoneType == "red" and "FF0000" or "FFFF00"
    local zoneName = zoneType == "red" and "RED ZONE" or "YELLOW ZONE"

    BannerText:SetText(string.format("|cff%s=== %s ===|r", color, zoneName))
    RiskBannerFrame:SetBackdropColor(
        zoneType == "red" and 1 or 0.5,
        zoneType == "red" and 0 or 0.5,
        0,
        0.9
    )

    RiskBannerFrame:Show()

    -- Show notification
    if MortalUINotifications then
        local notificationType = zoneType == "red" and "error" or "warning"
        local title = string.format("Entered %s Zone", zoneName)
        local message = zoneType == "red" and "Extreme danger! Criminal acts have severe consequences." or "Caution advised. Some rules may differ."
        MortalUINotifications.Show(title, message, notificationType, {
            duration = 8,
            sound = zoneType == "red" and "igQuestFailed" or "igPlayerInvite"
        })
    end

    -- Auto-hide after 10 seconds
    C_Timer.After(10, function()
        RiskBannerFrame:Hide()
    end)
end

-- Register for zone change events
local ZoneChangeFrame = CreateFrame("Frame")
ZoneChangeFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ZoneChangeFrame:SetScript("OnEvent", function(self, event)
    if event == "ZONE_CHANGED_NEW_AREA" then
        -- Request zone type from server
        if MortalPacketHandler then
            C_ChatInfo.SendAddonMessage("MORTAL_PACKET", "QUERY_ZONE_TYPE", "WHISPER", UnitName("player"))
        end
    end
end)

-- Handle zone type packet
local function OnZoneTypePacket(data)
    if #data >= 1 then
        local zoneType = data[1] or "green"
        local lootRules = data[2] or ""
        local crimeConsequences = data[3] or ""
        ShowRiskBanner(zoneType, lootRules, crimeConsequences)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.ZONE_TYPE, OnZoneTypePacket)
end

-- Export
MortalUIRiskBanner = {
    ShowRiskBanner = ShowRiskBanner
}

