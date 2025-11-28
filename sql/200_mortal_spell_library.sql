-- ================================================
-- Mortal Spell Library & Rune System
-- Spec: 75-mortal-gear-and-runes-spec.md
-- ================================================

-- Spell tags/metadata table
CREATE TABLE IF NOT EXISTS `mortal_spell_tags` (
  `spell_id` INT UNSIGNED NOT NULL PRIMARY KEY,
  `category` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=CORE, 1=LEARNED, 2=RUNE, 3=MASTERY, 4=AUGMENT, 5=REMOVED',
  `subcategory` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=MARTIAL, 1=ARCANE, 2=HEALING, 3=CC, 4=MOBILITY, 5=UTILITY, 6=DEFENSIVE, 7=PVE_ONLY',
  `pvp_flags` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bitmask: 1=REDUCED, 2=DISABLED, 4=CC_CAP, 8=DURATION_CAP',
  `source_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=BASELINE, 1=BOOK, 2=TRIAL, 3=FACTION, 4=DROP, 5=CRAFT, 6=RUNE_ITEM',
  `required_skill_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Mortal skill ID requirement',
  `required_skill_level` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum skill level',
  `is_combat_ability` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Counts as combat ability',
  `max_rank_spell_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Highest rank of this spell',
  `pvp_duration_cap` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Max duration in PvP (seconds)',
  `pvp_coefficient_mod` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Damage/heal modifier in PvP',
  `notes` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Spell metadata for Mortal spell library';

-- Player learned spells (permanent knowledge)
CREATE TABLE IF NOT EXISTS `character_mortal_spells` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `spell_id` INT UNSIGNED NOT NULL COMMENT 'Spell ID',
  `source_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'How spell was learned',
  `source_item_entry` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Item that taught the spell',
  `learned_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp when learned',
  PRIMARY KEY (`guid`, `spell_id`),
  INDEX `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Permanently learned spells per character';

-- Player active ability loadout (limited slots, 8-12 abilities)
CREATE TABLE IF NOT EXISTS `character_mortal_loadout` (
  `guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `slot_index` TINYINT UNSIGNED NOT NULL COMMENT 'Loadout slot (0-11)',
  `spell_id` INT UNSIGNED NOT NULL COMMENT 'Spell ID in this slot',
  `source_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Source of ability',
  `source_item_guid` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Item GUID if from rune',
  PRIMARY KEY (`guid`, `slot_index`),
  INDEX `idx_guid_spell` (`guid`, `spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Active ability loadout slots';

-- Rune definitions
CREATE TABLE IF NOT EXISTS `mortal_rune_def` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `rune_key` VARCHAR(64) UNIQUE NOT NULL COMMENT 'Unique identifier like RUNE_WHIRLWIND',
  `item_entry` INT UNSIGNED NOT NULL COMMENT 'Rune item entry',
  `category` TINYINT UNSIGNED NOT NULL COMMENT '1=Combat, 2=Control, 3=Guard, 4=Support, 5=Mobility, 6=Utility',
  `spell_id` INT UNSIGNED NOT NULL COMMENT 'Spell granted when equipped',
  `allowed_slot_mask` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bitmask: 1=Weapon, 2=Armor, 4=Accessory',
  `max_rank` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Max rank for tuning',
  `is_consumable` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Consumed on socket',
  `min_skill_id` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Required skill',
  `min_skill_level` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Required skill level',
  INDEX `idx_item_entry` (`item_entry`),
  INDEX `idx_spell_id` (`spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Rune definitions (Ashes of War style)';

-- Rune slots per item
CREATE TABLE IF NOT EXISTS `mortal_rune_slots` (
  `item_entry` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Item entry',
  `weapon_slots` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of rune slots for weapons',
  `armor_slots` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of rune slots for armor',
  `accessory_slots` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Number of rune slots for accessories'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Rune slot configuration per item';

-- Socketed runes on item instances
CREATE TABLE IF NOT EXISTS `mortal_item_runes` (
  `item_guid` BIGINT UNSIGNED NOT NULL COMMENT 'Item instance GUID',
  `rune_id` INT UNSIGNED NOT NULL COMMENT 'Rune definition ID',
  `slot_index` TINYINT UNSIGNED NOT NULL COMMENT 'Slot index (0-based)',
  PRIMARY KEY (`item_guid`, `slot_index`),
  INDEX `idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Runes socketed into item instances';

-- Insert some example spell tags for core abilities
-- This is a starting point - should be populated with real spell IDs from WotLK
INSERT INTO `mortal_spell_tags` (`spell_id`, `category`, `subcategory`, `source_type`, `is_combat_ability`, `notes`) VALUES
-- Core combat abilities (always available)
(6603, 0, 0, 0, 1, 'Auto Attack - CORE'),  -- Auto Attack
(100, 0, 0, 0, 1, 'Charge - CORE'),  -- Charge

-- Example learned spells
(845, 1, 0, 1, 1, 'Cleave - Learned from book'),  -- Cleave

-- Example rune spells (would need actual spell IDs)
-- (50001, 2, 0, 6, 1, 'Whirlwind Rune'),
-- (50002, 2, 3, 6, 1, 'Hamstring Rune'),
-- (50003, 2, 4, 6, 1, 'Heroic Leap Rune'),

-- PvP-restricted spells
(1784, 1, 4, 1, 1, 'Stealth - PvP CC cap')  -- Stealth
ON DUPLICATE KEY UPDATE spell_id=spell_id;

-- Example rune definitions (starter set)
-- These would need to be populated with actual item entries and spell IDs
INSERT INTO `mortal_rune_def` (`rune_key`, `item_entry`, `category`, `spell_id`, `allowed_slot_mask`, `max_rank`) VALUES
('RUNE_PLACEHOLDER_1', 999001, 1, 50001, 1, 1),  -- Placeholder for future rune entries
('RUNE_PLACEHOLDER_2', 999002, 4, 50002, 3, 1)
ON DUPLICATE KEY UPDATE rune_key=rune_key;

