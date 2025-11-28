-- ==================================================
-- Project Mortal Warcraft
-- Feature: Bounty System Enhancement
-- Description: Enhanced notoriety tracking with zone-based multipliers
-- ==================================================

-- Add zone-based notoriety multiplier tracking
-- Note: Run this against azerothcore_characters database
-- Check if columns exist before adding (for azerothcore_characters database)

USE azerothcore_characters;

SET @dbname = 'azerothcore_characters';
SET @tablename = 'character_notoriety';

-- Add zone_id column if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = 'zone_id') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN `zone_id` INT UNSIGNED DEFAULT NULL COMMENT ''Zone where last kill occurred''')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add total_kills column if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = 'total_kills') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN `total_kills` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''Total innocent player kills''')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add index if it doesn't exist
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND INDEX_NAME = 'idx_zone') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD INDEX `idx_zone` (`zone_id`)')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Create bounty board NPC locations table (for future NPC implementation)
CREATE TABLE IF NOT EXISTS `bounty_board_locations` (
    `location_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_id` INT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `o` FLOAT NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert bounty board locations (major cities)
INSERT INTO `bounty_board_locations` (`map_id`, `x`, `y`, `z`, `o`, `zone_id`, `description`) VALUES
(0, -8842.09, 626.358, 94.0867, 0, 1519, 'Stormwind - Trade District'),
(1, 1601.08, -4378.69, 9.9846, 0, 1637, 'Orgrimmar - Valley of Strength'),
(0, -5603.76, -482.704, 396.98, 0, 1537, 'Ironforge - Great Forge'),
(1, 2279.68, 242.623, 25.7218, 0, 1638, 'Thunder Bluff - Lower Rise'),
(0, 9889.03, 915.869, 1307.78, 0, 141, 'Teldrassil - Cenarion Enclave'),
(1, 1248.8, -4436.84, 26.6238, 0, 1637, 'Orgrimmar - Valley of Honor')

ON DUPLICATE KEY UPDATE `description` = VALUES(`description`);

