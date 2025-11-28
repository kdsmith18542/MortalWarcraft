-- ==================================================
-- Mortal UI: PvP & Warfront Panel
-- Spec 18: LFG System, Tavern Boards, Warfront & Hellgate UI
-- ==================================================
-- Replaces the Battleground Finder button with War & PvP Panel
-- ==================================================

local AIO = rawget(_G, "AIO")
if not AIO then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r PvP panel requires mod-AIO.")
    return
end

local PvPState = {
    warfronts = {},
    hellgates = {},
    season = {},
    bounties = {},
    sieges = {},
    politics = {},
    frames = {}
}

local CHANNEL = "MortalPvP"
local MortalAddon = LibStub and LibStub("AceAddon-3.0"):GetAddon("MortalUI", true)

local function RequestWarfronts()
    AIO.Handle(CHANNEL, "RequestWarfronts")
end

local function RequestHellgates()
    AIO.Handle(CHANNEL, "RequestHellgates")
end

local function RequestSeason()
    AIO.Handle(CHANNEL, "RequestSeasonStats")
end

local function RequestBounties()
    AIO.Handle(CHANNEL, "RequestBounties")
end

local function RequestSieges()
    AIO.Handle(CHANNEL, "RequestSieges")
end

local function RequestGuildPolitics()
    AIO.Handle(CHANNEL, "RequestGuildPolitics")
end

local MortalUI_PvPPanel = CreateFrame("Frame", "MortalUI_PvPPanel", UIParent)
MortalUI_PvPPanel:SetFrameStrata("HIGH")
MortalUI_PvPPanel:SetWidth(550)
MortalUI_PvPPanel:SetHeight(450)
MortalUI_PvPPanel:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
MortalUI_PvPPanel:Hide()
MortalUI_PvPPanel:SetMovable(true)
MortalUI_PvPPanel:EnableMouse(true)
MortalUI_PvPPanel:RegisterForDrag("LeftButton")
MortalUI_PvPPanel:SetScript("OnDragStart", function(self) self:StartMoving() end)
MortalUI_PvPPanel:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Background
local bg = MortalUI_PvPPanel:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0.1, 0.05, 0.05, 0.95)
MortalUI_PvPPanel.bg = bg

-- Title
local title = MortalUI_PvPPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -15)
title:SetText("|cFFFF0000War & PvP|r")
MortalUI_PvPPanel.title = title

-- Close button
local closeBtn = CreateFrame("Button", nil, MortalUI_PvPPanel, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)
closeBtn:SetScript("OnClick", function() MortalUI_PvPPanel:Hide() end)

-- Tabs
local pvpTabs = {}
local function CreatePvPTab(name, xOffset)
    local tab = CreateFrame("Button", "MortalUI_PvPTab_" .. name, MortalUI_PvPPanel)
    tab:SetWidth(120)
    tab:SetHeight(30)
    tab:SetPoint("TOPLEFT", MortalUI_PvPPanel, "TOPLEFT", xOffset, -45)
    
    local bg = tab:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.2, 0.1, 0.1, 1)
    tab.bg = bg
    
    local text = tab:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("CENTER")
    text:SetText(name)
    tab.text = text
    
    tab:SetScript("OnClick", function()
        for _, t in pairs(pvpTabs) do
            t.bg:SetColorTexture(0.2, 0.1, 0.1, 1)
        end
        tab.bg:SetColorTexture(0.4, 0.2, 0.2, 1)
        MortalUI_PvPPanel:SwitchTab(name)
    end)
    
    tab:SetScript("OnEnter", function() tab.bg:SetColorTexture(0.3, 0.15, 0.15, 1) end)
    tab:SetScript("OnLeave", function() 
        if tab ~= pvpTabs.active then
            tab.bg:SetColorTexture(0.2, 0.1, 0.1, 1)
        end
    end)
    
    pvpTabs[name] = tab
    return tab
end

