-- ==================================================
-- Project Mortal Warcraft
-- Feature: Economy Extensions
-- Description: NPC Buy Orders, Hot Zones, Blessed Items, Stronghold Upkeep
-- Based on: docs/specs/37-economy-system-extensions.md
-- ==================================================

-- NPC Buy Orders (Town Requests)
-- Cities and towns place buy orders for materials
CREATE TABLE IF NOT EXISTS `mortal_buy_orders` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `hub_npc_entry` INT UNSIGNED NOT NULL COMMENT 'Request board or quartermaster NPC',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry required',
    `quantity_total` INT UNSIGNED NOT NULL COMMENT 'Total desired',
    `quantity_fulfilled` INT UNSIGNED NOT NULL DEFAULT 0,
    `price_per_unit` INT UNSIGNED NOT NULL COMMENT 'Price in copper',
    `region_code` VARCHAR(32) NOT NULL COMMENT 'Internal region identifier',
    `expires_time` INT UNSIGNED NOT NULL,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 = high priority',
    `notes` VARCHAR(255) NULL,
    INDEX `idx_hub` (`hub_npc_entry`),
    INDEX `idx_item` (`item_entry`),
    INDEX `idx_region` (`region_code`),
    INDEX `idx_expires` (`expires_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='NPC buy orders (town requests)';

-- Regional Economic Bonuses (Hot Zones)
-- Weekly/daily economic hot spots with bonus rewards
CREATE TABLE IF NOT EXISTS `mortal_regional_bonuses` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `region_code` VARCHAR(32) NOT NULL,
    `bonus_type` VARCHAR(32) NOT NULL COMMENT 'TASK_GOLD, BUYORDER_PRICE, COURIER_GOLD',
    `multiplier` FLOAT NOT NULL COMMENT 'e.g. 1.3 for +30%',
    `start_time` INT UNSIGNED NOT NULL,
    `end_time` INT UNSIGNED NOT NULL,
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_region_type_time` (`region_code`, `bonus_type`, `start_time`),
    INDEX `idx_region` (`region_code`),
    INDEX `idx_time` (`start_time`, `end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Regional economic bonuses (hot zones)';

-- Blessed Items (Soft Insurance System)
-- Items protected from dropping on death in Red Zones
CREATE TABLE IF NOT EXISTS `mortal_blessed_items` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'characters.guid',
    `item_guid` INT UNSIGNED NOT NULL COMMENT 'item_instance.guid',
    `bless_end_time` INT UNSIGNED NOT NULL COMMENT 'Unix time when blessing expires',
    `charges_remaining` INT UNSIGNED NULL COMMENT 'Number of death protections remaining',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_guid` (`guid`),
    INDEX `idx_item` (`item_guid`),
    INDEX `idx_expires` (`bless_end_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blessed items (protected from death loot)';

-- Stronghold Upkeep
-- Ongoing upkeep requirements for strongholds
CREATE TABLE IF NOT EXISTS `mortal_stronghold_upkeep` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `stronghold_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_strongholds.id',
    `upkeep_gold` INT UNSIGNED NOT NULL COMMENT 'Gold required per cycle',
    `upkeep_mats` VARCHAR(255) NULL COMMENT 'e.g. IRON_BAR:200;STONE:300',
    `cycle_seconds` INT UNSIGNED NOT NULL COMMENT 'e.g. 604800 for weekly',
    `last_cycle_time` INT UNSIGNED NOT NULL,
    `missed_cycles` INT UNSIGNED NOT NULL DEFAULT 0,
    `status` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=stable, 1=weakened, 2=decaying',
    UNIQUE KEY `uk_stronghold` (`stronghold_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_cycle` (`last_cycle_time`),
    FOREIGN KEY (`stronghold_id`) REFERENCES `mortal_strongholds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Stronghold upkeep requirements';

-- Task Board Definitions (if not exists)
-- Defines available task types and templates
CREATE TABLE IF NOT EXISTS `mortal_tasks_def` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL COMMENT 'HUNT_BOARS_ELWYNN_TG',
    `type` VARCHAR(16) NOT NULL COMMENT 'HUNT, GATHER, DELIVER, COURIER, ESCORT',
    `risk_tier` VARCHAR(8) NOT NULL COMMENT 'T_G, T_Y, T_R',
    `min_skill_band` INT UNSIGNED NOT NULL DEFAULT 0,
    `max_skill_band` INT UNSIGNED NOT NULL DEFAULT 999,
    `zone_id` INT UNSIGNED NOT NULL,
    `param1` INT UNSIGNED NULL COMMENT 'creature entry, item entry, etc.',
    `param2` INT UNSIGNED NULL COMMENT 'count, crate weight, etc.',
    `base_gold` INT UNSIGNED NOT NULL DEFAULT 0,
    `base_fame` INT UNSIGNED NOT NULL DEFAULT 0,
    `flags` INT UNSIGNED NOT NULL DEFAULT 0,
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_code` (`code`),
    INDEX `idx_type` (`type`),
    INDEX `idx_risk` (`risk_tier`),
    INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Task board definitions';

-- Task Instances
-- Active task instances available at task boards
CREATE TABLE IF NOT EXISTS `mortal_tasks_instance` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `def_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_tasks_def',
    `hub_npc_entry` INT UNSIGNED NOT NULL COMMENT 'Task Board NPC',
    `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=available, 1=claimed, 2=completed, 3=expired',
    `assigned_guid` INT UNSIGNED NULL COMMENT 'characters.guid if claimed',
    `created_time` INT UNSIGNED NOT NULL,
    `expire_time` INT UNSIGNED NOT NULL,
    `reward_gold` INT UNSIGNED NOT NULL,
    `reward_fame` INT UNSIGNED NOT NULL,
    `reward_bonus` VARCHAR(64) NULL COMMENT 'Optional item reward code bundle',
    INDEX `idx_def` (`def_id`),
    INDEX `idx_hub` (`hub_npc_entry`),
    INDEX `idx_state` (`state`),
    INDEX `idx_assigned` (`assigned_guid`),
    INDEX `idx_expires` (`expire_time`),
    FOREIGN KEY (`def_id`) REFERENCES `mortal_tasks_def` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Task board instances';

