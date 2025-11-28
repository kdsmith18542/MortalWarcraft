-- ==================================================
-- Project Mortal Warcraft
-- Feature: Build Presets UI
-- Description: Client-side UI for saving and loading build presets
-- Spec: 55-build-presets-and-loadouts.md
-- ==================================================

local MortalUIBuildPresets = CreateFrame("Frame", "MortalUIBuildPresetsPanel", UIParent)
MortalUIBuildPresets:SetSize(500, 600)
MortalUIBuildPresets:SetPoint("CENTER")
MortalUIBuildPresets:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
MortalUIBuildPresets:SetBackdropColor(0, 0, 0, 0.9)
MortalUIBuildPresets:Hide()
MortalUIBuildPresets:SetMovable(true)
MortalUIBuildPresets:EnableMouse(true)
MortalUIBuildPresets:RegisterForDrag("LeftButton")
MortalUIBuildPresets:SetScript("OnDragStart", MortalUIBuildPresets.StartMoving)
MortalUIBuildPresets:SetScript("OnDragStop", MortalUIBuildPresets.StopMovingOrSizing)

-- Title
local title = MortalUIBuildPresets:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("Build Presets")

-- Close button
local closeBtn = CreateFrame("Button", nil, MortalUIBuildPresets, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUIBuildPresets:Hide() end)

-- Preset list
local presetScrollFrame = CreateFrame("ScrollFrame", "MortalUIBuildPresetsScroll", MortalUIBuildPresets, "UIPanelScrollFrameTemplate")
presetScrollFrame:SetPoint("TOPLEFT", 20, -50)
presetScrollFrame:SetPoint("BOTTOMRIGHT", -30, 100)

local presetContent = CreateFrame("Frame", nil, presetScrollFrame)
presetContent:SetSize(450, 400)
presetScrollFrame:SetScrollChild(presetContent)

local presetButtons = {}

local function CreatePresetButton(parent, index, presetData)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(430, 70)
    btn:SetPoint("TOPLEFT", 0, -(index - 1) * 75)
    
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\UI-SilverButton",
        edgeFile = "Interface\\Buttons\\UI-SilverButton",
        tile = true, tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    btn:SetBackdropColor(0.2, 0.2, 0.2, 0.8)
    
    -- Preset name
    local nameText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    nameText:SetPoint("LEFT", 10, 10)
    nameText:SetText(presetData.name or "Unknown")
    
    -- Preset type
    local typeText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    typeText:SetPoint("LEFT", 10, -10)
    typeText:SetText(presetData.preset_type or "Unknown")
    
    -- Load button
    local loadBtn = CreateFrame("Button", nil, btn, "UIPanelButtonTemplate")
    loadBtn:SetSize(80, 25)
    loadBtn:SetPoint("RIGHT", -10, 0)
    loadBtn:SetText("Load")
    loadBtn:SetScript("OnClick", function()
        if AIO then
            AIO.Handle("Mortal", "LoadPreset", presetData.id)
        end
    end)
    
    -- Delete button
    local deleteBtn = CreateFrame("Button", nil, btn, "UIPanelButtonTemplate")
    deleteBtn:SetSize(80, 25)
    deleteBtn:SetPoint("RIGHT", loadBtn, "LEFT", -10, 0)
    deleteBtn:SetText("Delete")
    deleteBtn:SetScript("OnClick", function()
        if AIO then
            AIO.Handle("Mortal", "DeletePreset", presetData.id)
        end
    end)
    
    presetButtons[index] = btn
    return btn
end

function MortalUIBuildPresets.UpdatePresetList(presets)
    -- Clear existing buttons
    for i, btn in ipairs(presetButtons) do
        btn:Hide()
    end
    
    -- Create buttons for each preset
    for i, preset in ipairs(presets or {}) do
        if not presetButtons[i] then
            CreatePresetButton(presetContent, i, preset)
        else
            presetButtons[i]:Show()
        end
    end
    
    presetContent:SetHeight(math.max(400, #presets * 75))
end

-- Save preset frame
local saveFrame = CreateFrame("Frame", nil, MortalUIBuildPresets)
saveFrame:SetSize(400, 150)
saveFrame:SetPoint("BOTTOM", 0, 50)
saveFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
saveFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)

local saveLabel = saveFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
saveLabel:SetPoint("TOP", 0, -10)
saveLabel:SetText("Save Current Build")

local nameEditBox = CreateFrame("EditBox", nil, saveFrame, "InputBoxTemplate")
nameEditBox:SetSize(200, 30)
nameEditBox:SetPoint("TOP", 0, -35)
nameEditBox:SetAutoFocus(false)

local typeDropdown = CreateFrame("Frame", nil, saveFrame, "UIDropDownMenuTemplate")
typeDropdown:SetPoint("TOP", 0, -70)
UIDropDownMenu_SetWidth(typeDropdown, 200)
UIDropDownMenu_SetText(typeDropdown, "Select Type")

local saveBtn = CreateFrame("Button", nil, saveFrame, "UIPanelButtonTemplate")
saveBtn:SetSize(100, 30)
saveBtn:SetPoint("BOTTOM", 0, 10)
saveBtn:SetText("Save")
saveBtn:SetScript("OnClick", function()
    local name = nameEditBox:GetText()
    local presetType = UIDropDownMenu_GetSelectedValue(typeDropdown)
    if name and name ~= "" and presetType then
        if AIO then
            AIO.Handle("Mortal", "SavePreset", name, presetType)
        end
        nameEditBox:SetText("")
    end
end)

-- Initialize dropdown
local function InitializeTypeDropdown()
    local info = UIDropDownMenu_CreateInfo()
    info.text = "PvP"
    info.value = "PvP"
    info.func = function()
        UIDropDownMenu_SetSelectedValue(typeDropdown, "PvP")
    end
    UIDropDownMenu_AddButton(info)
    
    info.text = "PvE"
    info.value = "PvE"
    info.func = function()
        UIDropDownMenu_SetSelectedValue(typeDropdown, "PvE")
    end
    UIDropDownMenu_AddButton(info)
    
    info.text = "Crafting"
    info.value = "CRAFTING"
    info.func = function()
        UIDropDownMenu_SetSelectedValue(typeDropdown, "CRAFTING")
    end
    UIDropDownMenu_AddButton(info)
end

UIDropDownMenu_Initialize(typeDropdown, InitializeTypeDropdown)

-- Register AIO handlers
if AIO then
    AIO.AddAddon("Mortal", function()
        -- Receive preset list
        AIO.Handle("Mortal", "UpdatePresetList", function(presets)
            MortalUIBuildPresets.UpdatePresetList(presets)
        end)
        
        -- Show preset panel
        AIO.Handle("Mortal", "ShowBuildPresetsPanel", function()
            MortalUIBuildPresets:Show()
            -- Request preset list
            AIO.Handle("Mortal", "RequestPresetList")
        end)
    end)
end

-- Export
MortalUIBuildPresetsPanel = MortalUIBuildPresets

