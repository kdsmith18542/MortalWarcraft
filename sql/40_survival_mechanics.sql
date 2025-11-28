-- ==================================================
-- Project Mortal Warcraft
-- Feature: Survival Mechanics (Metabolism)
-- Description: Hunger/satiety system for survival gameplay
-- ==================================================

-- Player Satiety Tracking Table
CREATE TABLE IF NOT EXISTS `character_satiety` (
    `guid` INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Player GUID',
    `satiety_level` INT UNSIGNED NOT NULL DEFAULT 100 COMMENT 'Satiety level (0-100, 100 = full, 0 = starving)',
    `last_update` INT UNSIGNED NOT NULL COMMENT 'Unix timestamp of last update',
    `hunger_rate` FLOAT NOT NULL DEFAULT 1.0 COMMENT 'Hunger rate multiplier (1.0 = normal)',
    INDEX `idx_satiety` (`satiety_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Player satiety tracking for survival mechanics';

-- Food Item Effects Table (for tracking food consumption)
CREATE TABLE IF NOT EXISTS `food_item_effects` (
    `item_entry` INT UNSIGNED NOT NULL PRIMARY KEY,
    `satiety_restore` INT UNSIGNED NOT NULL DEFAULT 20 COMMENT 'Satiety restored when consumed',
    `quality` TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Food quality (1-5)',
    `notes` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert common food items
INSERT INTO `food_item_effects` (`item_entry`, `satiety_restore`, `quality`, `notes`) VALUES
-- Basic Foods (Quality 1)
(117, 10, 1, 'Hard Cheese - Basic food'),
(414, 15, 1, 'Dalaran Sharp - Basic food'),
(422, 15, 1, 'Dwarven Mild - Basic food'),
(159, 20, 1, 'Refreshing Spring Water - Basic drink'),

-- Standard Foods (Quality 2)
(4540, 25, 2, 'Tough Hunk of Bread - Standard food'),
(4541, 25, 2, 'Freshly Baked Bread - Standard food'),
(4542, 30, 2, 'Moist Cornbread - Standard food'),
(4599, 30, 2, 'Cured Ham Steak - Standard food'),

-- Good Foods (Quality 3)
(4601, 40, 3, 'Soft Banana Bread - Good food'),
(4602, 40, 3, 'Moon Harvest Pumpkin - Good food'),
(8950, 45, 3, 'Homemade Cherry Pie - Good food'),
(8952, 45, 3, 'Roasted Quail - Good food'),

-- Excellent Foods (Quality 4)
(8953, 60, 4, 'Deep Fried Plantains - Excellent food'),
(8957, 60, 4, 'Spinefin Halibut - Excellent food'),
(20424, 70, 4, 'Sandworm Meat - Excellent food'),

-- Masterwork Foods (Quality 5)
(33052, 80, 5, 'Fisherman''s Feast - Masterwork food'),
(33053, 80, 5, 'Hot Buttered Trout - Masterwork food'),
(34748, 90, 5, 'Spicy Hot Talbuk - Masterwork food')

ON DUPLICATE KEY UPDATE
    `satiety_restore` = VALUES(`satiety_restore`),
    `quality` = VALUES(`quality`),
    `notes` = VALUES(`notes`);

