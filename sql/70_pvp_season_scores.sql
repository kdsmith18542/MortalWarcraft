-- ==================================================
-- Project Mortal Warcraft
-- Feature: PvP Season Scores
-- Description: Seasonal PvP tracking and rewards
-- Spec: 11-pvp-systems.md
-- ==================================================

-- PvP season definitions
CREATE TABLE IF NOT EXISTS `mortal_pvp_seasons` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `season_number` INT UNSIGNED NOT NULL,
    `name` VARCHAR(100) NOT NULL,
    `start_time` INT UNSIGNED NOT NULL,
    `end_time` INT UNSIGNED NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_season_number` (`season_number`),
    KEY `idx_active` (`is_active`),
    KEY `idx_time` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Player PvP season scores
CREATE TABLE IF NOT EXISTS `mortal_pvp_season_scores` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT UNSIGNED NOT NULL,
    `season_id` INT UNSIGNED NOT NULL,
    `kills` INT UNSIGNED NOT NULL DEFAULT 0,
    `deaths` INT UNSIGNED NOT NULL DEFAULT 0,
    `time_in_red_zones` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Time in seconds',
    `hellgate_wins` INT UNSIGNED NOT NULL DEFAULT 0,
    `bounty_claims` INT UNSIGNED NOT NULL DEFAULT 0,
    `rating` INT UNSIGNED NOT NULL DEFAULT 1000 COMMENT 'Base rating 1000',
    `rank` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Season rank',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_guid_season` (`guid`, `season_id`),
    KEY `idx_season` (`season_id`),
    KEY `idx_rating` (`season_id`, `rating`),
    KEY `idx_rank` (`season_id`, `rank`),
    FOREIGN KEY (`season_id`) REFERENCES `mortal_pvp_seasons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PvP kill log (for season tracking)
CREATE TABLE IF NOT EXISTS `mortal_pvp_kill_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `killer_guid` INT UNSIGNED NOT NULL,
    `victim_guid` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `season_id` INT UNSIGNED NOT NULL,
    `time` INT UNSIGNED NOT NULL DEFAULT 0,
    `looted_items` TEXT COMMENT 'JSON array of item entries',
    PRIMARY KEY (`id`),
    KEY `idx_killer` (`killer_guid`, `season_id`),
    KEY `idx_victim` (`victim_guid`, `season_id`),
    KEY `idx_time` (`time`),
    KEY `idx_season` (`season_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

