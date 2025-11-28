-- ==================================================
-- Project Mortal Warcraft
-- Feature: The Shrine System (Live Respawn)
-- Description: Database tables for death tracking and shrine configuration
-- ==================================================

-- Optional: Death log table for corpse recovery system
CREATE TABLE IF NOT EXISTS `character_death_log` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `map` SMALLINT UNSIGNED NOT NULL COMMENT 'Map ID where death occurred',
  `zone` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID where death occurred',
  `x` FLOAT NOT NULL COMMENT 'X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Z coordinate',
  `time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of death',
  PRIMARY KEY (`id`),
  KEY `idx_guid` (`guid`),
  KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Death location tracking for corpse recovery';

-- Optional: Custom Soul Fragment item (if you want to replace Soul Shard requirement)
-- Note: Soul Shard (6265) is a Warlock item, you may want a custom item for all classes
-- Uncomment and modify if needed:
/*
DELETE FROM `item_template` WHERE `entry` = 90010;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, 
    `BuyPrice`, `SellPrice`, `InventoryType`, `stackable`, `bonding`, `description`
) VALUES (
    90010, 0, 0, 'Soul Fragment', 1390, 1, 0,
    1000, 250, 0, 20, 0, 'Required reagent for resurrection rituals.'
);
*/

-- Note: The Shrine System primarily uses Lua hooks, no additional database setup required
-- unless you want to track death locations or use custom items

