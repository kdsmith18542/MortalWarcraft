-- ==================================================
-- Project Mortal Warcraft
-- Feature: Web Portal Wiki Module
-- Description: In-portal game wiki / knowledge base
-- Based on: docs/specs/49-webportal-wiki-spec.md
-- ==================================================

-- Wiki Pages
-- Stores the current live version of each page
CREATE TABLE IF NOT EXISTS `wiki_pages` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `slug` VARCHAR(128) NOT NULL UNIQUE,
    `title` VARCHAR(256) NOT NULL,
    `summary` VARCHAR(512) NULL,
    `content_markdown` MEDIUMTEXT NOT NULL,
    `category` VARCHAR(64) NOT NULL DEFAULT 'general' COMMENT 'mechanics, lore, locations, builds, dev',
    `tags` VARCHAR(512) NULL COMMENT 'comma-separated or JSON',
    `icon` VARCHAR(128) NULL COMMENT 'optional icon key/name',
    `is_published` TINYINT(1) NOT NULL DEFAULT 1,
    `is_locked` TINYINT(1) NOT NULL DEFAULT 0,
    `visibility` VARCHAR(32) NOT NULL DEFAULT 'public' COMMENT 'public, logged_in, char_gated',
    `min_role_required` VARCHAR(32) NOT NULL DEFAULT 'reader' COMMENT 'reader, contributor, moderator, admin',
    `codex_requirements` JSON NULL COMMENT 'e.g. ["CODEX_RUNECRAFTING_INTRO"]',
    `created_by_user_id` INT UNSIGNED NOT NULL,
    `updated_by_user_id` INT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT 0 ,
    INDEX `idx_category` (`category`),
    INDEX `idx_visibility` (`visibility`),
    INDEX `idx_published` (`is_published`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wiki pages';

-- Wiki Page Versions
-- Tracks version history for rollback/audit
CREATE TABLE IF NOT EXISTS `wiki_page_versions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `page_id` INT UNSIGNED NOT NULL,
    `version_number` INT UNSIGNED NOT NULL,
    `title` VARCHAR(256) NOT NULL,
    `summary` VARCHAR(512) NULL,
    `content_markdown` MEDIUMTEXT NOT NULL,
    `category` VARCHAR(64) NOT NULL,
    `tags` VARCHAR(512) NULL,
    `icon` VARCHAR(128) NULL,
    `visibility` VARCHAR(32) NOT NULL,
    `min_role_required` VARCHAR(32) NOT NULL,
    `codex_requirements` JSON NULL,
    `edited_by_user_id` INT UNSIGNED NOT NULL,
    `edited_at` TIMESTAMP NOT NULL DEFAULT 0,
    `comment` VARCHAR(512) NULL,
    INDEX `idx_page_version` (`page_id`, `version_number`),
    FOREIGN KEY (`page_id`) REFERENCES `wiki_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wiki page version history';

-- Wiki Page Links (Optional)
-- For link graphs / backlink navigation
CREATE TABLE IF NOT EXISTS `wiki_page_links` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `from_page_id` INT UNSIGNED NOT NULL,
    `to_page_id` INT UNSIGNED NOT NULL,
    `link_text` VARCHAR(256) NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT 0,
    INDEX `idx_from_page` (`from_page_id`),
    INDEX `idx_to_page` (`to_page_id`),
    FOREIGN KEY (`from_page_id`) REFERENCES `wiki_pages` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`to_page_id`) REFERENCES `wiki_pages` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wiki page links';

