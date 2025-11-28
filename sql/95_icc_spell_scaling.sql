-- ==================================================
-- Project Mortal Warcraft
-- Feature: ICC Spell Scaling Entries
-- Description: Adds spell scaling for problematic ICC boss abilities
-- Based on: docs/specs/32-npc-and-encounter-rebalance.md
-- Data Source: https://www.wowhead.com/wotlk/database
-- 
-- ⚠️ WARNING: Spell IDs need verification against database
-- Run sql/96_verify_spell_ids.sql first to verify IDs exist
-- Many spell IDs from Wowhead may not match our DBC version
-- ==================================================

-- Lich King Abilities
-- NOTE: These IDs need verification - may not exist in our DBC
-- TODO: Verify spell IDs from creature_template_spell for entry 36597
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (69409, 0.25, 0.4, 'Soul Reaper - Lich King (main ability) - NEEDS VERIFICATION'),
-- (72350, 0.3, 0.5, 'Fury of Frostmourne - Lich King (enrage) - NEEDS VERIFICATION'),
-- (72262, 0.3, 0.5, 'Quake - Lich King (AoE) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Lord Marrowgar Abilities
-- NOTE: Verified spell ID 69807 exists for "Saber Lash"
-- Other IDs (69055, 69057) need verification - may be server-side only
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(69807, 0.35, 0.6, 'Saber Lash - Lord Marrowgar (cleave) - VERIFIED')
-- (69055, 0.3, 0.5, 'Bone Storm - Lord Marrowgar (channeled AoE) - NEEDS VERIFICATION'),
-- (69057, 0.3, 0.5, 'Bone Slice - Lord Marrowgar (melee) - NEEDS VERIFICATION')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Lady Deathwhisper Abilities
-- NOTE: These IDs need verification
-- TODO: Query creature_template_spell for entry 36855
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (71001, 0.3, 0.5, 'Death and Decay - Lady Deathwhisper (ground AoE) - NEEDS VERIFICATION'),
-- (71237, 0.35, 0.6, 'Frostbolt - Lady Deathwhisper (single target) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Gunship Battle Abilities
-- NOTE: These IDs exist in database (verified from creature_template_spell)
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(70161, 0.3, 0.5, 'Gunship Battle ability - VERIFIED (server-side)'),
(70116, 0.3, 0.5, 'Cannon Blast - Gunship Battle - VERIFIED (server-side)')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Deathbringer Saurfang Abilities
-- NOTE: These IDs need verification
-- TODO: Query creature_template_spell for entry 37813
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (72293, 0.3, 0.5, 'Boiling Blood - Deathbringer Saurfang (DoT) - NEEDS VERIFICATION'),
-- (72410, 0.35, 0.6, 'Rune of Blood - Deathbringer Saurfang (heal/damage) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Rotface Abilities
-- NOTE: These IDs exist in database (verified from creature_template_spell)
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(69774, 0.3, 0.5, 'Slime Spray - Rotface (AoE) - VERIFIED (server-side)'),
(69508, 0.35, 0.6, 'Ooze Explosion - Rotface (AoE) - VERIFIED (server-side)'),
(69789, 0.3, 0.5, 'Rotface ability - VERIFIED (server-side)'),
(69674, 0.35, 0.6, 'Rotface ability - VERIFIED (server-side)')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Festergut Abilities
-- NOTE: These IDs exist in database (verified from creature_template_spell)
-- They may be server-side spells (no name in spell_dbc) but IDs are valid
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(69195, 0.3, 0.5, 'Pungent Blight - Festergut (AoE) - VERIFIED (server-side)'),
(69279, 0.35, 0.6, 'Gas Spore - Festergut (explosion) - VERIFIED (server-side)'),
(70138, 0.3, 0.5, 'Festergut ability - VERIFIED (server-side)')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Professor Putricide Abilities
-- NOTE: These IDs exist in database (verified from creature_template_spell)
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(70346, 0.3, 0.5, 'Putricide ability - VERIFIED (server-side)'),
(71968, 0.35, 0.6, 'Putricide ability - VERIFIED (server-side)'),
(71617, 0.3, 0.5, 'Putricide ability - VERIFIED (server-side)')
-- (70341, 0.3, 0.5, 'Unbound Plague - NEEDS VERIFICATION'),
-- (70475, 0.35, 0.6, 'Malleable Goo - NEEDS VERIFICATION')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Blood Prince Council Abilities
-- NOTE: These IDs need verification
-- TODO: Query creature_template_spell for Blood Prince entries
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (72037, 0.3, 0.5, 'Empowered Shock Vortex - Blood Prince Council (AoE) - NEEDS VERIFICATION'),
-- (72039, 0.35, 0.6, 'Empowered Bloodbolt - Blood Prince Council (single target) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Blood-Queen Lana'thel Abilities
-- NOTE: These IDs need verification
-- TODO: Query creature_template_spell for entry 37970
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (71446, 0.3, 0.5, 'Bloodbolt - Blood-Queen Lana''thel (single target) - NEEDS VERIFICATION'),
-- (71478, 0.35, 0.6, 'Bloodbolt Splash - Blood-Queen Lana''thel (AoE) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Valithria Dreamwalker Abilities (trash)
-- NOTE: These IDs need verification
-- TODO: Query creature_template_spell for Valithria trash entries
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (70115, 0.3, 0.5, 'Frostbolt Volley - Valithria trash (AoE) - NEEDS VERIFICATION'),
-- (70117, 0.35, 0.6, 'Ice Tomb - Valithria trash (single target) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Sindragosa Abilities
-- NOTE: These IDs need verification
-- TODO: Query creature_template_spell for entry 38433
-- INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
-- (70126, 0.3, 0.5, 'Frost Breath - Sindragosa (cone AoE) - NEEDS VERIFICATION'),
-- (70127, 0.35, 0.6, 'Ice Tomb - Sindragosa (single target) - NEEDS VERIFICATION'),
-- (69762, 0.3, 0.5, 'Unchained Magic - Sindragosa (AoE) - NEEDS VERIFICATION')
-- ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Summary
SELECT 
    COUNT(*) as total_spells_scaled,
    SUM(CASE WHEN notes LIKE '%VERIFIED%' THEN 1 ELSE 0 END) as verified_count,
    SUM(CASE WHEN notes LIKE '%NEEDS VERIFICATION%' THEN 1 ELSE 0 END) as needs_verification_count
FROM mortal_spell_scaling
WHERE notes LIKE '%ICC%' OR notes LIKE '%Lich King%' OR notes LIKE '%Marrowgar%' 
   OR notes LIKE '%Deathwhisper%' OR notes LIKE '%Saurfang%' OR notes LIKE '%Putricide%'
   OR notes LIKE '%Sindragosa%' OR notes LIKE '%Lana''thel%' OR notes LIKE '%Rotface%'
   OR notes LIKE '%Festergut%' OR notes LIKE '%Gunship%' OR notes LIKE '%Valithria%';

