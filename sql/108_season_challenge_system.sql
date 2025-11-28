-- ==================================================
-- Project Mortal Warcraft
-- Feature: Season of the Frontier - Challenge System
-- Description: Seasonal challenge track with dailies, weeklies, and seasonals
-- Based on: docs/specs/52-season-of-the-frontier.md
-- ==================================================

-- Seasons
CREATE TABLE IF NOT EXISTS `mortal_seasons` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'SEASON_OF_THE_RISEN, etc.',
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NULL,
    `start_time` INT UNSIGNED NOT NULL,
    `end_time` INT UNSIGNED NOT NULL,
    `total_ranks` INT UNSIGNED NOT NULL DEFAULT 30,
    `is_active` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_active` (`is_active`),
    INDEX `idx_time` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Season definitions';

-- Season Ranks (Reward Tiers)
CREATE TABLE IF NOT EXISTS `mortal_season_ranks` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `season_id` INT UNSIGNED NOT NULL,
    `rank_number` INT UNSIGNED NOT NULL COMMENT '1..N',
    `xp_required` INT UNSIGNED NOT NULL COMMENT 'Cumulative XP required',
    `reward_json` JSON NULL COMMENT 'Structured rewards list',
    INDEX `idx_season_rank` (`season_id`, `rank_number`),
    CONSTRAINT `fk_mortal_season_ranks_season`
        FOREIGN KEY (`season_id`) REFERENCES `mortal_seasons` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Season rank definitions and rewards';

-- Season Challenges
CREATE TABLE IF NOT EXISTS `mortal_season_challenges` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `season_id` INT UNSIGNED NOT NULL,
    `code` VARCHAR(64) NOT NULL COMMENT 'DAILY_FISH_YELLOW, WEEKLY_HELLGATE_3X, etc.',
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `category` VARCHAR(16) NOT NULL COMMENT 'DAILY, WEEKLY, SEASONAL',
    `xp_reward` INT UNSIGNED NOT NULL,
    `meta_json` JSON NULL COMMENT 'Parameters (target counts, zone tags, etc.)',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_season_category` (`season_id`, `category`),
    CONSTRAINT `fk_mortal_season_challenges_season`
        FOREIGN KEY (`season_id`) REFERENCES `mortal_seasons` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Season challenge definitions';

-- Player Season Progress
CREATE TABLE IF NOT EXISTS `mortal_season_progress` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `season_id` INT UNSIGNED NOT NULL,
    `current_xp` INT UNSIGNED NOT NULL DEFAULT 0,
    `current_rank` INT UNSIGNED NOT NULL DEFAULT 0,
    `rewards_claimed` JSON NULL COMMENT 'List of rank_numbers already claimed',
    `last_update_ts` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_character_season` (`guid`, `season_id`),
    INDEX `idx_season` (`season_id`),
    CONSTRAINT `fk_mortal_season_progress_season`
        FOREIGN KEY (`season_id`) REFERENCES `mortal_seasons` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player season progress';

-- Player Challenge Completion State
CREATE TABLE IF NOT EXISTS `mortal_season_challenge_state` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL,
    `challenge_id` INT UNSIGNED NOT NULL,
    `progress_value` INT UNSIGNED NOT NULL DEFAULT 0,
    `completed` TINYINT(1) NOT NULL DEFAULT 0,
    `reset_ts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'When this challenge resets',
    INDEX `idx_char_challenge` (`guid`, `challenge_id`),
    CONSTRAINT `fk_mortal_season_challenge_state_challenge`
        FOREIGN KEY (`challenge_id`) REFERENCES `mortal_season_challenges` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player challenge completion state';

-- Seed Data: Example Season
INSERT INTO `mortal_seasons` (`code`, `name`, `description`, `start_time`, `end_time`, `total_ranks`, `is_active`) VALUES
('SEASON_OF_THE_FRONTIER', 'Season of the Frontier', 'The first season of Mortal Warcraft. Explore, survive, and conquer the frontier!', 
 UNIX_TIMESTAMP('2025-01-01 00:00:00'), UNIX_TIMESTAMP('2025-03-31 23:59:59'), 30, 0)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Example Challenges (for Season 1)
-- These would be populated based on active season
-- INSERT INTO `mortal_season_challenges` (`season_id`, `code`, `name`, `description`, `category`, `xp_reward`, `meta_json`) VALUES
-- (1, 'DAILY_FISH_YELLOW', 'Yellow Zone Angler', 'Catch 5 fish in any Yellow Zone', 'DAILY', 100, '{"target_count": 5, "zone_risk": 2, "activity": "fishing"}'),
-- (1, 'WEEKLY_HELLGATE_3X', 'Hellgate Veteran', 'Complete 3 Hellgates this week', 'WEEKLY', 500, '{"target_count": 3, "activity": "hellgate"}'),
-- (1, 'SEASONAL_STRONGHOLD_CAPTURE', 'Conqueror', 'Capture one Stronghold from enemy guilds', 'SEASONAL', 1000, '{"activity": "stronghold_capture"}');

-- Summary
SELECT 
    'Season Challenge System Created' as summary,
    COUNT(*) as total_seasons,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_seasons
FROM mortal_seasons;

