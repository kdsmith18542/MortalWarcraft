-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: The Midnight Horde - Zombie NPC Template
-- Description: Creates the Risen Peasant zombie NPC for the midnight invasion event
-- ==================================================

-- WARNING: This script creates a custom NPC template.
-- Make sure you have a database backup before running this!

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. CREATE ZOMBIE NPC TEMPLATE
-- ------------------------------------------------------------------

-- Risen Peasant: Low HP, High Damage, Aggressive
-- Entry: 50010
-- Stats: Level 15-20, Undead, Aggressive, Low HP (0.5x), High Damage (1.5x)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `IconName`, `gossip_menu_id`,
    `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, 
    `speed_walk`, `speed_run`, `rank`, `unit_class`, `type`, 
    `type_flags`, `flags_extra`, `scale`, `BaseAttackTime`, `RangeAttackTime`,
    `unit_flags`, `unit_flags2`, `HealthModifier`, `ManaModifier`, `ArmorModifier`,
    `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    50010, 'Risen Peasant', 'The Midnight Horde', NULL, 0,
    15, 20, 0, 14, 0,
    1.0, 1.14286, 0, 1, 6,  -- Type 6 = Undead
    0, 0, 1.0, 2000, 2000,
    0, 0, 0.5, 1.0, 1.0,    -- Low HP (0.5x), Normal Mana/Armor
    1.5, '', ''              -- High Damage (1.5x)
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- ------------------------------------------------------------------
-- 2. CREATE MODEL INFO (Optional - uses existing skeleton model)
-- ------------------------------------------------------------------

-- Using model 169 (Skeleton) - already exists in client
-- If you want a custom model, add it here

-- ------------------------------------------------------------------
-- 3. CREATE LOOT TABLE (Optional - zombies drop salvage/scraps)
-- ------------------------------------------------------------------

-- Add basic loot (humanoid scraps)
INSERT INTO `creature_loot_template` (`Entry`, `Item`, `Reference`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`)
SELECT 50010, 0, 10001, 100, 0, 1, 0, 1, 1, 'Tier 1 Humanoid Scrap'
WHERE NOT EXISTS (
    SELECT 1 FROM `creature_loot_template` WHERE `Entry` = 50010 AND `Reference` = 10001
);

COMMIT;

-- Report results
SELECT 'Midnight Horde zombie NPC template created successfully.' AS result;
SELECT CONCAT('Entry: ', 50010, ' - Risen Peasant') AS npc_info;

