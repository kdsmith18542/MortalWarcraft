-- ==================================================
-- Project Mortal Warcraft
-- Feature: Economic Statistics UI (Client-Side)
-- Description: Display currency balances, vendor reputation, and economic data
-- ==================================================

local EconomicStats = {}

-- Create economic stats frame
local EconomicFrame = CreateFrame("Frame", "MortalUIEconomicStats", UIParent)
EconomicFrame:SetSize(350, 500)
EconomicFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
EconomicFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
EconomicFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
EconomicFrame:Hide()

-- Title
local TitleText = EconomicFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
TitleText:SetPoint("TOP", EconomicFrame, "TOP", 0, -15)
TitleText:SetText("Economic Overview")

-- Currency section
local CurrencyHeader = EconomicFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CurrencyHeader:SetPoint("TOPLEFT", EconomicFrame, "TOPLEFT", 15, -40)
CurrencyHeader:SetText("Currency Balances:")

local CurrencyFrame = CreateFrame("Frame", nil, EconomicFrame)
CurrencyFrame:SetSize(320, 150)
CurrencyFrame:SetPoint("TOPLEFT", CurrencyHeader, "BOTTOMLEFT", 0, -5)

-- Vendor reputation section
local ReputationHeader = EconomicFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ReputationHeader:SetPoint("TOPLEFT", CurrencyFrame, "BOTTOMLEFT", 0, -15)
ReputationHeader:SetText("Vendor Reputation:")

local ReputationFrame = CreateFrame("Frame", nil, EconomicFrame)
ReputationFrame:SetSize(320, 100)
ReputationFrame:SetPoint("TOPLEFT", ReputationHeader, "BOTTOMLEFT", 0, -5)

-- Economic events section
local EventsHeader = EconomicFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
EventsHeader:SetPoint("TOPLEFT", ReputationFrame, "BOTTOMLEFT", 0, -15)
EventsHeader:SetText("Active Economic Events:")

local EventsFrame = CreateFrame("Frame", nil, EconomicFrame)
EventsFrame:SetSize(320, 80)
EventsFrame:SetPoint("TOPLEFT", EventsHeader, "BOTTOMLEFT", 0, -5)

-- Close button
local CloseButton = CreateFrame("Button", nil, EconomicFrame, "UIPanelCloseButton")
CloseButton:SetPoint("TOPRIGHT", EconomicFrame, "TOPRIGHT", -5, -5)

-- Data storage
local currencyBalances = {}
local vendorReputations = {}
local activeEvents = {}

-- Update currency display
function EconomicStats.UpdateCurrencyDisplay()
    -- Clear existing currency texts
    if CurrencyFrame.currencyTexts then
        for _, text in ipairs(CurrencyFrame.currencyTexts) do
            text:Hide()
        end
    end
    CurrencyFrame.currencyTexts = CurrencyFrame.currencyTexts or {}

    local yOffset = 0
    for currencyId, balance in pairs(currencyBalances) do
        local currencyText = CurrencyFrame.currencyTexts[currencyId]
        if not currencyText then
            currencyText = CurrencyFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            CurrencyFrame.currencyTexts[currencyId] = currencyText
        end

        local currencyName = balance.name or ("Currency " .. currencyId)
        currencyText:SetText(string.format("%s: %s", currencyName, EconomicStats.FormatCurrency(balance.amount)))
        currencyText:SetPoint("TOPLEFT", CurrencyFrame, "TOPLEFT", 5, -5 - yOffset)
        currencyText:SetTextColor(1, 0.8, 0) -- Gold color
        currencyText:Show()

        yOffset = yOffset + 15
    end
end

-- Update reputation display
function EconomicStats.UpdateReputationDisplay()
    -- Clear existing reputation texts
    if ReputationFrame.reputationTexts then
        for _, text in ipairs(ReputationFrame.reputationTexts) do
            text:Hide()
        end
    end
    ReputationFrame.reputationTexts = ReputationFrame.reputationTexts or {}

    local yOffset = 0
    local count = 0
    for vendorEntry, reputation in pairs(vendorReputations) do
        if count >= 5 then break end -- Limit to 5 vendors

        local repText = ReputationFrame.reputationTexts[vendorEntry]
        if not repText then
            repText = ReputationFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            ReputationFrame.reputationTexts[vendorEntry] = repText
        end

        local repLevel = reputation.reputationLevel or 0
        local discount = reputation.discountUnlocked and " (Discount)" or ""
        local color = repLevel > 0 and "00FF00" or repLevel < 0 and "FF0000" or "FFFFFF"

        repText:SetText(string.format("|cff%sVendor %d: %d%s|r", color, vendorEntry, repLevel, discount))
        repText:SetPoint("TOPLEFT", ReputationFrame, "TOPLEFT", 5, -5 - yOffset)
        repText:Show()

        yOffset = yOffset + 15
        count = count + 1
    end
