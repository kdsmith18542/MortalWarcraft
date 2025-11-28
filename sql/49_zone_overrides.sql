-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Zone Overrides (Civic & Travel)
-- Description: Modifies NPCs to enable Open World Risk.
-- ==================================================

-- 1. FLIGHT MASTER REMOVAL (The "No Fly" Zone)
-- Remove the "Gossip" flag (1) and "Flight Master" flag (16) from all Flight Masters
-- This leaves the NPC there (for flavor) but they won't talk to you.

-- Check if creature_template table exists
SET @table_exists = (SELECT COUNT(*) FROM information_schema.tables 
    WHERE table_schema = 'azerothcore_world' AND table_name = 'creature_template');

SET @sql = IF(@table_exists > 0,
    'UPDATE `creature_template` 
     SET `npcflag` = `npcflag` & ~(1 | 16) 
     WHERE `subname` LIKE ''%Flight Master%'' OR `subname` LIKE ''%Wind Rider Master%'';',
    'SELECT 1;');

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. GUARD NERF (Town Capture)
-- Lower the stats of Guards in "Contested" zones (Barrens, Redridge, STV).
-- We identify guards by name pattern or ID lists.
-- Example: Orgrimmar Grunt / Stormwind Guard (Level 55 Elite)

-- Update Guards in Barrens (Zone 17) to Level 45 Elite (Killable)
-- Check if creature table exists
SET @creature_exists = (SELECT COUNT(*) FROM information_schema.tables 
    WHERE table_schema = 'azerothcore_world' AND table_name = 'creature');

SET @sql2 = IF(@creature_exists > 0 AND @table_exists > 0,
    'UPDATE `creature_template` ct
     JOIN `creature` c ON c.id = ct.entry
     SET ct.minlevel = 45, ct.maxlevel = 45, ct.rank = 1
     WHERE c.map = 1 AND c.zoneId = 17 AND ct.name LIKE ''%Guard%'';',
    'SELECT 1;');

PREPARE stmt2 FROM @sql2;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

-- Also nerf guards in other contested zones (Redridge, STV)
SET @sql3 = IF(@creature_exists > 0 AND @table_exists > 0,
    'UPDATE `creature_template` ct
     JOIN `creature` c ON c.id = ct.entry
     SET ct.minlevel = 45, ct.maxlevel = 45, ct.rank = 1
     WHERE (c.map = 0 AND c.zoneId = 44) OR (c.map = 0 AND c.zoneId = 33)
     AND ct.name LIKE ''%Guard%'';',
    'SELECT 1;');

PREPARE stmt3 FROM @sql3;
EXECUTE stmt3;
DEALLOCATE PREPARE stmt3;

-- 3. STRONGHOLD GUARDS (Custom Faction)
-- Create a custom faction for Guild Guards so they are hostile to non-members.
-- (Requires creating FactionTemplate ID in DBC first, but here is the SQL placeholder)
-- Note: This is a placeholder - actual faction creation requires DBC editing
-- UPDATE `creature_template` SET `faction` = 9999 WHERE `entry` IN (50001, 50002); -- Custom Guard IDs

-- 4. DELETE TELEPORTERS
-- Remove the "Portal" GameObjects in Cities to force travel.
-- Check if gameobject table exists
SET @go_exists = (SELECT COUNT(*) FROM information_schema.tables 
    WHERE table_schema = 'azerothcore_world' AND table_name = 'gameobject');

SET @sql4 = IF(@go_exists > 0,
    'DELETE FROM `gameobject` WHERE `id` IN (176094, 195141, 191009);',
    'SELECT 1;');

PREPARE stmt4 FROM @sql4;
EXECUTE stmt4;
DEALLOCATE PREPARE stmt4;

-- Summary
SELECT 'Zone Overrides Applied' AS Status,
       'Flight Masters disabled, Guards nerfed, Teleporters removed' AS Details;

