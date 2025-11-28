-- ==================================================
-- Project Mortal Warcraft
-- Feature: Advanced Signage System
-- Description: Visual banners, audio cues, and lighting effects for zone transitions
-- Spec: 03-risk-zones.md section 4.1-4.3
-- ==================================================

local addonName, addonTable = ...

-- Signage system variables
local signageFrame = nil
local currentZoneType = nil
local transitionTimer = nil
local audioCooldown = 0

-- Color definitions for zone types
local ZONE_COLORS = {
    GREEN = { r = 0.0, g = 1.0, b = 0.0 },    -- Safe zones
    YELLOW = { r = 1.0, g = 1.0, b = 0.0 },   -- Contested zones
    RED = { r = 1.0, g = 0.2, b = 0.2 }       -- Full loot zones
}

-- Initialize the signage system
function MortalUI_AdvancedSignage_Initialize()
    -- Create main signage frame
    signageFrame = CreateFrame("Frame", "MortalUI_SignageFrame", UIParent)
    signageFrame:SetFrameStrata("HIGH")
    signageFrame:SetWidth(400)
    signageFrame:SetHeight(150)
    signageFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
    signageFrame:Hide()

    -- Background texture
    local bgTexture = signageFrame:CreateTexture(nil, "BACKGROUND")
    bgTexture:SetAllPoints(signageFrame)
    bgTexture:SetTexture("Interface\\AddOns\\MortalUI\\Textures\\signage_bg")
    bgTexture:SetVertexColor(0, 0, 0, 0.8)
    signageFrame.bgTexture = bgTexture

    -- Border texture
    local borderTexture = signageFrame:CreateTexture(nil, "BORDER")
    borderTexture:SetAllPoints(signageFrame)
    borderTexture:SetTexture("Interface\\AddOns\\MortalUI\\Textures\\signage_border")
    signageFrame.borderTexture = borderTexture

    -- Zone type icon
    local iconTexture = signageFrame:CreateTexture(nil, "ARTWORK")
    iconTexture:SetWidth(64)
    iconTexture:SetHeight(64)
    iconTexture:SetPoint("LEFT", signageFrame, "LEFT", 20, 0)
    signageFrame.iconTexture = iconTexture

    -- Warning text
    local warningText = signageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    warningText:SetPoint("LEFT", iconTexture, "RIGHT", 15, 10)
    warningText:SetTextColor(1, 1, 1, 1)
    warningText:SetJustifyH("LEFT")
    warningText:SetWidth(280)
    signageFrame.warningText = warningText

    -- Zone name text
    local zoneText = signageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    zoneText:SetPoint("LEFT", iconTexture, "RIGHT", 15, -15)
    zoneText:SetTextColor(1, 0.8, 0, 1)
    zoneText:SetJustifyH("LEFT")
    zoneText:SetWidth(280)
    signageFrame.zoneText = zoneText

    -- Rules text
    local rulesText = signageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    rulesText:SetPoint("TOPLEFT", zoneText, "BOTTOMLEFT", 0, -10)
    rulesText:SetTextColor(0.8, 0.8, 0.8, 1)
    rulesText:SetJustifyH("LEFT")
    rulesText:SetWidth(280)
    rulesText:SetHeight(40)
    signageFrame.rulesText = rulesText

    -- Animation setup
    signageFrame.fadeIn = signageFrame:CreateAnimationGroup()
    local fadeInAnim = signageFrame.fadeIn:CreateAnimation("Alpha")
    fadeInAnim:SetFromAlpha(0)
    fadeInAnim:SetToAlpha(1)
    fadeInAnim:SetDuration(0.5)
    fadeInAnim:SetSmoothing("IN")

    signageFrame.fadeOut = signageFrame:CreateAnimationGroup()
    local fadeOutAnim = signageFrame.fadeOut:CreateAnimation("Alpha")
    fadeOutAnim:SetFromAlpha(1)
    fadeOutAnim:SetToAlpha(0)
    fadeOutAnim:SetDuration(1.0)
    fadeOutAnim:SetSmoothing("OUT")
    fadeOutAnim:SetScript("OnFinished", function() signageFrame:Hide() end)

    -- Register events
    signageFrame:RegisterEvent("ZONE_CHANGED")
    signageFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
    signageFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    signageFrame:SetScript("OnEvent", MortalUI_AdvancedSignage_OnZoneChange)
    signageFrame:SetScript("OnUpdate", MortalUI_AdvancedSignage_OnUpdate)

    -- Initialize lighting system
    MortalUI_AdvancedSignage_InitializeLighting()

    MortalUI:Print("Advanced Signage System initialized")
