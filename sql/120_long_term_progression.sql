-- ==================================================
-- Project Mortal Warcraft
-- Feature: Long-Term Progression System
-- Description: Eras, seasons, and long-term progression tracking
-- Based on: docs/specs/43-long-term-progression-and-seasons.md
-- ==================================================

-- Eras (Long-term progression periods)
CREATE TABLE IF NOT EXISTS `mortal_eras` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `era_code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'ERA_1_RISEN, ERA_2_FRONTIER, etc.',
    `era_name` VARCHAR(128) NOT NULL,
    `description` TEXT NULL,
    `start_time` INT UNSIGNED NOT NULL,
    `end_time` INT UNSIGNED NULL COMMENT 'NULL if current era',
    `featured_content_json` JSON NULL COMMENT 'Featured rifts, events, etc.',
    `is_active` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_active` (`is_active`),
    INDEX `idx_time` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Era definitions';

-- Era Progression Milestones
CREATE TABLE IF NOT EXISTS `mortal_era_milestones` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `era_id` INT UNSIGNED NOT NULL,
    `milestone_name` VARCHAR(128) NOT NULL,
    `milestone_type` VARCHAR(32) NOT NULL COMMENT 'WORLD_EVENT, RIFT, ACHIEVEMENT, GUILD',
    `target_value` INT UNSIGNED NOT NULL COMMENT 'Target count/score',
    `current_value` INT UNSIGNED NOT NULL DEFAULT 0,
    `reward_json` JSON NULL COMMENT 'Rewards when milestone reached',
    `is_completed` TINYINT(1) NOT NULL DEFAULT 0,
    `completed_at` INT UNSIGNED NULL,
    INDEX `idx_era` (`era_id`),
    INDEX `idx_completed` (`is_completed`),
    CONSTRAINT `fk_mortal_era_milestones_era`
        FOREIGN KEY (`era_id`) REFERENCES `mortal_eras` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Era progression milestones';

-- Player Era Participation
CREATE TABLE IF NOT EXISTS `mortal_player_era_participation` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL,
    `era_id` INT UNSIGNED NOT NULL,
    `contribution_score` INT UNSIGNED NOT NULL DEFAULT 0,
    `milestones_unlocked` JSON NULL COMMENT 'List of milestone IDs unlocked',
    `rewards_claimed` JSON NULL COMMENT 'List of reward IDs claimed',
    `last_update` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_guid_era` (`guid`, `era_id`),
    INDEX `idx_era` (`era_id`),
    CONSTRAINT `fk_mortal_player_era_participation_era`
        FOREIGN KEY (`era_id`) REFERENCES `mortal_eras` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player era participation tracking';

-- Seed Data: Example Era
INSERT INTO `mortal_eras` (`era_code`, `era_name`, `description`, `start_time`, `is_active`) VALUES
('ERA_1_RISEN', 'Era of the Risen', 'The first era of Mortal Warcraft', UNIX_TIMESTAMP('2025-01-01 00:00:00'), 0)
ON DUPLICATE KEY UPDATE `era_name` = VALUES(`era_name`);

-- Summary
SELECT 
    'Long-Term Progression System Created' as summary,
    COUNT(*) as total_eras,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_eras
FROM mortal_eras;

