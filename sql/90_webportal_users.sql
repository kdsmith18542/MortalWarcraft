-- ==================================================
-- Project Mortal Warcraft
-- Feature: Web Portal Users
-- Description: User accounts for Mortal Atlas web portal
-- Based on: docs/specs/24-webportal-mortal-atlas.md
-- ==================================================

-- Portal Users
-- User accounts for the web portal (separate from game accounts)
CREATE TABLE IF NOT EXISTS `atlas_users` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL COMMENT 'bcrypt hash',
    `role` VARCHAR(32) NOT NULL DEFAULT 'user' COMMENT 'user, contributor, moderator, admin',
    `created_at` TIMESTAMP NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT 0 ,
    INDEX `idx_email` (`email`),
    INDEX `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Atlas web portal users';

