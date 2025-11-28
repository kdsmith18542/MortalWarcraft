-- ==================================================
-- Project Mortal Warcraft
-- Feature: Hellgate Status Tracking
-- Description: Stores queue/portal metadata for PvP panel + automation
-- ==================================================

DROP TABLE IF EXISTS `mortal_hellgate_status`;
CREATE TABLE `mortal_hellgate_status` (
  `hellgate_id` INT UNSIGNED NOT NULL,
  `status` ENUM('idle','queued','matching','active') NOT NULL DEFAULT 'idle',
  `queue_group1` INT UNSIGNED NOT NULL DEFAULT 0,
  `queue_group2` INT UNSIGNED NOT NULL DEFAULT 0,
  `active_matches` INT UNSIGNED NOT NULL DEFAULT 0,
  `active_players` INT UNSIGNED NOT NULL DEFAULT 0,
  `portal_map` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `portal_x` FLOAT NOT NULL DEFAULT 0,
  `portal_y` FLOAT NOT NULL DEFAULT 0,
  `portal_z` FLOAT NOT NULL DEFAULT 0,
  `last_update` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`hellgate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hellgate queue / activity cache';

