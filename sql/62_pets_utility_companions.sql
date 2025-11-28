-- ==================================================
-- Project Mortal Warcraft
-- Feature: Pets & Utility Companions
-- Description: Combat pets with loyalty system and utility companions
-- ==================================================

-- Combat Pets
CREATE TABLE IF NOT EXISTS `mortal_pets` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `pet_guid` INT UNSIGNED NOT NULL COMMENT 'Pet GUID',
  `owner_guid` INT UNSIGNED NOT NULL COMMENT 'Owner player GUID',
  `pet_entry` INT UNSIGNED NOT NULL COMMENT 'Creature entry',
  `type` TINYINT UNSIGNED NOT NULL COMMENT 'Pet type (1=tamed_beast, 2=summoned_demon, 3=summoned_elemental)',
  `loyalty` INT UNSIGNED NOT NULL DEFAULT 50 COMMENT 'Loyalty score (0-100)',
  `last_feed_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last feed timestamp',
  `death_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of deaths',
  `win_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of combat wins',
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Pet state (0=active, 1=fleeing, 2=dead, 3=wild, 4=permanently_lost)',
  `last_update` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_pet` (`pet_guid`),
  KEY `idx_owner` (`owner_guid`),
  KEY `idx_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Combat pet tracking with loyalty system';

-- Utility Companions
CREATE TABLE IF NOT EXISTS `mortal_utility_companions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `companion_guid` INT UNSIGNED NOT NULL COMMENT 'Companion creature GUID',
  `owner_guid` INT UNSIGNED NOT NULL COMMENT 'Owner player GUID',
  `type` TINYINT UNSIGNED NOT NULL COMMENT 'Companion type (1=pack_mule, 2=vendor_squire, 3=eco_bot)',
  `entry` INT UNSIGNED NOT NULL COMMENT 'Creature entry',
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Companion state (0=active, 1=dead, 2=stabled)',
  `needs` INT UNSIGNED NOT NULL DEFAULT 60 COMMENT 'Needs level (0-100)',
  `last_feed_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last feed timestamp',
  `last_update` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_companion` (`companion_guid`),
  KEY `idx_owner` (`owner_guid`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Utility companion tracking';

-- Pack Mule Inventory (if needed)
CREATE TABLE IF NOT EXISTS `mortal_pack_mule_inventory` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `companion_guid` INT UNSIGNED NOT NULL COMMENT 'Pack mule companion GUID',
  `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Inventory slot (0-19)',
  `item_guid` INT UNSIGNED NULL COMMENT 'Item GUID',
  `item_entry` INT UNSIGNED NULL COMMENT 'Item entry',
  `count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Item count',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_companion_slot` (`companion_guid`, `slot`),
  KEY `idx_item` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Pack mule inventory storage';

