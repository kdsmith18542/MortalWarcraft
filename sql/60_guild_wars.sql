-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Guild Wars (Corporate Warfare)
-- Description: Tracks active hostilities between guilds, war declarations, kill scores, and wagers
-- Version: 18.0
-- ==================================================

-- Guild Wars Table
-- Tracks active war declarations between guilds
CREATE TABLE IF NOT EXISTS `guild_wars` (
  `war_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guild_challenger` INT UNSIGNED NOT NULL COMMENT 'Guild ID of the guild declaring war',
  `guild_target` INT UNSIGNED NOT NULL COMMENT 'Guild ID of the target guild',
  `start_time` BIGINT UNSIGNED NOT NULL COMMENT 'War active after 24h warmup (Unix timestamp)',
  `end_time` BIGINT UNSIGNED DEFAULT 0 COMMENT '0 = Indefinite war, otherwise Unix timestamp when war ends',
  `kill_score_challenger` INT UNSIGNED DEFAULT 0 COMMENT 'Total kills by challenger guild',
  `kill_score_target` INT UNSIGNED DEFAULT 0 COMMENT 'Total kills by target guild',
  `wager_amount` BIGINT UNSIGNED DEFAULT 0 COMMENT 'Optional Gold Bet (winner takes all)',
  `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '1=Active, 2=Ended, 3=Cancelled',
  `created_at` TIMESTAMP DEFAULT 0,
  PRIMARY KEY (`war_id`),
  INDEX `idx_challenger` (`guild_challenger`),
  INDEX `idx_target` (`guild_target`),
  INDEX `idx_status` (`status`),
  INDEX `idx_start_time` (`start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild war declarations and tracking';

-- Guild War Kill Log
-- Tracks individual kills during wars for scoring
CREATE TABLE IF NOT EXISTS `guild_war_kills` (
  `kill_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `war_id` INT UNSIGNED NOT NULL,
  `killer_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID of killer',
  `victim_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID of victim',
  `killer_guild` INT UNSIGNED NOT NULL,
  `victim_guild` INT UNSIGNED NOT NULL,
  `kill_time` BIGINT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  `zone_id` INT UNSIGNED NOT NULL,
  `loot_value` BIGINT UNSIGNED DEFAULT 0 COMMENT 'Gold value of items dropped',
  PRIMARY KEY (`kill_id`),
  INDEX `idx_war_id` (`war_id`),
  INDEX `idx_kill_time` (`kill_time`),
  INDEX `idx_killer_guild` (`killer_guild`),
  INDEX `idx_victim_guild` (`victim_guild`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Individual kills during guild wars';

-- Guild Alliances Table
-- Tracks formal "Blue" status between guilds
CREATE TABLE IF NOT EXISTS `guild_alliances` (
  `alliance_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guild1_id` INT UNSIGNED NOT NULL,
  `guild2_id` INT UNSIGNED NOT NULL,
  `created_at` TIMESTAMP DEFAULT 0,
  `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '1=Active, 2=Broken',
  PRIMARY KEY (`alliance_id`),
  UNIQUE KEY `unique_alliance` (`guild1_id`, `guild2_id`),
  INDEX `idx_guild1` (`guild1_id`),
  INDEX `idx_guild2` (`guild2_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Formal alliances between guilds (Blue status)';

-- Guild Taxation Configuration
-- Add tax rate column to guild table if it doesn't exist
SET @db_name = DATABASE();
SET @table_exists = (
    SELECT COUNT(*) 
    FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA = @db_name 
    AND TABLE_NAME = 'guild'
);

SET @column_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @db_name 
    AND TABLE_NAME = 'guild' 
    AND COLUMN_NAME = 'tax_rate'
);

SET @sql = IF(@table_exists > 0 AND @column_exists = 0,
    'ALTER TABLE `guild` ADD COLUMN `tax_rate` TINYINT UNSIGNED DEFAULT 5 COMMENT ''Tax rate percentage (0-100) on member loot drops''',
    'SELECT ''Column tax_rate already exists or guild table not found'' AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Guild Stronghold Chest
-- Tracks accumulated tax revenue in stronghold chests
CREATE TABLE IF NOT EXISTS `guild_stronghold_chest` (
  `guild_id` INT UNSIGNED NOT NULL,
  `gold_amount` BIGINT UNSIGNED DEFAULT 0 COMMENT 'Accumulated tax revenue',
  `last_updated` TIMESTAMP DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stronghold tax revenue chest';

-- War Declaration Fee Configuration
-- This would typically be in a config table, but for now we'll document it
-- War declaration fee: 1000 Gold (configurable via worldserver.conf or config table)

-- Example: Insert test war (commented out)
-- INSERT INTO `guild_wars` (`guild_challenger`, `guild_target`, `start_time`, `wager_amount`) 
-- VALUES (1, 2, UNIX_TIMESTAMP() + 86400, 5000);

-- Example: Insert test alliance (commented out)
-- INSERT INTO `guild_alliances` (`guild1_id`, `guild2_id`) 
-- VALUES (1, 3);

