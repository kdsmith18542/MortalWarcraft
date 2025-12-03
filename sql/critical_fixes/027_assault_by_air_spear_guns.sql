-- Fix for Issue #21680: Assault by Air - Ymirheim Spear Guns do nothing & no parachute
-- Problem: Spear guns don't attack player, dismounting doesn't trigger parachute
-- Expected: Spear guns should attack unless in fog; parachute should activate on dismount
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/21680

-- Quest: Assault by Air (13309)
-- Ymirheim Spear Gun entry: 31280
-- Hyldsmeet Proto-Drake vehicle: 31808
-- Parachute spell: 45472

-- Make Spear Guns actively attack
UPDATE `creature_template` SET
    `AIName` = 'SmartAI',
    `flags_extra` = `flags_extra` & ~0x00000080  -- Remove CREATURE_FLAG_EXTRA_TRIGGER
WHERE `entry` = 31280;

-- Add SAI for Spear Gun attacks
DELETE FROM `smart_scripts` WHERE `entryorguid` = 31280 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(31280, 0, 0, 0, 9, 0, 100, 0, 0, 40, 3000, 4000, 11, 59244, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Ymirheim Spear Gun - Within Range - Cast Harpoon'),
(31280, 0, 1, 0, 23, 0, 100, 0, 59270, 1, 1000, 1000, 28, 59244, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Ymirheim Spear Gun - Has Aura Fog - Stop Attacking');

-- Add parachute on dismount from proto-drake
DELETE FROM `spell_linked_spell` WHERE `spell_trigger` = -59270;
INSERT INTO `spell_linked_spell` (`spell_trigger`, `spell_effect`, `type`, `comment`) VALUES
(-59270, 45472, 0, 'Hyldsmeet Proto-Drake - Dismount - Parachute');

-- Update proto-drake vehicle to grant parachute on death/dismount
UPDATE `creature_template` SET
    `flags_extra` = `flags_extra` | 0x00200000  -- CREATURE_FLAG_EXTRA_TRIGGER_DEATH
WHERE `entry` = 31808;

-- Add vehicle spell script for parachute
DELETE FROM `spell_script_names` WHERE `spell_id` = 59319 AND `ScriptName` = 'spell_proto_drake_parachute';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(59319, 'spell_proto_drake_parachute');

-- Ensure spear guns have proper combat range
UPDATE `creature_template` SET
    `RangedBaseAttackTime` = 3000,
    `unit_flags` = `unit_flags` & ~0x00000100  -- Remove UNIT_FLAG_IMMUNE_TO_PC
WHERE `entry` = 31280;

-- Note: Full fix requires C++ implementation for fog detection and proper parachute trigger
-- This SQL provides the base structure

-- Verification query
-- SELECT entry, AIName, flags_extra, unit_flags FROM creature_template WHERE entry IN (31280, 31808);
-- SELECT * FROM smart_scripts WHERE entryorguid = 31280;
-- SELECT * FROM spell_linked_spell WHERE spell_trigger = -59270;
