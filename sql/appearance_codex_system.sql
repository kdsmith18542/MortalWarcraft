-- ==================================================
-- Project Mortal Warcraft
-- Feature: Appearance Codex & Transmog System
-- Description: Database schema for appearance collection and transmog unlocks
-- Based on: spec 57
-- ==================================================

USE `azerothcore_world`;

-- Table for storing appearance definitions
CREATE TABLE IF NOT EXISTS `mortal_appearance_codex` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `item_display_id` INT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `category` ENUM('weapon', 'armor_head', 'armor_shoulder', 'armor_chest', 'armor_waist', 'armor_legs', 'armor_feet', 'armor_wrists', 'armor_hands', 'armor_back', 'armor_tabard') NOT NULL,
    `rarity` ENUM('common', 'uncommon', 'rare', 'epic', 'legendary') NOT NULL DEFAULT 'common',
    `unlock_method` ENUM('bind', 'salvage', 'reward', 'heirloom') NOT NULL,
    `zone_restrictions` JSON NULL COMMENT 'JSON array of zone IDs where appearance is restricted (e.g., Red zones)',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bit flags for special properties',
    PRIMARY KEY (`id`),
    INDEX `idx_display_id` (`item_display_id`),
    INDEX `idx_category` (`category`),
    INDEX `idx_rarity` (`rarity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for tracking player appearance unlocks
CREATE TABLE IF NOT EXISTS `mortal_player_appearance_unlocks` (
    `player_guid` INT UNSIGNED NOT NULL,
    `appearance_id` INT UNSIGNED NOT NULL,
    `unlocked_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`player_guid`, `appearance_id`),
    FOREIGN KEY (`appearance_id`) REFERENCES `mortal_appearance_codex`(`id`) ON DELETE CASCADE,
    INDEX `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for storing player's current transmog state
CREATE TABLE IF NOT EXISTS `mortal_player_appearance_state` (
    `player_guid` INT UNSIGNED NOT NULL,
    `equipment_slot` TINYINT UNSIGNED NOT NULL COMMENT 'Equipment slot 0-18',
-- Sample appearance data (placeholder display IDs - replace with actual WoW display IDs)
INSERT INTO `mortal_appearance_codex` (`item_display_id`, `name`, `category`, `rarity`, `unlock_method`, `zone_restrictions`, `flags`) VALUES
-- Common armor appearances
(1001, 'Worn Leather Helm', 'armor_head', 'common', 'bind', NULL, 0),
(1002, 'Rugged Chain Shoulders', 'armor_shoulder', 'common', 'bind', NULL, 0),
(1003, 'Sturdy Plate Chest', 'armor_chest', 'uncommon', 'salvage', NULL, 0),

-- Rare weapon appearances
(2001, 'Enchanted Sword', 'weapon', 'rare', 'reward', '[1, 12, 14]', 1), -- Restricted in Red zones (Dun Morogh, Elwynn Forest, Duskwood)
(2002, 'Mystic Staff', 'weapon', 'rare', 'heirloom', NULL, 0),

-- Epic armor appearances
(3001, 'Royal Crown', 'armor_head', 'epic', 'reward', '[1637]', 2), -- Restricted in Greycrag (custom zone)
(3002, 'Dragonscale Pauldrons', 'armor_shoulder', 'epic', 'salvage', NULL, 0),

-- Legendary appearances
(4001, 'Crown of the Immortal', 'armor_head', 'legendary', 'reward', '[1, 12, 14, 1637]', 4); -- Restricted in all Red zones
    `appearance_id` INT UNSIGNED NULL COMMENT 'Current appearance ID, NULL for no transmog',
    PRIMARY KEY (`player_guid`, `equipment_slot`),
    FOREIGN KEY (`appearance_id`) REFERENCES `mortal_appearance_codex`(`id`) ON DELETE SET NULL,
    INDEX `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;