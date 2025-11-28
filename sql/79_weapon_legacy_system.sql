-- ==================================================
-- Mortal Warcraft – Weapon Legacy & History System
-- Spec 61: Weapon Legacy and History
-- Target DB: world (definitions), characters (history & codex)
-- ==================================================

-- Weapon History: Tracks individual weapon instance achievements
CREATE TABLE IF NOT EXISTS `mortal_weapon_history` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `item_guid` BIGINT UNSIGNED NOT NULL COMMENT 'Unique item instance GUID',
    `owner_guid` INT UNSIGNED NOT NULL COMMENT 'Current or original owner character GUID',
    `weapon_code` VARCHAR(64) DEFAULT NULL COMMENT 'Optional classification tag (e.g., SWORD_T1, STAFF_T2)',
    `pvp_kills` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'PvP kills while wielding this weapon',
    `boss_kills` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Boss kills in dungeons/raids',
    `events_participated` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'World events completed while wielding',
    `trials_completed` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Trials completed while wielding',
    `legacy_tier` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Derived from milestones (0-4+)',
    `legacy_score` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cumulative legacy score',
    `created_ts` INT UNSIGNED NOT NULL COMMENT 'Timestamp when history started tracking',
    `last_update_ts` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
    UNIQUE KEY `uniq_item_guid` (`item_guid`),
    INDEX `idx_owner_guid` (`owner_guid`),
    INDEX `idx_legacy_tier` (`legacy_tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Weapon history tracking for individual weapon instances';

-- Weapon Legacy Codex: Per-character tracking of best achievements per weapon template
CREATE TABLE IF NOT EXISTS `mortal_weapon_legacy_codex` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
    `weapon_template` INT UNSIGNED NOT NULL COMMENT 'item_template.entry',
    `max_legacy_tier` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Best tier ever achieved on any instance',
    `legacy_points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cumulative legacy score across all instances',
    `last_update_ts` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
    UNIQUE KEY `uniq_guid_template` (`guid`, `weapon_template`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_weapon_template` (`weapon_template`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Per-character weapon legacy codex tracking';

-- Legacy Definitions: Defines tier thresholds and rewards
CREATE TABLE IF NOT EXISTS `mortal_weapon_legacy_definitions` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `weapon_template` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Specific weapon template ID, or 0 for generic class',
    `weapon_class_mask` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bitmask for weapon classes (1=sword, 2=axe, etc.)',
    `tier` INT UNSIGNED NOT NULL COMMENT 'Legacy tier (1-4+)',
    `required_score` INT UNSIGNED NOT NULL COMMENT 'Required legacy score to reach this tier',
    `reward_json` JSON NOT NULL COMMENT 'Reward data: appearance unlock, title, cosmetic FX, etc.',
    `description` TEXT DEFAULT NULL COMMENT 'Tier description for tooltips',
    UNIQUE KEY `uniq_weapon_tier` (`weapon_template`, `tier`),
    INDEX `idx_weapon_template` (`weapon_template`),
    INDEX `idx_tier` (`tier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Weapon legacy tier definitions and rewards';

-- Example legacy definitions (generic tiers for all weapons)
INSERT INTO `mortal_weapon_legacy_definitions` (`weapon_template`, `tier`, `required_score`, `reward_json`, `description`) VALUES
(0, 1, 10, '{"tooltip": "This weapon has seen blood.", "visual": "minor_glow"}', 'Tier I: Blooded'),
(0, 2, 50, '{"tooltip": "This weapon has proven itself in battle.", "visual": "etchings"}', 'Tier II: Veteran'),
(0, 3, 150, '{"tooltip": "This weapon has earned its legend.", "appearance_unlock": true, "visual": "unique_glow"}', 'Tier III: Legendary'),
(0, 4, 500, '{"tooltip": "This weapon has carved its name in history.", "epithet": true, "appearance_unlock": true, "visual": "epic_glow"}', 'Tier IV: Mythic');

