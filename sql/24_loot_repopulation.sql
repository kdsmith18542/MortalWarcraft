-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Loot Repopulation (The Material Economy)
-- Description: Assigns "Scrap" and "Material" drops to all mobs by Type/Level.
-- ==================================================

-- WARNING: This script should be run AFTER loot_table_nuke.sql
-- It repopulates loot tables with materials and salvage instead of finished gear.

-- ------------------------------------------------------------------
-- 1. DEFINE REFERENCE LOOT GROUPS (The "Loot Bags")
-- ------------------------------------------------------------------
-- We use IDs 30000+ to avoid conflicts with Blizzard IDs.

-- Clean up any existing custom reference loot groups
DELETE FROM `reference_loot_template` WHERE `entry` BETWEEN 30001 AND 30100;

-- Ref 30001: Tier 1 Humanoid Scrap (Level 1-20)
-- Drops: Linen, Broken Weapons (Iron Scrap), Copper
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30001, 2589, 40, 0, 0, 1, 3),  -- Linen Cloth
(30001, 2840, 5, 0, 0, 1, 1),   -- Copper Bar (Rare raw mat)
(30001, 7073, 20, 0, 0, 1, 1),  -- Broken Fang (Generic Scrap)
(30001, 2092, 15, 0, 0, 1, 1);  -- Worn Dagger (Metal Scrap to salvage)

-- Ref 30002: Tier 2 Humanoid Scrap (Level 21-40)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30002, 2592, 40, 0, 0, 1, 3),  -- Wool Cloth
(30002, 3576, 5, 0, 0, 1, 1),   -- Tin Bar
(30002, 2886, 20, 0, 0, 1, 1),  -- Cruddy Mojo (Magic Scrap)
(30002, 2589, 20, 0, 0, 1, 2);  -- Linen Cloth (still drops)

-- Ref 30003: Tier 3 Humanoid Scrap (Level 41-60)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30003, 4306, 40, 0, 0, 1, 3),  -- Silk Cloth
(30003, 3575, 8, 0, 0, 1, 1),   -- Iron Bar
(30003, 2886, 15, 0, 0, 1, 1),  -- Cruddy Mojo
(30003, 2592, 20, 0, 0, 1, 2);  -- Wool Cloth

-- Ref 30004: Tier 4 Humanoid Scrap (Level 61-80)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30004, 4338, 40, 0, 0, 1, 3),  -- Mageweave Cloth
(30004, 3859, 8, 0, 0, 1, 1),   -- Steel Bar
(30004, 2886, 15, 0, 0, 1, 1),  -- Cruddy Mojo
(30004, 4306, 20, 0, 0, 1, 2);  -- Silk Cloth

-- Ref 30011: Tier 1 Beast Harvest (Level 1-20)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30011, 769, 30, 0, 0, 1, 2),   -- Chunk of Boar Meat
(30011, 2318, 25, 0, 0, 1, 3),  -- Light Leather (Representing "Raw Hide" drop)
(30011, 2672, 20, 0, 0, 1, 1);  -- Stringy Wolf Meat

-- Ref 30012: Tier 2 Beast Harvest (Level 21-40)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30012, 2673, 30, 0, 0, 1, 2),  -- Coyote Meat
(30012, 2319, 25, 0, 0, 1, 3),  -- Medium Leather
(30012, 769, 20, 0, 0, 1, 1);   -- Chunk of Boar Meat

-- Ref 30013: Tier 3 Beast Harvest (Level 41-60)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30013, 2674, 30, 0, 0, 1, 2),  -- Crawler Meat
(30013, 4234, 25, 0, 0, 1, 3),  -- Heavy Leather
(30013, 2319, 20, 0, 0, 1, 2);  -- Medium Leather

-- Ref 30014: Tier 4 Beast Harvest (Level 61-80)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30014, 2677, 30, 0, 0, 1, 2),  -- Boar Ribs
(30014, 4304, 25, 0, 0, 1, 3),  -- Thick Leather
(30014, 4234, 20, 0, 0, 1, 2);  -- Heavy Leather

-- Ref 30021: Tier 1 Undead Scrap (Level 1-20)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30021, 2589, 35, 0, 0, 1, 3),  -- Linen Cloth
(30021, 7073, 25, 0, 0, 1, 1),  -- Broken Fang
(30021, 2886, 20, 0, 0, 1, 1);  -- Cruddy Mojo

-- Ref 30022: Tier 2 Undead Scrap (Level 21-40)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30022, 2592, 35, 0, 0, 1, 3),  -- Wool Cloth
(30022, 2886, 25, 0, 0, 1, 1),  -- Cruddy Mojo
(30022, 2589, 20, 0, 0, 1, 2);  -- Linen Cloth

