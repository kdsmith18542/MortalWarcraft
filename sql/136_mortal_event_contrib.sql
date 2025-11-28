-- ==================================================
-- Project Mortal Warcraft
-- Feature: Event Contribution Tracking
-- Description: Tracks player contributions during public events
-- ==================================================

-- Event Contribution Tracking
CREATE TABLE IF NOT EXISTS `mortal_event_contrib` (
    `event_active_id` INT UNSIGNED NOT NULL COMMENT 'Event instance or group ID',
    `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
    `damage_score` FLOAT NOT NULL DEFAULT 0 COMMENT 'Effective damage to event mobs',
    `healing_score` FLOAT NOT NULL DEFAULT 0 COMMENT 'Healing given to allies',
    `guard_score` FLOAT NOT NULL DEFAULT 0 COMMENT 'Damage mitigation and blocks',
    `utility_score` FLOAT NOT NULL DEFAULT 0 COMMENT 'CC, interrupts, crowd control',
    `total_score` FLOAT NOT NULL DEFAULT 0 COMMENT 'Sum of all contribution scores',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT UNIX_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`event_active_id`, `player_guid`),
    INDEX `idx_player_updated` (`player_guid`, `updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player contribution tracking for events';

-- Summary
SELECT 
    'Event Contribution Tracking Created' as summary,
    'Ready for contribution tracking' as status;
