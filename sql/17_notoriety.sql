-- ==================================================
-- Project Mortal Warcraft: Notoriety & Bounty System
-- Module: mod-mortal-core
-- Feature: Player notoriety tracking for bounty system
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_notoriety` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `notoriety` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Notoriety level (kills innocent players)',
  `last_updated` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of last update',
  PRIMARY KEY (`guid`),
  INDEX `idx_notoriety` (`notoriety`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player notoriety tracking for bounty system';
