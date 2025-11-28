-- ==================================================
-- Project Mortal Warcraft
-- Feature: Contract Crates
-- Description: Sealed crate definitions for courier contracts
-- Spec: 13-caravans-contracts.md
-- ==================================================

-- Contract crate definitions
CREATE TABLE IF NOT EXISTS `mortal_contract_crates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `crate_entry` INT UNSIGNED NOT NULL COMMENT 'Item entry for sealed crate',
    `contract_id` INT UNSIGNED NOT NULL COMMENT 'FK to courier_contracts',
    `weight` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Weight in units',
    `cannot_open` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Crate cannot be opened',
    `binds_to_courier` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Binds to courier until delivery',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_contract` (`contract_id`),
    KEY `idx_crate_entry` (`crate_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Note: The sealed crate item entry (900004) is already defined in courier_contracts.lua
-- This table tracks crate instances and their properties

