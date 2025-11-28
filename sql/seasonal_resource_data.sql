-- ==================================================
-- Feature: Seasonal Resource Data
-- Description: Seasonal rotation configuration for resources
-- Spec: 04-economy.md section 5.1 Seasonal Variation
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_seasonal_resource_rotation` (
    `season_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `season_name` VARCHAR(100) NOT NULL COMMENT 'Human-readable season name',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone affected by rotation',
    `from_tier` TINYINT UNSIGNED NOT NULL COMMENT 'Tier resources are rotating from',
    `to_tier` TINYINT UNSIGNED NOT NULL COMMENT 'Tier resources are rotating to',
    `multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Spawn rate multiplier during rotation',
    `start_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when rotation starts',
    `end_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when rotation ends',
    `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Whether this rotation is currently active',
    `description` VARCHAR(255) NULL COMMENT 'Optional rotation description',
    INDEX `idx_zone_season` (`zone_id`, `season_id`),
    INDEX `idx_active` (`is_active`),
    INDEX `idx_time_range` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Seasonal resource rotation configurations for dynamic economy';

-- Insert sample seasonal rotations
-- Seasons cycle every 30 days (2592000 seconds)
-- Current time reference: 1732500000 (approx Nov 25, 2024)
INSERT INTO `mortal_seasonal_resource_rotation` (
    `season_name`, `zone_id`, `from_tier`, `to_tier`, `multiplier`,
    `start_time`, `end_time`, `is_active`, `description`
) VALUES
-- Season 1: "Spring Bloom" - Resources shift to higher tiers in fertile areas
('Spring Bloom - Elwynn Forest', 12, 1, 2, 1.5,
    1732500000, 1732500000 + 2592000, 0, 'Copper deposits become Iron deposits in Elwynn Forest'),

('Spring Bloom - Dun Morogh', 1, 1, 2, 1.5,
    1732500000, 1732500000 + 2592000, 0, 'Copper deposits become Iron deposits in Dun Morogh'),

('Spring Bloom - Durotar', 14, 1, 2, 1.5,
    1732500000, 1732500000 + 2592000, 0, 'Copper deposits become Iron deposits in Durotar'),

-- Season 2: "Summer Harvest" - Resources shift to mid-tier in contested areas
('Summer Harvest - The Barrens', 17, 2, 3, 2.0,
    1732500000 + 2592000, 1732500000 + 5184000, 0, 'Iron deposits become Thorium deposits in The Barrens'),

('Summer Harvest - Westfall', 40, 2, 3, 2.0,
    1732500000 + 2592000, 1732500000 + 5184000, 0, 'Iron deposits become Thorium deposits in Westfall'),

('Summer Harvest - Darkshore', 148, 2, 3, 2.0,
    1732500000 + 2592000, 1732500000 + 5184000, 0, 'Iron deposits become Thorium deposits in Darkshore'),

-- Season 3: "Autumn Scarcity" - Resources become scarce in some areas
('Autumn Scarcity - Ashenvale', 331, 3, 2, 0.5,
    1732500000 + 5184000, 1732500000 + 7776000, 0, 'Thorium deposits become scarce in Ashenvale'),

('Autumn Scarcity - Stonetalon', 406, 3, 2, 0.5,
    1732500000 + 5184000, 1732500000 + 7776000, 0, 'Thorium deposits become scarce in Stonetalon'),

-- Season 4: "Winter Prosperity" - Rare resources appear in harsh areas
('Winter Prosperity - Silithus', 1377, 4, 5, 3.0,
    1732500000 + 7776000, 1732500000 + 10368000, 0, 'Rich thorium deposits yield rare dreamfoil in Silithus'),

('Winter Prosperity - Winterspring', 618, 4, 5, 3.0,
    1732500000 + 7776000, 1732500000 + 10368000, 0, 'Rich thorium deposits yield rare dreamfoil in Winterspring'),

('Winter Prosperity - Eastern Plaguelands', 139, 4, 5, 3.0,
    1732500000 + 7776000, 1732500000 + 10368000, 0, 'Rich thorium deposits yield rare dreamfoil in Eastern Plaguelands');

-- ==================================================
-- Feature: Resource Spawn Tracking
-- Description: Tracks active resource spawns for seasonal management
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_resource_spawns` (
    `spawn_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `resource_entry` MEDIUMINT UNSIGNED NOT NULL COMMENT 'Item template entry',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone where spawned',
    `tier` TINYINT UNSIGNED NOT NULL COMMENT 'Resource tier',
    `pos_x` FLOAT NOT NULL COMMENT 'X coordinate',
    `pos_y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `pos_z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `spawn_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when spawned',
    `despawn_time` INT UNSIGNED NULL COMMENT 'Unix timestamp when despawned (NULL if active)',
    `harvested_by` INT UNSIGNED NULL COMMENT 'Player GUID who harvested (NULL if not harvested)',
    `season_id` INT UNSIGNED NULL COMMENT 'Season ID when spawned (FK to mortal_seasonal_resource_rotation)',
    INDEX `idx_zone_tier` (`zone_id`, `tier`),
    INDEX `idx_spawn_time` (`spawn_time`),
    INDEX `idx_harvested` (`harvested_by`),
    INDEX `idx_season` (`season_id`),
    FOREIGN KEY (`season_id`) REFERENCES `mortal_seasonal_resource_rotation` (`season_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Tracks active and historical resource spawns for seasonal analysis';

-- ==================================================
-- Feature: Seasonal Economic Events
-- Description: Special events that affect resource distribution
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_seasonal_economic_events` (
    `event_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_name` VARCHAR(100) NOT NULL COMMENT 'Human-readable event name',
    `event_type` VARCHAR(50) NOT NULL COMMENT 'Type: bloom, scarcity, invasion, etc.',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone affected',
    `start_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when event starts',
    `end_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when event ends',
    `resource_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Resource spawn rate multiplier',
    `gold_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Vendor gold price modifier',
    `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Whether event is currently active',
    `description` VARCHAR(255) NULL COMMENT 'Event description and effects',
    INDEX `idx_zone_event` (`zone_id`, `event_type`),
    INDEX `idx_active` (`is_active`),
    INDEX `idx_time_range` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Special economic events that modify resource distribution and prices';

-- Insert sample economic events
INSERT INTO `mortal_seasonal_economic_events` (
    `event_name`, `event_type`, `zone_id`, `start_time`, `end_time`,
    `resource_multiplier`, `gold_modifier`, `is_active`, `description`
) VALUES
('Dreamscale Bloom', 'bloom', 1377, 1732500000 + 864000, 1732500000 + 1728000, 5.0, 0.7, 0,
    'Rare dreamscale leather becomes abundant in Silithus, driving down prices'),

('Plague Year', 'scarcity', 139, 1732500000 + 4320000, 1732500000 + 5184000, 0.3, 2.5, 0,
    'Plague infestation reduces herb availability in Eastern Plaguelands, increasing prices'),

('Bandit King Season', 'invasion', 17, 1732500000 + 2160000, 1732500000 + 3024000, 1.0, 1.2, 0,
    'Increased bandit activity in The Barrens raises transportation costs'),

('Market Recession', 'recession', 1519, 1732500000 + 6480000, 1732500000 + 7344000, 1.0, 0.8, 0,
    'Economic downturn in Stormwind reduces stall rental fees'),

('Titan Relic Discovery', 'discovery', 3, 1732500000 + 12960000, 1732500000 + 13824000, 2.0, 1.0, 0,
    'Ancient titan artifacts discovered in Badlands increase mining activity');