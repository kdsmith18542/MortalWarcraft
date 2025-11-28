-- ==================================================
-- Project Mortal Warcraft
-- Feature: Event Contribution System
-- Description: Contribution tracking for public PvE events
-- Based on: docs/specs/46-public-grouping-and-contribution.md
-- ==================================================

-- Event Contribution Tracking
CREATE TABLE IF NOT EXISTS `mortal_event_contrib` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_active_id` VARCHAR(64) NOT NULL COMMENT 'Unique event instance identifier',
    `player_guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `damage_score` FLOAT NOT NULL DEFAULT 0.0,
    `healing_score` FLOAT NOT NULL DEFAULT 0.0,
    `guard_score` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Tanking/guardian contribution',
    `utility_score` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'CC, buffs, debuffs',
    `total_score` FLOAT NOT NULL DEFAULT 0.0,
    `rewards_json` TEXT NULL COMMENT 'JSON record of rewards awarded',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    UNIQUE KEY `uk_event_player` (`event_active_id`, `player_guid`),
    INDEX `idx_event` (`event_active_id`),
    INDEX `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Event contribution scores for reward scaling';

-- Summary
SELECT 
    'Event Contribution System Created' as summary,
    'Ready for contribution tracking' as status;

