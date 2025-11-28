-- ==================================================
-- Project Mortal Warcraft: World Simulation Schemas
-- Module: mod-mortal-core
-- Feature: Dynamic World Simulation, Ecosystem AI, Seasons, Weather, Resources
-- Source Spec: docs/specs/12-world-simulation.md
-- ==================================================

-- Table: mortal_ecosystem_spawn_weights
-- Tracks dynamic spawn weights for creatures based on ecosystem state
CREATE TABLE IF NOT EXISTS `mortal_ecosystem_spawn_weights` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'creature_template.entry',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID where creature spawns',
    `base_weight` FLOAT NOT NULL DEFAULT 10.0 COMMENT 'Base spawn weight (default 10)',
    `current_weight` FLOAT NOT NULL DEFAULT 10.0 COMMENT 'Current dynamic weight',
    `min_weight` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Minimum weight (never 0)',
    `max_weight` FLOAT NOT NULL DEFAULT 50.0 COMMENT 'Maximum weight cap',
    `kill_count_24h` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Kills in last 24 hours',
    `last_kill_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Unix timestamp of last kill',
    `player_density_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from player activity',
    `season_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from current season',
    `weather_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from current weather',
    `time_of_day_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from day/night cycle',
    `territory_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Modifier from territory control',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_creature_zone` (`creature_entry`, `zone_id`),
    INDEX `idx_zone_id` (`zone_id`),
    INDEX `idx_creature_entry` (`creature_entry`),
    INDEX `idx_current_weight` (`current_weight`),
    FOREIGN KEY (`creature_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Dynamic spawn weights for ecosystem simulation';

-- Table: mortal_ecosystem_relations
-- Defines predator-prey relationships and ecosystem interactions
CREATE TABLE IF NOT EXISTS `mortal_ecosystem_relations` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `predator_entry` INT UNSIGNED NOT NULL COMMENT 'Predator creature entry',
    `prey_entry` INT UNSIGNED NOT NULL COMMENT 'Prey creature entry',
    `relation_type` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=predator-prey, 2=competitor, 3=symbiotic',
    `hunt_rate` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Rate at which predator hunts prey (0.0-1.0)',
    `population_impact` FLOAT NOT NULL DEFAULT 0.05 COMMENT 'Impact on prey population per hunt',
    `migration_trigger_threshold` FLOAT NOT NULL DEFAULT 0.3 COMMENT 'Predator density that triggers prey migration',
    `zone_id` SMALLINT UNSIGNED NULL COMMENT 'Zone-specific relation (NULL = global)',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=active, 0=disabled',
    `notes` VARCHAR(255) NULL COMMENT 'Description of relationship',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_predator_prey_zone` (`predator_entry`, `prey_entry`, `zone_id`),
    INDEX `idx_predator` (`predator_entry`),
    INDEX `idx_prey` (`prey_entry`),
    INDEX `idx_zone` (`zone_id`),
    FOREIGN KEY (`predator_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE,
    FOREIGN KEY (`prey_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Predator-prey and ecosystem relationships';

-- Table: mortal_territory_world_modifiers
-- Tracks how guild territory control affects world simulation
CREATE TABLE IF NOT EXISTS `mortal_territory_world_modifiers` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `territory_id` INT UNSIGNED NOT NULL COMMENT 'FK to mortal_territory_control_points.id',
    `guild_id` INT UNSIGNED NULL COMMENT 'Guild that controls territory (NULL = neutral)',
    `node_respawn_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Resource node respawn rate (1.0 = normal, 1.5 = 50% faster)',
    `predator_aggression_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Predator aggression (1.0 = normal, 0.5 = 50% less)',
    `seasonal_bonus_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Seasonal bonus stacking (1.0 = normal, 1.2 = 20% bonus)',
    `unique_harvest_zones` TEXT NULL COMMENT 'JSON array of unique harvest zone IDs',
    `guild_only_access` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1=guild members only, 0=public',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_territory` (`territory_id`),
    INDEX `idx_guild` (`guild_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Territory control effects on world simulation';

-- Table: mortal_migration_events
-- Tracks creature migration events between zones
CREATE TABLE IF NOT EXISTS `mortal_migration_events` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `creature_entry` INT UNSIGNED NOT NULL COMMENT 'Migrating creature entry',
    `source_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone migrating from',
    `target_zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone migrating to',
    `migration_type` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1=normal, 2=weather, 3=seasonal, 4=pressure',
    `creature_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Number of creatures migrating',
    `trigger_reason` VARCHAR(255) NULL COMMENT 'Reason for migration',
    `started_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Migration start time',
    `completed_at` INT UNSIGNED NULL COMMENT 'Migration completion time (NULL = in progress)',
    `is_broadcast` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1=broadcast to zone, 0=silent',
    PRIMARY KEY (`id`),
    INDEX `idx_creature` (`creature_entry`),
    INDEX `idx_source_zone` (`source_zone_id`),
    INDEX `idx_target_zone` (`target_zone_id`),
    INDEX `idx_started_at` (`started_at`),
    FOREIGN KEY (`creature_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Creature migration events between zones';

-- Table: mortal_alpha_variants
-- Tracks rare alpha variant spawns and their properties
CREATE TABLE IF NOT EXISTS `mortal_alpha_variants` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `base_creature_entry` INT UNSIGNED NOT NULL COMMENT 'Base creature template',
    `alpha_entry` INT UNSIGNED NOT NULL COMMENT 'Alpha variant creature entry',
    `spawn_chance` FLOAT NOT NULL DEFAULT 0.01 COMMENT 'Base spawn chance (1% default)',
    `pressure_trigger_threshold` FLOAT NOT NULL DEFAULT 0.7 COMMENT 'Ecosystem pressure that increases spawn chance',
    `stat_multiplier` FLOAT NOT NULL DEFAULT 1.5 COMMENT 'Stat multiplier vs base creature',
    `loot_tier_bonus` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Loot tier bonus (M-T1 to M-T5)',
    `zone_id` SMALLINT UNSIGNED NULL COMMENT 'Zone-specific alpha (NULL = global)',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=active, 0=disabled',
    `description` VARCHAR(255) NULL COMMENT 'Alpha variant description',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_base_alpha_zone` (`base_creature_entry`, `alpha_entry`, `zone_id`),
    INDEX `idx_base_creature` (`base_creature_entry`),
    INDEX `idx_alpha_entry` (`alpha_entry`),
    INDEX `idx_zone` (`zone_id`),
    FOREIGN KEY (`base_creature_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE,
    FOREIGN KEY (`alpha_entry`) REFERENCES `creature_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Alpha variant creature definitions';

-- Table: mortal_weather_zones
-- Tracks current weather state per zone
CREATE TABLE IF NOT EXISTS `mortal_weather_zones` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `zone_id` SMALLINT UNSIGNED NOT NULL UNIQUE COMMENT 'Zone ID',
    `current_weather_type` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=clear, 1=rain, 2=storm, 3=fog, 4=snow, 5=heatwave',
    `weather_intensity` FLOAT NOT NULL DEFAULT 0.0 COMMENT 'Weather intensity (0.0-1.0)',
    `started_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Weather start time',
    `duration_sec` INT UNSIGNED NOT NULL DEFAULT 3600 COMMENT 'Weather duration in seconds',
    `transition_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Chance to transition to different weather',
    `season_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Season-based weather frequency',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone` (`zone_id`),
    INDEX `idx_weather_type` (`current_weather_type`),
    INDEX `idx_started_at` (`started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Current weather state per zone';

-- Table: mortal_daynight_cycle
-- Tracks day/night cycle state and modifiers
CREATE TABLE IF NOT EXISTS `mortal_daynight_cycle` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `current_phase` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=dawn, 1=day, 2=dusk, 3=night',
    `phase_start_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Current phase start time (server time)',
    `phase_duration_sec` INT UNSIGNED NOT NULL DEFAULT 3600 COMMENT 'Phase duration in seconds',
    `spawn_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Spawn rate modifier for current phase',
    `creature_behavior_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Creature behavior modifier',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone` (`zone_id`),
    INDEX `idx_phase` (`current_phase`),
    INDEX `idx_phase_start` (`phase_start_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Day/night cycle state per zone';

-- Table: mortal_seasonal_states
-- Tracks seasonal world state and rotations
CREATE TABLE IF NOT EXISTS `mortal_seasonal_states` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `current_season` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=spring, 1=summer, 2=autumn, 3=winter',
    `season_start_date` DATE NOT NULL COMMENT 'Season start date',
    `season_end_date` DATE NOT NULL COMMENT 'Season end date',
    `resource_rotation_multiplier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Resource spawn multiplier',
    `creature_spawn_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Creature spawn modifier',
    `weather_frequency_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Weather frequency modifier',
    `migration_trigger_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Chance to trigger migrations',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_zone_season` (`zone_id`, `current_season`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_season` (`current_season`),
    INDEX `idx_dates` (`season_start_date`, `season_end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Seasonal state per zone';

-- Table: mortal_resource_node_simulation
-- Tracks dynamic resource node spawns and depletion
CREATE TABLE IF NOT EXISTS `mortal_resource_node_simulation` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `node_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject entry for resource node',
    `zone_id` SMALLINT UNSIGNED NOT NULL COMMENT 'Zone ID',
    `spawn_location_x` FLOAT NOT NULL COMMENT 'X coordinate',
    `spawn_location_y` FLOAT NOT NULL COMMENT 'Y coordinate',
    `spawn_location_z` FLOAT NOT NULL COMMENT 'Z coordinate',
    `current_state` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '0=depleted, 1=active, 2=blooming',
    `depletion_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Times harvested',
    `last_harvest_time` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last harvest timestamp',
    `respawn_timer_sec` INT UNSIGNED NOT NULL DEFAULT 300 COMMENT 'Respawn timer in seconds',
    `bloom_chance` FLOAT NOT NULL DEFAULT 0.1 COMMENT 'Chance to bloom (rare state)',
    `territory_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Territory control respawn modifier',
    `season_modifier` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Season-based spawn modifier',
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Node creation time',
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Last update timestamp',
    PRIMARY KEY (`id`),
    INDEX `idx_node_entry` (`node_entry`),
    INDEX `idx_zone` (`zone_id`),
    INDEX `idx_state` (`current_state`),
    INDEX `idx_location` (`zone_id`, `spawn_location_x`, `spawn_location_y`),
    FOREIGN KEY (`node_entry`) REFERENCES `gameobject_template` (`entry`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Dynamic resource node simulation and depletion';

