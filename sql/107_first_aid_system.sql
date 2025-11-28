-- ==================================================
-- Project Mortal Warcraft
-- Feature: First Aid System
-- Description: First Aid skill lines and bandage/kit items
-- Based on: docs/specs/50-lifeskills-fishing-and-first-aid.md
-- ==================================================

-- First Aid Skill Lines (stored in character_mortal_skills with IDs)
-- Skill IDs (to be defined in skill system):
-- 4001: Field Medicine (general bandaging, out-of-combat HoTs)
-- 4002: Trauma Care (combat dressings, fracture/slow debuff management)
-- 4003: Toxicology (antidotes, disease/poison cures)

-- First Aid Items Table
-- Tracks bandage/kit items and their properties
CREATE TABLE IF NOT EXISTS `mortal_first_aid_items` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry',
    `item_name` VARCHAR(128) NOT NULL,
    `skill_line` VARCHAR(32) NOT NULL COMMENT 'FIELD_MEDICINE, TRAUMA_CARE, TOXICOLOGY',
    `use_type` VARCHAR(32) NOT NULL COMMENT 'BANDAGE, COMBAT_DRESSING, SPLINT, ANTIDOTE',
    `hp_restore_pct` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Percentage of max HP restored (0.0-1.0)',
    `hp_restore_flat` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Flat HP restore amount',
    `channel_time_ms` INT UNSIGNED NOT NULL DEFAULT 8000 COMMENT 'Cast/channel time in milliseconds',
    `cooldown_ms` INT UNSIGNED NOT NULL DEFAULT 60000 COMMENT 'Cooldown in milliseconds',
    `removes_debuff_type` VARCHAR(32) NULL COMMENT 'BLEED, POISON, DISEASE, FRACTURE',
    `requires_combat` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if usable in combat',
    `breaks_on_damage` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1 if channel breaks on damage',
    `skill_required` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum skill level required',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_item` (`item_entry`),
    INDEX `idx_skill_line` (`skill_line`),
    INDEX `idx_use_type` (`use_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='First Aid item definitions';

-- Seed Data: Basic Bandages
-- Note: These item entries need to be created in item_template first
-- For now, using placeholder entries that should be created

-- Simple Bandage (Field Medicine - Out of Combat)
-- INSERT INTO `mortal_first_aid_items` (`item_entry`, `item_name`, `skill_line`, `use_type`, `hp_restore_pct`, `channel_time_ms`, `cooldown_ms`, `requires_combat`, `breaks_on_damage`, `skill_required`, `notes`) VALUES
-- (900700, 'Simple Bandage', 'FIELD_MEDICINE', 'BANDAGE', 0.15, 10000, 0, 0, 1, 0, 'Restores 15% HP over 10 seconds, out of combat only');

-- Combat Dressing (Trauma Care - In Combat)
-- INSERT INTO `mortal_first_aid_items` (`item_entry`, `item_name`, `skill_line`, `use_type`, `hp_restore_flat`, `removes_debuff_type`, `channel_time_ms`, `cooldown_ms`, `requires_combat`, `breaks_on_damage`, `skill_required`, `notes`) VALUES
-- (900701, 'Combat Dressing', 'TRAUMA_CARE', 'COMBAT_DRESSING', 200, 'BLEED', 3000, 30000, 1, 0, 50, 'Removes bleed effects, small instant heal, usable in combat');

-- Splint (Trauma Care - Movement Debuff)
-- INSERT INTO `mortal_first_aid_items` (`item_entry`, `item_name`, `skill_line`, `use_type`, `removes_debuff_type`, `channel_time_ms`, `cooldown_ms`, `requires_combat`, `breaks_on_damage`, `skill_required`, `notes`) VALUES
-- (900702, 'Splint', 'TRAUMA_CARE', 'SPLINT', 'FRACTURE', 5000, 60000, 0, 1, 100, 'Removes or downgrades movement debuffs');

-- Antidote (Toxicology - Poison/Disease)
-- INSERT INTO `mortal_first_aid_items` (`item_entry`, `item_name`, `skill_line`, `use_type`, `removes_debuff_type`, `channel_time_ms`, `cooldown_ms`, `requires_combat`, `breaks_on_damage`, `skill_required`, `notes`) VALUES
-- (900703, 'Antidote', 'TOXICOLOGY', 'ANTIDOTE', 'POISON', 2000, 45000, 1, 0, 75, 'Removes poison and disease effects');

-- Summary
SELECT 
    'First Aid System Created' as summary,
    COUNT(*) as total_items,
    COUNT(DISTINCT skill_line) as skill_lines,
    COUNT(DISTINCT use_type) as use_types
FROM mortal_first_aid_items;