CreatePvPTab("Warfronts", 10)
CreatePvPTab("Sieges", 140)
CreatePvPTab("My Commitments", 270)
CreatePvPTab("Politics", 400)
CreatePvPTab("Hellgates", 530)
CreatePvPTab("My Season", 660)
CreatePvPTab("Bounties", 790)
pvpTabs.active = pvpTabs["Warfronts"]
pvpTabs.active.bg:SetColorTexture(0.4, 0.2, 0.2, 1)

-- Content area
local contentFrame = CreateFrame("Frame", nil, MortalUI_PvPPanel)
contentFrame:SetPoint("TOPLEFT", 10, -80)
contentFrame:SetPoint("BOTTOMRIGHT", -10, 50)
MortalUI_PvPPanel.contentFrame = contentFrame

-- Tab switching
local function ReleaseChildren(frame)
    for i = 1, frame:GetNumChildren() do
        local child = select(i, frame:GetChildren())
        if child then
            child:Hide()
        end
    end
end

function MortalUI_PvPPanel:SwitchTab(tabName)
    ReleaseChildren(contentFrame)
    if tabName == "Warfronts" then
        RequestWarfronts()
        self:ShowWarfrontsTab()
    elseif tabName == "Sieges" then
        RequestSieges()
        self:ShowSiegesTab()
    elseif tabName == "My Commitments" then
        RequestSieges() -- Reuse siege data
        self:ShowCommitmentsTab()
    elseif tabName == "Politics" then
        RequestGuildPolitics()
        self:ShowPoliticsTab()
    elseif tabName == "Hellgates" then
        RequestHellgates()
        self:ShowHellgatesTab()
    elseif tabName == "My Season" then
        RequestSeason()
        self:ShowSeasonTab()
    elseif tabName == "Bounties" then
        RequestBounties()
        self:ShowBountiesTab()
    end
end

-- Warfronts tab
local rowHeight = 70

local function AcquireRow(pool, parent)
    local row = table.remove(pool.free) or CreateFrame("Frame", nil, parent, "BackdropTemplate")
    row:SetHeight(rowHeight)
    row.bg = row.bg or row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints()
    row.bg:SetColorTexture(0.15, 0.05, 0.05, 0.9)
    row.title = row.title or row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.title:SetPoint("TOPLEFT", 8, -6)
    row.title:SetPoint("RIGHT", -8, 0)
    row.meta = row.meta or row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    row.meta:SetPoint("TOPLEFT", row.title, "BOTTOMLEFT", 0, -4)
    row.meta:SetPoint("RIGHT", row.title, "RIGHT")
    row.meta:SetJustifyH("LEFT")
    row.extra = row.extra or row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    row.extra:SetPoint("TOPLEFT", row.meta, "BOTTOMLEFT", 0, -3)
    row.extra:SetPoint("RIGHT", row.meta, "RIGHT")
    row.extra:SetJustifyH("LEFT")
    return row
end

local function EnsureScrollContainer(key)
    if PvPState.frames[key] then
        return PvPState.frames[key]
    end

    local scroll = CreateFrame("ScrollFrame", nil, contentFrame, "UIPanelScrollFrameTemplate")
    scroll:SetAllPoints()
    local child = CreateFrame("Frame", nil, scroll)
    child:SetWidth(510)
    child:SetHeight(310)
    scroll:SetScrollChild(child)

    PvPState.frames[key] = {
        scroll = scroll,
        child = child,
        pool = { free = {}, active = {} }
    }
    return PvPState.frames[key]
end

local function AttachButton(row, config, entry)
    local buttonConfig = config
    if type(config) == "function" then
        buttonConfig = config(entry)
    end

    if not buttonConfig then
        if row.actionBtn then
            row.actionBtn:Hide()
        end
        return
    end

    row.actionBtn = row.actionBtn or CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
    row.actionBtn:SetSize(90, 20)
    row.actionBtn:SetPoint("BOTTOMRIGHT", -5, 5)
    row.actionBtn:SetScript("OnClick", function()
        buttonConfig.callback(entry)
    end)
    row.actionBtn:SetText(type(buttonConfig.label) == "function" and buttonConfig.label(entry) or (buttonConfig.label or "Show"))
    row.actionBtn:Show()
end

