-- ==================================================
-- Project Mortal Warcraft
-- Feature: Warfront State Tracking
-- Description: Stores portal metadata + open/closed status for Warfront UI
-- ==================================================

DROP TABLE IF EXISTS `mortal_warfront_state`;
CREATE TABLE `mortal_warfront_state` (
  `warfront_id` INT UNSIGNED NOT NULL,
  `status` ENUM('preparing','open','resolving','closed') NOT NULL DEFAULT 'preparing',
  `controlling_guild_id` INT UNSIGNED NULL,
  `next_open_time` INT UNSIGNED NOT NULL DEFAULT 0,
  `last_result` VARCHAR(150) DEFAULT NULL,
  `portal_map` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `portal_x` FLOAT NOT NULL DEFAULT 0,
  `portal_y` FLOAT NOT NULL DEFAULT 0,
  `portal_z` FLOAT NOT NULL DEFAULT 0,
  `last_update` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`warfront_id`),
  KEY `idx_guild` (`controlling_guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Warfront status cache for UI/automation';
