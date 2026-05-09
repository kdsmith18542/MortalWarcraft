-- ============================================================================
-- Mortal Warcraft Overhaul - Auth Database Tables
-- Part of the mod-mortal AzerothCore module
-- ============================================================================

-- GM Permissions
DROP TABLE IF EXISTS `mortal_gm_permissions`;
CREATE TABLE `mortal_gm_permissions` (
    `account_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `permission_mask` INT UNSIGNED NOT NULL DEFAULT 0,
    `granted_by` INT UNSIGNED DEFAULT NULL,
    `granted_at` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Server Log
DROP TABLE IF EXISTS `mortal_server_log`;
CREATE TABLE `mortal_server_log` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT UNSIGNED DEFAULT NULL,
    `action` VARCHAR(64) NOT NULL,
    `target` VARCHAR(64) DEFAULT NULL,
    `details` TEXT DEFAULT NULL,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
