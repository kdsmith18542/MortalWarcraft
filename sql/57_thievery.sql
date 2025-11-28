-- ==================================================
-- Project Mortal Warcraft
-- Feature: Thievery (Player Pickpocket)
-- Description: Players can steal items from player bags, risk of flagging
-- ==================================================

-- Thievery Skill Tracking
CREATE TABLE IF NOT EXISTS `character_thievery` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `skill_level` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Thievery skill level (0-400)',
  `successful_thefts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total successful thefts',
  `failed_thefts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total failed thefts (caught)',
  `last_updated` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of last update',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player thievery skill tracking';

-- Theft Log (for tracking and anti-exploit)
CREATE TABLE IF NOT EXISTS `theft_log` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `thief_guid` INT UNSIGNED NOT NULL COMMENT 'Thief player GUID',
  `victim_guid` INT UNSIGNED NOT NULL COMMENT 'Victim player GUID',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Stolen item entry',
  `item_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Item count stolen',
  `success` TINYINT(1) NOT NULL COMMENT 'Was theft successful?',
  `criminal_flag` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Did theft result in criminal flag?',
  `theft_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_thief` (`thief_guid`),
  KEY `idx_victim` (`victim_guid`),
  KEY `idx_time` (`theft_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Theft attempt log';

-- Thievery Skill ID (custom skill)
-- SKILL ID placeholder: 633 (Lockpicking) used in Lua; no DB change needed here.
