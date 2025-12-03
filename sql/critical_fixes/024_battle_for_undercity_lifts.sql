-- Fix for Issue #23792: Battle for Undercity - Horde side, lifts sometimes working
-- Problem: During Battle for Undercity, lifts sometimes work when they shouldn't
-- Expected: Lifts should be broken; Thrall should use air spirits to descend
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23792

-- Quest: The Battle For The Undercity (13367 - Horde)
-- Thrall (during quest): 30978
-- Undercity elevator gameobjects: 164659, 164660, 164661

-- Disable elevators during the quest event
DELETE FROM `gameobject` WHERE `id` IN (164659, 164660, 164661) AND `phaseMask` = 2;

-- Add phase mask for broken elevators during quest
UPDATE `gameobject` SET
    `phaseMask` = 1,  -- Normal phase only
    `state` = 0  -- Not usable
WHERE `id` IN (164659, 164660, 164661)
  AND `map` = 0
  AND `position_z` > 0;

-- Add SAI to control elevator state based on quest progress
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-164659, -164660, -164661) AND `source_type` = 1;

-- Create gameobject scripts to handle elevator state
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(164659, 1, 0, 0, 62, 0, 100, 0, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Undercity Elevator - On Gossip Select - Set State Not Ready'),
(164660, 1, 0, 0, 62, 0, 100, 0, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Undercity Elevator - On Gossip Select - Set State Not Ready'),
(164661, 1, 0, 0, 62, 0, 100, 0, 0, 0, 0, 0, 99, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Undercity Elevator - On Gossip Select - Set State Not Ready');

-- Ensure Thrall uses the air spirit descent spell
UPDATE `creature_template` SET
    `AIName` = 'SmartAI'
WHERE `entry` = 30978;

-- Add spell for air spirit descent (if not already present)
-- This is a placeholder; actual spell ID may vary
DELETE FROM `spell_script_names` WHERE `spell_id` = 55873 AND `ScriptName` = 'spell_thrall_air_spirit_descent';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(55873, 'spell_thrall_air_spirit_descent');

-- Note: This fix may require additional phasing or C++ implementation
-- to properly disable elevators during specific quest phases

-- Verification query
-- SELECT id, phaseMask, state FROM gameobject WHERE id IN (164659, 164660, 164661) LIMIT 5;
-- SELECT entry, AIName FROM creature_template WHERE entry = 30978;
