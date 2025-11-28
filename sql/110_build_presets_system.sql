-- ==================================================
-- Project Mortal Warcraft
-- Feature: Build Presets & Loadouts
-- Description: Build preset system for attributes, masteries, gear, and runes
-- Based on: docs/specs/55-build-presets-and-loadouts.md
-- ==================================================

-- Build Presets
CREATE TABLE IF NOT EXISTS `mortal_build_presets` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `preset_name` VARCHAR(64) NOT NULL,
    `preset_type` VARCHAR(32) NOT NULL COMMENT 'PVE_RAID, PVP_ARENA, PVP_WARFRONT, PVE_DELVE, etc.',
    `attributes_json` JSON NULL COMMENT 'Attribute allocation (str, agi, sta, int)',
    `mastery_trees_json` JSON NULL COMMENT 'Mastery tree selections',
    `gear_set_json` JSON NULL COMMENT 'Desired item IDs for each slot',
    `runic_layout_json` JSON NULL COMMENT 'Rune and augment layout',
    `is_active` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Currently active preset',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_guid` (`guid`),
    INDEX `idx_type` (`preset_type`),
    INDEX `idx_active` (`guid`, `is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Build presets per character';

-- Preset Sharing (Optional - for faction/season sharing)
CREATE TABLE IF NOT EXISTS `mortal_build_preset_sharing` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `preset_id` INT UNSIGNED NOT NULL,
    `shared_with_type` VARCHAR(32) NOT NULL COMMENT 'FACTION, SEASON, PUBLIC',
    `shared_with_ref` VARCHAR(64) NULL COMMENT 'Faction ID, Season ID, or NULL for public',
    `shared_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `view_count` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_preset` (`preset_id`),
    INDEX `idx_shared_type` (`shared_with_type`),
    CONSTRAINT `fk_mortal_build_preset_sharing_preset`
        FOREIGN KEY (`preset_id`) REFERENCES `mortal_build_presets` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Build preset sharing';

-- Summary
SELECT 
    'Build Presets System Created' as summary,
    'Ready for preset creation' as status;

