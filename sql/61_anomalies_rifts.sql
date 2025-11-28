-- ==================================================
-- Project Mortal Warcraft
-- Feature: Anomalies & Rifts System
-- Description: Exploration layer - anomalies, rifts, and zone invasions
-- ==================================================

-- Anomaly Signatures
CREATE TABLE IF NOT EXISTS `mortal_anomaly_signatures` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `anomaly_id` INT UNSIGNED NOT NULL COMMENT 'Anomaly ID',
  `type` TINYINT UNSIGNED NOT NULL COMMENT 'Anomaly type (1=micro_dungeon, 2=shrine_echo, 3=cartel_cache, 4=ether_tear)',
  `tier` TINYINT UNSIGNED NOT NULL COMMENT 'Difficulty tier (1-5)',
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `x` FLOAT NOT NULL COMMENT 'X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Z coordinate',
  `o` FLOAT NOT NULL COMMENT 'Orientation',
  `spawn_time` INT UNSIGNED NOT NULL COMMENT 'Spawn timestamp',
  `time_to_live` INT UNSIGNED NOT NULL COMMENT 'Time to live in seconds',
  `state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'State (0=hidden, 1=discovered, 2=activated, 3=complete, 4=expired)',
  `signature_guid` INT UNSIGNED NULL COMMENT 'GameObject GUID for signature',
  `activated_guid` INT UNSIGNED NULL COMMENT 'GameObject GUID after activation',
  `is_visible` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Is visible to others?',
  `completed_at` INT UNSIGNED NULL COMMENT 'Completion timestamp',
  `despawned_at` INT UNSIGNED NULL COMMENT 'Despawn timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_anomaly` (`anomaly_id`),
  KEY `idx_zone` (`zone_id`),
  KEY `idx_type` (`type`),
  KEY `idx_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Anomaly signature tracking';

-- Anomaly Discoveries
CREATE TABLE IF NOT EXISTS `mortal_anomaly_discoveries` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `anomaly_id` INT UNSIGNED NOT NULL COMMENT 'Anomaly ID',
  `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `discovered_at` INT UNSIGNED NOT NULL COMMENT 'Discovery timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_anomaly` (`anomaly_id`),
  KEY `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Anomaly discovery tracking';

-- Anomaly Completions
CREATE TABLE IF NOT EXISTS `mortal_anomaly_completions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `anomaly_id` INT UNSIGNED NOT NULL COMMENT 'Anomaly ID',
  `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player GUID',
  `completed_at` INT UNSIGNED NOT NULL COMMENT 'Completion timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_anomaly` (`anomaly_id`),
  KEY `idx_player` (`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Anomaly completion tracking';

-- Zone Instability
CREATE TABLE IF NOT EXISTS `mortal_zone_instability` (
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `instability_score` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Instability score (0-100)',
  `current_state` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Zone state (0=normal, 1=invasion, 2=under_control)',
  `last_update` INT UNSIGNED NOT NULL COMMENT 'Last update timestamp',
  `invasion_start_time` INT UNSIGNED NULL COMMENT 'Invasion start timestamp',
  `invasion_end_time` INT UNSIGNED NULL COMMENT 'Invasion end timestamp',
  PRIMARY KEY (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Zone instability tracking';

-- Rift Anchors
CREATE TABLE IF NOT EXISTS `mortal_rift_anchors` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `anchor_id` INT UNSIGNED NOT NULL COMMENT 'Anchor ID',
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `x` FLOAT NOT NULL COMMENT 'X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Z coordinate',
  `o` FLOAT NOT NULL COMMENT 'Orientation',
  `spawn_time` INT UNSIGNED NOT NULL COMMENT 'Spawn timestamp',
  `next_spawn_time` INT UNSIGNED NOT NULL COMMENT 'Next creature spawn timestamp',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is anchor active?',
  `despawned_at` INT UNSIGNED NULL COMMENT 'Despawn timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_anchor` (`anchor_id`),
  KEY `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Rift anchor tracking';

-- Invasion Points
CREATE TABLE IF NOT EXISTS `mortal_invasion_points` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `point_id` INT UNSIGNED NOT NULL COMMENT 'Invasion point ID',
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `x` FLOAT NOT NULL COMMENT 'X coordinate',
  `y` FLOAT NOT NULL COMMENT 'Y coordinate',
  `z` FLOAT NOT NULL COMMENT 'Z coordinate',
  `type` TINYINT UNSIGNED NOT NULL COMMENT 'Rift type (1=minor, 2=major, 3=critical)',
  `spawn_time` INT UNSIGNED NOT NULL COMMENT 'Spawn timestamp',
  `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Is point active?',
  `despawned_at` INT UNSIGNED NULL COMMENT 'Despawn timestamp',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_point` (`point_id`),
  KEY `idx_zone` (`zone_id`),
  KEY `idx_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Invasion point tracking';

-- Rift Closures (tracking)
CREATE TABLE IF NOT EXISTS `mortal_rift_closures` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `anchor_id` INT UNSIGNED NULL COMMENT 'Rift anchor ID (if closing anchor)',
  `point_id` INT UNSIGNED NULL COMMENT 'Invasion point ID (if closing point)',
  `player_guid` INT UNSIGNED NOT NULL COMMENT 'Player who closed it',
  `zone_id` INT UNSIGNED NOT NULL COMMENT 'Zone ID',
  `closed_at` INT UNSIGNED NOT NULL COMMENT 'Closure timestamp',
  PRIMARY KEY (`id`),
  KEY `idx_anchor` (`anchor_id`),
  KEY `idx_point` (`point_id`),
  KEY `idx_player` (`player_guid`),
  KEY `idx_zone` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Rift closure tracking';

