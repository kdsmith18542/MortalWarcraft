-- ==================================================
-- Project Mortal Warcraft
-- Feature: World Contracts & Map Pins
-- Description: World Quest / map-wide objective system with map pins
-- Based on: docs/specs/58-world-contracts-and-map-pins.md
-- ==================================================

-- World Contract Templates
CREATE TABLE IF NOT EXISTS `mortal_world_contract_templates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'WC_HUNT_BARRENS_ALPHA_WOLVES',
    `name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `type` VARCHAR(32) NOT NULL COMMENT 'HUNT, DEFENSE, RIFT, CARAVAN, HELLGATE',
    `risk_tier` INT UNSIGNED NOT NULL COMMENT '1..5 (Green->Red mapping)',
    `zone_id` INT UNSIGNED NOT NULL,
    `faction_tag` VARCHAR(64) NULL COMMENT 'IRON_LEDGER, RANGERS_PACT, etc.',
    `objective_json` JSON NOT NULL COMMENT 'target mobs, counts, event ids, etc.',
    `reward_json` JSON NOT NULL COMMENT 'base rewards',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_type` (`type`),
    INDEX `idx_risk` (`risk_tier`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='World contract template definitions';

-- World Contract Instances (Map Pins)
CREATE TABLE IF NOT EXISTS `mortal_world_contract_instances` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `template_id` INT UNSIGNED NOT NULL,
    `map_id` INT UNSIGNED NOT NULL,
    `x_coord` FLOAT NOT NULL,
    `y_coord` FLOAT NOT NULL,
    `z_coord` FLOAT NOT NULL,
    `start_ts` INT UNSIGNED NOT NULL,
    `end_ts` INT UNSIGNED NOT NULL,
    `state` VARCHAR(16) NOT NULL DEFAULT 'ACTIVE' COMMENT 'ACTIVE, COMPLETED, EXPIRED',
    `current_progress_json` JSON NULL COMMENT 'global progress for server-wide events',
    CONSTRAINT `fk_mortal_world_contract_instances_template`
        FOREIGN KEY (`template_id`) REFERENCES `mortal_world_contract_templates`(`id`)
        ON DELETE CASCADE,
    INDEX `idx_contract_active` (`template_id`, `state`, `end_ts`),
    INDEX `idx_map_coords` (`map_id`, `x_coord`, `y_coord`),
    INDEX `idx_time` (`start_ts`, `end_ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Active world contract instances on map';

-- Player World Contract Progress
CREATE TABLE IF NOT EXISTS `mortal_world_contract_progress` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `instance_id` BIGINT UNSIGNED NOT NULL,
    `progress_json` JSON NOT NULL COMMENT 'per-contract type tracking',
    `completed` TINYINT(1) NOT NULL DEFAULT 0,
    `last_update_ts` INT UNSIGNED NOT NULL,
    CONSTRAINT `fk_mortal_world_contract_progress_instance`
        FOREIGN KEY (`instance_id`) REFERENCES `mortal_world_contract_instances`(`id`)
        ON DELETE CASCADE,
    INDEX `idx_guid_instance` (`guid`, `instance_id`),
    INDEX `idx_completed` (`completed`, `last_update_ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player progress on world contracts';

