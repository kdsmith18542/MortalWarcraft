-- ==================================================
-- Project Mortal Warcraft
-- Feature: Vanity Pet to Companion Conversion
-- Description: Database schema for converting vanity pet spells to companion items
-- Spec: 29-companion-bond-and-mercenary-system.md section 4.4
-- ==================================================

-- Vanity Pet Spell to Companion Item Mapping
CREATE TABLE IF NOT EXISTS `mortal_vanity_pet_conversions` (
    `spell_id` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Original WoW vanity pet spell ID',
    `companion_item_entry` INT UNSIGNED NOT NULL COMMENT 'Companion item entry that replaces the pet spell',
    `pet_name` VARCHAR(100) NOT NULL COMMENT 'Pet name for reference',
    `companion_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Vanity Companion (cosmetic only)',
    `notes` TEXT NULL COMMENT 'Conversion notes',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_companion_item` (`companion_item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Vanity pet spell to companion item conversion mapping';

-- Example conversions (to be populated with actual spell/item IDs)
-- These are placeholders - actual IDs will be determined during content conversion
INSERT INTO `mortal_vanity_pet_conversions` (`spell_id`, `companion_item_entry`, `pet_name`, `companion_type`, `notes`) VALUES
-- Classic Vanity Pets (examples - actual IDs needed)
(26533, 70001, 'Penguin', 0, 'Classic vanity pet - cosmetic companion'),
(26529, 70002, 'Mechanical Squirrel', 0, 'Classic vanity pet - cosmetic companion'),
(26541, 70003, 'Worg Pup', 0, 'Classic vanity pet - cosmetic companion')

ON DUPLICATE KEY UPDATE `pet_name` = VALUES(`pet_name`);

-- Note: This table will be populated during content conversion phase
-- All WoW 3.3.5a vanity pet spells will be mapped to companion items

