-- ==================================================
-- Project Mortal Warcraft
-- Migration: Add skill_req and lore_req columns to mortal_fishing_loot
-- Description: Updates fishing loot table to match C++ code expectations
-- Based on: docs/specs/50-lifeskills-fishing-and-first-aid.md
-- ==================================================

-- Add missing columns if they don't exist
ALTER TABLE `mortal_fishing_loot`
ADD COLUMN IF NOT EXISTS `skill_req` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum fishing skill required' AFTER `base_chance`,
ADD COLUMN IF NOT EXISTS `lore_req` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum material lore skill required' AFTER `skill_req`,
ADD COLUMN IF NOT EXISTS `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Additional flags' AFTER `lore_req`;

-- Add index for skill requirements
ALTER TABLE `mortal_fishing_loot`
ADD INDEX IF NOT EXISTS `idx_skill_req` (`skill_req`, `lore_req`);

-- Update existing entries with default skill requirements based on risk tier
UPDATE `mortal_fishing_loot` SET `skill_req` = 0, `lore_req` = 0 WHERE `risk_tier` = 1 AND `skill_req` = 0;
UPDATE `mortal_fishing_loot` SET `skill_req` = 25, `lore_req` = 5 WHERE `risk_tier` = 2 AND `skill_req` = 0;
UPDATE `mortal_fishing_loot` SET `skill_req` = 50, `lore_req` = 10 WHERE `risk_tier` = 3 AND `skill_req` = 0;

