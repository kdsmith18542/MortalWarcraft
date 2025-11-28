-- Feature: Caravan Routes
-- Description: Pre-defined caravan routes between zones
-- Spec: 04-economy.md
-- ==================================================

-- Caravan routes table
CREATE TABLE IF NOT EXISTS `mortal_caravan_routes` (
    `route_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `route_name` VARCHAR(100) NOT NULL COMMENT 'Display name for the route',
    `start_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Starting zone ID',
    `end_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Ending zone ID',
    `start_x` FLOAT NOT NULL COMMENT 'Starting X coordinate',
    `start_y` FLOAT NOT NULL COMMENT 'Starting Y coordinate',
    `start_z` FLOAT NOT NULL COMMENT 'Starting Z coordinate',
    `end_x` FLOAT NOT NULL COMMENT 'Ending X coordinate',
    `end_y` FLOAT NOT NULL COMMENT 'Ending Y coordinate',
    `end_z` FLOAT NOT NULL COMMENT 'Ending Z coordinate',
    `base_reward` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Base gold reward in copper',
    `difficulty` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Difficulty level (1-5)',
    `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=enabled, 0=disabled',
    PRIMARY KEY (`route_id`),
    INDEX `idx_zones` (`start_zone_id`, `end_zone_id`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pre-defined caravan routes between zones';

-- Insert sample caravan routes
INSERT INTO `mortal_caravan_routes` (`route_name`, `start_zone_id`, `end_zone_id`, `start_x`, `start_y`, `start_z`, `end_x`, `end_y`, `end_z`, `base_reward`, `difficulty`, `enabled`) VALUES
('Stormwind to Ironforge', 1519, 1537, -8913.0, 554.0, 94.0, -4821.0, -1155.0, 502.0, 500, 2, 1),
('Ironforge to Stormwind', 1537, 1519, -4821.0, -1155.0, 502.0, -8913.0, 554.0, 94.0, 500, 2, 1),
('Stormwind to Booty Bay', 1519, 35, -8913.0, 554.0, 94.0, -14457.0, 470.0, 15.0, 1000, 4, 1),
('Booty Bay to Stormwind', 35, 1519, -14457.0, 470.0, 15.0, -8913.0, 554.0, 94.0, 1000, 4, 1),
('Orgrimmar to Thunder Bluff', 1637, 1638, 1677.0, -4315.0, 61.0, -1274.0, 124.0, 131.0, 600, 3, 1),
('Thunder Bluff to Orgrimmar', 1638, 1637, -1274.0, 124.0, 131.0, 1677.0, -4315.0, 61.0, 600, 3, 1);