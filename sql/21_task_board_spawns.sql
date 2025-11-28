-- ==================================================
-- Project Mortal Warcraft Overhaul
-- Feature: Task Board Spawns
-- Description: Spawn Wanted Poster gameobjects in towns for Task Board system
-- ==================================================

-- Note: GameObject Entry 179826 = Wanted Poster (Generic Human)
-- This object exists in 3.3.5a client data, so no custom model needed

USE `azerothcore_world`;

-- Check if gameobject table exists, if not, provide instructions
-- The gameobject table should exist if base AzerothCore database was imported
-- If you get an error, run: mysql -u root -p azerothcore_world < azerothcore/data/sql/base/db_world/gameobject.sql

-- Darkshire (Duskwood) - Zone 10
-- Spawn near the inn or town center
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`)
SELECT 
    COALESCE(MAX(`guid`), 0) + 1,  -- Auto-increment guid
    179826,           -- Wanted Poster
    0,                -- Eastern Kingdoms
    10,               -- Duskwood
    0,
    1,                -- Spawn mask
    1,                -- Phase mask
    -10517.0,         -- X (near Darkshire inn)
    -1158.0,          -- Y
    39.0,             -- Z
    2.0,              -- Orientation (facing town)
    0, 0, 0, 1,       -- Rotation
    0,                -- Spawn time (permanent)
    100,              -- Anim progress
    1,                -- State (active)
    '',               -- Script name (handled by Lua)
    12340             -- Verified build
FROM `gameobject`
WHERE NOT EXISTS (
    SELECT 1 FROM `gameobject` 
    WHERE `id` = 179826 
    AND `zoneId` = 10 
    AND `position_x` BETWEEN -10520 AND -10514
);

-- Lakeshire (Redridge Mountains) - Zone 44
-- Spawn near the inn
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`)
SELECT 
    COALESCE(MAX(`guid`), 0) + 1,
    179826,
    0,
    44,               -- Redridge Mountains
    0,
    1,
    1,
    -9450.0,          -- X (near Lakeshire inn)
    -2239.0,          -- Y
    70.0,             -- Z
    1.5,              -- Orientation
    0, 0, 0, 1,
    0,
    100,
    1,
    '',
    12340
FROM `gameobject`
WHERE NOT EXISTS (
    SELECT 1 FROM `gameobject` 
    WHERE `id` = 179826 
    AND `zoneId` = 44 
    AND `position_x` BETWEEN -9453 AND -9447
);

-- The Crossroads (The Barrens) - Zone 17
-- Spawn near the inn or quest giver area
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`)
SELECT 
    COALESCE(MAX(`guid`), 0) + 1,
    195248,           -- Wanted Poster (Generic Orc) for Horde zones
    1,                -- Kalimdor
    17,               -- The Barrens
    0,
    1,
    1,
    -456.0,           -- X (near Crossroads inn)
    2650.0,           -- Y
    91.0,             -- Z
    0.0,              -- Orientation
    0, 0, 0, 1,
    0,
    100,
    1,
    '',
    12340
FROM `gameobject`
WHERE NOT EXISTS (
    SELECT 1 FROM `gameobject` 
    WHERE `id` = 195248 
    AND `zoneId` = 17 
    AND `position_x` BETWEEN -459 AND -453
);

-- Tarren Mill (Hillsbrad Foothills) - Zone 267
-- Spawn near the inn
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`)
SELECT 
    COALESCE(MAX(`guid`), 0) + 1,
    195248,           -- Wanted Poster (Generic Orc)
    0,
    267,              -- Hillsbrad Foothills
    0,
    1,
    1,
    -1.0,             -- X (near Tarren Mill inn)
    -913.0,           -- Y
    57.0,             -- Z
    3.0,              -- Orientation
    0, 0, 0, 1,
    0,
    100,
    1,
    '',
    12340
FROM `gameobject`
WHERE NOT EXISTS (
    SELECT 1 FROM `gameobject` 
    WHERE `id` = 195248 
    AND `zoneId` = 267 
    AND `position_x` BETWEEN -4 AND 2
);

-- Booty Bay (Stranglethorn Vale) - Zone 3483
-- Spawn near the inn or quest area
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`)
SELECT 
    COALESCE(MAX(`guid`), 0) + 1,
    179826,           -- Wanted Poster (works for neutral zones too)
    0,
    3483,             -- Stranglethorn Vale
    0,
    1,
    1,
    -14457.0,        -- X (near Booty Bay)
    470.0,           -- Y
    15.0,            -- Z
    1.0,             -- Orientation
    0, 0, 0, 1,
    0,
    100,
    1,
    '',
    12340
FROM `gameobject`
WHERE NOT EXISTS (
    SELECT 1 FROM `gameobject` 
    WHERE `id` = 179826 
    AND `zoneId` = 3483 
    AND `position_x` BETWEEN -14460 AND -14454
);

-- Note: Goldshire and Stormwind already have these objects
-- This script only adds them to towns that don't have them

