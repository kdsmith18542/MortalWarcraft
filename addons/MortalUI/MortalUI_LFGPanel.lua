-- ==================================================
-- MortalUI: LFG Panel (AIO-powered)
-- Spec 18: LFG System, Tavern Boards, Warfront & Hellgate UI
-- ==================================================

local AIO = rawget(_G, "AIO")
if not AIO then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r LFG panel requires the mod-AIO client. Please install the Mortal UI package.")
    return
end

local bit = bit
local LFG_CHANNEL = "MortalLFG"
local MortalAddon = LibStub and LibStub("AceAddon-3.0"):GetAddon("MortalUI", true)

local CONTENT_TYPES = {
    { label = "All Content", value = nil },
    { label = "Dungeons", value = "dungeon" },
    { label = "Raids", value = "raid" },
    { label = "Delves", value = "delve" },
    { label = "Events", value = "event" },
}

local ROLE_FLAGS = {
    { flag = 1, label = "Frontline" },
    { flag = 2, label = "Support" },
    { flag = 4, label = "Healing" },
    { flag = 8, label = "Ranged" },
    { flag = 16, label = "Scout" },
}

local TAB_CONFIG = {
    { label = "All Listings", key = "all", request = "RequestListings" },
    { label = "My Listings", key = "mine", request = "RequestMyListings" },
    { label = "Favorites", key = "favorites" }, -- reserved for future work
}

MortalUI = MortalUI or {}
MortalUI.LFG = MortalUI.LFG or {}
local LFGState = MortalUI.LFG
LFGState.filters = LFGState.filters or {}
LFGState.listings = LFGState.listings or {}
LFGState.myListings = LFGState.myListings or {}
LFGState.activeKey = LFGState.activeKey or "all"
LFGState.rowPool = LFGState.rowPool or {}

local function SendLFGRequest(action, payload)
    if payload ~= nil then
        AIO.Handle(LFG_CHANNEL, action, payload)
    else
        AIO.Handle(LFG_CHANNEL, action)
    end
end

local MortalUI_LFGPanel = CreateFrame("Frame", "MortalUI_LFGPanel", UIParent)
MortalUI_LFGPanel:SetFrameStrata("HIGH")
MortalUI_LFGPanel:SetSize(540, 430)
MortalUI_LFGPanel:SetPoint("CENTER")
MortalUI_LFGPanel:Hide()
MortalUI_LFGPanel:SetMovable(true)
MortalUI_LFGPanel:EnableMouse(true)
MortalUI_LFGPanel:RegisterForDrag("LeftButton")
MortalUI_LFGPanel:SetScript("OnDragStart", MortalUI_LFGPanel.StartMoving)
MortalUI_LFGPanel:SetScript("OnDragStop", MortalUI_LFGPanel.StopMovingOrSizing)

local bg = MortalUI_LFGPanel:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0.08, 0.08, 0.08, 0.95)

local title = MortalUI_LFGPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("|cFF00FF00Mortal LFG Board|r")

local closeBtn = CreateFrame("Button", nil, MortalUI_LFGPanel, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUI_LFGPanel:Hide() end)

-- Tabs -----------------------------------------------------------
local tabs = { byKey = {} }
local function CreateTab(config, index)
    local tab = CreateFrame("Button", "MortalUI_LFGTab_" .. config.key, MortalUI_LFGPanel)
    tab:SetSize(130, 30)
    tab:SetPoint("TOPLEFT", 10 + ((index - 1) * 140), -45)
    
    local tabBg = tab:CreateTexture(nil, "BACKGROUND")
    tabBg:SetAllPoints()
    tabBg:SetColorTexture(0.2, 0.2, 0.2, 1)
    tab.bg = tabBg
    
    local text = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("CENTER")
    text:SetText(config.label)
    tab.text = text
    tab.config = config
    
    tab:SetScript("OnClick", function()
        MortalUI_LFGPanel:SwitchTab(config.key)
    end)
    
    tab:SetScript("OnEnter", function()
        if not tab.isActive then
            tab.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
        end
    end)
    
    tab:SetScript("OnLeave", function()
        if not tab.isActive then
            tab.bg:SetColorTexture(0.2, 0.2, 0.2, 1)
        end
    end)
    
    tabs.byKey[config.key] = tab
