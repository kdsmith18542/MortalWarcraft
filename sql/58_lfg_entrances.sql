-- ==================================================
-- Project Mortal Warcraft
-- Feature: LFG Entrance Metadata
-- Description: Maps LFG content tags to world coordinates for map pins
-- ==================================================

DROP TABLE IF EXISTS `mortal_lfg_entrances`;
CREATE TABLE `mortal_lfg_entrances` (
  `content_tag` VARCHAR(64) NOT NULL COMMENT 'Matches mortal_lfg_listings.content_tag',
  `map_id` SMALLINT UNSIGNED NOT NULL COMMENT 'World map/zone ID for portal',
  `pos_x` FLOAT NOT NULL,
  `pos_y` FLOAT NOT NULL,
  `pos_z` FLOAT NOT NULL DEFAULT 0,
  `description` VARCHAR(120) DEFAULT NULL,
  PRIMARY KEY (`content_tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Travel locations for LFG panel';

INSERT INTO `mortal_lfg_entrances` (`content_tag`, `map_id`, `pos_x`, `pos_y`, `pos_z`, `description`) VALUES
('DEADMINES', 40, -11208.0, 1686.0, 24.0, 'Deadmines entrance near Moonbrook'),
('SCARLET_MONASTERY', 85, 2872.0, -820.0, 160.0, 'Scarlet Monastery portal in Tirisfal Glades'),
('WAILING_CAVERNS', 1, -740.059, -2214.23, 16.1374, 'Wailing Caverns sinkhole outside the Crossroads'),
('RAGEFIRE_CHASM', 1, 1813.49, -4418.58, -18.57, 'Ragefire portal inside the Cleft of Shadow'),
('SHADOWFANG_KEEP', 0, -232.796, 1568.28, 76.8909, 'Shadowfang gate in Silverpine Forest'),
('STORMWIND_STOCKADES', 0, -8764.83, 846.075, 87.4842, 'Stormwind Stockades prison entrance'),
('GNOMEREGAN', 0, -5163.33, 927.623, 257.188, 'Gnomeregan main gate in Dun Morogh'),
('BLACKFATHOM_DEEPS', 1, 4247.74, 745.879, -24.5299, 'Blackfathom grotto along the Zoram Strand'),
('RAZORFEN_KRAUL', 1, -4464.92, -1666.24, 81.8928, 'Razorfen Kraul thorn rise'),
('RAZORFEN_DOWNS', 1, -4658.12, -2526.35, 81.492, 'Razorfen Downs spiral entrance'),
('ZUL_FARRAK', 1, -6796.49, -2890.77, 8.88063, 'Zul\'Farrak gate in Tanaris'),
('ULDAMAN', 0, -6066.73, -2955.63, 209.776, 'Uldaman digsite in Badlands'),
('MARAUDON', 1, -1186.98, 2875.95, 85.7258, 'Maraudon canyon entrance'),
('DIRE_MAUL', 1, -3737.48, 934.975, 160.973, 'Dire Maul central courtyard');
