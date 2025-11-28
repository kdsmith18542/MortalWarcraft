-- ==================================================
-- Project Mortal Warcraft
-- Feature: Rune & Augment UI
-- Description: Client-side UI for socketing runes and augments
-- Spec: 53-rune-augments-and-gear-build-system.md
-- ==================================================

local MortalUIRunes = CreateFrame("Frame", "MortalUIRunesPanel", UIParent)
MortalUIRunes:SetSize(600, 500)
MortalUIRunes:SetPoint("CENTER")
MortalUIRunes:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MortalUIRunes:SetBackdropColor(0, 0, 0, 0.9)
MortalUIRunes:Hide()
MortalUIRunes:SetMovable(true)
MortalUIRunes:EnableMouse(true)
MortalUIRunes:RegisterForDrag("LeftButton")
MortalUIRunes:SetScript("OnDragStart", MortalUIRunes.StartMoving)
MortalUIRunes:SetScript("OnDragStop", MortalUIRunes.StopMovingOrSizing)

-- Title
local title = MortalUIRunes:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("Runes & Augments")

-- Close button
local closeBtn = CreateFrame("Button", nil, MortalUIRunes, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUIRunes:Hide() end)

-- Item slot display
local itemSlotFrame = CreateFrame("Frame", nil, MortalUIRunes)
itemSlotFrame:SetSize(100, 100)
itemSlotFrame:SetPoint("TOPLEFT", 20, -50)
itemSlotFrame:SetBackdrop({
    bgFile = "Interface\\Buttons\\UI-EmptySlot",
    edgeFile = "Interface\\Buttons\\UI-EmptySlot",
    tile = false,
    edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
})

local itemIcon = itemSlotFrame:CreateTexture(nil, "ARTWORK")
itemIcon:SetAllPoints()
itemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

local itemName = MortalUIRunes:CreateFontString(nil, "OVERLAY", "GameFontNormal")
itemName:SetPoint("TOP", itemSlotFrame, "BOTTOM", 0, -5)
itemName:SetText("No item selected")

-- Rune slots
local runeLabel = MortalUIRunes:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
runeLabel:SetPoint("TOPLEFT", 150, -50)
runeLabel:SetText("Rune Slots:")

local runeSlots = {}
for i = 1, 3 do
    local slot = CreateFrame("Button", nil, MortalUIRunes)
    slot:SetSize(50, 50)
    slot:SetPoint("TOPLEFT", 150 + (i - 1) * 60, -80)
    slot:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-EmptySlot",
        edgeFile = "Interface\\Buttons\\UI-EmptySlot",
        tile = false,
        edgeSize = 16,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    
    local icon = slot:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    slot.icon = icon
    
    slot:SetScript("OnClick", function()
        -- Show rune selection
        if AIO then
            AIO.Handle("Mortal", "RequestRuneSelection", i)
        end
    end)
    
    slot:SetScript("OnEnter", function()
        if slot.runeData then
            GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
            GameTooltip:SetText(slot.runeData.name or "Empty")
            GameTooltip:AddLine(slot.runeData.description or "", 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    slot:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    runeSlots[i] = slot
end

-- Augment slots
local augmentLabel = MortalUIRunes:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
augmentLabel:SetPoint("TOPLEFT", 150, -150)
augmentLabel:SetText("Augment Slots:")

local augmentSlots = {}
for i = 1, 6 do
    local slot = CreateFrame("Button", nil, MortalUIRunes)
    slot:SetSize(50, 50)
    slot:SetPoint("TOPLEFT", 150 + ((i - 1) % 3) * 60, -180 - math.floor((i - 1) / 3) * 60)
    slot:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-EmptySlot",
        edgeFile = "Interface\\Buttons\\UI-EmptySlot",
        tile = false,
        edgeSize = 16,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    
    local icon = slot:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    slot.icon = icon
    
    slot:SetScript("OnClick", function()
        -- Show augment selection
        if AIO then
            AIO.Handle("Mortal", "RequestAugmentSelection", i)
        end
    end)
    
    slot:SetScript("OnEnter", function()
        if slot.augmentData then
            GameTooltip:SetOwner(slot, "ANCHOR_RIGHT")
            GameTooltip:SetText(slot.augmentData.name or "Empty")
            GameTooltip:AddLine(slot.augmentData.description or "", 1, 1, 1, true)
            GameTooltip:Show()
        end
    end)
    slot:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    augmentSlots[i] = slot
end

-- Apply button
local applyBtn = CreateFrame("Button", nil, MortalUIRunes, "UIPanelButtonTemplate")
applyBtn:SetSize(150, 30)
applyBtn:SetPoint("BOTTOM", 0, 20)
applyBtn:SetText("Apply Enhancements")
applyBtn:SetScript("OnClick", function()
    -- Send enhancement data to server
    if AIO then
        local enhancements = {}
        for i, slot in ipairs(runeSlots) do
            if slot.runeData then
                table.insert(enhancements, { type = "RUNE", slot = i, id = slot.runeData.id })
            end
        end
        for i, slot in ipairs(augmentSlots) do
            if slot.augmentData then
                table.insert(enhancements, { type = "AUGMENT", slot = i, id = slot.augmentData.id })
            end
        end
        AIO.Handle("Mortal", "ApplyEnhancements", enhancements)
    end
end)

function MortalUIRunes.UpdateItem(itemData)
    if itemData then
        itemIcon:SetTexture(itemData.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        itemName:SetText(itemData.name or "Unknown")
        
        -- Update rune slots
        for i, slot in ipairs(runeSlots) do
            if itemData.runes and itemData.runes[i] then
                slot.icon:SetTexture(itemData.runes[i].icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                slot.runeData = itemData.runes[i]
            else
                slot.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                slot.runeData = nil
            end
        end
        
        -- Update augment slots
        for i, slot in ipairs(augmentSlots) do
            if itemData.augments and itemData.augments[i] then
                slot.icon:SetTexture(itemData.augments[i].icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                slot.augmentData = itemData.augments[i]
            else
                slot.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                slot.augmentData = nil
            end
        end
    end
end

-- Register AIO handlers
if AIO then
    AIO.AddAddon("Mortal", function()
        -- Receive item data
        AIO.Handle("Mortal", "UpdateRuneAugmentItem", function(itemData)
            MortalUIRunes.UpdateItem(itemData)
        end)
        
        -- Show rune panel
        AIO.Handle("Mortal", "ShowRuneAugmentPanel", function()
            MortalUIRunes:Show()
        end)
    end)
end

-- Export
MortalUIRunesPanel = MortalUIRunes

