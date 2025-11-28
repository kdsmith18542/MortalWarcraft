-- ==================================================
-- Project Mortal Warcraft
-- Feature: Planar Rifts and Anomalies
-- Description: Populates planar rift and anomaly spawn locations
-- Based on: docs/specs/45-eldens-eve-layer.md
-- ==================================================

-- Planar Rifts (2 rifts)
INSERT INTO `mortal_planar_rifts` (`rift_code`, `name`, `description`, `map_id`, `zone_id`, `x`, `y`, `z`, `spawn_chance`, `min_level`, `max_level`, `cooldown_hours`, `is_active`) VALUES
('RIFT_EMERALD_DREAM', 'Emerald Dream Rift', 'A shimmering portal to the Emerald Dream', 0, 0, -8949.95, -132.493, 83.5312, 0.1, 1, 80, 24, 1),
('RIFT_SHADOWLANDS', 'Shadowlands Rift', 'A dark portal to the Shadowlands', 0, 0, 1569.97, -4397.41, 16.0472, 0.1, 1, 80, 24, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Planar Anomalies (2 anomalies)
INSERT INTO `mortal_planar_anomalies` (`anomaly_code`, `name`, `description`, `map_id`, `zone_id`, `x`, `y`, `z`, `spawn_chance`, `min_level`, `max_level`, `cooldown_hours`, `is_active`) VALUES
('ANOMALY_TIME_DISTORTION', 'Time Distortion', 'A temporal anomaly causing time to flow differently', 0, 0, -8949.95, -132.493, 83.5312, 0.05, 1, 80, 48, 1),
('ANOMALY_MANA_STORM', 'Mana Storm', 'A wild magic storm disrupting spellcasting', 0, 0, 1569.97, -4397.41, 16.0472, 0.05, 1, 80, 48, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Summary
SELECT 
    'Planar Events Created' as summary,
    COUNT(*) as total_rifts
FROM mortal_planar_rifts
UNION ALL
SELECT 
    'Planar Anomalies Created' as summary,
    COUNT(*) as total_anomalies
FROM mortal_planar_anomalies;

