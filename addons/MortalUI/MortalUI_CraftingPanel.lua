local AIO = rawget(_G, "AIO")
if not AIO then
    return
end

local CHANNEL = "MortalCraft"

local state = {
    blueprints = {},
    selectedIndex = 1
}

local CraftingPanel = CreateFrame("Frame", "MortalUI_CraftingPanel", UIParent, "BackdropTemplate")
CraftingPanel:SetSize(500, 360)
CraftingPanel:SetPoint("CENTER")
CraftingPanel:SetFrameStrata("HIGH")
CraftingPanel:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 16,
    insets = { left = 3, right = 3, top = 5, bottom = 5 }
})
CraftingPanel:Hide()
CraftingPanel:SetMovable(true)
CraftingPanel:EnableMouse(true)
CraftingPanel:RegisterForDrag("LeftButton")
CraftingPanel:SetScript("OnDragStart", CraftingPanel.StartMoving)
CraftingPanel:SetScript("OnDragStop", CraftingPanel.StopMovingOrSizing)

local title = CraftingPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("|cFF00FF00Forge Workstation|r")

local closeBtn = CreateFrame("Button", nil, CraftingPanel, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() CraftingPanel:Hide() end)

local listFrame = CreateFrame("ScrollFrame", nil, CraftingPanel, "UIPanelScrollFrameTemplate")
listFrame:SetPoint("TOPLEFT", 14, -40)
listFrame:SetSize(200, 270)

local listChild = CreateFrame("Frame", nil, listFrame)
listChild:SetSize(180, 270)
listFrame:SetScrollChild(listChild)

local componentFrame = CreateFrame("Frame", nil, CraftingPanel)
componentFrame:SetPoint("TOPLEFT", listFrame, "TOPRIGHT", 20, 0)
componentFrame:SetSize(240, 240)

componentFrame.title = componentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
componentFrame.title:SetPoint("TOPLEFT", 0, 0)
componentFrame.desc = componentFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
componentFrame.desc:SetPoint("TOPLEFT", componentFrame.title, "BOTTOMLEFT", 0, -4)
componentFrame.slots = {}
for i = 1, 4 do
    local label = componentFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    label:SetPoint("TOPLEFT", componentFrame.desc, "BOTTOMLEFT", 0, - (i * 25))
    label:SetWidth(230)
    label:SetJustifyH("LEFT")
    componentFrame.slots[i] = label
end

local statusText = CraftingPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
statusText:SetPoint("BOTTOMLEFT", componentFrame, "BOTTOMLEFT", 0, -20)
statusText:SetWidth(230)
statusText:SetJustifyH("LEFT")

local craftBtn = CreateFrame("Button", nil, CraftingPanel, "UIPanelButtonTemplate")
craftBtn:SetPoint("BOTTOMRIGHT", -20, 20)
craftBtn:SetSize(140, 30)
craftBtn:SetText("Craft Item")
craftBtn:SetScript("OnClick", function()
    local blueprint = state.blueprints[state.selectedIndex]
    if not blueprint then
        return
    end
    AIO.Handle(CHANNEL, "CraftBlueprint", blueprint.id)
end)

local blueprintButtons = {}

local function UpdateBlueprintButtons()
    local yOffset = 0
    for index, blueprint in ipairs(state.blueprints) do
        local button = blueprintButtons[index]
        if not button then
            button = CreateFrame("Button", nil, listChild, "UIPanelButtonTemplate")
            button:SetWidth(160)
            button:SetScript("OnClick", function()
                state.selectedIndex = index
                CraftingPanel:Refresh()
            end)
            blueprintButtons[index] = button
        end
        button:SetPoint("TOPLEFT", 0, -yOffset)
        button:SetText(blueprint.name)
        button:Show()
        if index == state.selectedIndex then
            button:GetFontString():SetTextColor(0, 1, 0)
        else
            button:GetFontString():SetTextColor(1, 1, 1)
        end
        yOffset = yOffset + 35
    end
    for i = #state.blueprints + 1, #blueprintButtons do
        blueprintButtons[i]:Hide()
    end
    listChild:SetHeight(math.max(yOffset, 270))
end

function CraftingPanel:Refresh()
    UpdateBlueprintButtons()
    local blueprint = state.blueprints[state.selectedIndex]
    if not blueprint then
        componentFrame.title:SetText("No blueprints available")
        componentFrame.desc:SetText("")
        for _, label in ipairs(componentFrame.slots) do
            label:SetText("")
        end
        craftBtn:Disable()
        return
    end
    componentFrame.title:SetText(blueprint.name)
    componentFrame.desc:SetText(blueprint.description or "")
    for i, comp in ipairs(blueprint.components or {}) do
        local label = componentFrame.slots[i]
        if label then
            local color = comp.available >= comp.required and "|cFF00FF00" or "|cFFFF0000"
            label:SetText(string.format("%s%s|r - (%d / %d)", color, comp.slot .. ": " .. comp.name, comp.available, comp.required))
        end
    end
    for i = # (blueprint.components or {}) + 1, #componentFrame.slots do
        componentFrame.slots[i]:SetText("")
    end
    craftBtn:Enable()
end

local function OpenPanel(payload)
    state.blueprints = payload.blueprints or {}
    if #state.blueprints == 0 then
        state.selectedIndex = 1
    else
        state.selectedIndex = math.min(state.selectedIndex, #state.blueprints)
    end
    CraftingPanel:Refresh()
    CraftingPanel:Show()
end

local function HandleResult(payload)
    if payload.error then
        statusText:SetText(string.format("|cFFFF0000%s|r", payload.error))
    elseif payload.item then
        statusText:SetText(string.format("|cFF00FF00Crafted item ID %d|r", payload.item))
    end
    if payload.blueprints then
        state.blueprints = payload.blueprints
        state.selectedIndex = math.min(state.selectedIndex, #state.blueprints)
        CraftingPanel:Refresh()
    end
end

AIO.RegisterEvent(CHANNEL, function(_, action, payload)
    if action == "OpenPanel" then
        OpenPanel(payload or {})
    elseif action == "CraftResult" then
        HandleResult(payload or {})
    end
end)

SLASH_MORTALCRAFT1 = "/mcraft"
SlashCmdList["MORTALCRAFT"] = function()
    AIO.Handle(CHANNEL, "RequestBlueprints")
end
