-- ==================================================
-- Project Mortal Warcraft
-- Feature: Mortal Achievement Definitions
-- Description: Category definitions, achievement metadata, rewards, and DBC rows
-- Based on: docs/specs/36-mortal-achievements-and-titles-core.md
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_achievement_categories` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(32) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `parent_code` VARCHAR(32) DEFAULT NULL,
  `ui_order` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Logical groupings for Mortal achievements';

CREATE TABLE IF NOT EXISTS `mortal_achievement_definitions` (
  `achievement_id` INT UNSIGNED NOT NULL,
  `code` VARCHAR(64) NOT NULL,
  `category_code` VARCHAR(32) NOT NULL,
  `criteria_type` TINYINT UNSIGNED NOT NULL,
  `target_value` INT UNSIGNED NOT NULL DEFAULT 0,
  `points` INT UNSIGNED NOT NULL DEFAULT 0,
  `title_name` VARCHAR(100) DEFAULT NULL,
  `item_entry` INT UNSIGNED DEFAULT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`achievement_id`),
  CONSTRAINT `fk_mortal_achievements_category` FOREIGN KEY (`category_code`) REFERENCES `mortal_achievement_categories` (`code`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Metadata for Mortal achievements';

INSERT INTO `mortal_achievement_categories` (`code`, `name`, `parent_code`, `ui_order`) VALUES
('PVP', 'Mortal – PvP', NULL, 10),
('PVE', 'Mortal – Raids & Dungeons', NULL, 20),
('ECON', 'Mortal – Economy & Crafting', NULL, 30),
('EXPLORE', 'Mortal – Exploration & Lore', NULL, 40),
('STRONG', 'Mortal – Strongholds & Territory', NULL, 50),
('HARDCORE', 'Mortal – Hardcore & Survival', NULL, 60),
('SOCIAL', 'Mortal – Social & Community', NULL, 70)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `ui_order` = VALUES(`ui_order`);

INSERT INTO `mortal_achievement_definitions`
(`achievement_id`, `code`, `category_code`, `criteria_type`, `target_value`, `points`, `title_name`, `item_entry`, `description`) VALUES
(500001, 'MORTAL_COMBATANT', 'PVP', 0, 100, 10, 'arena_champion', NULL, 'Win 100 rated arena matches.'),
(510001, 'CONQUEROR_OF_ICECROWN', 'PVE', 100, 1, 25, 'world_wanderer', NULL, 'Defeat the Lich King in Mortal Icecrown.'),
(520001, 'ROAD_BARON', 'ECON', 101, 50, 15, 'caravan_master', NULL, 'Complete 50 courier contracts.'),
(530001, 'WORLD_WANDERER', 'EXPLORE', 0, 30, 15, 'world_wanderer', NULL, 'Discover 30 Mortal exploration markers.'),
(540001, 'STRONGHOLD_MASTER', 'STRONG', 104, 5, 20, 'stronghold_master', NULL, 'Claim 5 unique strongholds.'),
(550001, 'MORTAL_LEGEND', 'HARDCORE', 109, 1, 30, 'legendary_crafter', NULL, 'Complete a seasonal hardcore challenge.')
ON DUPLICATE KEY UPDATE
`criteria_type` = VALUES(`criteria_type`),
`target_value` = VALUES(`target_value`),
`points` = VALUES(`points`),
`title_name` = VALUES(`title_name`),
`description` = VALUES(`description`);

INSERT INTO `mortal_achievement_rewards` (`achievement_id`, `title_name`, `item_entry`, `notes`) VALUES
(500001, 'arena_champion', NULL, 'PvP milestone title'),
(510001, 'world_wanderer', NULL, 'PvE explorer title'),
(520001, 'caravan_master', NULL, 'Economy courier title'),
(530001, 'world_wanderer', NULL, 'Exploration repeat reward'),
(540001, 'stronghold_master', NULL, 'Stronghold prestige title'),
(550001, 'legendary_crafter', NULL, 'Hardcore cosmetic title')
ON DUPLICATE KEY UPDATE `title_name` = VALUES(`title_name`), `item_entry` = VALUES(`item_entry`);

-- --------------------------------------------------
-- DBC overlay so achievements appear in the UI
-- --------------------------------------------------

INSERT INTO `achievement_category_dbc` (`ID`, `Parent`, `Name_Lang_enUS`, `Name_Lang_Mask`, `Ui_Order`) VALUES
(20010, -1, 'Mortal – PvP', 0xFFFFFFFF, 10),
(20011, -1, 'Mortal – Raids & Dungeons', 0xFFFFFFFF, 20),
(20012, -1, 'Mortal – Economy & Crafting', 0xFFFFFFFF, 30),
(20013, -1, 'Mortal – Exploration & Lore', 0xFFFFFFFF, 40),
(20014, -1, 'Mortal – Strongholds & Territory', 0xFFFFFFFF, 50),
(20015, -1, 'Mortal – Hardcore & Survival', 0xFFFFFFFF, 60)
ON DUPLICATE KEY UPDATE `Name_Lang_enUS` = VALUES(`Name_Lang_enUS`);

INSERT INTO `achievement_dbc`
(`ID`, `Faction`, `Instance_Id`, `Supercedes`, `Title_Lang_enUS`, `Title_Lang_Mask`,
 `Description_Lang_enUS`, `Description_Lang_Mask`, `Category`, `Points`, `Ui_Order`, `Flags`, `IconID`)
VALUES
(500001, 0, 0, 0, 'Mortal Combatant', 0xFFFFFFFF, 'Win 100 rated arena matches.', 0xFFFFFFFF, 20010, 10, 1, 0, 0),
(510001, 0, 0, 0, 'Conqueror of Icecrown', 0xFFFFFFFF, 'Defeat the Lich King in Mortal Icecrown.', 0xFFFFFFFF, 20011, 25, 2, 0, 0),
(520001, 0, 0, 0, 'Road Baron', 0xFFFFFFFF, 'Complete 50 courier contracts.', 0xFFFFFFFF, 20012, 15, 3, 0, 0),
(530001, 0, 0, 0, 'World Wanderer', 0xFFFFFFFF, 'Discover 30 Mortal exploration markers.', 0xFFFFFFFF, 20013, 15, 4, 0, 0),
(540001, 0, 0, 0, 'Stronghold Master', 0xFFFFFFFF, 'Claim 5 unique strongholds.', 0xFFFFFFFF, 20014, 20, 5, 0, 0),
(550001, 0, 0, 0, 'Mortal Legend', 0xFFFFFFFF, 'Complete a seasonal hardcore challenge.', 0xFFFFFFFF, 20015, 30, 6, 0, 0)
ON DUPLICATE KEY UPDATE
`Title_Lang_enUS` = VALUES(`Title_Lang_enUS`),
`Description_Lang_enUS` = VALUES(`Description_Lang_enUS`),
`Category` = VALUES(`Category`),
`Points` = VALUES(`Points`);
