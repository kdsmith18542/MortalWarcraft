-- ==================================================
-- Project Mortal Warcraft
-- Feature: Hellgates (PvP Dungeons)
-- Description: Two groups enter same instance, boss in middle, winner takes loot
-- ==================================================

-- Hellgate Configuration Table
CREATE TABLE IF NOT EXISTS `hellgates_config` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Dungeon map ID',
  `name` VARCHAR(100) NOT NULL COMMENT 'Hellgate name',
  `boss_entry` INT UNSIGNED NOT NULL COMMENT 'Boss creature entry',
  `boss_x` FLOAT NOT NULL COMMENT 'Boss spawn X',
  `boss_y` FLOAT NOT NULL COMMENT 'Boss spawn Y',
  `boss_z` FLOAT NOT NULL COMMENT 'Boss spawn Z',
  `boss_o` FLOAT NOT NULL COMMENT 'Boss spawn orientation',
  `entry_portal_x` FLOAT NOT NULL COMMENT 'Entry portal X',
  `entry_portal_y` FLOAT NOT NULL COMMENT 'Entry portal Y',
  `entry_portal_z` FLOAT NOT NULL COMMENT 'Entry portal Z',
  `entry_portal_o` FLOAT NOT NULL COMMENT 'Entry portal orientation',
  `min_players` TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT 'Minimum players per group',
  `max_players` TINYINT UNSIGNED NOT NULL DEFAULT 5 COMMENT 'Maximum players per group',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is this hellgate enabled?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_map` (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hellgate dungeon configurations';

-- Active Hellgate Instances
CREATE TABLE IF NOT EXISTS `hellgates_active` (
  `instance_id` INT UNSIGNED NOT NULL COMMENT 'Instance ID',
  `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Map ID',
  `group1_leader` INT UNSIGNED NOT NULL COMMENT 'Group 1 leader GUID',
  `group2_leader` INT UNSIGNED NOT NULL COMMENT 'Group 2 leader GUID',
  `boss_spawned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Has boss been spawned?',
  `boss_killed` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Has boss been killed?',
  `winner_group` TINYINT UNSIGNED NULL COMMENT 'Winning group (1 or 2)',
  `started_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp when started',
  `ended_at` INT UNSIGNED NULL COMMENT 'Unix timestamp when ended',
  PRIMARY KEY (`instance_id`),
  KEY `idx_group1` (`group1_leader`),
  KEY `idx_group2` (`group2_leader`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Active hellgate instances';

-- Hellgate Entry Portals (GameObjects)
-- These are physical portals in the world that players click to enter
CREATE TABLE IF NOT EXISTS `hellgates_portals` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `hellgate_id` INT UNSIGNED NOT NULL COMMENT 'Reference to hellgates_config.id',
  `map` SMALLINT UNSIGNED NOT NULL COMMENT 'World map where portal exists',
  `x` FLOAT NOT NULL COMMENT 'Portal X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Portal Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Portal Z coordinate',
  `o` FLOAT NOT NULL COMMENT 'Portal orientation',
  `go_entry` INT UNSIGNED NOT NULL DEFAULT 177193 COMMENT 'GameObject entry (Portal)',
  PRIMARY KEY (`id`),
  KEY `idx_hellgate` (`hellgate_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hellgate entry portals in world';

-- Insert example Hellgate configurations
-- Example: Deadmines as a Hellgate
INSERT INTO `hellgates_config` (
    `map_id`, `name`, `boss_entry`, `boss_x`, `boss_y`, `boss_z`, `boss_o`,
    `entry_portal_x`, `entry_portal_y`, `entry_portal_z`, `entry_portal_o`,
    `min_players`, `max_players`, `enabled`
) VALUES
-- Deadmines Hellgate (Map 36)
(36, 'Deadmines Hellgate', 639, -16.0, -383.0, 62.0, 0.0, -16.0, -383.0, 62.0, 0.0, 3, 5, 1),
-- Scarlet Monastery Hellgate (Map 189, Graveyard)
(189, 'Scarlet Monastery Hellgate', 3976, 1688.0, 1053.0, 18.0, 0.0, 1688.0, 1053.0, 18.0, 0.0, 3, 5, 1);

-- Insert example portals (in Westfall for Deadmines, Tirisfal for SM)
INSERT INTO `hellgates_portals` (`hellgate_id`, `map`, `x`, `y`, `z`, `o`, `go_entry`) VALUES
(1, 0, -11208.0, 1686.0, 24.0, 0.0, 177193), -- Deadmines portal in Westfall
(2, 0, 2872.0, -820.0, 160.0, 0.0, 177193);  -- SM portal in Tirisfal