end

-- Handle zone change events
function MortalUI_AdvancedSignage_OnZoneChange(self, event)
    -- Get current zone information
    local zoneName = GetZoneText()
    local zoneType = MortalUI_AdvancedSignage_GetZoneType()

    -- Only show signage if zone type changed
    if zoneType ~= currentZoneType then
        currentZoneType = zoneType
        MortalUI_AdvancedSignage_ShowSignage(zoneName, zoneType)
        MortalUI_AdvancedSignage_PlayAudioCue(zoneType)
        MortalUI_AdvancedSignage_UpdateLighting(zoneType)
    end
end

-- Update function for timers
function MortalUI_AdvancedSignage_OnUpdate(self, elapsed)
    if audioCooldown > 0 then
        audioCooldown = audioCooldown - elapsed
    end

    if transitionTimer then
        transitionTimer = transitionTimer - elapsed
        if transitionTimer <= 0 then
            MortalUI_AdvancedSignage_HideSignage()
            transitionTimer = nil
        end
    end
end

-- Get zone type from server data
function MortalUI_AdvancedSignage_GetZoneType()
    -- This would be populated by server data via addon messages
    -- For now, use a simple zone name check as fallback
    local zoneName = GetZoneText()

    -- Red zones
    if zoneName == "Stranglethorn Vale" or zoneName == "Burning Steppes" or
       zoneName == "Eastern Plaguelands" or zoneName == "Blasted Lands" or
       zoneName == "Silithus" or zoneName == "Icecrown" then
        return "RED"
    -- Yellow zones
    elseif zoneName == "Westfall" or zoneName == "Redridge Mountains" or
           zoneName == "Duskwood" or zoneName == "The Barrens" or
           zoneName == "Darkshore" or zoneName == "Ashenvale" then
        return "YELLOW"
    -- Green zones (default)
    else
        return "GREEN"
    end
end

-- Show zone signage
function MortalUI_AdvancedSignage_ShowSignage(zoneName, zoneType)
    if not signageFrame then return end

    -- Set colors based on zone type
    local colors = ZONE_COLORS[zoneType] or ZONE_COLORS.GREEN

    -- Update textures and text
    signageFrame.borderTexture:SetVertexColor(colors.r, colors.g, colors.b, 1)

    -- Set icon based on zone type
    local iconPath
    if zoneType == "RED" then
        iconPath = "Interface\\Icons\\Ability_Creature_Cursed_01"  -- Skull icon
    elseif zoneType == "YELLOW" then
        iconPath = "Interface\\Icons\\INV_Misc_SymbolOfKings_01"  -- Warning symbol
    else
        iconPath = "Interface\\Icons\\Spell_Nature_ProtectionForm"  -- Shield icon
    end
    signageFrame.iconTexture:SetTexture(iconPath)

    -- Set warning text
    local warningText
    if zoneType == "RED" then
        warningText = "FULL LOOT ZONE"
    elseif zoneType == "YELLOW" then
        warningText = "CONTESTED ZONE"
    else
        warningText = "SAFE ZONE"
    end
    signageFrame.warningText:SetText(warningText)
    signageFrame.warningText:SetTextColor(colors.r, colors.g, colors.b, 1)

    -- Set zone name
    signageFrame.zoneText:SetText(zoneName)

    -- Set rules text
    local rulesText
    if zoneType == "RED" then
        rulesText = "• FFA PvP always enabled\n• Full loot on death\n• No corpse protection"
    elseif zoneType == "YELLOW" then
        rulesText = "• Criminal flagging for attacks\n• Partial loot on death\n• Guard protection in towns"
    else
        rulesText = "• PvP disabled\n• No death loot\n• Guard protection everywhere"
    end
    signageFrame.rulesText:SetText(rulesText)

    -- Show and animate
    signageFrame:Show()
    signageFrame.fadeIn:Play()

    -- Auto-hide after 8 seconds
    transitionTimer = 8.0
