-- ==================================================
-- Project Mortal Warcraft
-- Feature: NPC Tier Mappings for Dungeons & Raids
-- Description: Populates mortal_creature_tier_map with creature entries from instances
-- Based on: docs/specs/32-npc-and-encounter-rebalance.md, 33-instance-and-battleground-tier-mapping.md
-- ==================================================

-- This script maps creatures to Mortal tiers based on:
-- 1. The instance they spawn in (from mortal_instance_tiers)
-- 2. Whether they are bosses (rank > 0) or trash (rank = 0)
-- 3. The tier codes defined in mortal_instance_tiers

-- Clear existing mappings (optional - comment out if you want to keep existing)
-- DELETE FROM mortal_creature_tier_map;

-- Helper: Get tier ID from tier code
SET @trash_t1_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'TRASH_T1' LIMIT 1);
SET @boss_t1_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'BOSS_T1' LIMIT 1);
SET @trash_t2_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'TRASH_T2' LIMIT 1);
SET @boss_t2_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'BOSS_T2' LIMIT 1);
SET @trash_t3_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'TRASH_T3' LIMIT 1);
SET @boss_t3_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'BOSS_T3' LIMIT 1);
SET @raid_icc_n_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'RAID_ICC_N' LIMIT 1);
SET @raid_icc_h_id = (SELECT id FROM mortal_creature_tiers WHERE code = 'RAID_ICC_H' LIMIT 1);

-- M-T1 Instances: Early Classic Dungeons
-- Map all creatures from M-T1 instances
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT c.id1, 
    CASE 
        WHEN ct.`rank` > 0 THEN @boss_t1_id
        ELSE @trash_t1_id
    END as tier_id,
    CONCAT('M-T1: ', it.instance_name, ' - ', IF(ct.`rank` > 0, 'Boss', 'Trash'))
FROM creature c
INNER JOIN creature_template ct ON c.id1 = ct.entry
INNER JOIN mortal_instance_tiers it ON c.map = it.map_id AND it.tier_code = 'M-T1' AND it.is_heroic = 0
WHERE c.map IN (389, 43, 36, 33, 48, 34, 47, 129, 70)  -- M-T1 instance maps
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = c.id1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- M-T2 Instances: Mid-Game Classic / TBC Dungeons
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT c.id1,
    CASE 
        WHEN ct.`rank` > 0 THEN @boss_t2_id
        ELSE @trash_t2_id
    END as tier_id,
    CONCAT('M-T2: ', it.instance_name, ' - ', IF(ct.`rank` > 0, 'Boss', 'Trash'))
FROM creature c
INNER JOIN creature_template ct ON c.id1 = ct.entry
INNER JOIN mortal_instance_tiers it ON c.map = it.map_id AND it.tier_code = 'M-T2' AND it.is_heroic = 0
WHERE c.map IN (209, 349, 109, 230, 229, 289, 329)  -- M-T2 instance maps
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = c.id1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- M-T3 Instances: Heroic Dungeons / WotLK 5-mans
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT c.id1,
    CASE 
        WHEN ct.`rank` > 0 THEN @boss_t3_id
        ELSE @trash_t3_id
    END as tier_id,
    CONCAT('M-T3: ', it.instance_name, ' - ', IF(ct.`rank` > 0, 'Boss', 'Trash'))
FROM creature c
INNER JOIN creature_template ct ON c.id1 = ct.entry
INNER JOIN mortal_instance_tiers it ON c.map = it.map_id AND it.tier_code = 'M-T3' AND it.is_heroic = 0
WHERE c.map IN (574, 575, 576, 578, 601, 602, 600, 608, 604, 599)  -- M-T3 instance maps
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = c.id1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- M-T4 Instances: ICC 5-mans and Early WotLK Raids
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT c.id1,
    CASE 
        WHEN ct.`rank` > 0 THEN @raid_icc_n_id
        ELSE @trash_t3_id
    END as tier_id,
    CONCAT('M-T4: ', it.instance_name, ' - ', IF(ct.`rank` > 0, 'Boss', 'Trash'))
FROM creature c
INNER JOIN creature_template ct ON c.id1 = ct.entry
INNER JOIN mortal_instance_tiers it ON c.map = it.map_id AND it.tier_code = 'M-T4' AND it.is_heroic = 0
WHERE c.map IN (632, 658, 668, 533, 616, 615, 603, 649)  -- M-T4 instance maps
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = c.id1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- M-T4/M-T5: ICC Normal and Heroic
-- ICC Normal (map 631, is_heroic = 0)
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT c.id1,
    CASE 
        WHEN ct.`rank` > 0 THEN @raid_icc_n_id
        ELSE @trash_t3_id
    END as tier_id,
    CONCAT('M-T4: ICC Normal - ', IF(ct.`rank` > 0, 'Boss', 'Trash'))
FROM creature c
INNER JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 631  -- Icecrown Citadel
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = c.id1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- ICC Heroic (map 631, is_heroic = 1) - Use difficulty_entry for heroic versions
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT ct.difficulty_entry_1, @raid_icc_h_id,
    CONCAT('M-T5: ICC Heroic - Boss')
FROM creature_template ct
INNER JOIN creature c ON ct.entry = c.id1
WHERE c.map = 631
  AND ct.difficulty_entry_1 > 0
  AND ct.`rank` > 0
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = ct.difficulty_entry_1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- Ulduar Hard Modes (map 603, is_heroic = 1)
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT ct.difficulty_entry_1, @raid_icc_h_id,
    CONCAT('M-T5: Ulduar Hard Mode - Boss')
FROM creature_template ct
INNER JOIN creature c ON ct.entry = c.id1
WHERE c.map = 603
  AND ct.difficulty_entry_1 > 0
  AND ct.`rank` > 0
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = ct.difficulty_entry_1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- Trial of the Crusader Heroic (map 649, is_heroic = 1)
INSERT INTO mortal_creature_tier_map (creature_entry, mortal_tier_id, notes)
SELECT DISTINCT ct.difficulty_entry_1, @raid_icc_h_id,
    CONCAT('M-T5: ToC Heroic - Boss')
FROM creature_template ct
INNER JOIN creature c ON ct.entry = c.id1
WHERE c.map = 649
  AND ct.difficulty_entry_1 > 0
  AND ct.`rank` > 0
  AND NOT EXISTS (SELECT 1 FROM mortal_creature_tier_map WHERE creature_entry = ct.difficulty_entry_1)
ON DUPLICATE KEY UPDATE notes = VALUES(notes);

-- Summary query to show what was mapped
SELECT 
    'M-T1 Trash' as tier_type,
    COUNT(*) as creature_count
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code = 'TRASH_T1'
UNION ALL
SELECT 
    'M-T1 Bosses',
    COUNT(*)
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code = 'BOSS_T1'
UNION ALL
SELECT 
    'M-T2 Trash',
    COUNT(*)
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code = 'TRASH_T2'
UNION ALL
SELECT 
    'M-T2 Bosses',
    COUNT(*)
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code = 'BOSS_T2'
UNION ALL
SELECT 
    'M-T3 Trash',
    COUNT(*)
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code = 'TRASH_T3'
UNION ALL
SELECT 
    'M-T3 Bosses',
    COUNT(*)
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code = 'BOSS_T3'
UNION ALL
SELECT 
    'M-T4/M-T5 Raid Bosses',
    COUNT(*)
FROM mortal_creature_tier_map m
INNER JOIN mortal_creature_tiers t ON m.mortal_tier_id = t.id
WHERE t.code IN ('RAID_ICC_N', 'RAID_ICC_H')
ORDER BY tier_type;

