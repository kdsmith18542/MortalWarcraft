-- ==================================================
-- Project Mortal Warcraft
-- Feature: Feature Flags System
-- Description: Live-tunable switches for balancing without restarts
-- Spec: 14-admin-tools.md
-- ==================================================

-- Feature flags
CREATE TABLE IF NOT EXISTS `mortal_feature_flags` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `flag_key` VARCHAR(100) NOT NULL,
    `flag_name` VARCHAR(100) NOT NULL,
    `flag_value` VARCHAR(255) NOT NULL,
    `flag_type` VARCHAR(50) NOT NULL DEFAULT 'string' COMMENT 'string, int, float, bool',
    `category` VARCHAR(50) NOT NULL COMMENT 'decay, notoriety, bounty, seasonal, resources',
    `description` TEXT,
    `updated_at` INT UNSIGNED NOT NULL DEFAULT 0,
    `updated_by` INT UNSIGNED DEFAULT NULL COMMENT 'GM GUID who last updated',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_flag_key` (`flag_key`),
    KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default feature flags
INSERT INTO `mortal_feature_flags` (`flag_key`, `flag_name`, `flag_value`, `flag_type`, `category`, `description`) VALUES
-- Decay flags
('decay.rate', 'Durability Decay Rate', '0.90', 'float', 'decay', 'Multiplier for max durability reduction on repair (0.90 = 10% reduction)'),
('decay.enabled', 'Durability Decay Enabled', 'true', 'bool', 'decay', 'Enable/disable durability decay system'),

-- Notoriety flags
('notoriety.threshold.suspect', 'Suspect Threshold', '1', 'int', 'notoriety', 'Notoriety level for Suspect tier'),
('notoriety.threshold.criminal', 'Criminal Threshold', '2', 'int', 'notoriety', 'Notoriety level for Criminal tier'),
('notoriety.threshold.outlaw', 'Outlaw Threshold', '10', 'int', 'notoriety', 'Notoriety level for Outlaw tier (default: 10 per spec 02-combat.md)'),
('notoriety.threshold.infamous', 'Infamous Threshold', '20', 'int', 'notoriety', 'Notoriety level for Infamous tier'),
('notoriety.decay.rate', 'Notoriety Decay Rate', '1', 'int', 'notoriety', 'Notoriety points lost per day (default: 1 per day per spec 02-combat.md)'),

-- Bounty flags
('bounty.percentage', 'Bounty Percentage', '0.25', 'float', 'bounty', 'Percentage of victim repair cost added to bounty pot when outlaw kills innocent (default: 25% per spec 02-combat.md)'),
('bounty.payout.multiplier', 'Bounty Payout Multiplier', '1.0', 'float', 'bounty', 'Multiplier for bounty payouts'),
('bounty.minimum', 'Minimum Bounty', '10000', 'int', 'bounty', 'Minimum bounty amount in copper'),

-- Seasonal flags
('seasonal.duration.weeks', 'Season Duration (Weeks)', '6', 'int', 'seasonal', 'Duration of each season in weeks'),
('seasonal.resource.rotation', 'Resource Rotation Enabled', 'true', 'bool', 'seasonal', 'Enable/disable seasonal resource rotation'),

-- Resource flags
('resources.drop_rate.multiplier', 'Resource Drop Rate Multiplier', '1.0', 'float', 'resources', 'Multiplier for resource drop rates'),
('resources.node_respawn.multiplier', 'Node Respawn Multiplier', '1.0', 'float', 'resources', 'Multiplier for node respawn times'),

-- Damage flags
('damage.player.multiplier', 'Player Damage Multiplier', '1.0', 'float', 'damage', 'Global multiplier for player damage'),
('damage.creature.multiplier', 'Creature Damage Multiplier', '1.0', 'float', 'damage', 'Global multiplier for creature damage'),

-- Spawn flags
('spawn.dungeon.density', 'Dungeon Spawn Density', '1.0', 'float', 'spawn', 'Multiplier for dungeon spawn density'),
('spawn.boss.hp.multiplier', 'Boss HP Multiplier', '1.0', 'float', 'spawn', 'Multiplier for boss health points'),

-- Economy / Events
('economy.events.enabled', 'Economy Events Enabled', 'false', 'bool', 'seasonal', 'Enable seasonal economic events'),
('economy.events.multiplier', 'Economy Event Multiplier', '1.0', 'float', 'seasonal', 'Global multiplier applied during economic events'),
('economy.resource.boost', 'Resource Boost Factor', '1.0', 'float', 'seasonal', 'Multiplier for resource yield during events'),
('economy.market.tax', 'Market Tax Multiplier', '1.0', 'float', 'economy', 'Global market stall tax multiplier'),
('siege.vulnerability.window', 'Siege Vulnerability Window (hours)', '2', 'int', 'siege', 'Vulnerability window length in hours'),
('siege.grace.minutes', 'Siege Grace Period (minutes)', '10', 'int', 'siege', 'Grace before vulnerability starts'),
('siege.lock.enabled', 'Siege Lock Enabled', 'false', 'bool', 'siege', 'Enable enforcement of siege vulnerability windows'),
('ui.map_pins.enabled', 'Map Pins Enabled', 'true', 'bool', 'ui', 'Enable sending map pins via addon messages');
