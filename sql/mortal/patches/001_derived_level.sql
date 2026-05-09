-- ============================================================================
-- Mortal Warcraft Overhaul - SQL Migration: 001 Derived Level System
-- Part of the mod-mortal AzerothCore module
-- ============================================================================

ALTER TABLE `character_mortal_skills` ADD INDEX `idx_guid_skill` (`guid`, `skill_id`);
ALTER TABLE `character_notoriety` ADD INDEX `idx_notoriety` (`notoriety`);
ALTER TABLE `mortal_bounties` ADD INDEX `idx_target_unclaimed` (`target_guid`, `is_claimed`);
