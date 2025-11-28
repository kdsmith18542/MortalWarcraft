-- ==================================================
-- Project Mortal Warcraft
-- Feature: Mentoring System Enhancements
-- Description: Mentor down scaling and group scaling for PvE
-- Based on: docs/specs/47-mentoring-and-build-loadouts.md
-- ==================================================

-- Mentor Mode State
CREATE TABLE IF NOT EXISTS `mortal_mentor_mode` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `is_active` TINYINT(1) NOT NULL DEFAULT 0,
    `target_band` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Target level band (1-5)',
    `effective_level` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Effective level when mentoring',
    `activated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `last_zone_check` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_guid` (`guid`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mentor mode state per character';

-- Level Bands (for mentor scaling)
CREATE TABLE IF NOT EXISTS `mortal_level_bands` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `band_number` INT UNSIGNED NOT NULL UNIQUE COMMENT '1-5',
    `min_level` INT UNSIGNED NOT NULL,
    `max_level` INT UNSIGNED NOT NULL,
    `description` VARCHAR(128) NULL,
    INDEX `idx_band` (`band_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Level bands for mentor scaling';

-- Seed Data: Level Bands
INSERT INTO `mortal_level_bands` (`band_number`, `min_level`, `max_level`, `description`) VALUES
(1, 1, 5, 'Band 1: Levels 1-5'),
(2, 6, 10, 'Band 2: Levels 6-10'),
(3, 11, 15, 'Band 3: Levels 11-15'),
(4, 16, 20, 'Band 4: Levels 16-20'),
(5, 21, 25, 'Band 5: Levels 21-25')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

-- Group Scaling State (for public PvE events)
CREATE TABLE IF NOT EXISTS `mortal_group_scaling_state` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_instance_id` VARCHAR(64) NOT NULL COMMENT 'Unique event instance identifier',
    `event_type` VARCHAR(32) NOT NULL COMMENT 'RIFT, PUBLIC_DUNGEON, WORLD_BOSS',
    `average_level` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Average effective level of participants',
    `scaling_factor` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Applied scaling factor',
    `participant_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_event` (`event_instance_id`),
    INDEX `idx_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Group scaling state for public PvE events';

-- Summary
SELECT 
    'Mentoring Enhancements Created' as summary,
    COUNT(*) as level_bands,
    'Mentor down and group scaling ready' as status
FROM mortal_level_bands;

