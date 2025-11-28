-- ==================================================
-- Project Mortal Warcraft
-- Feature: Zone Reworks (Case Studies)
-- Description: Special mechanics for specific zones
-- ==================================================

-- Zone Rework Configuration Table
CREATE TABLE IF NOT EXISTS `zone_reworks_config` (
    `zone_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `zone_name` VARCHAR(100) NOT NULL,
    `zone_type` VARCHAR(50) NOT NULL COMMENT 'Red, Yellow, Deep Red',
    `special_mechanics` TEXT COMMENT 'JSON or description of special mechanics',
    `stronghold_location` VARCHAR(255) DEFAULT NULL COMMENT 'Stronghold landmark name',
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Zone Reworks
INSERT INTO `zone_reworks_config` (`zone_id`, `zone_name`, `zone_type`, `special_mechanics`, `stronghold_location`, `enabled`) VALUES
(33, 'Stranglethorn Vale', 'Red', 'Arena is Betting Hub. ZG Exterior is a Stronghold. Bloodwood Resource.', 'ZG Exterior', 1),
(17, 'The Barrens', 'Yellow', 'Caravan routes. Northwatch Hold is a Stronghold.', 'Northwatch Hold', 1),
(139, 'Eastern Plaguelands', 'Deep Red', 'No Chat. Midnight Horde main spawn. Tyr Hand is a Stronghold (Purification Altar).', 'Tyr Hand', 1),
(47, 'Hinterlands', 'Open Raid', 'Jintha Alor is a Public Delve. Boss drops Blueprint Originals.', 'Jintha Alor', 1)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `zone_type` = VALUES(`zone_type`),
    `special_mechanics` = VALUES(`special_mechanics`),
    `stronghold_location` = VALUES(`stronghold_location`),
    `enabled` = VALUES(`enabled`);

-- Caravan Routes (The Barrens)
CREATE TABLE IF NOT EXISTS `caravan_routes` (
    `route_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `route_name` VARCHAR(100) NOT NULL,
    `start_zone` INT UNSIGNED NOT NULL,
    `start_x` FLOAT NOT NULL,
    `start_y` FLOAT NOT NULL,
    `start_z` FLOAT NOT NULL,
    `end_zone` INT UNSIGNED NOT NULL,
    `end_x` FLOAT NOT NULL,
    `end_y` FLOAT NOT NULL,
    `end_z` FLOAT NOT NULL,
    `reward_gold` INT UNSIGNED NOT NULL DEFAULT 100,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Caravan Routes (The Barrens)
INSERT INTO `caravan_routes` (`route_name`, `start_zone`, `start_x`, `start_y`, `start_z`, `end_zone`, `end_x`, `end_y`, `end_z`, `reward_gold`, `enabled`) VALUES
('Crossroads to Ratchet', 17, -452.84, -2650.76, 95.52, 17, -956.664, -3754.63, 5.34739, 150, 1),
('Crossroads to Camp Taurajo', 17, -452.84, -2650.76, 95.52, 17, -2363.54, -1913.75, 95.78, 100, 1)

ON DUPLICATE KEY UPDATE
    `route_name` = VALUES(`route_name`),
    `reward_gold` = VALUES(`reward_gold`),
    `enabled` = VALUES(`enabled`);

-- Bloodwood Resource Nodes (Stranglethorn Vale)
CREATE TABLE IF NOT EXISTS `bloodwood_nodes` (
    `node_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `node_type` VARCHAR(50) NOT NULL COMMENT 'Bloodwood, Rare Herb',
    `spawn_map` INT UNSIGNED NOT NULL DEFAULT 0,
    `spawn_zone` INT UNSIGNED NOT NULL DEFAULT 33,
    `spawn_x` FLOAT NOT NULL,
    `spawn_y` FLOAT NOT NULL,
    `spawn_z` FLOAT NOT NULL,
    `spawn_o` FLOAT NOT NULL,
    `respawn_time` INT UNSIGNED NOT NULL DEFAULT 600 COMMENT 'Respawn time in seconds',
    `tier_level` TINYINT UNSIGNED NOT NULL DEFAULT 4,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_zone` (`spawn_zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Public Delve Bosses (Hinterlands - Jintha'Alor)
CREATE TABLE IF NOT EXISTS `public_delve_bosses` (
    `boss_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `boss_entry` INT UNSIGNED NOT NULL COMMENT 'Creature entry ID',
    `boss_name` VARCHAR(100) NOT NULL,
    `delve_name` VARCHAR(100) NOT NULL COMMENT 'Public Delve name',
    `zone_id` INT UNSIGNED NOT NULL,
    `blueprint_drop_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT '10% chance for Blueprint Original',
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Jintha'Alor Bosses (Hinterlands)
-- Note: Using placeholder boss entries - update with actual Jintha'Alor boss entries
INSERT INTO `public_delve_bosses` (`boss_entry`, `boss_name`, `delve_name`, `zone_id`, `blueprint_drop_chance`, `enabled`) VALUES
(2640, 'Vile Priestess Hexx', 'Jintha Alor', 47, 0.15, 1),
(2641, 'Vile Priestess Hexx', 'Jintha Alor', 47, 0.15, 1),
(2642, 'Vile Priestess Hexx', 'Jintha Alor', 47, 0.15, 1),
(2643, 'Vile Priestess Hexx', 'Jintha Alor', 47, 0.15, 1),
(2644, 'Vile Priestess Hexx', 'Jintha Alor', 47, 0.15, 1),
(2645, 'Vile Priestess Hexx', 'Jintha Alor', 47, 0.15, 1);

