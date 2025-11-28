-- ==================================================
-- Project Mortal Warcraft
-- Feature: Add Stat Bonus Columns to mortal_enhancements
-- Description: Adds stat bonus columns for augment stat calculation
-- Based on: docs/specs/53-rune-augments-and-gear-build-system.md
-- ==================================================

-- Add stat bonus columns to mortal_enhancements table
ALTER TABLE `mortal_enhancements`
    ADD COLUMN IF NOT EXISTS `stat_bonus_str` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Strength bonus from this enhancement',
    ADD COLUMN IF NOT EXISTS `stat_bonus_agi` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Agility bonus from this enhancement',
    ADD COLUMN IF NOT EXISTS `stat_bonus_sta` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Stamina bonus from this enhancement',
    ADD COLUMN IF NOT EXISTS `stat_bonus_int` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Intellect bonus from this enhancement',
    ADD COLUMN IF NOT EXISTS `stat_bonus_spi` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Spirit bonus from this enhancement`;

-- Update example augments with stat bonuses (tunable values)
-- These are example values - actual values should be tuned based on balance
UPDATE `mortal_enhancements` SET
    `stat_bonus_str` = CASE
        WHEN `code` = 'AUG_EXECUTIONER_EDGE' THEN 2.0
        WHEN `code` = 'AUG_MEASURED_STRIKES' THEN 1.0
        ELSE 0.0
    END,
    `stat_bonus_agi` = CASE
        WHEN `code` = 'AUG_MEASURED_STRIKES' THEN 2.0
        WHEN `code` = 'AUG_TRAILBLAZER' THEN 1.0
        ELSE 0.0
    END,
    `stat_bonus_sta` = CASE
        WHEN `code` = 'AUG_STONE_BRACE' THEN 2.0
        WHEN `code` = 'AUG_IRON_WILL' THEN 1.5
        WHEN `code` = 'AUG_SHRINEBOUND' THEN 1.0
        ELSE 0.0
    END,
    `stat_bonus_int` = CASE
        WHEN `code` = 'AUG_SHRINEBOUND' THEN 1.0
        ELSE 0.0
    END,
    `stat_bonus_spi` = CASE
        WHEN `code` = 'AUG_SHRINEBOUND' THEN 1.5
        ELSE 0.0
    END
WHERE `type` = 'AUGMENT';

