-- ==================================================
-- Project Mortal Warcraft
-- Feature: Endless Contracts - Defense & Survival
-- Description: Wave-based endless content (Defense and Survival modes)
-- Based on: docs/specs/54-endless-contracts-defense-and-survival.md
-- ==================================================

-- Endless Contract Definitions
CREATE TABLE IF NOT EXISTS `mortal_endless_contracts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'DEFENSE_SHRINE_ASH, SURVIVAL_RED_ZONE, etc.',
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `contract_type` VARCHAR(16) NOT NULL COMMENT 'DEFENSE, SURVIVAL',
    `objective_type` VARCHAR(32) NOT NULL COMMENT 'SHRINE, STRONGHOLD_GATE, CARAVAN, PLANAR_ANCHOR',
    `objective_entry` INT UNSIGNED NULL COMMENT 'GameObject or NPC entry',
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `min_waves` INT UNSIGNED NOT NULL DEFAULT 5 COMMENT 'Minimum waves before extraction',
    `scaling_factor` FLOAT NOT NULL DEFAULT 1.1 COMMENT 'Difficulty scaling per wave',
    `base_reward_tokens` INT UNSIGNED NOT NULL DEFAULT 0,
    `base_reward_credits` INT UNSIGNED NOT NULL DEFAULT 0,
    `wave_reward_multiplier` FLOAT NOT NULL DEFAULT 1.2 COMMENT 'Reward multiplier per wave',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `notes` VARCHAR(255) NULL,
    INDEX `idx_type` (`contract_type`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Endless contract definitions';

-- Active Endless Contract Instances
CREATE TABLE IF NOT EXISTS `mortal_endless_contract_instances` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `contract_id` INT UNSIGNED NOT NULL,
    `party_leader_guid` INT UNSIGNED NOT NULL COMMENT 'Party leader character guid',
    `current_wave` INT UNSIGNED NOT NULL DEFAULT 0,
    `start_time` INT UNSIGNED NOT NULL DEFAULT 0,
    `status` VARCHAR(16) NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE, EXTRACTED, FAILED',
    `extraction_votes` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Votes to extract',
    `total_rewards_tokens` INT UNSIGNED NOT NULL DEFAULT 0,
    `total_rewards_credits` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_contract` (`contract_id`),
    INDEX `idx_leader` (`party_leader_guid`),
    INDEX `idx_status` (`status`),
    CONSTRAINT `fk_mortal_endless_contract_instances_contract`
        FOREIGN KEY (`contract_id`) REFERENCES `mortal_endless_contracts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Active endless contract instances';

-- Wave Spawn Definitions
CREATE TABLE IF NOT EXISTS `mortal_endless_contract_waves` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `contract_id` INT UNSIGNED NOT NULL,
    `wave_number` INT UNSIGNED NOT NULL,
    `spawn_json` JSON NULL COMMENT 'Spawn definitions (creature entries, counts, positions)',
    `boss_wave` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if this is a boss wave',
    INDEX `idx_contract_wave` (`contract_id`, `wave_number`),
    CONSTRAINT `fk_mortal_endless_contract_waves_contract`
        FOREIGN KEY (`contract_id`) REFERENCES `mortal_endless_contracts` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wave spawn definitions';

-- Player Contract Participation
CREATE TABLE IF NOT EXISTS `mortal_endless_contract_participants` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `instance_id` INT UNSIGNED NOT NULL,
    `guid` INT UNSIGNED NOT NULL,
    `joined_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `waves_completed` INT UNSIGNED NOT NULL DEFAULT 0,
    `extraction_vote` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if voted to extract',
    INDEX `idx_instance` (`instance_id`),
    INDEX `idx_guid` (`guid`),
    CONSTRAINT `fk_mortal_endless_contract_participants_instance`
        FOREIGN KEY (`instance_id`) REFERENCES `mortal_endless_contract_instances` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player participation in endless contracts';

-- Seed Data: Example Contracts
INSERT INTO `mortal_endless_contracts` (`code`, `name`, `description`, `contract_type`, `objective_type`, `map_id`, `zone_id`, `min_waves`, `base_reward_tokens`, `base_reward_credits`, `notes`) VALUES
('DEFENSE_SHRINE_ASH', 'Defend the Shrine of Ash', 'Defend the Shrine against waves of attackers', 'DEFENSE', 'SHRINE', 0, 0, 5, 100, 200, 'Example defense contract'),
('SURVIVAL_RED_ZONE', 'Survival: Red Zone', 'Survive waves of enemies in a Red Zone', 'SURVIVAL', 'NONE', 0, 0, 5, 150, 300, 'Example survival contract')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Summary
SELECT 
    'Endless Contracts System Created' as summary,
    COUNT(*) as total_contracts,
    COUNT(CASE WHEN contract_type = 'DEFENSE' THEN 1 END) as defense_contracts,
    COUNT(CASE WHEN contract_type = 'SURVIVAL' THEN 1 END) as survival_contracts
FROM mortal_endless_contracts;

