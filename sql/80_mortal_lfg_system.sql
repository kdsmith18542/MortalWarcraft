-- ==================================================
-- Project Mortal Warcraft
-- Feature: LFG System (Non-Teleport Group Finder)
-- Description: Group listings and member tracking for dungeons/raids/delves
-- Based on: docs/specs/18-lfg-warfront-ui.md
-- ==================================================

-- LFG Listings Table
CREATE TABLE IF NOT EXISTS `mortal_lfg_listings` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `leader_guid` INT UNSIGNED NOT NULL COMMENT 'Party/raid leader GUID',
    `content_type` ENUM('dungeon', 'raid', 'delve', 'event') NOT NULL,
    `content_tag` VARCHAR(64) NOT NULL COMMENT 'DEADMINES, MOLTEN_CORE, etc.',
    `title` VARCHAR(100) NOT NULL COMMENT 'Short description',
    `required_role_flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bitmask: FRONTLINE(1), SUPPORT(2), HEALING(4), RANGED(8), SCOUT(16)',
    `min_derived_level` TINYINT UNSIGNED NULL COMMENT 'Minimum derived level (1-25)',
    `max_group_size` TINYINT UNSIGNED NOT NULL DEFAULT 5,
    `current_member_count` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `notes` TEXT NULL COMMENT 'Additional notes for applicants',
    `created_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
    `last_updated` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_leader` (`leader_guid`),
    INDEX `idx_content` (`content_type`, `content_tag`),
    INDEX `idx_active` (`is_active`, `created_at`),
    FOREIGN KEY (`leader_guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='LFG group listings';

-- LFG Members Table
CREATE TABLE IF NOT EXISTS `mortal_lfg_members` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `listing_id` INT UNSIGNED NOT NULL,
    `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
    `role_flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bitmask: FRONTLINE(1), SUPPORT(2), HEALING(4), RANGED(8), SCOUT(16)',
    `joined_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
    `status` ENUM('pending', 'accepted', 'declined') NOT NULL DEFAULT 'pending',
    INDEX `idx_listing` (`listing_id`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_status` (`status`),
    INDEX `idx_listing_guid_status` (`listing_id`, `guid`, `status`),
    FOREIGN KEY (`listing_id`) REFERENCES `mortal_lfg_listings` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='LFG listing members';

-- Add status column if it doesn't exist (for existing installations)
ALTER TABLE `mortal_lfg_members` 
ADD COLUMN IF NOT EXISTS `status` ENUM('pending', 'accepted', 'declined') NOT NULL DEFAULT 'pending' AFTER `joined_at`;

