-- Fix for Issue #23790: Dun-da-Dun-tah! quest various issues
-- Problem: Harrison Jones RP timing issues, snake attackable, drakkars spawn all at once
-- Expected: Proper RP timing, snake not attackable, incremental drakkar spawns
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23790

-- Quest: Dun-da-Dun-tah! (12082)
-- Harrison Jones entry: 26814
-- Sholazar Guardian entry: 27431 (the snake)
-- Ancient Drakkari Warmonger entry: 27425

-- Fix Harrison Jones movement speed and timing
UPDATE `creature_template` SET
    `speed_walk` = 1.0,
    `speed_run` = 1.14286  -- Normal run speed
WHERE `entry` = 26814;

-- Make the snake unattackable during RP (faction change)
UPDATE `creature_template` SET
    `faction` = 35,  -- Friendly during RP phase
    `flags_extra` = `flags_extra` | 0x00000040  -- CREATURE_FLAG_EXTRA_CIVILIAN
WHERE `entry` = 27431;

-- Fix snake spit visual to come from mouth
DELETE FROM `spell_script_names` WHERE `spell_id` = 49532 AND `ScriptName` = 'spell_sholazar_snake_spit';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(49532, 'spell_sholazar_snake_spit');

-- Prevent poison stacking
UPDATE `spell_dbc` SET
    `MaxStackAmount` = 1
WHERE `Id` = 49532;  -- Snake poison spell

-- Prevent Ancient Drakkari curse stacking
UPDATE `spell_dbc` SET
    `MaxStackAmount` = 1
WHERE `Id` = 50635;  -- Ancient Drakkari curse

-- Update Harrison Jones SAI for better RP timing
DELETE FROM `smart_scripts` WHERE `entryorguid` = 26814 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(26814, 0, 0, 0, 19, 0, 100, 0, 12082, 0, 0, 0, 80, 2681400, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Harrison Jones - On Quest Accept - Run Timed Action List'),
(26814, 0, 1, 0, 19, 0, 100, 0, 12082, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 19, 27425, 50, 0, 0, 0, 0, 0, 'Harrison Jones - On Quest Accept - Despawn Old Drakkars');

-- Note: Full fix requires C++ script for incremental spawning and proper RP timing
-- This SQL provides basic structure and prevents some issues

-- Verification query
-- SELECT entry, speed_walk, speed_run FROM creature_template WHERE entry = 26814;
-- SELECT Id, MaxStackAmount FROM spell_dbc WHERE Id IN (49532, 50635);