local function RenderList(key, data, formatter, buttonConfig)
    local frame = EnsureScrollContainer(key)
    for _, row in ipairs(frame.pool.active) do
        row:Hide()
        table.insert(frame.pool.free, row)
    end
    wipe(frame.pool.active)

    if not data or #data == 0 then
        if not frame.empty then
            frame.empty = frame.child:CreateFontString(nil, "OVERLAY", "GameFontDisable")
            frame.empty:SetPoint("TOP", 0, -20)
        end
        frame.empty:SetText("No data available.")
        frame.empty:Show()
        return
    elseif frame.empty then
        frame.empty:Hide()
    end

    local totalHeight = 0
    for index, entry in ipairs(data) do
        local row = AcquireRow(frame.pool, frame.child)
        formatter(row, entry)
        AttachButton(row, buttonConfig, entry)
        row:SetPoint("TOPLEFT", 0, -((index - 1) * (rowHeight + 5)))
        row:SetPoint("TOPRIGHT", 0, -((index - 1) * (rowHeight + 5)))
        row:Show()
        table.insert(frame.pool.active, row)
        totalHeight = totalHeight + rowHeight + 5
    end
    frame.child:SetHeight(math.max(totalHeight, 310))
end

local function DropMapPin(mapId, x, y, pinType, label, data)
    if not (MortalAddon and MortalAddon.UpdateMapPin) then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r Map pins unavailable (HandyNotes missing).")
        return
    end

    MortalAddon:UpdateMapPin(mapId, x, y, pinType or 4, label, data)
    DEFAULT_CHAT_FRAME:AddMessage(string.format("|cff00ff00[MortalUI]|r Added map pin for %s (map %d).", label or "Warfront", mapId or 0))
end

local function MakeWarfrontButton(entry)
    return {
        label = "Show Map",
        callback = function()
            if not entry.map or not entry.x or not entry.y then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r No portal coordinates for this warfront.")
                return
            end
            DropMapPin(entry.map, entry.x, entry.y, 4, entry.name or "Warfront", entry.guildId)
        end
    }
end

local function MakeHellgateButton(entry)
    return {
        label = "Show Map",
        callback = function()
            if not entry.map or entry.map == 0 or not entry.x or not entry.y then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r No entrance coordinates for this hellgate.")
                return
            end
            DropMapPin(entry.map, entry.x, entry.y, 3, entry.name or "Hellgate", entry.id)
        end
    }
end

local function SetWaypointToWarCamp(entry)
    -- Request war camp coordinates from server
    if entry.siegeId and entry.zoneId then
        local mapId = entry.zoneId
        local x, y = entry.warCampX or 0, entry.warCampY or 0
        
        -- Fallback to zone-specific defaults if not provided
        if x == 0 or y == 0 then
            if mapId == 4197 then -- Wintergrasp
                x, y = 5100, 2500 -- Approximate war camp location
            else
                -- Use zone center as fallback
                x, y = 0, 0
            end
        end
        
        if MortalAddon and MortalAddon.UpdateMapPin then
            local label = string.format("War Camp - %s", entry.strongholdName or "Siege")
            MortalAddon:UpdateMapPin(mapId, x, y, 3, label, entry.siegeId)
            DEFAULT_CHAT_FRAME:AddMessage(string.format(
                "|cff00ff00[MortalUI]|r Added waypoint to War Camp for %s siege.",
                entry.strongholdName or "Unknown"
            ))
            
            -- Also try to set as TomTom waypoint if available (optional)
            if TomTom then
                TomTom:AddWaypoint(mapId, x/100, y/100, {
                    title = label,
                    persistent = false,
                    minimap = true,
                    world = true
                })
            end
        else
            -- HandyNotes should be embedded, but check if it failed to load
            if not _G.HandyNotes then
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r Map pins unavailable (HandyNotes failed to load).")
            else
                DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r Map pins unavailable (MortalUI map pin system not initialized).")
            end
        end
    end
end

local function MakeSiegeButton(entry)
    if entry.isActive and entry.siegeId then
        return {
            label = "Enter",
            callback = function()
                DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[MortalUI]|r Use a Siege Portal to enter the active siege.")
            end
        }
    else
        return {
            label = "Set Waypoint",
            callback = function()
                SetWaypointToWarCamp(entry)
            end
        }
    end
