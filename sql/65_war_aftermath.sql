-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Post-War Aftermath & Reconstruction
-- Description: Tracks stronghold damage state and reconstruction progress
-- Spec: 100-mortal-post-war-aftermath-and-reconstruction.md
-- Version: 1.0.0
-- ==================================================

-- Stronghold Aftermath State
-- Tracks damage state and reconstruction metrics for each stronghold
CREATE TABLE IF NOT EXISTS `mortal_stronghold_aftermath` (
  `stronghold_id` INT UNSIGNED NOT NULL,
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=Stable, 2=Under Siege, 3=Recently Sacked, 4=Damaged',
  `sacked_at` BIGINT UNSIGNED DEFAULT NULL COMMENT 'Timestamp when sacked',
  `sacked_by_guild_id` INT UNSIGNED DEFAULT NULL COMMENT 'Guild that sacked it',
  `fortification_repair` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, structural repairs',
  `civilian_recovery` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, civilian aid',
  `garrison_readiness` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, guard reconstitution',
  `sanitation_level` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0-100, plague prevention',
  `war_fatigue_end_time` BIGINT UNSIGNED DEFAULT NULL COMMENT 'When war fatigue expires',
  `last_reconstruction_update` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stronghold_id`),
  INDEX `idx_state` (`state`),
  INDEX `idx_war_fatigue` (`war_fatigue_end_time`),
  CONSTRAINT `chk_fortification` CHECK (`fortification_repair` <= 100),
  CONSTRAINT `chk_civilian` CHECK (`civilian_recovery` <= 100),
  CONSTRAINT `chk_garrison` CHECK (`garrison_readiness` <= 100),
  CONSTRAINT `chk_sanitation` CHECK (`sanitation_level` <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Post-war aftermath state and reconstruction progress';

-- Reconstruction Contract Templates
-- Defines available reconstruction contract types
CREATE TABLE IF NOT EXISTS `mortal_reconstruction_contract_templates` (
  `template_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_key` VARCHAR(64) NOT NULL UNIQUE COMMENT 'e.g., RECON_STRUCTURAL_WALLS',
  `contract_name` VARCHAR(255) NOT NULL,
  `contract_category` TINYINT UNSIGNED NOT NULL COMMENT '1=Structural, 2=Civilian, 3=Garrison, 4=Sanitation',
  `required_item_entry` INT UNSIGNED NOT NULL DEFAULT 0,
  `required_item_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `required_gold` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_standing` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_standing_type` TINYINT UNSIGNED DEFAULT 0 COMMENT '0=Frontier, 1=Civic',
  `fortification_effect` TINYINT NOT NULL DEFAULT 0 COMMENT 'Points added to fortification_repair',
  `civilian_effect` TINYINT NOT NULL DEFAULT 0 COMMENT 'Points added to civilian_recovery',
  `garrison_effect` TINYINT NOT NULL DEFAULT 0 COMMENT 'Points added to garrison_readiness',
  `sanitation_effect` TINYINT NOT NULL DEFAULT 0 COMMENT 'Points added to sanitation_level',
  `board_types` VARCHAR(255) COMMENT 'Comma-separated: stronghold,frontier,civic',
  `duration_hours` INT UNSIGNED NOT NULL DEFAULT 24,
  `is_active` TINYINT UNSIGNED NOT NULL DEFAULT 1,
  `weight` INT UNSIGNED NOT NULL DEFAULT 10,
  PRIMARY KEY (`template_id`),
  INDEX `idx_category` (`contract_category`),
  INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Templates for reconstruction contracts';

-- Active Reconstruction Contracts
-- Instances of reconstruction contracts
CREATE TABLE IF NOT EXISTS `mortal_reconstruction_contracts` (
  `contract_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stronghold_id` INT UNSIGNED NOT NULL,
  `template_id` INT UNSIGNED NOT NULL,
  `board_id` INT UNSIGNED NOT NULL COMMENT 'Task board gameobject guid',
  `zone_id` INT UNSIGNED NOT NULL,
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Available, 1=Taken, 2=Completed, 3=Expired',
  `assigned_to` INT UNSIGNED DEFAULT NULL COMMENT 'Player GUID',
  `created_at` BIGINT UNSIGNED NOT NULL,
  `expires_at` BIGINT UNSIGNED NOT NULL,
  `completed_at` BIGINT UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`contract_id`),
  INDEX `idx_stronghold` (`stronghold_id`),
  INDEX `idx_template` (`template_id`),
  INDEX `idx_state` (`state`),
  INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Active reconstruction contract instances';

-- Reconstruction Contributions
-- Log of completed reconstruction contracts
CREATE TABLE IF NOT EXISTS `mortal_reconstruction_contributions` (
  `contribution_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stronghold_id` INT UNSIGNED NOT NULL,
  `contract_id` BIGINT UNSIGNED NOT NULL,
  `player_guid` INT UNSIGNED NOT NULL,
  `guild_id` INT UNSIGNED DEFAULT NULL,
  `fortification_change` TINYINT NOT NULL DEFAULT 0,
  `civilian_change` TINYINT NOT NULL DEFAULT 0,
  `garrison_change` TINYINT NOT NULL DEFAULT 0,
  `sanitation_change` TINYINT NOT NULL DEFAULT 0,
  `reward_gold` INT UNSIGNED NOT NULL DEFAULT 0,
  `reward_standing` INT UNSIGNED NOT NULL DEFAULT 0,
  `completed_at` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`contribution_id`),
  INDEX `idx_stronghold` (`stronghold_id`),
  INDEX `idx_player` (`player_guid`),
  INDEX `idx_guild` (`guild_id`),
  INDEX `idx_completed` (`completed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Log of reconstruction contributions';

-- Insert default reconstruction contract templates
INSERT IGNORE INTO `mortal_reconstruction_contract_templates` 
(`contract_key`, `contract_name`, `contract_category`, `required_item_entry`, `required_item_count`, 
 `required_gold`, `reward_gold`, `reward_standing`, `reward_standing_type`, 
 `fortification_effect`, `civilian_effect`, `garrison_effect`, `sanitation_effect`, 
 `board_types`, `duration_hours`, `weight`) VALUES
-- Structural Repairs
('RECON_STRUCTURAL_WALLS', 'Rebuild the Walls', 1, 0, 0, 100000, 50000, 10, 1, 5, 0, 0, 0, 'stronghold,frontier', 48, 15),
('RECON_STRUCTURAL_GATE', 'Repair the Gate', 1, 0, 0, 80000, 40000, 8, 1, 4, 0, 0, 0, 'stronghold,frontier', 48, 15),
('RECON_STRUCTURAL_TOWERS', 'Raise New Towers', 1, 0, 0, 120000, 60000, 12, 1, 6, 0, 0, 0, 'stronghold,frontier', 48, 10),
-- Civilian Recovery
('RECON_CIVILIAN_AID', 'Aid the Refugees', 2, 0, 0, 50000, 30000, 15, 1, 0, 5, 0, 0, 'stronghold,civic', 36, 20),
('RECON_CIVILIAN_PROVISION', 'Provision the Homeless', 2, 0, 0, 40000, 25000, 12, 1, 0, 4, 0, 0, 'stronghold,civic', 36, 20),
-- Garrison Reconstitution
('RECON_GARRISON_RECRUIT', 'Recruit the New Guard', 3, 0, 0, 60000, 35000, 10, 0, 0, 0, 5, 0, 'stronghold,frontier', 24, 15),
('RECON_GARRISON_ARM', 'Arm the Watch', 3, 0, 0, 70000, 40000, 12, 0, 0, 0, 6, 0, 'stronghold,frontier', 24, 15),
-- Sanitation & Plague Prevention
('RECON_SANITATION_BURN', 'Burn the Corpses', 4, 0, 0, 30000, 20000, 8, 1, 0, 0, 0, 5, 'stronghold,frontier', 12, 20),
('RECON_SANITATION_CLEANSE', 'Cleanse the Water', 4, 0, 0, 40000, 25000, 10, 1, 0, 0, 0, 6, 'stronghold,frontier', 12, 15);

