-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Market Districts (Physical AH Terminals)
-- Description: Places Auctioneer/Broker NPCs in major cities and select tradeposts.
--              Co-locates them with bankers for Regional Banking integration.
-- ==================================================

-- WARNING: This script adds/modifies NPC spawns.
-- Make sure you have a database backup before running this!

-- Market Locations (Capitals + Select Tradeposts):
-- Stormwind (1519), Ironforge (1537), Darnassus (1657)
-- Orgrimmar (1637), Thunder Bluff (1638), Undercity (1497)
-- Booty Bay (35), Gadgetzan (976), Everlook (6182)

-- Auctioneer NPC Entry IDs (Standard WoW Auctioneers):
-- Alliance: 8670 (Stormwind), 8671 (Ironforge), 8672 (Darnassus)
-- Horde: 8673 (Orgrimmar), 8674 (Thunder Bluff), 8675 (Undercity)
-- Neutral: 9856 (Booty Bay), 15659 (Gadgetzan), 15678 (Everlook)

SET @placed_auctioneers = 0;

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. ENSURE AUCTIONEERS EXIST IN MARKET DISTRICTS
-- ------------------------------------------------------------------

-- Note: This script assumes auctioneer NPCs already exist in the database.
-- We're verifying their placement in market zones and adding them if missing.

-- Stormwind Market District (Trade District)
-- Zone: 1519, Area: 1519 (Stormwind City)
-- Coordinates: Near the bank in Trade District
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
-- Stormwind Auctioneer (near bank)
(900000, 8670, 0, 1519, 1519, '0', 0, 0, 0, -1, 0, 0, -8812.0, 650.0, 96.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Ironforge Auctioneer (near bank)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900001, 8671, 0, 1537, 1537, '0', 0, 0, 0, -1, 0, 0, -4981.0, -881.0, 502.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Darnassus Auctioneer (near bank)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900002, 8672, 1, 1657, 1657, '0', 0, 0, 0, -1, 0, 0, 9938.0, 2500.0, 1319.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Orgrimmar Auctioneer (Valley of Strength, near bank)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900003, 8673, 1, 1637, 1637, '0', 0, 0, 0, -1, 0, 0, 1552.0, -4414.0, 10.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Thunder Bluff Auctioneer (near bank)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900004, 8674, 1, 1638, 1638, '0', 0, 0, 0, -1, 0, 0, -1238.0, 104.0, 129.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Undercity Auctioneer (near bank)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900005, 8675, 0, 1497, 1497, '0', 0, 0, 0, -1, 0, 0, 1565.0, 238.0, -43.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Booty Bay Auctioneer (Stranglethorn Vale)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900006, 9856, 0, 35, 35, '0', 0, 0, 0, -1, 0, 0, -14441.0, 470.0, 15.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Gadgetzan Auctioneer (Tanaris)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900007, 15659, 1, 976, 976, '0', 0, 0, 0, -1, 0, 0, -7176.0, -3788.0, 8.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- Everlook Auctioneer (Winterspring)
INSERT IGNORE INTO `creature` (
    `guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
    `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
    `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`,
    `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `ScriptName`, `VerifiedBuild`
) VALUES
(900008, 15678, 1, 6182, 6182, '0', 0, 0, 0, -1, 0, 0, 6738.0, -4613.0, 721.0, 0.0, 300, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, '', 12340);

SET @placed_auctioneers = @placed_auctioneers + ROW_COUNT();

-- ------------------------------------------------------------------
-- 2. VERIFY AUCTIONEER NPCFLAGS (128 = AUCTIONEER)
-- ------------------------------------------------------------------

-- Ensure all auctioneer NPCs have the correct npcflag
UPDATE `creature_template`
SET `npcflag` = 128  -- NPC_FLAG_AUCTIONEER
WHERE `entry` IN (8670, 8671, 8672, 8673, 8674, 8675, 9856, 15659, 15678)
AND (`npcflag` & 128) = 0;

COMMIT;

-- Report results
SELECT CONCAT('Placed/Verified ', @placed_auctioneers, ' auctioneer NPCs in market districts.') AS result;

-- Verification: List auctioneers by zone
SELECT 
    c.guid,
    ct.name AS npc_name,
    c.zoneId,
    (SELECT name FROM area_table WHERE id = c.zoneId LIMIT 1) AS zone_name,
    c.position_x,
    c.position_y,
    c.position_z
FROM `creature` c
JOIN `creature_template` ct ON c.id = ct.entry
WHERE ct.entry IN (8670, 8671, 8672, 8673, 8674, 8675, 9856, 15659, 15678)
ORDER BY c.zoneId;

