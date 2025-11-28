-- ==================================================
-- Project Mortal Warcraft
-- Feature: Regional Tokens System
-- Description: Database schema for regional tokens (converted from emblems)
-- Spec: 04-economy.md section 5.5
-- ==================================================

-- Regional Tokens Definition Table
CREATE TABLE IF NOT EXISTS `mortal_regional_tokens` (
    `item_entry` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Item entry ID for the token',
    `name` VARCHAR(100) NOT NULL COMMENT 'Token name',
    `token_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Civic, 1=Faction, 2=Regional',
    `region_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID of the region this token belongs to',
    `region_name` VARCHAR(100) NOT NULL COMMENT 'Region name (e.g., Stormwind, Ironforge)',
    `tradeable` BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Can be traded between players',
    `stackable` BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Can stack in inventory',
    `max_stack` INT UNSIGNED NOT NULL DEFAULT 200 COMMENT 'Maximum stack size',
    `description` TEXT NULL COMMENT 'Token description',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_region_id` (`region_id`),
    INDEX `idx_token_type` (`token_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Regional token definitions';

-- Token Exchange Rates (for converting tokens to gold at regional vendors)
CREATE TABLE IF NOT EXISTS `mortal_token_exchange_rates` (
    `token_entry` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Token item entry',
    `region_id` INT UNSIGNED NOT NULL COMMENT 'Region where exchange is valid',
    `base_gold_rate` INT UNSIGNED NOT NULL DEFAULT 10 COMMENT 'Base gold per token (in copper, so 10 = 0.1 gold)',
    `faction_standing_bonus` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Bonus gold per 1000 faction standing (percentage)',
    `max_bonus` FLOAT NOT NULL DEFAULT 0.3 COMMENT 'Maximum bonus (30% = 0.3)',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`token_entry`) REFERENCES `mortal_regional_tokens`(`item_entry`) ON DELETE CASCADE,
    INDEX `idx_region_id` (`region_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Token exchange rates for regional vendors';

-- Example token entries (to be populated with actual item entries)
-- These are placeholders - actual item entries will be created in item_template
INSERT INTO `mortal_regional_tokens` (`item_entry`, `name`, `token_type`, `region_id`, `region_name`, `tradeable`, `stackable`, `max_stack`, `description`) VALUES
-- Civic Tokens (Major Cities)
(90001, 'Stormwind Token', 0, 1519, 'Stormwind City', TRUE, TRUE, 200, 'A token representing standing with Stormwind. Can be exchanged for goods and services.'),
(90002, 'Ironforge Token', 0, 1537, 'Ironforge', TRUE, TRUE, 200, 'A token representing standing with Ironforge. Can be exchanged for goods and services.'),
(90003, 'Orgrimmar Token', 0, 1637, 'Orgrimmar', TRUE, TRUE, 200, 'A token representing standing with Orgrimmar. Can be exchanged for goods and services.'),
(90004, 'Thunder Bluff Token', 0, 1638, 'Thunder Bluff', TRUE, TRUE, 200, 'A token representing standing with Thunder Bluff. Can be exchanged for goods and services.')

ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Example exchange rates
INSERT INTO `mortal_token_exchange_rates` (`token_entry`, `region_id`, `base_gold_rate`, `faction_standing_bonus`, `max_bonus`) VALUES
(90001, 1519, 1000, 0.05, 0.3), -- 10 gold base, 5% bonus per 1000 standing, max 30% bonus
(90002, 1537, 1000, 0.05, 0.3),
(90003, 1637, 1000, 0.05, 0.3),
(90004, 1638, 1000, 0.05, 0.3)

ON DUPLICATE KEY UPDATE `base_gold_rate` = VALUES(`base_gold_rate`);

