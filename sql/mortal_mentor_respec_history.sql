-- Mortal Warcraft: Mentor Respec History Tracking
-- Tracks all respec operations performed by the mentor system

CREATE TABLE IF NOT EXISTS `mortal_mentor_respec_history` (
    `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT(11) UNSIGNED NOT NULL COMMENT 'Player GUID',
    `respec_type` ENUM('attributes','skills','mastery','full') NOT NULL COMMENT 'Type of respec performed',
    `skill_points_before` FLOAT NOT NULL DEFAULT 0 COMMENT 'Total skill points before respec',
    `skill_points_after` FLOAT NOT NULL DEFAULT 0 COMMENT 'Total skill points after respec',
    `cost_paid` INT(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Gold cost paid (0 for free mentor respecs)',
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When the respec was performed',
    `mentor_free` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Whether this was a free mentor respec (1) or paid respec (0)',
    PRIMARY KEY (`id`),
    KEY `guid` (`guid`),
    KEY `timestamp` (`timestamp`),
    KEY `respec_type` (`respec_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tracks mentor respec history for audit and statistics';

-- Add some sample data for testing
INSERT INTO `mortal_mentor_respec_history` (`guid`, `respec_type`, `skill_points_before`, `skill_points_after`, `cost_paid`, `mentor_free`) VALUES
(1, 'attributes', 45.5, 45.5, 0, 1),
(1, 'skills', 67.2, 0, 0, 1),
(2, 'full', 123.8, 0, 0, 1);