-- Fix for Issue #12115: Replenishment aura (57669) generates threat
-- Problem: Replenishment should not generate threat, but it currently does
-- Expected: The aura should restore mana without causing the caster to enter combat or generate threat
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/12115

-- Replenishment spell ID: 57669
-- This is triggered by various talents:
-- - Judgements of the Wise (Paladin) - 31878
-- - Improved Soul Leech (Warlock) - 54118  
-- - Hunting Party (Hunter) - 53292
-- - Enduring Winter (Mage) - 44561
-- - Vampiric Touch (Priest) - 48160

-- Add SPELL_ATTR1_NO_THREAT flag (0x00010000) to prevent threat generation
UPDATE `spell_dbc` SET
    `AttributesEx` = `AttributesEx` | 0x00010000
WHERE `Id` = 57669;

-- Also ensure the spell doesn't break stealth or cause combat
UPDATE `spell_dbc` SET
    `AttributesEx3` = `AttributesEx3` | 0x00040000  -- SPELL_ATTR3_NO_INITIAL_AGGRO
WHERE `Id` = 57669;

-- Update the periodic aura to not generate threat
UPDATE `spell_dbc` SET
    `Attributes` = `Attributes` | 0x00000080  -- SPELL_ATTR0_PASSIVE (treat as passive for threat)
WHERE `Id` = 57669;

-- Verification query
-- SELECT Id, SpellName, Attributes, AttributesEx, AttributesEx3 FROM spell_dbc WHERE Id = 57669;
