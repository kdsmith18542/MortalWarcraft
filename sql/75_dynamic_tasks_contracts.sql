-- ==================================================
-- Mortal Warcraft – Dynamic Tasks & Contracts 2.0
-- Spec 76: Dynamic Tasks and Contracts 2.0
-- Target DB: world
-- ==================================================

-- Task Templates: Define reusable task archetypes
CREATE TABLE IF NOT EXISTS `mortal_task_template` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `task_key` VARCHAR(64) UNIQUE NOT NULL,        -- 'TASK_CULL_WOLVES_T1'
    `category` TINYINT NOT NULL,                   -- 1=kill, 2=gather, 3=deliver, 4=repair, 5=escort, 6=investigate, 7=fishing, 8=firstaid
    `zone_id` INT NOT NULL,
    `min_zone_tier` TINYINT NOT NULL DEFAULT 1,    -- 1=green, 2=yellow, 3=red
    `max_zone_tier` TINYINT NOT NULL DEFAULT 3,
    `min_level` INT NOT NULL DEFAULT 1,            -- dynamic-level suggestion
    `max_level` INT NOT NULL DEFAULT 25,
    `base_reward_gold` INT NOT NULL,
    `base_reward_xp` INT NOT NULL DEFAULT 0,       -- XP disabled in Mortal, but kept for compatibility
    `base_reward_material_value` INT NOT NULL,     -- abstract material reward budget
    `faction_mask` INT NOT NULL DEFAULT 0,         -- bitmask: 1=Civic, 2=Frontier, 4=Cartel, 8=Atlas
    `is_repeatable` TINYINT NOT NULL DEFAULT 1,
    `weight` INT NOT NULL DEFAULT 10,               -- selection weight for generator
    `objective_type` INT NOT NULL DEFAULT 0,       -- creature entry, item entry, gameobject entry, etc.
    `objective_count` INT NOT NULL DEFAULT 1,
    `objective_text` VARCHAR(255) DEFAULT NULL,
    `description` TEXT DEFAULT NULL,
    `title` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Contract Templates: Define reusable contract archetypes
CREATE TABLE IF NOT EXISTS `mortal_contract_template` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `contract_key` VARCHAR(64) UNIQUE NOT NULL,    -- 'CONTRACT_CARAVAN_T2'
    `type` TINYINT NOT NULL,                       -- 1=caravan, 2=stronghold, 3=invasion, 4=warfront, 5=siege_prep
    `zone_id` INT NOT NULL,
    `difficulty` INT NOT NULL DEFAULT 3,           -- 1-5 scale
    `group_size_min` INT NOT NULL DEFAULT 1,
    `group_size_max` INT NOT NULL DEFAULT 5,
    `duration_sec` INT NOT NULL,                    -- soft time expectation
    `base_reward_gold` INT NOT NULL,
    `base_reward_material_value` INT NOT NULL,
    `base_reward_token_value` INT NOT NULL DEFAULT 0, -- tokens (Military Credits, etc.)
    `faction_mask` INT NOT NULL DEFAULT 0,
    `is_repeatable` TINYINT NOT NULL DEFAULT 1,
    `weight` INT NOT NULL DEFAULT 5,
    `description` TEXT DEFAULT NULL,
    `title` VARCHAR(255) DEFAULT NULL,
    `objectives_json` TEXT DEFAULT NULL            -- JSON array of objective steps
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Task Instances: Active tasks available on boards
CREATE TABLE IF NOT EXISTS `mortal_task_instance` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `template_id` INT NOT NULL,                    -- FK to mortal_task_template.id
    `zone_id` INT NOT NULL,
    `board_id` INT NOT NULL,                       -- gameobject entry or creature entry for board
    `state` TINYINT NOT NULL DEFAULT 0,            -- 0=available, 1=taken, 2=completed, 3=expired
    `assigned_to` BIGINT NULL,                     -- player guid
    `created_at` INT NOT NULL,
    `expires_at` INT NULL,                         -- NULL = no expiration
    `scaled_reward_gold` INT NOT NULL DEFAULT 0,   -- calculated reward after scaling
    `scaled_reward_material_value` INT NOT NULL DEFAULT 0,
    INDEX `idx_template` (`template_id`),
    INDEX `idx_board` (`board_id`),
    INDEX `idx_state` (`state`),
    INDEX `idx_assigned` (`assigned_to`),
    FOREIGN KEY (`template_id`) REFERENCES `mortal_task_template`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Contract Instances: Active contracts available on boards