end

function MortalUI_PvPPanel:ShowWarfrontsTab()
    RenderList("warfronts", PvPState.warfronts, function(row, entry)
        local fighters = entry.activePlayers or 0
        local statusLabel = string.upper(entry.status or "open")
        row.title:SetText(string.format("|cFFFF5555%s|r", entry.name))
        row.meta:SetText(string.format("Controlled by: %s | Status: %s | Fighters: %d | Rewards W:%d I:%d",
            entry.guildName or "Unclaimed", statusLabel, fighters, entry.woodReward or 0, entry.ironReward or 0))

        local now = time()
        local lines = {}
        if entry.status == "preparing" and entry.nextOpenTime and entry.nextOpenTime > now then
            local minutes = math.max(1, math.floor((entry.nextOpenTime - now) / 60))
            table.insert(lines, string.format("Opens in %d min", minutes))
        elseif entry.shipmentETA and entry.shipmentETA > 0 then
            local minutes = math.max(1, math.floor(entry.shipmentETA / 60))
            table.insert(lines, string.format("Next shipment in %d min", minutes))
        elseif entry.shipmentReady then
            table.insert(lines, "Shipment ready")
        end

        if entry.lastResult and entry.lastResult ~= "" then
            table.insert(lines, entry.lastResult)
        end

        if #lines == 0 then
            table.insert(lines, "Map " .. (entry.map or 0))
        else
            table.insert(lines, "Map " .. (entry.map or 0))
        end

        row.extra:SetText(table.concat(lines, " • "))
    end, MakeWarfrontButton)
end

-- My Commitments tab (shows player's registered sieges)
function MortalUI_PvPPanel:ShowCommitmentsTab()
    if not PvPState.frames.commitments then
        local holder = CreateFrame("Frame", nil, contentFrame)
        holder:SetAllPoints()
        holder.scroll = CreateFrame("ScrollFrame", nil, holder, "UIPanelScrollFrameTemplate")
        holder.scroll:SetAllPoints()
        local child = CreateFrame("Frame", nil, holder.scroll)
        child:SetWidth(510)
        child:SetHeight(310)
        holder.scroll:SetScrollChild(child)
        holder.child = child
        holder.entries = {}
        PvPState.frames.commitments = holder
    end
    
    local holder = PvPState.frames.commitments
    holder:Show()
    
    -- Clear existing entries
    for _, entry in ipairs(holder.entries) do
        entry:Hide()
    end
    wipe(holder.entries)
    
    -- Filter sieges where player is registered
    local playerGuildId = GetGuildInfo("player")
    local committedSieges = {}
    
    for _, siege in ipairs(PvPState.sieges or {}) do
        -- Check if player's guild is involved
        if siege.attackerGuildId == playerGuildId or siege.defenderGuildId == playerGuildId then
            table.insert(committedSieges, siege)
        end
    end
    
    if #committedSieges == 0 then
        if not holder.empty then
            holder.empty = holder.child:CreateFontString(nil, "OVERLAY", "GameFontDisable")
            holder.empty:SetPoint("TOP", 0, -20)
        end
        holder.empty:SetText("You are not registered for any sieges.\nVisit a Siege Marshal to sign up!")
        holder.empty:Show()
        return
    end
    
    if holder.empty then
        holder.empty:Hide()
    end
    
    -- Display committed sieges
    local totalHeight = 0
    for index, siege in ipairs(committedSieges) do
        local row = CreateFrame("Frame", nil, holder.child)
        row:SetHeight(80)
        row:SetPoint("TOPLEFT", 0, -totalHeight)
        row:SetPoint("TOPRIGHT", 0, -totalHeight)
        
        local bg = row:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0.15, 0.05, 0.05, 0.9)
        row.bg = bg
        
        local title = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        title:SetPoint("TOPLEFT", 8, -6)
        title:SetPoint("RIGHT", -8, 0)
        title:SetText(string.format("|cFFFF5555%s|r", siege.strongholdName or "Unknown"))
        
        local now = time()
        local startTime = siege.startTime or 0
        local minutesUntil = startTime > now and math.floor((startTime - now) / 60) or 0
        
        local side = "Unknown"
        if siege.attackerGuildId == playerGuildId then
            side = "|cFFFF0000Attacker|r"
        elseif siege.defenderGuildId == playerGuildId then
            side = "|cFF0000FFDefender|r"
        end
        
        local meta = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        meta:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        meta:SetPoint("RIGHT", title, "RIGHT")
        meta:SetText(string.format("Side: %s | Starts in %d min", side, minutesUntil))
        
        local waypointBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        waypointBtn:SetSize(100, 20)
        waypointBtn:SetPoint("BOTTOMRIGHT", -5, 5)
        waypointBtn:SetText("Set Waypoint")
        waypointBtn:SetScript("OnClick", function()
            SetWaypointToWarCamp(siege)
        end)
        
        table.insert(holder.entries, row)
        totalHeight = totalHeight + 85
    end
    
    holder.child:SetHeight(math.max(totalHeight, 310))
