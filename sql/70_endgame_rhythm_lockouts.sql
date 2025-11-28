-- ==================================================
-- Mortal Warcraft – Endgame Rhythm & Lockouts
-- Spec 65: Endgame Rhythm, Lockouts & Seasonal Cadence
-- Target DB: world, characters
-- ==================================================

-- Scheduler Configuration: Time-based rules for daily/weekly/seasonal resets
CREATE TABLE IF NOT EXISTS `mortal_scheduler_config` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `config_key` VARCHAR(64) UNIQUE NOT NULL,        -- 'DAILY_RESET_HOUR', 'WEEKLY_RESET_DAY', 'SEASON_LENGTH_WEEKS'
    `config_value` VARCHAR(255) NOT NULL,            -- '0' (midnight), '1' (Monday), '10' (weeks)
    `description` TEXT DEFAULT NULL,
    `updated_at` INT NOT NULL DEFAULT 0,
    INDEX `idx_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Character Lockouts: Per-character lockout tracking
CREATE TABLE IF NOT EXISTS `mortal_character_lockouts` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `character_guid` BIGINT NOT NULL,
    `lockout_type` TINYINT NOT NULL,                -- 1=raid, 2=trial, 3=world_boss, 4=contract_daily
    `lockout_key` VARCHAR(64) NOT NULL,              -- 'ICC', 'TRIAL_SHRINE_1', 'WORLD_BOSS_AZUREGOS', 'CONTRACT_DAILY'
    `lockout_value` INT NOT NULL DEFAULT 0,          -- For raids: instance ID, for others: count or flag
    `expires_at` INT NOT NULL,                       -- Unix timestamp when lockout expires
    `created_at` INT NOT NULL,
    INDEX `idx_character` (`character_guid`),
    INDEX `idx_type_key` (`lockout_type`, `lockout_key`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seasonal Progression: Per-character season progression tracking
CREATE TABLE IF NOT EXISTS `mortal_seasonal_progression` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `character_guid` BIGINT NOT NULL,
    `season_id` INT NOT NULL,                        -- Current season ID
    `progression_points` INT NOT NULL DEFAULT 0,    -- Total progression points earned
    `milestone_rewards_claimed` TEXT DEFAULT NULL,   -- JSON array of claimed milestone IDs
    `seasonal_currency` INT NOT NULL DEFAULT 0,     -- Seasonal currency balance
    `updated_at` INT NOT NULL,
    UNIQUE KEY `uk_char_season` (`character_guid`, `season_id`),
    INDEX `idx_season` (`season_id`),
    INDEX `idx_points` (`progression_points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Season Definitions: Season metadata
CREATE TABLE IF NOT EXISTS `mortal_seasons` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `season_key` VARCHAR(64) UNIQUE NOT NULL,       -- 'SEASON_1_BLACK_ICE', 'SEASON_2_ASHEN_CROWNS'
    `name` VARCHAR(128) NOT NULL,
    `theme` VARCHAR(128) NOT NULL,                   -- 'Black Ice', 'Ashen Crowns', 'Rusted Gold'
    `start_time` INT NOT NULL,                       -- Unix timestamp
    `end_time` INT NOT NULL,                         -- Unix timestamp
    `length_weeks` INT NOT NULL DEFAULT 10,
    `is_active` TINYINT NOT NULL DEFAULT 0,
    `created_at` INT NOT NULL,
    INDEX `idx_active` (`is_active`),
    INDEX `idx_time` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Event Windows: Scheduled event windows (Warfronts, Stronghold vulnerability, etc.)
CREATE TABLE IF NOT EXISTS `mortal_event_windows` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `event_type` TINYINT NOT NULL,                   -- 1=warfront, 2=stronghold_vuln, 3=world_boss, 4=rift_surge, 5=midnight_horde
    `event_key` VARCHAR(64) NOT NULL,               -- 'WARFRONT_1', 'STRONGHOLD_123', 'WORLD_BOSS_AZUREGOS'
    `start_time` INT NOT NULL,                       -- Unix timestamp
    `end_time` INT NOT NULL,                         -- Unix timestamp
    `duration_minutes` INT NOT NULL,
    `recurrence_type` TINYINT NOT NULL DEFAULT 0,   -- 0=one-time, 1=daily, 2=weekly, 3=seasonal
    `recurrence_data` TEXT DEFAULT NULL,            -- JSON for recurrence rules
    `is_active` TINYINT NOT NULL DEFAULT 0,
    `created_at` INT NOT NULL,
    INDEX `idx_type` (`event_type`),
    INDEX `idx_time` (`start_time`, `end_time`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seasonal Leaderboards: Leaderboard tracking per season
CREATE TABLE IF NOT EXISTS `mortal_seasonal_leaderboards` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `season_id` INT NOT NULL,
    `leaderboard_type` TINYINT NOT NULL,             -- 1=guild_territory, 2=guild_warfront_wins, 3=player_contracts, 4=player_pvp, 5=player_trials
    `entity_type` TINYINT NOT NULL,                  -- 1=player, 2=guild
    `entity_id` BIGINT NOT NULL,                     -- character_guid or guild_id
    `score` INT NOT NULL DEFAULT 0,
    `rank` INT NOT NULL DEFAULT 0,
    `updated_at` INT NOT NULL,
    INDEX `idx_season_type` (`season_id`, `leaderboard_type`),
    INDEX `idx_entity` (`entity_type`, `entity_id`),
    INDEX `idx_score` (`leaderboard_type`, `score`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initialize default scheduler config
INSERT INTO `mortal_scheduler_config` (`config_key`, `config_value`, `description`, `updated_at`) VALUES
('DAILY_RESET_HOUR', '0', 'Hour of day for daily reset (0-23, default 0 = midnight)', UNIX_TIMESTAMP()),
('WEEKLY_RESET_DAY', '1', 'Day of week for weekly reset (0=Sunday, 1=Monday, default 1)', UNIX_TIMESTAMP()),
('SEASON_LENGTH_WEEKS', '10', 'Default season length in weeks', UNIX_TIMESTAMP()),
('CONTRACT_DAILY_CAP', '10', 'Daily contract cap per character for full rewards', UNIX_TIMESTAMP()),
('MIDNIGHT_HORDE_WINDOW_START', '22', 'Hour when Midnight Horde window starts (0-23)', UNIX_TIMESTAMP()),
('MIDNIGHT_HORDE_WINDOW_END', '2', 'Hour when Midnight Horde window ends (0-23)', UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE `updated_at` = UNIX_TIMESTAMP();

