-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Module: mod-mortal-core
-- Feature: Character Mortal Flags
-- Description: Stores various flags for mortal characters
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_mortal_flags` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `onboarded` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Whether player has completed tutorial/onboarding',
  `tutorial_completed` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Tutorial completion flag',
  `first_login` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'First login timestamp',
  `last_activity` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last activity timestamp',
  PRIMARY KEY (`guid`),
  INDEX `idx_onboarded` (`onboarded`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mortal-specific character flags and status';