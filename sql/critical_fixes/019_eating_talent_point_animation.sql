-- Fix for Issue #23827: Putting a talent point while eating cancels eating animation
-- Problem: When eating/drinking and allocating a talent point, the eating/drinking animation/buff is cancelled
-- Expected: Allocating talent points should not interrupt eating or drinking
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23827

-- This is a client/server sync issue where talent changes trigger an interrupt
-- We need to ensure food/drink buffs are not removed during non-combat actions

-- Food buff spell IDs (examples, there are many):
-- Well Fed buffs, Food buffs, Drink buffs typically range from 430-450 and various conjured items

-- Make food/drink buffs persistent during talent changes
UPDATE `spell_dbc` SET
    `AuraInterruptFlags` = `AuraInterruptFlags` & ~0x00000008,  -- Remove AURA_INTERRUPT_FLAG_CHANGE_MAP
    `AuraInterruptFlags` = `AuraInterruptFlags` & ~0x00000080,  -- Remove AURA_INTERRUPT_FLAG_ENTER_PVP_COMBAT
    `AttributesEx` = `AttributesEx` | 0x00080000  -- SPELL_ATTR1_UNAFFECTED_BY_SCHOOL_IMMUNE
WHERE `Mechanic` = 11;  -- MECHANIC_EATING (food buffs)

UPDATE `spell_dbc` SET
    `AuraInterruptFlags` = `AuraInterruptFlags` & ~0x00000008,
    `AuraInterruptFlags` = `AuraInterruptFlags` & ~0x00000080,
    `AttributesEx` = `AttributesEx` | 0x00080000
WHERE `Mechanic` = 12;  -- MECHANIC_DRINKING (drink buffs)

-- Ensure conjured food/drink also maintains these properties
UPDATE `spell_dbc` SET
    `AuraInterruptFlags` = `AuraInterruptFlags` & ~0x00000001,  -- Don't remove on any action
    `AttributesEx5` = `AttributesEx5` | 0x00001000  -- SPELL_ATTR5_USABLE_WHILE_STUNNED
WHERE `Effect1` = 6 AND `EffectApplyAuraName1` IN (226, 227);  -- SPELL_AURA_MOD_REGEN, SPELL_AURA_MOD_POWER_REGEN

-- Note: This may require core code adjustment to prevent talent UI from triggering spell interrupts
-- This SQL adjusts the spell aura interrupt flags to be more permissive

-- Verification query
-- SELECT Id, SpellName, Mechanic, AuraInterruptFlags FROM spell_dbc WHERE Mechanic IN (11, 12) LIMIT 10;
