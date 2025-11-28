-- ==================================================
-- Project Mortal Warcraft
-- Feature: Elden's Eve Layer Enhancements
-- Description: Planar rifts, anomalies, and insurance system
-- Based on: docs/specs/45-eldens-eve-layer.md
-- ==================================================

-- Planar Rifts
CREATE TABLE IF NOT EXISTS `mortal_planar_rifts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `rift_code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'RIFT_DUSKWOOD_1, etc.',
    `rift_name` VARCHAR(128) NOT NULL,
    `description` TEXT NULL,
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `position_x` FLOAT NOT NULL,
    `position_y` FLOAT NOT NULL,
    `position_z` FLOAT NOT NULL,
    `rift_type` VARCHAR(32) NOT NULL COMMENT 'MINOR, MAJOR, ELITE',
    `spawn_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Daily spawn chance (0.0-1.0)',
    `min_level` INT UNSIGNED NOT NULL DEFAULT 1,
    `max_level` INT UNSIGNED NOT NULL DEFAULT 80,
    `is_active` TINYINT(1) NOT NULL DEFAULT 0,
    `spawned_at` INT UNSIGNED NULL,
    `despawns_at` INT UNSIGNED NULL,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_map_zone` (`map_id`, `zone_id`),
    INDEX `idx_active` (`is_active`),
    INDEX `idx_type` (`rift_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Planar rift definitions';

-- Planar Anomalies
CREATE TABLE IF NOT EXISTS `mortal_planar_anomalies` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `anomaly_code` VARCHAR(64) NOT NULL UNIQUE,
    `anomaly_name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `anomaly_type` VARCHAR(32) NOT NULL COMMENT 'TEMPORAL, SPATIAL, REALITY_BREACH',
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `position_x` FLOAT NOT NULL,
    `position_y` FLOAT NOT NULL,
    `position_z` FLOAT NOT NULL,
    `radius` FLOAT NOT NULL DEFAULT 50.0 COMMENT 'Effect radius in yards',
    `effect_json` JSON NULL COMMENT 'Anomaly effects (buffs/debuffs, visual)',
    `spawn_chance` FLOAT NOT NULL DEFAULT 0.05 COMMENT 'Daily spawn chance',
    `duration_minutes` INT UNSIGNED NOT NULL DEFAULT 60,
    `is_active` TINYINT(1) NOT NULL DEFAULT 0,
    `spawned_at` INT UNSIGNED NULL,
    `expires_at` INT UNSIGNED NULL,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_map_zone` (`map_id`, `zone_id`),
    INDEX `idx_active` (`is_active`),
    INDEX `idx_type` (`anomaly_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Planar anomaly definitions';

-- Insurance Policies (already exists, but enhance if needed)
-- mortal_insurance_policies table already exists

-- Rift Participation Log
CREATE TABLE IF NOT EXISTS `mortal_rift_participation` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `rift_id` INT UNSIGNED NOT NULL,
    `guid` INT UNSIGNED NOT NULL,
    `joined_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `completed_at` INT UNSIGNED NULL,
    `rewards_claimed` TINYINT(1) NOT NULL DEFAULT 0,
    INDEX `idx_rift` (`rift_id`),
    INDEX `idx_guid` (`guid`),
    CONSTRAINT `fk_mortal_rift_participation_rift`
        FOREIGN KEY (`rift_id`) REFERENCES `mortal_planar_rifts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rift participation tracking';

-- Seed Data: Example Rifts
INSERT INTO `mortal_planar_rifts` (`rift_code`, `rift_name`, `description`, `map_id`, `zone_id`, `position_x`, `position_y`, `position_z`, `rift_type`, `spawn_chance`, `min_level`, `max_level`) VALUES
('RIFT_DUSKWOOD_1', 'Duskwood Planar Rift', 'A minor planar breach in Duskwood', 0, 10, -10898.0, -415.0, 22.0, 'MINOR', 0.15, 20, 40),
('RIFT_STRANGLETHORN_1', 'Stranglethorn Major Rift', 'A major planar disturbance', 0, 33, -12000.0, -2000.0, 10.0, 'MAJOR', 0.1, 30, 60)
ON DUPLICATE KEY UPDATE `rift_name` = VALUES(`rift_name`);

-- Seed Data: Example Anomalies
INSERT INTO `mortal_planar_anomalies` (`anomaly_code`, `anomaly_name`, `description`, `anomaly_type`, `map_id`, `zone_id`, `position_x`, `position_y`, `position_z`, `radius`, `spawn_chance`, `duration_minutes`) VALUES
('ANOMALY_TEMPORAL_1', 'Temporal Distortion', 'Time flows differently here', 'TEMPORAL', 0, 10, -10900.0, -420.0, 22.0, 30.0, 0.05, 120),
('ANOMALY_SPATIAL_1', 'Spatial Fold', 'Space is warped in this area', 'SPATIAL', 0, 33, -12050.0, -2050.0, 10.0, 50.0, 0.03, 180)
ON DUPLICATE KEY UPDATE `anomaly_name` = VALUES(`anomaly_name`);

-- Summary
SELECT 
    'Elden''s Eve Layer Enhancements Created' as summary,
    COUNT(CASE WHEN rift_type = 'MINOR' THEN 1 END) as minor_rifts,
    COUNT(CASE WHEN rift_type = 'MAJOR' THEN 1 END) as major_rifts,
    COUNT(CASE WHEN rift_type = 'ELITE' THEN 1 END) as elite_rifts,
    COUNT(*) as total_anomalies
FROM mortal_planar_rifts
CROSS JOIN (SELECT COUNT(*) as total_anomalies FROM mortal_planar_anomalies) a;

