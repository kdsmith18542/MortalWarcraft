-- Feature: Seasonal Data
-- Description: Seasonal rotation configuration for resource spawns
-- Spec: 04-economy.md
-- ==================================================

-- Seasonal data table
CREATE TABLE IF NOT EXISTS `mortal_seasonal_data` (
    `season_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `season_name` VARCHAR(50) NOT NULL COMMENT 'Display name for the season',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID affected by this season',
    `resource_tier` TINYINT UNSIGNED NOT NULL COMMENT 'Resource tier affected (1-5)',
    `spawn_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Spawn rate multiplier (1.0 = normal)',
    `start_time` INT UNSIGNED NOT NULL COMMENT 'Season start time (Unix timestamp)',
    `end_time` INT UNSIGNED NOT NULL COMMENT 'Season end time (Unix timestamp)',
    `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=enabled, 0=disabled',
    PRIMARY KEY (`season_id`),
    INDEX `idx_zone_tier` (`zone_id`, `resource_tier`),
    INDEX `idx_time` (`start_time`, `end_time`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Seasonal rotation configuration for resource spawns';

-- Insert sample seasonal data
-- Season 1: Spring (Copper/Iron boost in Green/Yellow zones)
INSERT INTO `mortal_seasonal_data` (`season_name`, `zone_id`, `resource_tier`, `spawn_multiplier`, `start_time`, `end_time`, `enabled`) VALUES
('Spring Bloom', 1519, 1, 1.5, UNIX_TIMESTAMP('2025-03-01 00:00:00'), UNIX_TIMESTAMP('2025-05-31 23:59:59'), 1), -- Stormwind Copper boost
('Spring Bloom', 1537, 1, 1.5, UNIX_TIMESTAMP('2025-03-01 00:00:00'), UNIX_TIMESTAMP('2025-05-31 23:59:59'), 1), -- Ironforge Copper boost
('Spring Bloom', 17, 2, 1.3, UNIX_TIMESTAMP('2025-03-01 00:00:00'), UNIX_TIMESTAMP('2025-05-31 23:59:59'), 1), -- Barrens Iron boost
('Spring Bloom', 130, 2, 1.3, UNIX_TIMESTAMP('2025-03-01 00:00:00'), UNIX_TIMESTAMP('2025-05-31 23:59:59'), 1); -- Silverpine Iron boost

-- Season 2: Summer (Mithril/Thorium boost in Yellow/Red zones)
INSERT INTO `mortal_seasonal_data` (`season_name`, `zone_id`, `resource_tier`, `spawn_multiplier`, `start_time`, `end_time`, `enabled`) VALUES
('Summer Forge', 331, 3, 1.4, UNIX_TIMESTAMP('2025-06-01 00:00:00'), UNIX_TIMESTAMP('2025-08-31 23:59:59'), 1), -- Ashenvale Mithril boost
('Summer Forge', 406, 3, 1.4, UNIX_TIMESTAMP('2025-06-01 00:00:00'), UNIX_TIMESTAMP('2025-08-31 23:59:59'), 1), -- Stonetalon Mithril boost
('Summer Forge', 4, 4, 1.2, UNIX_TIMESTAMP('2025-06-01 00:00:00'), UNIX_TIMESTAMP('2025-08-31 23:59:59'), 1), -- Blasted Lands Thorium boost
('Summer Forge', 46, 4, 1.2, UNIX_TIMESTAMP('2025-06-01 00:00:00'), UNIX_TIMESTAMP('2025-08-31 23:59:59'), 1); -- Burning Steppes Thorium boost

-- Season 3: Autumn (Dreamscale boost in Red zones)
INSERT INTO `mortal_seasonal_data` (`season_name`, `zone_id`, `resource_tier`, `spawn_multiplier`, `start_time`, `end_time`, `enabled`) VALUES
('Autumn Dreams', 4, 5, 1.6, UNIX_TIMESTAMP('2025-09-01 00:00:00'), UNIX_TIMESTAMP('2025-11-30 23:59:59'), 1), -- Blasted Lands Dreamscale boost
('Autumn Dreams', 46, 5, 1.6, UNIX_TIMESTAMP('2025-09-01 00:00:00'), UNIX_TIMESTAMP('2025-11-30 23:59:59'), 1), -- Burning Steppes Dreamscale boost
('Autumn Dreams', 51, 5, 1.6, UNIX_TIMESTAMP('2025-09-01 00:00:00'), UNIX_TIMESTAMP('2025-11-30 23:59:59'), 1); -- Searing Gorge Dreamscale boost

-- Season 4: Winter (General scarcity - reduced spawns)
INSERT INTO `mortal_seasonal_data` (`season_name`, `zone_id`, `resource_tier`, `spawn_multiplier`, `start_time`, `end_time`, `enabled`) VALUES
('Winter Scarcity', 1519, 1, 0.8, UNIX_TIMESTAMP('2025-12-01 00:00:00'), UNIX_TIMESTAMP('2025-02-28 23:59:59'), 1), -- Stormwind Copper reduction
('Winter Scarcity', 1537, 1, 0.8, UNIX_TIMESTAMP('2025-12-01 00:00:00'), UNIX_TIMESTAMP('2025-02-28 23:59:59'), 1), -- Ironforge Copper reduction
('Winter Scarcity', 17, 2, 0.9, UNIX_TIMESTAMP('2025-12-01 00:00:00'), UNIX_TIMESTAMP('2025-02-28 23:59:59'), 1), -- Barrens Iron reduction
('Winter Scarcity', 331, 3, 0.9, UNIX_TIMESTAMP('2025-12-01 00:00:00'), UNIX_TIMESTAMP('2025-02-28 23:59:59'), 1); -- Ashenvale Mithril reduction