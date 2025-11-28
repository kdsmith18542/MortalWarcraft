-- ==================================================
-- Project Mortal Warcraft
-- Feature: Security & Anti-Bot/RMT Enhancements
-- Description: Enhanced security monitoring and RMT detection
-- Based on: docs/specs/40-anti-bot-rmt-and-security.md
-- ==================================================

-- Security Event Log
CREATE TABLE IF NOT EXISTS `mortal_security_events` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_type` VARCHAR(32) NOT NULL COMMENT 'SUSPICIOUS_MOVEMENT, RAPID_TRADE, BOT_PATTERN, RMT_SIGNAL',
    `guid` INT UNSIGNED NULL COMMENT 'characters.guid (if applicable)',
    `ip_address` VARCHAR(45) NULL,
    `account_id` INT UNSIGNED NULL,
    `severity` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Low, 2=Medium, 3=High, 4=Critical',
    `event_data` JSON NULL COMMENT 'Structured event details',
    `action_taken` VARCHAR(64) NULL COMMENT 'FLAGGED, WARNED, KICKED, BANNED',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_event_type` (`event_type`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_ip` (`ip_address`),
    INDEX `idx_account` (`account_id`),
    INDEX `idx_severity` (`severity`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Security event log';

-- Trade Monitoring
CREATE TABLE IF NOT EXISTS `mortal_trade_monitoring` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `trader_guid` INT UNSIGNED NOT NULL,
    `recipient_guid` INT UNSIGNED NOT NULL,
    `item_entry` INT UNSIGNED NOT NULL,
    `item_count` INT UNSIGNED NOT NULL,
    `gold_amount` INT UNSIGNED NOT NULL DEFAULT 0,
    `trade_value_estimate` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Estimated market value',
    `suspicion_score` FLOAT NOT NULL DEFAULT 0.0 COMMENT '0.0-1.0 RMT suspicion',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_trader` (`trader_guid`),
    INDEX `idx_recipient` (`recipient_guid`),
    INDEX `idx_suspicion` (`suspicion_score`),
    INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Trade monitoring for RMT detection';

-- Bot Detection Patterns
CREATE TABLE IF NOT EXISTS `mortal_bot_patterns` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `pattern_type` VARCHAR(32) NOT NULL COMMENT 'MOVEMENT, COMBAT, GATHERING, CRAFTING',
    `pattern_name` VARCHAR(128) NOT NULL,
    `description` TEXT NOT NULL,
    `detection_threshold` FLOAT NOT NULL DEFAULT 0.7 COMMENT '0.0-1.0 confidence threshold',
    `action_on_detect` VARCHAR(32) NOT NULL DEFAULT 'FLAG' COMMENT 'FLAG, WARN, KICK, BAN',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    INDEX `idx_type` (`pattern_type`),
    INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bot detection pattern definitions';

-- Player Behavior Tracking
CREATE TABLE IF NOT EXISTS `mortal_player_behavior` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL,
    `session_id` VARCHAR(64) NOT NULL,
    `behavior_type` VARCHAR(32) NOT NULL COMMENT 'MOVEMENT, COMBAT, TRADE, GATHERING',
    `metric_name` VARCHAR(64) NOT NULL,
    `metric_value` FLOAT NOT NULL,
    `timestamp` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_guid_session` (`guid`, `session_id`),
    INDEX `idx_behavior` (`behavior_type`),
    INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player behavior metrics for bot detection';

-- Seed Data: Bot Detection Patterns
INSERT INTO `mortal_bot_patterns` (`pattern_type`, `pattern_name`, `description`, `detection_threshold`, `action_on_detect`) VALUES
('MOVEMENT', 'Perfect Pathing', 'Player follows exact same path repeatedly with pixel-perfect precision', 0.8, 'FLAG'),
('MOVEMENT', 'Unnatural Movement', 'Movement patterns that are physically impossible (teleporting, clipping)', 0.9, 'KICK'),
('COMBAT', 'Perfect Rotation', 'Combat rotation executed with inhuman precision and timing', 0.75, 'FLAG'),
('GATHERING', 'Automated Gathering', 'Gathering resources with perfect timing and no human delay', 0.7, 'FLAG'),
('GATHERING', '24/7 Activity', 'Player active 24/7 without breaks (impossible for human)', 0.95, 'BAN'),
('TRADE', 'Rapid High-Value Trades', 'Multiple high-value trades between same accounts in short time', 0.8, 'FLAG')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

-- Summary
SELECT 
    'Security Enhancements Created' as summary,
    COUNT(*) as bot_patterns,
    'Enhanced monitoring active' as status
FROM mortal_bot_patterns;

