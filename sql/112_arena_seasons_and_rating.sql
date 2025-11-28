-- ==================================================
-- Project Mortal Warcraft
-- Feature: Arena Seasons and Rating System
-- Description: Season management, team rating overlay, and rating bands
-- Based on: docs/specs/34-mortal-arena-and-rating.md
-- ==================================================

-- Arena Seasons Table
-- Tracks global season configuration
CREATE TABLE IF NOT EXISTS `mortal_arena_seasons` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(64) NOT NULL COMMENT 'Season name (e.g., "Season 1")',
  `start_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  `end_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if currently active',
  `reward_profile` VARCHAR(32) NOT NULL DEFAULT 'S1_DEFAULT' COMMENT 'Reward profile code',
  `notes` VARCHAR(255) NULL,
  INDEX `idx_active` (`is_active`),
  INDEX `idx_time` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Arena season configuration';

-- Arena Team Rating Overlay
-- Overlay on top of AzerothCore's arena_team table
CREATE TABLE IF NOT EXISTS `mortal_arena_team_rating` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `arena_team_id` INT UNSIGNED NOT NULL COMMENT 'FK to arena_team.id',
  `bracket` TINYINT UNSIGNED NOT NULL COMMENT '2=2v2, 3=3v3, 5=5v5',
  `rating` INT UNSIGNED NOT NULL DEFAULT 1500 COMMENT 'Team rating',
  `mmr` INT UNSIGNED NOT NULL DEFAULT 1500 COMMENT 'Matchmaking Rating',
  `season_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_arena_seasons.id',
  `games_played` INT UNSIGNED NOT NULL DEFAULT 0,
  `games_won` INT UNSIGNED NOT NULL DEFAULT 0,
  `last_update` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  UNIQUE KEY `uk_team_bracket_season` (`arena_team_id`, `bracket`, `season_id`),
  INDEX `idx_team` (`arena_team_id`),
  INDEX `idx_season` (`season_id`),
  INDEX `idx_rating` (`rating`),
  FOREIGN KEY (`season_id`) REFERENCES `mortal_arena_seasons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Arena team rating overlay';

-- Arena Rating Bands
-- Maps rating ranges to P-tier reward bands
CREATE TABLE IF NOT EXISTS `mortal_arena_rating_bands` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(32) NOT NULL COMMENT 'P1, P2, P3, P4, P5, P6',
  `min_rating` INT UNSIGNED NOT NULL COMMENT 'Minimum rating for band',
  `max_rating` INT UNSIGNED NOT NULL COMMENT 'Maximum rating for band (0 = no max)',
  `bracket_mask` TINYINT UNSIGNED NOT NULL DEFAULT 7 COMMENT 'Bitmask: 1=2s, 2=3s, 4=5s; 7=any',
  `weekly_token_base` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Base weekly PvP Token reward',
  `weekly_credits` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Base weekly Military Credits reward',
  `notes` VARCHAR(255) NULL,
  UNIQUE KEY `uk_code` (`code`),
  INDEX `idx_rating_range` (`min_rating`, `max_rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Arena rating bands (P1-P6)';

-- Arena Personal Participation
-- Tracks individual player participation in teams
CREATE TABLE IF NOT EXISTS `mortal_arena_personal` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
  `arena_team_id` INT UNSIGNED NOT NULL COMMENT 'FK to arena_team.id',
  `bracket` TINYINT UNSIGNED NOT NULL COMMENT '2=2v2, 3=3v3, 5=5v5',
  `season_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_arena_seasons.id',
  `games_played_this_week` INT UNSIGNED NOT NULL DEFAULT 0,
  `games_won_this_week` INT UNSIGNED NOT NULL DEFAULT 0,
  `last_week_reset` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last weekly reset',
  `qualifies_for_rewards` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if played >= 30% of team games',
  UNIQUE KEY `uk_guid_team_bracket_season` (`guid`, `arena_team_id`, `bracket`, `season_id`),
  INDEX `idx_guid` (`guid`),
  INDEX `idx_team` (`arena_team_id`),
  INDEX `idx_season` (`season_id`),
  FOREIGN KEY (`season_id`) REFERENCES `mortal_arena_seasons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player participation tracking for arena teams';

-- Seed Data: Rating Bands
INSERT INTO `mortal_arena_rating_bands` (`code`, `min_rating`, `max_rating`, `bracket_mask`, `weekly_token_base`, `weekly_credits`, `notes`) VALUES
('P1', 1300, 1499, 7, 200, 100, 'Entry PvP tier'),
('P2', 1500, 1699, 7, 400, 200, 'Core PvP tier'),
('P3', 1700, 1899, 7, 600, 300, 'Serious PvP tier'),
('P4', 1900, 2099, 7, 800, 400, 'High PvP tier'),
('P5', 2100, 2299, 7, 1000, 500, 'Elite PvP tier'),
('P6', 2300, 0, 7, 1200, 600, 'Top-end / gladiator tier')
ON DUPLICATE KEY UPDATE `code` = VALUES(`code`);

-- Seed Data: Initial Season
INSERT INTO `mortal_arena_seasons` (`name`, `start_time`, `end_time`, `is_active`, `reward_profile`, `notes`) VALUES
('Season 1', UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + (90 * 86400), 1, 'S1_DEFAULT', 'Initial Mortal arena season')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

