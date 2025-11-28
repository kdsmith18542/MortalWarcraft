-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Currency Overhaul (Emblem/Badge Removal)
-- Description: Removes Emblems and Badges from loot tables and vendors.
--              Converts Reputation Vendors to Recipe Vendors.
-- ==================================================

-- WARNING: This script permanently removes emblem/badge currency items.
-- Make sure you have a database backup before running this!

SET @deleted_emblem_loot = 0;
SET @deleted_emblem_vendors = 0;
SET @updated_rep_vendors = 0;

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. REMOVE EMBLEMS FROM LOOT TABLES
-- ------------------------------------------------------------------

-- Emblem Item IDs (WotLK)
-- 40752: Emblem of Heroism
-- 40753: Emblem of Valor
-- 47241: Emblem of Triumph
-- 49426: Emblem of Frost
-- 45624: Emblem of Conquest
-- 40754: Emblem of Conquest (alternative)

DELETE FROM `creature_loot_template` 
WHERE `item` IN (40752, 40753, 47241, 49426, 45624, 40754)
AND `Reference` = 0;

SET @deleted_emblem_loot = @deleted_emblem_loot + ROW_COUNT();

-- Check if reference_loot_template exists
SET @has_reference_loot = (
    SELECT COUNT(*) FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reference_loot_template'
);

-- Only delete from reference_loot_template if it exists
SET @sql_ref = IF(@has_reference_loot > 0,
    'DELETE FROM `reference_loot_template` WHERE `item` IN (40752, 40753, 47241, 49426, 45624, 40754) AND `Reference` = 0',
    'SELECT 0'
);
PREPARE stmt FROM @sql_ref;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @deleted_emblem_loot = @deleted_emblem_loot + ROW_COUNT();

-- Check if gameobject_loot_template exists
SET @has_gameobject_loot = (
    SELECT COUNT(*) FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'gameobject_loot_template'
);

SET @sql_go = IF(@has_gameobject_loot > 0,
    'DELETE FROM `gameobject_loot_template` WHERE `item` IN (40752, 40753, 47241, 49426, 45624, 40754) AND `Reference` = 0',
    'SELECT 0'
);
PREPARE stmt FROM @sql_go;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @deleted_emblem_loot = @deleted_emblem_loot + ROW_COUNT();

-- ------------------------------------------------------------------
-- 2. REMOVE EMBLEMS FROM VENDOR LISTS
-- ------------------------------------------------------------------

-- Check if npc_vendor table exists
SET @has_npc_vendor = (
    SELECT COUNT(*) FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'npc_vendor'
);

SET @sql_vendor = IF(@has_npc_vendor > 0,
    'DELETE FROM `npc_vendor` WHERE `item` IN (40752, 40753, 47241, 49426, 45624, 40754)',
    'SELECT 0'
);
PREPARE stmt FROM @sql_vendor;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @deleted_emblem_vendors = IF(@has_npc_vendor > 0, ROW_COUNT(), 0);

-- ------------------------------------------------------------------
-- 3. CONVERT REPUTATION VENDORS TO RECIPE VENDORS
-- ------------------------------------------------------------------

-- Update vendors that sell gear to only sell recipes/formulas
-- This targets vendors that have reputation requirements and sell finished gear

-- First, identify vendors selling finished gear (class 2 = weapons, class 4 = armor)
-- Then update them to only sell recipes (class 9 = recipes)

-- Note: This is a conservative approach - we're not deleting vendor entries,
-- but we're removing gear items and keeping only recipes/formulas

-- Remove gear items from reputation vendors (if npc_vendor exists)
SET @sql_rep = IF(@has_npc_vendor > 0,
    'DELETE nv FROM `npc_vendor` nv JOIN `item_template` it ON nv.item = it.entry WHERE it.class IN (2, 4) AND nv.ExtendedCost > 0',
    'SELECT 0'
);
PREPARE stmt FROM @sql_rep;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @updated_rep_vendors = IF(@has_npc_vendor > 0, ROW_COUNT(), 0);

-- Verification: Show remaining items sold by rep vendors (should only be recipes/consumables)
-- SELECT 
--     nv.entry,
--     ct.name AS vendor_name,
--     it.entry AS item_id,
--     it.name AS item_name,
--     it.class,
--     it.subclass
-- FROM npc_vendor nv
-- JOIN creature_template ct ON nv.entry = ct.entry
-- JOIN item_template it ON nv.item = it.entry
-- WHERE nv.ExtendedCost > 0
-- AND it.class NOT IN (9, 0, 1, 7, 8)  -- Exclude recipes, consumables, containers, reagents, trade goods
-- LIMIT 20;

COMMIT;

-- Report results
SELECT CONCAT(
    'Emblem Cleanup Complete:',
    '  - Removed ', @deleted_emblem_loot, ' emblem entries from loot tables',
    '  - Removed ', @deleted_emblem_vendors, ' emblem entries from vendor lists',
    '  - Removed ', @updated_rep_vendors, ' gear items from reputation vendors'
) AS summary;

-- Verification: Check if any emblems remain
SELECT CONCAT('Remaining emblem drops: ', COUNT(*)) AS result
FROM `creature_loot_template` cl
WHERE cl.item IN (40752, 40753, 47241, 49426, 45624, 40754);

