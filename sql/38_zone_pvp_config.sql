-- ==================================================
-- Project Mortal Warcraft
-- Feature: Zone-Based PvP System
-- Description: Defines Green/Yellow/Red zones with different PvP rules
-- ==================================================

-- Zone PvP Configuration Table
CREATE TABLE IF NOT EXISTS `zone_pvp_config` (
    `zone_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `zone_name` VARCHAR(100) NOT NULL,
    `pvp_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Green (Safe), 1=Yellow (Contested), 2=Red (Full Loot)',
    `pvp_enabled` BOOLEAN NOT NULL DEFAULT FALSE,
    `criminal_flag_duration` INT UNSIGNED NOT NULL DEFAULT 900 COMMENT 'Duration in seconds (15 minutes default)',
    `always_drop_loot` BOOLEAN NOT NULL DEFAULT FALSE COMMENT 'Always drop all items on death (Red zones)',
    `tier_level` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Resource tier (1-5)',
    `notes` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Zone Configurations
-- Green Zones (Safe - PvP Disabled, Tier 1 Resources)
INSERT INTO `zone_pvp_config` (`zone_id`, `zone_name`, `pvp_type`, `pvp_enabled`, `criminal_flag_duration`, `always_drop_loot`, `tier_level`, `notes`) VALUES
(12, 'Elwynn Forest', 0, FALSE, 0, FALSE, 1, 'Starting zone - Safe'),
(1637, 'Mulgore', 0, FALSE, 0, FALSE, 1, 'Starting zone - Safe'),
(1, 'Dun Morogh', 0, FALSE, 0, FALSE, 1, 'Starting zone - Safe'),
(14, 'Durotar', 0, FALSE, 0, FALSE, 1, 'Starting zone - Safe'),
(141, 'Teldrassil', 0, FALSE, 0, FALSE, 1, 'Starting zone - Safe'),
(215, 'Mulgore', 0, FALSE, 0, FALSE, 1, 'Starting zone - Safe'),

-- Yellow Zones (Contested - Criminal Flag, Conditional Loot, Tier 2-3 Resources)
(10, 'Duskwood', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(17, 'The Barrens', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(40, 'Westfall', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(130, 'Silverpine Forest', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(38, 'Loch Modan', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(85, 'Tirisfal Glades', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(148, 'Darkshore', 1, TRUE, 900, FALSE, 2, 'Contested - Criminal flag on attack'),
(331, 'Ashenvale', 1, TRUE, 900, FALSE, 3, 'Contested - Criminal flag on attack'),
(406, 'Stonetalon Mountains', 1, TRUE, 900, FALSE, 3, 'Contested - Criminal flag on attack'),

-- Red Zones (Full Loot - FFA PvP, Always Drop All, Tier 4-5 Resources)
(33, 'Stranglethorn Vale', 2, TRUE, 0, TRUE, 4, 'Full Loot - Always drop all on death'),
(139, 'Eastern Plaguelands', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(28, 'Western Plaguelands', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(1377, 'Silithus', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3483, 'Hellfire Peninsula', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3519, 'Terokkar Forest', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3520, 'Shadowmoon Valley', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3521, 'Zangarmarsh', 2, TRUE, 0, TRUE, 4, 'Full Loot - Always drop all on death'),
(3522, 'Blade''s Edge Mountains', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3523, 'Netherstorm', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3524, 'Nagrand', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3525, 'Howling Fjord', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3537, 'Borean Tundra', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(65, 'Dragonblight', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(394, 'Grizzly Hills', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(495, 'Howling Fjord', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(3711, 'Sholazar Basin', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(210, 'Icecrown', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(67, 'The Storm Peaks', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death'),
(66, 'Zul''Drak', 2, TRUE, 0, TRUE, 5, 'Full Loot - Always drop all on death')

ON DUPLICATE KEY UPDATE
    `zone_name` = VALUES(`zone_name`),
    `pvp_type` = VALUES(`pvp_type`),
    `pvp_enabled` = VALUES(`pvp_enabled`),
    `criminal_flag_duration` = VALUES(`criminal_flag_duration`),
    `always_drop_loot` = VALUES(`always_drop_loot`),
    `tier_level` = VALUES(`tier_level`),
    `notes` = VALUES(`notes`);

-- Criminal Flag Tracking Table
CREATE TABLE IF NOT EXISTS `player_criminal_flags` (
    `player_guid` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `flag_start_time` INT UNSIGNED NOT NULL,
    `flag_duration` INT UNSIGNED NOT NULL,
    `expires_at` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`player_guid`, `zone_id`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

