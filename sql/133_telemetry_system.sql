-- ==================================================
-- Project Mortal Warcraft
-- Feature: Telemetry & Balancing Framework
-- Description: Economy, activity, risk, and social telemetry tables
-- Based on: docs/specs/41-telemetry-and-balancing.md
-- ==================================================

-- Economy gold flow aggregates
CREATE TABLE IF NOT EXISTS `mortal_econ_gold_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `gold_from_tasks` BIGINT NOT NULL DEFAULT 0,
    `gold_from_dungeons` BIGINT NOT NULL DEFAULT 0,
    `gold_from_pvp` BIGINT NOT NULL DEFAULT 0,
    `gold_from_trades` BIGINT NOT NULL DEFAULT 0,
    `gold_from_npc_vendors` BIGINT NOT NULL DEFAULT 0,
    `gold_sink_repairs` BIGINT NOT NULL DEFAULT 0,
    `gold_sink_vendors` BIGINT NOT NULL DEFAULT 0,
    `gold_sink_taxes` BIGINT NOT NULL DEFAULT 0,
    `gold_sink_blessings` BIGINT NOT NULL DEFAULT 0,
    `gold_sink_upkeep` BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Material acquisition telemetry
CREATE TABLE IF NOT EXISTS `mortal_econ_mats_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `item_entry` INT UNSIGNED NOT NULL,
    `quantity_gain` INT NOT NULL DEFAULT 0,
    `quantity_loss` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`, `item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Market snapshots (auction/buy orders)
CREATE TABLE IF NOT EXISTS `mortal_econ_market_daily` (
    `date_int` INT UNSIGNED NOT NULL,
    `item_entry` INT UNSIGNED NOT NULL,
    `avg_price` BIGINT NOT NULL DEFAULT 0,
    `volume_traded` INT NOT NULL DEFAULT 0,
    `region_code` VARCHAR(32) NOT NULL,
    PRIMARY KEY (`date_int`, `item_entry`, `region_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Task board / contract activity
CREATE TABLE IF NOT EXISTS `mortal_activity_tasks_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `tasks_green` INT NOT NULL DEFAULT 0,
    `tasks_yellow` INT NOT NULL DEFAULT 0,
    `tasks_red` INT NOT NULL DEFAULT 0,
    `tasks_cityjobs` INT NOT NULL DEFAULT 0,
    `avg_task_reward` BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PvE telemetry
CREATE TABLE IF NOT EXISTS `mortal_activity_pve_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `expeditions_completed` INT NOT NULL DEFAULT 0,
    `expeditions_failed` INT NOT NULL DEFAULT 0,
    `public_dungeons_runs` INT NOT NULL DEFAULT 0,
    `boss_kills` INT NOT NULL DEFAULT 0,
    `deaths_in_pve` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Expedition run details
CREATE TABLE IF NOT EXISTS `mortal_activity_expedition_runs` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `expedition_code` VARCHAR(64) NOT NULL,
    `completed` TINYINT NOT NULL DEFAULT 0,
    `deaths` INT NOT NULL DEFAULT 0,
    `time_seconds` INT NOT NULL DEFAULT 0,
    `loot_value_est` BIGINT NOT NULL DEFAULT 0,
    INDEX `idx_guid_date` (`guid`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PvP telemetry
CREATE TABLE IF NOT EXISTS `mortal_activity_pvp_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `bg_games` INT NOT NULL DEFAULT 0,
    `bg_wins` INT NOT NULL DEFAULT 0,
    `arena_games` INT NOT NULL DEFAULT 0,
    `arena_wins` INT NOT NULL DEFAULT 0,
    `warfront_games` INT NOT NULL DEFAULT 0,
    `warfront_wins` INT NOT NULL DEFAULT 0,
    `kills_pvp` INT NOT NULL DEFAULT 0,
    `deaths_pvp` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Risk telemetry (red/yellow zones)
CREATE TABLE IF NOT EXISTS `mortal_activity_risk_daily` (
    `guid` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `deaths_redzone` INT NOT NULL DEFAULT 0,
    `deaths_yellow` INT NOT NULL DEFAULT 0,
    `items_lost_count` INT NOT NULL DEFAULT 0,
    `items_lost_value` BIGINT NOT NULL DEFAULT 0,
    `blessed_saves` INT NOT NULL DEFAULT 0,
    `durability_loss_total` BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guid`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Guild telemetry
CREATE TABLE IF NOT EXISTS `mortal_social_guild_daily` (
    `guild_id` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `member_count` INT NOT NULL DEFAULT 0,
    `joins` INT NOT NULL DEFAULT 0,
    `leaves` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`guild_id`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Stronghold telemetry (owner activity)
CREATE TABLE IF NOT EXISTS `mortal_social_stronghold_daily` (
    `stronghold_id` INT UNSIGNED NOT NULL,
    `date_int` INT UNSIGNED NOT NULL,
    `owner_guild_id` INT UNSIGNED NOT NULL,
    `times_attacked` INT NOT NULL DEFAULT 0,
    `times_defended` INT NOT NULL DEFAULT 0,
    `times_captured` INT NOT NULL DEFAULT 0,
    `resource_output` BIGINT NOT NULL DEFAULT 0,
    PRIMARY KEY (`stronghold_id`, `date_int`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Engagement buckets
ALTER TABLE `mortal_activity_summary_daily`
    ADD COLUMN `time_in_redzones` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `chat_messages`,
    ADD COLUMN `time_in_capitals` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `time_in_redzones`,
    ADD COLUMN `time_in_group` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `time_in_capitals`;
