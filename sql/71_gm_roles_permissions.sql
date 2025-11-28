-- ==================================================
-- Project Mortal Warcraft
-- Feature: GM Roles & Permissions
-- Description: Role-based access control for GMs and admins
-- Spec: 14-admin-tools.md
-- ==================================================

-- GM Roles
CREATE TABLE IF NOT EXISTS `mortal_gm_roles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `role_name` VARCHAR(50) NOT NULL,
    `role_level` TINYINT UNSIGNED NOT NULL COMMENT 'Higher number = more permissions',
    `description` TEXT,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_role_name` (`role_name`),
    KEY `idx_role_level` (`role_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- GM Permissions
CREATE TABLE IF NOT EXISTS `mortal_gm_permissions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `permission_key` VARCHAR(100) NOT NULL,
    `permission_name` VARCHAR(100) NOT NULL,
    `category` VARCHAR(50) NOT NULL COMMENT 'Players, Economy, Territory, Events, PvP, Logs',
    `description` TEXT,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_permission_key` (`permission_key`),
    KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Role-Permission mapping
CREATE TABLE IF NOT EXISTS `mortal_gm_role_permissions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `role_id` INT UNSIGNED NOT NULL,
    `permission_id` INT UNSIGNED NOT NULL,
    `granted_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_role_permission` (`role_id`, `permission_id`),
    KEY `idx_role` (`role_id`),
    KEY `idx_permission` (`permission_id`),
    FOREIGN KEY (`role_id`) REFERENCES `mortal_gm_roles` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES `mortal_gm_permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Character-GM Role assignment
CREATE TABLE IF NOT EXISTS `mortal_gm_character_roles` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `guid` INT UNSIGNED NOT NULL,
    `role_id` INT UNSIGNED NOT NULL,
    `granted_by` INT UNSIGNED NOT NULL COMMENT 'GM who granted the role',
    `granted_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `revoked_at` INT UNSIGNED DEFAULT NULL,
    `revoked_by` INT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_guid` (`guid`),
    KEY `idx_role` (`role_id`),
    KEY `idx_active` (`guid`, `revoked_at`),
    FOREIGN KEY (`role_id`) REFERENCES `mortal_gm_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default roles
INSERT INTO `mortal_gm_roles` (`role_name`, `role_level`, `description`) VALUES
('Admin', 100, 'Full permissions, including DB-level controls'),
('Senior GM', 80, 'High-level support and enforcement'),
('GM', 60, 'Player support, minor world adjustments'),
('Event GM', 40, 'Controls for running world events and RP scenarios'),
('Observer', 20, 'Read-only access to logs and map overlays');

-- Insert default permissions
INSERT INTO `mortal_gm_permissions` (`permission_key`, `permission_name`, `category`, `description`) VALUES
-- Player permissions
('player.teleport', 'Teleport Player', 'Players', 'Teleport players to locations'),
('player.summon', 'Summon Player', 'Players', 'Summon players to GM location'),
('player.jail', 'Jail Player', 'Players', 'Temporarily jail a player'),
('player.mute', 'Mute Player', 'Players', 'Mute player chat'),
('player.kick', 'Kick Player', 'Players', 'Kick player from server'),
('player.ban', 'Ban Player', 'Players', 'Ban player (temp/permanent)'),
('player.reset_position', 'Reset Position', 'Players', 'Reset player position'),
('player.clear_corpse', 'Clear Corpse Chest', 'Players', 'Clear player corpse chest'),
('player.view_inventory', 'View Inventory', 'Players', 'View player inventory'),
('player.set_skill', 'Set Skill', 'Players', 'Set player skill values'),
('player.set_notoriety', 'Set Notoriety', 'Players', 'Set player notoriety'),
('player.set_credits', 'Set Credits', 'Players', 'Set Military Credits'),

-- Economy permissions
('economy.view_banks', 'View Regional Banks', 'Economy', 'View regional bank inventories'),
('economy.view_gold', 'View Gold Holders', 'Economy', 'View top gold holders'),
('economy.view_auctions', 'View Auctions', 'Economy', 'View auction listings by region'),
('economy.view_caravans', 'View Caravans', 'Economy', 'View in-flight caravans'),
('economy.freeze_stalls', 'Freeze Market Stalls', 'Economy', 'Temporarily freeze market stalls'),
('economy.adjust_taxes', 'Adjust Taxes', 'Economy', 'Adjust tax multipliers'),

-- Territory permissions
('territory.view_map', 'View Territory Map', 'Territory', 'View stronghold/TCP map'),
('territory.flip_tcp', 'Flip TCP', 'Territory', 'Forcibly flip territory control point'),
('territory.start_siege', 'Start Siege', 'Territory', 'Start/stop sieges'),

-- Event permissions
('event.trigger_midnight', 'Trigger Midnight Horde', 'Events', 'Trigger Midnight Horde event'),
('event.trigger_invasion', 'Trigger Invasion', 'Events', 'Trigger elemental invasions'),
('event.trigger_caravan', 'Trigger Caravan Event', 'Events', 'Trigger merchant caravan events'),
('event.trigger_boss', 'Trigger World Boss', 'Events', 'Trigger world boss spawns'),
('event.schedule', 'Schedule Events', 'Events', 'Schedule recurring events'),

-- PvP & Crime permissions
('pvp.view_killers', 'View Top Killers', 'PvP', 'View top PvP killers'),
('pvp.view_notoriety', 'View Notoriety', 'PvP', 'View notoriety distribution'),
('pvp.view_outlaws', 'View Outlaws', 'PvP', 'View Outlaws & Infamous list'),
('pvp.amnesty', 'Crime Amnesty', 'PvP', 'Apply global crime amnesty'),
('pvp.wipe_bounties', 'Wipe Bounties', 'PvP', 'Wipe all bounties'),

-- Log permissions
('log.view_economy', 'View Economy Logs', 'Logs', 'View economy logs'),
('log.view_pvp', 'View PvP Logs', 'Logs', 'View PvP logs'),
('log.view_crime', 'View Crime Logs', 'Logs', 'View crime logs'),
('log.view_guild', 'View Guild Logs', 'Logs', 'View guild logs'),
('log.view_admin', 'View Admin Logs', 'Logs', 'View admin logs'),

-- Admin permissions
('admin.manage_roles', 'Manage Roles', 'Admin', 'Grant/revoke GM roles'),
('admin.feature_flags', 'Feature Flags', 'Admin', 'Modify feature flags'),
('admin.live_balance', 'Live Balance', 'Admin', 'Modify live balance values'),
('admin.db_access', 'DB Access', 'Admin', 'Direct database access');

-- Grant permissions to roles
-- Admin: All permissions
INSERT INTO `mortal_gm_role_permissions` (`role_id`, `permission_id`)
SELECT 1, id FROM `mortal_gm_permissions`;

-- Senior GM: Most permissions except DB access
INSERT INTO `mortal_gm_role_permissions` (`role_id`, `permission_id`)
SELECT 2, id FROM `mortal_gm_permissions` WHERE permission_key != 'admin.db_access';

-- GM: Player support and basic tools
INSERT INTO `mortal_gm_role_permissions` (`role_id`, `permission_id`)
SELECT 3, id FROM `mortal_gm_permissions` 
WHERE category IN ('Players', 'Logs') 
   OR permission_key IN ('economy.view_banks', 'economy.view_gold', 'pvp.view_killers', 'pvp.view_notoriety');

-- Event GM: Event and territory permissions
INSERT INTO `mortal_gm_role_permissions` (`role_id`, `permission_id`)
SELECT 4, id FROM `mortal_gm_permissions` 
WHERE category IN ('Events', 'Territory', 'Logs');

-- Observer: Read-only log access
INSERT INTO `mortal_gm_role_permissions` (`role_id`, `permission_id`)
SELECT 5, id FROM `mortal_gm_permissions` 
WHERE permission_key LIKE 'log.view_%';

