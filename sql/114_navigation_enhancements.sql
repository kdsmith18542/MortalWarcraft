-- ==================================================
-- Project Mortal Warcraft
-- Feature: Navigation & Map Overlays Enhancements
-- Description: Enhanced navigation system with waypoints and map overlays
-- Based on: docs/specs/39-navigation-and-map-overlays.md (conceptual)
-- ==================================================

-- Player Waypoints
CREATE TABLE IF NOT EXISTS `mortal_player_waypoints` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `waypoint_name` VARCHAR(64) NOT NULL,
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `position_x` FLOAT NOT NULL,
    `position_y` FLOAT NOT NULL,
    `position_z` FLOAT NOT NULL,
    `icon_type` VARCHAR(32) NOT NULL DEFAULT 'DEFAULT' COMMENT 'DEFAULT, RESOURCE, NPC, QUEST, DANGER',
    `color` INT UNSIGNED NOT NULL DEFAULT 0xFFFFFF COMMENT 'RGB color',
    `is_shared` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if shared with party/guild',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_guid` (`guid`),
    INDEX `idx_map_zone` (`map_id`, `zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player waypoints';

-- Navigation Routes
CREATE TABLE IF NOT EXISTS `mortal_navigation_routes` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `route_name` VARCHAR(128) NOT NULL,
    `start_map_id` INT UNSIGNED NOT NULL,
    `start_zone_id` INT UNSIGNED NOT NULL,
    `start_x` FLOAT NOT NULL,
    `start_y` FLOAT NOT NULL,
    `start_z` FLOAT NOT NULL,
    `end_map_id` INT UNSIGNED NOT NULL,
    `end_zone_id` INT UNSIGNED NOT NULL,
    `end_x` FLOAT NOT NULL,
    `end_y` FLOAT NOT NULL,
    `end_z` FLOAT NOT NULL,
    `waypoints_json` JSON NULL COMMENT 'Intermediate waypoints',
    `risk_tier` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Green, 2=Yellow, 3=Red',
    `estimated_time_minutes` INT UNSIGNED NOT NULL DEFAULT 0,
    `is_public` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if shared publicly',
    `created_by_guid` INT UNSIGNED NULL,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_start` (`start_map_id`, `start_zone_id`),
    INDEX `idx_end` (`end_map_id`, `end_zone_id`),
    INDEX `idx_public` (`is_public`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Navigation routes between locations';

-- Map Overlay Data
CREATE TABLE IF NOT EXISTS `mortal_map_overlays` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `overlay_type` VARCHAR(32) NOT NULL COMMENT 'ZONE_RISK, RESOURCE_DENSITY, NPC_SPAWN, EVENT',
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `polygon_json` JSON NULL COMMENT 'Polygon coordinates for overlay area',
    `color` INT UNSIGNED NOT NULL DEFAULT 0xFFFFFF,
    `opacity` FLOAT NOT NULL DEFAULT 0.5 COMMENT '0.0-1.0',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_type` (`overlay_type`),
    INDEX `idx_map_zone` (`map_id`, `zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Map overlay definitions';

-- Summary
SELECT 
    'Navigation Enhancements Created' as summary,
    'Waypoints, routes, and overlays ready' as status;

