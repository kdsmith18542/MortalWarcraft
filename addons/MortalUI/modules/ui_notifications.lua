-- ==================================================
-- Project Mortal Warcraft
-- Feature: UI Notifications System (Client-Side)
-- Description: Advanced notification system with callbacks and polish
-- ==================================================

local UINotifications = {}

-- Notification queue
local notificationQueue = {}
local activeNotifications = {}

-- Create notification frame pool
local notificationFrames = {}

-- Notification types
local NOTIFICATION_TYPES = {
    INFO = "info",
    WARNING = "warning",
    ERROR = "error",
    SUCCESS = "success",
    ACHIEVEMENT = "achievement",
    ECONOMIC = "economic",
    CURRENCY = "currency",
    VENDOR = "vendor"
}

-- Get notification colors
local function GetNotificationColor(notificationType)
    local colors = {
        info = {0.4, 0.6, 1.0},
        warning = {1.0, 0.8, 0.0},
        error = {1.0, 0.2, 0.2},
        success = {0.2, 1.0, 0.2},
        achievement = {1.0, 0.8, 0.0},
        economic = {0.0, 1.0, 1.0}, -- Cyan for economic events
        currency = {1.0, 0.8, 0.4}, -- Gold for currency
        vendor = {0.6, 0.4, 1.0}    -- Purple for vendor events
    }
    return colors[notificationType] or colors.info
end

-- Create notification frame
local function CreateNotificationFrame()
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(300, 60)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })

    -- Icon
    frame.icon = frame:CreateTexture(nil, "ARTWORK")
    frame.icon:SetSize(32, 32)
    frame.icon:SetPoint("LEFT", frame, "LEFT", 10, 0)

    -- Title text
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.title:SetPoint("TOPLEFT", frame.icon, "TOPRIGHT", 10, -5)
    frame.title:SetJustifyH("LEFT")

    -- Message text
    frame.message = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.message:SetPoint("BOTTOMLEFT", frame.icon, "BOTTOMRIGHT", 10, 5)
    frame.message:SetJustifyH("LEFT")

    -- Progress bar for timed notifications
    frame.progressBar = CreateFrame("StatusBar", nil, frame)
    frame.progressBar:SetSize(280, 4)
    frame.progressBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 8)
    frame.progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    frame.progressBar:SetStatusBarColor(0.2, 0.8, 0.2)
    frame.progressBar:Hide()

    -- Animation
    frame.animGroup = frame:CreateAnimationGroup()
    local fadeIn = frame.animGroup:CreateAnimation("Alpha")
    fadeIn:SetFromAlpha(0)
    fadeIn:SetToAlpha(1)
    fadeIn:SetDuration(0.3)
    fadeIn:SetOrder(1)

    local slideIn = frame.animGroup:CreateAnimation("Translation")
    slideIn:SetOffset(0, -50)
    slideIn:SetDuration(0.5)
    slideIn:SetOrder(1)

    frame.fadeOutGroup = frame:CreateAnimationGroup()
    local fadeOut = frame.fadeOutGroup:CreateAnimation("Alpha")
    fadeOut:SetFromAlpha(1)
    fadeOut:SetToAlpha(0)
    fadeOut:SetDuration(0.3)
    fadeOut:SetOrder(1)

    frame.fadeOutGroup:SetScript("OnFinished", function()
        frame:Hide()
        frame:SetAlpha(1)
        table.insert(notificationFrames, frame)
    end)

    return frame
end

-- Get or create notification frame
local function GetNotificationFrame()
    if #notificationFrames > 0 then
        return table.remove(notificationFrames)
    end
    return CreateNotificationFrame()
end

