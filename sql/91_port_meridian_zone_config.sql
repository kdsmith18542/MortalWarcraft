-- ==================================================
-- Mortal Warcraft – Port Meridian Zone Configuration
-- Spec 62: Core Lore and Campaign Skeleton
-- Target DB: world
-- ==================================================

-- Zone Configuration for Port Meridian (Act I Hub)
-- This is the first major Green Zone hub on the mainland

-- Zone ID: 1519 (Elwynn Forest) or custom zone
-- Map: 0 (Eastern Kingdoms)

-- Key Locations in Port Meridian

-- Task Board (GO ID: 19990)
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT 19990, 19990, 0, 1519, 0, 1, 1,
    -8820.0, 645.0, 94.0, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 19990);

-- Regional Bank (GO ID: 19991)
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT 19991, 19991, 0, 1519, 0, 1, 1,
    -8815.0, 650.0, 94.0, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 19991);

-- Shrine (GO ID: 19992)
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT 19992, 19992, 0, 1519, 0, 1, 1,
    -8800.0, 620.0, 94.0, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = 19992);

-- Market Stalls (GO ID: 19993-19996)
-- Multiple market stall gameobjects
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, 
    `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, 
    `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`)
SELECT guid, 19993, 0, 1519, 0, 1, 1,
    position_x, position_y, position_z, 0.0, 0.0, 0.0, 0.0, 1.0,
    0, 100, 1, ''
FROM (
    SELECT 19993 AS guid, -8825.0 AS position_x, 635.0 AS position_y, 94.0 AS position_z
    UNION SELECT 19994, -8828.0, 638.0, 94.0
    UNION SELECT 19995, -8831.0, 641.0, 94.0
    UNION SELECT 19996, -8834.0, 644.0, 94.0
) AS positions
WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `guid` = positions.guid);

-- Zone Risk Configuration
-- Port Meridian is a Green Zone (safe hub)
INSERT INTO `mortal_zone_risk_config` (`zone_id`, `risk_tier`, `pvp_enabled`, `full_loot_enabled`, `shrine_respawn_enabled`, `description`)
VALUES
(1519, 'GREEN', 0, 0, 1, 'Port Meridian - Safe Green Zone hub for Act I')
ON DUPLICATE KEY UPDATE
    `risk_tier` = VALUES(`risk_tier`),
    `pvp_enabled` = VALUES(`pvp_enabled`),
    `full_loot_enabled` = VALUES(`full_loot_enabled`),
    `shrine_respawn_enabled` = VALUES(`shrine_respawn_enabled`),
    `description` = VALUES(`description`);

-- Task Board Configuration
INSERT INTO `mortal_task_board` (`board_id`, `zone_id`, `name`, `position_x`, `position_y`, `position_z`, `refresh_interval_minutes`, `max_active_tasks`, `description`)
VALUES
(1, 1519, 'Port Meridian Task Board', -8820.0, 645.0, 94.0, 60, 20, 'Main task board for Port Meridian contracts')
ON DUPLICATE KEY UPDATE
    `zone_id` = VALUES(`zone_id`),
    `name` = VALUES(`name`),
    `position_x` = VALUES(`position_x`),
    `position_y` = VALUES(`position_y`),
    `position_z` = VALUES(`position_z`),
    `refresh_interval_minutes` = VALUES(`refresh_interval_minutes`),
    `max_active_tasks` = VALUES(`max_active_tasks`),
    `description` = VALUES(`description`);

