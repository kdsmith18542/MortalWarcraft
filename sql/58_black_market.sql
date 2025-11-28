-- ==================================================
-- Project Mortal Warcraft
-- Feature: Black Market (Darkmoon Faire)
-- Description: Rotates between Red Zones, fences for stolen goods
-- ==================================================

-- Black Market Configuration
CREATE TABLE IF NOT EXISTS `black_market_config` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'Market name',
  `current_location_map` SMALLINT UNSIGNED NOT NULL COMMENT 'Current map ID',
  `current_location_zone` SMALLINT UNSIGNED NOT NULL COMMENT 'Current zone ID',
  `current_location_x` FLOAT NOT NULL COMMENT 'Current X coordinate',
  `current_location_y` FLOAT NOT NULL COMMENT 'Current Y coordinate',
  `current_location_z` FLOAT NOT NULL COMMENT 'Current Z coordinate',
  `current_location_o` FLOAT NOT NULL COMMENT 'Current orientation',
  `rotation_interval_hours` INT UNSIGNED NOT NULL DEFAULT 168 COMMENT 'Rotation interval in hours (default: 7 days)',
  `next_rotation_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of next rotation',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is market active?',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Black Market configuration and location';

-- Black Market Locations (Red Zones where market can spawn)
CREATE TABLE IF NOT EXISTS `black_market_locations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `map` SMALLINT UNSIGNED NOT NULL COMMENT 'Map ID',
  `zone` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `x` FLOAT NOT NULL COMMENT 'X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Z coordinate',
  `o` FLOAT NOT NULL COMMENT 'Orientation',
  `name` VARCHAR(100) NOT NULL COMMENT 'Location name',
  `weight` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Spawn weight (higher = more likely)',
  PRIMARY KEY (`id`),
  KEY `idx_zone` (`zone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Black Market spawn locations in Red Zones';

-- Black Market Transactions (fencing stolen goods)
CREATE TABLE IF NOT EXISTS `black_market_transactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item entry',
  `item_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Item count',
  `gold_paid` INT UNSIGNED NOT NULL COMMENT 'Gold received',
  `transaction_time` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_player` (`player_guid`),
  KEY `idx_time` (`transaction_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Black Market transaction log';

-- Black Market NPC
CREATE TABLE IF NOT EXISTS `black_market_npc` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `creature_entry` INT UNSIGNED NOT NULL DEFAULT 90080 COMMENT 'NPC entry',
  `name` VARCHAR(100) NOT NULL DEFAULT 'Black Market Fence',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Black Market NPC configuration';

-- Insert Black Market locations (Red Zones)
INSERT INTO `black_market_locations` (`map`, `zone`, `x`, `y`, `z`, `o`, `name`, `weight`) VALUES
-- Stranglethorn Vale (Red Zone)
(0, 33, -14457.0, 419.0, 22.0, 0.0, 'Booty Bay (STV)', 3),
(0, 33, -12345.0, 1850.0, 3.0, 0.0, 'Gurubashi Arena (STV)', 2),
-- Eastern Plaguelands (Deep Red)
(0, 139, 2274.0, -5310.0, 87.0, 0.0, 'Tyr\'s Hand (EPL)', 2),
(0, 139, 2300.0, -4610.0, 76.0, 0.0, 'Light\'s Hope Chapel (EPL)', 1),
-- Western Plaguelands
(0, 28, 1743.0, -1723.0, 60.0, 0.0, 'Andorhal (WPL)', 1),
-- Alterac Mountains
(0, 36, 275.0, -2100.0, 120.0, 0.0, 'Alterac Valley (Alterac)', 1);

-- Initialize Black Market (spawn in first location)
INSERT INTO `black_market_config` (
    `name`, `current_location_map`, `current_location_zone`, 
    `current_location_x`, `current_location_y`, `current_location_z`, `current_location_o`,
    `rotation_interval_hours`, `next_rotation_time`, `enabled`
) VALUES (
    'The Shadow Market', 0, 33, -14457.0, 419.0, 22.0, 0.0,
    168, UNIX_TIMESTAMP() + 604800, 1  -- Start in Booty Bay, rotate in 7 days
);

-- Create Black Market Fence NPC
DELETE FROM `creature_template` WHERE `entry` = 90080;
INSERT INTO `creature_template` (
    `entry`, `modelid_A`, `modelid_H`, `name`, `subname`, `IconName`, `gossip_menu_id`,
    `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`,
    `scale`, `rank`, `dmgschool`, `baseattacktime`, `rangeattacktime`, `unit_class`,
    `unit_flags`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `minrangedmg`, `maxrangedmg`, `rangedattackpower`, `type`, `type_flags`,
    `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`,
    `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`,
    `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`,
    `InhabitType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`,
    `DamageModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`,
    `mechanic_immune_mask`, `flags_extra`, `ScriptName`
) VALUES (
    90080, 1298, 1298, 'Black Market Fence', 'Stolen Goods', NULL, 90080,
    60, 60, 0, 35, 1, 1.0, 1.14286,
    1.0, 0, 0, 2000, 2000, 1,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 7, 0,
    0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, '', 0,
    3, 1.0, 1.0, 1.0, 1.0,
    1.0, 1.0, 0, 0, 1,
    0, 0, ''
);

