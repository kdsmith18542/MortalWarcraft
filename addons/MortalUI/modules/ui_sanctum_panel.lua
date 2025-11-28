-- ==================================================
-- MortalUI: Faction Sanctum Panel
-- Spec 60: Faction Sanctums
-- ==================================================

local SanctumPanelFrame = CreateFrame("Frame", "MortalUI_SanctumPanelFrame", UIParent)
SanctumPanelFrame:SetSize(600, 400)
SanctumPanelFrame:SetPoint("CENTER")
SanctumPanelFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
SanctumPanelFrame:SetBackdropColor(0, 0, 0, 0.8)
SanctumPanelFrame:Hide()

-- Title
local title = SanctumPanelFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -20)
title:SetText("Faction Sanctums")

-- Close button
local closeBtn = CreateFrame("Button", nil, SanctumPanelFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() SanctumPanelFrame:Hide() end)

-- Faction buttons
local factions = {
    {code = "IRON_LEDGER", name = "Iron Ledger", color = {1.0, 0.8, 0.2}},
    {code = "ORDER_SHRINE", name = "Order of the Shrine", color = {0.2, 0.8, 1.0}},
    {code = "BLACK_SUN_CARTEL", name = "Black Sun Cartel", color = {0.8, 0.2, 0.2}},
    {code = "RANGERS_PACT", name = "Rangers' Pact", color = {0.2, 1.0, 0.2}},
}

local function CreateFactionButton(faction, index)
    local btn = CreateFrame("Button", nil, SanctumPanelFrame, "UIPanelButtonTemplate")
    btn:SetSize(280, 60)
    btn:SetPoint("TOPLEFT", 20 + ((index - 1) % 2) * 300, -50 - math.floor((index - 1) / 2) * 70)
    btn:SetText(faction.name)
    
    local status = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    status:SetPoint("BOTTOM", 0, 5)
    status:SetText("Tier 1 Unlocked")
    status:SetTextColor(unpack(faction.color))
    
    btn:SetScript("OnClick", function()
        -- Teleport to sanctum (would call server function)
        SendChatMessage(".sanctum " .. faction.code, "GUILD")
    end)
    
    return btn
end

-- Create faction buttons
for i, faction in ipairs(factions) do
    CreateFactionButton(faction, i)
end

-- Show function
function ShowSanctumPanel()
    SanctumPanelFrame:Show()
end

-- Register slash command
SLASH_MORTALSANCTUM1 = "/sanctum"
SlashCmdList["MORTALSANCTUM"] = function(msg)
    ShowSanctumPanel()
end

