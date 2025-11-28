local AIO = rawget(_G, "AIO")
if not AIO then
    return
end

local CHANNEL = "MortalBank"
local latestZone = { id = 0, name = "Unknown Region" }

local function CreateDisplay()
    local frame = CreateFrame("Frame", "MortalUI_BankRegion", UIParent)
    frame:SetSize(300, 20)
    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetAllPoints()
    frame:SetFrameStrata("HIGH")
    frame:Hide()

    frame:RegisterEvent("BANKFRAME_OPENED")
    frame:RegisterEvent("BANKFRAME_CLOSED")
    frame:SetScript("OnEvent", function(self, event)
        if event == "BANKFRAME_OPENED" then
            if BankFrame then
                self:SetParent(BankFrame)
                self:ClearAllPoints()
                self:SetPoint("BOTTOMLEFT", BankFrame, "TOPLEFT", 0, 6)
            else
                self:SetParent(UIParent)
                self:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
            end
            self.text:SetText(string.format("Region: %s", latestZone.name))
            self:Show()
        else
            self:Hide()
        end
    end)
    return frame
end

local regionFrame = CreateDisplay()

local function UpdateRegion(payload)
    latestZone.id = payload and payload.zoneId or 0
    latestZone.name = payload and payload.zoneName or "Unknown Region"
    if regionFrame:IsShown() then
        regionFrame.text:SetText(string.format("Region: %s", latestZone.name))
    end
end

AIO.RegisterEvent(CHANNEL, function(_, action, payload)
    if action == "ShowRegion" then
        UpdateRegion(payload)
    end
end)
