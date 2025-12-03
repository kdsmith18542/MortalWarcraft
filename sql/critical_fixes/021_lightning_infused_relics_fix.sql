-- Fix for Issue #23596: Lightning Infused Relics - Collect Data vehicle spell wrong behavior
-- Problem: Using Collect Data spell warps player through world ending in Westfall graveyard
-- Expected: Spell should collect data from the relic without teleporting player
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23596

-- Quest: Lightning Infused Relics (11494)
-- Vehicle/Disguise entry: 24849 (Iron Rune Construct Disguise)
-- Collect Data spell: 44802

-- Fix the Collect Data spell to not teleport player
UPDATE `spell_dbc` SET
    `Effect1` = 3,  -- SPELL_EFFECT_DUMMY instead of teleport
    `EffectImplicitTargetA1` = 1,  -- TARGET_UNIT_CASTER
    `AttributesEx3` = `AttributesEx3` & ~0x00000004  -- Remove any teleport flags
WHERE `Id` = 44802;

-- Add spell script to handle proper data collection
DELETE FROM `spell_script_names` WHERE `spell_id` = 44802 AND `ScriptName` = 'spell_collect_data_lightning_relic';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(44802, 'spell_collect_data_lightning_relic');

-- Ensure the vehicle/disguise works properly
UPDATE `creature_template` SET
    `flags_extra` = `flags_extra` | 0x00000080,  -- CREATURE_FLAG_EXTRA_TRIGGER
    `unit_flags` = `unit_flags` | 0x00000100  -- UNIT_FLAG_IMMUNE_TO_PC
WHERE `entry` = 24849;

-- Update quest to ensure proper credit
DELETE FROM `spell_area` WHERE `spell` = 44800 AND `quest_start` = 11494;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`) VALUES
(44800, 495, 11494, 11494, 0, 0, 2, 1);  -- Storm Peaks area

-- Note: This requires C++ implementation to properly handle data collection without teleport
-- The SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, Effect1, EffectImplicitTargetA1 FROM spell_dbc WHERE Id = 44802;
-- SELECT entry, name, flags_extra, unit_flags FROM creature_template WHERE entry = 24849;