end

-- Sieges tab
function MortalUI_PvPPanel:ShowSiegesTab()
    RenderList("sieges", PvPState.sieges, function(row, entry)
        local now = time()
        local startTime = entry.startTime or 0
        local minutesUntil = startTime > now and math.floor((startTime - now) / 60) or 0
        
        local statusColor = "|cFFFF5555"
        local statusText = "UPCOMING"
        if entry.isActive then
            statusColor = "|cFFFF0000"
            statusText = "ACTIVE"
        elseif entry.lifecycleStage == "lock_in" then
            statusColor = "|cFFFFFF00"
            statusText = "LOCK-IN"
        elseif entry.lifecycleStage == "signup" then
            statusColor = "|cFF00FF00"
            statusText = "SIGNUP"
        end
        
        row.title:SetText(string.format("%s%s|r", statusColor, entry.strongholdName or "Unknown Stronghold"))
        
        local attackerName = entry.attackerGuildName or "Unknown"
        local defenderName = entry.defenderGuildName or "Unknown"
        local attackerCount = entry.attackerCount or 0
        local defenderCount = entry.defenderCount or 0
        
        row.meta:SetText(string.format("%s vs %s | %s | %d vs %d players",
            attackerName, defenderName, statusText, attackerCount, defenderCount))
        
        local lines = {}
        if minutesUntil > 0 then
            table.insert(lines, string.format("Starts in %d min", minutesUntil))
        elseif entry.isActive then
            table.insert(lines, "Battle in progress")
        end
        
        if entry.minimumLevel and entry.minimumLevel > 0 then
            table.insert(lines, string.format("Min Level: %d", entry.minimumLevel))
        end
        
        if entry.zoneId then
            table.insert(lines, string.format("Zone: %d", entry.zoneId))
        end
        
        if #lines == 0 then
            table.insert(lines, "Full loot zone")
        else
            table.insert(lines, "Full loot zone")
        end
        
        row.extra:SetText(table.concat(lines, " • "))
    end, MakeSiegeButton)
end

-- Hellgates tab
function MortalUI_PvPPanel:ShowHellgatesTab()
    RenderList("hellgates", PvPState.hellgates, function(row, entry)
        local status = string.upper(entry.status or "IDLE")
        local queue1 = entry.queueGroup1 or 0
        local queue2 = entry.queueGroup2 or 0
        row.title:SetText(string.format("|cFFFFAA00%s|r", entry.name))
        row.meta:SetText(string.format("Players: %d-%d | Queue: %d vs %d | Active matches: %d",
            entry.minPlayers, entry.maxPlayers, queue1, queue2, entry.activeMatches or 0))
        local mapLabel = entry.map ~= 0 and entry.map or entry.instanceMap or 0
        row.extra:SetText(string.format("Status: %s • Active players: %d • Map %d",
            status, entry.activePlayers or 0, mapLabel))
    end, MakeHellgateButton)
end

