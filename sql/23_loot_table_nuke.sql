-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Loot Table Reset (The Surgical Purge)
-- Description: Removes ONLY Weapons and Armor. Preserves Quest Items & Mats.
-- ==================================================

-- WARNING: This script permanently removes weapons and armor from creature loot tables.
-- Make sure you have a database backup before running this!

SET @deleted_creature_loot = 0;
SET @deleted_reference_loot = 0;
SET @deleted_emblems = 0;

-- Start transaction for safety
START TRANSACTION;

-- 1. DELETE WEAPONS (Class 2) AND ARMOR (Class 4) from creature_loot_template
-- This ensures mobs stop dropping "Welfare Gear" but keeps Quest Items (Class 12).
DELETE cl
FROM `creature_loot_template` cl
JOIN `item_template` it ON cl.item = it.entry
WHERE it.class IN (2, 4);

SET @deleted_creature_loot = ROW_COUNT();

-- 2. DELETE REFERENCE LOOT (Groups)
-- Often contains "Green/Blue" random drop bags. 
-- We check the reference tables for gear groups.
DELETE rl
FROM `reference_loot_template` rl
JOIN `item_template` it ON rl.item = it.entry
WHERE it.class IN (2, 4);

SET @deleted_reference_loot = ROW_COUNT();

-- 3. PURGE BADGES & EMBLEMS
-- Remove Emblem of Frost/Triumph etc. (Welfare Currency)
DELETE FROM `creature_loot_template` 
WHERE `item` IN (
    40752, -- Emblem of Heroism
    40753, -- Emblem of Valor
    47241, -- Emblem of Triumph
    49426, -- Emblem of Frost
    45624, -- Emblem of Conquest
    40754  -- Emblem of Conquest (alternative)
);

SET @deleted_emblems = ROW_COUNT();

-- 4. Also remove from reference_loot_template
DELETE FROM `reference_loot_template`
WHERE `item` IN (
    40752, -- Emblem of Heroism
    40753, -- Emblem of Valor
    47241, -- Emblem of Triumph
    49426, -- Emblem of Frost
    45624, -- Emblem of Conquest
    40754  -- Emblem of Conquest (alternative)
);

-- 5. Remove from gameobject_loot_template (chests, etc.)
DELETE gl
FROM `gameobject_loot_template` gl
JOIN `item_template` it ON gl.item = it.entry
WHERE it.class IN (2, 4);

-- 6. Remove from fishing_loot_template
DELETE fl
FROM `fishing_loot_template` fl
JOIN `item_template` it ON fl.item = it.entry
WHERE it.class IN (2, 4);

-- 7. Remove from disenchant_loot_template
DELETE dl
FROM `disenchant_loot_template` dl
JOIN `item_template` it ON dl.item = it.entry
WHERE it.class IN (2, 4);

-- 8. Remove from prospecting_loot_template
DELETE pl
FROM `prospecting_loot_template` pl
JOIN `item_template` it ON pl.item = it.entry
WHERE it.class IN (2, 4);

-- 9. Remove from milling_loot_template
DELETE ml
FROM `milling_loot_template` ml
JOIN `item_template` it ON ml.item = it.entry
WHERE it.class IN (2, 4);

-- 10. Remove from pickpocketing_loot_template
DELETE pp
FROM `pickpocketing_loot_template` pp
JOIN `item_template` it ON pp.item = it.entry
WHERE it.class IN (2, 4);

-- 11. Remove from skinning_loot_template
DELETE sl
FROM `skinning_loot_template` sl
JOIN `item_template` it ON sl.item = it.entry
WHERE it.class IN (2, 4);

-- Commit transaction
COMMIT;

-- Report results
SELECT 
    CONCAT('Surgical Purge Complete:') AS summary,
    CONCAT('  - Removed ', @deleted_creature_loot, ' weapon/armor entries from creature_loot_template') AS creature_loot,
    CONCAT('  - Removed ', @deleted_reference_loot, ' weapon/armor entries from reference_loot_template') AS reference_loot,
    CONCAT('  - Removed ', @deleted_emblems, ' emblem/badge entries') AS emblems;

-- ==================================================
-- OPTIONAL: DEFINE NEW COMPONENT DROPS (The "Scrap" System)
-- ==================================================
-- Instead of replacing the whole table, we INSERT "Salvage" items 
-- into mobs that previously dropped gear.
--
-- Example: Give all Humanoids (Type 7) a chance to drop "Scrap Metal"
-- You would need a custom item 50001 "Scrap Metal" created first.
--
-- Uncomment and modify as needed:
--
-- INSERT INTO `creature_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `groupid`, `mincountOrRef`, `maxcount`, `lootcondition`, `condition_value1`, `condition_value2`)
-- SELECT 
--     `entry`, 
--     50001, -- Scrap Metal item ID
--     25.0,  -- 25% drop chance
--     0,     -- Group ID
--     1,     -- Min count
--     2,     -- Max count
--     0,     -- No condition
--     0,     -- Condition value 1
--     0      -- Condition value 2
-- FROM `creature_template` 
-- WHERE `type` = 7 -- Humanoid
-- AND `entry` NOT IN (
--     SELECT DISTINCT `entry` 
--     FROM `creature_loot_template` 
--     WHERE `item` = 50001
-- );

-- ==================================================
-- VERIFICATION QUERIES
-- ==================================================
-- Run these to verify the purge worked:

-- Check remaining weapons/armor in creature_loot_template (should be 0 or very few)
-- SELECT COUNT(*) AS remaining_gear_drops
-- FROM `creature_loot_template` cl
-- JOIN `item_template` it ON cl.item = it.entry
-- WHERE it.class IN (2, 4);

-- Check what items still drop (should be materials, quest items, etc.)
-- SELECT DISTINCT it.entry, it.name, it.class, it.subclass
-- FROM `creature_loot_template` cl
-- JOIN `item_template` it ON cl.item = it.entry
-- ORDER BY it.class, it.subclass
-- LIMIT 100;

