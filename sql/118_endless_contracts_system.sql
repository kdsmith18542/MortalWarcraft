-- ==================================================
-- Project Mortal Warcraft
-- Feature: Endless Contracts System
-- Description: Defense and survival mode contracts
-- Based on: docs/specs/54-endless-contracts.md
-- ==================================================

-- Endless Contracts
CREATE TABLE IF NOT EXISTS `mortal_endless_contracts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE,
    `name` VARCHAR(128) NOT NULL,
    `type` VARCHAR(16) NOT NULL COMMENT 'DEFENSE, SURVIVAL',
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `risk_tier` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Green, 1=Yellow, 2=Red',
    `min_players` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `max_players` TINYINT UNSIGNED NOT NULL DEFAULT 5,
    `faction_bias` VARCHAR(32) NULL COMMENT 'Optional faction preference',
    `base_reward_json` TEXT NULL COMMENT 'JSON reward structure',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_zone_risk` (`zone_id`, `risk_tier`),
    INDEX `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Endless contract definitions';

-- Endless Contract Waves
CREATE TABLE IF NOT EXISTS `mortal_endless_waves` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `contract_id` INT UNSIGNED NOT NULL,
    `wave_number` INT UNSIGNED NOT NULL,
    `enemy_group_id` INT UNSIGNED NOT NULL COMMENT 'Reference to enemy spawn group',
    `scaling_factor` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Wave difficulty scaling',
    `reward_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Reward multiplier for this wave',
    INDEX `idx_contract_wave` (`contract_id`, `wave_number`),
    CONSTRAINT `fk_mortal_endless_waves_contract`
        FOREIGN KEY (`contract_id`) REFERENCES `mortal_endless_contracts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wave definitions for endless contracts';

-- Endless Contract Runs (player participation records)
CREATE TABLE IF NOT EXISTS `mortal_endless_runs` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `contract_id` INT UNSIGNED NOT NULL,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid (leader)',
    `party_size` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `max_wave` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Highest wave reached',
    `duration_sec` INT UNSIGNED NOT NULL DEFAULT 0,
    `extracted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if extracted early, 0 if failed',
    `start_ts` INT UNSIGNED NOT NULL DEFAULT 0,
    `end_ts` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_contract` (`contract_id`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_start` (`start_ts`),
    CONSTRAINT `fk_mortal_endless_runs_contract`
        FOREIGN KEY (`contract_id`) REFERENCES `mortal_endless_contracts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Endless contract run records';

-- Summary
SELECT 
    'Endless Contracts System Created' as summary,
    'Ready for contract definitions' as status;

