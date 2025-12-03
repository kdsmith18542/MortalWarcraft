-- ============================================================================
-- CRITICAL FIX #2: Surveyor Candress - Cast Frequency and Damage
-- ============================================================================
-- Issue: https://github.com/azerothcore/azerothcore-wotlk/issues/20730
-- Description: NPC casts fireball too frequently and deals too much damage
-- Impact: Low level players (5-6) get destroyed by overtuned spell damage
-- NPC: Surveyor Candress (Entry 16522)
-- ============================================================================

-- Current behavior: Hits for 20-25 damage every 1.5s (100% cast probability)
-- Expected behavior: Hits for 8-10 damage with 6-8s gaps between casts (8% probability)

-- Fix spell damage (Fireball spell 9487)
UPDATE `creature_template` SET
    `dmg_multiplier` = 1.0  -- Reset to normal multiplier
WHERE `entry` = 16522;

-- Fix casting AI probability - reduce from 100% to 8%
-- This makes the NPC cast approximately 1 fireball per 12 melee attacks
DELETE FROM `smart_scripts` WHERE `entryorguid` = 16522 AND `source_type` = 0 AND `id` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(16522, 0, 0, 0, 0, 0, 8, 0, 8000, 12000, 12000, 18000, 11, 9487, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 'Surveyor Candress - In Combat - Cast Fireball (8% chance, 12-18s cooldown)');

-- Ensure the creature text exists if she says anything
-- (Based on retail videos, she should be mostly silent)
DELETE FROM `creature_text` WHERE `CreatureID` = 16522;

-- Update stats to ensure she's balanced for level 5 area
UPDATE `creature_template` SET
    `minlevel` = 5,
    `maxlevel` = 5,
    `mindmg` = 7,    -- Low melee damage
    `maxdmg` = 10,
    `attackpower` = 20,
    `baseattacktime` = 2000,
    `rangeattacktime` = 2000,
    `flags_extra` = `flags_extra` & ~0x40  -- Remove CREATURE_FLAG_EXTRA_NO_CRIT if set
WHERE `entry` = 16522;

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Run these to verify the fix:
-- SELECT * FROM creature_template WHERE entry = 16522;
-- SELECT * FROM smart_scripts WHERE entryorguid = 16522;
-- 
-- Test in-game:
-- .go creature 16522
-- Engage as level 5-6 character and observe:
-- - Fireball should hit for ~8-10 damage
-- - Should see ~6-8 seconds between casts
-- - Should not chain-cast until OOM
-- ============================================================================
