-- ==================================================
-- Project Mortal Warcraft
-- Feature: Elden's Eve Layer - Spell and Item Templates
-- Description: Defines spell template for Rift Participant aura and Arcane Eye trinket
-- Based on: docs/specs/45-eldens-eve-layer.md
-- ==================================================

-- ==================================================
-- SPELL TEMPLATE: Rift Participant Aura (900100)
-- ==================================================
-- Note: Spells in WotLK are defined in DBC files (Spell.dbc), not SQL tables.
-- This SQL file provides documentation and any SQL-side configuration needed.
-- The actual spell entry must be added to Spell.dbc with the following properties:
--
-- Spell ID: 900100
-- Spell Name: "Rift Participant"
-- School: Magic (0)
-- Category: 0
-- Dispel Type: None (0)
-- Mechanic: None (0)
-- Attributes: 
--   - SPELL_ATTR0_NOT_SHAPESHIFT (0x00000008)
--   - SPELL_ATTR0_PASSIVE (0x00000080) - Passive aura
--   - SPELL_ATTR0_DO_NOT_DISPLAY (0x00000100) - Hidden from UI
-- AttributesEx: 
--   - SPELL_ATTR1_NO_THREAT (0x00000020)
-- Cast Time: 0 (Instant)
-- Duration: -1 (Permanent while in rift phase)
-- Range: 0 (Self)
-- Effect 1: SPELL_EFFECT_APPLY_AURA
--   Aura Type: SPELL_AURA_DUMMY (4) - Marker aura
--   Base Points: 1
--   Target: Self (1)
-- Effect 2: None
-- Effect 3: None
-- Icon: 1 (or appropriate icon ID)
-- Description: "Marks you as a participant in a planar rift event. Provides access to rift content."

-- SQL-side configuration (if spell_template table exists):
-- Note: Most AzerothCore setups don't have a spell_template table.
-- If your setup uses spell_template, uncomment and adjust:
/*
DELETE FROM `spell_template` WHERE `entry` = 900100;
INSERT INTO `spell_template` (
    `entry`, `procChance`, `procFlags`, `procEx`, `ppmRate`, `CustomChance`, `Cooldown`
) VALUES (
    900100,  -- entry
    0,       -- procChance
    0,       -- procFlags
    0,       -- procEx
    0,       -- ppmRate
    0,       -- CustomChance
    0        -- Cooldown
);
*/

-- Spell bonus data (if needed):
DELETE FROM `spell_bonus_data` WHERE `entry` = 900100;
-- No bonus data needed for marker aura

-- ==================================================
-- ITEM TEMPLATE: Arcane Eye Trinket (900200)
-- ==================================================
-- Trinket that allows players to detect planar anomalies
-- Note: Trinkets in WotLK use class 4 (ITEM_CLASS_CONSUMABLE) with InventoryType 12 (INVTYPE_TRINKET)
DELETE FROM `item_template` WHERE `entry` = 900200;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`, `stackable`
) VALUES (
    900200,  -- entry
    4,       -- class: ITEM_CLASS_CONSUMABLE
    0,       -- subclass: ITEM_SUBCLASS_CONSUMABLE
    'Arcane Eye',  -- name
    0,       -- displayid: Will need to be set to appropriate trinket model (suggest 45869 or similar trinket visual)
    3,       -- Quality: RARE (blue)
    0,       -- Flags
    1,       -- BuyCount
    50000,   -- BuyPrice: 5 gold (50000 copper)
    25000,   -- SellPrice: 2.5 gold
    12,      -- InventoryType: INVTYPE_TRINKET (equips in trinket slot)
    -1,      -- AllowableClass: All classes
    -1,      -- AllowableRace: All races
    60,      -- ItemLevel: 60
    1,       -- RequiredLevel: 1
    0,       -- StatsCount: No stats (utility trinket)
    0,       -- bonding: BIND_NONE (can be traded)
    'Allows you to detect planar anomalies in the world. Signal strength increases as you approach an anomaly. Alternatively, you can unlock this ability through the Explorer mastery tree (25+ points).',  -- description
    3,       -- Material: ITEM_MATERIAL_METAL
    1        -- stackable: 1 (not stackable)
);

-- Summary
SELECT 
    'Elden''s Eve Spell and Item Templates' as summary,
    (SELECT COUNT(*) FROM `item_template` WHERE `entry` = 900200) as arcane_eye_created,
    'Note: Spell 900100 must be added to Spell.dbc file' as spell_note;

-- Documentation Files:
-- - docs/SPELL_900100_DBC_NOTES.md - Detailed field reference
-- - docs/SPELL_900100_DBC_SPEC.json - Structured specification for automated patching
-- - docs/SPELL_900100_DBC_PATCH_INSTRUCTIONS.md - Step-by-step patching guide
-- - launcher/src/spell_patcher.rs - Updated to include spell 900100 in marker file

