-- ==================================================
-- Project Mortal Warcraft
-- Feature: Guild Instancing (Private Halls)
-- Description: Guilds can purchase private instances
-- ==================================================

-- Guild Hall Configuration Table
CREATE TABLE IF NOT EXISTS `guild_halls` (
    `guild_id` INT UNSIGNED NOT NULL PRIMARY KEY,
    `guild_name` VARCHAR(100) NOT NULL,
    `hall_key_item` INT UNSIGNED NOT NULL DEFAULT 90050 COMMENT 'Hall Key item ID',
    `base_map_id` INT UNSIGNED NOT NULL COMMENT 'Base map (e.g., Shadowfang Keep = 33)',
    `instance_id` INT UNSIGNED NOT NULL COMMENT 'Private instance ID',
    `purchase_time` INT UNSIGNED NOT NULL,
    `expires_at` INT UNSIGNED DEFAULT NULL COMMENT 'NULL = permanent, otherwise expiration timestamp',
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE,
    INDEX `idx_instance` (`instance_id`),
    INDEX `idx_expires` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Guild Hall Decorations (Persistent GameObjects)
CREATE TABLE IF NOT EXISTS `guild_hall_decorations` (
    `decoration_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `guild_id` INT UNSIGNED NOT NULL,
    `go_entry` INT UNSIGNED NOT NULL COMMENT 'GameObject entry ID',
    `spawn_map` INT UNSIGNED NOT NULL,
    `instance_id` INT UNSIGNED NOT NULL,
    `spawn_x` FLOAT NOT NULL,
    `spawn_y` FLOAT NOT NULL,
    `spawn_z` FLOAT NOT NULL,
    `spawn_o` FLOAT NOT NULL,
    `scale` FLOAT NOT NULL DEFAULT 1.0,
    `state` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `created_time` INT UNSIGNED NOT NULL,
    INDEX `idx_guild` (`guild_id`),
    INDEX `idx_instance` (`instance_id`),
    FOREIGN KEY (`guild_id`) REFERENCES `guild_halls`(`guild_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Available Hall Templates
CREATE TABLE IF NOT EXISTS `hall_templates` (
    `template_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `template_name` VARCHAR(100) NOT NULL,
    `base_map_id` INT UNSIGNED NOT NULL,
    `cost_gold` INT UNSIGNED NOT NULL DEFAULT 10000 COMMENT 'Cost in gold',
    `cost_item` INT UNSIGNED DEFAULT NULL COMMENT 'Alternative: cost in items',
    `cost_item_count` INT UNSIGNED NOT NULL DEFAULT 0,
    `description` TEXT,
    `enabled` BOOLEAN NOT NULL DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Hall Templates
INSERT INTO `hall_templates` (`template_name`, `base_map_id`, `cost_gold`, `description`, `enabled`) VALUES
('Shadowfang Keep', 33, 10000, 'Private instance of Shadowfang Keep. Perfect for guild meetings and storage.', TRUE),
('Deadmines', 36, 10000, 'Private instance of Deadmines. Converted into a guild hall.', TRUE),
('Scarlet Monastery', 189, 15000, 'Private instance of Scarlet Monastery. Larger space for guild activities.', TRUE),
('Razorfen Kraul', 47, 8000, 'Private instance of Razorfen Kraul. Affordable guild hall option.', TRUE)

ON DUPLICATE KEY UPDATE
    `template_name` = VALUES(`template_name`),
    `cost_gold` = VALUES(`cost_gold`),
    `description` = VALUES(`description`),
    `enabled` = VALUES(`enabled`);

