-- ==================================================
-- Project Mortal Warcraft: Bounty Token Item
-- Module: mod-mortal-core
-- Feature: Bounty token item template
-- ==================================================

-- Insert Bounty Token item (if not exists)
INSERT IGNORE INTO `item_template` (`entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`, `stackable`, `ContainerSlots`) VALUES
(90002, 12, 0, 'Bounty Token', 13367, 3, 0, 1, 0, 0, 0, -1, -1, 1, 1, 200, 0);

-- Note: Bounty Tokens are tradeable and can be exchanged for cosmetics/titles
