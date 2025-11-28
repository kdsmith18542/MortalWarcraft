-- ==================================================
-- Project Mortal Warcraft: Arena & Duel Rankings
-- Module: mod-mortal-core
-- Feature: Ranked PvP leaderboards
-- ==================================================

-- Character Duel Rankings
CREATE TABLE IF NOT EXISTS `character_duel_rankings` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
  `rating` INT UNSIGNED NOT NULL DEFAULT 1500 COMMENT 'ELO rating (default 1500)',
  `wins` INT UNSIGNED NOT NULL DEFAULT 0,
  `losses` INT UNSIGNED NOT NULL DEFAULT 0,
  `rank` INT UNSIGNED NULL DEFAULT NULL COMMENT 'Current rank (calculated)',
  `season_wins` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Wins this season',
  `season_losses` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Losses this season',
  `last_updated` TIMESTAMP NOT NULL DEFAULT 0 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`guid`),
  INDEX `idx_rating` (`rating`),
  INDEX `idx_rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Ranked duel leaderboard';

-- Arena Team Rankings (Modified for Classless)
-- Note: Uses existing WoW arena_team table but removes class requirements
-- This table tracks additional classless-specific data
CREATE TABLE IF NOT EXISTS `arena_team_classless` (
  `arenaTeamId` INT UNSIGNED NOT NULL COMMENT 'Arena Team ID (links to arena_team)',
  `team_rating` INT UNSIGNED NOT NULL DEFAULT 1500,
  `season_wins` INT UNSIGNED NOT NULL DEFAULT 0,
  `season_losses` INT UNSIGNED NOT NULL DEFAULT 0,
  `no_class_restriction` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Flag for classless system',
  PRIMARY KEY (`arenaTeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Classless arena team data';

