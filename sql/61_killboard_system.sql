-- ==================================================
-- Project Mortal Warcraft: Killboard System
-- Feature: PvP Kill Tracking for Web Portal
-- Description: Tracks PvP kills with loot value, location, and participants
-- ==================================================

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. CREATE KILLBOARD TABLE
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pvp_killboard` (
    `kill_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `killer_guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID of killer',
    `killer_name` VARCHAR(12) NOT NULL COMMENT 'Character name of killer',
    `victim_guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID of victim',
    `victim_name` VARCHAR(12) NOT NULL COMMENT 'Character name of victim',
    `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID where kill occurred',
    `zone_name` VARCHAR(100) DEFAULT NULL COMMENT 'Zone name (cached)',
    `map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID',
    `location_x` FLOAT NOT NULL,
    `location_y` FLOAT NOT NULL,
    `location_z` FLOAT NOT NULL,
    `loot_value` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total gold value in copper',
    `notoriety_gain` INT NOT NULL DEFAULT 0 COMMENT 'Notoriety gained from kill',
    `is_zerg` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'True if > 5 attackers',
    `kill_time` TIMESTAMP NOT NULL DEFAULT 0,
    `killer_guild_id` INT UNSIGNED DEFAULT NULL COMMENT 'Guild ID of killer',
    `victim_guild_id` INT UNSIGNED DEFAULT NULL COMMENT 'Guild ID of victim',
    PRIMARY KEY (`kill_id`),
    INDEX `idx_killer_guid` (`killer_guid`),
    INDEX `idx_victim_guid` (`victim_guid`),
    INDEX `idx_kill_time` (`kill_time`),
    INDEX `idx_zone_id` (`zone_id`),
    INDEX `idx_loot_value` (`loot_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='PvP killboard for web portal';

-- ------------------------------------------------------------------
-- 2. CREATE KILLBOARD PARTICIPANTS TABLE (for group kills)
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pvp_killboard_participants` (
    `participant_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `kill_id` BIGINT UNSIGNED NOT NULL,
    `character_guid` INT UNSIGNED NOT NULL,
    `character_name` VARCHAR(12) NOT NULL,
    `guild_id` INT UNSIGNED DEFAULT NULL,
    `damage_dealt` INT UNSIGNED DEFAULT 0 COMMENT 'Damage dealt to victim',
    `is_killer` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'True if this is the final killer',
    PRIMARY KEY (`participant_id`),
    INDEX `idx_kill_id` (`kill_id`),
    INDEX `idx_character_guid` (`character_guid`),
    FOREIGN KEY (`kill_id`) REFERENCES `pvp_killboard`(`kill_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Participants in PvP kills (for group kills)';

-- ------------------------------------------------------------------
-- 3. CREATE KILLBOARD LOOT TABLE
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pvp_killboard_loot` (
    `loot_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `kill_id` BIGINT UNSIGNED NOT NULL,
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item template entry',
    `item_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `item_value` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gold value in copper',
    PRIMARY KEY (`loot_id`),
    INDEX `idx_kill_id` (`kill_id`),
    FOREIGN KEY (`kill_id`) REFERENCES `pvp_killboard`(`kill_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Loot dropped in PvP kills';

-- ------------------------------------------------------------------
-- 4. CREATE CHARACTER NOTORIETY TABLE (if not exists)
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `character_notoriety` (
    `guid` INT UNSIGNED NOT NULL,
    `notoriety_level` INT NOT NULL DEFAULT 0 COMMENT 'Current notoriety score',
    `last_updated` TIMESTAMP NOT NULL DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`guid`),
    INDEX `idx_notoriety_level` (`notoriety_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Character notoriety tracking';

COMMIT;

-- Report results
SELECT 'Killboard system tables created successfully.' AS result;

