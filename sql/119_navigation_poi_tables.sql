-- ==================================================
-- Project Mortal Warcraft
-- Feature: Navigation POI System
-- Description: Point of Interest tables for navigation
-- Based on: docs/specs/39-navigation-and-wayfinding.md
-- ==================================================

-- POI Discoveries (player discovery tracking)
CREATE TABLE IF NOT EXISTS `mortal_poi_discoveries` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `player_guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `poi_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_map_pois.id',
    `discovered_at` INT UNSIGNED NOT NULL,
    UNIQUE KEY `uk_player_poi` (`player_guid`, `poi_id`),
    INDEX `idx_player` (`player_guid`),
    INDEX `idx_poi` (`poi_id`),
    FOREIGN KEY (`poi_id`) REFERENCES `mortal_map_pois` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player POI discoveries';

-- Buy Order Log (if not exists)
CREATE TABLE IF NOT EXISTS `mortal_buy_order_log` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `order_id` INT UNSIGNED NOT NULL,
    `player_guid` INT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    `payment` INT UNSIGNED NOT NULL,
    `fulfilled_at` INT UNSIGNED NOT NULL,
    INDEX `idx_order` (`order_id`),
    INDEX `idx_player` (`player_guid`),
    INDEX `idx_time` (`fulfilled_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Buy order fulfillment log';

