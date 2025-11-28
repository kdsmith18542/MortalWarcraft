-- ==================================================
-- Project Mortal Warcraft
-- Feature: Character Creation Starter Items
-- Description: Defines starter kit items for new characters
-- ==================================================

-- Starter Kit Item Definitions
-- These are the items given to all new characters regardless of class

-- Note: Item IDs may need adjustment based on your item database
-- The following are common low-level items:

-- Rags (Cloth Chest) - Basic starting clothing
-- Item ID 25861: Rough Leather Vest (Level 1, Cloth Chest)
-- Alternative: 2589 (Linen Cloth) - but this is material, not equipment

-- Worn Dagger - Basic weapon
-- Item ID 2092: Worn Dagger (Level 1, One-Hand Dagger)

-- Torch - Light source
-- Item ID 5956: Blacksmith Hammer (placeholder - need actual torch)
-- Alternative: 2512 (Rough Arrow) - not a torch
-- TODO: Find correct torch item ID or create custom item

-- Bread - Food
-- Item ID 4540: Tough Hunk of Bread (Level 1, Food)
-- Alternative: 117 (Hard Cheese), 159 (Refreshing Spring Water)

-- Create a reference table for starter items (optional, for tracking)
CREATE TABLE IF NOT EXISTS `starter_kit_items` (
    `item_entry` INT UNSIGNED NOT NULL PRIMARY KEY,
    `item_name` VARCHAR(100) NOT NULL,
    `item_type` VARCHAR(50) NOT NULL COMMENT 'Equipment, Consumable, etc.',
    `quantity` INT UNSIGNED NOT NULL DEFAULT 1,
    `notes` VARCHAR(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert starter kit items
INSERT INTO `starter_kit_items` (`item_entry`, `item_name`, `item_type`, `quantity`, `notes`) VALUES
(38, 'Recruiter''s Shirt', 'Equipment', 1, 'Rags - Basic chest armor'),
(2092, 'Worn Dagger', 'Equipment', 1, 'Basic weapon'),
(44212, 'Torch', 'Equipment', 1, 'Light source'),
(4540, 'Tough Hunk of Bread', 'Consumable', 5, 'Starter food')

ON DUPLICATE KEY UPDATE
    `item_name` = VALUES(`item_name`),
    `item_type` = VALUES(`item_type`),
    `quantity` = VALUES(`quantity`),
    `notes` = VALUES(`notes`);

