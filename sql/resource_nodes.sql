-- ==================================================
-- Feature: Resource Nodes
-- Description: Dynamic resource spawn locations
-- Spec: 04-economy.md section 5. Resource Tiers & Distribution
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_resource_nodes` (
    `node_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `resource_entry` MEDIUMINT UNSIGNED NOT NULL COMMENT 'Item template entry for this resource',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone where node spawns',
    `tier` TINYINT UNSIGNED NOT NULL COMMENT 'Resource tier (1-5)',
    `pos_x` FLOAT NOT NULL COMMENT 'X coordinate',
    `pos_y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `pos_z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `respawn_time` INT UNSIGNED NOT NULL DEFAULT 300 COMMENT 'Respawn time in seconds',
    `last_harvest_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last harvest',
    `max_spawns` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Maximum concurrent spawns',
    `current_spawns` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Current active spawns',
    `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Whether node is active',
    `description` VARCHAR(255) NULL COMMENT 'Optional node description',
    INDEX `idx_zone_tier` (`zone_id`, `tier`),
    INDEX `idx_resource` (`resource_entry`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Dynamic resource spawn locations for tiered resource distribution';

-- Insert sample resource nodes for Tier 1 (Green Zones)
INSERT INTO `mortal_resource_nodes` (
    `resource_entry`, `zone_id`, `tier`, `pos_x`, `pos_y`, `pos_z`,
    `respawn_time`, `max_spawns`, `enabled`, `description`
) VALUES
-- Elwynn Forest (Stormwind area) - Copper Ore
(2770, 12, 1, -9500.0, 100.0, 60.0, 300, 3, 1, 'Copper vein near Goldshire'),
(2770, 12, 1, -9200.0, 200.0, 70.0, 300, 3, 1, 'Copper vein east of Goldshire'),
(2770, 12, 1, -8800.0, 150.0, 65.0, 300, 3, 1, 'Copper vein near Eastvale Logging Camp'),

-- Dun Morogh (Ironforge area) - Copper Ore
(2770, 1, 1, -5600.0, -800.0, 400.0, 300, 3, 1, 'Copper vein near Kharanos'),
(2770, 1, 1, -5800.0, -900.0, 420.0, 300, 3, 1, 'Copper vein in Coldridge Valley'),

-- Durotar (Orgrimmar area) - Copper Ore
(2770, 14, 1, 1000.0, -4800.0, 20.0, 300, 3, 1, 'Copper vein near Razor Hill'),
(2770, 14, 1, 1200.0, -4600.0, 25.0, 300, 3, 1, 'Copper vein south of Razor Hill'),

-- Mulgore (Thunder Bluff area) - Copper Ore
(2770, 215, 1, -2000.0, 200.0, 100.0, 300, 3, 1, 'Copper vein near Bloodhoof Village'),
(2770, 215, 1, -1800.0, 300.0, 110.0, 300, 3, 1, 'Copper vein east of Bloodhoof Village'),

-- Teldrassil (Darnassus area) - Copper Ore
(2770, 141, 1, 9800.0, 900.0, 1300.0, 300, 3, 1, 'Copper vein near Dolanaar'),
(2770, 141, 1, 10000.0, 800.0, 1320.0, 300, 3, 1, 'Copper vein in Shadowglen'),

-- Tirisfal Glades (Undercity area) - Copper Ore
(2770, 85, 1, 2000.0, 200.0, 35.0, 300, 3, 1, 'Copper vein near Deathknell'),
(2770, 85, 1, 2200.0, 100.0, 40.0, 300, 3, 1, 'Copper vein east of Deathknell');

-- Insert sample resource nodes for Tier 2 (Yellow Zones)
INSERT INTO `mortal_resource_nodes` (
    `resource_entry`, `zone_id`, `tier`, `pos_x`, `pos_y`, `pos_z`,
    `respawn_time`, `max_spawns`, `enabled`, `description`
) VALUES
-- Westfall - Iron Ore
(2772, 40, 2, -10500.0, 1000.0, 40.0, 450, 2, 1, 'Iron deposit near Sentinel Hill'),
(2772, 40, 2, -10200.0, 1200.0, 35.0, 450, 2, 1, 'Iron deposit in Moonbrook'),

-- Loch Modan - Iron Ore
(2772, 38, 2, -5200.0, -2800.0, 320.0, 450, 2, 1, 'Iron deposit near Thelsamar'),
(2772, 38, 2, -5000.0, -2600.0, 310.0, 450, 2, 1, 'Iron deposit in Stonesplinter Valley'),

-- Darkshore - Iron Ore
(2772, 148, 2, 6200.0, 300.0, 20.0, 450, 2, 1, 'Iron deposit near Auberdine'),
(2772, 148, 2, 6400.0, 200.0, 25.0, 450, 2, 1, 'Iron deposit south of Auberdine'),

-- Silverpine Forest - Iron Ore
(2772, 130, 2, 800.0, 1400.0, 60.0, 450, 2, 1, 'Iron deposit near The Sepulcher'),
(2772, 130, 2, 600.0, 1600.0, 55.0, 450, 2, 1, 'Iron deposit in The Skittering Dark'),

-- The Barrens - Iron Ore
(2772, 17, 2, -500.0, -2600.0, 95.0, 450, 2, 1, 'Iron deposit near Crossroads'),
(2772, 17, 2, -300.0, -2400.0, 100.0, 450, 2, 1, 'Iron deposit east of Crossroads');

-- Insert sample resource nodes for Tier 3 (Yellow High/Red Zones)
INSERT INTO `mortal_resource_nodes` (
    `resource_entry`, `zone_id`, `tier`, `pos_x`, `pos_y`, `pos_z`,
    `respawn_time`, `max_spawns`, `enabled`, `description`
) VALUES
-- Ashenvale - Thorium Ore
(10620, 331, 3, 2000.0, -2000.0, 95.0, 600, 1, 1, 'Thorium vein in Ashenvale'),
(10620, 331, 3, 2200.0, -1800.0, 100.0, 600, 1, 1, 'Thorium vein near Astranaar'),

-- Stonetalon Mountains - Thorium Ore
(10620, 406, 3, 800.0, 800.0, 140.0, 600, 1, 1, 'Thorium vein in Stonetalon'),
(10620, 406, 3, 600.0, 1000.0, 135.0, 600, 1, 1, 'Thorium vein near Sun Rock Retreat'),

-- Desolace - Thorium Ore
(10620, 405, 3, -500.0, 1800.0, 90.0, 600, 1, 1, 'Thorium vein in Desolace'),
(10620, 405, 3, -300.0, 2000.0, 85.0, 600, 1, 1, 'Thorium vein near Ghost Walker Post'),

-- Feralas - Thorium Ore
(10620, 357, 3, -4500.0, 2000.0, 85.0, 600, 1, 1, 'Thorium vein in Feralas'),
(10620, 357, 3, -4300.0, 2200.0, 80.0, 600, 1, 1, 'Thorium vein near Camp Mojache'),

-- Thousand Needles - Thorium Ore
(10620, 4005, 3, -5200.0, -1800.0, -60.0, 600, 1, 1, 'Thorium vein in Thousand Needles'),
(10620, 4005, 3, -5000.0, -1600.0, -55.0, 600, 1, 1, 'Thorium vein near Freewind Post');

-- Insert sample resource nodes for Tier 4 (Red Zones)
INSERT INTO `mortal_resource_nodes` (
    `resource_entry`, `zone_id`, `tier`, `pos_x`, `pos_y`, `pos_z`,
    `respawn_time`, `max_spawns`, `enabled`, `description`
) VALUES
-- Badlands - Thorium Ore (higher tier)
(10620, 3, 4, -6800.0, -3200.0, 250.0, 900, 1, 1, 'Rich thorium deposit in Badlands'),
(10620, 3, 4, -6600.0, -3000.0, 245.0, 900, 1, 1, 'Rich thorium deposit near Kargath'),

-- Searing Gorge - Thorium Ore (higher tier)
(10620, 51, 4, -6800.0, -1800.0, 250.0, 900, 1, 1, 'Rich thorium deposit in Searing Gorge'),
(10620, 51, 4, -6600.0, -1600.0, 245.0, 900, 1, 1, 'Rich thorium deposit near Blackrock Mountain'),

-- Winterspring - Thorium Ore (higher tier)
(10620, 618, 4, 6500.0, -4800.0, 700.0, 900, 1, 1, 'Rich thorium deposit in Winterspring'),
(10620, 618, 4, 6700.0, -4600.0, 695.0, 900, 1, 1, 'Rich thorium deposit near Everlook'),

-- Silithus - Thorium Ore (higher tier)
(10620, 1377, 4, -6800.0, 800.0, 10.0, 900, 1, 1, 'Rich thorium deposit in Silithus'),
(10620, 1377, 4, -6600.0, 1000.0, 15.0, 900, 1, 1, 'Rich thorium deposit near Cenarion Hold');

-- Insert sample resource nodes for Tier 5 (Red Rare)
INSERT INTO `mortal_resource_nodes` (
    `resource_entry`, `zone_id`, `tier`, `pos_x`, `pos_y`, `pos_z`,
    `respawn_time`, `max_spawns`, `enabled`, `description`
) VALUES
-- Silithus - Dreamfoil (rare herb)
(13463, 1377, 5, -7200.0, 600.0, 5.0, 1800, 1, 1, 'Rare dreamfoil patch in Silithus'),
(13463, 1377, 5, -7000.0, 800.0, 8.0, 1800, 1, 1, 'Rare dreamfoil patch near Hive\'Regal'),

-- Winterspring - Dreamfoil (rare herb)
(13463, 618, 5, 6200.0, -5000.0, 710.0, 1800, 1, 1, 'Rare dreamfoil patch in Winterspring'),
(13463, 618, 5, 6400.0, -4800.0, 705.0, 1800, 1, 1, 'Rare dreamfoil patch near Frostsaber Rock'),

-- Eastern Plaguelands - Dreamfoil (rare herb)
(13463, 139, 5, 1800.0, -5600.0, 85.0, 1800, 1, 1, 'Rare dreamfoil patch in Eastern Plaguelands'),
(13463, 139, 5, 2000.0, -5400.0, 80.0, 1800, 1, 1, 'Rare dreamfoil patch near Light\'s Hope Chapel');