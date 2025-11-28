-- ==================================================
-- Project Mortal Warcraft
-- Feature: Logging & Audit Trails
-- Description: Comprehensive logging system for moderation and analytics
-- Spec: 14-admin-tools.md
-- ==================================================

-- Economy Logs
CREATE TABLE IF NOT EXISTS `mortal_log_economy` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT UNSIGNED NOT NULL,
    `log_type` VARCHAR(50) NOT NULL COMMENT 'gold_gain, gold_loss, stall_sale, caravan_completion, contract_failure, tax_distribution',
    `amount` INT UNSIGNED DEFAULT 0 COMMENT 'Gold amount in copper',
    `details` TEXT COMMENT 'JSON or text details',
    `time` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_guid` (`guid`),
    KEY `idx_type` (`log_type`),
    KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PvP Logs
CREATE TABLE IF NOT EXISTS `mortal_log_pvp` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `killer_guid` INT UNSIGNED NOT NULL,
    `victim_guid` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `looted_items` TEXT COMMENT 'JSON array of item entries',
    `bounty_claimed` TINYINT(1) DEFAULT 0,
    `hellgate_match` TINYINT(1) DEFAULT 0,
    `hellgate_win` TINYINT(1) DEFAULT 0,
    `time` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_killer` (`killer_guid`, `time`),
    KEY `idx_victim` (`victim_guid`, `time`),
    KEY `idx_zone` (`zone_id`),
    KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crime Logs
CREATE TABLE IF NOT EXISTS `mortal_log_crime` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT UNSIGNED NOT NULL,
    `log_type` VARCHAR(50) NOT NULL COMMENT 'notoriety_change, criminal_flag, outlaw_promotion, bounty_posted, bounty_claimed',
    `old_value` INT UNSIGNED DEFAULT NULL,
    `new_value` INT UNSIGNED DEFAULT NULL,
    `target_guid` INT UNSIGNED DEFAULT NULL COMMENT 'For bounties, etc.',
    `zone_id` INT UNSIGNED DEFAULT NULL,
    `details` TEXT COMMENT 'JSON or text details',
    `time` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_guid` (`guid`, `time`),
    KEY `idx_type` (`log_type`),
    KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Guild Logs
CREATE TABLE IF NOT EXISTS `mortal_log_guild` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guild_id` INT UNSIGNED NOT NULL,
    `log_type` VARCHAR(50) NOT NULL COMMENT 'stronghold_capture, tcp_flip, siege_declaration, siege_completion, alliance_formed, alliance_broken, betrayal',
    `actor_guid` INT UNSIGNED DEFAULT NULL COMMENT 'Player who performed action',
    `target_guild_id` INT UNSIGNED DEFAULT NULL COMMENT 'For alliances, sieges, etc.',
    `zone_id` INT UNSIGNED DEFAULT NULL,
    `details` TEXT COMMENT 'JSON or text details',
    `time` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_guild` (`guild_id`, `time`),
    KEY `idx_type` (`log_type`),
    KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin Logs
CREATE TABLE IF NOT EXISTS `mortal_log_admin` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `gm_guid` INT UNSIGNED NOT NULL,
    `command` VARCHAR(100) NOT NULL,
    `target_guid` INT UNSIGNED DEFAULT NULL,
    `parameters` TEXT COMMENT 'JSON or text parameters',
    `result` VARCHAR(50) DEFAULT NULL COMMENT 'success, failure, error',
    `time` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_gm` (`gm_guid`, `time`),
    KEY `idx_command` (`command`),
    KEY `idx_target` (`target_guid`),
    KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

