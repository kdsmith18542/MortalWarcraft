-- ==================================================
-- Project Mortal Warcraft
-- Feature: Deep Crafting Material Data
-- Description: Definitions for the 6-Tier Material System.
-- ==================================================

CREATE TABLE IF NOT EXISTS `crafting_materials` (
  `material_id` INT UNSIGNED NOT NULL, -- Item ID of the Bar/Leather
  `name` VARCHAR(100),
  `tier` TINYINT UNSIGNED NOT NULL COMMENT '0-6',
  
  -- Physics Properties
  `density` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Increases Weight/Damage',
  `hardness` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Increases Durability/Defense',
  `conductivity` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Magical Affinity (for Staves)',
  
  -- Requirements
  `lore_skill_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Skill needed to work this mat',
  `min_heat` SMALLINT UNSIGNED DEFAULT 0 COMMENT 'Furnace Tier required',
  
  PRIMARY KEY (`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initial Data Population
INSERT INTO `crafting_materials` (`material_id`, `name`, `tier`, `density`, `hardness`, `conductivity`, `lore_skill_id`, `min_heat`) VALUES
(2840, 'Copper Bar', 1, 1.0, 0.8, 0.0, 4001, 1),
(3576, 'Tin Bar', 1, 0.8, 0.7, 0.0, 4001, 1),
(3575, 'Iron Bar', 2, 1.5, 1.2, 0.0, 4001, 2),
(3859, 'Steel Bar', 3, 1.8, 1.8, 0.0, 4001, 3),
(12359, 'Thorium Bar', 5, 2.5, 2.2, 0.0, 4002, 5),
(12360, 'Arcanite Bar', 6, 1.2, 3.0, 0.5, 4003, 6) -- Arcanite is light but hard (Magical)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `tier` = VALUES(`tier`),
  `density` = VALUES(`density`),
  `hardness` = VALUES(`hardness`),
  `conductivity` = VALUES(`conductivity`),
  `lore_skill_id` = VALUES(`lore_skill_id`),
  `min_heat` = VALUES(`min_heat`);

-- Add more materials as needed
-- Leather materials (example entries - adjust item IDs as needed)
INSERT INTO `crafting_materials` (`material_id`, `name`, `tier`, `density`, `hardness`, `conductivity`, `lore_skill_id`, `min_heat`) VALUES
(2318, 'Light Leather', 1, 0.5, 0.6, 0.0, 4004, 0),
(2319, 'Medium Leather', 2, 0.7, 0.8, 0.0, 4004, 0),
(4234, 'Heavy Leather', 3, 0.9, 1.0, 0.0, 4004, 0),
(4304, 'Thick Leather', 4, 1.1, 1.2, 0.0, 4005, 0),
(8170, 'Rugged Leather', 5, 1.3, 1.5, 0.0, 4005, 0)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `tier` = VALUES(`tier`),
  `density` = VALUES(`density`),
  `hardness` = VALUES(`hardness`),
  `conductivity` = VALUES(`conductivity`),
  `lore_skill_id` = VALUES(`lore_skill_id`),
  `min_heat` = VALUES(`min_heat`);

-- Mithril (Tier 4) - missing from initial data
INSERT INTO `crafting_materials` (`material_id`, `name`, `tier`, `density`, `hardness`, `conductivity`, `lore_skill_id`, `min_heat`) VALUES
(3860, 'Mithril Bar', 4, 2.0, 2.0, 0.0, 4002, 4)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `tier` = VALUES(`tier`),
  `density` = VALUES(`density`),
  `hardness` = VALUES(`hardness`),
  `conductivity` = VALUES(`conductivity`),
  `lore_skill_id` = VALUES(`lore_skill_id`),
  `min_heat` = VALUES(`min_heat`);

SELECT CONCAT('Created crafting_materials table and populated with ', COUNT(*), ' materials.') AS result
FROM `crafting_materials`;

