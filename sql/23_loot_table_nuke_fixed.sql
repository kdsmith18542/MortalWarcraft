-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Loot Table Reset (The Surgical Purge) - FIXED FOR ACORE SCHEMA
-- Description: Removes ONLY Weapons and Armor. Preserves Quest Items & Mats.
-- ==================================================

-- WARNING: This script permanently removes weapons and armor from creature loot tables.
-- Make sure you have a database backup before running this!

SET @deleted_creature_loot = 0;
SET @deleted_gameobject_loot = 0;
SET @deleted_emblems = 0;

-- Start transaction for safety
START TRANSACTION;

-- 1. DELETE WEAPONS (Class 2) AND ARMOR (Class 4) from creature_loot_template
-- This ensures mobs stop dropping "Welfare Gear" but keeps Quest Items (Class 12).
DELETE cl
FROM `creature_loot_template` cl
JOIN `item_template` it ON cl.Item = it.entry
WHERE it.class IN (2, 4)
AND cl.Reference = 0; -- Only delete direct item drops, not references

SET @deleted_creature_loot = ROW_COUNT();

-- 2. PURGE BADGES & EMBLEMS
-- Remove Emblem of Frost/Triumph etc. (Welfare Currency)
DELETE FROM `creature_loot_template` 
WHERE `Item` IN (
    40752, -- Emblem of Heroism
    40753, -- Emblem of Valor
    47241, -- Emblem of Triumph
    49426, -- Emblem of Frost
    45624, -- Emblem of Conquest
    40754  -- Emblem of Conquest (alternative)
)
AND `Reference` = 0;

SET @deleted_emblems = ROW_COUNT();

-- 3. Remove from gameobject_loot_template (chests, etc.)
-- Note: This table may not exist in all ACore installations
-- DELETE gl
-- FROM `gameobject_loot_template` gl
-- JOIN `item_template` it ON gl.Item = it.entry
-- WHERE it.class IN (2, 4)
-- AND gl.Reference = 0;

SET @deleted_gameobject_loot = 0;

-- Commit transaction
COMMIT;

-- Report results
SELECT 
    CONCAT('Surgical Purge Complete:') AS summary,
    CONCAT('  - Removed ', @deleted_creature_loot, ' weapon/armor entries from creature_loot_template') AS creature_loot,
    CONCAT('  - Removed ', @deleted_gameobject_loot, ' weapon/armor entries from gameobject_loot_template') AS gameobject_loot,
    CONCAT('  - Removed ', @deleted_emblems, ' emblem/badge entries') AS emblems;

-- ==================================================
-- VERIFICATION QUERIES
-- ==================================================
-- Check remaining weapons/armor in creature_loot_template (should be much lower)
SELECT CONCAT('Remaining gear drops: ', COUNT(*)) AS result
FROM `creature_loot_template` cl
JOIN `item_template` it ON cl.Item = it.entry
WHERE it.class IN (2, 4)
AND cl.Reference = 0;

