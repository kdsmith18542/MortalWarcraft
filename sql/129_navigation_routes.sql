-- ==================================================
-- Project Mortal Warcraft
-- Feature: Navigation Routes
-- Description: Creates common navigation routes
-- Based on: docs/specs/49-navigation-and-wayfinding.md
-- ==================================================

-- Common Routes
INSERT INTO `mortal_navigation_routes` (`route_code`, `name`, `description`, `start_map_id`, `start_zone_id`, `start_x`, `start_y`, `start_z`, `end_map_id`, `end_zone_id`, `end_x`, `end_y`, `end_z`, `route_type`, `difficulty`, `estimated_time_minutes`, `is_active`) VALUES
('ROUTE_STORMWIND_IRONFORGE', 'Stormwind to Ironforge', 'Trade route from Stormwind to Ironforge', 0, 1519, -8949.95, -132.493, 83.5312, 0, 1537, -4797.79, -1117.77, 499.804, 'TRADE', 1, 10, 1),
('ROUTE_ORGRIMMAR_THUNDER_BLUFF', 'Orgrimmar to Thunder Bluff', 'Trade route from Orgrimmar to Thunder Bluff', 1, 1637, 1569.97, -4397.41, 16.0472, 1, 1638, -1277.37, 124.804, 131.287, 'TRADE', 1, 8, 1),
('ROUTE_STORMWIND_DUSKWOOD', 'Stormwind to Duskwood', 'Adventure route to Duskwood', 0, 1519, -8949.95, -132.493, 83.5312, 0, 10, -10898.3, -364.231, 39.2686, 'ADVENTURE', 2, 15, 1),
('ROUTE_ORGRIMMAR_BARRENS', 'Orgrimmar to Barrens', 'Adventure route to the Barrens', 1, 1637, 1569.97, -4397.41, 16.0472, 1, 17, -456.263, -2652.7, 95.615, 'ADVENTURE', 2, 12, 1)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Summary
SELECT 
    'Navigation Routes Created' as summary,
    COUNT(*) as total_routes,
    COUNT(CASE WHEN route_type = 'TRADE' THEN 1 END) as trade_routes,
    COUNT(CASE WHEN route_type = 'ADVENTURE' THEN 1 END) as adventure_routes
FROM mortal_navigation_routes;

