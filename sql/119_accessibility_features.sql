-- ==================================================
-- Project Mortal Warcraft
-- Feature: Accessibility Features
-- Description: Accessibility settings and UX enhancements
-- Based on: docs/specs/44-accessibility-and-ux-guidelines.md
-- ==================================================

-- Player Accessibility Settings
CREATE TABLE IF NOT EXISTS `mortal_accessibility_settings` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `setting_category` VARCHAR(32) NOT NULL COMMENT 'VISUAL, AUDIO, INPUT, UI',
    `setting_key` VARCHAR(64) NOT NULL,
    `setting_value` TEXT NOT NULL COMMENT 'JSON or string value',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_guid_category_key` (`guid`, `setting_category`, `setting_key`),
    INDEX `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player accessibility settings';

-- UI Presets (for quick accessibility setup)
CREATE TABLE IF NOT EXISTS `mortal_ui_presets` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `preset_name` VARCHAR(64) NOT NULL,
    `preset_type` VARCHAR(32) NOT NULL COMMENT 'DEFAULT, HIGH_CONTRAST, LARGE_TEXT, MINIMAL',
    `description` TEXT NULL,
    `settings_json` JSON NOT NULL COMMENT 'Complete UI settings',
    `is_default` TINYINT(1) NOT NULL DEFAULT 0,
    `is_public` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if available to all players',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_type` (`preset_type`),
    INDEX `idx_default` (`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='UI accessibility presets';

-- Seed Data: Default Presets
INSERT INTO `mortal_ui_presets` (`preset_name`, `preset_type`, `description`, `settings_json`, `is_default`, `is_public`) VALUES
('Default', 'DEFAULT', 'Standard UI settings', '{"text_size": "normal", "contrast": "normal", "ui_scale": 1.0}', 1, 1),
('High Contrast', 'HIGH_CONTRAST', 'High contrast mode for better visibility', '{"text_size": "normal", "contrast": "high", "ui_scale": 1.0, "color_blind_mode": false}', 0, 1),
('Large Text', 'LARGE_TEXT', 'Larger text and UI elements', '{"text_size": "large", "contrast": "normal", "ui_scale": 1.2}', 0, 1),
('Minimal UI', 'MINIMAL', 'Minimal UI for reduced clutter', '{"text_size": "normal", "contrast": "normal", "ui_scale": 1.0, "hide_chat": false, "hide_actionbars": false}', 0, 1)
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

-- Summary
SELECT 
    'Accessibility Features Created' as summary,
    COUNT(*) as ui_presets,
    'Accessibility settings ready' as status
FROM mortal_ui_presets;

