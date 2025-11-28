-- ==================================================
-- Project Mortal Warcraft
-- Feature: Warfronts (Battleground Overhaul)
-- Description: Physical entry portals, full loot, guild rewards
-- ==================================================

-- Warfront Configuration
CREATE TABLE IF NOT EXISTS `warfronts_config` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `battleground_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Battleground ID (1=AB, 2=WSG, etc.)',
  `name` VARCHAR(100) NOT NULL COMMENT 'Warfront name',
  `entry_portal_map` SMALLINT UNSIGNED NOT NULL COMMENT 'World map where portal exists',
  `entry_portal_x` FLOAT NOT NULL COMMENT 'Portal X coordinate',
  `entry_portal_y` FLOAT NOT NULL COMMENT 'Portal Y coordinate',
  `entry_portal_z` FLOAT NOT NULL COMMENT 'Portal Z coordinate',
  `entry_portal_o` FLOAT NOT NULL COMMENT 'Portal orientation',
  `go_entry` INT UNSIGNED NOT NULL DEFAULT 177193 COMMENT 'GameObject entry (Portal)',
  `resource_wood` INT UNSIGNED NOT NULL DEFAULT 1000 COMMENT 'Wood reward for controlling guild',
  `resource_iron` INT UNSIGNED NOT NULL DEFAULT 1000 COMMENT 'Iron reward for controlling guild',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is this warfront enabled?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_bg` (`battleground_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Warfront battleground configurations';

-- Active Warfront Control
CREATE TABLE IF NOT EXISTS `warfronts_control` (
  `warfront_id` INT UNSIGNED NOT NULL COMMENT 'Reference to warfronts_config.id',
  `controlling_guild` INT UNSIGNED NULL COMMENT 'Guild ID controlling this warfront',
  `last_control_change` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of last control change',
  `resource_shipment_due` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when next shipment is due',
  PRIMARY KEY (`warfront_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Warfront control tracking';

-- Warfront Entry Log
CREATE TABLE IF NOT EXISTS `warfronts_entries` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `warfront_id` INT UNSIGNED NOT NULL COMMENT 'Warfront ID',
  `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `guild_id` INT UNSIGNED NULL COMMENT 'Guild ID (if in guild)',
  `entered_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_warfront` (`warfront_id`),
  KEY `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Warfront entry tracking';

-- Insert example Warfront configurations
INSERT INTO `warfronts_config` (
    `battleground_id`, `name`, `entry_portal_map`, `entry_portal_x`, `entry_portal_y`, `entry_portal_z`, `entry_portal_o`,
    `resource_wood`, `resource_iron`, `enabled`
) VALUES
-- Arathi Basin (BG ID 1)
(1, 'Arathi Basin Warfront', 0, -1215.0, -2530.0, 21.0, 0.0, 1000, 1000, 1),
-- Warsong Gulch (BG ID 2)
(2, 'Warsong Gulch Warfront', 1, 1035.0, -2106.0, 122.0, 0.0, 800, 800, 1),
-- Alterac Valley (BG ID 3)
(3, 'Alterac Valley Warfront', 0, 634.0, -294.0, 30.0, 0.0, 2000, 2000, 1);

-- Initialize control tracking
INSERT INTO `warfronts_control` (`warfront_id`, `controlling_guild`, `last_control_change`, `resource_shipment_due`) VALUES
(1, NULL, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + 3600), -- AB: No control, shipment in 1 hour
(2, NULL, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + 3600), -- WSG: No control, shipment in 1 hour
(3, NULL, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + 3600); -- AV: No control, shipment in 1 hour

