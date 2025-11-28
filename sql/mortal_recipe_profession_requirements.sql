-- Mortal Warcraft Overhaul - Recipe Profession Requirements
-- Per spec 05-crafting.md section 5 (Multi-Profession Dependencies)

-- Table for storing which professions are required for each recipe
-- This enables items that require multiple professions (e.g., Blacksmithing + Leatherworking + Alchemy)

DROP TABLE IF EXISTS `mortal_recipe_profession_requirements`;
CREATE TABLE `mortal_recipe_profession_requirements` (
    `recipe_id` INT(10) UNSIGNED NOT NULL COMMENT 'Recipe ID from mortal_crafting_recipes or similar',
    `profession_skill_id` INT(10) UNSIGNED NOT NULL COMMENT 'Required Mortal crafting skill ID (2000+ range)',
    `required_skill_level` INT(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Minimum skill level required (default 1 for basic proficiency)',
    PRIMARY KEY (`recipe_id`, `profession_skill_id`),
    INDEX `idx_profession_skill` (`profession_skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Example data for multi-profession recipes
-- Based on spec 05-crafting.md section 5 examples

-- Sword Crafting Example: Requires Blacksmithing, Leatherworking, Alchemy
-- Recipe ID 1001: Steel Sword
INSERT INTO `mortal_recipe_profession_requirements` (`recipe_id`, `profession_skill_id`, `required_skill_level`) VALUES
(1001, 2005, 50),  -- Blacksmithing (2005) - minimum level 50
(1001, 2003, 25),  -- Leatherworking (2003) - minimum level 25
(1001, 2004, 25);  -- Alchemy (2004) - minimum level 25

-- Armor Crafting Example: Requires Blacksmithing, Tailoring
-- Recipe ID 1002: Plate Armor Set
INSERT INTO `mortal_recipe_profession_requirements` (`recipe_id`, `profession_skill_id`, `required_skill_level`) VALUES
(1002, 2005, 75),  -- Blacksmithing - minimum level 75
(1002, 2002, 50);  -- Tailoring - minimum level 50

-- Potion Crafting Example: Requires Alchemy, Herbalism
-- Recipe ID 1003: Advanced Healing Potion
INSERT INTO `mortal_recipe_profession_requirements` (`recipe_id`, `profession_skill_id`, `required_skill_level`) VALUES
(1003, 2004, 100), -- Alchemy - minimum level 100
(1004, 3001, 50);  -- Herbalism (gathering skill) - minimum level 50

-- Engineering Device Example: Requires Engineering, Blacksmithing, Jewelcrafting
-- Recipe ID 1004: Mechanical Golem
INSERT INTO `mortal_recipe_profession_requirements` (`recipe_id`, `profession_skill_id`, `required_skill_level`) VALUES
(1004, 2006, 150), -- Engineering - minimum level 150
(1004, 2005, 100), -- Blacksmithing - minimum level 100
(1004, 2007, 75);  -- Runecrafting (replaces Jewelcrafting) - minimum level 75

-- Single profession recipes (most recipes) don't need entries here
-- Only multi-profession recipes require entries in this table

-- Skill ID Reference (from spec 05-crafting.md section 10.2):
-- 2001: Weapon Crafting
-- 2002: Tailoring
-- 2003: Leatherworking
-- 2004: Alchemy
-- 2005: Blacksmithing
-- 2006: Engineering
-- 2007: Runecrafting (replaces Enchanting/Inscription/Jewelcrafting)
-- 2008: Cooking (lifeskill)
-- 2009: First Aid (lifeskill)
-- 3001: Gathering: Mining
-- 3002: Gathering: Herbalism
-- 3003: Gathering: Skinning
-- 3004: Gathering: Fishing