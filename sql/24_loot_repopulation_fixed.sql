-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Loot Repopulation (The Material Economy) - FIXED FOR ACORE SCHEMA
-- Description: Assigns "Scrap" and "Material" drops to all mobs by Type/Level.
-- ==================================================

-- WARNING: This script should be run AFTER loot_table_nuke.sql
-- It repopulates loot tables with materials and salvage instead of finished gear.

-- Note: AzerothCore uses a different schema - references are stored in the Reference column
-- and items are stored in the Item column. We'll use direct item inserts rather than
-- reference loot groups for simplicity.

-- ------------------------------------------------------------------
-- 1. ASSIGN MATERIAL DROPS TO MOBS (Direct Item Inserts)
-- ------------------------------------------------------------------

-- Remove any existing custom material drops to avoid duplicates (optional - comment out if you want to keep existing)
-- DELETE FROM `creature_loot_template` 
-- WHERE `Item` IN (2589, 2592, 4306, 4338, 769, 2318, 2319, 4234, 4304, 2840, 3576, 3575, 3859)
-- AND `Reference` = 0
-- AND `Entry` IN (SELECT `entry` FROM `creature_template` WHERE `type` IN (1, 6, 7));

-- Tier 1 Humanoid Scrap (Level 1-20) - Linen Cloth
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 2589, 0, 40.0, 0, 1, 0, 1, 3, 'Linen Cloth (Tier 1 Material)'
FROM `creature_template` 
WHERE `type` = 7 -- Humanoid
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 2589 AND `Reference` = 0
)
LIMIT 1000; -- Limit to prevent too many inserts at once

-- Tier 1 Humanoid Scrap - Copper Bar (Rare)
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 2840, 0, 5.0, 0, 1, 0, 1, 1, 'Copper Bar (Tier 1 Rare)'
FROM `creature_template` 
WHERE `type` = 7
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 2840 AND `Reference` = 0
)
LIMIT 1000;

-- Tier 2 Humanoid Scrap (Level 21-40) - Wool Cloth
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 2592, 0, 40.0, 0, 1, 0, 1, 3, 'Wool Cloth (Tier 2 Material)'
FROM `creature_template` 
WHERE `type` = 7
AND `minlevel` BETWEEN 21 AND 40
AND `maxlevel` BETWEEN 21 AND 40
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 2592 AND `Reference` = 0
)
LIMIT 1000;

-- Tier 2 Humanoid Scrap - Tin Bar (Rare)
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 3576, 0, 5.0, 0, 1, 0, 1, 1, 'Tin Bar (Tier 2 Rare)'
FROM `creature_template` 
WHERE `type` = 7
AND `minlevel` BETWEEN 21 AND 40
AND `maxlevel` BETWEEN 21 AND 40
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 3576 AND `Reference` = 0
)
LIMIT 1000;

-- Tier 1 Beast Harvest (Level 1-20) - Light Leather
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 2318, 0, 30.0, 0, 1, 0, 1, 3, 'Light Leather (Tier 1 Beast)'
FROM `creature_template` 
WHERE `type` = 1 -- Beast
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 2318 AND `Reference` = 0
)
LIMIT 1000;

-- Tier 1 Beast Harvest - Meat
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 769, 0, 25.0, 0, 1, 0, 1, 2, 'Chunk of Boar Meat (Tier 1 Beast)'
FROM `creature_template` 
WHERE `type` = 1
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 769 AND `Reference` = 0
)
LIMIT 1000;

-- Tier 2 Beast Harvest (Level 21-40) - Medium Leather
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT `entry`, 2319, 0, 30.0, 0, 1, 0, 1, 3, 'Medium Leather (Tier 2 Beast)'
FROM `creature_template` 
WHERE `type` = 1
AND `minlevel` BETWEEN 21 AND 40
AND `maxlevel` BETWEEN 21 AND 40
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Item` = 2319 AND `Reference` = 0
)
LIMIT 1000;

-- ------------------------------------------------------------------
-- VERIFICATION QUERIES
-- ------------------------------------------------------------------

-- Check how many creatures got assigned material drops
SELECT 
    CONCAT('Creatures with material drops: ', COUNT(DISTINCT `Entry`)) AS result
FROM `creature_loot_template`
WHERE `Item` IN (2589, 2592, 2318, 2319, 769, 2840, 3576)
AND `Reference` = 0;

-- Sample creatures and their assigned loot
-- SELECT ct.entry, ct.name, ct.type, ct.minlevel, cl.Item, cl.Chance
-- FROM `creature_template` ct
-- JOIN `creature_loot_template` cl ON ct.entry = cl.Entry
-- WHERE cl.Item IN (2589, 2592, 2318, 2319)
-- AND cl.Reference = 0
-- LIMIT 20;

SELECT CONCAT('Loot Repopulation Complete: Material drops assigned to creatures.') AS result;

