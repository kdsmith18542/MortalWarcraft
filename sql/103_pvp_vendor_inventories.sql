-- ==================================================
-- Project Mortal Warcraft
-- Feature: PvP Vendor Inventories
-- Description: Assigns PvP items to vendor NPCs via npc_vendor table
-- Based on: docs/specs/35-mortal-pvp-vendors-and-rewards.md
-- ==================================================

-- ==================================================
-- ENTRY COMBATANT VENDORS (P1 gear)
-- NPCs: 90001 (Alliance), 90011 (Horde)
-- Items: P1 tier (rating_band_code = 'P1')
-- ==================================================
INSERT INTO `npc_vendor` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT 
    90001 as entry,  -- Alliance Entry Combatant
    req.item_entry as item,
    0 as maxcount,  -- Unlimited
    0 as incrtime,
    0 as ExtendedCost,
    0 as VerifiedBuild
FROM `mortal_pvp_item_requirements` req
WHERE req.rating_band_code = 'P1'
  AND NOT EXISTS (
    SELECT 1 FROM `npc_vendor` nv 
    WHERE nv.entry = 90001 AND nv.item = req.item_entry
  )
LIMIT 500  -- Limit to avoid too many items per vendor
ON DUPLICATE KEY UPDATE `item` = VALUES(`item`);

-- Horde Entry Combatant
INSERT INTO `npc_vendor` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT 
    90011 as entry,  -- Horde Entry Combatant
    req.item_entry as item,
    0 as maxcount,
    0 as incrtime,
    0 as ExtendedCost,
    0 as VerifiedBuild
FROM `mortal_pvp_item_requirements` req
WHERE req.rating_band_code = 'P1'
  AND NOT EXISTS (
    SELECT 1 FROM `npc_vendor` nv 
    WHERE nv.entry = 90011 AND nv.item = req.item_entry
  )
LIMIT 500
ON DUPLICATE KEY UPDATE `item` = VALUES(`item`);

-- ==================================================
-- CHALLENGER VENDORS (P2-P4 gear)
-- NPCs: 90002 (Alliance), 90012 (Horde)
-- Items: P2, P3, P4 tiers
-- ==================================================
INSERT INTO `npc_vendor` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT 
    90002 as entry,  -- Alliance Challenger
    req.item_entry as item,
    0 as maxcount,
    0 as incrtime,
    0 as ExtendedCost,
    0 as VerifiedBuild
FROM `mortal_pvp_item_requirements` req
WHERE req.rating_band_code IN ('P2', 'P3', 'P4')
  AND NOT EXISTS (
    SELECT 1 FROM `npc_vendor` nv 
    WHERE nv.entry = 90002 AND nv.item = req.item_entry
  )
LIMIT 500
ON DUPLICATE KEY UPDATE `item` = VALUES(`item`);

-- Horde Challenger
INSERT INTO `npc_vendor` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT 
    90012 as entry,  -- Horde Challenger
    req.item_entry as item,
    0 as maxcount,
    0 as incrtime,
    0 as ExtendedCost,
    0 as VerifiedBuild
FROM `mortal_pvp_item_requirements` req
WHERE req.rating_band_code IN ('P2', 'P3', 'P4')
  AND NOT EXISTS (
    SELECT 1 FROM `npc_vendor` nv 
    WHERE nv.entry = 90012 AND nv.item = req.item_entry
  )
LIMIT 500
ON DUPLICATE KEY UPDATE `item` = VALUES(`item`);

-- ==================================================
-- ELITE VENDORS (P5 gear)
-- NPCs: 90003 (Alliance), 90013 (Horde)
-- Items: P5 tier (P6 can be added later)
-- ==================================================
INSERT INTO `npc_vendor` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT 
    90003 as entry,  -- Alliance Elite
    req.item_entry as item,
    0 as maxcount,
    0 as incrtime,
    0 as ExtendedCost,
    0 as VerifiedBuild
FROM `mortal_pvp_item_requirements` req
WHERE req.rating_band_code = 'P5'
  AND NOT EXISTS (
    SELECT 1 FROM `npc_vendor` nv 
    WHERE nv.entry = 90003 AND nv.item = req.item_entry
  )
LIMIT 500
ON DUPLICATE KEY UPDATE `item` = VALUES(`item`);

-- Horde Elite
INSERT INTO `npc_vendor` (`entry`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `VerifiedBuild`)
SELECT 
    90013 as entry,  -- Horde Elite
    req.item_entry as item,
    0 as maxcount,
    0 as incrtime,
    0 as ExtendedCost,
    0 as VerifiedBuild
FROM `mortal_pvp_item_requirements` req
WHERE req.rating_band_code = 'P5'
  AND NOT EXISTS (
    SELECT 1 FROM `npc_vendor` nv 
    WHERE nv.entry = 90013 AND nv.item = req.item_entry
  )
LIMIT 500
ON DUPLICATE KEY UPDATE `item` = VALUES(`item`);

-- ==================================================
-- SUMMARY
-- ==================================================
SELECT 
    'PvP Vendor Inventories' as summary,
    nv.entry,
    ct.name as vendor_name,
    COUNT(DISTINCT nv.item) as items_assigned,
    GROUP_CONCAT(DISTINCT req.rating_band_code ORDER BY req.rating_band_code SEPARATOR ', ') as tier_bands
FROM `npc_vendor` nv
INNER JOIN `creature_template` ct ON nv.entry = ct.entry
LEFT JOIN `mortal_pvp_item_requirements` req ON nv.item = req.item_entry
WHERE nv.entry IN (90001, 90002, 90003, 90004, 90011, 90012, 90013, 90014)
GROUP BY nv.entry, ct.name
ORDER BY nv.entry;

