-- ==================================================
-- Project Mortal Warcraft
-- Feature: Environmental Hazards (Client-Side)
-- Description: Visual and audio cues for environmental hazards
-- Spec: 03-risk-zones.md section 4.2-4.3
-- ==================================================

local EnvironmentalHazardsFrame = CreateFrame("Frame", "MortalUIEnvironmentalHazards", UIParent)
EnvironmentalHazardsFrame:SetFrameStrata("BACKGROUND")
EnvironmentalHazardsFrame:SetAllPoints(UIParent)
EnvironmentalHazardsFrame:SetAlpha(0)
EnvironmentalHazardsFrame:EnableMouse(false)
EnvironmentalHazardsFrame:Hide()

-- Overlay texture for visual effects
local overlay = EnvironmentalHazardsFrame:CreateTexture(nil, "BACKGROUND")
overlay:SetAllPoints()
overlay:SetBlendMode("ADD")
overlay:SetAlpha(0.3)
EnvironmentalHazardsFrame.overlay = overlay

-- Hazard types
local HAZARD_TYPES = {
    POISON = "poison",
    RADIATION = "radiation",
    FIRE = "fire",
    FROST = "frost",
    SHADOW = "shadow"
}

-- Current active hazard
local activeHazard = nil
local hazardTimer = nil

-- Apply visual effect for hazard type
local function ApplyHazardVisual(hazardType)
    if not hazardType then
        EnvironmentalHazardsFrame:Hide()
        overlay:SetTexture(nil)
        return
    end
    
    local r, g, b, texture
    
    if hazardType == HAZARD_TYPES.POISON then
        r, g, b = 0.2, 1.0, 0.2  -- Green tint
        texture = "Interface\\AddOns\\MortalUI\\assets\\textures\\poison_overlay"
    elseif hazardType == HAZARD_TYPES.RADIATION then
        r, g, b = 1.0, 1.0, 0.0  -- Yellow tint
        texture = "Interface\\AddOns\\MortalUI\\assets\\textures\\radiation_overlay"
    elseif hazardType == HAZARD_TYPES.FIRE then
        r, g, b = 1.0, 0.3, 0.0  -- Orange/red tint
        texture = "Interface\\AddOns\\MortalUI\\assets\\textures\\fire_overlay"
    elseif hazardType == HAZARD_TYPES.FROST then
        r, g, b = 0.5, 0.8, 1.0  -- Blue tint
        texture = "Interface\\AddOns\\MortalUI\\assets\\textures\\frost_overlay"
    elseif hazardType == HAZARD_TYPES.SHADOW then
        r, g, b = 0.3, 0.0, 0.5  -- Purple tint
        texture = "Interface\\AddOns\\MortalUI\\assets\\textures\\shadow_overlay"
    else
        return
    end
    
    -- Try to load texture, fallback to color overlay
    overlay:SetColorTexture(r, g, b, 0.2)
    
    -- Show frame with fade-in animation
    EnvironmentalHazardsFrame:Show()
    local fadeIn = EnvironmentalHazardsFrame:CreateAnimationGroup()
    local fade = fadeIn:CreateAnimation("Alpha")
    fade:SetFromAlpha(0)
    fade:SetToAlpha(1)
    fade:SetDuration(1.0)
    fadeIn:Play()
end

-- Play audio cue for hazard
local function PlayHazardAudio(hazardType)
    if hazardType == HAZARD_TYPES.POISON then
        PlaySound(8958)  -- Warning sound
    elseif hazardType == HAZARD_TYPES.RADIATION then
        PlaySound(8959)  -- Alert sound
    elseif hazardType == HAZARD_TYPES.FIRE then
        PlaySound(8960)  -- Fire sound
    elseif hazardType == HAZARD_TYPES.FROST then
        PlaySound(8961)  -- Frost sound
    elseif hazardType == HAZARD_TYPES.SHADOW then
        PlaySound(8962)  -- Shadow sound
    end
end

-- Show hazard warning
local function ShowHazard(hazardType, intensity)
    if not hazardType then
        activeHazard = nil
        ApplyHazardVisual(nil)
        return
    end
    
    activeHazard = hazardType
    intensity = intensity or 1.0
    
    -- Apply visual effect
    ApplyHazardVisual(hazardType)
    
    -- Play audio cue
    PlayHazardAudio(hazardType)
    
    -- Update overlay alpha based on intensity
    overlay:SetAlpha(0.1 + (intensity * 0.2))
end

-- Zone-based lighting effects
local function ApplyZoneLighting(zoneType)
    -- Yellow zones: warmer tone & slight overcast
    if zoneType == "yellow" then
        -- Apply warm color filter (would need shader support)
        -- For now, just log it
        print("[MortalUI] Applying Yellow Zone lighting: Warm tone, slight overcast")
    -- Red zones: saturated reds/oranges, heavier fog
    elseif zoneType == "red" then
        -- Apply red/orange color filter
        print("[MortalUI] Applying Red Zone lighting: Saturated reds/oranges, heavy fog")
    else
        -- Green zones: normal lighting
        print("[MortalUI] Applying Green Zone lighting: Normal")
    end
end

-- Listen for zone changes and hazard updates
local HazardFrame = CreateFrame("Frame")
HazardFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
HazardFrame:RegisterEvent("CHAT_MSG_ADDON")

HazardFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ZONE_CHANGED_NEW_AREA" then
        -- Request hazard data from server
        if C_ChatInfo then
            C_ChatInfo.SendAddonMessage("MORTAL_PACKET", "QUERY_ENVIRONMENTAL_HAZARD", "WHISPER", UnitName("player"))
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == "MORTAL_ENV_HAZARD" then
            -- Parse message: "hazardType:intensity"
            local hazardType, intensityStr = strsplit(":", message)
            local intensity = tonumber(intensityStr) or 1.0
            
            if hazardType and hazardType ~= "none" then
                ShowHazard(hazardType, intensity)
            else
                ShowHazard(nil)
            end
        elseif prefix == "MORTAL_ZONE_LIGHTING" then
            -- Parse message: "zoneType"
            local zoneType = message or "green"
            ApplyZoneLighting(zoneType)
        end
    end
end)

-- Combat drums fade-in when near Red zone borders
local function PlayCombatDrums(enable)
    if enable then
        -- Start ambient combat music (would need audio system integration)
        print("[MortalUI] Combat drums: Fading in")
    else
        -- Stop combat music
        print("[MortalUI] Combat drums: Fading out")
    end
end

-- Export
MortalUIEnvironmentalHazards = {
    ShowHazard = ShowHazard,
    ApplyZoneLighting = ApplyZoneLighting,
    PlayCombatDrums = PlayCombatDrums,
    HAZARD_TYPES = HAZARD_TYPES
}

print("[MortalUI] Environmental Hazards loaded")

