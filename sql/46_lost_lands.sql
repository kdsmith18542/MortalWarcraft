-- ==================================================
-- Project Mortal Warcraft
-- Feature: The Lost Lands (Hidden Maps)
-- Description: Repurposed maps for special content
-- ==================================================

-- Lost Lands Configuration Table
CREATE TABLE IF NOT EXISTS `lost_lands_config` (
    `map_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `map_name` VARCHAR(100) NOT NULL,
    `land_type` VARCHAR(50) NOT NULL COMMENT 'Gathering, PvP, Admin',
    `access_requirement` VARCHAR(255) DEFAULT NULL COMMENT 'Skill requirement, item, etc.',
    `description` TEXT,
    `spawn_x` FLOAT DEFAULT NULL,
    `spawn_y` FLOAT DEFAULT NULL,
    `spawn_z` FLOAT DEFAULT NULL,
    `spawn_o` FLOAT DEFAULT NULL,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Lost Lands
INSERT INTO `lost_lands_config` (`map_id`, `map_name`, `land_type`, `access_requirement`, `description`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_o`, `enabled`) VALUES
(169, 'Emerald Dream', 'Gathering', 'Gathering Skill > 100', 'High-tier Gathering Zone (Dreamfoil/Dreamscale). Tier 5 resources only.', 0.0, 0.0, 0.0, 0.0, 1),
(37, 'Azshara Crater', 'PvP', 'Guild Membership', 'Massive 40v40 Guild War Zone (Permanent King of the Hill). Full Loot enabled.', 0.0, 0.0, 0.0, 0.0, 1),
(451, 'Development Land', 'Admin', 'GM Access Only', 'Admin Event Zone for building custom dungeons. GM-only access.', 0.0, 0.0, 0.0, 0.0, 1)

ON DUPLICATE KEY UPDATE
    `map_name` = VALUES(`map_name`),
    `land_type` = VALUES(`land_type`),
    `access_requirement` = VALUES(`access_requirement`),
    `description` = VALUES(`description`),
    `enabled` = VALUES(`enabled`);

-- Azshara Crater Control Tracking
CREATE TABLE IF NOT EXISTS `azshara_crater_control` (
    `guild_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `guild_name` VARCHAR(100) NOT NULL,
    `capture_time` INT UNSIGNED NOT NULL,
    `control_duration` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Seconds of control',
    `last_update` INT UNSIGNED NOT NULL,
    INDEX `idx_capture` (`capture_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Emerald Dream Resource Nodes
CREATE TABLE IF NOT EXISTS `emerald_dream_nodes` (
    `node_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `node_type` VARCHAR(50) NOT NULL COMMENT 'Dreamfoil, Dreamscale, etc.',
    `spawn_map` INT UNSIGNED NOT NULL DEFAULT 169,
    `spawn_x` FLOAT NOT NULL,
    `spawn_y` FLOAT NOT NULL,
    `spawn_z` FLOAT NOT NULL,
    `spawn_o` FLOAT NOT NULL,
    `respawn_time` INT UNSIGNED NOT NULL DEFAULT 300 COMMENT 'Respawn time in seconds',
    `tier_level` TINYINT UNSIGNED NOT NULL DEFAULT 5,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_type` (`node_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

