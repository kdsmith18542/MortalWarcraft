-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Mercenary Broker (AI Assistance System)
-- Description: Adds Mercenary Broker NPCs and Mercenary templates (Tank/Healer/Archer).
-- Based on: docs/specs/29-companion-bond-and-mercenary-system.md, 31-mortal-core-registry.md
-- ==================================================

-- WARNING: This script adds custom NPCs. Run in the world database.
-- NOTE: Mercenary creatures use entry range 600000-609999 per spec 31.
-- This script creates both creature templates AND mortal_merc_templates entries.

START TRANSACTION;

SET @has_creature_table := (
    SELECT COUNT(*)
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'creature'
);

-- ------------------------------------------------------------------
-- 1. CREATURE TEMPLATES
-- ------------------------------------------------------------------

-- Mercenary Broker (Neutral NPC stationed in inns/taverns)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `IconName`, `gossip_menu_id`,
    `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`,
    `rank`, `unit_class`, `type`, `type_flags`, `flags_extra`,
    `scale`, `BaseAttackTime`, `RangeAttackTime`, `unit_flags`, `unit_flags2`,
    `AIName`, `ScriptName`
) VALUES (
    91000, 'Mercenary Broker', 'Hire Contracted Muscle', 'Speak',
    0, 80, 80, 35, 1, 1.0, 1.14286,
    0, 1, 7, 0, 0,
    1.0, 2000, 2000, 0, 0,
    '', 'npc_mercenary_broker'
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Mercenary Tank (Guardian)
-- NOTE: Using 600000-609999 range per spec 31-mortal-core-registry.md
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`,
    `npcflag`, `speed_walk`, `speed_run`, `rank`, `unit_class`, `type`,
    `type_flags`, `flags_extra`, `BaseAttackTime`, `RangeAttackTime`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `AIName`, `ScriptName`
) VALUES (
    600001, 'Mercenary Defender', 'Shield Contract', 70, 70, 35,
    0, 1.1, 1.2, 1, 1, 7,
    0, 0, 1800, 2000,
    20.0, 2.0, 2.5, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Mercenary Healer
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`,
    `npcflag`, `speed_walk`, `speed_run`, `rank`, `unit_class`, `type`,
    `type_flags`, `flags_extra`, `BaseAttackTime`, `RangeAttackTime`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `AIName`, `ScriptName`
) VALUES (
    600002, 'Mercenary Cleric', 'Restoration Contract', 70, 70, 35,
    0, 1.1, 1.2, 1, 2, 7,
    0, 0, 1800, 2000,
    12.0, 6.0, 1.5, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Mercenary Archer
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`,
    `npcflag`, `speed_walk`, `speed_run`, `rank`, `unit_class`, `type`,
    `type_flags`, `flags_extra`, `BaseAttackTime`, `RangeAttackTime`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `AIName`, `ScriptName`
) VALUES (
    600003, 'Mercenary Ranger', 'Volley Contract', 70, 70, 35,
    0, 1.2, 1.4, 1, 3, 7,
    0, 0, 1600, 1600,
    14.0, 2.0, 1.8, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- ------------------------------------------------------------------
-- 2. CREATURE MODELS
-- ------------------------------------------------------------------

INSERT IGNORE INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(91000, 0, 1298, 1.0, 1, 12340),
(600001, 0, 2686, 1.1, 1, 12340),
(600002, 0, 2676, 1.0, 1, 12340),
(600003, 0, 2687, 1.0, 1, 12340);

-- ------------------------------------------------------------------
-- 3. SPAWNS (Stormwind, Orgrimmar, Booty Bay)
-- ------------------------------------------------------------------

SET @sql_delete = IF(@has_creature_table > 0,
    'DELETE FROM `creature` WHERE `id` = 91000;',
    'SELECT 0;');
PREPARE stmt_delete FROM @sql_delete;
EXECUTE stmt_delete;
DEALLOCATE PREPARE stmt_delete;

SET @sql_spawn = IF(@has_creature_table > 0,
    'INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `wander_distance`, `MovementType`, `npcflag`, `unit_flags`, `unit_flags2`, `dynamicflags`, `VerifiedBuild`) VALUES
    (990000, 91000, 0, 1519, 5151, ''0'', 0, 0, 0, -1, 0, 0, -8861.0, 674.5, 97.9, 1.57, 300, 0, 0, 1, 0, 0, 0, 12340),
    (990001, 91000, 1, 1637, 1637, ''0'', 0, 0, 0, -1, 0, 0, 1596.5, -4379.2, 10.1, 5.0, 300, 0, 0, 1, 0, 0, 0, 12340),
    (990002, 91000, 0, 35, 35, ''0'', 0, 0, 0, -1, 0, 0, -14464.4, 460.2, 16.3, 2.9, 300, 0, 0, 1, 0, 0, 0, 12340);',
    'SELECT 0;');
PREPARE stmt_spawn FROM @sql_spawn;
EXECUTE stmt_spawn;
    DEALLOCATE PREPARE stmt_spawn;

-- ------------------------------------------------------------------
-- 4. MERCENARY TEMPLATES (mortal_merc_templates)
-- NOTE: Requires mortal_merc_templates table from 65_mortal_core_registry_tables.sql
-- ------------------------------------------------------------------

-- Check if mortal_merc_templates table exists
SET @has_merc_templates := (
    SELECT COUNT(*)
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'mortal_merc_templates'
);

SET @sql_merc_templates = IF(@has_merc_templates > 0,
    'INSERT INTO `mortal_merc_templates` (`name`, `role`, `base_gear_tier`, `creature_entry`, `base_wage`, `max_bond_bonus`, `notes`) VALUES
    (''Mercenary Defender'', ''tank'', ''M-T2'', 600001, 200, 10, ''Tank mercenary for dungeon support''),
    (''Mercenary Cleric'', ''healer'', ''M-T2'', 600002, 250, 10, ''Healer mercenary for dungeon support''),
    (''Mercenary Ranger'', ''ranged_dps'', ''M-T2'', 600003, 200, 10, ''Ranged DPS mercenary for dungeon support'')
    ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);',
    'SELECT ''mortal_merc_templates table not found. Run 65_mortal_core_registry_tables.sql first.'' AS result;');
PREPARE stmt_merc_templates FROM @sql_merc_templates;
EXECUTE stmt_merc_templates;
DEALLOCATE PREPARE stmt_merc_templates;

COMMIT;

SELECT CASE
    WHEN @has_creature_table > 0 THEN 'Mercenary Broker NPCs installed (templates + spawns).'
    ELSE 'Mercenary Broker templates installed. Spawn table missing; add spawns once `creature` exists.'
END AS result;

SELECT 'NOTE: Mercenary creatures use entry range 600000-609999 (600001-600003).' AS result;
SELECT 'NOTE: If you have existing Lua scripts referencing 91001-91003, update them to use 600001-600003.' AS result;

