-- ==================================================
-- Mortal Warcraft – Shipwreck Cove Zone Configuration
-- Spec 62: Core Lore and Campaign Skeleton
-- Target DB: world
-- ==================================================

-- Zone Configuration for Shipwreck Cove
-- This would be a phased/isolated starter area

-- Zone ID: 9999 (custom zone ID for Shipwreck Cove)
-- Map: 0 (Eastern Kingdoms) or custom instance map

-- GameObjects for Shipwreck Cove

-- Makeshift Anvil (GO ID: 19980)
-- Position: Near survivor camp
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT 19980, 19980, 0, 9999, 0, 1, 1,
    -8955.0, -135.0, 83.0, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 19980);

-- Damaged Raft (GO ID: 19981)
-- Position: Beach area
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT 19981, 19981, 0, 9999, 0, 1, 1,
    -8960.0, -150.0, 82.0, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 19981);

-- Damaged Shrine Fragment (GO ID: 19982)
-- Position: Further up the beach
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT 19982, 19982, 0, 9999, 0, 1, 1,
    -8970.0, -160.0, 82.0, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 19982);

-- Driftwood Piles (GO ID: 19983)
-- Multiple spawns along the beach
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT guid, 19983, 0, 9999, 0, 1, 1,
    position_x, position_y, position_z, 0.0, 0.0, 0.0, 0.0, 1.0,
    300, 100, 1, ''
FROM (
    SELECT 19983 AS guid, -8950.0 AS position_x, -145.0 AS position_y, 82.5 AS position_z
    UNION SELECT 19984, -8955.0, -148.0, 82.5
    UNION SELECT 19985, -8960.0, -151.0, 82.5
) AS positions
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = positions.guid);

-- Zone Risk Configuration
-- Shipwreck Cove is a Green Zone (safe starter area)
INSERT INTO `mortal_zone_risk_config` (`zone_id`, `risk_tier`, `pvp_enabled`, `full_loot_enabled`, `shrine_respawn_enabled`, `description`)
VALUES
(9999, 'GREEN', 0, 0, 0, 'Shipwreck Cove - Safe starter area for new players')
ON DUPLICATE KEY UPDATE
    `risk_tier` = VALUES(`risk_tier`),
    `pvp_enabled` = VALUES(`pvp_enabled`),
    `full_loot_enabled` = VALUES(`full_loot_enabled`),
    `shrine_respawn_enabled` = VALUES(`shrine_respawn_enabled`),
    `description` = VALUES(`description`);

