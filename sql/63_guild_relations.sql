-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Guild Relations (Politics System)
-- Description: Unified table for guild relationships (Neutral, Alliance, War, Truce)
-- Spec: 97-mortal-guild-war-and-alliances.md
-- Version: 1.0.0
-- ==================================================

-- Guild Relations Table
-- Unified table for all guild relationship types (replaces separate war/alliance tables)
CREATE TABLE IF NOT EXISTS `mortal_guild_relations` (
  `relation_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guild_id_a` INT UNSIGNED NOT NULL COMMENT 'Lower guild ID (ensures symmetric storage)',
  `guild_id_b` INT UNSIGNED NOT NULL COMMENT 'Higher guild ID (ensures symmetric storage)',
  `relation_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Neutral, 1=Alliance, 2=War, 3=Truce',
  `initiator_guild_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Guild that initiated the relation',
  `start_time` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when relation started',
  `end_time` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when relation ends (0 = indefinite)',
  `notes` TEXT COMMENT 'GM-facing notes about the relation',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `unique_relation` (`guild_id_a`, `guild_id_b`),
  INDEX `idx_guild_a` (`guild_id_a`),
  INDEX `idx_guild_b` (`guild_id_b`),
  INDEX `idx_relation_type` (`relation_type`),
  INDEX `idx_start_time` (`start_time`),
  INDEX `idx_end_time` (`end_time`),
  CONSTRAINT `chk_guild_order` CHECK (`guild_id_a` < `guild_id_b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Unified guild relationship tracking (Neutral, Alliance, War, Truce)';

-- Guild Pacts Table (Optional - for future special agreements)
CREATE TABLE IF NOT EXISTS `mortal_guild_pacts` (
  `pact_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guild_id_a` INT UNSIGNED NOT NULL,
  `guild_id_b` INT UNSIGNED NOT NULL,
  `pact_type` VARCHAR(50) NOT NULL COMMENT 'e.g., trade, non-aggression, resource-sharing',
  `terms` TEXT COMMENT 'JSON or text description of pact terms',
  `start_time` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `end_time` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `status` TINYINT UNSIGNED DEFAULT 1 COMMENT '1=Active, 2=Expired, 3=Broken',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`pact_id`),
  UNIQUE KEY `unique_pact` (`guild_id_a`, `guild_id_b`, `pact_type`),
  INDEX `idx_guild_a` (`guild_id_a`),
  INDEX `idx_guild_b` (`guild_id_b`),
  INDEX `idx_status` (`status`),
  CONSTRAINT `chk_pact_guild_order` CHECK (`guild_id_a` < `guild_id_b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Special agreements between guilds (optional future feature)';

-- Migration: Migrate existing guild_wars to mortal_guild_relations
-- This preserves existing war data
INSERT IGNORE INTO `mortal_guild_relations` (`guild_id_a`, `guild_id_b`, `relation_type`, `initiator_guild_id`, `start_time`, `end_time`, `notes`)
SELECT 
    LEAST(`guild_challenger`, `guild_target`) AS `guild_id_a`,
    GREATEST(`guild_challenger`, `guild_target`) AS `guild_id_b`,
    2 AS `relation_type`, -- WAR
    `guild_challenger` AS `initiator_guild_id`,
    `start_time`,
    CASE WHEN `end_time` > 0 THEN `end_time` ELSE 0 END AS `end_time`,
    CONCAT('Migrated from guild_wars table, war_id: ', `war_id`) AS `notes`
FROM `guild_wars`
WHERE `status` = 1 -- Active wars only
ON DUPLICATE KEY UPDATE `relation_type` = 2, `updated_at` = CURRENT_TIMESTAMP;

-- Migration: Migrate existing guild_alliances to mortal_guild_relations
-- This preserves existing alliance data
INSERT IGNORE INTO `mortal_guild_relations` (`guild_id_a`, `guild_id_b`, `relation_type`, `initiator_guild_id`, `start_time`, `end_time`, `notes`)
SELECT 
    LEAST(`guild1_id`, `guild2_id`) AS `guild_id_a`,
    GREATEST(`guild1_id`, `guild2_id`) AS `guild_id_b`,
    1 AS `relation_type`, -- ALLIANCE
    `guild1_id` AS `initiator_guild_id`, -- Best guess, may need manual correction
    UNIX_TIMESTAMP(`created_at`) AS `start_time`,
    0 AS `end_time`,
    CONCAT('Migrated from guild_alliances table, alliance_id: ', `alliance_id`) AS `notes`
FROM `guild_alliances`
WHERE `status` = 1 -- Active alliances only
ON DUPLICATE KEY UPDATE `relation_type` = 1, `updated_at` = CURRENT_TIMESTAMP;

