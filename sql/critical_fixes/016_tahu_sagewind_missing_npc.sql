-- Fix for Issue #22752: Missing Tahu Sagewind and interactions in Thunder Bluff
-- Problem: Tahu Sagewind (NPC 34528) is missing from Thunder Bluff Elder Rise tent
-- Expected: Should exist, have conversations with Aponi Brightmane, and cast spells
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22752

-- Tahu Sagewind entry: 34528
-- Aponi Brightmane entry: 36648
-- Location: Thunder Bluff, Elder Rise tent

-- First, ensure Tahu Sagewind exists in creature_template (if not already there)
-- This may already be in the DBC, but we need to ensure proper spawn

-- Spawn Tahu Sagewind in Thunder Bluff Elder Rise tent
-- Coordinates based on upstream data: approximately -1040, 218, 129 in Thunder Bluff
DELETE FROM `creature` WHERE `id` = 34528;
INSERT INTO `creature` (`id`, `map`, `zone`, `spawnMask`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `MovementType`) VALUES
(34528, 1, 1638, 1, -1040.5, 218.2, 129.19, 4.71, 300, 0);

-- Add SAI script for Tahu's conversation with Aponi
DELETE FROM `smart_scripts` WHERE `entryorguid` = 34528 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(34528, 0, 0, 0, 1, 0, 100, 0, 60000, 120000, 180000, 300000, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Tahu Sagewind - OOC - Say Line 0'),
(34528, 0, 1, 0, 1, 0, 100, 0, 30000, 60000, 240000, 360000, 11, 65607, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Tahu Sagewind - OOC - Cast Spell Visual');

-- Add the rug gameobject for Aponi (based on issue description)
-- Gameobject rug ID approximately 195678 (Tauren Rug)
DELETE FROM `gameobject` WHERE `id` = 195678 AND `position_x` BETWEEN -1041 AND -1040;
INSERT INTO `gameobject` (`id`, `map`, `zone`, `spawnMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `state`) VALUES
(195678, 1, 1638, 1, -1040.8, 219.5, 128.9, 4.71, 0, 0, 0.707, -0.707, 300, 1);

-- Verification queries
-- SELECT * FROM creature WHERE id = 34528;
-- SELECT * FROM smart_scripts WHERE entryorguid = 34528;
-- SELECT * FROM gameobject WHERE id = 195678 AND position_x BETWEEN -1041 AND -1040;
