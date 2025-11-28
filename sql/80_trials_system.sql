-- ==================================================
-- Mortal Warcraft – Shrine & Faction Trials System
-- Spec 59: Shrine and Faction Trials
-- Target DB: world (definitions), characters (progress)
-- ==================================================

-- Trial Definitions: Defines available Trials
CREATE TABLE IF NOT EXISTS `mortal_trials` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'Unique trial code (e.g., TRIAL_BULWARK_T1)',
    `name` VARCHAR(128) NOT NULL COMMENT 'Trial display name',
    `description` TEXT NOT NULL COMMENT 'Trial description',
    `tier` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Difficulty tier (1-5)',
    `faction_tag` VARCHAR(64) DEFAULT NULL COMMENT 'Faction association (ORDER_SHRINE, RANGERS_PACT, etc.)',
    `trial_type` VARCHAR(32) NOT NULL DEFAULT 'BULWARK' COMMENT 'Trial type: BULWARK, BLADE, VEIL, LIFELINE',
    `map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID for trial instance',
    `entry_npc_id` INT UNSIGNED DEFAULT NULL COMMENT 'Optional NPC entry ID for access',
    `entry_standing_min` INT NOT NULL DEFAULT 0 COMMENT 'Minimum faction standing required (0 = neutral)',
    `entry_level_min` INT UNSIGNED NOT NULL DEFAULT 10 COMMENT 'Minimum dynamic level required',
    `normalized_band_json` JSON DEFAULT NULL COMMENT 'Normalization parameters: {min_ilvl, max_ilvl, stat_scale_multiplier}',
    `reward_json` JSON NOT NULL COMMENT 'Reward data: one-time and repeat rewards',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Trial flags (solo_only, etc.)',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Whether trial is currently active',
    INDEX `idx_faction_tag` (`faction_tag`),
    INDEX `idx_tier` (`tier`),
    INDEX `idx_trial_type` (`trial_type`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Trial definitions and configuration';

-- Trial Progress: Per-character trial completion tracking
CREATE TABLE IF NOT EXISTS `mortal_trial_progress` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
    `trial_id` INT UNSIGNED NOT NULL COMMENT 'Trial ID from mortal_trials',
    `best_result_json` JSON NOT NULL COMMENT 'Best completion result: {success, time_sec, deaths, score}',
    `completions` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of successful completions',
    `attempts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total attempts (including failures)',
    `first_completion_ts` INT UNSIGNED DEFAULT NULL COMMENT 'Timestamp of first completion',
    `last_attempt_ts` INT UNSIGNED NOT NULL COMMENT 'Last attempt timestamp',
    UNIQUE KEY `uniq_guid_trial` (`guid`, `trial_id`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_trial_id` (`trial_id`),
    CONSTRAINT `fk_mortal_trial_progress_trial`
        FOREIGN KEY (`trial_id`) REFERENCES `mortal_trials`(`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Per-character trial progress and achievements';

-- Example trial definitions
INSERT INTO `mortal_trials` (`code`, `name`, `description`, `tier`, `faction_tag`, `trial_type`, `map_id`, `normalized_band_json`, `reward_json`) VALUES
('TRIAL_BULWARK_T1', 'Trial of the Bulwark (Tier 1)', 'Defend against waves of undead. Focus on mitigation, HP management, and Guard Counter usage.', 1, 'ORDER_SHRINE', 'BULWARK', 0, '{"min_ilvl": 1, "max_ilvl": 5, "stat_scale_multiplier": 1.0}', '{"one_time": {"title": "Bulwark Novice", "appearance_unlock": "bulwark_t1_weapon"}, "repeat": {"faction_standing": 50, "season_xp": 100}}'),
('TRIAL_BLADE_T1', 'Trial of the Blade (Tier 1)', 'Deal sustained damage while handling mechanics. Test your combat prowess.', 1, 'RANGERS_PACT', 'BLADE', 0, '{"min_ilvl": 1, "max_ilvl": 5, "stat_scale_multiplier": 1.0}', '{"one_time": {"title": "Blade Novice", "appearance_unlock": "blade_t1_weapon"}, "repeat": {"faction_standing": 50, "season_xp": 100}}'),
('TRIAL_VEIL_T1', 'Trial of the Veil (Tier 1)', 'Navigate through movement challenges and dodge AOEs. Master mobility and positioning.', 1, 'RANGERS_PACT', 'VEIL', 0, '{"min_ilvl": 1, "max_ilvl": 5, "stat_scale_multiplier": 1.0}', '{"one_time": {"title": "Veil Novice", "appearance_unlock": "veil_t1_weapon"}, "repeat": {"faction_standing": 50, "season_xp": 100}}'),
('TRIAL_LIFELINE_T1', 'Trial of the Lifeline (Tier 1)', 'Keep NPCs alive through healing and First Aid. Test your support capabilities.', 1, 'ORDER_SHRINE', 'LIFELINE', 0, '{"min_ilvl": 1, "max_ilvl": 5, "stat_scale_multiplier": 1.0}', '{"one_time": {"title": "Lifeline Novice", "appearance_unlock": "lifeline_t1_weapon"}, "repeat": {"faction_standing": 50, "season_xp": 100}}');

