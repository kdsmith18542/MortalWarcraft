-- ==================================================
-- Project Mortal Warcraft
-- Feature: Zone Risk Flags System
-- Description: Defines risk tiers for all zones (Green=0, Yellow=1, Red=2)
-- Based on spec 03-risk-zones.md zone-by-zone conversion
-- ==================================================

-- Zone Risk Flags Table
CREATE TABLE IF NOT EXISTS `zones_risk_flags` (
    `zone_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `zone_name` VARCHAR(100) NOT NULL,
    `risk_flag` TINYINT UNSIGNED NOT NULL COMMENT '0=Green (Safe), 1=Yellow (Contested), 2=Red (Full Loot)',
    INDEX `idx_risk_flag` (`risk_flag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Zone Risk Flags
-- Eastern Kingdoms - Green Zones (Safe)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(12, 'Elwynn Forest', 0),
(1, 'Dun Morogh', 0),
(38, 'Loch Modan', 0),
(1519, 'Stormwind City', 0),
(1537, 'Ironforge', 0),
(3430, 'Eversong Woods', 0),
(85, 'Tirisfal Glades', 0),
(130, 'Silverpine Forest', 0),
(14, 'Durotar', 0),
(215, 'Mulgore', 0),
(141, 'Teldrassil', 0),
(1657, 'Darnassus', 0),
(1637, 'Orgrimmar', 0),
(1638, 'Thunder Bluff', 0),
(3703, 'Shattrath City', 0),
(4395, 'Dalaran', 0),
(2817, 'Crystalsong Forest', 0)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Eastern Kingdoms - Yellow Zones (Contested)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(40, 'Westfall', 1),
(44, 'Redridge Mountains', 1),
(10, 'Duskwood', 1),
(11, 'Wetlands', 1),
(45, 'Arathi Highlands', 1),
(267, 'Hillsbrad Foothills', 1),
(3, 'Badlands', 1),
(51, 'Searing Gorge', 1),
(8, 'Swamp of Sorrows', 1),
(47, 'The Hinterlands', 1),
(28, 'Western Plaguelands', 1),
(41, 'Deadwind Pass', 1),
(3433, 'Ghostlands', 1)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Eastern Kingdoms - Red Zones (Full Loot)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(33, 'Stranglethorn Vale', 2),
(46, 'Burning Steppes', 2),
(4, 'Blasted Lands', 2),
(139, 'Eastern Plaguelands', 2)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Kalimdor - Yellow Zones (Contested)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(148, 'Darkshore', 1),
(331, 'Ashenvale', 1),
(406, 'Stonetalon Mountains', 1),
(405, 'Desolace', 1),
(357, 'Feralas', 1),
(17, 'The Barrens', 1),
(400, 'Thousand Needles', 1),
(440, 'Tanaris', 1),
(490, 'Un''Goro Crater', 1),
(618, 'Winterspring', 1),
(361, 'Felwood', 1),
(16, 'Azshara', 1)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Kalimdor - Red Zones (Full Loot)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(1377, 'Silithus', 2)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Outland - Yellow Zones (Contested)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(3483, 'Hellfire Peninsula', 1),
(3521, 'Zangarmarsh', 1),
(3524, 'Nagrand', 1),
(3522, 'Blade''s Edge Mountains', 1),
(3523, 'Netherstorm', 1),
(3519, 'Terokkar Forest', 1)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Outland - Red Zones (Full Loot)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(3520, 'Shadowmoon Valley', 2)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Northrend - Yellow Zones (Contested)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(3537, 'Borean Tundra', 1),
(495, 'Howling Fjord', 1),
(65, 'Dragonblight', 1),
(394, 'Grizzly Hills', 1),
(66, 'Zul''Drak', 1),
(3711, 'Sholazar Basin', 1),
(67, 'The Storm Peaks', 1)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);

-- Northrend - Red Zones (Full Loot)
INSERT INTO `zones_risk_flags` (`zone_id`, `zone_name`, `risk_flag`) VALUES
(210, 'Icecrown', 2),
(4197, 'Wintergrasp', 2)

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `risk_flag` = VALUES(`risk_flag`);