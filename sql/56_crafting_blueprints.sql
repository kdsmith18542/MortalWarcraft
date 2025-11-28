-- ==================================================
-- Project Mortal Warcraft
-- Feature: Crafting Blueprints & Components (Spec 17/19)
-- Creates mortal_* tables used by AIO crafting workstation.
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_material_properties` (
  `material_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `family` ENUM('metal','wood','leather','fabric','essence') NOT NULL DEFAULT 'metal',
  `tier` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `hardness` INT NOT NULL DEFAULT 0,
  `flexibility` INT NOT NULL DEFAULT 0,
  `weight` INT NOT NULL DEFAULT 0,
  `conductivity` INT NOT NULL DEFAULT 0,
  `purity` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`material_id`),
  UNIQUE KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Material physics data for crafting.';

CREATE TABLE IF NOT EXISTS `mortal_crafting_components` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `component_type` VARCHAR(32) NOT NULL COMMENT 'blade, hilt, plate, etc.',
  `material_id` INT UNSIGNED NOT NULL,
  `quality_tier` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `base_item_template` INT UNSIGNED NOT NULL COMMENT 'Item template for the component',
  `created_by` INT UNSIGNED DEFAULT NULL COMMENT 'Crafter guid',
  `created_at` INT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_material_type` (`material_id`,`component_type`),
  CONSTRAINT `fk_component_material` FOREIGN KEY (`material_id`) REFERENCES `mortal_material_properties`(`material_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Intermediate crafting parts.';

CREATE TABLE IF NOT EXISTS `mortal_blueprints` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `item_template` INT UNSIGNED DEFAULT NULL COMMENT 'Blueprint item entry',
  `is_original` TINYINT(1) NOT NULL DEFAULT 1,
  `max_uses` INT DEFAULT NULL,
  `craft_type` VARCHAR(32) NOT NULL DEFAULT 'forge',
  `output_item_template` INT UNSIGNED NOT NULL,
  `required_skill` INT DEFAULT NULL,
  `required_skill_level` INT DEFAULT NULL,
  `notes` TEXT,
  PRIMARY KEY (`id`),
  KEY `idx_craft_type` (`craft_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Crafting blueprint definitions.';

CREATE TABLE IF NOT EXISTS `mortal_blueprint_requirements` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `blueprint_id` INT UNSIGNED NOT NULL,
  `slot_label` VARCHAR(32) NOT NULL COMMENT 'Blade, Hilt, Flux',
  `item_entry` INT UNSIGNED NOT NULL,
  `display_name` VARCHAR(64) DEFAULT NULL,
  `required_count` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `slot_order` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_blueprint_slot` (`blueprint_id`,`slot_order`),
  CONSTRAINT `fk_requirements_blueprint` FOREIGN KEY (`blueprint_id`) REFERENCES `mortal_blueprints`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Per-blueprint component requirements.';

-- ------------------------------------------------------------------
-- Seed data for the forge crafting slice (Iron & Mithril Longswords)
-- ------------------------------------------------------------------

INSERT INTO `mortal_material_properties` (`name`, `family`, `tier`, `hardness`, `flexibility`, `weight`, `purity`)
VALUES
  ('Iron', 'metal', 2, 60, 20, 55, 40),
  ('Mithril', 'metal', 3, 80, 35, 40, 65),
  ('Leather', 'leather', 1, 15, 70, 15, 30)
ON DUPLICATE KEY UPDATE
  `family`=VALUES(`family`),
  `tier`=VALUES(`tier`),
  `hardness`=VALUES(`hardness`),
  `flexibility`=VALUES(`flexibility`),
  `weight`=VALUES(`weight`),
  `purity`=VALUES(`purity`);

-- Blueprints
INSERT INTO `mortal_blueprints` (`id`,`item_template`,`is_original`,`craft_type`,`output_item_template`,`notes`)
VALUES
  (1, NULL, 1, 'forge', 10001, 'Standard Iron Longsword'),
  (2, NULL, 1, 'forge', 10002, 'Refined Mithril Longsword'),
  (3, NULL, 1, 'forge', 10003, 'Iron Pickaxe for miners'),
  (4, NULL, 1, 'forge', 10004, 'Iron Battleaxe for frontline fighters')
ON DUPLICATE KEY UPDATE
  `output_item_template`=VALUES(`output_item_template`),
  `notes`=VALUES(`notes`);

-- Blueprint requirements (match entries used in Lua fallback)
DELETE FROM `mortal_blueprint_requirements` WHERE `blueprint_id` IN (1,2,3,4);
INSERT INTO `mortal_blueprint_requirements` (`blueprint_id`,`slot_label`,`item_entry`,`display_name`,`required_count`,`slot_order`)
VALUES
  (1, 'Blade', 5001, 'Iron Blade', 1, 1),
  (1, 'Hilt', 6001, 'Leather Hilt', 1, 2),
  (2, 'Blade', 5002, 'Mithril Blade', 1, 1),
  (2, 'Hilt', 6001, 'Leather Hilt', 1, 2),
  (3, 'Head', 5003, 'Iron Pick Head', 1, 1),
  (3, 'Haft', 6002, 'Oak Haft', 1, 2),
  (4, 'Head', 5004, 'Iron Axe Head', 1, 1),
  (4, 'Handle', 6003, 'Wrapped Handle', 1, 2);

-- Optional: component table pre-population (ties blueprint components to materials)
DELETE FROM `mortal_crafting_components` WHERE `base_item_template` IN (5001,5002,5003,5004,6001,6002,6003);
INSERT INTO `mortal_crafting_components` (`component_type`,`material_id`,`quality_tier`,`base_item_template`)
SELECT 'blade', m.material_id, m.tier, 5001 FROM `mortal_material_properties` m WHERE m.name='Iron'
UNION ALL
SELECT 'blade', m.material_id, m.tier, 5002 FROM `mortal_material_properties` m WHERE m.name='Mithril'
UNION ALL
SELECT 'head', m.material_id, m.tier, 5003 FROM `mortal_material_properties` m WHERE m.name='Iron'
UNION ALL
SELECT 'head', m.material_id, m.tier, 5004 FROM `mortal_material_properties` m WHERE m.name='Iron'
UNION ALL
SELECT 'hilt', m.material_id, m.tier, 6001 FROM `mortal_material_properties` m WHERE m.name='Leather'
UNION ALL
SELECT 'haft', m.material_id, m.tier, 6002 FROM `mortal_material_properties` m WHERE m.name='Leather'
UNION ALL
SELECT 'handle', m.material_id, m.tier, 6003 FROM `mortal_material_properties` m WHERE m.name='Leather';