end

for index, config in ipairs(TAB_CONFIG) do
    CreateTab(config, index)
end

-- Scrollable list -----------------------------------------------
local scrollFrame = CreateFrame("ScrollFrame", "MortalUI_LFGScrollFrame", MortalUI_LFGPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 12, -85)
scrollFrame:SetPoint("BOTTOMRIGHT", -32, 60)

local content = CreateFrame("Frame", "MortalUI_LFGContent", scrollFrame)
content:SetSize(480, 320)
scrollFrame:SetScrollChild(content)

content.placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontDisable")
content.placeholder:SetPoint("CENTER")
content.placeholder:Hide()

local function ShowPlaceholder(text)
    content.placeholder:SetText(text or "No listings available.")
    content.placeholder:Show()
end

local function HidePlaceholder()
    content.placeholder:Hide()
end

-- Filters --------------------------------------------------------
local filterFrame = CreateFrame("Frame", nil, MortalUI_LFGPanel)
filterFrame:SetPoint("BOTTOMLEFT", 12, 15)
filterFrame:SetSize(260, 32)

local filterLabel = filterFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
filterLabel:SetPoint("LEFT")
filterLabel:SetText("Content Filter:")

local filterDropdown = CreateFrame("Frame", "MortalUI_LFGContentFilter", filterFrame, "UIDropDownMenuTemplate")
filterDropdown:SetPoint("LEFT", filterLabel, "RIGHT", -10, -3)
UIDropDownMenu_SetWidth(filterDropdown, 150)
UIDropDownMenu_SetText(filterDropdown, "All Content")

local function ApplyFilter(value, label)
    LFGState.filters.contentType = value
    UIDropDownMenu_SetText(filterDropdown, label)
    MortalUI_LFGPanel:RequestActiveTabData()
end

UIDropDownMenu_Initialize(filterDropdown, function(_, level)
    local info = UIDropDownMenu_CreateInfo()
    for _, option in ipairs(CONTENT_TYPES) do
        info.text = option.label
        info.checked = option.value == LFGState.filters.contentType
        info.func = function()
            ApplyFilter(option.value, option.label)
        end
        UIDropDownMenu_AddButton(info, level)
    end
end)

local refreshBtn = CreateFrame("Button", nil, filterFrame, "UIPanelButtonTemplate")
refreshBtn:SetSize(80, 24)
refreshBtn:SetPoint("LEFT", filterDropdown, "RIGHT", -10, 2)
refreshBtn:SetText("Refresh")
refreshBtn:SetScript("OnClick", function()
    MortalUI_LFGPanel:RequestActiveTabData()
end)

-- Listing rows ---------------------------------------------------
local ROW_HEIGHT = 78
local ROW_SPACING = 6

local function FormatRoleText(mask)
    if not mask or mask == 0 then
        return "|cFF777777No specific roles requested.|r"
    end
    local labels = {}
    for _, role in ipairs(ROLE_FLAGS) do
        if bit.band(mask, role.flag) ~= 0 then
            table.insert(labels, role.label)
        end
    end
    return string.format("|cFF00FF00Needs:|r %s", table.concat(labels, ", "))
end

