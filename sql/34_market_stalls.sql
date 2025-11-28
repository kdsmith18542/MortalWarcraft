-- ==================================================
-- Project Mortal Warcraft
-- Feature: Market Stalls (Player Vendors)
-- Description: Physical stalls in cities; buyers must visit to see inventory
-- ==================================================

-- Market Stalls Table
-- Tracks player-owned vendor stalls in cities
CREATE TABLE IF NOT EXISTS `market_stalls` (
    `stall_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `owner_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID who owns this stall',
    `stall_name` VARCHAR(100) NOT NULL DEFAULT 'Player Stall',
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'NPC entry for the stall vendor',
    `creature_guid` INT UNSIGNED DEFAULT NULL COMMENT 'Spawned creature GUID (if spawned)',
    `map_id` SMALLINT UNSIGNED NOT NULL,
    `zone_id` SMALLINT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `o` FLOAT NOT NULL DEFAULT 0,
    `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=active, 0=closed',
    `rent_cost` INT UNSIGNED NOT NULL DEFAULT 100000 COMMENT 'Daily rent in copper (10 gold default)',
    `rent_due` TIMESTAMP NOT NULL DEFAULT 0 COMMENT 'When rent is next due',
    `created_at` TIMESTAMP NOT NULL DEFAULT 0,
    PRIMARY KEY (`stall_id`),
    KEY `idx_owner` (`owner_guid`),
    KEY `idx_location` (`map_id`, `zone_id`),
    KEY `idx_creature` (`creature_entry`, `creature_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player-owned market stalls';

-- Market Stall Items Table
-- Items for sale at each stall
CREATE TABLE IF NOT EXISTS `market_stall_items` (
    `stall_id` INT UNSIGNED NOT NULL,
    `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Vendor slot (0-39)',
    `item_entry` INT UNSIGNED NOT NULL,
    `item_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `price` INT UNSIGNED NOT NULL COMMENT 'Price in copper',
    `max_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Max items in this slot',
    `current_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Current stock',
    PRIMARY KEY (`stall_id`, `slot`),
    KEY `idx_item` (`item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Items for sale at market stalls';

-- Market Stall Transactions Table
-- Log of all purchases for tracking
CREATE TABLE IF NOT EXISTS `market_stall_transactions` (
    `transaction_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `stall_id` INT UNSIGNED NOT NULL,
    `buyer_guid` INT UNSIGNED NOT NULL,
    `seller_guid` INT UNSIGNED NOT NULL COMMENT 'Stall owner',
    `item_entry` INT UNSIGNED NOT NULL,
    `item_count` INT UNSIGNED NOT NULL,
    `price_paid` INT UNSIGNED NOT NULL,
    `transaction_time` TIMESTAMP NOT NULL DEFAULT 0,
    PRIMARY KEY (`transaction_id`),
    KEY `idx_stall` (`stall_id`),
    KEY `idx_buyer` (`buyer_guid`),
    KEY `idx_seller` (`seller_guid`),
    KEY `idx_time` (`transaction_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Market stall purchase history';

-- Market Stall Locations (Pre-defined stall spots in cities)
-- These are physical locations where players can rent stalls
CREATE TABLE IF NOT EXISTS `market_stall_locations` (
    `location_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `map_id` SMALLINT UNSIGNED NOT NULL,
    `zone_id` SMALLINT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `o` FLOAT NOT NULL DEFAULT 0,
    `is_occupied` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `stall_id` INT UNSIGNED DEFAULT NULL COMMENT 'Currently rented stall',
    `rent_cost` INT UNSIGNED NOT NULL DEFAULT 100000 COMMENT 'Daily rent in copper',
    PRIMARY KEY (`location_id`),
    KEY `idx_location` (`map_id`, `zone_id`),
    KEY `idx_occupied` (`is_occupied`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Available stall locations in cities';

-- Insert default stall locations in major cities
-- Stormwind Market District
INSERT INTO `market_stall_locations` (`map_id`, `zone_id`, `x`, `y`, `z`, `o`, `rent_cost`) VALUES
(0, 1519, -8825.0, 640.0, 96.0, 0.0, 100000),  -- Stormwind Market
(0, 1519, -8820.0, 640.0, 96.0, 0.0, 100000),
(0, 1519, -8815.0, 640.0, 96.0, 0.0, 100000),
(0, 1519, -8810.0, 640.0, 96.0, 0.0, 100000)
ON DUPLICATE KEY UPDATE `rent_cost` = VALUES(`rent_cost`);

-- Orgrimmar Valley of Strength
INSERT INTO `market_stall_locations` (`map_id`, `zone_id`, `x`, `y`, `z`, `o`, `rent_cost`) VALUES
(1, 1637, 1550.0, -4410.0, 10.0, 0.0, 100000),  -- Orgrimmar Market
(1, 1637, 1555.0, -4410.0, 10.0, 0.0, 100000),
(1, 1637, 1560.0, -4410.0, 10.0, 0.0, 100000),
(1, 1637, 1565.0, -4410.0, 10.0, 0.0, 100000)
ON DUPLICATE KEY UPDATE `rent_cost` = VALUES(`rent_cost`);

-- Ironforge Great Forge
INSERT INTO `market_stall_locations` (`map_id`, `zone_id`, `x`, `y`, `z`, `o`, `rent_cost`) VALUES
(0, 1537, -4800.0, -1100.0, 500.0, 0.0, 100000),
(0, 1537, -4795.0, -1100.0, 500.0, 0.0, 100000),
(0, 1537, -4790.0, -1100.0, 500.0, 0.0, 100000)
ON DUPLICATE KEY UPDATE `rent_cost` = VALUES(`rent_cost`);

-- Booty Bay (Neutral)
INSERT INTO `market_stall_locations` (`map_id`, `zone_id`, `x`, `y`, `z`, `o`, `rent_cost`) VALUES
(0, 3483, -14400.0, 400.0, 5.0, 0.0, 150000),  -- Higher rent for neutral zone
(0, 3483, -14395.0, 400.0, 5.0, 0.0, 150000),
(0, 3483, -14390.0, 400.0, 5.0, 0.0, 150000)
ON DUPLICATE KEY UPDATE `rent_cost` = VALUES(`rent_cost`);

