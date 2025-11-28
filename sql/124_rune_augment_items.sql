-- ==================================================
-- Project Mortal Warcraft
-- Feature: Rune and Augment Item Templates
-- Description: Creates item templates for runes and augments
-- Based on: docs/specs/53-rune-augments-and-gear-build-system.md
-- ==================================================

-- Rune Items (4 runes)
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `bonding`, `description`, `Material`, `ScriptName`) VALUES
(900800, 0, 0, 'Rune of Whirlwind', 13262, 3, 0, 1, 1000, 100, 0, -1, -1, 80, 0, 1, 2, 'Grants Whirlwind ability - spin attack hitting nearby enemies', -1, 'item_rune'),
(900801, 0, 0, 'Rune of Blink', 13262, 3, 0, 1, 1000, 100, 0, -1, -1, 80, 0, 1, 2, 'Grants Blink ability - short-range teleport', -1, 'item_rune'),
(900802, 0, 0, 'Rune of Guard Counter', 13262, 3, 0, 1, 1000, 100, 0, -1, -1, 80, 0, 1, 2, 'Grants Guard Counter ability - counter-attack after blocking', -1, 'item_rune'),
(900803, 0, 0, 'Rune of Thorns', 13262, 3, 0, 1, 1000, 100, 0, -1, -1, 80, 0, 1, 2, 'Grants Thorns passive - reflect damage to attackers', -1, 'item_rune')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Augment Items (9 augments)
INSERT INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `bonding`, `description`, `Material`, `ScriptName`) VALUES
-- Offense Augments
(900810, 0, 0, 'Razor Gale', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, 'When using Whirlwind, apply a small Bleed', -1, 'item_augment'),
(900811, 0, 0, 'Measured Strikes', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, 'Basic melee attacks gain +5% crit chance when above 80% stamina', -1, 'item_augment'),
(900812, 0, 0, 'Executioner''s Edge', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, '+10% damage vs low-health enemies (<20%)', -1, 'item_augment'),
-- Defense Augments
(900820, 0, 0, 'Stone Brace', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, 'Brace reduces damage by an additional 10% vs the first hit', -1, 'item_augment'),
(900821, 0, 0, 'Iron Will', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, 'Taking a Guard Counter opportunity grants +5% damage reduction for 3s', -1, 'item_augment'),
(900822, 0, 0, 'Shrinebound', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, '+X% resistance to undead/holy damage near Shrines', -1, 'item_augment'),
-- Utility Augments
(900830, 0, 0, 'Trailblazer', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, 'Slight movement speed bonus in wilderness zones', -1, 'item_augment'),
(900831, 0, 0, 'Packrat', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, '+5% carry capacity for materials', -1, 'item_augment'),
(900832, 0, 0, 'Smuggler''s Guile', 13262, 2, 0, 1, 500, 50, 0, -1, -1, 80, 0, 1, 2, 'Reduced gold loss on death by Y%', -1, 'item_augment')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `description` = VALUES(`description`);

-- Summary
SELECT 
    'Rune and Augment Items Created' as summary,
    COUNT(CASE WHEN entry BETWEEN 900800 AND 900803 THEN 1 END) as total_runes,
    COUNT(CASE WHEN entry BETWEEN 900810 AND 900832 THEN 1 END) as total_augments
FROM item_template WHERE entry BETWEEN 900800 AND 900832;

