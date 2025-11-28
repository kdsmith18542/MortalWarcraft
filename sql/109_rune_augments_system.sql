-- ==================================================
-- Project Mortal Warcraft
-- Feature: Rune Augments & Gear Build System
-- Description: Rune slots, augment cards, and gear enhancement system
-- Based on: docs/specs/53-rune-augments-and-gear-build-system.md
-- ==================================================

-- Gear Socket Definitions
CREATE TABLE IF NOT EXISTS `mortal_gear_sockets` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry',
    `rune_slots` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `augment_slots` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `max_offense_augments` TINYINT UNSIGNED NOT NULL DEFAULT 2,
    `max_defense_augments` TINYINT UNSIGNED NOT NULL DEFAULT 2,
    `max_utility_augments` TINYINT UNSIGNED NOT NULL DEFAULT 2,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_item_entry` (`item_entry`),
    INDEX `idx_rune_slots` (`rune_slots`),
    INDEX `idx_augment_slots` (`augment_slots`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Gear socket definitions';

-- Rune & Augment Definitions
CREATE TABLE IF NOT EXISTS `mortal_enhancements` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'RUNE_WHIRLWIND, AUG_STONE_BRACE',
    `name` VARCHAR(128) NOT NULL,
    `type` VARCHAR(16) NOT NULL COMMENT 'RUNE, AUGMENT',
    `category` VARCHAR(16) NULL COMMENT 'For augments: OFFENSE, DEFENSE, UTILITY',
    `affinity` VARCHAR(32) NULL COMMENT 'SWORD, SHIELD, PLATE, ANY',
    `description` TEXT NOT NULL,
    `icon` VARCHAR(128) NULL,
    `script_hook` VARCHAR(64) NULL COMMENT 'Link to Lua/C++ hooks',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_type` (`type`),
    INDEX `idx_category` (`category`),
    INDEX `idx_affinity` (`affinity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rune and augment definitions';

-- Socketed Enhancements on Items
CREATE TABLE IF NOT EXISTS `mortal_item_enhancements` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_guid` BIGINT UNSIGNED NOT NULL COMMENT 'Unique item instance guid',
    `slot_index` TINYINT UNSIGNED NOT NULL COMMENT '0..N-1 (runes: 0-3, augments: 10-19)',
    `enhancement_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_enhancements.id',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_item_guid` (`item_guid`),
    INDEX `idx_enhancement` (`enhancement_id`),
    CONSTRAINT `fk_mortal_item_enhancements_enh`
        FOREIGN KEY (`enhancement_id`) REFERENCES `mortal_enhancements` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Socketed enhancements on item instances';

-- Seed Data: Example Runes
INSERT INTO `mortal_enhancements` (`code`, `name`, `type`, `affinity`, `description`, `script_hook`, `is_active`) VALUES
('RUNE_WHIRLWIND', 'Rune of Whirlwind', 'RUNE', 'ANY', 'Grants Whirlwind ability - spin attack hitting nearby enemies', 'rune_whirlwind', 1),
('RUNE_BLINK', 'Rune of Blink', 'RUNE', 'ANY', 'Grants Blink ability - short-range teleport', 'rune_blink', 1),
('RUNE_GUARD_COUNTER', 'Rune of Guard Counter', 'RUNE', 'SHIELD', 'Grants Guard Counter ability - counter-attack after blocking', 'rune_guard_counter', 1),
('RUNE_THORNS', 'Rune of Thorns', 'RUNE', 'PLATE', 'Grants Thorns passive - reflect damage to attackers', 'rune_thorns', 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Seed Data: Example Augments
INSERT INTO `mortal_enhancements` (`code`, `name`, `type`, `category`, `affinity`, `description`, `script_hook`, `is_active`) VALUES
-- Offense Augments
('AUG_RAZOR_GALE', 'Razor Gale', 'AUGMENT', 'OFFENSE', 'SWORD', 'When using Whirlwind, apply a small Bleed (X over 4s)', 'aug_razor_gale', 1),
('AUG_MEASURED_STRIKES', 'Measured Strikes', 'AUGMENT', 'OFFENSE', 'ANY', 'Basic melee attacks gain +5% crit chance when above 80% stamina', 'aug_measured_strikes', 1),
('AUG_EXECUTIONER_EDGE', 'Executioner''s Edge', 'AUGMENT', 'OFFENSE', 'ANY', '+10% damage vs low-health enemies (<20%)', 'aug_executioner_edge', 1),
-- Defense Augments
('AUG_STONE_BRACE', 'Stone Brace', 'AUGMENT', 'DEFENSE', 'ANY', 'Brace reduces damage by an additional 10% vs the first hit during its window', 'aug_stone_brace', 1),
('AUG_IRON_WILL', 'Iron Will', 'AUGMENT', 'DEFENSE', 'ANY', 'Taking a Guard Counter opportunity grants +5% damage reduction for 3s', 'aug_iron_will', 1),
('AUG_SHRINEBOUND', 'Shrinebound', 'AUGMENT', 'DEFENSE', 'ANY', '+X% resistance to undead/holy damage near Shrines', 'aug_shrinebound', 1),
-- Utility Augments
('AUG_TRAILBLAZER', 'Trailblazer', 'AUGMENT', 'UTILITY', 'ANY', 'Slight movement speed bonus in wilderness zones', 'aug_trailblazer', 1),
('AUG_PACKRAT', 'Packrat', 'AUGMENT', 'UTILITY', 'ANY', '+5% carry capacity for materials (counted for encumbrance)', 'aug_packrat', 1),
('AUG_SMUGGLER_GUILE', 'Smuggler''s Guile', 'AUGMENT', 'UTILITY', 'ANY', 'Reduced gold loss on death by Y% (capped, tuned)', 'aug_smuggler_guile', 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Summary
SELECT 
    'Rune Augments System Created' as summary,
    COUNT(CASE WHEN type = 'RUNE' THEN 1 END) as total_runes,
    COUNT(CASE WHEN type = 'AUGMENT' THEN 1 END) as total_augments,
    COUNT(CASE WHEN type = 'AUGMENT' AND category = 'OFFENSE' THEN 1 END) as offense_augments,
    COUNT(CASE WHEN type = 'AUGMENT' AND category = 'DEFENSE' THEN 1 END) as defense_augments,
    COUNT(CASE WHEN type = 'AUGMENT' AND category = 'UTILITY' THEN 1 END) as utility_augments
FROM mortal_enhancements;

