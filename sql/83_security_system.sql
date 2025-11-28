-- ==================================================
-- Project Mortal Warcraft
-- Feature: Security & Anti-Bot/RMT System
-- Description: Multi-layered security detection and logging
-- Based on: docs/specs/40-anti-bot-rmt-and-security.md
-- ==================================================

-- Anticheat Events Log
-- Logs serious anticheat violations from mod-anticheat
CREATE TABLE IF NOT EXISTS `mortal_security_anticheat` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `account_id` INT UNSIGNED NOT NULL,
    `type` VARCHAR(32) NOT NULL COMMENT 'SPEED, FLY, TELEPORT, COMBAT',
    `value` FLOAT NULL COMMENT 'Magnitude of violation',
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `timestamp` INT UNSIGNED NOT NULL,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_guid` (`guid`, `timestamp`),
    INDEX `idx_account` (`account_id`, `timestamp`),
    INDEX `idx_type` (`type`, `timestamp`),
    INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Anticheat violation logs';

-- Daily Activity Summary
-- Tracks per-character daily activity metrics for behavior analysis
CREATE TABLE IF NOT EXISTS `mortal_activity_summary_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL COMMENT 'YYYYMMDD',
    `session_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `minutes_played` INT UNSIGNED NOT NULL DEFAULT 0,
    `kills_pve` INT UNSIGNED NOT NULL DEFAULT 0,
    `kills_pvp` INT UNSIGNED NOT NULL DEFAULT 0,
    `nodes_gathered` INT UNSIGNED NOT NULL DEFAULT 0,
    `tasks_completed` INT UNSIGNED NOT NULL DEFAULT 0,
    `deaths_total` INT UNSIGNED NOT NULL DEFAULT 0,
    `gold_earned` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `gold_spent` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `chat_messages` INT UNSIGNED NOT NULL DEFAULT 0,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`),
    INDEX `idx_date` (`date_int`),
    INDEX `idx_minutes` (`minutes_played`),
    INDEX `idx_chat` (`chat_messages`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Daily activity summaries for behavior analysis';

-- Security Flags
-- Flags accounts/characters for suspicious behavior patterns
CREATE TABLE IF NOT EXISTS `mortal_security_flags` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL,
    `flag_type` VARCHAR(32) NOT NULL COMMENT 'BOT_PATTERN, 24_7_UPTIME, NO_CHAT, SUSPICIOUS_ROUTE',
    `severity` TINYINT UNSIGNED NOT NULL COMMENT '1=low, 2=med, 3=high',
    `details` VARCHAR(255) NULL,
    `first_seen` INT UNSIGNED NOT NULL,
    `last_seen` INT UNSIGNED NOT NULL,
    `resolved` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_guid` (`guid`, `resolved`),
    INDEX `idx_type` (`flag_type`, `severity`),
    INDEX `idx_resolved` (`resolved`, `severity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Security behavior flags';

-- Trade Log
-- Logs high-value player-to-player trades
CREATE TABLE IF NOT EXISTS `mortal_trade_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `sender_guid` INT UNSIGNED NOT NULL,
    `receiver_guid` INT UNSIGNED NOT NULL,
    `timestamp` INT UNSIGNED NOT NULL,
    `gold_amount` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `item_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `item_value_est` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Estimated item value',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_sender` (`sender_guid`, `timestamp`),
    INDEX `idx_receiver` (`receiver_guid`, `timestamp`),
    INDEX `idx_timestamp` (`timestamp`),
    INDEX `idx_value` (`gold_amount`, `item_value_est`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player trade logs';

-- Mail Log
-- Logs high-value mail transfers
CREATE TABLE IF NOT EXISTS `mortal_mail_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `sender_guid` INT UNSIGNED NOT NULL,
    `receiver_guid` INT UNSIGNED NOT NULL,
    `timestamp` INT UNSIGNED NOT NULL,
    `gold_amount` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `item_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `item_value_est` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Estimated item value',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_sender` (`sender_guid`, `timestamp`),
    INDEX `idx_receiver` (`receiver_guid`, `timestamp`),
    INDEX `idx_timestamp` (`timestamp`),
    INDEX `idx_value` (`gold_amount`, `item_value_est`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Mail transfer logs';

-- Economic Security Flags
-- Flags suspicious economic transfers (RMT, mule patterns)
CREATE TABLE IF NOT EXISTS `mortal_security_econ_flags` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `source_guid` INT UNSIGNED NOT NULL,
    `target_guid` INT UNSIGNED NOT NULL,
    `timestamp` INT UNSIGNED NOT NULL,
    `direction` VARCHAR(8) NOT NULL COMMENT 'TRADE, MAIL',
    `gold_amount` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `item_value_est` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `reason` VARCHAR(64) NOT NULL COMMENT 'LARGE_ONE_WAY, MULE_PATTERN, SUPPORTER_ANOMALY',
    `details` VARCHAR(255) NULL,
    `severity` TINYINT UNSIGNED NOT NULL COMMENT '1=low, 2=med, 3=high',
    `resolved` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_source` (`source_guid`, `timestamp`),
    INDEX `idx_target` (`target_guid`, `timestamp`),
    INDEX `idx_reason` (`reason`, `severity`),
    INDEX `idx_resolved` (`resolved`, `severity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Economic security flags';

-- Session Log
-- Tracks login sessions with IP and hardware fingerprint
CREATE TABLE IF NOT EXISTS `mortal_session_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT UNSIGNED NOT NULL,
    `guid` INT UNSIGNED NOT NULL,
    `ip_address` VARCHAR(45) NOT NULL,
    `hw_hash` VARCHAR(64) NULL COMMENT 'Hardware fingerprint if available',
    `login_time` INT UNSIGNED NOT NULL,
    `logout_time` INT UNSIGNED NULL,
    INDEX `idx_account` (`account_id`, `login_time`),
    INDEX `idx_guid` (`guid`, `login_time`),
    INDEX `idx_ip` (`ip_address`, `login_time`),
    INDEX `idx_hw` (`hw_hash`, `login_time`),
    INDEX `idx_active` (`logout_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player session logs';

-- Bot Characters
-- Marks characters as playerbots (excluded from security checks)
CREATE TABLE IF NOT EXISTS `mortal_bot_characters` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `bot_type` VARCHAR(32) NOT NULL DEFAULT 'MERCENARY' COMMENT 'MERCENARY, COMPANION, etc.',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_type` (`bot_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bot character registry';