CREATE TABLE IF NOT EXISTS `mortal_contract_instance` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `template_id` INT NOT NULL,                    -- FK to mortal_contract_template.id
    `zone_id` INT NOT NULL,
    `board_id` INT NOT NULL,
    `state` TINYINT NOT NULL DEFAULT 0,            -- 0=available, 1=taken, 2=completed, 3=failed, 4=expired
    `assigned_to` BIGINT NULL,                     -- player guid or guild id
    `is_guild_contract` TINYINT NOT NULL DEFAULT 0,
    `guild_id` INT NULL,                           -- if is_guild_contract = 1
    `created_at` INT NOT NULL,
    `expires_at` INT NULL,
    `scaled_reward_gold` INT NOT NULL DEFAULT 0,
    `scaled_reward_material_value` INT NOT NULL DEFAULT 0,
    `scaled_reward_token_value` INT NOT NULL DEFAULT 0,
    INDEX `idx_template` (`template_id`),
    INDEX `idx_board` (`board_id`),
    INDEX `idx_state` (`state`),
    INDEX `idx_assigned` (`assigned_to`),
    INDEX `idx_guild` (`guild_id`),
    FOREIGN KEY (`template_id`) REFERENCES `mortal_contract_template`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Regional Demand State: Drives dynamic task/contract generation
CREATE TABLE IF NOT EXISTS `mortal_region_demand_state` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `zone_id` INT UNIQUE NOT NULL,
    `resource_shortage_score` FLOAT NOT NULL DEFAULT 0.0,   -- mats needed (0.0-1.0)
    `security_risk_score` FLOAT NOT NULL DEFAULT 0.0,       -- mobs/invasion risk (0.0-1.0)
    `trade_flow_score` FLOAT NOT NULL DEFAULT 0.0,          -- caravans & market activity (0.0-1.0)
    `population_activity_score` FLOAT NOT NULL DEFAULT 0.0,  -- players active recently (0.0-1.0)
    `updated_at` INT NOT NULL,
    INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player Task Progress: Track active task progress
CREATE TABLE IF NOT EXISTS `mortal_player_task_progress` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `player_guid` BIGINT NOT NULL,
    `task_instance_id` BIGINT NOT NULL,            -- FK to mortal_task_instance.id
    `progress` INT NOT NULL DEFAULT 0,             -- current progress toward objective
    `objective_count` INT NOT NULL DEFAULT 1,      -- target count
    `accepted_at` INT NOT NULL,
    INDEX `idx_player` (`player_guid`),
    INDEX `idx_task` (`task_instance_id`),
    FOREIGN KEY (`task_instance_id`) REFERENCES `mortal_task_instance`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Player Contract Progress: Track active contract progress
