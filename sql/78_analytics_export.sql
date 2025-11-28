-- ==================================================
-- Project Mortal Warcraft
-- Feature: Analytics Export Queue
-- Description: Queue table for analytics CSV/API exports
-- Spec: 14-admin-tools.md
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_analytics_export` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `export_type` VARCHAR(20) NOT NULL COMMENT 'csv, api',
    `data` LONGTEXT NOT NULL COMMENT 'JSON or CSV data',
    `destination` VARCHAR(255) NOT NULL COMMENT 'File path or API URL',
    `status` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 = pending, 1 = completed, 2 = failed',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `completed_at` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_status` (`status`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

