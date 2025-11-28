-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Mortal Core Registry Tables
-- Description: Creates tables for gear visuals, mount visuals, companions, and mercenary system
-- Based on: docs/specs/30-db-migrations-mortal-core.md
-- ==================================================

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. mortal_gear_visuals
-- Maps Mortal custom gear items to their visual sources (WotLK item models)
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `mortal_gear_visuals` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `mortal_item_entry` INT NOT NULL COMMENT 'Custom item entry (700000-709999 for PvE, 710000-719999 for PvP)',
  `mortal_tier` VARCHAR(8) NOT NULL COMMENT 'M-T1 through M-T5 or P1 through P6',
  `category` VARCHAR(16) NOT NULL COMMENT 'pve or pvp',
  `armor_type` VARCHAR(8) NOT NULL COMMENT 'plate, mail, leather, cloth',
  `slot` VARCHAR(16) NOT NULL COMMENT 'head, chest, legs, hands, shoulders, etc.',
  `source_type` VARCHAR(32) NOT NULL COMMENT 't7, t8, t9, t10, s5, s6, s7, s8, etc.',
  `source_item_entry` INT NOT NULL COMMENT 'Original WotLK item entry',
  `displayid` INT NOT NULL COMMENT 'Copied from item_template.displayid',
  `notes` VARCHAR(255) NULL,
  INDEX `idx_mortal_item` (`mortal_item_entry`),
  INDEX `idx_source_item` (`source_item_entry`),
  INDEX `idx_tier_category` (`mortal_tier`, `category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Maps Mortal gear to WotLK visual sources';

-- ------------------------------------------------------------------
-- 2. mortal_mount_visuals
-- Defines Mortal Living Mounts (Reins items) with tier, speed, and capacity
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `mortal_mount_visuals` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `mortal_item_entry` INT NOT NULL COMMENT 'Reins item entry (720000-729999 range)',
  `mortal_mount_tier` VARCHAR(8) NOT NULL COMMENT 'M-M1, M-M2, M-M3, M-M4',
  `speed_multiplier` FLOAT NOT NULL COMMENT 'e.g. 0.6, 1.0, 1.2, 1.3',
  `capacity_slots` INT NOT NULL COMMENT 'Extra saddlebag slots (0-16)',
  `source_item_entry` INT NOT NULL COMMENT 'Original WotLK mount item',
  `source_spell_id` INT NOT NULL COMMENT 'Original mount spell',
  `source_creature_id` INT NULL COMMENT 'Optional creature_template entry',
  `notes` VARCHAR(255) NULL,
  INDEX `idx_mortal_mount_item` (`mortal_item_entry`),
  INDEX `idx_mount_tier` (`mortal_mount_tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mortal Living Mount definitions';

-- ------------------------------------------------------------------
-- 3. mortal_companions
-- Tracks Bond & Hunger for all companion types (pets, mercs, mounts)
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `mortal_companions` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner_guid` INT NOT NULL COMMENT 'characters.guid',
  `companion_guid` BIGINT NOT NULL COMMENT 'pet/merc creature GUID or mount item instance GUID',
  `companion_type` TINYINT NOT NULL COMMENT '0=pet, 1=merc, 2=mount',
  `hunger` TINYINT NOT NULL DEFAULT 100 COMMENT '0-100',
  `bond` TINYINT NOT NULL DEFAULT 0 COMMENT '0-100',
  `last_update` INT NOT NULL COMMENT 'Unix timestamp (seconds)',
  INDEX `idx_owner_type` (`owner_guid`, `companion_type`),
  INDEX `idx_companion` (`companion_guid`, `companion_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Companion Bond & Hunger tracking';

-- ------------------------------------------------------------------
-- 4. mortal_merc_templates
-- Defines available mercenary archetypes (tank/healer/DPS)
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `mortal_merc_templates` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(64) NOT NULL COMMENT 'e.g. "Mortal Field Medic"',
  `role` VARCHAR(16) NOT NULL COMMENT 'tank, healer, melee_dps, ranged_dps',
  `base_gear_tier` VARCHAR(8) NOT NULL COMMENT 'e.g. M-T2, M-T3',
  `creature_entry` INT NOT NULL COMMENT 'creature_template.entry (600000-609999 range)',
  `base_wage` INT NOT NULL COMMENT 'Gold cost baseline',
  `max_bond_bonus` TINYINT NOT NULL DEFAULT 10 COMMENT 'Max % performance bonus at bond=100',
  `notes` VARCHAR(255) NULL,
  INDEX `idx_role` (`role`),
  INDEX `idx_tier` (`base_gear_tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Mercenary templates';

-- ------------------------------------------------------------------
-- 5. mortal_merc_contracts
-- Tracks active mercenary contracts (player hires)
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `mortal_merc_contracts` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `owner_guid` INT NOT NULL COMMENT 'characters.guid',
  `merc_template_id` INT NOT NULL COMMENT 'mortal_merc_templates.id',
  `merc_creature_guid` BIGINT NULL COMMENT 'Spawned creature GUID if active',
  `start_time` INT NOT NULL COMMENT 'Unix timestamp',
  `end_time` INT NOT NULL COMMENT 'Unix timestamp',
  `active` TINYINT NOT NULL DEFAULT 0,
  `last_paid_time` INT NOT NULL COMMENT 'Last upkeep payment',
  `daily_wage` INT NOT NULL COMMENT 'Effective wage for this contract',
  `notes` VARCHAR(255) NULL,
  INDEX `idx_owner_active` (`owner_guid`, `active`),
  INDEX `idx_template` (`merc_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Active mercenary contracts';

COMMIT;

SELECT 'Mortal Core Registry tables created successfully.' AS result;
SELECT 'Tables: mortal_gear_visuals, mortal_mount_visuals, mortal_companions, mortal_merc_templates, mortal_merc_contracts' AS result;

