-- ==================================================
-- Project Mortal Warcraft
-- Feature: Dungeon Key Access System
-- Description: Database schema for dungeon keys (converted from instance keys)
-- Spec: 06-pve.md section 4.2.1
-- ==================================================

-- Dungeon Keys Definition Table
CREATE TABLE IF NOT EXISTS `mortal_dungeon_keys` (
    `item_entry` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Item entry ID for the key',
    `name` VARCHAR(100) NOT NULL COMMENT 'Key name',
    `dungeon_map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID of the dungeon this key is for',
    `dungeon_name` VARCHAR(100) NOT NULL COMMENT 'Dungeon name (e.g., Dire Maul, Blackrock Depths)',
    `gameobject_entry` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'GameObject entry that requires this key (0 = any door in dungeon)',
    `consumable` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Key is consumed on use (single-use)',
    `durability` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Max uses before key breaks (if not consumable)',
    `description` TEXT NULL COMMENT 'Key description',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_dungeon_map_id` (`dungeon_map_id`),
    INDEX `idx_gameobject_entry` (`gameobject_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Dungeon key definitions';

-- Key Requirements (which keys are needed for which gameobjects)
-- This allows multiple keys for the same door, or key combinations
CREATE TABLE IF NOT EXISTS `mortal_key_requirements` (
    `requirement_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `gameobject_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject that requires keys',
    `key_entry` INT UNSIGNED NOT NULL COMMENT 'Key item entry required',
    `required_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Number of keys required',
    `key_combination` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'If true, all keys in combination must be present',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`key_entry`) REFERENCES `mortal_dungeon_keys`(`item_entry`) ON DELETE CASCADE,
    INDEX `idx_gameobject_entry` (`gameobject_entry`),
    INDEX `idx_key_entry` (`key_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Key requirements for gameobjects';

-- Example key entries (to be populated with actual item entries)
-- These are placeholders - actual item entries will be created in item_template
INSERT INTO `mortal_dungeon_keys` (`item_entry`, `name`, `dungeon_map_id`, `dungeon_name`, `gameobject_entry`, `consumable`, `durability`, `description`) VALUES
-- Dire Maul Keys
(80001, 'Dire Maul East Key', 429, 'Dire Maul', 0, FALSE, 10, 'A crafted key for accessing the eastern wing of Dire Maul. Durability: 10 uses.'),
(80002, 'Dire Maul West Key', 429, 'Dire Maul', 0, FALSE, 10, 'A crafted key for accessing the western wing of Dire Maul. Durability: 10 uses.'),
(80003, 'Dire Maul North Key', 429, 'Dire Maul', 0, FALSE, 10, 'A crafted key for accessing the northern wing of Dire Maul. Durability: 10 uses.'),

-- Blackrock Depths Keys
(80004, 'Shadowforge Key', 230, 'Blackrock Depths', 0, FALSE, 5, 'A key for accessing deeper areas of Blackrock Depths. Durability: 5 uses.'),
(80005, 'Prison Key', 230, 'Blackrock Depths', 0, TRUE, 1, 'A single-use key for accessing the prison area of Blackrock Depths.'),

-- Scholomance Keys
(80006, 'Scholomance Key', 289, 'Scholomance', 0, FALSE, 3, 'A key for accessing secret rooms in Scholomance. Durability: 3 uses.')

ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Example key requirements (if specific gameobjects need keys)
-- These are examples - actual gameobject entries will be determined during implementation
-- INSERT INTO `mortal_key_requirements` (`gameobject_entry`, `key_entry`, `required_count`, `key_combination`) VALUES
-- (12345, 80001, 1, FALSE), -- Example: GameObject 12345 requires Dire Maul East Key
-- (12346, 80002, 1, FALSE)   -- Example: GameObject 12346 requires Dire Maul West Key

