-- ==================================================
-- Project Mortal Warcraft: Material Properties System
-- Module: mod-mortal-core
-- Feature: Advanced procedural crafting with material properties
-- ==================================================

-- Material Properties Table
-- Defines properties for crafting materials
CREATE TABLE IF NOT EXISTS `material_properties` (
  `material_entry` INT UNSIGNED NOT NULL COMMENT 'Item entry of the material',
  `material_name` VARCHAR(64) NOT NULL,
  `property_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Sharp, 2=Heavy, 3=Light, 4=Magical, 5=Resilient, etc.',
  `property_value` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Property strength (0.0-1.0)',
  `stat_modifier_strength` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Strength stat modifier',
  `stat_modifier_agility` FLOAT NOT NULL DEFAULT 0.0,
  `stat_modifier_stamina` FLOAT NOT NULL DEFAULT 0.0,
  `stat_modifier_intellect` FLOAT NOT NULL DEFAULT 0.0,
  `durability_bonus` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Durability modifier',
  `quality_tier` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Material quality tier (1-5)',
  PRIMARY KEY (`material_entry`, `property_type`),
  INDEX `idx_property_type` (`property_type`),
  INDEX `idx_quality` (`quality_tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Material properties for procedural crafting';

-- Recipe Combinations Table
-- Tracks discovered recipe combinations
CREATE TABLE IF NOT EXISTS `crafting_recipe_combinations` (
  `recipe_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `base_item_entry` INT UNSIGNED NOT NULL COMMENT 'Base item (e.g., Iron Sword)',
  `reagent_entry` INT UNSIGNED NOT NULL COMMENT 'Reagent (e.g., Wolf Tooth)',
  `result_item_entry` INT UNSIGNED NOT NULL COMMENT 'Result item (e.g., Serrated Iron Sword)',
  `discovered_by` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Character who discovered it',
  `discovered_at` TIMESTAMP NULL DEFAULT NULL,
  `is_public` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Private, 1=Public knowledge',
  `crafting_skill_required` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Required skill level',
  PRIMARY KEY (`recipe_id`),
  UNIQUE KEY `idx_combination` (`base_item_entry`, `reagent_entry`),
  INDEX `idx_discovered_by` (`discovered_by`),
  INDEX `idx_public` (`is_public`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Discovered crafting recipe combinations';

-- Item Quality Calculation Table
-- Stores calculated quality for crafted items
CREATE TABLE IF NOT EXISTS `crafted_item_quality` (
  `item_guid` INT UNSIGNED NOT NULL COMMENT 'Item instance GUID',
  `base_quality` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Base quality (1-5)',
  `material_quality_bonus` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Bonus from material quality',
  `crafter_skill_bonus` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Bonus from crafter skill',
  `final_quality` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Final calculated quality',
  `stat_bonuses` TEXT NULL DEFAULT NULL COMMENT 'JSON: Stat bonuses from materials',
  `crafted_by` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Character who crafted it',
  `crafted_at` TIMESTAMP NOT NULL DEFAULT 0,
  PRIMARY KEY (`item_guid`),
  INDEX `idx_quality` (`final_quality`),
  INDEX `idx_crafter` (`crafted_by`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Quality tracking for crafted items';

-- Example Material Properties (Insert statements)
-- Iron Ore
INSERT INTO `material_properties` (`material_entry`, `material_name`, `property_type`, `property_value`, `stat_modifier_strength`, `quality_tier`) VALUES
(2772, 'Iron Ore', 2, 0.5, 0.1, 1) -- Heavy property, +10% strength, Tier 1
ON DUPLICATE KEY UPDATE `material_name`=VALUES(`material_name`);

-- Wolf Tooth (Sharp property)
INSERT INTO `material_properties` (`material_entry`, `material_name`, `property_type`, `property_value`, `stat_modifier_agility`, `quality_tier`) VALUES
(2672, 'Wolf Tooth', 1, 0.3, 0.05, 1) -- Sharp property, +5% agility, Tier 1
ON DUPLICATE KEY UPDATE `material_name`=VALUES(`material_name`);

-- Thorium Ore (High quality)
INSERT INTO `material_properties` (`material_entry`, `material_name`, `property_type`, `property_value`, `stat_modifier_strength`, `durability_bonus`, `quality_tier`) VALUES
(10620, 'Thorium Ore', 2, 0.8, 0.2, 0.15, 4) -- Heavy property, +20% strength, +15% durability, Tier 4
ON DUPLICATE KEY UPDATE `material_name`=VALUES(`material_name`);

