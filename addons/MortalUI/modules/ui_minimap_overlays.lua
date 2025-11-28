-- ==================================================
-- Project Mortal Warcraft
-- Feature: Minimap Risk Zone Overlays (Client-Side)
-- Description: Visual overlays on minimap for risk zones
-- Spec: 15-ui-client.md section 13.3
-- ==================================================

local MinimapOverlaysFrame = CreateFrame("Frame", "MortalUIMinimapOverlays", Minimap)
MinimapOverlaysFrame:SetAllPoints(Minimap)
MinimapOverlaysFrame:SetFrameStrata("BACKGROUND")
MinimapOverlaysFrame:SetFrameLevel(Minimap:GetFrameLevel() + 1)
MinimapOverlaysFrame:EnableMouse(false)

-- Border overlay for risk zones
local borderOverlay = MinimapOverlaysFrame:CreateTexture(nil, "OVERLAY")
borderOverlay:SetAllPoints(MinimapOverlaysFrame)
borderOverlay:SetBlendMode("ADD")
borderOverlay:SetAlpha(0.5)
borderOverlay:Hide()
MinimapOverlaysFrame.borderOverlay = borderOverlay

-- Warning icon for Red zones
local warningIcon = MinimapOverlaysFrame:CreateTexture(nil, "OVERLAY")
warningIcon:SetSize(32, 32)
warningIcon:SetPoint("TOP", MinimapOverlaysFrame, "TOP", 0, -5)
warningIcon:SetTexture("Interface\\Icons\\INV_Misc_Bone_01")
warningIcon:Hide()
MinimapOverlaysFrame.warningIcon = warningIcon

-- Current zone type
local currentZoneType = "green"

-- Apply minimap overlay based on zone type
local function ApplyMinimapOverlay(zoneType)
    currentZoneType = zoneType or "green"
    
    if zoneType == "green" then
        -- No overlay for Green zones
        borderOverlay:Hide()
        warningIcon:Hide()
    elseif zoneType == "yellow" then
        -- Yellow border overlay
        borderOverlay:SetColorTexture(1.0, 1.0, 0.0, 0.3)  -- Yellow with transparency
        borderOverlay:Show()
        warningIcon:Hide()
    elseif zoneType == "red" then
        -- Red border overlay + warning icon
        borderOverlay:SetColorTexture(1.0, 0.0, 0.0, 0.4)  -- Red with transparency
        borderOverlay:Show()
        warningIcon:Show()
    end
end

-- Update minimap when zone changes
local ZoneUpdateFrame = CreateFrame("Frame")
ZoneUpdateFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ZoneUpdateFrame:RegisterEvent("CHAT_MSG_ADDON")

ZoneUpdateFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ZONE_CHANGED_NEW_AREA" then
        -- Request zone type from server
        if C_ChatInfo then
            C_ChatInfo.SendAddonMessage("MORTAL_PACKET", "QUERY_ZONE_TYPE", "WHISPER", UnitName("player"))
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == "MORTAL_RISK_ZONE" then
            -- Parse message: "riskTier:zoneName"
            local riskTierStr = strsplit(":", message)
            local riskTier = tonumber(riskTierStr) or 0
            
            local zoneType = "green"
            if riskTier == 2 then
                zoneType = "red"
            elseif riskTier == 1 then
                zoneType = "yellow"
            end
            
            ApplyMinimapOverlay(zoneType)
        end
    end
end)

-- Initialize on load
local function Initialize()
    -- Apply default overlay (Green zone)
    ApplyMinimapOverlay("green")
end

-- Hook into minimap updates
MinimapOverlaysFrame:SetScript("OnUpdate", function(self, elapsed)
    -- Keep overlay in sync with minimap
    if Minimap:IsVisible() then
        MinimapOverlaysFrame:Show()
    else
        MinimapOverlaysFrame:Hide()
    end
end)

-- Export
MortalUIMinimapOverlays = {
    ApplyMinimapOverlay = ApplyMinimapOverlay
}

-- Initialize on load
Initialize()

print("[MortalUI] Minimap Overlays loaded")

