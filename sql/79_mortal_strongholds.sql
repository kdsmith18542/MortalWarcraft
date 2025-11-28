-- ==================================================
-- Project Mortal Warcraft
-- Feature: Mortal Strongholds
-- Description: Guild stronghold system with 5-level progression
-- Based on: docs/specs/08-guilds-sovereignty.md
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_strongholds` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL COMMENT 'Stronghold name',
    `guild_id` INT UNSIGNED NULL COMMENT 'Owning guild ID (NULL if unclaimed)',
    `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'World map ID',
    `pos_x` FLOAT NOT NULL COMMENT 'X coordinate',
    `pos_y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `pos_z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `level` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Stronghold level (1-5)',
    `treasury_gold` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Accumulated tax revenue',
    `last_siege_time` INT UNSIGNED NULL COMMENT 'Unix timestamp of last siege',
    `claimed_at` INT UNSIGNED NULL COMMENT 'Unix timestamp when claimed',
    `vulnerability_start` TIME NULL COMMENT 'Vulnerability window start time',
    `vulnerability_end` TIME NULL COMMENT 'Vulnerability window end time',
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_guild` (`guild_id`),
    INDEX `idx_map` (`map_id`),
    INDEX `idx_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild strongholds with progression';

-- Stronghold Features (unlocked per level)
CREATE TABLE IF NOT EXISTS `mortal_stronghold_features` (
    `stronghold_id` INT UNSIGNED NOT NULL,
    `feature_type` VARCHAR(50) NOT NULL COMMENT 'storage, crafting_station, guard_patrol, etc.',
    `feature_level` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `unlocked_at` INT UNSIGNED NULL COMMENT 'Unix timestamp when unlocked',
    PRIMARY KEY (`stronghold_id`, `feature_type`),
    FOREIGN KEY (`stronghold_id`) REFERENCES `mortal_strongholds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stronghold features unlocked per level';

