-- ==================================================
-- Project Mortal Warcraft
-- Feature: Mastery Trees (Repurposed Talent UI)
-- Description: Universal mastery system database
-- ==================================================

-- Mastery Point Allocation Table
CREATE TABLE IF NOT EXISTS `character_mastery_allocation` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `warlord_points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Offense/Combat mastery points',
    `guardian_points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Defense/Survival mastery points',
    `explorer_points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Utility/Exploration mastery points',
    `last_updated` INT UNSIGNED NOT NULL,
    INDEX `idx_total` (`warlord_points`, `guardian_points`, `explorer_points`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

