-- ==================================================
-- Project Mortal Warcraft
-- Feature: Public Grouping Enhancements
-- Description: Enhanced public grouping system
-- Based on: docs/specs/46-public-grouping.md
-- ==================================================

-- Public Group Requests
CREATE TABLE IF NOT EXISTS `mortal_public_group_requests` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `leader_guid` INT UNSIGNED NOT NULL,
    `activity_type` VARCHAR(32) NOT NULL COMMENT 'DUNGEON, RAID, QUEST, WORLD_BOSS, DELVE',
    `target_entry` INT UNSIGNED NULL COMMENT 'Instance ID, quest ID, creature entry, etc.',
    `target_name` VARCHAR(128) NULL,
    `min_level` INT UNSIGNED NOT NULL DEFAULT 1,
    `max_level` INT UNSIGNED NOT NULL DEFAULT 80,
    `min_players` INT UNSIGNED NOT NULL DEFAULT 1,
    `max_players` INT UNSIGNED NOT NULL DEFAULT 5,
    `zone_id` INT UNSIGNED NULL,
    `map_id` INT UNSIGNED NULL,
    `status` VARCHAR(16) NOT NULL DEFAULT 'OPEN' COMMENT 'OPEN, FULL, IN_PROGRESS, COMPLETED',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `expires_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_activity` (`activity_type`),
    INDEX `idx_status` (`status`),
    INDEX `idx_created` (`created_at`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Public group requests';

-- Public Group Applications
CREATE TABLE IF NOT EXISTS `mortal_public_group_applications` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `request_id` INT UNSIGNED NOT NULL,
    `applicant_guid` INT UNSIGNED NOT NULL,
    `status` VARCHAR(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING, ACCEPTED, REJECTED',
    `applied_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_request` (`request_id`),
    INDEX `idx_applicant` (`applicant_guid`),
    INDEX `idx_status` (`status`),
    CONSTRAINT `fk_mortal_public_group_applications_request`
        FOREIGN KEY (`request_id`) REFERENCES `mortal_public_group_requests` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Public group applications';

-- Summary
SELECT 
    'Public Grouping Enhancements Created' as summary,
    'Ready for group requests' as status;

