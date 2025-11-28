-- ==================================================
-- Project Mortal Warcraft
-- Feature: Insurance Vouchers System
-- Description: Economy-safe softening of loss (EVE-style insurance)
-- Based on: docs/specs/45-eldens-eve-layer.md
-- ==================================================

-- Insurance Policies
-- Active insurance policies on items
CREATE TABLE IF NOT EXISTS `mortal_insurance_policies` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `item_guid` INT UNSIGNED NOT NULL COMMENT 'item_instance.guid',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry',
    `policy_type` VARCHAR(32) NOT NULL COMMENT 'MATERIAL_REBATE, CRAFTING_DISCOUNT',
    `premium_paid` INT UNSIGNED NOT NULL COMMENT 'Gold paid for insurance',
    `material_value_base` INT UNSIGNED NOT NULL COMMENT 'Base material value',
    `rebate_percentage` TINYINT UNSIGNED NOT NULL DEFAULT 50 COMMENT 'Percentage of material value returned',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `expires_at` INT UNSIGNED NULL COMMENT 'NULL = permanent until item lost',
    `status` VARCHAR(16) NOT NULL DEFAULT 'active' COMMENT 'active, claimed, expired',
    INDEX `idx_guid` (`guid`),
    INDEX `idx_item` (`item_guid`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Insurance policies';

-- Insurance Claims
-- Claims made when insured items are lost
CREATE TABLE IF NOT EXISTS `mortal_insurance_claims` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `policy_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_insurance_policies.id',
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `item_entry` INT UNSIGNED NOT NULL,
    `item_name` VARCHAR(255) NOT NULL,
    `death_timestamp` INT UNSIGNED NOT NULL,
    `death_zone_id` INT UNSIGNED NOT NULL,
    `material_vouchers_json` TEXT NULL COMMENT 'JSON array of material vouchers',
    `rebate_amount` INT UNSIGNED NOT NULL COMMENT 'Total rebate in copper',
    `claimed_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `status` VARCHAR(16) NOT NULL DEFAULT 'pending' COMMENT 'pending, processed, expired',
    INDEX `idx_policy` (`policy_id`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_status` (`status`),
    FOREIGN KEY (`policy_id`) REFERENCES `mortal_insurance_policies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Insurance claims';

-- Material Vouchers
-- Vouchers redeemable for materials
CREATE TABLE IF NOT EXISTS `mortal_material_vouchers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `material_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry for material',
    `material_name` VARCHAR(255) NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    `source_claim_id` INT UNSIGNED NULL COMMENT 'FK to mortal_insurance_claims.id',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `redeemed_at` INT UNSIGNED NULL,
    `expires_at` INT UNSIGNED NULL COMMENT 'NULL = no expiration',
    `status` VARCHAR(16) NOT NULL DEFAULT 'active' COMMENT 'active, redeemed, expired',
    INDEX `idx_guid` (`guid`),
    INDEX `idx_status` (`status`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Material vouchers';