-- Show notification
local function ShowNotification(notificationData)
    local frame = GetNotificationFrame()
    local r, g, b = unpack(GetNotificationColor(notificationData.type))

    frame:SetBackdropColor(r * 0.1, g * 0.1, b * 0.1, 0.9)
    frame:SetBackdropBorderColor(r, g, b, 1)

    -- Set icon
    if notificationData.icon then
        frame.icon:SetTexture(notificationData.icon)
        frame.icon:Show()
    else
        frame.icon:Hide()
    end

    -- Set text
    frame.title:SetText(notificationData.title or "")
    frame.message:SetText(notificationData.message or "")

    -- Position
    local yOffset = -200 - (#activeNotifications * 70)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, yOffset)
    frame:Show()

    -- Animation
    frame.animGroup:Play()

    -- Add to active notifications
    table.insert(activeNotifications, frame)

    -- Auto-hide
    local duration = notificationData.duration or 5
    if duration > 0 then
        frame.progressBar:SetMinMaxValues(0, duration)
        frame.progressBar:SetValue(duration)
        frame.progressBar:Show()

        local startTime = GetTime()
        frame:SetScript("OnUpdate", function(self, elapsed)
            local elapsed = GetTime() - startTime
            local remaining = duration - elapsed
            if remaining <= 0 then
                self:SetScript("OnUpdate", nil)
                self.fadeOutGroup:Play()
                -- Remove from active notifications
                for i, activeFrame in ipairs(activeNotifications) do
                    if activeFrame == self then
                        table.remove(activeNotifications, i)
                        break
                    end
                end
            else
                self.progressBar:SetValue(remaining)
            end
        end)
    end

    -- Callbacks
    if notificationData.onShow then
        notificationData.onShow(frame)
    end

    -- Sound
    if notificationData.sound then
        PlaySound(notificationData.sound)
    end
end

-- Process notification queue
local function ProcessNotificationQueue()
    if #notificationQueue > 0 and #activeNotifications < 5 then -- Max 5 concurrent notifications
        local notification = table.remove(notificationQueue, 1)
        ShowNotification(notification)
    end
end

-- Public API: Show notification
function UINotifications.Show(title, message, notificationType, options)
    options = options or {}
    local notification = {
        title = title,
        message = message,
        type = notificationType or NOTIFICATION_TYPES.INFO,
        icon = options.icon,
        duration = options.duration or 5,
        sound = options.sound,
        onShow = options.onShow,
        onClick = options.onClick,
        data = options.data
    }

    table.insert(notificationQueue, notification)
    ProcessNotificationQueue()
end

-- Public API: Show achievement notification
function UINotifications.ShowAchievement(title, description, icon)
    UINotifications.Show(title, description, NOTIFICATION_TYPES.ACHIEVEMENT, {
        icon = icon or "Interface\\Icons\\Achievement_Quests_Completed_01",
        sound = "Achievement",
        duration = 8
    })
end

-- Public API: Show error notification
function UINotifications.ShowError(title, message)
    UINotifications.Show(title, message, NOTIFICATION_TYPES.ERROR, {
        sound = "igQuestFailed",
        duration = 6
    })
end

-- Public API: Show success notification
function UINotifications.ShowSuccess(title, message)
    UINotifications.Show(title, message, NOTIFICATION_TYPES.SUCCESS, {
        sound = "Achievement",
        duration = 4
    })
end

-- Public API: Show economic event notification
function UINotifications.ShowEconomicEvent(title, message, eventType)
    local options = {
        icon = "Interface\\Icons\\INV_Misc_Coin_01",
        sound = "igMainMenuOption",
        duration = 6
    }

    if eventType == "price_increase" then
        options.icon = "Interface\\Icons\\INV_Misc_Coin_02"
    elseif eventType == "price_decrease" then
        options.icon = "Interface\\Icons\\INV_Misc_Coin_03"
    elseif eventType == "currency_earned" then
        options.icon = "Interface\\Icons\\INV_Misc_Coin_04"
        options.sound = "igPlayerInviteAccept"
    end

    UINotifications.Show(title, message, NOTIFICATION_TYPES.ECONOMIC, options)
end

-- Public API: Show currency transaction notification
function UINotifications.ShowCurrencyTransaction(currencyName, amount, transactionType)
    local title = currencyName .. " " .. transactionType
    local message = string.format("%+d %s", amount, currencyName)
    local color = amount > 0 and "00FF00" or "FF0000"
    message = string.format("|cff%s%s|r", color, message)

    UINotifications.Show(title, message, NOTIFICATION_TYPES.CURRENCY, {
        icon = "Interface\\Icons\\INV_Misc_Coin_05",
        sound = amount > 0 and "igPlayerInviteAccept" or "igQuestFailed",
        duration = 4
    })
end

-- Public API: Show vendor reputation notification
function UINotifications.ShowVendorReputation(vendorName, reputationChange)
    local title = "Vendor Reputation"
    local message = string.format("%s: %+d", vendorName, reputationChange)
    local color = reputationChange > 0 and "00FF00" or reputationChange < 0 and "FF0000" or "FFFFFF"
    message = string.format("|cff%s%s|r", color, message)

    UINotifications.Show(title, message, NOTIFICATION_TYPES.VENDOR, {
        icon = "Interface\\Icons\\INV_Misc_GroupNeedMore",
        sound = reputationChange > 0 and "igMainMenuOption" or "igQuestFailed",
        duration = 5
    })
end

-- Register for packet-based notifications
local function OnNotificationPacket(data)
    if #data >= 2 then
        local notificationType = data[1]
        local title = data[2]
        local message = data[3] or ""
        local options = {}

        if #data >= 4 then
            options.icon = data[4]
        end
        if #data >= 5 then
            options.duration = tonumber(data[5]) or 5
        end
        if #data >= 6 then
            options.sound = data[6]
        end

        UINotifications.Show(title, message, notificationType, options)
    end
end

if MortalPacketHandler then
    MortalPacketHandler:RegisterHandler(MortalPacketHandler.PACKET_TYPES.NOTIFICATION, OnNotificationPacket)
end

-- Process queue periodically
local queueFrame = CreateFrame("Frame")
queueFrame:SetScript("OnUpdate", function(self, elapsed)
    self.timer = (self.timer or 0) + elapsed
    if self.timer >= 0.1 then
        ProcessNotificationQueue()
        self.timer = 0
    end
end)

-- Export
MortalUINotifications = UINotifications