-- ==================================================
-- Project Mortal Warcraft: Resource Node Control
-- Module: mod-mortal-core
-- Feature: Contested resource nodes with ownership
-- ==================================================

-- Resource Nodes Table
-- Tracks resource nodes and their ownership
CREATE TABLE IF NOT EXISTS `resource_nodes` (
  `node_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `node_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Mining, 2=Herb, 3=Wood, 4=Special',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone where node is located',
  `location_x` FLOAT NOT NULL,
  `location_y` FLOAT NOT NULL,
  `location_z` FLOAT NOT NULL,
  `resource_tier` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Resource tier (1-5)',
  `owning_guild` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Guild that owns this node',
  `owning_player` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Player that owns this node (if not guild)',
  `current_resources` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Current resource amount (0-100)',
  `max_resources` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Maximum resource amount',
  `depletion_rate` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Resources depleted per hour',
  `regeneration_rate` FLOAT NOT NULL DEFAULT 0.5 COMMENT 'Resources regenerated per hour',
  `last_harvested` TIMESTAMP NULL DEFAULT NULL,
  `last_updated` TIMESTAMP NOT NULL DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`node_id`),
  INDEX `idx_zone` (`zone_id`),
  INDEX `idx_guild` (`owning_guild`),
  INDEX `idx_player` (`owning_player`),
  INDEX `idx_type_tier` (`node_type`, `resource_tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Resource nodes with ownership and depletion mechanics';

-- Resource Node Control Points
-- Control points around nodes that determine ownership
CREATE TABLE IF NOT EXISTS `resource_node_control` (
  `node_id` INT UNSIGNED NOT NULL COMMENT 'Resource node ID',
  `control_point_id` TINYINT UNSIGNED NOT NULL COMMENT 'Control point number (1-3)',
  `location_x` FLOAT NOT NULL,
  `location_y` FLOAT NOT NULL,
  `location_z` FLOAT NOT NULL,
  `controlling_guild` INT UNSIGNED NULL DEFAULT NULL,
  `captured_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`node_id`, `control_point_id`),
  INDEX `idx_guild` (`controlling_guild`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Control points around resource nodes';

