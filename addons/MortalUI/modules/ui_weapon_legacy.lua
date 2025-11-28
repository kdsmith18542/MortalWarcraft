-- ==================================================
-- MortalUI: Weapon Legacy Codex Panel
-- Spec 61: Weapon Legacy and History
-- ==================================================

local WeaponLegacyFrame = CreateFrame("Frame", "MortalUI_WeaponLegacyFrame", UIParent)
WeaponLegacyFrame:SetSize(600, 400)
WeaponLegacyFrame:SetPoint("CENTER")
WeaponLegacyFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
WeaponLegacyFrame:SetBackdropColor(0, 0, 0, 0.8)
WeaponLegacyFrame:Hide()

-- Title
local title = WeaponLegacyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -20)
title:SetText("Weapon Legacy Codex")

-- Close button
local closeBtn = CreateFrame("Button", nil, WeaponLegacyFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() WeaponLegacyFrame:Hide() end)

-- Scroll frame for weapon list
local scrollFrame = CreateFrame("ScrollFrame", "WeaponLegacyScrollFrame", WeaponLegacyFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 20, -50)
scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)

local content = CreateFrame("Frame", "WeaponLegacyContent", scrollFrame)
content:SetSize(560, 300)
scrollFrame:SetScrollChild(content)

-- Weapon list (would be populated from database)
local function UpdateWeaponList()
    -- Clear existing entries
    for i = 1, content:GetNumChildren() do
        local child = select(i, content:GetChildren())
        if child then
            child:Hide()
        end
    end
    
    -- Query weapon legacy codex (would use AIO or custom protocol)
    -- For now, show placeholder
    local placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    placeholder:SetPoint("TOP", 0, -10)
    placeholder:SetText("Your weapon legacy records will appear here.")
    placeholder:SetTextColor(0.7, 0.7, 0.7)
end

-- Show function
function ShowWeaponLegacyCodex()
    UpdateWeaponList()
    WeaponLegacyFrame:Show()
end

-- Register slash command
SLASH_MORTALLEGACY1 = "/legacy"
SlashCmdList["MORTALLEGACY"] = function(msg)
    ShowWeaponLegacyCodex()
end

