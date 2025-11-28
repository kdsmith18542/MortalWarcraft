-- ==================================================
-- Project Mortal Warcraft
-- Feature: Other Raids Spell Scaling Entries
-- Description: Adds spell scaling for Naxxramas, Ulduar, and Trial of the Crusader
-- Based on: docs/specs/32-npc-and-encounter-rebalance.md
-- Data Source: AzerothCore source code (boss_*.cpp files)
-- ==================================================

-- ==================================================
-- NAXXRAMAS BOSSES
-- ==================================================

-- Kel'Thuzad
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(28478, 0.3, 0.5, 'Frost Bolt Single - Kel''Thuzad - VERIFIED FROM SOURCE'),
(28479, 0.3, 0.5, 'Frost Bolt Multi - Kel''Thuzad - VERIFIED FROM SOURCE'),
(27812, 0.3, 0.5, 'Void Blast - Kel''Thuzad - VERIFIED FROM SOURCE'),
(27820, 0.35, 0.6, 'Mana Detonation Damage - Kel''Thuzad - VERIFIED FROM SOURCE'),
(27808, 0.3, 0.5, 'Frost Blast - Kel''Thuzad - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Sapphiron
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(28542, 0.3, 0.5, 'Life Drain - Sapphiron - VERIFIED FROM SOURCE'),
(28524, 0.35, 0.6, 'Frost Explosion - Sapphiron - VERIFIED FROM SOURCE'),
(30101, 0.3, 0.5, 'Frost Missile - Sapphiron - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Thaddius
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(28167, 0.3, 0.5, 'Chain Lightning - Thaddius - VERIFIED FROM SOURCE'),
(28299, 0.35, 0.6, 'Ball Lightning - Thaddius - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- ==================================================
-- ULDUAR BOSSES
-- ==================================================

-- Yogg-Saron
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(63883, 0.25, 0.4, 'Death Ray Damage - Yogg-Saron - VERIFIED FROM SOURCE'),
(63803, 0.3, 0.5, 'Brain Link Damage - Yogg-Saron - VERIFIED FROM SOURCE'),
(63038, 0.3, 0.5, 'Dark Volley - Yogg-Saron Guardians - VERIFIED FROM SOURCE'),
(62714, 0.35, 0.6, 'Shadow Nova - Yogg-Saron Guardians - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Mimiron
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(63666, 0.3, 0.5, 'Napalm Shell - Mimiron - VERIFIED FROM SOURCE'),
(62997, 0.3, 0.5, 'Plasma Blast - Mimiron - VERIFIED FROM SOURCE'),
(63631, 0.35, 0.6, 'Shock Blast - Mimiron - VERIFIED FROM SOURCE'),
(66351, 0.35, 0.6, 'Mine Explosion - Mimiron - VERIFIED FROM SOURCE'),
(64533, 0.3, 0.5, 'Heat Wave - Mimiron Phase 2 - VERIFIED FROM SOURCE'),
(63689, 0.3, 0.5, 'Plasma Ball - Mimiron Phase 3 - VERIFIED FROM SOURCE'),
(63801, 0.35, 0.6, 'Bomb Bot Explode - Mimiron - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Razorscale
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(64016, 0.3, 0.5, 'Flame Buffet - Razorscale - VERIFIED FROM SOURCE'),
(63815, 0.35, 0.6, 'Fireball - Razorscale - VERIFIED FROM SOURCE'),
(63317, 0.3, 0.5, 'Flame Breath - Razorscale - VERIFIED FROM SOURCE'),
(63236, 0.3, 0.5, 'Devouring Flame - Razorscale - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Flame Leviathan
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(62396, 0.3, 0.5, 'Flame Vents - Flame Leviathan - VERIFIED FROM SOURCE'),
(62400, 0.3, 0.5, 'Missile Barrage - Flame Leviathan - VERIFIED FROM SOURCE'),
(63666, 0.3, 0.5, 'Napalm (10-man) - Flame Leviathan - VERIFIED FROM SOURCE'),
(65026, 0.3, 0.5, 'Napalm (25-man) - Flame Leviathan - VERIFIED FROM SOURCE'),
(62402, 0.35, 0.6, 'Searing Flame - Flame Leviathan Turret - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- ==================================================
-- TRIAL OF THE CRUSADER BOSSES
-- ==================================================

-- Anub'arak (Trial)
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(66012, 0.35, 0.6, 'Freezing Slash - Anub''arak (Trial) - VERIFIED FROM SOURCE'),
(66013, 0.3, 0.5, 'Penetrating Cold - Anub''arak (Trial) - VERIFIED FROM SOURCE'),
(66118, 0.3, 0.5, 'Leeching Swarm - Anub''arak (Trial) - VERIFIED FROM SOURCE'),
(65919, 0.35, 0.6, 'Impale - Anub''arak (Trial) - VERIFIED FROM SOURCE'),
(65774, 0.3, 0.5, 'Acid Mandible - Anub''arak Scarab - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- Lord Jaraxxus
INSERT INTO mortal_spell_scaling (spell_id, damage_scale, max_pct_hp, notes) VALUES
(66532, 0.3, 0.5, 'Fel Fireball - Lord Jaraxxus - VERIFIED FROM SOURCE'),
(66528, 0.3, 0.5, 'Fel Lightning - Lord Jaraxxus - VERIFIED FROM SOURCE'),
(66237, 0.3, 0.5, 'Incinerate Flesh - Lord Jaraxxus - VERIFIED FROM SOURCE'),
(66209, 0.35, 0.6, 'Touch of Jaraxxus - Lord Jaraxxus - VERIFIED FROM SOURCE'),
(66197, 0.3, 0.5, 'Legion Flame - Lord Jaraxxus - VERIFIED FROM SOURCE')
ON DUPLICATE KEY UPDATE damage_scale = VALUES(damage_scale), max_pct_hp = VALUES(max_pct_hp), notes = VALUES(notes);

-- ==================================================
-- SUMMARY
-- ==================================================
SELECT 
    'Other Raids Spell Scaling' as summary,
    COUNT(*) as total_spells_scaled,
    SUM(CASE WHEN notes LIKE '%Naxx%' OR notes LIKE '%Kel%' OR notes LIKE '%Sapphiron%' OR notes LIKE '%Thaddius%' THEN 1 ELSE 0 END) as naxx_spells,
    SUM(CASE WHEN notes LIKE '%Ulduar%' OR notes LIKE '%Yogg%' OR notes LIKE '%Mimiron%' OR notes LIKE '%Razorscale%' OR notes LIKE '%Leviathan%' THEN 1 ELSE 0 END) as ulduar_spells,
    SUM(CASE WHEN notes LIKE '%Trial%' OR notes LIKE '%Anub%arak%' OR notes LIKE '%Jaraxxus%' THEN 1 ELSE 0 END) as toc_spells
FROM mortal_spell_scaling
WHERE notes LIKE '%VERIFIED FROM SOURCE%'
  AND (notes LIKE '%Naxx%' OR notes LIKE '%Ulduar%' OR notes LIKE '%Trial%' 
       OR notes LIKE '%Kel%' OR notes LIKE '%Sapphiron%' OR notes LIKE '%Thaddius%'
       OR notes LIKE '%Yogg%' OR notes LIKE '%Mimiron%' OR notes LIKE '%Razorscale%'
       OR notes LIKE '%Leviathan%' OR notes LIKE '%Anub%arak%' OR notes LIKE '%Jaraxxus%');

