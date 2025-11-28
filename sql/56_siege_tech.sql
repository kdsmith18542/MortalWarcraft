-- ==================================================
-- Project Mortal Warcraft
-- Feature: Siege Tech (Honor Overhaul)
-- Description: Honor Points become "Military Credits" for siege equipment
-- ==================================================

-- Siege Equipment Blueprints
CREATE TABLE IF NOT EXISTS `siege_blueprints` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'Blueprint name',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item ID for the blueprint',
  `military_credits_cost` INT UNSIGNED NOT NULL COMMENT 'Cost in Military Credits',
  `description` TEXT COMMENT 'Blueprint description',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is this blueprint available?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_item` (`item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege equipment blueprints';

-- Base Defenses (Guard Spawners, etc.)
CREATE TABLE IF NOT EXISTS `base_defenses` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT 'Defense name',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item ID for the defense',
  `military_credits_cost` INT UNSIGNED NOT NULL COMMENT 'Cost in Military Credits',
  `creature_entry` INT UNSIGNED NULL COMMENT 'Creature spawned by this defense',
  `description` TEXT COMMENT 'Defense description',
  `enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is this defense available?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_item` (`item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Base defense items';

-- Player Military Credits (stored per character)
-- Note: Honor Points are converted to Military Credits
CREATE TABLE IF NOT EXISTS `character_military_credits` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `credits` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Military Credits balance',
  `total_earned` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total credits earned (lifetime)',
  `last_updated` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of last update',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player Military Credits balance';

-- Insert Siege Equipment Blueprints
INSERT INTO `siege_blueprints` (`name`, `item_entry`, `military_credits_cost`, `description`, `enabled`) VALUES
('Meat Wagon Blueprint', 90020, 5000, 'Allows construction of Meat Wagons for siege warfare', 1),
('Cannon Blueprint', 90021, 7500, 'Allows construction of Cannons for breaking walls', 1),
('Battering Ram Blueprint', 90022, 3000, 'Allows construction of Battering Rams for gates', 1),
('Siege Tower Blueprint', 90023, 10000, 'Allows construction of Siege Towers for scaling walls', 1);

-- Insert Base Defenses
INSERT INTO `base_defenses` (`name`, `item_entry`, `military_credits_cost`, `creature_entry`, `description`, `enabled`) VALUES
('Guard Spawner', 90030, 2000, 50001, 'Spawns a guard NPC to defend your stronghold', 1),
('Archer Tower', 90031, 4000, 50002, 'Spawns an archer tower for ranged defense', 1),
('Barricade', 90032, 1500, 50003, 'Creates a barricade to block enemy movement', 1),
('Watchtower', 90033, 3000, 50004, 'Provides vision and early warning', 1);

-- Create Siege Equipment Items
-- Meat Wagon
DELETE FROM `item_template` WHERE `entry` = 90020;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, 
    `BuyPrice`, `SellPrice`, `InventoryType`, `stackable`, `bonding`, `description`
) VALUES (
    90020, 9, 0, 'Meat Wagon Blueprint', 1390, 3, 0,
    0, 0, 0, 1, 0, 'Blueprint for constructing Meat Wagons. Requires Military Credits to purchase.'
);

-- Cannon
DELETE FROM `item_template` WHERE `entry` = 90021;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, 
    `BuyPrice`, `SellPrice`, `InventoryType`, `stackable`, `bonding`, `description`
) VALUES (
    90021, 9, 0, 'Cannon Blueprint', 1390, 3, 0,
    0, 0, 0, 1, 0, 'Blueprint for constructing Cannons. Requires Military Credits to purchase.'
);

-- Battering Ram
DELETE FROM `item_template` WHERE `entry` = 90022;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, 
    `BuyPrice`, `SellPrice`, `InventoryType`, `stackable`, `bonding`, `description`
) VALUES (
    90022, 9, 0, 'Battering Ram Blueprint', 1390, 3, 0,
    0, 0, 0, 1, 0, 'Blueprint for constructing Battering Rams. Requires Military Credits to purchase.'
);

-- Siege Tower
DELETE FROM `item_template` WHERE `entry` = 90023;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, 
    `BuyPrice`, `SellPrice`, `InventoryType`, `stackable`, `bonding`, `description`
) VALUES (
    90023, 9, 0, 'Siege Tower Blueprint', 1390, 3, 0,
    0, 0, 0, 1, 0, 'Blueprint for constructing Siege Towers. Requires Military Credits to purchase.'
);

-- Base Defense Items
DELETE FROM `item_template` WHERE `entry` IN (90030, 90031, 90032, 90033);
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, 
    `BuyPrice`, `SellPrice`, `InventoryType`, `stackable`, `bonding`, `description`
) VALUES
(90030, 9, 0, 'Guard Spawner', 1390, 2, 0, 0, 0, 0, 1, 0, 'Spawns a guard to defend your stronghold. Requires Military Credits.'),
(90031, 9, 0, 'Archer Tower', 1390, 2, 0, 0, 0, 0, 1, 0, 'Spawns an archer tower for defense. Requires Military Credits.'),
(90032, 9, 0, 'Barricade', 1390, 2, 0, 0, 0, 0, 1, 0, 'Creates a barricade. Requires Military Credits.'),
(90033, 9, 0, 'Watchtower', 1390, 2, 0, 0, 0, 0, 1, 0, 'Provides vision and warning. Requires Military Credits.');

