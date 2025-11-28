-- ==================================================
-- Project Mortal Warcraft
-- Feature: NPC & Encounter Rebalance System
-- Description: Data-driven NPC stat scaling for Mortal power band
-- Based on: docs/specs/32-npc-and-encounter-rebalance.md
-- ==================================================

-- Creature Tier Definitions
-- Defines scaling factors for different NPC tiers
CREATE TABLE IF NOT EXISTS `mortal_creature_tiers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(32) NOT NULL COMMENT 'TRASH_T1, BOSS_T3, WORLD_3, RAID_ICC_N, etc.',
    `description` VARCHAR(255) NOT NULL,
    
    -- Stat scaling factors (relative to original creature_template)
    `hp_scale` FLOAT NOT NULL DEFAULT 1.0,
    `damage_scale` FLOAT NOT NULL DEFAULT 1.0,
    `armor_scale` FLOAT NOT NULL DEFAULT 1.0,
    `resist_scale` FLOAT NOT NULL DEFAULT 1.0,
    
    -- Optional caps / tuning hints
    `max_hp_override` INT UNSIGNED NULL COMMENT 'Clamp HP to this after scaling',
    `max_damage_override` INT UNSIGNED NULL COMMENT 'Clamp average melee hit to this',
    `loot_tier_hint` VARCHAR(16) NULL COMMENT 'M-T1, M-T2, M-T3, M-T4, M-T5',
    
    UNIQUE KEY `uk_code` (`code`),
    INDEX `idx_loot_tier` (`loot_tier_hint`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='NPC tier scaling definitions';

-- Creature Tier Mapping
-- Maps creature entries to Mortal tiers
CREATE TABLE IF NOT EXISTS `mortal_creature_tier_map` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'creature_template.entry',
    `mortal_tier_id` INT UNSIGNED NOT NULL COMMENT 'mortal_creature_tiers.id',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_creature` (`creature_entry`),
    INDEX `idx_tier` (`mortal_tier_id`),
    FOREIGN KEY (`mortal_tier_id`) REFERENCES `mortal_creature_tiers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Creature to tier mapping';

-- Spell Scaling
-- Scales spell damage for NPC abilities
CREATE TABLE IF NOT EXISTS `mortal_spell_scaling` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `spell_id` INT UNSIGNED NOT NULL COMMENT 'spell_template.entry',
    `damage_scale` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Multiply original damage by this',
    `max_pct_hp` FLOAT NULL COMMENT 'Cap at % of target max HP (0.0-1.0)',
    `notes` VARCHAR(255) NULL,
    UNIQUE KEY `uk_spell` (`spell_id`),
    INDEX `idx_damage_scale` (`damage_scale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='NPC spell damage scaling';

-- Seed Data: Default Tier Definitions
INSERT INTO `mortal_creature_tiers` (`code`, `description`, `hp_scale`, `damage_scale`, `armor_scale`, `resist_scale`, `loot_tier_hint`) VALUES
('TRASH_T1', 'Early dungeon trash', 0.25, 0.25, 0.25, 0.25, 'M-T1'),
('BOSS_T1', 'Early dungeon bosses', 0.3, 0.3, 0.3, 0.3, 'M-T1'),
('TRASH_T2', 'Mid dungeon trash', 0.3, 0.3, 0.3, 0.3, 'M-T2'),
('BOSS_T2', 'Mid dungeon bosses', 0.35, 0.35, 0.35, 0.35, 'M-T2'),
('TRASH_T3', 'Late heroic trash', 0.35, 0.35, 0.35, 0.35, 'M-T3'),
('BOSS_T3', 'Late heroic bosses', 0.4, 0.4, 0.4, 0.4, 'M-T3'),
('WORLD_1', 'Low-tier world bosses', 0.35, 0.4, 0.35, 0.35, 'M-T3'),
('WORLD_2', 'Mid-tier world bosses', 0.4, 0.45, 0.4, 0.4, 'M-T4'),
('WORLD_3', 'High-tier world bosses', 0.4, 0.45, 0.4, 0.4, 'M-T4'),
('RAID_ICC_N', 'ICC Normal raid bosses', 0.4, 0.4, 0.4, 0.4, 'M-T4'),
('RAID_ICC_H', 'ICC Heroic raid bosses', 0.5, 0.55, 0.5, 0.5, 'M-T5')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

