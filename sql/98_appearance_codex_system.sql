-- ==================================================
-- Project Mortal Warcraft
-- Feature: Appearance Codex & Transmog
-- Description: Modern collection-style appearance system with transmog rules
-- Based on: docs/specs/57-appearance-codex-and-transmog.md
-- ==================================================

-- Appearance Definitions
CREATE TABLE IF NOT EXISTS `mortal_appearances` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'APP_MORTAL_T1_SWORD_01',
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NULL,
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'base item_template.entry providing this look',
    `slot_id` TINYINT UNSIGNED NOT NULL COMMENT 'equipment slot',
    `category` VARCHAR(32) NOT NULL COMMENT 'ARMOR, WEAPON, MOUNT, PET',
    `source_type` VARCHAR(32) NOT NULL COMMENT 'DUNGEON, RAID, FACTION, EVENT, SEASON, CRAFTED',
    `source_tag` VARCHAR(64) NULL COMMENT 'e.g. ICC_10N, IRON_LEDGER',
    `rarity` VARCHAR(16) NOT NULL DEFAULT 'COMMON' COMMENT 'cosmetic rarity',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_item_entry` (`item_entry`),
    INDEX `idx_slot` (`slot_id`),
    INDEX `idx_category` (`category`),
    INDEX `idx_source` (`source_type`, `source_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Appearance definitions mapped to items';

-- Character Appearance Unlocks
CREATE TABLE IF NOT EXISTS `mortal_appearance_unlocks` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `appearance_id` INT UNSIGNED NOT NULL,
    `unlocked_ts` INT UNSIGNED NOT NULL,
    `unlock_source` VARCHAR(32) NOT NULL COMMENT 'EQUIP, SALVAGE, REWARD, PURCHASE',
    UNIQUE KEY `uniq_guid_appearance` (`guid`, `appearance_id`),
    CONSTRAINT `fk_mortal_appearance_unlocks_app`
        FOREIGN KEY (`appearance_id`) REFERENCES `mortal_appearances`(`id`)
        ON DELETE CASCADE,
    INDEX `idx_guid` (`guid`),
    INDEX `idx_unlock_source` (`unlock_source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Character appearance unlock records';

-- Active Transmog State
CREATE TABLE IF NOT EXISTS `mortal_transmog_state` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `slot_id` TINYINT UNSIGNED NOT NULL COMMENT 'equipment slot',
    `appearance_id` INT UNSIGNED NULL COMMENT 'NULL = no transmog',
    `last_update_ts` INT UNSIGNED NOT NULL,
    UNIQUE KEY `uniq_guid_slot` (`guid`, `slot_id`),
    CONSTRAINT `fk_mortal_transmog_state_app`
        FOREIGN KEY (`appearance_id`) REFERENCES `mortal_appearances`(`id`)
        ON DELETE SET NULL,
    INDEX `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Active transmog state per character slot';

