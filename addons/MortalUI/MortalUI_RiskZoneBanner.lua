-- ==================================================
-- Mortal UI: Risk Zone Banner
-- Milestone 2: Risk Zones & Death/Loot Rules
-- ==================================================
-- Displays large banner when entering Yellow/Red zones
-- ==================================================

local MortalUI_RiskZoneBanner = CreateFrame("Frame", "MortalUI_RiskZoneBanner", UIParent)
MortalUI_RiskZoneBanner:SetFrameStrata("TOOLTIP")
MortalUI_RiskZoneBanner:SetWidth(400)
MortalUI_RiskZoneBanner:SetHeight(150)
MortalUI_RiskZoneBanner:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
MortalUI_RiskZoneBanner:Hide()

-- Background
local bg = MortalUI_RiskZoneBanner:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.9)
MortalUI_RiskZoneBanner.bg = bg

-- Border
local border = CreateFrame("Frame", nil, MortalUI_RiskZoneBanner)
border:SetAllPoints()
border:SetBackdrop({
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
border:SetBackdropBorderColor(1, 1, 1, 1)

-- Title
local title = MortalUI_RiskZoneBanner:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
title:SetPoint("TOP", 0, -20)
title:SetText("")
MortalUI_RiskZoneBanner.title = title

-- Subtitle
local subtitle = MortalUI_RiskZoneBanner:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
subtitle:SetPoint("TOP", title, "BOTTOM", 0, -10)
subtitle:SetText("")
MortalUI_RiskZoneBanner.subtitle = subtitle

-- Warning text
local warning = MortalUI_RiskZoneBanner:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
warning:SetPoint("TOP", subtitle, "BOTTOM", 0, -15)
warning:SetWidth(380)
warning:SetJustifyH("CENTER")
warning:SetJustifyV("TOP")
warning:SetText("")
MortalUI_RiskZoneBanner.warning = warning

-- Show banner function
local function ShowBanner(riskTier, tierName)
    local color, titleText, subtitleText, warningText
    
    if riskTier == 2 then  -- Red Zone
        color = "FF0000"
        titleText = "|cFF" .. color .. "⚠ FULL-LOOT ZONE ⚠|r"
        subtitleText = "|cFF" .. color .. "You are entering a " .. tierName .. " Zone!|r"
        warningText = "|cFF" .. color .. "All items will drop on death!\nPvP is always enabled!\nFriendly fire is active!|r"
    elseif riskTier == 1 then  -- Yellow Zone
        color = "FFFF00"
        titleText = "|cFF" .. color .. "⚠ MID-RISK ZONE ⚠|r"
        subtitleText = "|cFF" .. color .. "You are entering a " .. tierName .. " Zone!|r"
        warningText = "|cFF" .. color .. "Attacking innocents will flag you as Criminal!\nCriminals drop all items on death!|r"
    else
        return  -- Don't show for Green zones
    end
    
    MortalUI_RiskZoneBanner.title:SetText(titleText)
    MortalUI_RiskZoneBanner.subtitle:SetText(subtitleText)
    MortalUI_RiskZoneBanner.warning:SetText(warningText)
    
    -- Update border color
    local r, g, b = tonumber("0x" .. color:sub(1, 2)) / 255,
                    tonumber("0x" .. color:sub(3, 4)) / 255,
                    tonumber("0x" .. color:sub(5, 6)) / 255
    border:SetBackdropBorderColor(r, g, b, 1)
    
    -- Show banner
    MortalUI_RiskZoneBanner:Show()
    
    -- Auto-hide after 5 seconds
    C_Timer.After(5, function()
        MortalUI_RiskZoneBanner:Hide()
    end)
end

-- Listen for addon messages from server
local function OnAddonMessage(event, prefix, message, channel, sender)
    if prefix ~= "MORTAL_RISK_ZONE" then
        return
    end
    
    -- Parse message: "riskTier:tierName"
    local riskTierStr, tierName = strsplit(":", message)
    local riskTier = tonumber(riskTierStr) or 0
    tierName = tierName or "Unknown"
    
    if riskTier > 0 then
        ShowBanner(riskTier, tierName)
    end
end

MortalUI_RiskZoneBanner:RegisterEvent("CHAT_MSG_ADDON")
MortalUI_RiskZoneBanner:SetScript("OnEvent", OnAddonMessage)

print("[MortalUI] Risk Zone Banner loaded")

