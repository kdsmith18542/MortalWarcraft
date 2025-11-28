-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Territory Control Points (Stronghold Sovereignty)
-- Description: Defines specific control points at landmarks (Jintha'Alor, Stromgarde, Tyr's Hand)
-- ==================================================

-- WARNING: This script creates control point locations.
-- Make sure you have a database backup before running this!

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. ENHANCE TERRITORY CONTROL POINTS TABLE
-- ------------------------------------------------------------------

-- Add vulnerability window and reinforcement fields if they don't exist
ALTER TABLE `territory_control_points` 
ADD COLUMN `vulnerability_start` TIME NULL DEFAULT NULL COMMENT '4-hour vulnerability window start time',
ADD COLUMN IF NOT EXISTS `vulnerability_end` TIME NULL DEFAULT NULL COMMENT '4-hour vulnerability window end time',
ADD COLUMN IF NOT EXISTS `reinforcement_buff` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Spell ID for defender stat buff';

-- ------------------------------------------------------------------
-- 2. INSERT CONTROL POINT LOCATIONS
-- ------------------------------------------------------------------

-- Jintha'Alor (The Hinterlands - Zone 47)
-- Area ID: ~47 (The Hinterlands)
-- Coordinates: Approximate location of Jintha'Alor ruins
INSERT IGNORE INTO `territory_control_points` 
    (`zone_id`, `point_name`, `location_x`, `location_y`, `location_z`, `controlling_guild`, `vulnerability_start`, `vulnerability_end`, `reinforcement_buff`) 
VALUES
    (47, 'Jintha\'Alor Ruins', -680.0, -4040.0, 30.0, NULL, NULL, NULL, 60001);

-- Stromgarde Keep (Arathi Highlands - Zone 45)
-- Area ID: ~45 (Arathi Highlands)
-- Coordinates: Stromgarde Keep location
INSERT IGNORE INTO `territory_control_points` 
    (`zone_id`, `point_name`, `location_x`, `location_y`, `location_z`, `controlling_guild`, `vulnerability_start`, `vulnerability_end`, `reinforcement_buff`) 
VALUES
    (45, 'Stromgarde Keep', -1581.0, -1804.0, 67.0, NULL, NULL, NULL, 60001);

-- Tyr's Hand (Eastern Plaguelands - Zone 139)
-- Area ID: ~139 (Eastern Plaguelands)
-- Coordinates: Tyr's Hand location
INSERT IGNORE INTO `territory_control_points` 
    (`zone_id`, `point_name`, `location_x`, `location_y`, `location_z`, `controlling_guild`, `vulnerability_start`, `vulnerability_end`, `reinforcement_buff`) 
VALUES
    (139, 'Tyr\'s Hand', 2300.0, -5300.0, 80.0, NULL, NULL, NULL, 60001);

-- Additional Control Points (Optional - can be expanded)
-- Hearthglen (Western Plaguelands - Zone 28)
INSERT IGNORE INTO `territory_control_points` 
    (`zone_id`, `point_name`, `location_x`, `location_y`, `location_z`, `controlling_guild`, `vulnerability_start`, `vulnerability_end`, `reinforcement_buff`) 
VALUES
    (28, 'Hearthglen', 2920.0, -1420.0, 140.0, NULL, NULL, NULL, 60001);

-- Kargath (Badlands - Zone 3)
INSERT IGNORE INTO `territory_control_points` 
    (`zone_id`, `point_name`, `location_x`, `location_y`, `location_z`, `controlling_guild`, `vulnerability_start`, `vulnerability_end`, `reinforcement_buff`) 
VALUES
    (3, 'Kargath Outpost', -6656.0, -2156.0, 264.0, NULL, NULL, NULL, 60001);

COMMIT;

-- Report results
SELECT 'Territory Control Points created successfully.' AS result;
SELECT CONCAT('Created ', COUNT(*), ' control point locations') AS summary
FROM `territory_control_points`;

