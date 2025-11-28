-- ==================================================
-- Project Mortal Warcraft
-- Feature: PvP Vendors & Rewards System
-- Description: Data-driven PvP item gating with rating requirements
-- Based on: docs/specs/35-mortal-pvp-vendors-and-rewards.md
-- ==================================================

-- PvP Item Requirements Table
-- Defines rating gates, bracket restrictions, and costs for PvP items
CREATE TABLE IF NOT EXISTS `mortal_pvp_item_requirements` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry (PvP piece)',
    `rating_band_code` VARCHAR(16) NULL COMMENT 'P1..P6 (optional tier code)',
    `min_rating` INT UNSIGNED NULL COMMENT 'Absolute rating floor (e.g. 1800)',
    `bracket_mask` TINYINT UNSIGNED NOT NULL DEFAULT 7 COMMENT '1=2s,2=3s,4=5s; 7=any bracket',
    `min_season_id` INT UNSIGNED NULL COMMENT 'Optional: season-specific pieces',
    `require_achievement` INT UNSIGNED NULL COMMENT 'Achievement id (if any)',
    `cost_tokens` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'PvP Tokens cost',
    `cost_credits` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Military Credits cost',
    `cost_commendations` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Warfront Commendations cost',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_item` (`item_entry`),
    INDEX `idx_rating_band` (`rating_band_code`),
    INDEX `idx_min_rating` (`min_rating`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PvP item requirements and costs';

-- Currency System Table
-- Stores PvP currencies per character
CREATE TABLE IF NOT EXISTS `mortal_currencies` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `currency_code` VARCHAR(32) NOT NULL COMMENT 'PVP_TOKEN, MILITARY_CREDIT, WARFRONT_COMM',
    `amount` INT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 ,
    UNIQUE KEY `uk_guid_currency` (`guid`, `currency_code`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_currency` (`currency_code`),
    FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player PvP currencies';

-- PvP Vendor NPC Assignments
-- Links NPCs to vendor types (Entry Combatant, Challenger, Elite, Warfront)
CREATE TABLE IF NOT EXISTS `mortal_pvp_vendors` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `npc_entry` INT UNSIGNED NOT NULL COMMENT 'creature_template.entry',
    `vendor_type` ENUM('entry', 'challenger', 'elite', 'warfront') NOT NULL,
    `tier_bands` VARCHAR(32) NULL COMMENT 'Comma-separated: P1,P2,P3 or P4,P5,P6',
    `location` VARCHAR(100) NULL COMMENT 'Hall of Champions, Hall of Blood, etc.',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_npc` (`npc_entry`),
    INDEX `idx_vendor_type` (`vendor_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='PvP vendor NPC assignments';

