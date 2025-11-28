-- ==================================================
-- Project Mortal Warcraft
-- Feature: Traveler's Notes System
-- Description: Asynchronous social messaging (Elden Ring style)
-- Based on: docs/specs/45-eldens-eve-layer.md
-- ==================================================

-- Note Templates
-- Predefined text fragments for notes
CREATE TABLE IF NOT EXISTS `mortal_notes_templates` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `category` VARCHAR(32) NOT NULL COMMENT 'WARNING, RESOURCE, SECRET, HUMOR',
    `text_base` VARCHAR(64) NOT NULL COMMENT 'e.g. Enemy ahead, Hidden path',
    `text_suffix` VARCHAR(64) NULL COMMENT 'e.g. on the left, above',
    INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Traveler note templates';

-- Placed Notes
-- Notes placed by players in the world
CREATE TABLE IF NOT EXISTS `mortal_traveler_notes` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `creator_guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `template_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_notes_templates.id',
    `created_time` INT UNSIGNED NOT NULL,
    `expires_time` INT UNSIGNED NOT NULL,
    `upvotes` INT UNSIGNED NOT NULL DEFAULT 0,
    `downvotes` INT UNSIGNED NOT NULL DEFAULT 0,
    `tips_copper` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'reserved (e.g. muted/spam)',
    INDEX `idx_creator` (`creator_guid`),
    INDEX `idx_location` (`map_id`, `zone_id`, `x`, `y`),
    INDEX `idx_expires` (`expires_time`),
    INDEX `idx_template` (`template_id`),
    FOREIGN KEY (`template_id`) REFERENCES `mortal_notes_templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Traveler notes placed in world';

-- Note Ratings
-- Tracks which players have rated which notes
CREATE TABLE IF NOT EXISTS `mortal_traveler_note_ratings` (
    `note_id` INT UNSIGNED NOT NULL,
    `player_guid` INT UNSIGNED NOT NULL,
    `rating` TINYINT NOT NULL COMMENT '1=helpful, -1=misleading',
    `rated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`note_id`, `player_guid`),
    INDEX `idx_player` (`player_guid`),
    FOREIGN KEY (`note_id`) REFERENCES `mortal_traveler_notes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Note ratings';

-- Seed Data: Note Templates
INSERT INTO `mortal_notes_templates` (`category`, `text_base`, `text_suffix`) VALUES
('WARNING', 'Enemy ahead', NULL),
('WARNING', 'Ambush ahead', NULL),
('WARNING', 'Dangerous area', 'ahead'),
('RESOURCE', 'Ore vein', 'nearby'),
('RESOURCE', 'Herb patch', 'here'),
('RESOURCE', 'Rich resource', 'in this area'),
('SECRET', 'Hidden path', 'on the left'),
('SECRET', 'Secret entrance', 'above'),
('SECRET', 'Shortcut', 'through here'),
('HUMOR', 'Try jumping', NULL),
('HUMOR', 'Praise the sun', NULL),
('HUMOR', 'Try finger', 'but hole')
ON DUPLICATE KEY UPDATE `text_base` = VALUES(`text_base`);

