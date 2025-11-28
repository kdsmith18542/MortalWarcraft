-- ==================================================
-- Mortal Warcraft – Campaign NPC Spawns
-- Spec 62: Core Lore and Campaign Skeleton
-- Target DB: world
-- ==================================================

-- Prologue NPCs (Shipwreck Cove)
-- Note: Replace coordinates with actual zone coordinates

-- Survivor Alden (99990)
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`)
SELECT 99990, 99990, 0, 0, 0, 1, 1, 0, 0, -8949.0, -132.0, 83.0, 0.0, 300, 0, 0, 100, 0, 0, 0, 0, 0, ''
WHERE NOT EXISTS (SELECT 1 FROM `creature` WHERE `guid` = 99990);

-- Training Dummy (99992)
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`)
SELECT 99992, 99992, 0, 0, 0, 1, 1, 0, 0, -8950.0, -140.0, 83.0, 0.0, 300, 0, 0, 100, 0, 0, 0, 0, 0, ''
WHERE NOT EXISTS (SELECT 1 FROM `creature` WHERE `guid` = 99992);

-- Act I NPCs (Port Meridian)

-- Harbor Clerk (99980)
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`)
SELECT 99980, 99980, 0, 0, 0, 1, 1, 0, 0, -8823.0, 640.0, 94.0, 0.0, 300, 0, 0, 100, 0, 0, 0, 0, 0, ''
WHERE NOT EXISTS (SELECT 1 FROM `creature` WHERE `guid` = 99980);

-- Banker (99983)
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`)
SELECT 99983, 99983, 0, 0, 0, 1, 1, 0, 0, -8815.0, 650.0, 94.0, 0.0, 300, 0, 0, 100, 0, 0, 0, 0, 0, ''
WHERE NOT EXISTS (SELECT 1 FROM `creature` WHERE `guid` = 99983);

-- Shrine Acolyte (99984)
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `unit_flags`, `dynamicflags`, `ScriptName`)
SELECT 99984, 99984, 0, 0, 0, 1, 1, 0, 0, -8800.0, 620.0, 94.0, 0.0, 300, 0, 0, 100, 0, 0, 0, 0, 0, ''
WHERE NOT EXISTS (SELECT 1 FROM `creature` WHERE `guid` = 99984);

-- Quest Giver Relations
INSERT INTO `creature_questrelation` (`id`, `quest`)
VALUES
(99990, 90000), -- Survivor Alden gives Q90000
(99990, 90001),
(99990, 90002),
(99990, 90003),
(99990, 90004),
(99990, 90005),
(99980, 90010), -- Harbor Clerk gives Q90010
(99980, 90011),
(99980, 90012),
(99980, 90013),
(99980, 90014),
(99984, 90014) -- Shrine Acolyte also gives Q90014
ON DUPLICATE KEY UPDATE `quest` = VALUES(`quest`);

-- Quest Finisher Relations
INSERT INTO `creature_involvedrelation` (`id`, `quest`)
VALUES
(99990, 90000),
(99990, 90001),
(99990, 90002),
(99990, 90003),
(99990, 90004),
(99990, 90005),
(99980, 90010),
(99980, 90011),
(99980, 90012),
(99980, 90013),
(99980, 90014),
(99984, 90014)
ON DUPLICATE KEY UPDATE `quest` = VALUES(`quest`);

