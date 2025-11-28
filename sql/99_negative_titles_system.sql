-- ==================================================
-- Project Mortal Warcraft
-- Feature: Negative Titles & Notoriety Labels
-- Description: System-enforced negative title system for criminals and notoriety
-- Based on: docs/specs/56-negative-titles-and-notoriety-labels.md
-- ==================================================

-- Negative Title Definitions
CREATE TABLE IF NOT EXISTS `mortal_negative_titles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'NOTO_SCOURGE_FRONTIER, CRIME_GRAVE_ROBBER',
    `name` VARCHAR(128) NOT NULL COMMENT 'display name',
    `description` TEXT NOT NULL,
    `category` VARCHAR(16) NOT NULL COMMENT 'NOTORIETY, CRIME, FACTION',
    `priority` INT NOT NULL DEFAULT 0 COMMENT 'higher = overrides lower when multiple apply',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_category` (`category`),
    INDEX `idx_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Negative title definitions';

-- Title Conditions
CREATE TABLE IF NOT EXISTS `mortal_negative_title_conditions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `title_id` INT UNSIGNED NOT NULL,
    `condition_type` VARCHAR(32) NOT NULL COMMENT 'NOTORIETY_THRESHOLD, CRIME_COUNTER, FACTION_STANDING',
    `param_json` JSON NOT NULL COMMENT 'parameters vary by type',
    CONSTRAINT `fk_mortal_negative_title_conditions_title`
        FOREIGN KEY (`title_id`) REFERENCES `mortal_negative_titles`(`id`)
        ON DELETE CASCADE,
    INDEX `idx_title` (`title_id`),
    INDEX `idx_condition_type` (`condition_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Machine-readable triggers for negative titles';

-- Per-Character Active Title State
CREATE TABLE IF NOT EXISTS `mortal_negative_title_state` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `active_title_id` INT UNSIGNED NULL COMMENT 'currently displayed negative title',
    `last_update_ts` INT UNSIGNED NOT NULL,
    `history_json` JSON NULL COMMENT 'log of titles earned/lost with timestamps',
    UNIQUE KEY `uniq_guid` (`guid`),
    CONSTRAINT `fk_mortal_negative_title_state_title`
        FOREIGN KEY (`active_title_id`) REFERENCES `mortal_negative_titles`(`id`)
        ON DELETE SET NULL,
    INDEX `idx_active_title` (`active_title_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Per-character active negative title state';

