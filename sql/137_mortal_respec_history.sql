-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Module: mod-mortal-core
-- Feature: Mentor Respec History
-- Description: Tracks respec history for mentor system
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_respec_history` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `respec_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Unique respec ID',
  `respec_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Attributes, 2=Skills, 3=Mastery, 4=Full',
  `timestamp` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of respec',
  `total_skill_points` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Total skill points at time of respec',
  `cost_paid` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gold cost paid for respec',
  `mentor_free` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if free mentor respec',
  `old_attributes` TEXT COMMENT 'JSON of old attribute values',
  `new_attributes` TEXT COMMENT 'JSON of new attribute values',
  `old_skills` TEXT COMMENT 'JSON of old skill values',
  `new_skills` TEXT COMMENT 'JSON of new skill values',
  `old_mastery` TEXT COMMENT 'JSON of old mastery points',
  `new_mastery` TEXT COMMENT 'JSON of new mastery points',
  PRIMARY KEY (`respec_id`),
  INDEX `idx_guid_timestamp` (`guid`, `timestamp`),
  INDEX `idx_guid_type` (`guid`, `respec_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Tracks respec history for mentor system and cost analysis';

-- Add initial data if needed
-- This table starts empty and fills as players respec