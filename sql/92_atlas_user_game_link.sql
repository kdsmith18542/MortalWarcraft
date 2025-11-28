-- ==================================================
-- Project Mortal Warcraft
-- Feature: Web Portal - Game Account Linking
-- Description: Links web portal users to game accounts
-- ==================================================

-- Link table between web portal users and game accounts
CREATE TABLE IF NOT EXISTS `atlas_user_game_link` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `atlas_user_id` INT UNSIGNED NOT NULL,
    `account_id` INT UNSIGNED NOT NULL COMMENT 'Game account ID',
    `character_guid` INT UNSIGNED NULL COMMENT 'Primary character GUID (optional)',
    `linked_at` TIMESTAMP NOT NULL DEFAULT 0,
    `last_sync` TIMESTAMP NULL DEFAULT NULL,
    UNIQUE KEY `idx_atlas_user` (`atlas_user_id`),
    UNIQUE KEY `idx_account` (`account_id`),
    KEY `idx_character` (`character_guid`),
    FOREIGN KEY (`atlas_user_id`) REFERENCES `atlas_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Links web portal users to game accounts';

