-- ==================================================
-- Project Mortal Warcraft: Guild Territory System
-- Module: mod-mortal-core
-- Feature: Guild territory control and warfare
-- ==================================================

-- Guild Territories Table
-- Tracks which zones/areas are controlled by which guilds
CREATE TABLE IF NOT EXISTS `guild_territories` (
  `guild_id` INT UNSIGNED NOT NULL COMMENT 'Guild ID',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID being controlled',
  `control_points` SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Control points (0-100)',
  `claimed_at` TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'When territory was claimed',
  `last_contested` TIMESTAMP NULL DEFAULT NULL COMMENT 'Last time territory was contested',
  `defense_level` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Defense upgrades (1-5)',
  PRIMARY KEY (`guild_id`, `zone_id`),
  INDEX `idx_zone` (`zone_id`),
  INDEX `idx_control_points` (`control_points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild territory control system';

-- Guild Housing Table
-- Tracks guild structures in claimed territories
CREATE TABLE IF NOT EXISTS `guild_housing` (
  `guild_id` INT UNSIGNED NOT NULL COMMENT 'Guild ID',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone where structure is located',
  `gameobject_guid` INT UNSIGNED NOT NULL COMMENT 'GameObject GUID of the structure',
  `building_type` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Castle, 2=Fortress, 3=Outpost, 4=Barracks',
  `location_x` FLOAT NOT NULL COMMENT 'X coordinate',
  `location_y` FLOAT NOT NULL COMMENT 'Y coordinate',
  `location_z` FLOAT NOT NULL COMMENT 'Z coordinate',
  `upgrade_level` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Upgrade level (1-10)',
  `built_at` TIMESTAMP NOT NULL DEFAULT 0,
  PRIMARY KEY (`guild_id`, `gameobject_guid`),
  INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild structures in claimed territories';

-- Guild Warfare Table
-- Tracks active guild wars and conflicts
CREATE TABLE IF NOT EXISTS `guild_warfare` (
  `war_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attacker_guild` INT UNSIGNED NOT NULL COMMENT 'Attacking guild ID',
  `defender_guild` INT UNSIGNED NOT NULL COMMENT 'Defending guild ID',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Contested zone',
  `status` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Active, 2=Attacker Won, 3=Defender Won, 4=Cancelled',
  `start_time` TIMESTAMP NOT NULL DEFAULT 0,
  `end_time` TIMESTAMP NULL DEFAULT NULL,
  `attacker_points` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `defender_points` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`war_id`),
  INDEX `idx_attacker` (`attacker_guild`),
  INDEX `idx_defender` (`defender_guild`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild warfare and conflicts';

-- Territory Control Points Table
-- Tracks control points within zones that determine ownership
CREATE TABLE IF NOT EXISTS `territory_control_points` (
  `point_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `point_name` VARCHAR(64) NOT NULL COMMENT 'Control point name',
  `location_x` FLOAT NOT NULL,
  `location_y` FLOAT NOT NULL,
  `location_z` FLOAT NOT NULL,
  `controlling_guild` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Guild controlling this point',
  `captured_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`point_id`),
  INDEX `idx_zone` (`zone_id`),
  INDEX `idx_guild` (`controlling_guild`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Control points within zones for territory claiming';

