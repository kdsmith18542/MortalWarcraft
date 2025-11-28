-- ==================================================
-- Project Mortal Warcraft
-- Feature: Web Portal Wiki Enhancements
-- Description: Enhanced wiki system for web portal
-- Based on: docs/specs/49-web-portal-wiki.md (conceptual)
-- ==================================================

-- Wiki Articles
CREATE TABLE IF NOT EXISTS `mortal_wiki_articles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `article_slug` VARCHAR(128) NOT NULL UNIQUE COMMENT 'URL-friendly identifier',
    `title` VARCHAR(255) NOT NULL,
    `content` LONGTEXT NOT NULL COMMENT 'Markdown or HTML content',
    `category` VARCHAR(64) NOT NULL COMMENT 'GAMEPLAY, LORE, GUIDES, SYSTEMS',
    `tags` JSON NULL COMMENT 'Array of tag strings',
    `author_guid` INT UNSIGNED NULL COMMENT 'characters.guid of author',
    `is_published` TINYINT(1) NOT NULL DEFAULT 0,
    `is_featured` TINYINT(1) NOT NULL DEFAULT 0,
    `view_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `last_edited_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_category` (`category`),
    INDEX `idx_published` (`is_published`),
    INDEX `idx_featured` (`is_featured`),
    INDEX `idx_slug` (`article_slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wiki articles';

-- Wiki Article Revisions
CREATE TABLE IF NOT EXISTS `mortal_wiki_revisions` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `article_id` INT UNSIGNED NOT NULL,
    `revision_number` INT UNSIGNED NOT NULL,
    `content` LONGTEXT NOT NULL,
    `edit_summary` VARCHAR(255) NULL,
    `editor_guid` INT UNSIGNED NULL,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_article` (`article_id`, `revision_number`),
    CONSTRAINT `fk_mortal_wiki_revisions_article`
        FOREIGN KEY (`article_id`) REFERENCES `mortal_wiki_articles` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wiki article revision history';

-- Wiki Categories
CREATE TABLE IF NOT EXISTS `mortal_wiki_categories` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `category_code` VARCHAR(64) NOT NULL UNIQUE,
    `category_name` VARCHAR(128) NOT NULL,
    `description` TEXT NULL,
    `parent_category_id` INT UNSIGNED NULL,
    `display_order` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_parent` (`parent_category_id`),
    INDEX `idx_order` (`display_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Wiki categories';

-- Seed Data: Default Categories
INSERT INTO `mortal_wiki_categories` (`category_code`, `category_name`, `description`, `display_order`) VALUES
('GAMEPLAY', 'Gameplay', 'Core gameplay mechanics and systems', 1),
('LORE', 'Lore', 'World lore and story', 2),
('GUIDES', 'Guides', 'Player-written guides and tutorials', 3),
('SYSTEMS', 'Systems', 'Technical system documentation', 4),
('PVE', 'PvE Content', 'Player vs Environment content', 5),
('PVP', 'PvP Content', 'Player vs Player content', 6)
ON DUPLICATE KEY UPDATE `category_name` = VALUES(`category_name`);

-- Summary
SELECT 
    'Wiki Enhancements Created' as summary,
    COUNT(*) as total_categories,
    'Ready for article creation' as status
FROM mortal_wiki_categories;

