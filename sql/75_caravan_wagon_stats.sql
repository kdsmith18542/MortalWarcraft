-- ==================================================
-- Project Mortal Warcraft
-- Feature: Caravan Wagon Stats
-- Description: Wagon stat definitions for caravan system
-- Spec: 13-caravans-contracts.md
-- ==================================================

-- Caravan wagon stat definitions
CREATE TABLE IF NOT EXISTS `mortal_caravan_wagon_stats` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `wagon_type` VARCHAR(50) NOT NULL COMMENT 'basic, reinforced, heavy, magical',
    `max_speed` FLOAT NOT NULL DEFAULT 0.6 COMMENT 'Speed multiplier (0.6 = 60% of normal)',
    `turn_rate` FLOAT NOT NULL DEFAULT 0.3 COMMENT 'Turn rate multiplier',
    `stamina_pool` INT UNSIGNED NOT NULL DEFAULT 1000 COMMENT 'Stamina points',
    `armor` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Armor value',
    `cargo_slots` INT UNSIGNED NOT NULL DEFAULT 20 COMMENT 'Number of cargo slots',
    `visibility_radius` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Visibility radius in yards',
    `durability` INT UNSIGNED NOT NULL DEFAULT 1000 COMMENT 'Wagon durability',
    `item_entry` INT UNSIGNED NOT NULL COMMENT 'Item entry for wagon',
    `description` TEXT,
    `created_at` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_wagon_type` (`wagon_type`),
    KEY `idx_item_entry` (`item_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default wagon types
INSERT INTO `mortal_caravan_wagon_stats` (`wagon_type`, `max_speed`, `turn_rate`, `stamina_pool`, `armor`, `cargo_slots`, `visibility_radius`, `durability`, `item_entry`, `description`) VALUES
('basic', 0.6, 0.3, 1000, 100, 20, 100, 1000, 500010, 'Basic caravan wagon - standard speed and capacity'),
('reinforced', 0.55, 0.25, 1500, 200, 25, 100, 1500, 500011, 'Reinforced wagon - slower but more durable and spacious'),
('heavy', 0.5, 0.2, 2000, 300, 30, 120, 2000, 500012, 'Heavy wagon - very slow but maximum capacity and durability'),
('magical', 0.65, 0.35, 1200, 150, 22, 80, 1200, 500013, 'Magical wagon - faster and more maneuverable but less durable');

