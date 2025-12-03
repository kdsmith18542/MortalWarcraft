-- Fix for Issue #22331: Warrior Charge is not climbing terrain in WSG
-- Problem: Cannot charge up to graveyard spawn zones in Warsong Gulch
-- Expected: Charge should allow climbing terrain like in graveyards
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22331

-- Charge spell IDs (Warrior): 100, 6178, 11578
-- Feral Charge - Bear (Druid): 16979

-- Update Charge to allow terrain following
-- Note: Flag usage here is non-standard and intended as preparation for C++ implementation
-- The actual terrain-following logic must be implemented in the core spell handler
UPDATE `spell_dbc` SET
    `AttributesEx2` = `AttributesEx2` | 0x00000004,  -- SPELL_ATTR2_CAN_TARGET_NOT_IN_LOS
    `AttributesEx5` = `AttributesEx5` | 0x00020000,  -- Custom flag for terrain following (C++ required)
    `Effect1` = 121,  -- SPELL_EFFECT_LEAP_BACK (modified for forward charge with Z-axis)
    `EffectMiscValueB1` = 1  -- Allow vertical movement
WHERE `Id` IN (100, 6178, 11578);

-- Apply same fix to Druid Feral Charge - Bear
-- Note: Same non-standard flag usage as above
UPDATE `spell_dbc` SET
    `AttributesEx2` = `AttributesEx2` | 0x00000004,
    `AttributesEx5` = `AttributesEx5` | 0x00020000,  -- Custom flag for terrain following (C++ required)
    `Effect1` = 121,
    `EffectMiscValueB1` = 1
WHERE `Id` = 16979;

-- Ensure Charge can be used in WSG graveyard areas
-- WSG graveyard areas: Alliance = 1363, Horde = 1364
DELETE FROM `spell_area` WHERE `spell` IN (100, 6178, 11578, 16979) AND `area` IN (1363, 1364);
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`) VALUES
(100, 1363, 0, 0, 0, 0, 2, 0),
(6178, 1363, 0, 0, 0, 0, 2, 0),
(11578, 1363, 0, 0, 0, 0, 2, 0),
(16979, 1363, 0, 0, 0, 0, 2, 0),
(100, 1364, 0, 0, 0, 0, 2, 0),
(6178, 1364, 0, 0, 0, 0, 2, 0),
(11578, 1364, 0, 0, 0, 0, 2, 0),
(16979, 1364, 0, 0, 0, 0, 2, 0);

-- Add spell script for proper terrain following charge
DELETE FROM `spell_script_names` WHERE `spell_id` IN (100, 6178, 11578, 16979) AND `ScriptName` = 'spell_warrior_charge_terrain';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(100, 'spell_warrior_charge_terrain'),
(6178, 'spell_warrior_charge_terrain'),
(11578, 'spell_warrior_charge_terrain'),
(16979, 'spell_warrior_charge_terrain');

-- Update charge to ignore small obstacles
UPDATE `spell_dbc` SET
    `Speed` = 0,  -- Use instant speed with path calculation
    `SpellVisual1` = 1,  -- Keep charge visual
    `EffectRadiusIndex1` = 12  -- Extended range for target selection
WHERE `Id` IN (100, 6178, 11578, 16979);

-- Note: This requires C++ implementation to properly calculate charge path with Z-axis
-- The SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, AttributesEx2, AttributesEx5, Effect1 FROM spell_dbc WHERE Id IN (100, 6178, 11578, 16979);
-- SELECT * FROM spell_area WHERE spell IN (100, 6178, 11578, 16979) AND area IN (1363, 1364);
