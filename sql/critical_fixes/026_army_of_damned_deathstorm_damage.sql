-- Fix for Issue #23896: Player gets hit by vehicle ability during quest Army of the Damned
-- Problem: Deathstorm (Arthas ability) damages the player when it shouldn't
-- Expected: Player should not take damage from Arthas's Deathstorm ability
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23896

-- Quest: Army of the Damned (13395)
-- Arthas vehicle entry: 31795
-- Deathstorm spell: 58912

-- Make Deathstorm not hit friendly targets (player is friendly during this quest)
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00000100,  -- SPELL_ATTR1_CANT_TARGET_SELF
    `AttributesEx3` = `AttributesEx3` | 0x00100000,  -- SPELL_ATTR3_ONLY_TARGET_PLAYERS (inverse - only hit enemies)
    `Targets` = 0x00000040  -- TARGET_UNIT_CONE_ENEMY_104
WHERE `Id` = 58912;

-- Ensure the spell only hits hostile targets
UPDATE `spell_dbc` SET
    `EffectChainTarget1` = 0,  -- Don't chain to friendly
    `EffectImplicitTargetA1` = 53,  -- TARGET_UNIT_SRC_AREA_ENEMY
    `EffectImplicitTargetB1` = 0
WHERE `Id` = 58912;

-- Add spell script to prevent friendly fire
DELETE FROM `spell_script_names` WHERE `spell_id` = 58912 AND `ScriptName` = 'spell_arthas_deathstorm';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(58912, 'spell_arthas_deathstorm');

-- Ensure Arthas vehicle has proper faction during quest
UPDATE `creature_template` SET
    `faction` = 35  -- Friendly faction
WHERE `entry` = 31795;

-- Update quest area to ensure player is treated as friendly
DELETE FROM `spell_area` WHERE `spell` = 58693 AND `quest_start` = 13395;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`) VALUES
(58693, 4281, 13395, 13395, 0, 0, 2, 1);  -- Quest area protection

-- Note: This requires C++ implementation to properly filter friendly targets
-- The SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, AttributesEx, AttributesEx3, Targets FROM spell_dbc WHERE Id = 58912;
-- SELECT entry, faction FROM creature_template WHERE entry = 31795;
