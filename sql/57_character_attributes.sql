-- ==================================================
-- Project Mortal Warcraft
-- Feature: Character Attributes & Derived Level Cache (Spec 1)
-- ==================================================

-- Player attribute snapshot per character.
CREATE TABLE IF NOT EXISTS `mortal_character_attributes` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'FK characters.guid',
  `strength` SMALLINT NOT NULL DEFAULT 50,
  `agility` SMALLINT NOT NULL DEFAULT 50,
  `stamina` SMALLINT NOT NULL DEFAULT 50,
  `intellect` SMALLINT NOT NULL DEFAULT 50,
  `spirit` SMALLINT NOT NULL DEFAULT 50,
  `last_update` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`),
  CONSTRAINT `fk_mortal_attrs_character` FOREIGN KEY (`guid`) REFERENCES `characters`(`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mortal attribute sheet per character.';

-- Derived level cache so we can answer UI/API requests without recomputing skills every time.
CREATE TABLE IF NOT EXISTS `mortal_derived_level_cache` (
  `guid` INT UNSIGNED NOT NULL,
  `derived_level` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `total_skill_points` FLOAT NOT NULL DEFAULT 0,
  `last_skill_checksum` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`),
  CONSTRAINT `fk_mortal_level_cache_character` FOREIGN KEY (`guid`) REFERENCES `characters`(`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cached derived level + total skill points.';

-- Seed existing characters with baseline rows (optional).
INSERT INTO `mortal_character_attributes` (`guid`) 
SELECT `guid` FROM `characters`
ON DUPLICATE KEY UPDATE `last_update` = VALUES(`last_update`);

INSERT INTO `mortal_derived_level_cache` (`guid`) 
SELECT `guid` FROM `characters`
ON DUPLICATE KEY UPDATE `updated_at` = VALUES(`updated_at`);
