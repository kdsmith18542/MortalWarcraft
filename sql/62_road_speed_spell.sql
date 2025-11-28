-- ==================================================
-- Project Mortal Warcraft: King's Road Spell
-- Feature: Road Speed Buff (+30% Movement Speed)
-- Description: Creates the spell for road speed buff
-- ==================================================

START TRANSACTION;

-- Note: Spell creation in AzerothCore typically requires DBC editing or using existing spell entries
-- This SQL provides a template - you may need to use a spell editor tool or modify spell_dbc directly

-- Option 1: Use an existing spell entry and modify it (if spell_dbc table exists)
-- Option 2: Create via DBC editor and import
-- Option 3: Use a spell editor tool

-- For now, we'll document the required spell properties:
-- Spell ID: 60005
-- Effect: SPELL_EFFECT_APPLY_AURA (6)
-- Aura: SPELL_AURA_MOD_SPEED_ALWAYS (61)
-- Base Points: 30 (30% speed increase)
-- Target: TARGET_SELF (1)
-- Attributes: SPELL_ATTR0_PASSIVE (0x00000040)
-- Duration: Permanent (21)

-- If you have access to spell_dbc table, use this structure:
INSERT IGNORE INTO `spell_dbc` (
    `ID`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`,
    `CastingTimeIndex`, `DurationIndex`, `RangeIndex`, `SchoolMask`,
    `Effect_1`, `EffectBasePoints_1`, `ImplicitTargetA_1`, `EffectAura_1`,
    `Name_Lang_enUS`, `Description_Lang_enUS`
) VALUES (
    60005,
    0x00000040, -- SPELL_ATTR0_PASSIVE
    0, 0, 0, 0,
    1, -- Instant cast
    21, -- Permanent duration
    1, -- Self range
    0, -- Physical school
    6, -- SPELL_EFFECT_APPLY_AURA
    30, -- 30% speed increase
    1, -- TARGET_SELF
    61, -- SPELL_AURA_MOD_SPEED_ALWAYS
    'King''s Road',
    'Increases movement speed by 30% while on the King''s Road.'
);

COMMIT;

-- Note: If spell_dbc table doesn't exist, you'll need to:
-- 1. Use a DBC editor (like WDBX Editor) to modify Spell.dbc
-- 2. Or use a spell creation tool
-- 3. Or use an existing similar spell and modify it

SELECT 'Road Speed Spell (60005) - Use DBC editor or spell creation tool to create this spell.' AS result;