local function AcquireRow(index)
    local row = LFGState.rowPool[index]
    if not row then
        row = CreateFrame("Frame", nil, content)
        row:SetHeight(ROW_HEIGHT)
        row.bg = row:CreateTexture(nil, "BACKGROUND")
        row.bg:SetAllPoints()
        row.bg:SetColorTexture(0.12, 0.12, 0.12, 0.92)
        row.border = CreateFrame("Frame", nil, row)
        row.border:SetPoint("TOPLEFT", -1, 1)
        row.border:SetPoint("BOTTOMRIGHT", 1, -1)
        row.border:SetBackdrop({ edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12 })
        row.border:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.7)
        
        row.title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        row.title:SetPoint("TOPLEFT", 8, -6)
        row.title:SetPoint("TOPRIGHT", -110, -6)
        row.title:SetJustifyH("LEFT")
        
        row.meta = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.meta:SetPoint("TOPLEFT", row.title, "BOTTOMLEFT", 0, -2)
        row.meta:SetPoint("RIGHT", row.title, "RIGHT")
        row.meta:SetJustifyH("LEFT")
        
        row.roles = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        row.roles:SetPoint("TOPLEFT", row.meta, "BOTTOMLEFT", 0, -4)
        row.roles:SetPoint("RIGHT", row.meta, "RIGHT")
        row.roles:SetJustifyH("LEFT")
        
        row.notes = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        row.notes:SetPoint("TOPLEFT", row.roles, "BOTTOMLEFT", 0, -2)
        row.notes:SetPoint("RIGHT", row.roles, "RIGHT")
        row.notes:SetJustifyH("LEFT")
        
        row.actionBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        row.actionBtn:SetSize(90, 26)
        row.actionBtn:SetPoint("TOPRIGHT", -10, -10)

        row.mapBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        row.mapBtn:SetSize(80, 20)
        row.mapBtn:SetPoint("BOTTOMRIGHT", -10, 8)
        row.mapBtn:SetText("Show Map")
        row.mapBtn:Hide()
        
        LFGState.rowPool[index] = row
    end
    row:Show()
    return row
end

local function ReleaseRows(startIndex)
    for i = startIndex, #LFGState.rowPool do
        local row = LFGState.rowPool[i]
        if row then
            row:Hide()
            row.data = nil
        end
    end
end

local function ConfigureRow(row, entry, isMine)
    local tag = entry.contentTag and entry.contentTag ~= "" and entry.contentTag or entry.contentType or "Unknown"
    local titleText = entry.title ~= "" and entry.title or "Untitled Run"
    row.title:SetText(string.format("|cFFFFFFFF%s|r  |cFFAAAAAA[%s]|r", titleText, tag))
    
    local minLevel = (entry.minLevel and entry.minLevel > 0) and entry.minLevel or "Any"
    local memberLine = string.format("%s • %d/%d players • Min Lv %s",
        entry.leaderName or "Unknown",
        entry.currentMembers or 1,
        entry.maxGroupSize or 5,
        minLevel
    )
    row.meta:SetText(memberLine)
    row.roles:SetText(FormatRoleText(entry.requiredRoles))
    
    if entry.notes and entry.notes ~= "" then
        row.notes:SetText(entry.notes)
    else
        row.notes:SetText("|cFF666666No notes provided.|r")
    end
    
    row.actionBtn:SetScript("OnClick", nil)
    if isMine then
        if entry.isActive == false then
            row.actionBtn:SetText("Closed")
            row.actionBtn:Disable()
        else
            row.actionBtn:SetText("Close")
            row.actionBtn:Enable()
            row.actionBtn:SetScript("OnClick", function()
                SendLFGRequest("CloseListing", entry.id)
            end)
        end
    else
        row.actionBtn:SetText("Apply")
        row.actionBtn:Enable()
        row.actionBtn:SetScript("OnClick", function()
            SendLFGRequest("ApplyToListing", { listingId = entry.id })
        end)
    end

    if entry.entranceMap and entry.entranceX and entry.entranceY then
        row.mapBtn:Show()
        row.mapBtn:SetScript("OnClick", function()
            local pinLabel = entry.title ~= "" and entry.title or (entry.contentTag or "Dungeon")
            if not MortalAddon or not MortalAddon.UpdateMapPin then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r HandyNotes is required for map pins.")
                return
            end
            MortalAddon:UpdateMapPin(entry.entranceMap, entry.entranceX, entry.entranceY, 1, pinLabel, entry.contentTag or "")
            DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff00ff00[MortalUI]|r Added map pin for %s (map %d).", pinLabel, entry.entranceMap))
        end)
    else
        row.mapBtn:Hide()
        row.mapBtn:SetScript("OnClick", nil)
    end
end

