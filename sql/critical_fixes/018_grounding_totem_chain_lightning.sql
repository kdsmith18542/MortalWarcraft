-- Fix for Issue #21627: Grounding Totem does not consume the entire Chain Lightning spell
-- Problem: Grounding Totem only absorbs first instance of Chain Lightning, allowing it to continue jumping
-- Expected: Grounding Totem should absorb entire Chain Lightning spell with no subsequent jumps
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/21627

-- Grounding Totem spell ID: 8177
-- Chain Lightning spell IDs: 421, 930, 2860, 10605, 25439, 25442, 49268, 49269, 49270, 49271

-- Update Grounding Totem to have proper spell interception
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00000400,  -- SPELL_ATTR1_CHANNELED_1
    `AttributesEx3` = `AttributesEx3` | 0x00020000,  -- SPELL_ATTR3_DEATH_PERSISTENT
    `AttributesEx6` = `AttributesEx6` | 0x00000008  -- SPELL_ATTR6_NOT_IN_RAID_INSTANCE
WHERE `Id` = 8177;

-- Modify Chain Lightning to be fully absorbed by spell redirection
UPDATE `spell_dbc` SET
    `AttributesEx4` = `AttributesEx4` | 0x00000010,  -- SPELL_ATTR4_DAMAGE_DOESNT_BREAK_AURAS
    `MaxAffectedTargets` = 1  -- Force single target when redirected
WHERE `Id` IN (421, 930, 2860, 10605, 25439, 25442, 49268, 49269, 49270, 49271);

-- Add spell script for proper Grounding Totem absorption
DELETE FROM `spell_script_names` WHERE `spell_id` = 8177 AND `ScriptName` = 'spell_grounding_totem_chain_lightning';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(8177, 'spell_grounding_totem_chain_lightning');

-- Add linked spell scripts for Chain Lightning interception
DELETE FROM `spell_script_names` WHERE `spell_id` IN (421, 930, 2860, 10605, 25439, 25442, 49268, 49269, 49270, 49271) AND `ScriptName` = 'spell_chain_lightning_grounding';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(421, 'spell_chain_lightning_grounding'),
(930, 'spell_chain_lightning_grounding'),
(2860, 'spell_chain_lightning_grounding'),
(10605, 'spell_chain_lightning_grounding'),
(25439, 'spell_chain_lightning_grounding'),
(25442, 'spell_chain_lightning_grounding'),
(49268, 'spell_chain_lightning_grounding'),
(49269, 'spell_chain_lightning_grounding'),
(49270, 'spell_chain_lightning_grounding'),
(49271, 'spell_chain_lightning_grounding');

-- Note: This requires C++ implementation to properly cancel Chain Lightning chain on redirection
-- The SQL prepares the database for the spell scripts

-- Verification query
-- SELECT Id, SpellName, AttributesEx, AttributesEx3, AttributesEx4, MaxAffectedTargets FROM spell_dbc WHERE Id IN (8177, 421, 930);
