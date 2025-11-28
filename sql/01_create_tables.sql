-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Module: mod-mortal-core
-- Description: Stores the custom skill progression.
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_mortal_skills` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `skill_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Custom Skill ID (1001=Swords, etc)',
  `value` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Current Skill Value (allows fractional gains)',
  `max_value` SMALLINT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Individual Skill Cap',
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '0=Locked, 1=Up, 2=Down',
  PRIMARY KEY (`guid`, `skill_id`),
  INDEX `idx_guid_state` (`guid`, `state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Custom progression system for Mortal Warcraft';

-- ==================================================
-- Reference: Proposed Custom Skill IDs
-- ==================================================
-- 1000: Unarmed
-- 1001: Swordsmanship
-- 1002: Axe Mastery
-- 1003: Mace Mastery
-- 1004: Archery
-- 1005: Shield Training
-- 1006: Heavy Armor Training
-- 1007: Light Armor Training
-- 2001: Mining
-- 2002: Herb Gathering
-- 2003: Butchery (Skinning+)
-- 3001: Evocation (Mana Pool)
-- 3002: Destruction (Spell Power)
-- 3003: Restoration (Healing Power)
-- ==================================================

-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Module: mod-mortal-core
-- Feature: Regional Banking
-- Description: Splits bank storage by Zone ID.
-- ==================================================

CREATE TABLE IF NOT EXISTS `character_regional_bank` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID (e.g., 1519 for Stormwind)',
  `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Bank Slot (0-27 for main bank, + bags)',
  `item_guid` INT UNSIGNED NOT NULL COMMENT 'GUID of the Item instance',
  `item_entry` MEDIUMINT UNSIGNED NOT NULL COMMENT 'Item Template ID',
  `count` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Stack Count',
  PRIMARY KEY (`guid`, `zone_id`, `slot`),
  INDEX `idx_guid_zone` (`guid`, `zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores items per zone-based bank';

-- Note: You will need to modify Player::GetBankBag() in C++ 
-- to query this table instead of the default character_inventory 
-- when the player interacts with a Banker NPC.


