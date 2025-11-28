-- ==================================================
-- Project Mortal Warcraft: World Boss System
-- Module: mod-mortal-core
-- Feature: World bosses and dynamic events
-- ==================================================

-- World Boss Spawns Table
-- Tracks world boss spawns and respawn timers
CREATE TABLE IF NOT EXISTS `world_boss_spawns` (
  `boss_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `creature_entry` INT UNSIGNED NOT NULL COMMENT 'Creature template entry',
  `boss_name` VARCHAR(64) NOT NULL COMMENT 'Boss name',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone where boss spawns',
  `location_x` FLOAT NOT NULL,
  `location_y` FLOAT NOT NULL,
  `location_z` FLOAT NOT NULL,
  `spawn_timer` INT UNSIGNED NOT NULL DEFAULT 86400 COMMENT 'Respawn timer in seconds (24 hours default)',
  `last_killed` TIMESTAMP NULL DEFAULT NULL,
  `next_spawn` TIMESTAMP NULL DEFAULT NULL,
  `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Dead, 1=Alive',
  `kill_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total times killed',
  PRIMARY KEY (`boss_id`),
  INDEX `idx_zone` (`zone_id`),
  INDEX `idx_next_spawn` (`next_spawn`),
  INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='World boss spawn tracking';

-- World Boss Loot Table
-- Custom loot table for world bosses (blueprints, unique items)
CREATE TABLE IF NOT EXISTS `world_boss_loot` (
  `boss_id` INT UNSIGNED NOT NULL COMMENT 'World boss ID',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item template entry',
  `drop_chance` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Drop chance percentage',
  `min_count` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `max_count` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `loot_type` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Item, 2=Blueprint, 3=Material, 4=Fragment',
  PRIMARY KEY (`boss_id`, `item_entry`),
  INDEX `idx_loot_type` (`loot_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='World boss loot tables';

-- Dynamic Events Table
-- Tracks dynamic world events
CREATE TABLE IF NOT EXISTS `dynamic_events` (
  `event_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Resource Spawn, 2=Invasion, 3=Weather, 4=Special',
  `event_name` VARCHAR(64) NOT NULL,
  `zone_id` SMALLINT UNSIGNED NOT NULL,
  `location_x` FLOAT NULL DEFAULT NULL COMMENT 'NULL = zone-wide event',
  `location_y` FLOAT NULL DEFAULT NULL,
  `location_z` FLOAT NULL DEFAULT NULL,
  `start_time` TIMESTAMP NOT NULL DEFAULT 0,
  `end_time` TIMESTAMP NULL DEFAULT NULL,
  `duration` INT UNSIGNED NOT NULL DEFAULT 3600 COMMENT 'Event duration in seconds',
  `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `reward_data` TEXT NULL DEFAULT NULL COMMENT 'JSON data for event rewards',
  PRIMARY KEY (`event_id`),
  INDEX `idx_zone` (`zone_id`),
  INDEX `idx_active` (`is_active`),
  INDEX `idx_type` (`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Dynamic world events';

