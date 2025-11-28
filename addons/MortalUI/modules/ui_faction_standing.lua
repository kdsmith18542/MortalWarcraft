-- ==================================================
-- Mortal UI: Faction Standing Widget
-- Spec: 99-mortal-faction-meta-civic-frontier-cartel-atlas.md
-- ==================================================
-- Displays player standing with soft-power factions

local AIO = rawget(_G, "AIO")
if not AIO then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[MortalUI]|r Faction standing widget requires mod-AIO.")
    return
end

local FactionStanding = {
    data = {},
    frame = nil,
    updateTimer = 0
}

local FACTION_NAMES = {
    [1] = "Civic",
    [2] = "Frontier",
    [3] = "Cartel",
    [4] = "Atlas"
}

local FACTION_COLORS = {
    [1] = "|cFF00AAFF", -- Blue (Civic)
    [2] = "|cFFFFAA00", -- Orange (Frontier)
    [3] = "|cFFAA00AA", -- Purple (Cartel)
    [4] = "|cFF00FFAA"  -- Green (Atlas)
}

local RANK_NAMES = {
    [0] = "Neutral",
    [1] = "Unfriendly",
    [2] = "Hostile",
    [3] = "Friendly",
    [4] = "Honored",
    [5] = "Revered",
    [6] = "Exalted"
}

local function RequestFactionStanding()
    AIO.Handle("MortalFaction", "RequestFactionStanding")
end

local function CreateStandingWidget()
    if FactionStanding.frame then
        return FactionStanding.frame
    end
    
    -- Create main frame
    local frame = CreateFrame("Frame", "MortalUI_FactionStanding", UIParent)
    frame:SetWidth(200)
    frame:SetHeight(120)
    frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -100)
    frame:SetFrameStrata("MEDIUM")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    
    -- Background
    local bg = frame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
    frame.bg = bg
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -5)
    title:SetText("|cFFFFFF00Faction Standing|r")
    frame.title = title
    
    -- Standing entries
    frame.entries = {}
    for i = 1, 4 do
        local entry = CreateFrame("Frame", nil, frame)
        entry:SetWidth(180)
        entry:SetHeight(20)
        entry:SetPoint("TOPLEFT", 10, -25 - (i * 22))
        
        local name = entry:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        name:SetPoint("LEFT", 0, 0)
        name:SetText(FACTION_COLORS[i] .. FACTION_NAMES[i] .. "|r")
        entry.name = name
        
        local standing = entry:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        standing:SetPoint("RIGHT", 0, 0)
        standing:SetText("--")
        entry.standing = standing
        
        frame.entries[i] = entry
    end
    
    FactionStanding.frame = frame
    return frame
end

local function UpdateStandingDisplay()
    if not FactionStanding.frame then
        return
    end
    
    for i = 1, 4 do
        local entry = FactionStanding.frame.entries[i]
        local data = FactionStanding.data[i]
        
        if data then
            local standing = data.standing or 0
            local rank = data.rank or 0
            local rankName = RANK_NAMES[rank] or "Unknown"
            
            local color = "|cFFFFFFFF"
            if standing > 0 then
                color = "|cFF00FF00"
            elseif standing < 0 then
                color = "|cFFFF0000"
            end
            
            entry.standing:SetText(string.format("%s%d (%s)|r", color, standing, rankName))
        else
            entry.standing:SetText("--")
        end
    end
end

local function OnFactionStandingData(_, action, payload)
    if action == "ReceiveFactionStanding" then
        FactionStanding.data = payload or {}
        UpdateStandingDisplay()
    end
end

AIO.RegisterEvent("MortalFaction", OnFactionStandingData)

-- Initialize on login
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
    CreateStandingWidget()
    RequestFactionStanding()
    
    -- Update every 30 seconds
    local updateFrame = CreateFrame("Frame")
    updateFrame:SetScript("OnUpdate", function(self, elapsed)
        FactionStanding.updateTimer = FactionStanding.updateTimer + elapsed
        if FactionStanding.updateTimer >= 30 then
            FactionStanding.updateTimer = 0
            RequestFactionStanding()
        end
    end)
end)

