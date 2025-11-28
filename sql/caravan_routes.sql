-- ==================================================
-- Feature: Caravan Routes
-- Description: Pre-defined caravan routes between zones
-- Spec: 04-economy.md section 6. Caravans & Hauling
-- ==================================================

CREATE TABLE IF NOT EXISTS `mortal_caravan_routes` (
    `route_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `route_name` VARCHAR(100) NOT NULL COMMENT 'Human-readable route name',
    `start_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Starting zone ID',
    `end_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Ending zone ID',
    `start_pos_x` FLOAT NOT NULL COMMENT 'Starting X coordinate',
    `start_pos_y` FLOAT NOT NULL COMMENT 'Starting Y coordinate',
    `start_pos_z` FLOAT NOT NULL COMMENT 'Starting Z coordinate',
    `end_pos_x` FLOAT NOT NULL COMMENT 'Ending X coordinate',
    `end_pos_y` FLOAT NOT NULL COMMENT 'Ending Y coordinate',
    `end_pos_z` FLOAT NOT NULL COMMENT 'Ending Z coordinate',
    `base_reward_gold` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Base gold reward for completing route',
    `difficulty` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Route difficulty (1-5, affects ambush chance)',
    `distance` FLOAT NOT NULL DEFAULT 0 COMMENT 'Route distance in yards',
    `enabled` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Whether route is active',
    `description` VARCHAR(255) NULL COMMENT 'Optional route description',
    INDEX `idx_start_zone` (`start_zone_id`),
    INDEX `idx_end_zone` (`end_zone_id`),
    INDEX `idx_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Pre-defined caravan routes for hauling mechanics';

-- Insert sample caravan routes
INSERT INTO `mortal_caravan_routes` (
    `route_name`, `start_zone_id`, `end_zone_id`,
    `start_pos_x`, `start_pos_y`, `start_pos_z`,
    `end_pos_x`, `end_pos_y`, `end_pos_z`,
    `base_reward_gold`, `difficulty`, `distance`, `enabled`, `description`
) VALUES
-- Alliance routes
('Stormwind to Ironforge', 1519, 1537,
    -8913.0, 554.0, 94.0,    -- Stormwind
    -4918.0, -940.0, 501.0,   -- Ironforge
    150, 2, 1500.0, 1, 'Safe trade route through Elwynn Forest'),

('Ironforge to Stormwind', 1537, 1519,
    -4918.0, -940.0, 501.0,   -- Ironforge
    -8913.0, 554.0, 94.0,     -- Stormwind
    150, 2, 1500.0, 1, 'Safe trade route through Dun Morogh'),

-- Horde routes
('Orgrimmar to Thunder Bluff', 1637, 1638,
    1430.0, -4420.0, 25.0,    -- Orgrimmar
    -1274.0, 125.0, 131.0,     -- Thunder Bluff
    150, 2, 1200.0, 1, 'Trade route through Durotar'),

('Thunder Bluff to Orgrimmar', 1638, 1637,
    -1274.0, 125.0, 131.0,     -- Thunder Bluff
    1430.0, -4420.0, 25.0,     -- Orgrimmar
    150, 2, 1200.0, 1, 'Trade route through Mulgore'),

-- Neutral/Cross-faction routes
('Booty Bay to Gadgetzan', 35, 440,
    -14457.0, 470.0, 15.0,     -- Booty Bay
    -7150.0, -3800.0, 8.0,      -- Gadgetzan
    200, 3, 2500.0, 1, 'Long desert caravan route'),

('Gadgetzan to Booty Bay', 440, 35,
    -7150.0, -3800.0, 8.0,      -- Gadgetzan
    -14457.0, 470.0, 15.0,      -- Booty Bay
    200, 3, 2500.0, 1, 'Long desert caravan route'),

-- Yellow zone routes (higher difficulty)
('Ratchet to Crossroads', 17, 17,
    -956.0, -3754.0, 5.0,       -- Ratchet
    -452.0, -2650.0, 95.0,      -- Crossroads
    100, 3, 1200.0, 1, 'Barrens trade route'),

('Crossroads to Ratchet', 17, 17,
    -452.0, -2650.0, 95.0,      -- Crossroads
    -956.0, -3754.0, 5.0,       -- Ratchet
    100, 3, 1200.0, 1, 'Barrens trade route'),

-- Red zone routes (highest difficulty)
('Gadgetzan to Cenarion Hold', 440, 1377,
    -7150.0, -3800.0, 8.0,      -- Gadgetzan
    -6820.0, 821.0, 50.0,       -- Cenarion Hold
    300, 5, 1800.0, 1, 'Dangerous Silithus route'),

('Cenarion Hold to Gadgetzan', 1377, 440,
    -6820.0, 821.0, 50.0,       -- Cenarion Hold
    -7150.0, -3800.0, 8.0,      -- Gadgetzan
    300, 5, 1800.0, 1, 'Dangerous Silithus route');