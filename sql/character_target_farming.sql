-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Module: mod-mortal-core
-- Feature: Anti-Zerg Farming Data
-- Description: Tracks farming behavior to prevent loot farming
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_target_farming` (
  `victim_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID of the victim',
  `attacker_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID of the attacker',
  `kill_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of times attacker killed victim',
  `last_kill_timestamp` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of last kill',
  `loot_quality_reduction` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Percentage reduction in loot quality (0-100)',
  `farming_penalty_expires` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when penalty expires',
  PRIMARY KEY (`victim_guid`, `attacker_guid`),
  INDEX `idx_attacker` (`attacker_guid`),
  INDEX `idx_penalty_expires` (`farming_penalty_expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tracks farming behavior for anti-zerg system';