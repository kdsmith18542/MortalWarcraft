-- Fix for Issue #22028: Freezing trap is not correctly reflected by spell reflection
-- Problem: Freezing Trap doesn't freeze the hunter when reflected by Spell Reflection or Gyrofreeze Ice Reflector
-- Expected: If reflected, the trap should freeze the hunter who placed it
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22028

-- Freezing Trap spell IDs (trap aura):
-- 1499 (Rank 1), 14310 (Rank 2), 14311 (Rank 3)

-- Freezing Trap Effect spell IDs (the freeze effect):
-- 3355 (Rank 1), 14308 (Rank 2), 14309 (Rank 3)

-- Make Freezing Trap reflectable
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` & ~0x00000020,  -- Remove SPELL_ATTR1_CANT_BE_REFLECTED
    `AttributesEx4` = `AttributesEx4` | 0x00000001  -- SPELL_ATTR4_NOT_STEALABLE (but still reflectable)
WHERE `Id` IN (1499, 14310, 14311, 3355, 14308, 14309);

-- Add spell script to handle proper reflection mechanics
DELETE FROM `spell_script_names` WHERE `spell_id` IN (3355, 14308, 14309) AND `ScriptName` = 'spell_freezing_trap_reflection';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(3355, 'spell_freezing_trap_reflection'),
(14308, 'spell_freezing_trap_reflection'),
(14309, 'spell_freezing_trap_reflection');

-- Update trap trigger to be reflectable
UPDATE `spell_dbc` SET
    `AttributesEx2` = `AttributesEx2` | 0x00000020  -- SPELL_ATTR2_CAN_TARGET_NOT_IN_LOS (allows reflection to work)
WHERE `Id` IN (1499, 14310, 14311);

-- Note: This requires C++ implementation to properly handle trap reflection
-- The SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, AttributesEx, AttributesEx2, AttributesEx4 FROM spell_dbc WHERE Id IN (1499, 14310, 14311, 3355, 14308, 14309);
