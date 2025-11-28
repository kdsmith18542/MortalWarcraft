-- Feature: Caravan Data
-- Description: Persistent storage for active caravans
-- Spec: 04-economy.md
-- ==================================================

-- Caravan data table
CREATE TABLE IF NOT EXISTS `mortal_caravan_data` (
    `caravan_guid` BIGINT UNSIGNED NOT NULL COMMENT 'Unique caravan GUID',
    `owner_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID who owns the caravan (FK to characters.guid)',
    `caravan_entry` INT UNSIGNED NOT NULL COMMENT 'NPC entry for the caravan creature',
    `animal_type` TINYINT UNSIGNED NOT NULL COMMENT 'Pack animal type (1=horse, 2=mule, 3=kodo, 4=elekk)',
    `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Caravan state (0=idle, 1=moving, 2=combat, 3=destroyed)',
    `current_speed` FLOAT NOT NULL DEFAULT 2.0 COMMENT 'Current movement speed',
    `max_cargo` FLOAT NOT NULL DEFAULT 100.0 COMMENT 'Maximum cargo capacity',
    `current_cargo` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Current cargo weight',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Current zone ID',
    `pos_x` FLOAT NOT NULL COMMENT 'Current X coordinate',
    `pos_y` FLOAT NOT NULL COMMENT 'Current Y coordinate',
    `pos_z` FLOAT NOT NULL COMMENT 'Current Z coordinate',
    `last_update` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`caravan_guid`),
    INDEX `idx_owner` (`owner_guid`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_state` (`state`),
    FOREIGN KEY (`owner_guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Persistent storage for active caravan data';

-- Caravan cargo table
CREATE TABLE IF NOT EXISTS `mortal_caravan_cargo` (
    `caravan_guid` BIGINT UNSIGNED NOT NULL COMMENT 'FK to mortal_caravan_data.caravan_guid',
    `slot` TINYINT UNSIGNED NOT NULL COMMENT 'Cargo slot (0-19)',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item template entry',
    `item_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Stack count',
    PRIMARY KEY (`caravan_guid`, `slot`),
    INDEX `idx_item` (`item_entry`),
    FOREIGN KEY (`caravan_guid`) REFERENCES `mortal_caravan_data` (`caravan_guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Caravan cargo storage';

-- Caravan escorts table
CREATE TABLE IF NOT EXISTS `mortal_caravan_escorts` (
    `caravan_guid` BIGINT UNSIGNED NOT NULL COMMENT 'FK to mortal_caravan_data.caravan_guid',
    `escort_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID of escort',
    `joined_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Time escort joined',
    PRIMARY KEY (`caravan_guid`, `escort_guid`),
    INDEX `idx_escort` (`escort_guid`),
    FOREIGN KEY (`caravan_guid`) REFERENCES `mortal_caravan_data` (`caravan_guid`) ON DELETE CASCADE,
    FOREIGN KEY (`escort_guid`) REFERENCES `characters` (`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Caravan escort assignments';