end

-- Update events display
function EconomicStats.UpdateEventsDisplay()
    -- Clear existing event texts
    if EventsFrame.eventTexts then
        for _, text in ipairs(EventsFrame.eventTexts) do
            text:Hide()
        end
    end
    EventsFrame.eventTexts = EventsFrame.eventTexts or {}

    local yOffset = 0
    local count = 0
    for eventId, event in pairs(activeEvents) do
        if count >= 3 then break end -- Limit to 3 events

        local eventText = EventsFrame.eventTexts[eventId]
        if not eventText then
            eventText = EventsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            EventsFrame.eventTexts[eventId] = eventText
        end

        local eventType = event.eventType or "Unknown"
        local modifier = event.priceModifier or 1.0
        local color = modifier > 1.0 and "FF0000" or modifier < 1.0 and "00FF00" or "FFFFFF"

        eventText:SetText(string.format("|cff%s%s: %.0f%%|r", color, eventType, (modifier - 1.0) * 100))
        eventText:SetPoint("TOPLEFT", EventsFrame, "TOPLEFT", 5, -5 - yOffset)
        eventText:Show()

        yOffset = yOffset + 15
        count = count + 1
    end

    if count == 0 then
        local noEventsText = EventsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        noEventsText:SetText("No active economic events")
        noEventsText:SetPoint("TOPLEFT", EventsFrame, "TOPLEFT", 5, -5)
        noEventsText:SetTextColor(0.5, 0.5, 0.5)
        noEventsText:Show()
        EventsFrame.eventTexts = EventsFrame.eventTexts or {}
        EventsFrame.eventTexts[0] = noEventsText
    end
end

-- Format currency amounts
function EconomicStats.FormatCurrency(amount)
    if amount >= 10000 then
        return string.format("%.1fk", amount / 1000)
    elseif amount >= 1000 then
        return string.format("%.1fk", amount / 1000)
    else
        return tostring(amount)
    end
end

-- Update all displays
function EconomicStats.UpdateAllDisplays()
    EconomicStats.UpdateCurrencyDisplay()
    EconomicStats.UpdateReputationDisplay()
    EconomicStats.UpdateEventsDisplay()
end

-- Show economic stats
function EconomicStats.Show()
    EconomicStats.UpdateAllDisplays()
    EconomicFrame:Show()
end

-- Hide economic stats
function EconomicStats.Hide()
    EconomicFrame:Hide()
end

-- Toggle economic stats
function EconomicStats.Toggle()
    if EconomicFrame:IsShown() then
        EconomicStats.Hide()
    else
        EconomicStats.Show()
    end
end

-- Register slash command
SLASH_ECONOMICS1 = "/economics"
SLASH_ECONOMICS2 = "/econ"
SlashCmdList["ECONOMICS"] = function(msg)
    EconomicStats.Toggle()
end

-- Register for packet-based updates
local function OnEconomicStatsPacket(data)
    if #data >= 1 then
        local packetType = data[1]

        if packetType == "CURRENCY_UPDATE" and #data >= 4 then
            local currencyId = tonumber(data[2])
            local amount = tonumber(data[3])
            local name = data[4]

            currencyBalances[currencyId] = {
                amount = amount,
                name = name
            }

            if EconomicFrame:IsShown() then
                EconomicStats.UpdateCurrencyDisplay()
            end

        elseif packetType == "REPUTATION_UPDATE" and #data >= 5 then
            local vendorEntry = tonumber(data[2])
            local reputationLevel = tonumber(data[3])
            local totalTransactions = tonumber(data[4])
            local discountUnlocked = data[5] == "1"

            vendorReputations[vendorEntry] = {
                reputationLevel = reputationLevel,
                totalTransactions = totalTransactions,
                discountUnlocked = discountUnlocked
            }

            if EconomicFrame:IsShown() then
                EconomicStats.UpdateReputationDisplay()
            end

        elseif packetType == "ECONOMIC_EVENT" and #data >= 5 then
            local eventId = tonumber(data[2])
            local eventType = data[3]
            local priceModifier = tonumber(data[4])
            local description = data[5]

            activeEvents[eventId] = {
                eventType = eventType,
                priceModifier = priceModifier,
                description = description
            }

            if EconomicFrame:IsShown() then
                EconomicStats.UpdateEventsDisplay()
            end
        end
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler("ECONOMIC_STATS", OnEconomicStatsPacket)
end

-- Export
MortalUIEconomicStats = EconomicStats