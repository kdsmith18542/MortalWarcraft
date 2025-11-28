-- ==================================================
-- Project Mortal Warcraft
-- Feature: Achievement Rewards Mapping
-- Description: Maps achievements to title rewards
-- Based on: docs/specs/36-mortal-achievements-and-titles-core.md
-- ==================================================

-- Achievement Rewards Table
-- Maps achievements to title rewards
CREATE TABLE IF NOT EXISTS `mortal_achievement_rewards` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `achievement_id` INT UNSIGNED NOT NULL COMMENT 'Achievement ID (500000-509999 range)',
  `title_name` VARCHAR(100) NULL COMMENT 'Title name from mortal_titles.name',
  `item_entry` INT UNSIGNED NULL COMMENT 'Item reward (optional)',
  `notes` VARCHAR(255) NULL,
  UNIQUE KEY `uk_achievement` (`achievement_id`),
  INDEX `idx_title` (`title_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Achievement reward mappings';