end

-- Hide signage
function MortalUI_AdvancedSignage_HideSignage()
    if not signageFrame then return end

    signageFrame.fadeOut:Play()
end

-- Play audio cues for zone transitions
function MortalUI_AdvancedSignage_PlayAudioCue(zoneType)
    if audioCooldown > 0 then return end

    local soundFile
    if zoneType == "RED" then
        soundFile = "Interface\\AddOns\\MortalUI\\Sounds\\red_zone_transition.mp3"
    elseif zoneType == "YELLOW" then
        soundFile = "Interface\\AddOns\\MortalUI\\Sounds\\yellow_zone_transition.mp3"
    else
        soundFile = "Interface\\AddOns\\MortalUI\\Sounds\\green_zone_transition.mp3"
    end

    -- Play sound (would need actual sound files)
    -- PlaySoundFile(soundFile)

    -- For now, use default UI sounds
    if zoneType == "RED" then
        PlaySound("igQuestFailed", "SFX")
    elseif zoneType == "YELLOW" then
        PlaySound("igQuestLogOpen", "SFX")
    else
        PlaySound("igQuestLogAbandonQuest", "SFX")
    end

    audioCooldown = 5.0  -- Prevent spam
end

-- Initialize lighting system
function MortalUI_AdvancedSignage_InitializeLighting()
    -- Create lighting adjustment frame
    local lightingFrame = CreateFrame("Frame", "MortalUI_LightingFrame", UIParent)
    lightingFrame:SetFrameStrata("BACKGROUND")
    lightingFrame:SetAllPoints(UIParent)

    -- Full screen lighting overlay
    local lightingTexture = lightingFrame:CreateTexture(nil, "BACKGROUND")
    lightingTexture:SetAllPoints(UIParent)
    lightingTexture:SetTexture("Interface\\AddOns\\MortalUI\\Textures\\lighting_overlay")
    lightingTexture:SetVertexColor(1, 1, 1, 0)  -- Start transparent
    lightingFrame.lightingTexture = lightingTexture

    lightingFrame:Hide()
end

-- Update lighting based on zone type
function MortalUI_AdvancedSignage_UpdateLighting(zoneType)
    local lightingFrame = _G["MortalUI_LightingFrame"]
    if not lightingFrame then return end

    local texture = lightingFrame.lightingTexture
    if not texture then return end

    if zoneType == "RED" then
        -- Red zone: saturated reds/oranges, heavier fog
        texture:SetVertexColor(1.0, 0.3, 0.1, 0.3)
        lightingFrame:Show()
    elseif zoneType == "YELLOW" then
        -- Yellow zone: warmer tone, slight overcast
        texture:SetVertexColor(1.0, 0.9, 0.6, 0.2)
        lightingFrame:Show()
    else
        -- Green zone: normal lighting
        texture:SetVertexColor(1, 1, 1, 0)
        lightingFrame:Hide()
    end
end

-- Handle addon messages for server data
function MortalUI_AdvancedSignage_OnAddonMessage(prefix, message, channel, sender)
    if prefix ~= "MORTAL_SIGNAGE" then return end

    -- Parse server message: "zoneType:zoneName:rules"
    local zoneType, zoneName, rules = strsplit(":", message)

    if zoneType and zoneName then
        MortalUI_AdvancedSignage_ShowSignage(zoneName, zoneType)
        MortalUI_AdvancedSignage_PlayAudioCue(zoneType)
        MortalUI_AdvancedSignage_UpdateLighting(zoneType)
    end
end

-- Register addon message handler
local frame = CreateFrame("Frame")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "CHAT_MSG_ADDON" then
        MortalUI_AdvancedSignage_OnAddonMessage(...)
    end
end)

-- Export functions for other modules
addonTable.AdvancedSignage = {
    Initialize = MortalUI_AdvancedSignage_Initialize,
    ShowSignage = MortalUI_AdvancedSignage_ShowSignage,
    HideSignage = MortalUI_AdvancedSignage_HideSignage,
    GetZoneType = MortalUI_AdvancedSignage_GetZoneType,
    UpdateLighting = MortalUI_AdvancedSignage_UpdateLighting
}