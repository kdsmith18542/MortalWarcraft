-- ============================================================================
-- Mortal Warcraft Overhaul - Character Database Tables
-- Part of the mod-mortal AzerothCore module
-- ============================================================================

-- Character Skills
DROP TABLE IF EXISTS `character_mortal_skills`;
CREATE TABLE `character_mortal_skills` (
    `guid` INT UNSIGNED NOT NULL,
    `skill_id` INT UNSIGNED NOT NULL,
    `value` INT UNSIGNED NOT NULL DEFAULT 0,
    `max_value` INT UNSIGNED NOT NULL DEFAULT 100,
    `state` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Character Attributes
DROP TABLE IF EXISTS `character_mortal_attributes`;
CREATE TABLE `character_mortal_attributes` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `strength` INT UNSIGNED NOT NULL DEFAULT 0,
    `agility` INT UNSIGNED NOT NULL DEFAULT 0,
    `stamina` INT UNSIGNED NOT NULL DEFAULT 0,
    `intellect` INT UNSIGNED NOT NULL DEFAULT 0,
    `spirit` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Regional Banking
DROP TABLE IF EXISTS `character_regional_bank`;
CREATE TABLE `character_regional_bank` (
    `guid` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `slot` TINYINT UNSIGNED NOT NULL,
    `item_guid` INT UNSIGNED NOT NULL DEFAULT 0,
    `item_entry` MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
    `count` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `zone_id`, `slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Criminal Flags
DROP TABLE IF EXISTS `character_criminal_flags`;
CREATE TABLE `character_criminal_flags` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `criminal_until` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Notoriety System
DROP TABLE IF EXISTS `character_notoriety`;
CREATE TABLE `character_notoriety` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `notoriety` INT NOT NULL DEFAULT 0,
    `last_updated` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Bounties
DROP TABLE IF EXISTS `mortal_bounties`;
CREATE TABLE `mortal_bounties` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `poster_guid` INT UNSIGNED NOT NULL,
    `target_guid` INT UNSIGNED NOT NULL,
    `bounty_amount` INT UNSIGNED NOT NULL DEFAULT 0,
    `posted_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `is_claimed` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `claimed_by` INT UNSIGNED DEFAULT NULL,
    `claimed_at` INT UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Derived Level Cache
DROP TABLE IF EXISTS `character_derived_level`;
CREATE TABLE `character_derived_level` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `derived_level` TINYINT UNSIGNED NOT NULL DEFAULT 1,
    `total_skill_points` INT UNSIGNED NOT NULL DEFAULT 0,
    `last_updated` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Player Tasks
DROP TABLE IF EXISTS `character_mortal_tasks`;
CREATE TABLE `character_mortal_tasks` (
    `guid` INT UNSIGNED NOT NULL,
    `task_id` INT UNSIGNED NOT NULL,
    `progress` INT UNSIGNED NOT NULL DEFAULT 0,
    `target_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `completed` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `reward_claimed` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Strongholds
DROP TABLE IF EXISTS `mortal_strongholds`;
CREATE TABLE `mortal_strongholds` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `zone_id` INT UNSIGNED NOT NULL,
    `owning_guild` INT UNSIGNED NOT NULL DEFAULT 0,
    `claimed_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `pos_x` FLOAT NOT NULL DEFAULT 0,
    `pos_y` FLOAT NOT NULL DEFAULT 0,
    `pos_z` FLOAT NOT NULL DEFAULT 0,
    `map_id` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Territory Control Points
DROP TABLE IF EXISTS `mortal_tcp`;
CREATE TABLE `mortal_tcp` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `zone_id` INT UNSIGNED NOT NULL,
    `owning_guild` INT UNSIGNED NOT NULL DEFAULT 0,
    `capture_progress` INT UNSIGNED NOT NULL DEFAULT 0,
    `pos_x` FLOAT NOT NULL DEFAULT 0,
    `pos_y` FLOAT NOT NULL DEFAULT 0,
    `pos_z` FLOAT NOT NULL DEFAULT 0,
    `map_id` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Guild Season Scores
DROP TABLE IF EXISTS `mortal_guild_season_scores`;
CREATE TABLE `mortal_guild_season_scores` (
    `guild_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `season` INT UNSIGNED NOT NULL DEFAULT 1,
    `score` INT UNSIGNED NOT NULL DEFAULT 0,
    `strongholds_held` INT UNSIGNED NOT NULL DEFAULT 0,
    `sieges_won` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- PvP Kill Tracking
DROP TABLE IF EXISTS `mortal_pvp_kills`;
CREATE TABLE `mortal_pvp_kills` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `killer_guid` INT UNSIGNED NOT NULL,
    `victim_guid` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `killed_at` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Market Stalls
DROP TABLE IF EXISTS `mortal_market_stalls`;
CREATE TABLE `mortal_market_stalls` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `owner_guid` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `rent_until` INT UNSIGNED NOT NULL DEFAULT 0,
    `stall_name` VARCHAR(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Market Items
DROP TABLE IF EXISTS `mortal_market_items`;
CREATE TABLE `mortal_market_items` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `stall_id` INT UNSIGNED NOT NULL,
    `item_entry` MEDIUMINT UNSIGNED NOT NULL,
    `item_count` INT UNSIGNED NOT NULL DEFAULT 1,
    `price_per_item` INT UNSIGNED NOT NULL DEFAULT 0,
    `listed_at` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Contracts
DROP TABLE IF EXISTS `mortal_contracts`;
CREATE TABLE `mortal_contracts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `template_id` INT UNSIGNED NOT NULL,
    `owner_guid` INT UNSIGNED NOT NULL,
    `contractor_guid` INT UNSIGNED DEFAULT NULL,
    `progress` INT UNSIGNED NOT NULL DEFAULT 0,
    `target_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `time_remaining` INT UNSIGNED NOT NULL DEFAULT 0,
    `completed` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `failed` TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Courier Contracts
DROP TABLE IF EXISTS `mortal_courier_contracts`;
CREATE TABLE `mortal_courier_contracts` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `owner_guid` INT UNSIGNED NOT NULL,
    `contractor_guid` INT UNSIGNED DEFAULT NULL,
    `start_zone` INT UNSIGNED NOT NULL,
    `end_zone` INT UNSIGNED NOT NULL,
    `collateral` INT UNSIGNED NOT NULL DEFAULT 0,
    `reward` INT UNSIGNED NOT NULL DEFAULT 0,
    `completed` TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Feature Flags
DROP TABLE IF EXISTS `mortal_feature_flags`;
CREATE TABLE `mortal_feature_flags` (
    `flag_name` VARCHAR(64) NOT NULL PRIMARY KEY,
    `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Analytics Log
DROP TABLE IF EXISTS `mortal_log_events`;
CREATE TABLE `mortal_log_events` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `event_type` VARCHAR(32) NOT NULL,
    `player_guid` INT UNSIGNED DEFAULT NULL,
    `zone_id` INT UNSIGNED DEFAULT NULL,
    `data` TEXT DEFAULT NULL,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