-- Creation dialog ------------------------------------------------
local function BuildCreateDialog()
    local frame = CreateFrame("Frame", "MortalUI_LFGCreateDialog", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(360, 420)
    frame:SetPoint("CENTER")
    frame:Hide()
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetPoint("TOP", 0, -15)
    frame.title:SetText("Create LFG Listing")
    
    local labels = {
        { key = "title", text = "Title", width = 220, max = 60 },
        { key = "contentTag", text = "Content Tag", width = 220, max = 40 },
        { key = "minLevel", text = "Min Level", width = 80, max = 2, numeric = true },
        { key = "maxSize", text = "Max Group Size", width = 80, max = 2, numeric = true },
    }
    
    local inputs = {}
    local previous
    for _, info in ipairs(labels) do
        local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("TOPLEFT", previous or frame.title, "BOTTOMLEFT", 0, previous and -18 or -20)
        label:SetText(info.text)
        
        local box = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
        box:SetSize(info.width, 20)
        box:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
        box:SetAutoFocus(false)
        box:SetMaxLetters(info.max)
        if info.numeric then
            box:SetNumeric(true)
        end
        inputs[info.key] = box
        previous = box
    end
    
    -- Content type dropdown
    local ctLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ctLabel:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 180, -20)
    ctLabel:SetText("Content Type")
    
    local typeDropdown = CreateFrame("Frame", "MortalUI_LFGCreateType", frame, "UIDropDownMenuTemplate")
    typeDropdown:SetPoint("TOPLEFT", ctLabel, "BOTTOMLEFT", -10, -6)
    UIDropDownMenu_SetWidth(typeDropdown, 140)
    UIDropDownMenu_SetText(typeDropdown, "Dungeons")
    frame.contentType = "dungeon"
    
    UIDropDownMenu_Initialize(typeDropdown, function(_, level)
        local info = UIDropDownMenu_CreateInfo()
        for _, option in ipairs(CONTENT_TYPES) do
            if option.value then
                info.text = option.label
                info.checked = option.value == frame.contentType
                info.func = function()
                    frame.contentType = option.value
                    UIDropDownMenu_SetText(typeDropdown, option.label)
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end)
    
    -- Notes box
    local notesLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    notesLabel:SetPoint("TOPLEFT", inputs.maxSize, "BOTTOMLEFT", 0, -18)
    notesLabel:SetText("Notes")
    
    local notesScroll = CreateFrame("ScrollFrame", "MortalUI_LFGNotesScroll", frame, "UIPanelScrollFrameTemplate")
    notesScroll:SetPoint("TOPLEFT", notesLabel, "BOTTOMLEFT", -6, -6)
    notesScroll:SetPoint("RIGHT", frame, -30, 0)
    notesScroll:SetHeight(90)
    
    local notesBox = CreateFrame("EditBox", nil, notesScroll)
    notesBox:SetMultiLine(true)
    notesBox:SetFontObject("GameFontHighlightSmall")
    notesBox:SetWidth(260)
    notesBox:SetAutoFocus(false)
    notesBox:SetMaxLetters(160)
    notesScroll:SetScrollChild(notesBox)
    frame.notesBox = notesBox
    
    -- Role checkboxes
    local rolesLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rolesLabel:SetPoint("TOPLEFT", notesScroll, "BOTTOMLEFT", 6, -12)
    rolesLabel:SetText("Roles Needed")
    
    frame.roleChecks = {}
    for i, role in ipairs(ROLE_FLAGS) do
        local check = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
        check.text:SetText(role.label)
        local column = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        check:SetPoint("TOPLEFT", rolesLabel, "BOTTOMLEFT", column * 140, -8 - (row * 24))
        frame.roleChecks[role.flag] = check
    end
    
    local function GatherPayload()
        local payload = {
            title = inputs.title:GetText() or "",
            contentTag = inputs.contentTag:GetText() or "",
            minLevel = tonumber(inputs.minLevel:GetText()),
            maxGroupSize = tonumber(inputs.maxSize:GetText()),
            notes = notesBox:GetText() or "",
            contentType = frame.contentType or "dungeon",
        }
        local mask = 0
        for flag, check in pairs(frame.roleChecks) do
            if check:GetChecked() then
                mask = mask + flag
            end
        end
        payload.requiredRoles = mask
        return payload
    end
    
    local publishBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    publishBtn:SetSize(120, 26)
    publishBtn:SetPoint("BOTTOMRIGHT", -10, 10)
    publishBtn:SetText("Publish")
    publishBtn:SetScript("OnClick", function()
        SendLFGRequest("CreateListing", GatherPayload())
        frame:Hide()
    end)
    
    local cancelBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    cancelBtn:SetSize(90, 26)
    cancelBtn:SetPoint("RIGHT", publishBtn, "LEFT", -10, 0)
    cancelBtn:SetText("Cancel")
    cancelBtn:SetScript("OnClick", function()
        frame:Hide()
    end)
    
    frame.inputs = inputs
    return frame
