-- ==================================================
-- Project Mortal Warcraft
-- Feature: Crime Status Display (Client-Side)
-- Description: Display notoriety, criminal flag, and bounty status
-- Spec: 15-ui-client.md
-- ==================================================

local CrimeStatusFrame = CreateFrame("Frame", "MortalUICrimeStatus", UIParent)
CrimeStatusFrame:SetSize(200, 60)
CrimeStatusFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -10, -100)
CrimeStatusFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 }
})
CrimeStatusFrame:SetBackdropColor(0, 0, 0, 0.8)
CrimeStatusFrame:Hide()

-- Status text
local StatusText = CrimeStatusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
StatusText:SetPoint("TOP", CrimeStatusFrame, "TOP", 0, -10)
StatusText:SetText("Notoriety: Innocent")

-- Timer text
local TimerText = CrimeStatusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
TimerText:SetPoint("BOTTOM", CrimeStatusFrame, "BOTTOM", 0, 10)
TimerText:SetText("")

-- Store previous notoriety for change detection
local previousNotoriety = 0

-- Update crime status (called from server)
local function UpdateCrimeStatus(notoriety, criminalFlagTime, bounty)
    -- Check for notoriety change and show notification
    if notoriety ~= previousNotoriety and MortalUINotifications then
        if notoriety > previousNotoriety then
            -- Notoriety increased
            local notorietyNames = {"Innocent", "Suspect", "Criminal", "Outlaw", "Infamous"}
            local newLevel = notorietyNames[notoriety] or "Infamous"
            MortalUINotifications.Show("Notoriety Increased", string.format("You are now considered a %s", newLevel), "warning", {
                sound = "igQuestFailed",
                duration = 6
            })
        elseif notoriety < previousNotoriety then
            -- Notoriety decreased
            MortalUINotifications.Show("Notoriety Decreased", "Your criminal status has improved", "success", {
                sound = "Achievement",
                duration = 4
            })
        end
    end
    previousNotoriety = notoriety

    if notoriety == 0 then
        StatusText:SetText("|cffFFFFFFNotoriety: Innocent|r")
        CrimeStatusFrame:Hide()
        return
    end

    CrimeStatusFrame:Show()

    local notorietyText = "Innocent"
    local color = "FFFFFF"
    if notoriety == 1 then
        notorietyText = "Suspect"
        color = "FFFF00"
    elseif notoriety == 2 then
        notorietyText = "Criminal"
        color = "FF8000"
    elseif notoriety == 3 then
        notorietyText = "Outlaw"
        color = "FF0000"
    elseif notoriety >= 4 then
        notorietyText = "Infamous"
        color = "FF0000"
    end

    StatusText:SetText(string.format("|cff%sNotoriety: %s|r", color, notorietyText))

    if criminalFlagTime and criminalFlagTime > 0 then
        local remaining = criminalFlagTime - time()
        if remaining > 0 then
            local minutes = math.floor(remaining / 60)
            local seconds = remaining % 60
            TimerText:SetText(string.format("Criminal Flag: %d:%02d", minutes, seconds))
        else
            TimerText:SetText("")
        end
    else
        TimerText:SetText("")
    end

    if bounty and bounty > 0 then
        local bountyText = CrimeStatusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        bountyText:SetPoint("BOTTOM", TimerText, "TOP", 0, 5)
        bountyText:SetText(string.format("|cffFF0000Bounty: %dg|r", bounty / 10000))
    end
end

-- Register for custom packets
local function OnCrimeStatusPacket(data)
    if #data >= 1 then
        local notoriety = tonumber(data[1]) or 0
        local criminalFlagTime = tonumber(data[2]) or 0
        local bounty = tonumber(data[3]) or 0
        UpdateCrimeStatus(notoriety, criminalFlagTime, bounty)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.CRIME_STATUS, OnCrimeStatusPacket)
end

-- Export
MortalUICrimeStatus = {
    UpdateCrimeStatus = UpdateCrimeStatus
}