-- Ref 30031: Tier 1 Elemental Core (Level 1-20)
INSERT INTO `reference_loot_template` (`entry`, `item`, `Chance`, `groupid`, `Reference`, `MinCount`, `MaxCount`) VALUES
(30031, 7070, 40, 0, 0, 1, 1),  -- Elemental Earth
(30031, 7067, 30, 0, 0, 1, 1),  -- Elemental Earth (alternative)
(30031, 2886, 20, 0, 0, 1, 1);  -- Cruddy Mojo

-- ------------------------------------------------------------------
-- 2. ASSIGN REFERENCES TO MOBS (The Mass Update)
-- ------------------------------------------------------------------

-- Remove any existing custom reference loot entries to avoid duplicates
DELETE FROM `creature_loot_template` 
WHERE `Reference` < 0 
AND `Reference` BETWEEN -30100 AND -30001;

-- Assign Tier 1 Humanoid Scrap to all Humanoids (Type 7) Level 1-20
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30001, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 7 
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `Entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30001
);

-- Assign Tier 2 Humanoid Scrap to all Humanoids Level 21-40
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30002, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 7 
AND `minlevel` BETWEEN 21 AND 40
AND `maxlevel` BETWEEN 21 AND 40
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30002
);

-- Assign Tier 3 Humanoid Scrap to all Humanoids Level 41-60
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30003, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 7 
AND `minlevel` BETWEEN 41 AND 60
AND `maxlevel` BETWEEN 41 AND 60
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30003
);

-- Assign Tier 4 Humanoid Scrap to all Humanoids Level 61-80
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30004, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 7 
AND `minlevel` BETWEEN 61 AND 80
AND `maxlevel` BETWEEN 61 AND 80
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30004
);

-- Assign Tier 1 Beast Harvest to all Beasts (Type 1) Level 1-20
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30011, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 1 
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30011
);

-- Assign Tier 2 Beast Harvest to all Beasts Level 21-40
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30012, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 1 
AND `minlevel` BETWEEN 21 AND 40
AND `maxlevel` BETWEEN 21 AND 40
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30012
);

-- Assign Tier 3 Beast Harvest to all Beasts Level 41-60
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30013, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 1 
AND `minlevel` BETWEEN 41 AND 60
AND `maxlevel` BETWEEN 41 AND 60
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30013
);

-- Assign Tier 4 Beast Harvest to all Beasts Level 61-80
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30014, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 1 
AND `minlevel` BETWEEN 61 AND 80
AND `maxlevel` BETWEEN 61 AND 80
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30014
);

-- Assign Tier 1 Undead Scrap to all Undead (Type 6) Level 1-20
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30021, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 6 
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30021
);

-- Assign Tier 2 Undead Scrap to all Undead Level 21-40
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30022, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 6 
AND `minlevel` BETWEEN 21 AND 40
AND `maxlevel` BETWEEN 21 AND 40
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30022
);

-- Assign Tier 1 Elemental Core to all Elementals (Type 4) Level 1-20
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`)
SELECT `entry`, 0, -30031, 100, 0, 1, 0, 1, 1 
FROM `creature_template` 
WHERE `type` = 4 
AND `minlevel` BETWEEN 1 AND 20
AND `maxlevel` BETWEEN 1 AND 20
AND `entry` NOT IN (
    SELECT DISTINCT `entry` 
    FROM `creature_loot_template` 
    WHERE `Reference` = -30031
);

-- ------------------------------------------------------------------
-- 3. BOSS LOOT (Blueprints)
-- ------------------------------------------------------------------
-- Example: Hogger (Entry 448) drops a "Weapon Schematic"
-- Note: You need to create the Custom Item 90001 "Basic Weapon Schematic" first.

-- Uncomment and modify as needed for specific bosses:
--
-- INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`) 
-- VALUES (448, 90001, 50, 0, 1, 1)
-- ON DUPLICATE KEY UPDATE `ChanceOrQuestChance` = 50;

-- ------------------------------------------------------------------
-- VERIFICATION QUERIES
-- ------------------------------------------------------------------

-- Check how many creatures got assigned reference loot
SELECT 
    COUNT(DISTINCT `entry`) AS creatures_with_reference_loot,
    `Reference` AS reference_id
FROM `creature_loot_template`
WHERE `Reference` < 0 
AND `Reference` BETWEEN -30100 AND -30001
GROUP BY `Reference`
ORDER BY `Reference`;

-- Check sample creatures and their assigned loot
-- SELECT ct.entry, ct.name, ct.type, ct.minlevel, cl.Reference
-- FROM `creature_template` ct
-- JOIN `creature_loot_template` cl ON ct.entry = cl.entry
-- WHERE cl.Reference < 0 
-- AND cl.Reference BETWEEN -30100 AND -30001
-- LIMIT 20;

SELECT CONCAT('Loot Repopulation Complete: Reference loot groups created and assigned to creatures.') AS result;