-- Politics tab
function MortalUI_PvPPanel:ShowPoliticsTab()
    local politics = PvPState.politics or {}
    local playerGuildId = GetGuildInfo("player")
    
    if not playerGuildId or playerGuildId == 0 then
        RenderList("politics", {}, function(row, entry)
            row.title:SetText("|cFFFF5555No Guild|r")
            row.meta:SetText("You must be in a guild to view politics")
            row.extra:SetText("")
        end)
        return
    end
    
    local relations = {}
    
    -- Add alliances
    if politics.allies then
        for _, ally in ipairs(politics.allies) do
            table.insert(relations, {
                type = "alliance",
                guildId = ally.guildId,
                guildName = ally.guildName,
                startTime = ally.startTime
            })
        end
    end
    
    -- Add wars
    if politics.wars then
        for _, war in ipairs(politics.wars) do
            table.insert(relations, {
                type = "war",
                guildId = war.guildId,
                guildName = war.guildName,
                startTime = war.startTime,
                endTime = war.endTime
            })
        end
    end
    
    -- Add truces
    if politics.truces then
        for _, truce in ipairs(politics.truces) do
            table.insert(relations, {
                type = "truce",
                guildId = truce.guildId,
                guildName = truce.guildName,
                startTime = truce.startTime,
                endTime = truce.endTime
            })
        end
    end
    
    if #relations == 0 then
        RenderList("politics", {}, function(row, entry)
            row.title:SetText("|cFFAAAAAANo Active Relations|r")
            row.meta:SetText("Your guild has no alliances, wars, or truces")
            row.extra:SetText("Visit a Guild Steward to manage relations")
        end)
        return
    end
    
    RenderList("politics", relations, function(row, entry)
        local statusColor = "|cFFFFFFFF"
        local statusText = "NEUTRAL"
        local icon = ""
        
        if entry.type == "alliance" then
            statusColor = "|cFF00AAFF"
            statusText = "ALLY"
            icon = "|TInterface\\GroupFrame\\UI-Group-MasterLooter:16:16|t "
        elseif entry.type == "war" then
            statusColor = "|cFFFF0000"
            statusText = "AT WAR"
            icon = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:16:16|t "
        elseif entry.type == "truce" then
            statusColor = "|cFFFFFF00"
            statusText = "TRUCE"
            icon = "|TInterface\\Calendar\\MeetingIcon:16:16|t "
        end
        
        row.title:SetText(string.format("%s%s%s|r", icon, statusColor, entry.guildName or "Unknown"))
        
        local metaLines = {}
        table.insert(metaLines, statusText)
        
        if entry.startTime and entry.startTime > 0 then
            local daysAgo = math.floor((time() - entry.startTime) / 86400)
            if daysAgo == 0 then
                table.insert(metaLines, "Started today")
            elseif daysAgo == 1 then
                table.insert(metaLines, "Started yesterday")
            else
                table.insert(metaLines, string.format("Started %d days ago", daysAgo))
            end
        end
        
        row.meta:SetText(table.concat(metaLines, " • "))
        
        local extraLines = {}
        if entry.endTime and entry.endTime > 0 then
            local timeLeft = entry.endTime - time()
            if timeLeft > 0 then
                local hoursLeft = math.floor(timeLeft / 3600)
                local minutesLeft = math.floor((timeLeft % 3600) / 60)
                if hoursLeft > 0 then
                    table.insert(extraLines, string.format("Expires in %dh %dm", hoursLeft, minutesLeft))
                else
                    table.insert(extraLines, string.format("Expires in %dm", minutesLeft))
                end
            else
                table.insert(extraLines, "Expired")
            end
        elseif entry.type == "war" then
            table.insert(extraLines, "Indefinite war")
        elseif entry.type == "alliance" then
            table.insert(extraLines, "Active alliance")
        end
        
        row.extra:SetText(table.concat(extraLines, " • "))
    end)
end

