-- ==================================================
-- MortalUI: Trial Browser Panel
-- Spec 59: Shrine and Faction Trials
-- ==================================================

local TrialBrowserFrame = CreateFrame("Frame", "MortalUI_TrialBrowserFrame", UIParent)
TrialBrowserFrame:SetSize(700, 500)
TrialBrowserFrame:SetPoint("CENTER")
TrialBrowserFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
TrialBrowserFrame:SetBackdropColor(0, 0, 0, 0.8)
TrialBrowserFrame:Hide()

-- Title
local title = TrialBrowserFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -20)
title:SetText("Trial Browser")

-- Close button
local closeBtn = CreateFrame("Button", nil, TrialBrowserFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() TrialBrowserFrame:Hide() end)

-- Filter buttons
local filterFrame = CreateFrame("Frame", nil, TrialBrowserFrame)
filterFrame:SetPoint("TOPLEFT", 20, -50)
filterFrame:SetSize(660, 30)

local allBtn = CreateFrame("Button", nil, filterFrame, "UIPanelButtonTemplate")
allBtn:SetSize(100, 25)
allBtn:SetPoint("LEFT", 0, 0)
allBtn:SetText("All")
allBtn:SetScript("OnClick", function() UpdateTrialList("") end)

local bulwarkBtn = CreateFrame("Button", nil, filterFrame, "UIPanelButtonTemplate")
bulwarkBtn:SetSize(100, 25)
bulwarkBtn:SetPoint("LEFT", allBtn, "RIGHT", 5, 0)
bulwarkBtn:SetText("Bulwark")
bulwarkBtn:SetScript("OnClick", function() UpdateTrialList("BULWARK") end)

local bladeBtn = CreateFrame("Button", nil, filterFrame, "UIPanelButtonTemplate")
bladeBtn:SetSize(100, 25)
bladeBtn:SetPoint("LEFT", bulwarkBtn, "RIGHT", 5, 0)
bladeBtn:SetText("Blade")
bladeBtn:SetScript("OnClick", function() UpdateTrialList("BLADE") end)

-- Scroll frame for trial list
local scrollFrame = CreateFrame("ScrollFrame", "TrialBrowserScrollFrame", TrialBrowserFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", filterFrame, "BOTTOMLEFT", 0, -10)
scrollFrame:SetPoint("BOTTOMRIGHT", -40, 50)

local content = CreateFrame("Frame", "TrialBrowserContent", scrollFrame)
content:SetSize(660, 400)
scrollFrame:SetScrollChild(content)

-- Trial list update function
function UpdateTrialList(filter)
    -- Clear existing entries
    for i = 1, content:GetNumChildren() do
        local child = select(i, content:GetChildren())
        if child then
            child:Hide()
        end
    end
    
    -- Query available trials (would use AIO or custom protocol)
    -- For now, show placeholder
    local placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    placeholder:SetPoint("TOP", 0, -10)
    placeholder:SetText("Available trials will be listed here.")
    placeholder:SetTextColor(0.7, 0.7, 0.7)
end

-- Show function
function ShowTrialBrowser()
    UpdateTrialList("")
    TrialBrowserFrame:Show()
end

-- Register slash command
SLASH_MORTALTRIALS1 = "/trials"
SlashCmdList["MORTALTRIALS"] = function(msg)
    ShowTrialBrowser()
end

