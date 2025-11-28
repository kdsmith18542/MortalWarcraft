-- ==================================================
-- Mortal Warcraft – Conversion Automation Tagging Tables
-- Spec 67: Conversion Automation Plan
-- Target DB: world
-- ==================================================

-- Quest Conversion Map: Maps legacy quests to Mortal conversion types
CREATE TABLE IF NOT EXISTS `mortal_quest_conversion_map` (
    `quest_id` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Quest ID from quest_template',
    `conversion_type` VARCHAR(32) NOT NULL COMMENT 'STORY_REWRITE, CONTRACT_BOARD, CONTRACT_LOCAL, FLAVOR, HUB_NARRATIVE',
    `faction_tag` VARCHAR(64) DEFAULT NULL COMMENT 'LEDGER, SHRINE, CARTEL, RANGERS, optional',
    `contract_template_id` INT UNSIGNED DEFAULT NULL COMMENT 'Link to mortal_contract_template or mortal_task_template if used',
    `notes` TEXT DEFAULT NULL COMMENT 'Conversion notes, classification rationale, etc.',
    INDEX `idx_conversion_type` (`conversion_type`),
    INDEX `idx_faction_tag` (`faction_tag`),
    INDEX `idx_contract_template` (`contract_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Quest conversion mapping for Mortal Warcraft';

-- Item Tags: Categorizes items for Mortal's tier system and usage policies
CREATE TABLE IF NOT EXISTS `mortal_item_tags` (
    `item_id` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Item ID from item_template',
    `mortal_tier` TINYINT UNSIGNED DEFAULT NULL COMMENT 'Mortal gear tier T1-T5 or NULL if not in progression',
    `category` VARCHAR(32) DEFAULT NULL COMMENT 'WEAPON, ARMOR, TRINKET, CONSUMABLE, REAGENT, RUNE, APPEARANCE_ONLY, MOUNT_REINS',
    `subcategory` VARCHAR(32) DEFAULT NULL COMMENT 'SWORD, STAFF, LIGHT_ARMOR, HEAVY_ARMOR, MOUNT_REINS, etc.',
    `usage_policy` VARCHAR(32) DEFAULT NULL COMMENT 'ENABLED, DISABLED, APPEARANCE_ONLY, VENDOR_TRASH, CONVERT_TO_RUNE',
    `notes` TEXT DEFAULT NULL COMMENT 'Classification notes, tier assignment rationale, etc.',
    INDEX `idx_mortal_tier` (`mortal_tier`),
    INDEX `idx_category` (`category`),
    INDEX `idx_subcategory` (`subcategory`),
    INDEX `idx_usage_policy` (`usage_policy`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Item categorization for Mortal tier system';

-- NPC Tags: Categorizes NPCs for scaling and role assignment
CREATE TABLE IF NOT EXISTS `mortal_npc_tags` (
    `entry` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'creature_template.entry',
    `role` VARCHAR(32) DEFAULT NULL COMMENT 'TRADER, GUARD, BOSS, WEAK_MOB, MID_ELITE, WORLD_BOSS, PUBLIC_DUNGEON_ELITE',
    `faction_override` VARCHAR(64) DEFAULT NULL COMMENT 'LEDGER, SHRINE, CARTEL, RANGERS, NEUTRAL, etc.',
    `scaling_profile` VARCHAR(32) DEFAULT NULL COMMENT 'FRONTIER_ELITE, PUBLIC_DUNGEON, STRONGHOLD_DEFENDER, etc.',
    `notes` TEXT DEFAULT NULL COMMENT 'Classification notes, scaling rationale, etc.',
    INDEX `idx_role` (`role`),
    INDEX `idx_faction_override` (`faction_override`),
    INDEX `idx_scaling_profile` (`scaling_profile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='NPC categorization for Mortal scaling and role system';

-- Conversion Statistics: Tracks classification progress
CREATE TABLE IF NOT EXISTS `mortal_conversion_stats` (
    `stat_key` VARCHAR(64) NOT NULL PRIMARY KEY COMMENT 'e.g., quests_classified, spells_classified, items_classified',
    `stat_value` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Count of classified items',
    `last_updated` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last update',
    `notes` TEXT DEFAULT NULL COMMENT 'Additional statistics or metadata'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Conversion statistics and progress tracking';

-- Initialize statistics
INSERT INTO `mortal_conversion_stats` (`stat_key`, `stat_value`, `last_updated`) VALUES
('quests_classified', 0, UNIX_TIMESTAMP()),
('spells_classified', 0, UNIX_TIMESTAMP()),
('items_classified', 0, UNIX_TIMESTAMP()),
('npcs_classified', 0, UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE
    `stat_value` = VALUES(`stat_value`),
    `last_updated` = VALUES(`last_updated`);

