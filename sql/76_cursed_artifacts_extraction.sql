-- ==================================================
-- Mortal Warcraft – Cursed Artifacts & Extraction System
-- Spec 74: Cursed Artifacts and Extraction System
-- Target DB: world
-- ==================================================

-- Artifact Definitions: Static properties of each artifact type
CREATE TABLE IF NOT EXISTS `cursed_artifact_def` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `artifact_key` VARCHAR(64) UNIQUE NOT NULL,    -- e.g. 'MAJOR_TALLYSTONE', 'CROWN_PRIMARY'
    `item_entry` INT NOT NULL,                     -- reference to item_template entry
    `type` TINYINT NOT NULL,                       -- 1 = Minor, 2 = Major, 3 = Crown (Primary)
    `base_weight` INT NOT NULL DEFAULT 100,        -- used to compute encumbrance penalty
    `max_stack` INT NOT NULL DEFAULT 1,
    `is_extraction_required` TINYINT NOT NULL DEFAULT 0,  -- requires extraction phase to complete
    `world_effect_key` VARCHAR(64) DEFAULT NULL,   -- links to world effect handler
    `curse_multiplier` FLOAT NOT NULL DEFAULT 1.0, -- encumbrance multiplier (Major=2.0, Crown=4.0)
    `description` TEXT DEFAULT NULL,
    INDEX `idx_item_entry` (`item_entry`),
    INDEX `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Artifact Instances: Tracks live artifact instances in the world
CREATE TABLE IF NOT EXISTS `cursed_artifact_instance` (
    `guid` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `artifact_id` INT NOT NULL,                    -- FK to cursed_artifact_def.id
    `item_guid` BIGINT NOT NULL,                   -- reference to item instance GUID
    `state` TINYINT NOT NULL DEFAULT 0,            -- 0=dormant, 1=carried, 2=in_extraction, 3=purified, 4=lost/returned
    `owner_guid` BIGINT NULL,                      -- current player guid (if carried)
    `location_map` INT NULL,
    `location_x` FLOAT NULL,
    `location_y` FLOAT NULL,
    `location_z` FLOAT NULL,
    `created_at` INT NOT NULL,
    `updated_at` INT NOT NULL,
    `extraction_zone_id` INT NULL,                 -- zone where extraction is happening
    `extraction_start_time` INT NULL,              -- when extraction phase started
    INDEX `idx_artifact_id` (`artifact_id`),
    INDEX `idx_state` (`state`),
    INDEX `idx_owner` (`owner_guid`),
    INDEX `idx_location` (`location_map`, `location_x`, `location_y`),
    FOREIGN KEY (`artifact_id`) REFERENCES `cursed_artifact_def`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- World State: Tracks global effects of Major/Crown artifacts
CREATE TABLE IF NOT EXISTS `cursed_world_state` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `world_effect_key` VARCHAR(64) UNIQUE NOT NULL, -- e.g. 'MIDNIGHT_HORDE_RATE', 'SHRINE_PENALTY'
    `value` FLOAT NOT NULL DEFAULT 0.0,            -- signed scalar
    `updated_at` INT NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Extraction Events: Tracks active extraction phases
CREATE TABLE IF NOT EXISTS `cursed_extraction_event` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `artifact_instance_guid` BIGINT NOT NULL,      -- FK to cursed_artifact_instance.guid
    `zone_id` INT NOT NULL,                        -- zone where extraction is happening
    `altar_go_entry` INT NOT NULL,                 -- gameobject entry for extraction altar
    `altar_map` INT NOT NULL,
    `altar_x` FLOAT NOT NULL,
    `altar_y` FLOAT NOT NULL,
    `altar_z` FLOAT NOT NULL,
    `start_time` INT NOT NULL,                     -- when extraction phase started
    `duration_sec` INT NOT NULL DEFAULT 3600,      -- extraction window duration (1 hour default)
    `state` TINYINT NOT NULL DEFAULT 0,           -- 0=active, 1=completed, 2=failed, 3=cancelled
    `completion_time` INT NULL,                    -- when extraction completed/failed
    `completed_by_guid` BIGINT NULL,               -- player who completed extraction
    INDEX `idx_artifact` (`artifact_instance_guid`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_state` (`state`),
    INDEX `idx_start_time` (`start_time`),
    FOREIGN KEY (`artifact_instance_guid`) REFERENCES `cursed_artifact_instance`(`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Extraction Participants: Tracks players involved in extraction events
CREATE TABLE IF NOT EXISTS `cursed_extraction_participant` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `extraction_event_id` INT NOT NULL,            -- FK to cursed_extraction_event.id
    `player_guid` BIGINT NOT NULL,
    `joined_at` INT NOT NULL,
    `is_carrier` TINYINT NOT NULL DEFAULT 0,       -- 1 if this player is carrying the artifact
    `contribution_score` INT NOT NULL DEFAULT 0,    -- contribution to extraction success
    INDEX `idx_event` (`extraction_event_id`),
    INDEX `idx_player` (`player_guid`),
    FOREIGN KEY (`extraction_event_id`) REFERENCES `cursed_extraction_event`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Artifact History: Log of artifact state changes and events
CREATE TABLE IF NOT EXISTS `cursed_artifact_history` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `artifact_instance_guid` BIGINT NOT NULL,      -- FK to cursed_artifact_instance.guid
    `event_type` TINYINT NOT NULL,                 -- 1=pickup, 2=drop, 3=death, 4=extraction_start, 5=extraction_complete, 6=purification, 7=lost
    `player_guid` BIGINT NULL,                     -- player involved in event
    `location_map` INT NULL,
    `location_x` FLOAT NULL,
    `location_y` FLOAT NULL,
    `location_z` FLOAT NULL,
    `timestamp` INT NOT NULL,
    `notes` TEXT DEFAULT NULL,
    INDEX `idx_artifact` (`artifact_instance_guid`),
    INDEX `idx_event_type` (`event_type`),
    INDEX `idx_player` (`player_guid`),
    INDEX `idx_timestamp` (`timestamp`),
    FOREIGN KEY (`artifact_instance_guid`) REFERENCES `cursed_artifact_instance`(`guid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Example artifact definitions (placeholders - adjust item_entry values as needed)
INSERT INTO `cursed_artifact_def` (`artifact_key`, `item_entry`, `type`, `base_weight`, `max_stack`, `is_extraction_required`, `world_effect_key`, `curse_multiplier`, `description`) VALUES
('MINOR_CURSED_RELIC_1', 735001, 1, 50, 1, 0, NULL, 1.0, 'A minor cursed relic with slight Ether corruption.'),
('MAJOR_TALLYSTONE', 735010, 2, 100, 1, 1, 'MIDNIGHT_HORDE_RATE', 2.0, 'The Tallystone of the Unpaid from the Ledger of Bones. Amplifies Midnight Horde activity.'),
('MAJOR_FORGEWROUGHT_HEART', 735011, 2, 100, 1, 1, 'SHRINE_PENALTY', 2.0, 'The Heart of the Forgewrought from Forgewrought Hall. Weakens Shrine defenses.'),
('MAJOR_CHORUS_LOST', 735012, 2, 100, 1, 1, 'RIFT_FREQUENCY', 2.0, 'The Chorus of the Lost from the Frozen Choir. Increases Rift spawn rates.'),
('CROWN_PRIMARY', 735020, 3, 200, 1, 1, 'CROWN_WORLD_EFFECTS', 4.0, 'The Crown of the Hollow King. The primary cursed artifact responsible for amplifying all world threats.');

-- Initialize world state effects
INSERT INTO `cursed_world_state` (`world_effect_key`, `value`, `updated_at`, `description`) VALUES
('MIDNIGHT_HORDE_RATE', 0.0, UNIX_TIMESTAMP(), 'Multiplier for Midnight Horde spawn rate (0.0 = normal, 1.0 = double)'),
('SHRINE_PENALTY', 0.0, UNIX_TIMESTAMP(), 'Penalty to Shrine defense effectiveness (0.0 = normal, 1.0 = -50%)'),
('RIFT_FREQUENCY', 0.0, UNIX_TIMESTAMP(), 'Multiplier for Rift spawn frequency (0.0 = normal, 1.0 = double)'),
('CROWN_WORLD_EFFECTS', 0.0, UNIX_TIMESTAMP(), 'Combined world effect multiplier from Crown (affects all systems)');

-- Note: Extraction altar rotation table should already exist from MortalAltarRotation system
-- If not, create it:
CREATE TABLE IF NOT EXISTS `extraction_altar_rotation` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `current_altar_id` INT NOT NULL DEFAULT 1,
    `rotation_time` INT NOT NULL,
    `next_rotation_time` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initialize altar rotation if not exists
INSERT IGNORE INTO `extraction_altar_rotation` (`current_altar_id`, `rotation_time`, `next_rotation_time`) VALUES
(1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP() + 604800); -- Rotate weekly

