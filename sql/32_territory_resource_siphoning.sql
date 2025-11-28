-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Territory Resource Siphoning
-- Description: Tracks hourly resource generation for guild-controlled territories
-- ==================================================

-- WARNING: This script creates new database tables.
-- Make sure you have a database backup before running this!

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. TERRITORY RESOURCE GENERATION TABLE
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `territory_resource_generation` (
    `guild_id` INT UNSIGNED NOT NULL,
    `zone_id` SMALLINT UNSIGNED NOT NULL,
    `last_generation` TIMESTAMP NOT NULL DEFAULT 0,
    `total_gold_generated` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total gold generated over time',
    `total_materials_generated` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total material units generated',
    PRIMARY KEY (`guild_id`, `zone_id`),
    KEY `idx_last_gen` (`last_generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------
-- 2. TERRITORY SERVICES TABLE
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `territory_services` (
    `guild_id` INT UNSIGNED NOT NULL,
    `zone_id` SMALLINT UNSIGNED NOT NULL,
    `service_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Repair Bot, 2=Ammo Vendor, 3=Guild Bank Access, 4=All',
    `service_level` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Upgrade level (1-5)',
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `upgraded_at` TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (`guild_id`, `zone_id`, `service_type`),
    KEY `idx_guild_zone` (`guild_id`, `zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;

-- Report results
SELECT 'Territory Resource Siphoning tables created successfully.' AS result;
SELECT 'Tables: territory_resource_generation, territory_services' AS result;