CREATE TABLE IF NOT EXISTS `mortal_player_contract_progress` (
    `id` BIGINT PRIMARY KEY AUTO_INCREMENT,
    `player_guid` BIGINT NOT NULL,
    `contract_instance_id` BIGINT NOT NULL,        -- FK to mortal_contract_instance.id
    `current_step` INT NOT NULL DEFAULT 0,         -- current objective step
    `total_steps` INT NOT NULL DEFAULT 1,
    `progress_json` TEXT DEFAULT NULL,             -- JSON object tracking step progress
    `accepted_at` INT NOT NULL,
    INDEX `idx_player` (`player_guid`),
    INDEX `idx_contract` (`contract_instance_id`),
    FOREIGN KEY (`contract_instance_id`) REFERENCES `mortal_contract_instance`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Task Board Locations: Define where task boards exist
CREATE TABLE IF NOT EXISTS `mortal_task_board` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `board_key` VARCHAR(64) UNIQUE NOT NULL,       -- 'BOARD_PORT_MERIDIAN', 'BOARD_GREYCRAG'
    `zone_id` INT NOT NULL,
    `gameobject_entry` INT NULL,                   -- gameobject entry for board
    `creature_entry` INT NULL,                     -- creature entry for board NPC
    `max_tasks` INT NOT NULL DEFAULT 10,          -- max task instances on board
    `max_contracts` INT NOT NULL DEFAULT 5,       -- max contract instances on board
    `refresh_interval_sec` INT NOT NULL DEFAULT 1800, -- 30 minutes default
    `last_refresh` INT NOT NULL DEFAULT 0,
    `faction_filter` INT NOT NULL DEFAULT 0,       -- bitmask for faction filtering
    INDEX `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Example task template entries (placeholders - adjust as needed)
INSERT INTO `mortal_task_template` (`task_key`, `category`, `zone_id`, `min_zone_tier`, `max_zone_tier`, `min_level`, `max_level`, `base_reward_gold`, `base_reward_material_value`, `faction_mask`, `weight`, `objective_type`, `objective_count`, `title`, `description`) VALUES
('TASK_CULL_WOLVES_T1', 1, 1519, 1, 2, 1, 10, 50, 20, 0, 10, 0, 10, 'Cull the Wolves', 'Kill 10 wolves near the road to reduce bandit activity.'),
('TASK_GATHER_HERBS_T1', 2, 1519, 1, 2, 1, 10, 30, 30, 0, 10, 0, 12, 'Herb Collection', 'Collect 12 herbs for the local apothecary.'),
('TASK_DELIVER_PACKAGE_T1', 3, 1519, 1, 1, 1, 10, 40, 10, 0, 8, 0, 1, 'Package Delivery', 'Deliver a package from Port Meridian to a nearby outpost.');

-- Example contract template entries (placeholders)
INSERT INTO `mortal_contract_template` (`contract_key`, `type`, `zone_id`, `difficulty`, `group_size_min`, `group_size_max`, `duration_sec`, `base_reward_gold`, `base_reward_material_value`, `base_reward_token_value`, `faction_mask`, `weight`, `title`, `description`) VALUES
('CONTRACT_CARAVAN_T1', 1, 1519, 2, 2, 5, 1800, 200, 50, 0, 0, 5, 'Caravan Escort', 'Escort a caravan through Yellow Zone territory.'),
('CONTRACT_STRONGHOLD_DEFENSE_T1', 2, 1519, 3, 3, 10, 3600, 500, 100, 10, 0, 3, 'Stronghold Defense', 'Defend a Stronghold during a vulnerability window.');

-- Initialize region demand state for common zones (placeholders)
INSERT INTO `mortal_region_demand_state` (`zone_id`, `resource_shortage_score`, `security_risk_score`, `trade_flow_score`, `population_activity_score`, `updated_at`) VALUES
(1519, 0.5, 0.3, 0.4, 0.5, UNIX_TIMESTAMP()),
(1637, 0.4, 0.5, 0.3, 0.4, UNIX_TIMESTAMP());

-- Example task board entries (placeholders)
INSERT INTO `mortal_task_board` (`board_key`, `zone_id`, `gameobject_entry`, `creature_entry`, `max_tasks`, `max_contracts`, `refresh_interval_sec`, `faction_filter`) VALUES
('BOARD_PORT_MERIDIAN', 1519, NULL, 61000, 15, 8, 1800, 0),
('BOARD_GREYCRAG', 1637, NULL, 61005, 12, 6, 1800, 0);

