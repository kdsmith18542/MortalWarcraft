-- ==================================================
-- Project Mortal Warcraft
-- Feature: Navigation POI System
-- Description: Point-of-Interest registry for map pins and navigation
-- Based on: docs/specs/39-navigation-and-wayfinding.md
-- ==================================================

-- Map POIs Registry
-- Server-driven POIs for map pins and navigation
CREATE TABLE IF NOT EXISTS `mortal_map_pois` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'POI_BANK_SW, POI_SHRINE_ELWYNN01',
    `category` VARCHAR(32) NOT NULL COMMENT 'SERVICE, STRONGHOLD, HELLGATE, WARFRONT, SECRET',
    `map_id` INT UNSIGNED NOT NULL,
    `position_x` FLOAT NOT NULL,
    `position_y` FLOAT NOT NULL,
    `position_z` FLOAT NOT NULL,
    `discovery_mode` VARCHAR(16) NOT NULL DEFAULT 'VISITED' COMMENT 'ALWAYS, VISITED, NEVER',
    `zone_id` INT UNSIGNED NOT NULL,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1=red-zone only, 2=pvp objective',
    `icon_hint` VARCHAR(32) NULL COMMENT 'bank, shrine, stronghold, hellgate',
    `label` VARCHAR(64) NULL COMMENT 'In-game name',
    `notes` VARCHAR(255) NULL,
    INDEX `idx_map` (`map_id`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_category` (`category`),
    INDEX `idx_discovery` (`discovery_mode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Map POI registry';

-- Player POI Discovery
-- Tracks which POIs each player has discovered
CREATE TABLE IF NOT EXISTS `mortal_player_poi_discovery` (
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `poi_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_map_pois.id',
    `discovered_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `poi_id`),
    INDEX `idx_poi` (`poi_id`),
    FOREIGN KEY (`poi_id`) REFERENCES `mortal_map_pois` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player POI discovery tracking';

-- Seed Data: Core Services (Always Known)
INSERT INTO `mortal_map_pois` (`code`, `category`, `map_id`, `position_x`, `position_y`, `position_z`, `discovery_mode`, `zone_id`, `icon_hint`, `label`) VALUES
('POI_BANK_STORMWIND', 'SERVICE', 0, -8913.23, -133.26, 80.54, 'ALWAYS', 1519, 'bank', 'Stormwind Bank'),
('POI_BANK_ORGRIMMAR', 'SERVICE', 1, 1631.45, -4375.80, 31.25, 'ALWAYS', 1637, 'bank', 'Orgrimmar Bank'),
('POI_INN_STORMWIND', 'SERVICE', 0, -8867.65, 673.63, 97.90, 'ALWAYS', 1519, 'inn', 'Stormwind Inn'),
('POI_INN_ORGRIMMAR', 'SERVICE', 1, 1676.21, -4315.50, 61.13, 'ALWAYS', 1637, 'inn', 'Orgrimmar Inn')
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

