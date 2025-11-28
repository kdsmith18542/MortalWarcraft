-- ==================================================
-- Project Mortal Warcraft
-- Feature: Factions & Standing System
-- Description: World Factions (Syndicate-style) system with standing/reputation
-- Based on: docs/specs/51-factions-and-standing-system.md
-- ==================================================

-- Faction Definitions
CREATE TABLE IF NOT EXISTS `mortal_factions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(32) NOT NULL UNIQUE COMMENT 'IRON_LEDGER, ORDER_OF_SHRINE, BLACK_SUN_CARTEL, RANGERS_PACT',
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `icon` VARCHAR(128) NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_code` (`code`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Faction definitions';

-- Faction Standing Per Character
CREATE TABLE IF NOT EXISTS `mortal_faction_standing` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `faction_id` INT UNSIGNED NOT NULL,
    `standing` INT NOT NULL DEFAULT 0 COMMENT '-100000 to +100000',
    `last_update` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_guid_faction` (`guid`, `faction_id`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_faction` (`faction_id`),
    INDEX `idx_standing` (`standing`),
    CONSTRAINT `fk_mortal_faction_standing_faction`
        FOREIGN KEY (`faction_id`) REFERENCES `mortal_factions` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player faction standing';

-- Faction Rewards (Vendor Unlocks)
CREATE TABLE IF NOT EXISTS `mortal_faction_rewards` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `faction_id` INT UNSIGNED NOT NULL,
    `rank_required` VARCHAR(32) NOT NULL COMMENT 'FRIENDLY, HONORED, REVERED, EXALTED',
    `reward_type` VARCHAR(32) NOT NULL COMMENT 'ITEM, RECIPE, AURA, TITLE, EMOTE',
    `reward_ref` VARCHAR(64) NOT NULL COMMENT 'item entry, spell id, title id, etc.',
    `cost_gold` INT UNSIGNED NOT NULL DEFAULT 0,
    `cost_token_id` INT UNSIGNED NULL COMMENT 'optional specific token',
    `cost_token_amt` INT UNSIGNED NULL,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    `notes` VARCHAR(255) NULL,
    INDEX `idx_faction_rank` (`faction_id`, `rank_required`),
    CONSTRAINT `fk_mortal_faction_rewards_faction`
        FOREIGN KEY (`faction_id`) REFERENCES `mortal_factions` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Faction vendor rewards';

-- Character Primary Allegiance (Pledge)
CREATE TABLE IF NOT EXISTS `mortal_faction_allegiance` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL,
    `faction_id` INT UNSIGNED NOT NULL COMMENT 'Primary pledged faction',
    `pledged_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `last_switch_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `switch_cooldown_until` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '7 day cooldown',
    UNIQUE KEY `uk_guid` (`guid`),
    INDEX `idx_faction` (`faction_id`),
    CONSTRAINT `fk_mortal_faction_allegiance_faction`
        FOREIGN KEY (`faction_id`) REFERENCES `mortal_factions` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Character primary faction allegiance';

-- Seed Data: Initial Factions
INSERT INTO `mortal_factions` (`code`, `name`, `description`, `icon`, `is_active`) VALUES
('IRON_LEDGER', 'The Iron Ledger', 'Merchants, traders, and economic power brokers. Focus on trade, commerce, and economic dominance.', 'faction_iron_ledger', 1),
('ORDER_OF_SHRINE', 'Order of the Shrine', 'Guardians of Shrines, anti-undead, soul-keepers. Focus on defending settlements and cleansing corruption.', 'faction_order_shrine', 1),
('BLACK_SUN_CARTEL', 'Black Sun Cartel', 'Smugglers, fences, and black market brokers. Focus on illicit trade, Red Zone commerce, and criminal enterprise.', 'faction_black_sun', 1),
('RANGERS_PACT', 'Rangers'' Pact', 'Scouts, explorers, Rift delvers, Hellgate runners. Focus on exploration, anomalies, and wilderness survival.', 'faction_rangers', 1)
ON DUPLICATE KEY UPDATE 
    `name` = VALUES(`name`),
    `description` = VALUES(`description`);

-- Helper function to get standing rank
-- Standing ranges:
-- Hated: -100000 to -60001
-- Hostile: -60000 to -30001
-- Unfriendly: -30000 to -1
-- Neutral: 0 to 2999
-- Friendly: 3000 to 8999
-- Honored: 9000 to 20999
-- Revered: 21000 to 41999
-- Exalted: 42000 to 100000

-- Summary
SELECT 
    'Factions System Created' as summary,
    COUNT(*) as total_factions,
    SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_factions
FROM mortal_factions;

