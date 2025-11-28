-- ==================================================
-- Project Mortal Warcraft: Player Housing
-- Module: mod-mortal-core
-- Feature: Player housing using existing WoW building gameobjects
-- ==================================================

-- Character Housing Table
CREATE TABLE IF NOT EXISTS `character_housing` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
  `gameobject_guid` INT UNSIGNED NOT NULL COMMENT 'GameObject GUID of claimed building',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone where housing is located',
  `location_x` FLOAT NOT NULL,
  `location_y` FLOAT NOT NULL,
  `location_z` FLOAT NOT NULL,
  `claimed_at` TIMESTAMP NOT NULL DEFAULT 0,
  `last_maintained` TIMESTAMP NOT NULL DEFAULT 0,
  `access_level` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=self, 1=guild, 2=friends, 3=public',
  `storage_slots` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of storage slots available',
  PRIMARY KEY (`guid`, `gameobject_guid`),
  UNIQUE KEY `idx_gameobject` (`gameobject_guid`),
  INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player housing using existing building gameobjects';

-- Housing Inventory Table
CREATE TABLE IF NOT EXISTS `housing_inventory` (
  `house_id` INT UNSIGNED NOT NULL COMMENT 'GameObject GUID of the house',
  `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Storage slot (0-199)',
  `item_guid` INT UNSIGNED NOT NULL COMMENT 'Item instance GUID',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item template entry',
  `count` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`house_id`, `slot`),
  INDEX `idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Storage inventory for player housing';

-- Housing Crafting Stations Table
CREATE TABLE IF NOT EXISTS `housing_crafting_stations` (
  `house_id` INT UNSIGNED NOT NULL COMMENT 'GameObject GUID of the house',
  `station_type` TINYINT UNSIGNED NOT NULL COMMENT '1=Forge, 2=Alchemy, 3=Enchanting, 4=Cooking, etc.',
  `gameobject_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject entry for the station',
  `location_x` FLOAT NULL DEFAULT NULL COMMENT 'Relative X position in house',
  `location_y` FLOAT NULL DEFAULT NULL COMMENT 'Relative Y position in house',
  `location_z` FLOAT NULL DEFAULT NULL COMMENT 'Relative Z position in house',
  PRIMARY KEY (`house_id`, `station_type`),
  INDEX `idx_station_type` (`station_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Crafting stations placed in player housing';

