-- ==================================================
-- Project Mortal Warcraft
-- Feature: World Boss Tier Mappings
-- Description: Maps world bosses to Mortal creature tiers
-- Based on: docs/specs/32-npc-and-encounter-rebalance.md
-- Data Source: Lua scripts and Wowhead WotLK database
-- ==================================================

-- World Boss Tier Mappings
-- Maps world bosses to appropriate WORLD tiers based on difficulty

-- High-Tier World Bosses (WORLD_3 - M-T4 loot)
-- These are the most dangerous world bosses
INSERT INTO `mortal_creature_tier_map` (`creature_entry`, `mortal_tier_id`, `notes`)
SELECT 
    ct.entry,
    (SELECT id FROM `mortal_creature_tiers` WHERE code = 'WORLD_3'),
    CONCAT(ct.name, ' - High-tier world boss')
FROM `creature_template` ct
WHERE ct.entry IN (
    18728,  -- Doom Lord Kazzak (Outland)
    17711,  -- Doomwalker (Outland)
    12397   -- Doom Lord Kazzak (Classic - if exists)
)
AND EXISTS (SELECT 1 FROM `mortal_creature_tiers` WHERE code = 'WORLD_3')
ON DUPLICATE KEY UPDATE 
    `mortal_tier_id` = VALUES(`mortal_tier_id`),
    `notes` = VALUES(`notes`);

-- Mid-Tier World Bosses (WORLD_2 - M-T4 loot)
-- Classic world bosses (Emerald Dragons)
INSERT INTO `mortal_creature_tier_map` (`creature_entry`, `mortal_tier_id`, `notes`)
SELECT 
    ct.entry,
    (SELECT id FROM `mortal_creature_tiers` WHERE code = 'WORLD_2'),
    CONCAT(ct.name, ' - Mid-tier world boss (Emerald Dragon)')
FROM `creature_template` ct
WHERE ct.entry IN (
    14889,  -- Emeriss
    14888,  -- Lethon
    14890,  -- Taerar
    14887   -- Ysondre
)
AND EXISTS (SELECT 1 FROM `mortal_creature_tiers` WHERE code = 'WORLD_2')
ON DUPLICATE KEY UPDATE 
    `mortal_tier_id` = VALUES(`mortal_tier_id`),
    `notes` = VALUES(`notes`);

-- Low-Tier World Bosses (WORLD_1 - M-T3 loot)
-- Easier world bosses
INSERT INTO `mortal_creature_tier_map` (`creature_entry`, `mortal_tier_id`, `notes`)
SELECT 
    ct.entry,
    (SELECT id FROM `mortal_creature_tiers` WHERE code = 'WORLD_1'),
    CONCAT(ct.name, ' - Low-tier world boss')
FROM `creature_template` ct
WHERE ct.entry IN (
    6109    -- Azuregos (Classic)
)
AND EXISTS (SELECT 1 FROM `mortal_creature_tiers` WHERE code = 'WORLD_1')
ON DUPLICATE KEY UPDATE 
    `mortal_tier_id` = VALUES(`mortal_tier_id`),
    `notes` = VALUES(`notes`);

-- Summary
SELECT 
    'World Boss Tier Mappings' as summary,
    t.code as tier_code,
    t.description as tier_description,
    COUNT(m.creature_entry) as bosses_mapped
FROM `mortal_creature_tiers` t
LEFT JOIN `mortal_creature_tier_map` m ON t.id = m.mortal_tier_id
LEFT JOIN `creature_template` ct ON m.creature_entry = ct.entry
WHERE t.code LIKE 'WORLD_%'
GROUP BY t.id, t.code, t.description
ORDER BY t.code;

-- List all mapped world bosses
SELECT 
    ct.entry,
    ct.name,
    t.code as tier_code,
    t.description as tier_description,
    m.notes
FROM `mortal_creature_tier_map` m
INNER JOIN `creature_template` ct ON m.creature_entry = ct.entry
INNER JOIN `mortal_creature_tiers` t ON m.mortal_tier_id = t.id
WHERE t.code LIKE 'WORLD_%'
ORDER BY t.code, ct.name;

