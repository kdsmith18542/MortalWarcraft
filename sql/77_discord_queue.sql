-- ==================================================
-- Project Mortal Warcraft
-- Feature: Discord Webhook Queue
-- Description: Queue table for Discord webhook messages (processed by C++ hook or external service)
-- Spec: 09-social-systems.md
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_discord_queue` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `channel` VARCHAR(50) NOT NULL,
    `message` TEXT NOT NULL,
    `embed` TEXT,
    `webhook_url` VARCHAR(255) NOT NULL,
    `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 = pending, 1 = sent, 2 = failed',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `sent_at` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

