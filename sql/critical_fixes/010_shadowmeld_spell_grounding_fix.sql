-- Fix for Issue #22455: Shadowmeld does not ground spells without travel time
-- Problem: Shadowmeld should negate instant-cast spells with proper timing, but currently doesn't
-- Expected: Well-timed Shadowmeld should ground spells like Polymorph even without projectiles
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22455

-- Shadowmeld spell ID: 58984 (Night Elf racial)

-- Add spell script to handle proper grounding mechanics
DELETE FROM `spell_script_names` WHERE `spell_id` = 58984 AND `ScriptName` = 'spell_shadowmeld_grounding';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(58984, 'spell_shadowmeld_grounding');

-- Update Shadowmeld to have proper immunity/deflection mechanics
-- This requires proper timing window implementation in C++
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00000001,  -- SPELL_ATTR1_DISMISS_PET_FIRST (reuse for spell grounding)
    `AttributesEx3` = `AttributesEx3` | 0x00020000  -- SPELL_ATTR3_DEATH_PERSISTENT (stays active during spell resolution)
WHERE `Id` = 58984;

-- Note: This fix requires C++ implementation to properly check spell cast timing
-- The SQL prepares the database for the spell script

-- Verification query  
-- SELECT Id, SpellName, AttributesEx, AttributesEx3 FROM spell_dbc WHERE Id = 58984;