-- My Season tab
function MortalUI_PvPPanel:ShowSeasonTab()
    if not PvPState.frames.season then
        local holder = CreateFrame("Frame", nil, contentFrame)
        holder:SetAllPoints()
        holder.entries = {}
        local labels = {
            "Season Rating:",
            "Lifetime Kills:",
            "Honor Points:",
            "Bounties Claimed:",
            "Time in Red Zones:"
        }
        for i, text in ipairs(labels) do
            local label = holder:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            label:SetPoint("TOPLEFT", 20, -30 - (i * 30))
            label:SetText(text)
            local value = holder:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            value:SetPoint("LEFT", label, "RIGHT", 10, 0)
            holder.entries[i] = value
        end
        PvPState.frames.season = holder
    end
    PvPState.frames.season:Show()
    local stats = PvPState.season or {}
    local values = {
        stats.rating or "--",
        stats.kills or "--",
        stats.honor or "--",
        stats.bountyClaims or "--",
        stats.redZoneTime and string.format("%d min", math.floor(stats.redZoneTime / 60)) or "--"
    }
    for i, value in ipairs(values) do
        PvPState.frames.season.entries[i]:SetText(value)
    end
end

-- Bounties tab
function MortalUI_PvPPanel:ShowBountiesTab()
    RenderList("bounties", PvPState.bounties, function(row, entry)
        row.title:SetText(string.format("|cFFFF0000%s|r", entry.name))
        row.meta:SetText(string.format("Notoriety: %d", entry.notoriety))
        row.extra:SetText(string.format("GUID: %d", entry.guid))
    end)
end

-- Notification system for sieges
local SiegeNotifications = {
    notified15min = {},
    notified5min = {},
    checkTimer = 0,
    popupFrame = nil
}

-- Create popup notification frame
local function CreateNotificationPopup()
    if SiegeNotifications.popupFrame then
        return SiegeNotifications.popupFrame
    end
    
    local popup = CreateFrame("Frame", "MortalUISiegeNotification", UIParent)
    popup:SetSize(400, 120)
    popup:SetPoint("TOP", UIParent, "TOP", 0, -100)
    popup:SetFrameStrata("DIALOG")
    popup:SetMovable(true)
    popup:EnableMouse(true)
    popup:RegisterForDrag("LeftButton")
    popup:SetScript("OnDragStart", function(self) self:StartMoving() end)
    popup:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    popup:Hide()
    
    -- Background
    local bg = popup:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.1, 0.05, 0.05, 0.95)
    popup.bg = bg
    
    -- Border
    local border = popup:CreateTexture(nil, "BORDER")
    border:SetAllPoints()
    border:SetColorTexture(1, 0, 0, 0.8)
    popup.border = border
    
    -- Title
    local title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("|cffFF0000SIEGE ALERT|r")
    popup.title = title
    
    -- Message
    local message = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    message:SetPoint("TOP", title, "BOTTOM", 0, -10)
    message:SetPoint("LEFT", 10, 0)
    message:SetPoint("RIGHT", -10, 0)
    message:SetJustifyH("CENTER")
    message:SetJustifyV("TOP")
    popup.message = message
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function()
        popup:Hide()
    end)
    
    SiegeNotifications.popupFrame = popup
    return popup
end

-- Show notification popup
local function ShowNotificationPopup(text, duration)
    local popup = CreateNotificationPopup()
    if not popup then
        return
    end
    
    popup.message:SetText(text)
    popup:Show()
    
    -- Play sound
    PlaySound("RaidWarning", "Master")
    
    -- Auto-hide after duration
    if duration then
        C_Timer.After(duration, function()
            popup:Hide()
        end)
    end
end

