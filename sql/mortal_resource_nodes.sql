-- Feature: Resource Nodes
-- Description: Resource spawning nodes with tier-based distribution
-- Spec: 04-economy.md
-- ==================================================

-- Resource nodes table
CREATE TABLE IF NOT EXISTS `mortal_resource_nodes` (
    `node_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `resource_entry` INT UNSIGNED NOT NULL COMMENT 'Item entry for the resource',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID where node spawns',
    `pos_x` FLOAT NOT NULL COMMENT 'X coordinate',
    `pos_y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `pos_z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `tier` TINYINT UNSIGNED NOT NULL COMMENT 'Resource tier (1-5)',
    `respawn_time` INT UNSIGNED NOT NULL DEFAULT 1800000 COMMENT 'Respawn time in milliseconds (30 minutes default)',
    `last_harvest_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last harvest',
    `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=enabled, 0=disabled',
    PRIMARY KEY (`node_id`),
    INDEX `idx_zone_tier` (`zone_id`, `tier`),
    INDEX `idx_resource` (`resource_entry`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Resource spawning nodes with tier-based distribution';

-- Insert sample resource nodes
-- Tier 1: Green zones (Copper)
INSERT INTO `mortal_resource_nodes` (`resource_entry`, `zone_id`, `pos_x`, `pos_y`, `pos_z`, `tier`, `respawn_time`, `enabled`) VALUES
(2770, 1519, -8913.0, 554.0, 94.0, 1, 1800000, 1), -- Copper Ore in Stormwind
(2770, 1537, -4821.0, -1155.0, 502.0, 1, 1800000, 1), -- Copper Ore in Ironforge
(2770, 1637, 1677.0, -4315.0, 61.0, 1, 1800000, 1), -- Copper Ore in Orgrimmar
(2770, 1638, -1274.0, 124.0, 131.0, 1, 1800000, 1); -- Copper Ore in Thunder Bluff

-- Tier 2: Yellow zones (Iron)
INSERT INTO `mortal_resource_nodes` (`resource_entry`, `zone_id`, `pos_x`, `pos_y`, `pos_z`, `tier`, `respawn_time`, `enabled`) VALUES
(2771, 17, -456.0, -2650.0, 95.0, 2, 1800000, 1), -- Iron Ore in Barrens
(2771, 130, -14457.0, 470.0, 15.0, 2, 1800000, 1), -- Iron Ore in Silverpine Forest
(2771, 267, -8913.0, 554.0, 94.0, 2, 1800000, 1); -- Iron Ore in Hillsbrad Foothills

-- Tier 3: High Yellow zones (Mithril)
INSERT INTO `mortal_resource_nodes` (`resource_entry`, `zone_id`, `pos_x`, `pos_y`, `pos_z`, `tier`, `respawn_time`, `enabled`) VALUES
(3858, 331, -4821.0, -1155.0, 502.0, 3, 1800000, 1), -- Mithril Ore in Ashenvale
(3858, 406, 1677.0, -4315.0, 61.0, 3, 1800000, 1), -- Mithril Ore in Stonetalon Mountains
(3858, 357, -1274.0, 124.0, 131.0, 3, 1800000, 1); -- Mithril Ore in Feralas

-- Tier 4: Red zones (Thorium)
INSERT INTO `mortal_resource_nodes` (`resource_entry`, `zone_id`, `pos_x`, `pos_y`, `pos_z`, `tier`, `respawn_time`, `enabled`) VALUES
(10620, 4, -456.0, -2650.0, 95.0, 4, 1800000, 1), -- Thorium Ore in Blasted Lands
(10620, 46, -14457.0, 470.0, 15.0, 4, 1800000, 1), -- Thorium Ore in Burning Steppes
(10620, 51, -8913.0, 554.0, 94.0, 4, 1800000, 1); -- Thorium Ore in Searing Gorge

-- Tier 5: Red Rare zones (Dreamscale)
INSERT INTO `mortal_resource_nodes` (`resource_entry`, `zone_id`, `pos_x`, `pos_y`, `pos_z`, `tier`, `respawn_time`, `enabled`) VALUES
(20381, 4, -4821.0, -1155.0, 502.0, 5, 1800000, 1), -- Dreamscale in Blasted Lands
(20381, 46, 1677.0, -4315.0, 61.0, 5, 1800000, 1), -- Dreamscale in Burning Steppes
(20381, 51, -1274.0, 124.0, 131.0, 5, 1800000, 1); -- Dreamscale in Searing Gorge