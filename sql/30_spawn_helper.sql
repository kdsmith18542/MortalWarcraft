-- ==================================================
-- Project Mortal Warcraft: Spawn Helper
-- Feature: Instructions for spawning NPCs when creature table doesn't exist
-- Description: Use in-game GM commands to spawn NPCs manually
-- ==================================================

-- Since the creature spawn table doesn't exist in this database structure,
-- NPCs must be spawned manually using in-game GM commands.

-- ==================================================
-- SPAWN INSTRUCTIONS
-- ==================================================

-- 1. MERCENARY BROKERS
--    Location: Stormwind (Trade District, near bank)
--    Command: .npc add 91000
--    Coordinates: -8861.0, 674.5, 97.9 (Zone 1519)
--    
--    Location: Orgrimmar (Valley of Strength, near bank)
--    Command: .npc add 91000
--    Coordinates: 1596.5, -4379.2, 10.1 (Zone 1637)
--    
--    Location: Booty Bay (Stranglethorn Vale)
--    Command: .npc add 91000
--    Coordinates: -14464.4, 460.2, 16.3 (Zone 35)

-- 2. MARKET DISTRICT AUCTIONEERS
--    These are standard WoW auctioneers (entries 8670-8675, 9856, 15659, 15678)
--    They should already exist in the world, but if missing:
--    Command: .npc add [entry] (at appropriate locations)

-- ==================================================
-- ALTERNATIVE: Create a simple spawn management table
-- ==================================================

-- If you want to track spawns in the database, create this table:
CREATE TABLE IF NOT EXISTS `mortal_custom_spawns` (
    `spawn_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `creature_entry` INT UNSIGNED NOT NULL,
    `map_id` INT UNSIGNED NOT NULL,
    `zone_id` INT UNSIGNED NOT NULL,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `o` FLOAT NOT NULL DEFAULT 0,
    `spawned` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0=Not spawned, 1=Spawned',
    `spawned_guid` BIGINT UNSIGNED DEFAULT NULL COMMENT 'GUID of spawned creature',
    `notes` VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (`spawn_id`),
    KEY `idx_entry` (`creature_entry`),
    KEY `idx_spawned` (`spawned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert spawn locations for Mercenary Brokers
INSERT IGNORE INTO `mortal_custom_spawns` 
    (`creature_entry`, `map_id`, `zone_id`, `x`, `y`, `z`, `o`, `spawned`, `notes`) 
VALUES
    (91000, 0, 1519, -8861.0, 674.5, 97.9, 1.57, 0, 'Mercenary Broker - Stormwind'),
    (91000, 1, 1637, 1596.5, -4379.2, 10.1, 5.0, 0, 'Mercenary Broker - Orgrimmar'),
    (91000, 0, 35, -14464.4, 460.2, 16.3, 2.9, 0, 'Mercenary Broker - Booty Bay');

SELECT 'Spawn helper table created. Use .npc add commands or create a Lua script to auto-spawn from this table.' AS result;

