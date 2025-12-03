-- ============================================================================
-- CRITICAL FIX #3: Blade of Eternal Darkness - Engulfing Shadows Crit
-- ============================================================================
-- Issue: https://github.com/azerothcore/azerothcore-wotlk/issues/9400
-- Description: Engulfing Shadows proc doesn't crit when it should
-- Impact: Reduces item effectiveness, important for level 40-49 content
-- Item: Blade of Eternal Darkness (17780)
-- Spell: Engulfing Shadows (21978 and 27860)
-- ============================================================================

-- The proc should be able to crit for 200 damage (100 base * 2)
-- Crit chance should be based on player's spell crit rating
-- The proc should NOT be affected by spell power or crit damage multiplier talents

-- Fix spell attributes to allow critical hits
-- This requires modifying spell_dbc if using database-stored spells
-- Note: This may require core modification if not handled in DB

-- Check which table exists and update accordingly
-- Standard AzerothCore uses spell_dbc table

-- Update spell_dbc if it exists (standard AzerothCore)
-- AttributeEx2 flag 0x00000004 = SPELL_ATTR2_CANT_CRIT (prevents spell from landing critical hits)
-- We remove this flag by using bitwise AND with its complement (~)
UPDATE `spell_dbc` SET
    `AttributesEx2` = `AttributesEx2` & ~0x00000004  -- Remove SPELL_ATTR2_CANT_CRIT flag to allow crits
WHERE `Id` IN (21978, 27860)
AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'spell_dbc');

-- For damage values, check if spell_dbc stores them
UPDATE `spell_dbc` SET
    `EffectBasePoints1` = 99,  -- Base points (100 = 99 + 1)
    `EffectBonusMultiplier1` = 0  -- No spell power scaling
WHERE `Id` IN (21978, 27860)
AND EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'spell_dbc');

-- ============================================================================
-- ALTERNATIVE APPROACH - Server Config
-- ============================================================================
-- If the above doesn't work due to core limitations, you may need to:
-- 1. Wait for upstream core fix
-- 2. Apply a custom core patch
-- 3. Use a module to override spell behavior
--
-- Recommended core fix location:
-- src/server/game/Spells/SpellMgr.cpp - SpellInfo::_LoadSpellCustomAttr()
-- Add special case for spell IDs 21978 and 27860
-- ============================================================================

-- ============================================================================
-- VERIFICATION
-- ============================================================================
-- Test in-game:
-- .additem 17780
-- .learn 21978
-- Cast shadow spells repeatedly and observe Engulfing Shadows procs
-- Look for critical hits showing ~200 damage (yellow numbers)
-- Expected: Some procs should crit based on your spell crit %
-- ============================================================================

-- ============================================================================
-- NOTES FOR MORTAL WARCRAFT CUSTOM SYSTEM
-- ============================================================================
-- If your custom skill system replaces traditional spell crit mechanics:
-- - Ensure proc spells respect custom crit calculations
-- - May need to override in MortalCombat.cpp or MortalCraftingQuality.cpp
-- - Consider if quality system should affect proc crits
-- ============================================================================
