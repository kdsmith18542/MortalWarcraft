-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Faction Meta - Civic, Frontier, Cartel, Atlas
-- Description: Tracks player and guild standing with soft-power factions
-- Spec: 99-mortal-faction-meta-civic-frontier-cartel-atlas.md
-- Version: 1.0.0
-- ==================================================

-- Player Faction Standing
-- Tracks standing for each player with each faction
CREATE TABLE IF NOT EXISTS `mortal_player_faction_standing` (
  `player_guid` INT UNSIGNED NOT NULL,
  `faction_id` TINYINT UNSIGNED NOT NULL COMMENT '1=Civic, 2=Frontier, 3=Cartel, 4=Atlas',
  `standing` INT NOT NULL DEFAULT 0 COMMENT 'Can be negative',
  `rank` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Neutral, 1=Unfriendly, 2=Hostile, 3=Friendly, 4=Honored, 5=Revered, 6=Exalted',
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`player_guid`, `faction_id`),
  INDEX `idx_faction` (`faction_id`),
  INDEX `idx_standing` (`standing`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player standing with soft-power factions';

-- Guild Faction Standing (optional, for guild-wide bonuses)
CREATE TABLE IF NOT EXISTS `mortal_guild_faction_standing` (
  `guild_id` INT UNSIGNED NOT NULL,
  `faction_id` TINYINT UNSIGNED NOT NULL,
  `standing` INT NOT NULL DEFAULT 0,
  `rank` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`guild_id`, `faction_id`),
  INDEX `idx_faction` (`faction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild standing with soft-power factions';

-- Faction Standing History
-- Log of standing changes for audit/debugging
CREATE TABLE IF NOT EXISTS `mortal_faction_standing_history` (
  `history_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `player_guid` INT UNSIGNED NOT NULL,
  `guild_id` INT UNSIGNED DEFAULT NULL,
  `faction_id` TINYINT UNSIGNED NOT NULL,
  `standing_change` INT NOT NULL COMMENT 'Positive or negative change',
  `reason` VARCHAR(255) COMMENT 'Reason for change (e.g., "Completed Civic Contract", "Killed innocent in Green Zone")',
  `source_type` TINYINT UNSIGNED COMMENT '1=Contract, 2=Guild War, 3=Crime, 4=Siege, 5=Trade, etc.',
  `source_id` INT UNSIGNED DEFAULT NULL COMMENT 'Related ID (contract_id, siege_id, etc.)',
  `changed_at` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`history_id`),
  INDEX `idx_player` (`player_guid`),
  INDEX `idx_guild` (`guild_id`),
  INDEX `idx_faction` (`faction_id`),
  INDEX `idx_changed` (`changed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='History of faction standing changes';

-- Faction Standing Ranks
-- Defines rank thresholds and names
CREATE TABLE IF NOT EXISTS `mortal_faction_standing_ranks` (
  `rank_id` TINYINT UNSIGNED NOT NULL,
  `rank_name` VARCHAR(64) NOT NULL,
  `min_standing` INT NOT NULL,
  `max_standing` INT NOT NULL,
  PRIMARY KEY (`rank_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Faction standing rank definitions';

-- Insert default rank definitions
INSERT IGNORE INTO `mortal_faction_standing_ranks` (`rank_id`, `rank_name`, `min_standing`, `max_standing`) VALUES
(0, 'Neutral', -999, 999),
(1, 'Unfriendly', -2000, -501),
(2, 'Hostile', -99999, -2001),
(3, 'Friendly', 1000, 2999),
(4, 'Honored', 3000, 5999),
(5, 'Revered', 6000, 9999),
(6, 'Exalted', 10000, 99999);

-- Faction Constants
-- 1 = Civic (cities, law, stability)
-- 2 = Frontier (strongholds, militias, outer territories)
-- 3 = Cartel (black/grey markets, smuggling, profit)
-- 4 = Atlas (intel, exploration, information markets)