end

local createDialog = BuildCreateDialog()

local createBtn = CreateFrame("Button", nil, MortalUI_LFGPanel, "UIPanelButtonTemplate")
createBtn:SetSize(140, 30)
createBtn:SetPoint("BOTTOMRIGHT", -10, 15)
createBtn:SetText("Create Listing")
createBtn:SetScript("OnClick", function()
    createDialog:Show()
end)

-- Panel API ------------------------------------------------------
function MortalUI_LFGPanel:SwitchTab(key)
    LFGState.activeKey = key
    for tabKey, tab in pairs(tabs.byKey) do
        local active = tabKey == key
        tab.isActive = active
        local shade = active and 0.4 or 0.2
        tab.bg:SetColorTexture(shade, shade, shade, 1)
    end
    self:RequestActiveTabData()
end

function MortalUI_LFGPanel:RequestActiveTabData()
    local key = LFGState.activeKey
    local tab = tabs.byKey[key]
    if tab and tab.config.request == "RequestListings" then
        local payload
        if LFGState.filters.contentType then
            payload = { contentType = LFGState.filters.contentType }
        end
        SendLFGRequest("RequestListings", payload)
    elseif tab and tab.config.request == "RequestMyListings" then
        SendLFGRequest("RequestMyListings")
    else
        self:RefreshList()
    end
end

function MortalUI_LFGPanel:RefreshList()
    local key = LFGState.activeKey
    local entries
    if key == "mine" then
        entries = LFGState.myListings
        if not entries or #entries == 0 then
            ShowPlaceholder("You do not have any active listings.")
            ReleaseRows(1)
            return
        end
    elseif key == "favorites" then
        ShowPlaceholder("Favorites are coming soon.")
        ReleaseRows(1)
        return
    else
        entries = LFGState.listings
        if not entries or #entries == 0 then
            ShowPlaceholder("No listings match this filter. Try again soon.")
            ReleaseRows(1)
            return
        end
    end
    
    HidePlaceholder()
    for index, entry in ipairs(entries) do
        local row = AcquireRow(index)
        row:SetPoint("TOPLEFT", 0, -((index - 1) * (ROW_HEIGHT + ROW_SPACING)))
        row:SetPoint("TOPRIGHT", 0, -((index - 1) * (ROW_HEIGHT + ROW_SPACING)))
        ConfigureRow(row, entry, key == "mine")
    end
    local totalHeight = #entries * (ROW_HEIGHT + ROW_SPACING) + 10
    content:SetHeight(math.max(totalHeight, scrollFrame:GetHeight()))
    ReleaseRows(#entries + 1)
end

function MortalUI_LFGPanel:ShowPanel()
    self:Show()
    self:SwitchTab(LFGState.activeKey or "all")
end

-- AIO wiring -----------------------------------------------------
AIO.RegisterEvent(LFG_CHANNEL, function(_, action, payload)
    if action == "ReceiveListings" and type(payload) == "table" then
        if payload.tab == "mine" then
            LFGState.myListings = payload.listings or {}
        else
            LFGState.listings = payload.listings or {}
        end
        MortalUI_LFGPanel:RefreshList()
    elseif action == "OperationResult" and type(payload) == "table" then
        DEFAULT_CHAT_FRAME:AddMessage(string.format("|cFF00FF00[LFG]|r %s", payload.message or "Action completed."))
        if payload.action == "CreateListing" then
            SendLFGRequest("RequestListings")
            SendLFGRequest("RequestMyListings")
        elseif payload.action == "CloseListing" and LFGState.activeKey == "mine" then
            SendLFGRequest("RequestMyListings")
        end
    end
end)

-- Slash command --------------------------------------------------
SLASH_MORTALLFG1 = "/lfg"
SLASH_MORTALLFG2 = "/mortal_lfg"
SlashCmdList["MORTALLFG"] = function()
    MortalUI_LFGPanel:ShowPanel()
end

print("[MortalUI] LFG Panel loaded - Use /lfg to open")
