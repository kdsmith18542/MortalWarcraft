-- ==================================================
-- Project Mortal Warcraft: Companion Feed Items
-- Feature: Feed items for pets, mounts, and mercenaries
-- Based on: docs/specs/29-companion-bond-and-mercenary-system.md
-- ID Range: 730000-734999 per spec 31-mortal-core-registry.md
-- ==================================================

START TRANSACTION;

-- Pet Feed Items
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, 
    `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, 
    `maxcount`, `stackable`, `ContainerSlots`, `description`
) VALUES
-- Pet Ration (basic feed)
(730001, 0, 0, 'Mortal Pet Ration', 13367, 1, 0, 1, 10000, 5000, 0, -1, -1, 1, 1, 0, 20, 0,
 'Restores 40 Hunger and grants 2 Bond to your pet. Use on your active pet.'),

-- Mount Feed Items
-- Mount Oats (basic mount feed)
(730101, 0, 0, 'Mortal Mount Oats', 13367, 1, 0, 1, 5000, 2500, 0, -1, -1, 1, 1, 0, 20, 0,
 'Restores 40 Hunger and grants 2 Bond to your mount. Use while mounted or on mount item in inventory.'),

-- War Ration (premium mount feed)
(730102, 0, 0, 'Mortal War Ration', 13367, 2, 0, 1, 25000, 12500, 0, -1, -1, 1, 1, 0, 10, 0,
 'Restores 60 Hunger and grants 3 Bond to your mount. Premium feed for war mounts.'),

-- Mercenary Upkeep Items
-- Mercenary Ration (basic upkeep)
(730201, 0, 0, 'Mercenary Ration', 13367, 1, 0, 1, 15000, 7500, 0, -1, -1, 1, 1, 0, 20, 0,
 'Restores 40 Hunger and grants 2 Bond to your active mercenary. Use while mercenary is active.')

ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Add use spell effects (these would need custom spells created)
-- For now, items are created but use effects need to be implemented in Lua

COMMIT;

SELECT 'Companion feed items created successfully.' AS result;
SELECT 'Items: 730001 (Pet Ration), 730101 (Mount Oats), 730102 (War Ration), 730201 (Mercenary Ration)' AS result;
SELECT 'NOTE: Use spell effects need to be implemented in Lua companion_feed_items.lua' AS result;