local function CheckSiegeNotifications()
    if not PvPState.sieges or #PvPState.sieges == 0 then
        return
    end
    
    local now = time()
    local playerGuildId = GetGuildInfo("player")
    
    for _, siege in ipairs(PvPState.sieges) do
        if siege.startTime and siege.startTime > 0 then
            -- Only notify if player's guild is involved
            if siege.attackerGuildId ~= playerGuildId and siege.defenderGuildId ~= playerGuildId then
                goto continue
            end
            
            local timeUntil = siege.startTime - now
            local siegeId = siege.siegeId or 0
            local strongholdName = siege.strongholdName or "Unknown Stronghold"
            
            -- 15 minute warning
            if timeUntil <= 900 and timeUntil > 300 and not SiegeNotifications.notified15min[siegeId] then
                local chatMsg = string.format(
                    "|cffFF0000[SIEGE ALERT]:|r Siege at %s starts in 15 minutes!",
                    strongholdName
                )
                DEFAULT_CHAT_FRAME:AddMessage(chatMsg)
                
                local popupMsg = string.format(
                    "Siege at %s\nstarts in 15 minutes!",
                    strongholdName
                )
                ShowNotificationPopup(popupMsg, 10)
                
                SiegeNotifications.notified15min[siegeId] = true
            end
            
            -- 5 minute warning
            if timeUntil <= 300 and timeUntil > 0 and not SiegeNotifications.notified5min[siegeId] then
                local chatMsg = string.format(
                    "|cffFF0000[SIEGE ALERT]:|r Siege at %s starts in 5 minutes! Enter staging grounds now!",
                    strongholdName
                )
                DEFAULT_CHAT_FRAME:AddMessage(chatMsg)
                
                local popupMsg = string.format(
                    "Siege at %s\nstarts in 5 minutes!\nEnter staging grounds now!",
                    strongholdName
                )
                ShowNotificationPopup(popupMsg, 15)
                
                SiegeNotifications.notified5min[siegeId] = true
            end
        end
        ::continue::
    end
end

-- Create notification frame
local notificationFrame = CreateFrame("Frame")
notificationFrame:SetScript("OnUpdate", function(self, elapsed)
    SiegeNotifications.checkTimer = SiegeNotifications.checkTimer + elapsed
    if SiegeNotifications.checkTimer >= 10 then -- Check every 10 seconds
        SiegeNotifications.checkTimer = 0
        CheckSiegeNotifications()
    end
end)

local function OnPvPData(_, action, payload)
    if action == "ReceiveWarfronts" then
        PvPState.warfronts = payload or {}
        if PvPState.frames.warfronts then
            MortalUI_PvPPanel:ShowWarfrontsTab()
        end
    elseif action == "ReceiveSieges" then
        PvPState.sieges = payload or {}
        if PvPState.frames.sieges then
            MortalUI_PvPPanel:ShowSiegesTab()
        end
        -- Reset notification flags when new data arrives
        SiegeNotifications.notified15min = {}
        SiegeNotifications.notified5min = {}
    elseif action == "ReceiveHellgates" then
        PvPState.hellgates = payload or {}
        if PvPState.frames.hellgates then
            MortalUI_PvPPanel:ShowHellgatesTab()
        end
    elseif action == "ReceiveSeason" then
        PvPState.season = payload or {}
        if PvPState.frames.season then
            MortalUI_PvPPanel:ShowSeasonTab()
        end
    elseif action == "ReceiveBounties" then
        PvPState.bounties = payload or {}
        if PvPState.frames.bounties then
            MortalUI_PvPPanel:ShowBountiesTab()
        end
    elseif action == "ReceiveGuildPolitics" then
        PvPState.politics = payload or {}
        if PvPState.frames.politics then
            MortalUI_PvPPanel:ShowPoliticsTab()
        end
    end
end

AIO.RegisterEvent(CHANNEL, OnPvPData)

-- Show panel function
function MortalUI_PvPPanel:ShowPanel()
    self:Show()
    self:SwitchTab("Warfronts")
end

-- Auto-request sieges periodically for notifications
local siegeUpdateTimer = 0
local siegeUpdateFrame = CreateFrame("Frame")
siegeUpdateFrame:SetScript("OnUpdate", function(self, elapsed)
    siegeUpdateTimer = siegeUpdateTimer + elapsed
    if siegeUpdateTimer >= 60 then -- Update every minute
        siegeUpdateTimer = 0
        RequestSieges() -- Refresh siege data for notifications
    end
end)

-- Hook into PvP button (would need to replace the button)
-- For now, add slash command
SLASH_MORTALPVP1 = "/pvp"
SLASH_MORTALPVP2 = "/mortal_pvp"
SlashCmdList["MORTALPVP"] = function()
    MortalUI_PvPPanel:ShowPanel()
end

print("[MortalUI] PvP Panel loaded - Use /pvp to open")
