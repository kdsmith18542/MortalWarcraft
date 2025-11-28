-- ==================================================
-- Mortal Warcraft – Faction Sanctums System
-- Spec 60: Faction Sanctums
-- Target DB: world (definitions), characters (state)
-- ==================================================

-- Sanctum Unlock Levels: Defines Sanctum tiers and access requirements
CREATE TABLE IF NOT EXISTS `mortal_faction_sanctums` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `faction_code` VARCHAR(64) NOT NULL COMMENT 'Faction code: IRON_LEDGER, ORDER_SHRINE, BLACK_SUN_CARTEL, RANGERS_PACT',
    `tier` INT UNSIGNED NOT NULL COMMENT 'Sanctum tier (1-N)',
    `standing_min` INT NOT NULL DEFAULT 0 COMMENT 'Minimum faction standing to unlock (0 = neutral)',
    `map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID for Sanctum instance',
    `entrance_go_id` INT UNSIGNED DEFAULT NULL COMMENT 'Optional gameobject entry for portal/door',
    `entrance_x` FLOAT NOT NULL DEFAULT 0 COMMENT 'Entrance X coordinate',
    `entrance_y` FLOAT NOT NULL DEFAULT 0 COMMENT 'Entrance Y coordinate',
    `entrance_z` FLOAT NOT NULL DEFAULT 0 COMMENT 'Entrance Z coordinate',
    `entrance_o` FLOAT NOT NULL DEFAULT 0 COMMENT 'Entrance orientation',
    `flags` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sanctum flags',
    `description` TEXT DEFAULT NULL COMMENT 'Sanctum description',
    UNIQUE KEY `uniq_faction_tier` (`faction_code`, `tier`),
    INDEX `idx_faction_code` (`faction_code`),
    INDEX `idx_standing_min` (`standing_min`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Faction Sanctum definitions and unlock requirements';

-- Player Sanctum State: Per-player Sanctum progression and personalization
CREATE TABLE IF NOT EXISTS `mortal_faction_sanctum_state` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `guid` INT UNSIGNED NOT NULL COMMENT 'Character GUID',
    `faction_code` VARCHAR(64) NOT NULL COMMENT 'Faction code',
    `unlocked_tier` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Highest unlocked Sanctum tier',
    `decor_json` JSON DEFAULT NULL COMMENT 'Personalized decoration data (if used)',
    `last_visit_ts` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last visit timestamp',
    `last_update_ts` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
    UNIQUE KEY `uniq_guid_faction` (`guid`, `faction_code`),
    INDEX `idx_guid` (`guid`),
    INDEX `idx_faction_code` (`faction_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Per-character Sanctum state and progression';

-- Example Sanctum definitions (base tier for each faction)
INSERT INTO `mortal_faction_sanctums` (`faction_code`, `tier`, `standing_min`, `map_id`, `description`) VALUES
('IRON_LEDGER', 1, 0, 0, 'Iron Ledger Trade Hall - Base tier accessible at Neutral standing'),
('ORDER_SHRINE', 1, 0, 0, 'Order of the Shrine Chapel - Base tier accessible at Neutral standing'),
('BLACK_SUN_CARTEL', 1, 0, 0, 'Black Sun Cartel Den - Base tier accessible at Neutral standing'),
('RANGERS_PACT', 1, 0, 0, 'Rangers\' Pact Lodge - Base tier accessible at Neutral standing');

