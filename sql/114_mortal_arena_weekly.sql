-- ==================================================
-- Project Mortal Warcraft
-- Feature: Arena Weekly Tracking
-- Description: Adds per-week counters and reward tracking
-- Based on: docs/specs/34-mortal-arena-and-rating.md
-- ==================================================

ALTER TABLE `mortal_arena_team_rating`
  ADD COLUMN `weekly_games` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `games_won`,
  ADD COLUMN `weekly_wins` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `weekly_games`;

ALTER TABLE `mortal_arena_personal`
  ADD COLUMN `last_reward_week` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `qualifies_for_rewards`,
  ADD COLUMN `last_reward_band` VARCHAR(16) DEFAULT NULL AFTER `last_reward_week`;
