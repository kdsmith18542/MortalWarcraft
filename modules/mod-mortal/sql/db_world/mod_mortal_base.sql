-- ============================================================================
-- Mortal Warcraft Overhaul - World Database (Module Loader)
-- Part of the mod-mortal AzerothCore module
-- Source: sql/mortal/00_base/02_world_tables.sql
-- ============================================================================

-- Zone Risk Flags
CREATE TABLE IF NOT EXISTS `zones_risk_flags` (
    `zone_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `risk_tier` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `description` VARCHAR(128) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `zones_risk_flags` (`zone_id`, `risk_tier`, `description`) VALUES
(1,    0, 'Kalimdor - Safe'),
(3,    0, 'Eastern Kingdoms - Safe'),
(33,   2, 'Stranglethorn Vale - Full Loot'),
(1519, 1, 'STV Arena - Mid Risk'),
(4,    0, 'Durotar - Safe'),
(8,    0, 'Tirisfal Glades - Safe'),
(10,   0, 'Dun Morogh - Safe'),
(12,   0, 'Elwynn Forest - Safe'),
(38,   1, 'Westfall - Mid Risk'),
(41,   1, 'Redridge - Mid Risk'),
(45,   2, 'Arathi Highlands - Full Loot'),
(47,   2, 'Hillsbrad Foothills - Full Loot'),
(85,   1, 'Duskwood - Mid Risk'),
(139,  2, 'Tanaris - Full Loot'),
(490,  2, 'Alterac Valley - Full Loot'),
(1377, 2, 'Silithus - Full Loot'),
(1977, 2, 'Zul\'Gurub - Full Loot');

-- Workstations
CREATE TABLE IF NOT EXISTS `mortal_workstations` (
    `gameobject_entry` INT UNSIGNED NOT NULL PRIMARY KEY,
    `workstation_type` TINYINT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `mortal_workstations` (`gameobject_entry`, `workstation_type`) VALUES
(100, 1), (101, 2), (102, 3), (103, 4), (104, 5);

-- Task Board Templates
CREATE TABLE IF NOT EXISTS `mortal_task_board_templates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `type` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `target_entry` INT UNSIGNED NOT NULL DEFAULT 0,
    `target_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0,
    `reward_item_id` MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    `reward_item_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `min_level` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `max_level` TINYINT UNSIGNED NOT NULL DEFAULT 25,
    `cooldown_ms` INT UNSIGNED NOT NULL DEFAULT 86400000
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Ecosystem Spawn Weights
CREATE TABLE IF NOT EXISTS `mortal_ecosystem_spawn_weights` (
    `zone_id` INT UNSIGNED NOT NULL,
    `creature_entry` INT UNSIGNED NOT NULL,
    `base_weight` FLOAT NOT NULL DEFAULT 1.0,
    `current_weight` FLOAT NOT NULL DEFAULT 1.0,
    `min_weight` FLOAT NOT NULL DEFAULT 0.1,
    `max_weight` FLOAT NOT NULL DEFAULT 3.0,
    `last_adjustment` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`zone_id`, `creature_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Contract Templates
CREATE TABLE IF NOT EXISTS `mortal_contract_templates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `type` TINYINT UNSIGNED NOT NULL,
    `target_entry` INT UNSIGNED NOT NULL DEFAULT 0,
    `target_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `duration` INT UNSIGNED NOT NULL DEFAULT 3600,
    `base_reward` INT UNSIGNED NOT NULL DEFAULT 0,
    `penalty` INT UNSIGNED NOT NULL DEFAULT 0,
    `min_level` TINYINT UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Caravan Routes
CREATE TABLE IF NOT EXISTS `mortal_caravan_routes` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `start_zone` INT UNSIGNED NOT NULL,
    `end_zone` INT UNSIGNED NOT NULL,
    `duration` INT UNSIGNED NOT NULL DEFAULT 300,
    `reward_gold` INT UNSIGNED NOT NULL DEFAULT 50,
    `risk_tier` TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `mortal_caravan_routes` (`id`, `start_zone`, `end_zone`, `duration`, `reward_gold`, `risk_tier`) VALUES
(1, 1, 3, 300, 50, 0),
(2, 3, 1, 300, 50, 1),
(3, 1519, 3, 600, 100, 2);

-- Stronghold Locations
CREATE TABLE IF NOT EXISTS `mortal_stronghold_locations` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `zone_id` INT UNSIGNED NOT NULL,
    `name` VARCHAR(64) NOT NULL,
    `pos_x` FLOAT NOT NULL,
    `pos_y` FLOAT NOT NULL,
    `pos_z` FLOAT NOT NULL,
    `map_id` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `mortal_stronghold_locations` (`id`, `zone_id`, `name`, `pos_x`, `pos_y`, `pos_z`, `map_id`) VALUES
(1, 33, 'STV Stronghold', 0, 0, 0, 0),
(2, 1, 'Kalimdor Keep', 0, 0, 0, 1);

-- Mortal Titles
CREATE TABLE IF NOT EXISTS `mortal_titles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title` VARCHAR(64) NOT NULL,
    `condition_type` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `condition_value` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `mortal_titles` (`id`, `title`, `condition_type`, `condition_value`) VALUES
(1, 'the Brave', 0, 100),
(2, 'the Ruthless', 1, 1000),
(3, 'the Merciless', 1, 5000),
(4, 'Master Crafter', 2, 100),
(5, 'the Explorer', 3, 50);

-- Regional Bank NPCs
CREATE TABLE IF NOT EXISTS `mortal_regional_bank_npcs` (
    `entry` INT UNSIGNED NOT NULL PRIMARY KEY,
    `zone_id` INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

REPLACE INTO `mortal_regional_bank_npcs` (`entry`, `zone_id`) VALUES
(2500, 1), (2501, 3), (2502, 1519);
