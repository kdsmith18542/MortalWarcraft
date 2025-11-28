-- ==================================================
-- Project Mortal Warcraft
-- Feature: Stealth & Vision System
-- Description: True Sight potions and stealth detection items
-- ==================================================

-- Create True Sight Potion item
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`,
    `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`,
    `ItemLevel`, `RequiredLevel`, `stackable`, `ScriptName`, `description`, `VerifiedBuild`
) VALUES (
    90004, -- entry
    0,     -- class (Consumable)
    3,     -- subclass (Potion)
    'True Sight Potion', -- name
    13446, -- displayid (Potion model)
    2,     -- Quality (Uncommon)
    0,     -- Flags
    0,     -- FlagsExtra
    1,     -- BuyCount
    5000,  -- BuyPrice (50 silver)
    2500,  -- SellPrice (25 silver)
    0,     -- InventoryType (Non-equippable)
    -1,    -- AllowableClass (All)
    -1,    -- AllowableRace (All)
    30,    -- ItemLevel
    1,     -- RequiredLevel
    10,    -- stackable (Can stack to 10)
    'item_true_sight', -- ScriptName
    'Reveals stealthed players within 30 yards for 5 minutes.', -- description
    12340  -- VerifiedBuild (3.3.5a)
) ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

-- Create Stealth Detection Spell (for True Sight effect)
-- Note: This would need to be added to spell_template or handled via Lua
-- Spell ID: 60002 (custom spell for True Sight)

