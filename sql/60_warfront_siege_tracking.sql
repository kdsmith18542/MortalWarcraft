-- ==================================================
-- Project Mortal Warcraft
-- Feature: Warfront & Siege Kill Tracking
-- Description: Tracks kills for killfeed and statistics
-- ==================================================

-- Warfront Kill Tracking
CREATE TABLE IF NOT EXISTS `mortal_warfront_kills` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `warfront_id` INT UNSIGNED NOT NULL COMMENT 'Warfront ID',
  `killer_guid` INT UNSIGNED NOT NULL COMMENT 'Killer player GUID',
  `victim_guid` INT UNSIGNED NOT NULL COMMENT 'Victim player GUID',
  `killed_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_warfront` (`warfront_id`),
  KEY `idx_killer` (`killer_guid`),
  KEY `idx_victim` (`victim_guid`),
  KEY `idx_time` (`killed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Warfront kill tracking for killfeed';

-- Siege Kill Tracking
CREATE TABLE IF NOT EXISTS `mortal_siege_kills` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `killer_guid` INT UNSIGNED NOT NULL COMMENT 'Killer player GUID',
  `victim_guid` INT UNSIGNED NOT NULL COMMENT 'Victim player GUID',
  `killed_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_siege` (`siege_id`),
  KEY `idx_killer` (`killer_guid`),
  KEY `idx_victim` (`victim_guid`),
  KEY `idx_time` (`killed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege kill tracking for killfeed';

-- Add extracted field to warfronts_entries
ALTER TABLE `warfronts_entries` 
ADD COLUMN IF NOT EXISTS `extracted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Did player extract successfully?' AFTER `entered_at`;

-- Siege Objectives Tracking
CREATE TABLE IF NOT EXISTS `mortal_siege_objectives` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `objective_id` INT UNSIGNED NOT NULL COMMENT 'Objective ID',
  `objective_type` TINYINT UNSIGNED NOT NULL COMMENT 'Objective type (1=tower, 2=gate, etc.)',
  `required_stage` TINYINT UNSIGNED NOT NULL COMMENT 'Required siege stage',
  `gameobject_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject entry',
  `gameobject_guid` INT UNSIGNED NOT NULL COMMENT 'GameObject GUID',
  `is_destroyed` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Is objective destroyed?',
  `health` INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'Current health',
  `max_health` INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'Maximum health',
  PRIMARY KEY (`id`),
  KEY `idx_siege` (`siege_id`),
  KEY `idx_objective` (`objective_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege objective tracking';

-- Siege Sigil Tracking
CREATE TABLE IF NOT EXISTS `mortal_siege_sigils` (
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `sigil_guid` INT UNSIGNED NOT NULL COMMENT 'Sigil GameObject GUID',
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sigil state (0=defender, 1=channeling, 2=attacker)',
  `channel_start_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Channel start timestamp',
  `channel_duration` INT UNSIGNED NOT NULL DEFAULT 60 COMMENT 'Required channel duration in seconds',
  `channeling_player_guid` INT UNSIGNED NULL COMMENT 'Player currently channeling',
  PRIMARY KEY (`siege_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege sigil capture tracking';

-- Guild Stronghold Resources (if not exists)
CREATE TABLE IF NOT EXISTS `guild_stronghold_resources` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guild_id` INT UNSIGNED NOT NULL COMMENT 'Guild ID',
  `resource_type` VARCHAR(32) NOT NULL COMMENT 'Resource type (wood, iron, stone)',
  `amount` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Resource amount',
  `source` VARCHAR(64) NOT NULL COMMENT 'Source of resource (warfront_victory, siege, etc.)',
  `added_at` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_guild` (`guild_id`),
  KEY `idx_type` (`resource_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild stronghold resource tracking';

-- Warfront Objectives (for objective tracking)
CREATE TABLE IF NOT EXISTS `mortal_warfront_objectives` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `warfront_id` INT UNSIGNED NOT NULL COMMENT 'Warfront ID',
  `objective_id` INT UNSIGNED NOT NULL COMMENT 'Objective ID',
  `objective_type` TINYINT UNSIGNED NOT NULL COMMENT 'Objective type (1=resource_node, 2=bunker, etc.)',
  `gameobject_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject entry',
  `gameobject_guid` INT UNSIGNED NOT NULL COMMENT 'GameObject GUID',
  `controlling_team` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Controlling team (0=none, 1=attacker, 2=defender)',
  `war_score` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'War score value',
  `resource_throughput` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Resource throughput value',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is objective active?',
  PRIMARY KEY (`id`),
  KEY `idx_warfront` (`warfront_id`),
  KEY `idx_objective` (`objective_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Warfront objective tracking';

-- Guild Sieges (if not exists)
CREATE TABLE IF NOT EXISTS `guild_sieges` (
  `siege_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attacker_guild_id` INT UNSIGNED NOT NULL COMMENT 'Attacking guild ID',
  `defender_guild_id` INT UNSIGNED NOT NULL COMMENT 'Defending guild ID',
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID of stronghold',
  `phase` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Siege phase (1=declaration, 2=preparation, 3=battle, 4=complete)',
  `current_stage` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Current siege stage (1=outer, 2=inner, 3=sigil)',
  `start_time` INT UNSIGNED NOT NULL COMMENT 'Siege start timestamp',
  `end_time` INT UNSIGNED NULL COMMENT 'Siege end timestamp',
  `vulnerability_start` INT UNSIGNED NOT NULL COMMENT 'Vulnerability window start',
  `vulnerability_end` INT UNSIGNED NOT NULL COMMENT 'Vulnerability window end',
  `captured` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Was stronghold captured?',
  PRIMARY KEY (`siege_id`),
  KEY `idx_attacker` (`attacker_guild_id`),
  KEY `idx_defender` (`defender_guild_id`),
  KEY `idx_zone` (`zone_id`),
  KEY `idx_phase` (`phase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild siege tracking';

-- Guild Strongholds (if not exists)
CREATE TABLE IF NOT EXISTS `guild_strongholds` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `guild_id` INT UNSIGNED NOT NULL COMMENT 'Owning guild ID',
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `stronghold_name` VARCHAR(100) NOT NULL COMMENT 'Stronghold name',
  `level` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Stronghold level',
  `claimed_at` INT UNSIGNED NOT NULL COMMENT 'Claim timestamp',
  `last_upgrade` INT UNSIGNED NULL COMMENT 'Last upgrade timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_zone` (`zone_id`),
  KEY `idx_guild` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Guild stronghold ownership';

-- Siege Guild Alliances
CREATE TABLE IF NOT EXISTS `mortal_siege_alliances` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `guild_id` INT UNSIGNED NOT NULL COMMENT 'Allied guild ID',
  `is_attacker` TINYINT(1) NOT NULL COMMENT 'Is guild on attacker side?',
  `joined_at` INT UNSIGNED NOT NULL COMMENT 'Join timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_siege_guild` (`siege_id`, `guild_id`),
  KEY `idx_siege` (`siege_id`),
  KEY `idx_guild` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege guild alliance tracking';

-- Wintergrasp Siege Mapping
CREATE TABLE IF NOT EXISTS `mortal_wintergrasp_sieges` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `battlefield_id` INT UNSIGNED NOT NULL COMMENT 'Wintergrasp battlefield ID',
  `wintergrasp_zone_id` INT UNSIGNED NOT NULL COMMENT 'Wintergrasp zone ID (4197)',
  `created_at` INT UNSIGNED NOT NULL COMMENT 'Creation timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_siege` (`siege_id`),
  KEY `idx_battlefield` (`battlefield_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Wintergrasp siege mapping';

-- Siege Participants (signup tracking)
CREATE TABLE IF NOT EXISTS `mortal_siege_participants` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `guild_id` INT UNSIGNED NULL COMMENT 'Guild ID',
  `is_attacker` TINYINT(1) NOT NULL COMMENT 'Is player on attacker side?',
  `signup_time` INT UNSIGNED NOT NULL COMMENT 'Signup timestamp',
  `is_locked_in` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Is player locked in?',
  `is_in_staging` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Is player in staging area?',
  `is_active` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Is player active in battle?',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_siege_player` (`siege_id`, `player_guid`),
  KEY `idx_siege` (`siege_id`),
  KEY `idx_player` (`player_guid`),
  KEY `idx_guild` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege participant signup tracking';

-- Add lifecycle_stage to guild_sieges if not exists
ALTER TABLE `guild_sieges` 
ADD COLUMN IF NOT EXISTS `lifecycle_stage` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Lifecycle stage (0=announced, 1=signup, 2=lock_in, 3=active, 4=complete)' AFTER `current_stage`;

-- Add cleanup phase and requirements to guild_sieges
ALTER TABLE `guild_sieges`
ADD COLUMN IF NOT EXISTS `cleanup_end_time` INT UNSIGNED NULL COMMENT 'Cleanup phase end timestamp' AFTER `end_time`,
ADD COLUMN IF NOT EXISTS `minimum_level` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Minimum level requirement' AFTER `cleanup_end_time`,
ADD COLUMN IF NOT EXISTS `minimum_standing` INT NOT NULL DEFAULT 0 COMMENT 'Minimum Standing requirement' AFTER `minimum_level`;

-- Siege Staging Areas Configuration
CREATE TABLE IF NOT EXISTS `mortal_siege_staging_areas` (
  `siege_id` INT UNSIGNED NOT NULL COMMENT 'Siege ID',
  `map_id` INT UNSIGNED NOT NULL COMMENT 'Map ID',
  `attacker_x` FLOAT NOT NULL COMMENT 'Attacker staging X',
  `attacker_y` FLOAT NOT NULL COMMENT 'Attacker staging Y',
  `attacker_z` FLOAT NOT NULL COMMENT 'Attacker staging Z',
  `attacker_o` FLOAT NOT NULL COMMENT 'Attacker staging O',
  `defender_x` FLOAT NOT NULL COMMENT 'Defender staging X',
  `defender_y` FLOAT NOT NULL COMMENT 'Defender staging Y',
  `defender_z` FLOAT NOT NULL COMMENT 'Defender staging Z',
  `defender_o` FLOAT NOT NULL COMMENT 'Defender staging O',
  PRIMARY KEY (`siege_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Siege staging area coordinates';

-- Add is_late_join and last_active_time to participants
ALTER TABLE `mortal_siege_participants`
ADD COLUMN IF NOT EXISTS `is_late_join` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Did player join during lock-in phase?' AFTER `is_active`,
ADD COLUMN IF NOT EXISTS `last_active_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last activity timestamp' AFTER `is_late_join`;

