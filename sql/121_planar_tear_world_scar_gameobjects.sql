-- ==================================================
-- Project Mortal Warcraft
-- Feature: Planar Tear and World Scar GameObjects
-- Description: Defines GameObject templates for Elden's Eve Layer
-- Based on: docs/specs/45-eldens-eve-layer.md
-- ==================================================

-- Planar Tear (Active Rift Visual)
-- Uses Naxxramas portal model (181402) as base - dimensional portal effect
-- Entry: 180000
DELETE FROM `gameobject_template` WHERE `entry` = 180000;
INSERT INTO `gameobject_template` (
    `entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, 
    `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, 
    `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, 
    `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, 
    `Data28`, `Data29`, `Data30`, `Data31`, `unkInt32`, `AIName`, `ScriptName`, `VerifiedBuild`
) VALUES (
    180000,  -- entry
    10,      -- type: GO_TYPE_GENERIC (interactable)
    181402,  -- displayId: Naxxramas portal visual (Kel'Thuzad portal)
    'Planar Tear',  -- name
    '',      -- IconName
    'Interact',  -- castBarCaption
    '',      -- unk1
    1.5,     -- size: 1.5x scale for visibility
    0,       -- Data0
    0,       -- Data1
    0,       -- Data2
    0,       -- Data3
    0,       -- Data4
    0,       -- Data5
    0,       -- Data6
    0,       -- Data7
    0,       -- Data8
    0,       -- Data9
    0,       -- Data10
    0,       -- Data11
    0,       -- Data12
    0,       -- Data13
    0,       -- Data14
    0,       -- Data15
    0,       -- Data16
    0,       -- Data17
    0,       -- Data18
    0,       -- Data19
    0,       -- Data20
    0,       -- Data21
    0,       -- Data22
    0,       -- Data23
    0,       -- Data24
    0,       -- Data25
    0,       -- Data26
    0,       -- Data27
    0,       -- Data28
    0,       -- Data29
    0,       -- Data30
    0,       -- Data31
    0,       -- unkInt32
    '',      -- AIName
    'GameObjectScript_MortalRifts',  -- ScriptName: handles interaction
    0        -- VerifiedBuild
);

-- World Scar (Permanent Mark After Rift)
-- Uses a ground effect or environmental damage marker
-- Entry: 180001
-- Note: Using a generic ground effect model - may need adjustment based on available models
DELETE FROM `gameobject_template` WHERE `entry` = 180001;
INSERT INTO `gameobject_template` (
    `entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, 
    `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, 
    `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, 
    `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, 
    `Data28`, `Data29`, `Data30`, `Data31`, `unkInt32`, `AIName`, `ScriptName`, `VerifiedBuild`
) VALUES (
    180001,  -- entry
    3,       -- type: GO_TYPE_TRAP (non-interactable visual)
    0,       -- displayId: 0 = use model from gameobject_displayinfo or default
    'World Scar',  -- name
    '',      -- IconName
    '',      -- castBarCaption
    '',      -- unk1
    2.0,     -- size: 2.0x scale for visibility
    0,       -- Data0
    0,       -- Data1
    0,       -- Data2
    0,       -- Data3
    0,       -- Data4
    0,       -- Data5
    0,       -- Data6
    0,       -- Data7
    0,       -- Data8
    0,       -- Data9
    0,       -- Data10
    0,       -- Data11
    0,       -- Data12
    0,       -- Data13
    0,       -- Data14
    0,       -- Data15
    0,       -- Data16
    0,       -- Data17
    0,       -- Data18
    0,       -- Data19
    0,       -- Data20
    0,       -- Data21
    0,       -- Data22
    0,       -- Data23
    0,       -- Data24
    0,       -- Data25
    0,       -- Data26
    0,       -- Data27
    0,       -- Data28
    0,       -- Data29
    0,       -- Data30
    0,       -- Data31
    0,       -- unkInt32
    '',      -- AIName
    '',      -- ScriptName: no interaction needed
    0        -- VerifiedBuild
);

-- Alternative: If displayId 0 doesn't work, we can use a known ground effect model
-- Common WotLK ground effect displayIds:
-- 327 (generic ground effect)
-- 1287 (Heigan eruption effect from Naxxramas)
-- 181356 (Sapphiron birth effect)

-- Update World Scar to use a visible ground effect if needed
-- Uncomment and adjust displayId as needed:
-- UPDATE `gameobject_template` SET `displayId` = 327 WHERE `entry` = 180001;

-- Summary
SELECT 
    'Planar Tear and World Scar GameObjects Created' as summary,
    (SELECT COUNT(*) FROM `gameobject_template` WHERE `entry` IN (180000, 180001)) as templates_created;

