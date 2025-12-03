-- Fix for Issue #21276: Horde Siege Tank Demoralizer spell direction issues
-- Problem: The Demoralizer spell sometimes follows strange directions and hits barrels putting them in combat
-- Expected: The spell should hit where the player aims and not trigger combat on barrels
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/21276

-- Horde Siege Tank vehicle entry: 25588
-- Demoralizer spell: 45033
-- Target Barrels entries: 25499

-- Fix the Demoralizer spell to have proper targeting
UPDATE `spell_dbc` SET
    `Targets` = 0x00000040,  -- TARGET_UNIT_CONE_ENEMY_104 (proper frontal cone)
    `AttributesEx` = `AttributesEx` | 0x00000100,  -- SPELL_ATTR1_CANT_TARGET_SELF
    `AttributesEx3` = `AttributesEx3` | 0x00020000  -- SPELL_ATTR3_ONLY_TARGET_PLAYERS (modified for controlled targeting)
WHERE `Id` = 45033;

-- Make barrels immune to entering combat when hit
UPDATE `creature_template` SET
    `flags_extra` = `flags_extra` | 0x00000002,  -- CREATURE_FLAG_EXTRA_NO_AGGRO
    `unit_flags` = `unit_flags` | 0x00000100  -- UNIT_FLAG_IMMUNE_TO_PC
WHERE `entry` = 25499;

-- Update siege tank to have proper vehicle controls
UPDATE `creature_template` SET
    `VehicleId` = 167,  -- Siege Engine vehicle template
    `flags_extra` = `flags_extra` & ~0x00000080  -- Remove CREATURE_FLAG_EXTRA_TRIGGER
WHERE `entry` = 25588;

-- Add spell script for proper vehicle spell handling
DELETE FROM `spell_script_names` WHERE `spell_id` = 45033 AND `ScriptName` = 'spell_demoralizer_targeting';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(45033, 'spell_demoralizer_targeting');

-- Verification query
-- SELECT entry, name, flags_extra, unit_flags FROM creature_template WHERE entry IN (25588, 25499);
-- SELECT Id, SpellName, Targets, AttributesEx, AttributesEx3 FROM spell_dbc WHERE Id = 45033;
