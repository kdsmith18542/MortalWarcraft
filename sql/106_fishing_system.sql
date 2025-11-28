-- ==================================================
-- Project Mortal Warcraft
-- Feature: Fishing System
-- Description: Fishing skill lines and loot tables
-- Based on: docs/specs/50-lifeskills-fishing-and-first-aid.md
-- ==================================================

-- Fishing Loot Tables
-- Defines fish and loot per zone/water type/risk tier
CREATE TABLE IF NOT EXISTS `mortal_fishing_loot` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = all maps',
    `zone_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = all zones',
    `water_type` VARCHAR(16) NOT NULL COMMENT 'coastal, inland, deep, planar',
    `risk_tier` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Green, 2=Yellow, 3=Red',
    `item_entry` INT UNSIGNED NOT NULL,
    `min_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `max_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `base_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Base drop chance (0.0-1.0)',
    `skill_req` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum fishing skill required',
    `lore_req` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum material lore skill required',
    `junk_chance` FLOAT NOT NULL DEFAULT 0.3 COMMENT 'Chance this is junk (0.0-1.0)',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Additional flags',
    `notes` VARCHAR(255) NULL,
    INDEX `idx_map_zone` (`map_id`, `zone_id`),
    INDEX `idx_water_risk` (`water_type`, `risk_tier`),
    INDEX `idx_item` (`item_entry`),
    INDEX `idx_skill_req` (`skill_req`, `lore_req`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Fishing loot tables';

-- Fish State Tracking (Perishable Goods)
CREATE TABLE IF NOT EXISTS `mortal_fish_state` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_guid` BIGINT UNSIGNED NOT NULL COMMENT 'item_instance.guid',
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `state` VARCHAR(16) NOT NULL DEFAULT 'FRESH' COMMENT 'FRESH, EDIBLE, STALE, ROTTEN',
    `caught_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `expires_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `processed` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if processed (cooked/salted)',
    INDEX `idx_item_guid` (`item_guid`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_state` (`state`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Fish perishable state tracking';

-- Fishing Skill Lines (stored in character_mortal_skills with IDs)
-- Skill IDs (to be defined in skill system):
-- 3001: Fishing: Coastal
-- 3002: Fishing: Inland
-- 3003: Fishing: Deep Sea
-- 3004: Fishing: Planar
-- 3005: Lore: Freshwater Fish
-- 3006: Lore: Saltwater Fish
-- 3007: Lore: Abyssal/Planar Fish

-- Seed Data: Basic Fishing Loot (Green Zones - Coastal)
INSERT INTO `mortal_fishing_loot` (`map_id`, `zone_id`, `water_type`, `risk_tier`, `item_entry`, `min_count`, `max_count`, `base_chance`, `skill_req`, `lore_req`, `junk_chance`, `notes`) VALUES
-- Basic food fish (common) - no skill requirements
(0, 0, 'coastal', 1, 6291, 1, 2, 0.4, 0, 0, 0.0, 'Raw Brilliant Smallfish - Common'),
(0, 0, 'coastal', 1, 6299, 1, 2, 0.3, 0, 0, 0.0, 'Sickly Fish - Common'),
(0, 0, 'coastal', 1, 6308, 1, 1, 0.2, 10, 0, 0.0, 'Raw Bristle Whisker Catfish - Uncommon'),
-- Junk items
(0, 0, 'coastal', 1, 6256, 1, 1, 0.3, 0, 0, 1.0, 'Fishing Pole - Junk'),
(0, 0, 'coastal', 1, 6257, 1, 1, 0.2, 0, 0, 1.0, 'Rotten Fish - Junk')
ON DUPLICATE KEY UPDATE `base_chance` = VALUES(`base_chance`);

-- Yellow Zones - Better fish (requires some skill)
INSERT INTO `mortal_fishing_loot` (`map_id`, `zone_id`, `water_type`, `risk_tier`, `item_entry`, `min_count`, `max_count`, `base_chance`, `skill_req`, `lore_req`, `junk_chance`, `notes`) VALUES
(0, 0, 'coastal', 2, 6308, 1, 2, 0.3, 10, 0, 0.0, 'Raw Bristle Whisker Catfish - Better chance'),
(0, 0, 'coastal', 2, 6361, 1, 1, 0.15, 25, 5, 0.0, 'Raw Rainbow Fin Albacore - Uncommon'),
(0, 0, 'coastal', 2, 6362, 1, 1, 0.1, 50, 10, 0.0, 'Raw Rockscale Cod - Rare')
ON DUPLICATE KEY UPDATE `base_chance` = VALUES(`base_chance`);

-- Red Zones - Best fish (requires higher skill and lore)
INSERT INTO `mortal_fishing_loot` (`map_id`, `zone_id`, `water_type`, `risk_tier`, `item_entry`, `min_count`, `max_count`, `base_chance`, `skill_req`, `lore_req`, `junk_chance`, `notes`) VALUES
(0, 0, 'coastal', 3, 6362, 1, 2, 0.2, 50, 10, 0.0, 'Raw Rockscale Cod - Better chance'),
(0, 0, 'coastal', 3, 13754, 1, 1, 0.15, 100, 25, 0.0, 'Raw Glossy Mightfish - Rare'),
(0, 0, 'deep', 3, 13756, 1, 1, 0.1, 150, 50, 0.0, 'Raw Summer Bass - Very Rare'),
(0, 0, 'deep', 3, 13758, 1, 1, 0.05, 200, 75, 0.0, 'Raw Redgill - Epic')
ON DUPLICATE KEY UPDATE `base_chance` = VALUES(`base_chance`);

-- Summary
SELECT 
    'Fishing System Created' as summary,
    COUNT(DISTINCT water_type) as water_types,
    COUNT(DISTINCT risk_tier) as risk_tiers,
    COUNT(*) as total_loot_entries
FROM mortal_fishing_loot;

