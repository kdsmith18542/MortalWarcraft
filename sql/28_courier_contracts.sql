-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Courier Contracts (EVE-Style Logistics)
-- Description: Players can issue hauling contracts. Accepting places items in a sealed crate.
--              Requires collateral. Delivery = reward + collateral. Failure = owner keeps collateral.
-- ==================================================

-- WARNING: This script creates new database tables in azerothcore_characters.
-- Make sure you have a database backup before running this!

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. COURIER CONTRACTS TABLE
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `courier_contracts` (
    `contract_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `issuer_guid` INT UNSIGNED NOT NULL COMMENT 'Player who created the contract',
    `acceptor_guid` INT UNSIGNED DEFAULT NULL COMMENT 'Player who accepted (NULL = open)',
    `status` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Open, 1=In Transit, 2=Delivered, 3=Failed, 4=Cancelled',
    `origin_zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID where items are stored',
    `destination_zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID where items must be delivered',
    `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gold reward for delivery',
    `collateral_gold` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gold required to accept (insurance)',
    `created_time` TIMESTAMP NOT NULL DEFAULT 0,
    `accepted_time` TIMESTAMP NULL DEFAULT NULL,
    `completed_time` TIMESTAMP NULL DEFAULT NULL,
    `expiry_time` TIMESTAMP NULL DEFAULT NULL COMMENT 'Contract expires if not accepted by this time',
    PRIMARY KEY (`contract_id`),
    KEY `idx_issuer` (`issuer_guid`),
    KEY `idx_acceptor` (`acceptor_guid`),
    KEY `idx_status` (`status`),
    KEY `idx_expiry` (`expiry_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------
-- 2. COURIER CONTRACT ITEMS TABLE
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `courier_contract_items` (
    `contract_id` INT UNSIGNED NOT NULL,
    `item_guid` BIGINT UNSIGNED NOT NULL COMMENT 'Item GUID in character_regional_bank',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item template entry',
    `item_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Slot in sealed crate',
    PRIMARY KEY (`contract_id`, `slot`),
    KEY `idx_contract` (`contract_id`),
    KEY `idx_item_guid` (`item_guid`),
    CONSTRAINT `fk_contract_items_contract` FOREIGN KEY (`contract_id`) 
        REFERENCES `courier_contracts` (`contract_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;

-- Report results
SELECT 'Courier Contracts schema created successfully.' AS result;
SELECT 'Created tables: courier_contracts, courier_contract_items' AS result;
SELECT 'Note: Sealed Courier Crate item (Entry 90000) must be created in azerothcore_world using 28_courier_contracts_item.sql' AS result;
