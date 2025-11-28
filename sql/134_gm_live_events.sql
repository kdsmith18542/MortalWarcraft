-- ==================================================
-- Project Mortal Warcraft
-- Feature: GM Tools & Live Event Framework
-- Description: Permissions, event templates, active events, overrides, audit logging
-- Based on: docs/specs/42-gm-tools-and-live-events.md
-- ==================================================

-- GM Role Assignments
CREATE TABLE IF NOT EXISTS `mortal_gm_permissions` (
    `account_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `role` VARCHAR(16) NOT NULL,
    `granted_time` INT UNSIGNED NOT NULL,
    `granted_by` INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Event Templates
CREATE TABLE IF NOT EXISTS `mortal_event_template` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL,
    `name` VARCHAR(64) NOT NULL,
    `description` VARCHAR(255) NULL,
    `category` VARCHAR(32) NOT NULL,
    `zone_id` INT NOT NULL,
    `map_id` INT NOT NULL,
    `start_type` VARCHAR(16) NOT NULL,
    `duration_seconds` INT NOT NULL DEFAULT 1800,
    `max_concurrent` INT NOT NULL DEFAULT 1,
    `config_json` TEXT NOT NULL,
    `enabled` TINYINT NOT NULL DEFAULT 1,
    UNIQUE KEY `uk_event_code` (`code`),
    INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Active Event Instances
CREATE TABLE IF NOT EXISTS `mortal_event_active` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `template_id` INT UNSIGNED NOT NULL,
    `zone_id` INT NOT NULL,
    `map_id` INT NOT NULL,
    `started_by` INT NOT NULL,
    `started_time` INT NOT NULL,
    `end_time` INT NULL,
    `state` VARCHAR(16) NOT NULL DEFAULT 'RUNNING',
    `metrics_json` TEXT NULL,
    INDEX `idx_template_state` (`template_id`, `state`),
    CONSTRAINT `fk_mortal_event_active_template` FOREIGN KEY (`template_id`) REFERENCES `mortal_event_template`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Stronghold overrides for GM events
CREATE TABLE IF NOT EXISTS `mortal_stronghold_overrides` (
    `stronghold_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `override_output_multiplier` FLOAT NOT NULL DEFAULT 1.0,
    `override_vulnerability_json` TEXT NULL,
    `last_updated` INT UNSIGNED NOT NULL,
    `updated_by` INT UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GM action audit log
CREATE TABLE IF NOT EXISTS `mortal_gm_action_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT UNSIGNED NOT NULL,
    `role` VARCHAR(16) NOT NULL,
    `action_code` VARCHAR(64) NOT NULL,
    `target_type` VARCHAR(32) NULL,
    `target_id` INT NULL,
    `timestamp` INT UNSIGNED NOT NULL,
    `parameters_json` TEXT NULL,
    INDEX `idx_account` (`account_id`),
    INDEX `idx_action` (`action_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
