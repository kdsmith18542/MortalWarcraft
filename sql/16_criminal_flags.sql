-- ==================================================
-- Project Mortal Warcraft: Criminal Flag System
-- Module: mod-mortal-core
-- Feature: Criminal Flag Tracking
-- Description: Tracks criminal status for PvP zones (15-minute timer)
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_criminal_flags` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `criminal_until` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when criminal flag expires',
  PRIMARY KEY (`guid`),
  INDEX `idx_criminal_until` (`criminal_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tracks criminal status for PvP zone loot system';
