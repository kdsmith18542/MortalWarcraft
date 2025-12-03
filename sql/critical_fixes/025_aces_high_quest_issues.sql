-- Fix for Issue #23834: Aces High! quest issues
-- Problem: Multiple issues with vehicle spawning, abilities, and parachute
-- Expected: Proper auto-mount, Blazing Speed ability, spear guns attack, parachute on dismount
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23834

-- Quest: Aces High! (13413)
-- Wyrmrest Skytalon entry: 32535
-- Corastrasza entry: 32548
-- Scalesworn Elite entry: 32534
-- Blazing Speed spell: 57092

-- Fix Wyrmrest Skytalon to have Blazing Speed in slot 6
UPDATE `creature_template` SET
    `VehicleId` = 228,
    `spell1` = 56091,  -- Flame Spike
    `spell2` = 56092,  -- Engulf in Flames
    `spell3` = 57090,  -- Revivify
    `spell4` = 57143,  -- Destabilize Azure Dragonshrine Warding Spell
    `spell5` = 49370,  -- Empowered Blizzard
    `spell6` = 57092   -- Blazing Speed (was missing or wrong)
WHERE `entry` = 32535;

-- Make Revivify consume combo points properly
UPDATE `spell_dbc` SET
    `Effect2` = 74,  -- SPELL_EFFECT_CLEAR_COMBO_POINTS
    `EffectImplicitTargetA2` = 1  -- TARGET_UNIT_CASTER
WHERE `Id` = 57090;

-- Fix Scalesworn Elite to use their spells properly
UPDATE `creature_template` SET
    `AIName` = 'SmartAI',
    `spell1` = 61269,  -- Ice Shard (primary attack)
    `spell2` = 61272   -- Arcane Surge
WHERE `entry` = 32534;

-- Add SAI for Scalesworn Elite spellcasting
DELETE FROM `smart_scripts` WHERE `entryorguid` = 32534 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(32534, 0, 0, 0, 0, 0, 100, 0, 0, 0, 2500, 3500, 11, 61269, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Scalesworn Elite - IC - Cast Ice Shard'),
(32534, 0, 1, 0, 0, 0, 100, 0, 5000, 8000, 12000, 15000, 11, 61272, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Scalesworn Elite - IC - Cast Arcane Surge');

-- Add parachute spell on dismount/death
DELETE FROM `spell_linked_spell` WHERE `spell_trigger` IN (-56091, -56092);
INSERT INTO `spell_linked_spell` (`spell_trigger`, `spell_effect`, `type`, `comment`) VALUES
(-56091, 45472, 0, 'Wyrmrest Skytalon - Dismount - Parachute'),  -- When Flame Spike removed (dismount)
(-56092, 45472, 0, 'Wyrmrest Skytalon - Dismount - Parachute');  -- When Engulf removed (dismount)

-- Add spell script for proper vehicle mounting
DELETE FROM `spell_script_names` WHERE `spell_id` = 61421 AND `ScriptName` = 'spell_summon_wyrmrest_skytalon';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(61421, 'spell_summon_wyrmrest_skytalon');

-- Note: Full fix requires C++ implementation for auto-mounting and proper vehicle pathing
-- This SQL provides the base structure

-- Verification query
-- SELECT entry, spell1, spell2, spell3, spell4, spell5, spell6 FROM creature_template WHERE entry = 32535;
-- SELECT * FROM smart_scripts WHERE entryorguid = 32534;
