-- ==================================================
-- Mortal Warcraft – Campaign Progress Tracking
-- Spec 62: Core Lore and Campaign Skeleton
-- Target DB: characters
-- ==================================================

-- Campaign Progress: Tracks player progression through campaign Acts
CREATE TABLE IF NOT EXISTS `mortal_campaign_progress` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
    `stage_code` VARCHAR(32) NOT NULL DEFAULT 'PROLOGUE' COMMENT 'Current campaign stage: PROLOGUE, ACT_I, ACT_II, ACT_III, ACT_IV, ACT_V, COMPLETE',
    `state` VARCHAR(32) NOT NULL DEFAULT 'NOT_STARTED' COMMENT 'Stage state: NOT_STARTED, IN_PROGRESS, COMPLETE',
    `flags_json` JSON DEFAULT NULL COMMENT 'Stage-specific flags and progress data',
    `completed_acts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of completed Acts (0-5)',
    `last_update_ts` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
    UNIQUE KEY `uniq_guid` (`guid`),
    INDEX `idx_stage_code` (`stage_code`),
    INDEX `idx_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Campaign progression tracking per character';

