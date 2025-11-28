-- ==================================================
-- Project Mortal Warcraft
-- Feature: Faction System UI
-- Description: Client-side UI for faction standing, pledging, and rewards
-- Spec: 51-factions-and-standing-system.md
-- ==================================================

local MortalUIFaction = CreateFrame("Frame", "MortalUIFactionPanel", UIParent)
MortalUIFaction:SetSize(400, 500)
MortalUIFaction:SetPoint("CENTER")
MortalUIFaction:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MortalUIFaction:SetBackdropColor(0, 0, 0, 0.9)
MortalUIFaction:Hide()
MortalUIFaction:SetMovable(true)
MortalUIFaction:EnableMouse(true)
MortalUIFaction:RegisterForDrag("LeftButton")
MortalUIFaction:SetScript("OnDragStart", MortalUIFaction.StartMoving)
MortalUIFaction:SetScript("OnDragStop", MortalUIFaction.StopMovingOrSizing)

-- Title
local title = MortalUIFaction:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("Faction Standing")

-- Close button
local closeBtn = CreateFrame("Button", nil, MortalUIFaction, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUIFaction:Hide() end)

-- Faction list
local factionScrollFrame = CreateFrame("ScrollFrame", "MortalUIFactionScroll", MortalUIFaction, "UIPanelScrollFrameTemplate")
factionScrollFrame:SetPoint("TOPLEFT", 10, -50)
factionScrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)

local factionContent = CreateFrame("Frame", nil, factionScrollFrame)
factionContent:SetSize(350, 400)
factionScrollFrame:SetScrollChild(factionContent)

-- Faction buttons
local factionButtons = {}

local function CreateFactionButton(parent, index, factionData)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(330, 60)
    btn:SetPoint("TOPLEFT", 0, -(index - 1) * 65)
    
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SilverButton",
        edgeFile = "Interface\\Buttons\\UI-SilverButton",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    btn:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
    
    -- Faction name
    local nameText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("LEFT", 10, 0)
    nameText:SetText(factionData.name or "Unknown")
    
    -- Standing text
    local standingText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    standingText:SetPoint("LEFT", 10, -20)
    standingText:SetText(factionData.standing or "Neutral")
    
    -- Pledge indicator
    if factionData.isPledged then
        local pledgeIcon = btn:CreateTexture(nil, "OVERLAY")
        pledgeIcon:SetSize(20, 20)
        pledgeIcon:SetPoint("RIGHT", -10, 0)
        pledgeIcon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
    end
    
    btn:SetScript("OnClick", function()
        -- Request detailed faction info from server
        if AIO then
            AIO.Handle("Mortal", "RequestFactionDetails", factionData.id)
        end
    end)
    
    btn:SetScript("OnEnter", function()
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
        GameTooltip:SetText(factionData.name or "Unknown")
        GameTooltip:AddLine(factionData.description or "", 1, 1, 1, true)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    factionButtons[index] = btn
    return btn
end

-- Update faction list
function MortalUIFaction.UpdateFactionList(factions)
    -- Clear existing buttons
    for i, btn in ipairs(factionButtons) do
        btn:Hide()
    end
    
    -- Create buttons for each faction
    for i, faction in ipairs(factions or {}) do
        if not factionButtons[i] then
            CreateFactionButton(factionContent, i, faction)
        else
            factionButtons[i]:Show()
        end
    end
    
    factionContent:SetHeight(math.max(400, #factions * 65))
end

-- Pledge button
local pledgeBtn = CreateFrame("Button", nil, MortalUIFaction, "UIPanelButtonTemplate")
pledgeBtn:SetSize(150, 30)
pledgeBtn:SetPoint("BOTTOM", 0, 20)
pledgeBtn:SetText("Pledge to Faction")
pledgeBtn:SetScript("OnClick", function()
    -- Request pledge UI from server
    if AIO then
        AIO.Handle("Mortal", "RequestPledgeUI")
    end
end)

-- Register AIO handlers
if AIO then
    AIO.AddAddon("Mortal", function()
        -- Receive faction list
        AIO.Handle("Mortal", "UpdateFactionList", function(factions)
            MortalUIFaction.UpdateFactionList(factions)
        end)
        
        -- Show faction panel
        AIO.Handle("Mortal", "ShowFactionPanel", function()
            MortalUIFaction:Show()
        end)
    end)
end

-- Export
MortalUIFactionPanel = MortalUIFaction

