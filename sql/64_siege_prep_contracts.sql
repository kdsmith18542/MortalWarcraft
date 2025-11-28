-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Siege Preparation Contracts & Stats
-- Description: Tracks siege preparedness metrics and contract templates
-- Spec: 98-mortal-siege-prep-contracts.md
-- Version: 1.0.0
-- ==================================================

-- Siege Preparation Stats
-- Tracks preparedness metrics for each stronghold siege
CREATE TABLE IF NOT EXISTS `mortal_siege_prep_stats` (
  `siege_id` INT UNSIGNED NOT NULL,
  `stronghold_id` INT UNSIGNED NOT NULL,
  `defense_preparedness` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, affects wall HP, tower damage',
  `offense_preparedness` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, affects siege vehicles, buffs',
  `intel_level_def` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, affects Atlas intel, flank routes',
  `intel_level_off` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, affects Atlas intel, flank routes',
  `supply_stockpile_def` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total resources collected for defenders',
  `supply_stockpile_off` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Total resources collected for attackers',
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`siege_id`),
  INDEX `idx_stronghold` (`stronghold_id`),
  CONSTRAINT `chk_defense_prep` CHECK (`defense_preparedness` <= 100),
  CONSTRAINT `chk_offense_prep` CHECK (`offense_preparedness` <= 100),
  CONSTRAINT `chk_intel_def` CHECK (`intel_level_def` <= 100),
  CONSTRAINT `chk_intel_off` CHECK (`intel_level_off` <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege preparation metrics that affect battle outcomes';

-- Siege Prep Contract Templates
-- Defines available contract types for siege preparation
CREATE TABLE IF NOT EXISTS `mortal_siege_prep_contract_templates` (
  `template_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_key` VARCHAR(64) NOT NULL UNIQUE COMMENT 'e.g., SIEGE_PREP_STONE_WALLS',
  `contract_name` VARCHAR(255) NOT NULL,
  `contract_category` TINYINT UNSIGNED NOT NULL COMMENT '1=Supply, 2=Armament, 3=Intel, 4=Sabotage',
  `side` TINYINT UNSIGNED NOT NULL COMMENT '0=Defender, 1=Attacker, 2=Both',
  `required_item_entry` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Item to deliver (0 = no item, use objective)',
  `required_item_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `objective_type` VARCHAR(50) COMMENT 'kill, gather, deliver, scout, sabotage',
  `objective_target` INT UNSIGNED DEFAULT 0 COMMENT 'Creature/GameObject entry or zone ID',
  `objective_count` INT UNSIGNED DEFAULT 0,
  `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_standing` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Frontier or Civic Standing',
  `reward_standing_type` TINYINT UNSIGNED DEFAULT 0 COMMENT '0=Frontier, 1=Civic',
  `preparedness_effect` TINYINT NOT NULL DEFAULT 0 COMMENT 'Points added to preparedness (-100 to +100)',
  `intel_effect` TINYINT NOT NULL DEFAULT 0 COMMENT 'Points added to intel level (-100 to +100)',
  `supply_effect` INT NOT NULL DEFAULT 0 COMMENT 'Points added to supply stockpile',
  `spawn_phase` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=ANNOUNCED, 2=IMMINENT, 3=STARTED',
  `board_types` VARCHAR(255) COMMENT 'Comma-separated: stronghold,frontier,civic',
  `zone_range` INT UNSIGNED DEFAULT 0 COMMENT 'Max zone distance from stronghold (0 = any)',
  `duration_hours` INT UNSIGNED NOT NULL DEFAULT 24 COMMENT 'Contract duration in hours',
  `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `weight` INT UNSIGNED NOT NULL DEFAULT 10 COMMENT 'Selection weight for generation',
  PRIMARY KEY (`template_id`),
  INDEX `idx_category` (`contract_category`),
  INDEX `idx_side` (`side`),
  INDEX `idx_spawn_phase` (`spawn_phase`),
  INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Templates for siege preparation contracts';

-- Active Siege Prep Contracts
-- Instances of contracts spawned for specific sieges
CREATE TABLE IF NOT EXISTS `mortal_siege_prep_contracts` (
  `contract_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL,
  `template_id` INT UNSIGNED NOT NULL,
  `board_id` INT UNSIGNED NOT NULL COMMENT 'Task board gameobject guid',
  `zone_id` INT UNSIGNED NOT NULL,
  `side` TINYINT UNSIGNED NOT NULL COMMENT '0=Defender, 1=Attacker',
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Available, 1=Taken, 2=Completed, 3=Expired',
  `assigned_to` INT UNSIGNED DEFAULT NULL COMMENT 'Player GUID',
  `created_at` BIGINT UNSIGNED NOT NULL,
  `expires_at` BIGINT UNSIGNED NOT NULL,
  `completed_at` BIGINT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`contract_id`),
  INDEX `idx_siege` (`siege_id`),
  INDEX `idx_template` (`template_id`),
  INDEX `idx_board` (`board_id`),
  INDEX `idx_state` (`state`),
  INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Active siege preparation contract instances';

-- Siege Prep Contract Progress
-- Tracks player progress on active contracts
CREATE TABLE IF NOT EXISTS `mortal_siege_prep_contract_progress` (
  `progress_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` BIGINT UNSIGNED NOT NULL,
  `player_guid` INT UNSIGNED NOT NULL,
  `current_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `target_count` INT UNSIGNED NOT NULL,
  `items_delivered` TEXT COMMENT 'JSON array of item entries delivered',
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`progress_id`),
  UNIQUE KEY `unique_contract_player` (`contract_id`, `player_guid`),
  INDEX `idx_contract` (`contract_id`),
  INDEX `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player progress on siege prep contracts';

-- Siege Prep Contributions
-- Log of completed contracts and their effects
CREATE TABLE IF NOT EXISTS `mortal_siege_prep_contributions` (
  `contribution_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL,
  `contract_id` BIGINT UNSIGNED NOT NULL,
  `player_guid` INT UNSIGNED NOT NULL,
  `guild_id` INT UNSIGNED DEFAULT NULL,
  `side` TINYINT UNSIGNED NOT NULL COMMENT '0=Defender, 1=Attacker',
  `preparedness_change` TINYINT NOT NULL DEFAULT 0,
  `intel_change` TINYINT NOT NULL DEFAULT 0,
  `supply_change` INT NOT NULL DEFAULT 0,
  `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_standing` INT UNSIGNED NOT NULL DEFAULT 0,
  `completed_at` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`contribution_id`),
  INDEX `idx_siege` (`siege_id`),
  INDEX `idx_player` (`player_guid`),
  INDEX `idx_guild` (`guild_id`),
  INDEX `idx_completed` (`completed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Log of completed siege prep contributions';

-- Add siege prep stats columns to guild_strongholds if they don't exist
SET @db_name = DATABASE();
SET @table_exists = (
    SELECT COUNT(*) 
    FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA = @db_name 
    AND TABLE_NAME = 'guild_strongholds'
);

SET @column_exists = (
    SELECT COUNT(*) 
    FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = @db_name 
    AND TABLE_NAME = 'guild_strongholds' 
    AND COLUMN_NAME = 'defense_preparedness'
);

SET @sql = IF(@table_exists > 0 AND @column_exists = 0,
    'ALTER TABLE `guild_strongholds` 
     ADD COLUMN `defense_preparedness` TINYINT UNSIGNED DEFAULT 50 COMMENT ''Base defense preparedness (0-100)'' AFTER `upgrade_level`,
     ADD COLUMN `last_prep_update` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `defense_preparedness`',
    'SELECT ''Columns already exist or guild_strongholds table not found'' AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Insert default contract templates
INSERT IGNORE INTO `mortal_siege_prep_contract_templates` 
(`contract_key`, `contract_name`, `contract_category`, `side`, `required_item_entry`, `required_item_count`, 
 `reward_gold`, `reward_standing`, `preparedness_effect`, `spawn_phase`, `board_types`, `duration_hours`, `weight`) VALUES
-- Supply & Construction (Defender)
('SIEGE_PREP_STONE_WALLS', 'Stone for the Walls', 1, 0, 0, 0, 50000, 10, 2, 1, 'stronghold,frontier', 48, 15),
('SIEGE_PREP_TIMBER_PLATFORMS', 'Timber for Siege Platforms', 1, 0, 0, 0, 40000, 8, 1, 1, 'stronghold,frontier', 48, 15),
('SIEGE_PREP_RATIONS', 'Rations for the Garrison', 1, 0, 0, 0, 30000, 5, 1, 1, 'stronghold,frontier', 36, 20),
-- Supply & Construction (Attacker)
('SIEGE_PREP_ATTACKER_STONE', 'Stone for War Camp', 1, 1, 0, 0, 50000, 10, 2, 1, 'frontier', 48, 15),
('SIEGE_PREP_ATTACKER_TIMBER', 'Timber for Siege Engines', 1, 1, 0, 0, 40000, 8, 1, 1, 'frontier', 48, 15),
-- Armament & Crafting
('SIEGE_PREP_BALLISTA_BOLTS', 'Forge Order: Ballista Bolts', 2, 2, 0, 0, 60000, 12, 1, 1, 'stronghold,frontier', 24, 10),
('SIEGE_PREP_ARMOR_KITS', 'Armor Reinforcement Kits', 2, 2, 0, 0, 70000, 15, 1, 1, 'stronghold,frontier', 24, 10),
('SIEGE_PREP_ALCHEMICAL_WARDS', 'Alchemical Wards', 2, 2, 0, 0, 80000, 18, 1, 1, 'stronghold,frontier', 24, 8),
-- Intel & Scouting
('SIEGE_PREP_SCOUT_RALLY', 'Scout Enemy Rally Points', 3, 2, 0, 0, 100000, 20, 0, 2, 'frontier', 12, 5),
('SIEGE_PREP_MAP_TERRAIN', 'Map the Terrain', 3, 2, 0, 0, 120000, 25, 0, 2, 'frontier', 12, 5),
('SIEGE_PREP_INTERCEPT_COURIER', 'Intercept Enemy Couriers', 3, 2, 0, 0, 150000, 30, 0, 2, 'frontier', 6, 3),
-- Sabotage & Special Ops
('SIEGE_PREP_SABOTAGE_WORKSHOP', 'Sabotage the Workshops', 4, 2, 0, 0, 200000, 40, -5, 2, 'frontier', 6, 2),
('SIEGE_PREP_POISON_STOREHOUSE', 'Poison the Storehouses', 4, 2, 0, 0, 180000, 35, -3, 2, 'frontier', 6, 2),
('SIEGE_PREP_ASSASSINATE_CAPTAIN', 'Assassinate Enemy Captains', 4, 2, 0, 0, 250000, 50, -8, 1, 'frontier', 24, 1);

