-- ==================================================
-- Project Mortal Warcraft
-- Feature: Instance & Battleground Tier Mapping
-- Description: Maps dungeons, raids, and BGs to Mortal tiers
-- Based on: docs/specs/33-instance-and-battleground-tier-mapping.md
-- ==================================================

-- Instance Tier Mapping
-- Maps dungeon/raid instances to Mortal tiers for loot and scaling
CREATE TABLE IF NOT EXISTS `mortal_instance_tiers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID (dungeon/raid instance)',
    `instance_name` VARCHAR(100) NOT NULL,
    `tier_code` VARCHAR(32) NOT NULL COMMENT 'M-T1, M-T2, M-T3, M-T4, M-T5',
    `trash_tier_code` VARCHAR(32) NULL COMMENT 'TRASH_T1, TRASH_T2, etc.',
    `boss_tier_code` VARCHAR(32) NULL COMMENT 'BOSS_T1, BOSS_T2, etc.',
    `loot_tier_hint` VARCHAR(16) NULL COMMENT 'M-T1, M-T2, M-T3, M-T4, M-T5',
    `is_warfront` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if Warfront (full loot)',
    `is_heroic` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if Heroic mode',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_map` (`map_id`, `is_heroic`),
    INDEX `idx_tier` (`tier_code`),
    INDEX `idx_loot_tier` (`loot_tier_hint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Instance tier mappings';

-- Battleground Tier Mapping
-- Maps battlegrounds to PvP tiers and rules
CREATE TABLE IF NOT EXISTS `mortal_battleground_tiers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_id` INT UNSIGNED NOT NULL COMMENT 'Battleground map ID',
    `bg_name` VARCHAR(100) NOT NULL,
    `is_warfront` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 if Warfront (full loot)',
    `pvp_tier_hint` VARCHAR(16) NULL COMMENT 'P1, P2, P3, P4, P5, P6',
    `reward_tokens` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'PvP Tokens per win',
    `reward_credits` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Military Credits per win',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_map` (`map_id`),
    INDEX `idx_warfront` (`is_warfront`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Battleground tier mappings';

-- Seed Data: Instance Tier Mappings
-- M-T1: Early Classic Dungeons
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`) VALUES
(389, 'Ragefire Chasm', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(43, 'Wailing Caverns', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(36, 'The Deadmines', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(33, 'Shadowfang Keep', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(48, 'Blackfathom Deeps', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(34, 'Stormwind Stockade', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(47, 'Razorfen Kraul', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(129, 'Razorfen Downs', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1'),
(70, 'Uldaman', 'M-T1', 'TRASH_T1', 'BOSS_T1', 'M-T1')
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- M-T2: Mid-Game Classic / TBC Dungeons
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`) VALUES
(209, 'Zul\'Farrak', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(349, 'Maraudon', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(109, 'Sunken Temple', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(230, 'Blackrock Depths', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(229, 'Blackrock Spire (Lower)', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(229, 'Blackrock Spire (Upper)', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(289, 'Scholomance', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2'),
(329, 'Stratholme', 'M-T2', 'TRASH_T2', 'BOSS_T2', 'M-T2')
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- M-T3: Heroic Dungeons / WotLK 5-mans
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
(574, 'Utgarde Keep', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(575, 'Utgarde Pinnacle', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(576, 'The Nexus', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(578, 'The Oculus', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(601, 'Azjol-Nerub', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(602, 'Ahn\'Kahet', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(600, 'Drak\'Tharon Keep', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(608, 'Violet Hold', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(604, 'Gundrak', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(599, 'Halls of Stone', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0),
(602, 'Halls of Lightning', 'M-T3', 'TRASH_T3', 'BOSS_T3', 'M-T3', 0)
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- M-T4: ICC 5-mans (Bridge to M-T4)
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`) VALUES
(632, 'The Forge of Souls', 'M-T4', 'TRASH_T3', 'BOSS_T3', 'M-T4'),
(658, 'The Pit of Saron', 'M-T4', 'TRASH_T3', 'BOSS_T3', 'M-T4'),
(668, 'Halls of Reflection', 'M-T4', 'TRASH_T3', 'BOSS_T3', 'M-T4')
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- M-T4: Early WotLK Raids
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`) VALUES
(533, 'Naxxramas (10)', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4'),
(533, 'Naxxramas (25)', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4'),
(616, 'The Eye of Eternity', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4'),
(615, 'Obsidian Sanctum', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4')
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- M-T4: Ulduar / ToC
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
(603, 'Ulduar (Normal)', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4', 0),
(603, 'Ulduar (Hard Modes)', 'M-T4', 'TRASH_T3', 'RAID_ICC_H', 'M-T5', 1),
(649, 'Trial of the Crusader (Normal)', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4', 0),
(649, 'Trial of the Crusader (Heroic)', 'M-T4', 'TRASH_T3', 'RAID_ICC_H', 'M-T5', 1)
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- M-T4/M-T5: ICC
INSERT INTO `mortal_instance_tiers` (`map_id`, `instance_name`, `tier_code`, `trash_tier_code`, `boss_tier_code`, `loot_tier_hint`, `is_heroic`) VALUES
(631, 'Icecrown Citadel (Normal)', 'M-T4', 'TRASH_T3', 'RAID_ICC_N', 'M-T4', 0),
(631, 'Icecrown Citadel (Heroic)', 'M-T5', 'TRASH_T3', 'RAID_ICC_H', 'M-T5', 1)
ON DUPLICATE KEY UPDATE `instance_name` = VALUES(`instance_name`);

-- Battleground Mappings
INSERT INTO `mortal_battleground_tiers` (`map_id`, `bg_name`, `is_warfront`, `pvp_tier_hint`, `reward_tokens`, `reward_credits`) VALUES
(489, 'Warsong Gulch', 0, 'P1', 10, 50),
(529, 'Arathi Basin', 0, 'P1', 15, 75),
(566, 'Eye of the Storm', 0, 'P2', 20, 100),
(30, 'Alterac Valley', 0, 'P2', 25, 125),
(607, 'Strand of the Ancients', 0, 'P2', 20, 100)
ON DUPLICATE KEY UPDATE `bg_name` = VALUES(`bg_name`);

-- Warfront Mappings (full loot enabled)
INSERT INTO `mortal_battleground_tiers` (`map_id`, `bg_name`, `is_warfront`, `pvp_tier_hint`, `reward_tokens`, `reward_credits`) VALUES
(529, 'Arathi Basin Warfront', 1, 'P4', 100, 500),
(30, 'Alterac Valley Warfront', 1, 'P5', 150, 750)
ON DUPLICATE KEY UPDATE `bg_name` = VALUES(`bg_name`);

