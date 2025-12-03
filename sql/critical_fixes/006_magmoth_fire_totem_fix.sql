-- Fix for Issue #23680: Magmoth Fire Totem does nothing
-- Problem: Magmoth Fire Totem (entry 25444) doesn't cast any spells
-- Expected: The totem should cast a fireball that hits for 750-800 damage
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23680

-- Update the totem to have proper spell casting
UPDATE `creature_template` SET
    `AIName` = 'SmartAI',
    `ScriptName` = ''
WHERE `entry` = 25444;

-- Remove any existing SAI scripts for this totem
DELETE FROM `smart_scripts` WHERE `entryorguid` = 25444 AND `source_type` = 0;

-- Add SAI script to make totem cast Magmoth Fire every 3 seconds
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(25444, 0, 0, 0, 0, 0, 100, 0, 1000, 1000, 3000, 3000, 11, 45575, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Magmoth Fire Totem - In Combat - Cast Magmoth Fire');

-- Verification query
-- SELECT * FROM creature_template WHERE entry = 25444;
-- SELECT * FROM smart_scripts WHERE entryorguid = 25444;
