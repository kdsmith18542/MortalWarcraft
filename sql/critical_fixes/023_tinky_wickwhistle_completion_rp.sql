-- Fix for Issue #23777: I'm Stuck in this Damned Cage... But Not For Long! missing completion RP
-- Problem: No RP happens when turning in the quest
-- Expected: Tinky should teleport and say lines about failing/feeling lighter
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23777

-- Quest: I'm Stuck in this Damned Cage... But Not For Long! (11699)
-- Tinky Wickwhistle entry: 25714

-- Add quest completion SAI script for Tinky
DELETE FROM `smart_scripts` WHERE `entryorguid` = 25714 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25714, 0, 0, 1, 20, 0, 100, 0, 11699, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Tinky Wickwhistle - On Quest Reward - Say Line 0'),
(25714, 0, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 11, 46025, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Tinky Wickwhistle - On Quest Reward - Cast Teleport Visual'),
(25714, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 41, 2000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Tinky Wickwhistle - On Quest Reward - Despawn After 2s'),
(25714, 0, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 1, 1, 2000, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Tinky Wickwhistle - On Quest Reward - Say Line 1 After 2s'),
(25714, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 12, 25714, 1, 300000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Tinky Wickwhistle - On Quest Reward - Respawn After 5min');

-- Add creature text for Tinky's dialogue
DELETE FROM `creature_text` WHERE `CreatureID` = 25714;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(25714, 0, 0, 'Okay, $n, here we go. Cross your fingers, toes, eyes and whatever else you can cross!', 12, 0, 100, 0, 0, 0, 25349, 0, 'Tinky Wickwhistle'),
(25714, 1, 0, 'Oh no, it didn\'t work! Somehow I feel... lighter.', 12, 0, 100, 0, 0, 0, 25350, 0, 'Tinky Wickwhistle');

-- Ensure Tinky has proper respawn time
UPDATE `creature` SET
    `spawntimesecs` = 300
WHERE `id` = 25714;

-- Verification query
-- SELECT * FROM smart_scripts WHERE entryorguid = 25714;
-- SELECT * FROM creature_text WHERE CreatureID = 25714;
