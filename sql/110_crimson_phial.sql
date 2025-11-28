-- ==================================================
-- Project Mortal Warcraft
-- Feature: Crimson Phial System
-- Description: Refillable healing flask system (Elden Ring-inspired)
-- Spec: 21-elden-systems.md
-- ==================================================

-- Crimson Phial Character State Table
CREATE TABLE IF NOT EXISTS `mortal_crimson_phial` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Player GUID',
    `max_charges` TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT 'Base 3 + mastery bonuses',
    `current_charges` TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT 'Current available charges',
    `last_refill_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last refill',
    FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Crimson Phial charge tracking';

-- Feature Flags (if not already in mortal_feature_flags)
-- These should be added to mortal_feature_flags table:
-- INSERT INTO mortal_feature_flags (flag_key, flag_value, description) VALUES
-- ('flask_heal_percent', '0.40', 'Percentage of max HP healed per charge (0.0-1.0)'),
-- ('flask_base_charges', '3', 'Base number of charges'),
-- ('flask_cd_seconds', '20', 'Cooldown between charge uses in seconds'),
-- ('flask_hardcore_drop_empty', '0', 'If 1, phial drops empty on death in Red zones');

