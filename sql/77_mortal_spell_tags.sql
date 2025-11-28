-- ==================================================
-- Mortal Warcraft – Spell & Ability Library Tagging System
-- Spec 64: Classless Spell & Ability Library
-- Target DB: world
-- ==================================================

-- Spell Tagging Table: Categorizes all spells for Mortal's classless system
CREATE TABLE IF NOT EXISTS `mortal_spell_tags` (
    `spell_id` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Spell ID from spell_template',
    `category` VARCHAR(32) NOT NULL COMMENT 'CORE, LEARNED, RUNE, MASTERY, AUGMENT, REMOVED',
    `subcategory` VARCHAR(32) DEFAULT NULL COMMENT 'MARTIAL, ARCANE, HEALING, CC, MOBILITY, UTILITY, PVE_ONLY, etc.',
    `pvp_flags` VARCHAR(64) DEFAULT NULL COMMENT 'PVP_REDUCED, PVP_DISABLED, PVP_CC_CAP, PVP_DURATION_CAP, etc.',
    `source_type` VARCHAR(32) DEFAULT NULL COMMENT 'BOOK, TRIAL, FACTION, DROP, CRAFT, BASELINE, RUNE_ITEM',
    `required_skill_id` INT UNSIGNED DEFAULT NULL COMMENT 'Required skill ID (weapon mastery, etc.)',
    `required_skill_level` INT UNSIGNED DEFAULT NULL COMMENT 'Required skill level',
    `is_combat_ability` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Counts toward active ability cap (8-12)',
    `max_rank_spell_id` INT UNSIGNED DEFAULT NULL COMMENT 'Canonical spell ID if this is a rank (for rank pruning)',
    `pvp_duration_cap_seconds` INT UNSIGNED DEFAULT NULL COMMENT 'Max duration in PvP (for CC, buffs, etc.)',
    `pvp_coefficient_modifier` FLOAT DEFAULT 1.0 COMMENT 'Damage/healing multiplier in PvP (0.0-1.0)',
    `notes` TEXT DEFAULT NULL COMMENT 'Classification notes, balance notes, etc.',
    INDEX `idx_category` (`category`),
    INDEX `idx_subcategory` (`subcategory`),
    INDEX `idx_source_type` (`source_type`),
    INDEX `idx_is_combat_ability` (`is_combat_ability`),
    INDEX `idx_max_rank_spell_id` (`max_rank_spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Spell categorization for Mortal classless system';

-- Example entries (core universal abilities)
-- These are examples - full classification would be done via script
INSERT INTO `mortal_spell_tags` (`spell_id`, `category`, `subcategory`, `pvp_flags`, `source_type`, `is_combat_ability`, `notes`) VALUES
-- Core Universal Kit (always available)
(1, 'CORE', 'UTILITY', NULL, 'BASELINE', 0, 'Example: Basic Attack'),
(2, 'CORE', 'DEFENSIVE', NULL, 'BASELINE', 1, 'Example: Brace - 0.75s 50% DR, 5s CD'),
(3, 'CORE', 'UTILITY', NULL, 'BASELINE', 0, 'Example: Flask Use'),
(4, 'CORE', 'UTILITY', NULL, 'BASELINE', 0, 'Example: Basic Bandage'),
(5, 'CORE', 'UTILITY', NULL, 'BASELINE', 0, 'Example: Mount Cast')
ON DUPLICATE KEY UPDATE
    `category` = VALUES(`category`),
    `subcategory` = VALUES(`subcategory`),
    `pvp_flags` = VALUES(`pvp_flags`),
    `source_type` = VALUES(`source_type`),
    `is_combat_ability` = VALUES(`is_combat_ability`),
    `notes` = VALUES(`notes`);

-- Spell Rank Mapping Table: Maps lower ranks to canonical spell IDs
CREATE TABLE IF NOT EXISTS `mortal_spell_rank_map` (
    `spell_id` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Lower rank spell ID',
    `canonical_spell_id` INT UNSIGNED NOT NULL COMMENT 'Canonical (max rank) spell ID',
    `rank_number` TINYINT UNSIGNED NOT NULL COMMENT 'Rank number (1 = lowest, higher = better)',
    INDEX `idx_canonical` (`canonical_spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Maps spell ranks to canonical spell IDs for rank pruning';

-- Player Learned Spells: Tracks which learned spells a player knows
CREATE TABLE IF NOT EXISTS `mortal_player_learned_spells` (
    `player_guid` INT UNSIGNED NOT NULL,
    `spell_id` INT UNSIGNED NOT NULL,
    `learned_from` VARCHAR(64) DEFAULT NULL COMMENT 'BOOK, TRIAL, FACTION, DROP, etc.',
    `learned_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
    `source_item_entry` INT UNSIGNED DEFAULT NULL COMMENT 'Item entry if learned from book/tome',
    PRIMARY KEY (`player_guid`, `spell_id`),
    INDEX `idx_spell_id` (`spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player learned spells (from books, tomes, etc.)';

-- Player Active Ability Loadout: Tracks active combat abilities (8-12 cap)
CREATE TABLE IF NOT EXISTS `mortal_player_active_abilities` (
    `player_guid` INT UNSIGNED NOT NULL,
    `spell_id` INT UNSIGNED NOT NULL,
    `slot_index` TINYINT UNSIGNED NOT NULL COMMENT 'Action bar slot (0-11 for 12 max)',
    `source_type` VARCHAR(32) NOT NULL COMMENT 'LEARNED, RUNE, MASTERY, CORE',
    `source_item_guid` BIGINT UNSIGNED DEFAULT NULL COMMENT 'Item GUID if from rune',
    `preset_id` INT UNSIGNED DEFAULT NULL COMMENT 'Preset ID if part of a build preset',
    PRIMARY KEY (`player_guid`, `spell_id`),
    UNIQUE KEY `idx_player_slot` (`player_guid`, `slot_index`),
    INDEX `idx_preset` (`preset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player active combat ability loadout (8-12 abilities max)';

