-- ==================================================
-- Project Mortal Warcraft
-- Feature: Tutorial System (The Shipwreck)
-- Description: Mandatory quest chain for new players
-- ==================================================

-- Tutorial Quest Chain Table
CREATE TABLE IF NOT EXISTS `tutorial_quests` (
    `quest_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `quest_name` VARCHAR(100) NOT NULL,
    `quest_order` TINYINT UNSIGNED NOT NULL COMMENT 'Order in tutorial chain (1-4)',
    `objective_type` VARCHAR(50) NOT NULL COMMENT 'Action Skills, Gathering, Risk, Graduation',
    `objective_description` TEXT,
    `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0,
    `reward_item` INT UNSIGNED DEFAULT NULL,
    `reward_item_count` INT UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Tutorial Quest Chain (Two-Stage Tutorial)
-- Stage 1: Shipwreck Cove (Survival)
INSERT INTO `tutorial_quests` (`quest_id`, `quest_name`, `quest_order`, `objective_type`, `objective_description`, `reward_gold`, `reward_item`, `reward_item_count`) VALUES
-- Stage 1: Shipwreck Cove
(90001, 'Learning to Fight', 1, 'Action Skills', 'Attack the Training Dummy to learn how combat skills work. Hit it 10 times.', 100, NULL, 0),
(90002, 'Gathering Driftwood', 2, 'Harvesting', 'Gather Driftwood from the shipwreck to learn harvesting skills.', 100, NULL, 0),
(90003, 'Crafting a Shiv', 3, 'Crafting', 'Use the Anvil to craft a Shiv from the materials you gathered.', 100, 90030, 1), -- Custom Shiv item
(90004, 'Understanding Risk', 4, 'Risk', 'Speak with the Survivor to learn about zone rules and Full Loot zones.', 100, NULL, 0),
(90005, 'Repair the Raft', 5, 'Exit', 'Repair the raft using your crafting skills to travel to the mainland.', 200, NULL, 0),

-- Stage 2: Mainland Hub (Society)
(90006, 'The Market', 6, 'Market', 'Buy a Backpack from a Player Stall in the market district.', 100, NULL, 0),
(90007, 'The Contract', 7, 'Contracts', 'Accept a local Courier mission to move a crate to another location.', 150, NULL, 0),
(90008, 'Regional Banking', 8, 'Banking', 'Deposit your reward in the Regional Bank and learn how regional banking works.', 100, NULL, 0),
(90009, 'Your First Mount', 9, 'Mounts', 'Buy your first Horse Reins from the stable master.', 500, 90031, 1) -- Custom Horse Reins item

ON DUPLICATE KEY UPDATE
    `quest_name` = VALUES(`quest_name`),
    `quest_order` = VALUES(`quest_order`),
    `objective_type` = VALUES(`objective_type`),
    `objective_description` = VALUES(`objective_description`),
    `reward_gold` = VALUES(`reward_gold`),
    `reward_item` = VALUES(`reward_item`),
    `reward_item_count` = VALUES(`reward_item_count`);

-- Tutorial NPCs Table
CREATE TABLE IF NOT EXISTS `tutorial_npcs` (
    `npc_entry` INT UNSIGNED NOT NULL PRIMARY KEY,
    `npc_name` VARCHAR(100) NOT NULL,
    `npc_type` VARCHAR(50) NOT NULL COMMENT 'Training Dummy, Survivor, Anvil, Market Vendor, Courier, Banker, Stable Master',
    `spawn_map` INT UNSIGNED NOT NULL,
    `spawn_x` FLOAT NOT NULL,
    `spawn_y` FLOAT NOT NULL,
    `spawn_z` FLOAT NOT NULL,
    `spawn_o` FLOAT NOT NULL,
    `stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Shipwreck, 2=Mainland Hub',
    `notes` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add stage column if table exists without it
SET @dbname = 'azerothcore_characters';
SET @tablename = 'tutorial_npcs';
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = 'stage') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN `stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT ''1=Shipwreck, 2=Mainland Hub''')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Insert Tutorial NPCs (using placeholder coordinates - update with actual locations)
INSERT INTO `tutorial_npcs` (`npc_entry`, `npc_name`, `npc_type`, `spawn_map`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_o`, `stage`, `notes`) VALUES
-- Stage 1: Shipwreck Cove
(90010, 'Training Dummy', 'Training Dummy', 0, -12345.0, 500.0, 10.0, 0.0, 1, 'Placeholder - update with actual coordinates'),
(90011, 'Shipwreck Survivor', 'Survivor', 0, -12340.0, 510.0, 10.0, 0.0, 1, 'Placeholder - update with actual coordinates'),
(90012, 'Crafting Anvil', 'Anvil', 0, -12335.0, 505.0, 10.0, 0.0, 1, 'Placeholder - update with actual coordinates'),

-- Stage 2: Mainland Hub
(90013, 'Market Vendor', 'Market Vendor', 1, -956.664, -3754.63, 5.34739, 0.0, 2, 'Ratchet - Placeholder'),
(90014, 'Courier Master', 'Courier', 1, -960.0, -3750.0, 5.34739, 0.0, 2, 'Ratchet - Placeholder'),
(90015, 'Regional Banker', 'Banker', 1, -950.0, -3760.0, 5.34739, 0.0, 2, 'Ratchet - Placeholder'),
(90016, 'Stable Master', 'Stable Master', 1, -955.0, -3755.0, 5.34739, 0.0, 2, 'Ratchet - Placeholder')

ON DUPLICATE KEY UPDATE
    `npc_name` = VALUES(`npc_name`),
    `npc_type` = VALUES(`npc_type`),
    `spawn_map` = VALUES(`spawn_map`),
    `spawn_x` = VALUES(`spawn_x`),
    `spawn_y` = VALUES(`spawn_y`),
    `spawn_z` = VALUES(`spawn_z`),
    `spawn_o` = VALUES(`spawn_o`),
    `notes` = VALUES(`notes`);

-- Tutorial GameObjects Table
CREATE TABLE IF NOT EXISTS `tutorial_gameobjects` (
    `go_entry` INT UNSIGNED NOT NULL PRIMARY KEY,
    `go_name` VARCHAR(100) NOT NULL,
    `go_type` VARCHAR(50) NOT NULL COMMENT 'Driftwood, Anvil, Raft, Market Stall',
    `spawn_map` INT UNSIGNED NOT NULL,
    `spawn_x` FLOAT NOT NULL,
    `spawn_y` FLOAT NOT NULL,
    `spawn_z` FLOAT NOT NULL,
    `spawn_o` FLOAT NOT NULL,
    `stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Shipwreck, 2=Mainland Hub',
    `notes` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add stage column if table exists without it
SET @tablename = 'tutorial_gameobjects';
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = 'stage') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN `stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT ''1=Shipwreck, 2=Mainland Hub''')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Insert Tutorial GameObjects
INSERT INTO `tutorial_gameobjects` (`go_entry`, `go_name`, `go_type`, `spawn_map`, `spawn_x`, `spawn_y`, `spawn_z`, `spawn_o`, `stage`, `notes`) VALUES
-- Stage 1: Shipwreck Cove
(90020, 'Driftwood Pile', 'Driftwood', 0, -12345.0, 505.0, 10.0, 0.0, 1, 'Placeholder - update with actual coordinates'),
(90021, 'Crafting Anvil', 'Anvil', 0, -12335.0, 505.0, 10.0, 0.0, 1, 'Placeholder - update with actual coordinates'),
(90022, 'Damaged Raft', 'Raft', 0, -12350.0, 490.0, 10.0, 0.0, 1, 'Placeholder - update with actual coordinates'),

-- Stage 2: Mainland Hub
(90023, 'Market Stall', 'Market Stall', 1, -956.664, -3754.63, 5.34739, 0.0, 2, 'Ratchet - Placeholder')

ON DUPLICATE KEY UPDATE
    `go_name` = VALUES(`go_name`),
    `go_type` = VALUES(`go_type`),
    `spawn_map` = VALUES(`spawn_map`),
    `spawn_x` = VALUES(`spawn_x`),
    `spawn_y` = VALUES(`spawn_y`),
    `spawn_z` = VALUES(`spawn_z`),
    `spawn_o` = VALUES(`spawn_o`),
    `notes` = VALUES(`notes`);

-- Player Tutorial Progress Tracking
CREATE TABLE IF NOT EXISTS `character_tutorial_progress` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY,
    `current_stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Shipwreck, 2=Mainland Hub',
    `current_quest` INT UNSIGNED DEFAULT NULL COMMENT 'Current tutorial quest ID',
    `completed_quests` TEXT DEFAULT NULL COMMENT 'Comma-separated list of completed quest IDs',
    `stage1_complete` BOOLEAN NOT NULL DEFAULT FALSE,
    `tutorial_complete` BOOLEAN NOT NULL DEFAULT FALSE,
    `last_updated` INT UNSIGNED NOT NULL,
    INDEX `idx_complete` (`tutorial_complete`),
    INDEX `idx_stage` (`current_stage`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add new columns if table exists without them
SET @tablename = 'character_tutorial_progress';
SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = 'current_stage') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN `current_stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT ''1=Shipwreck, 2=Mainland Hub''')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

SET @preparedStatement = (SELECT IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = @dbname
        AND TABLE_NAME = @tablename
        AND COLUMN_NAME = 'stage1_complete') > 0,
    'SELECT 1',
    CONCAT('ALTER TABLE ', @tablename, ' ADD COLUMN `stage1_complete` BOOLEAN NOT NULL DEFAULT FALSE')
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

