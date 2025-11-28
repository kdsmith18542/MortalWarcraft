-- ==================================================
-- Mortal Warcraft – Campaign Item Templates
-- Spec 62: Core Lore and Campaign Skeleton
-- Item ID Range: 99991-99999 (Prologue/Act I quest items)
-- Target DB: world
-- ==================================================

-- Broken Weapon (99991) - Prologue Q1: Arms from Ruin
DELETE FROM `item_template` WHERE `entry` = 99991;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`, `sheath`, `MaxDurability`
) VALUES (
    99991, 2, 7, 'Broken Weapon', 1542, 0, 0, 1, 0, 0,
    13, -1, -1, 1, 1,
    0, 1, 'A broken weapon salvaged from the wreckage. It might still be usable.', 1, 1, 20
);

-- Driftwood (99993) - Prologue Q2: Driftwood & Flint
DELETE FROM `item_template` WHERE `entry` = 99993;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`, `stackable`
) VALUES (
    99993, 7, 0, 'Driftwood', 0, 0, 0, 1, 0, 1,
    0, -1, -1, 1, 1,
    0, 0, 'Pieces of driftwood washed ashore. Useful for crafting.', 2, 20
);

-- Flint (99994) - Prologue Q2: Driftwood & Flint
DELETE FROM `item_template` WHERE `entry` = 99994;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`, `stackable`
) VALUES (
    99994, 7, 0, 'Flint', 0, 0, 0, 1, 0, 1,
    0, -1, -1, 1, 1,
    0, 0, 'Sharp pieces of flint found among the rocks. Good for crafting tools.', 1, 20
);

-- Crafted Shiv (99995) - Prologue Q3: Edge of Survival
DELETE FROM `item_template` WHERE `entry` = 99995;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `stat_type1`, `stat_value1`, `stat_type2`, `stat_value2`,
    `StatsCount`, `bonding`, `description`, `Material`, `sheath`, `MaxDurability`, `delay`
) VALUES (
    99995, 2, 15, 'Crafted Shiv', 1542, 1, 0, 1, 0, 50,
    13, -1, -1, 1, 1,
    1, 2,  -- +2 Strength
    2, 1,  -- +1 Agility
    2, 1, 'A crude but effective weapon you crafted yourself.', 1, 1, 30, 1500
);

-- Contract Payment Receipt (99985) - Act I Q3: Pay, Not XP
DELETE FROM `item_template` WHERE `entry` = 99985;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`, `stackable`
) VALUES (
    99985, 12, 0, 'Contract Payment Receipt', 0, 0, 0, 1, 0, 0,
    0, -1, -1, 1, 1,
    0, 1, 'A receipt proving you completed a contract. Turn this in for your payment.', 7, 1
);

-- Starter Gear Pack (99998) - Prologue Q5: The Raft to Mainland
DELETE FROM `item_template` WHERE `entry` = 99998;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`, `ContainerSlots`
) VALUES (
    99998, 1, 0, 'Starter Gear Pack', 0, 1, 0, 1, 0, 0,
    18, -1, -1, 1, 1,
    0, 1, 'A pack containing basic starter equipment for your journey inland.', 7, 4
);

-- Repaired Raft (99999) - Prologue Q5: The Raft to Mainland (Quest Item)
DELETE FROM `item_template` WHERE `entry` = 99999;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`
) VALUES (
    99999, 12, 0, 'Repaired Raft', 0, 0, 0, 1, 0, 0,
    0, -1, -1, 1, 1,
    0, 1, 'A repaired raft ready to take you to the mainland. Use it to travel to Port Meridian.', 2, 1
);

-- Shrine-Touched Pebble (99997) - Prologue Q4: First Fracture (Flavor Item)
DELETE FROM `item_template` WHERE `entry` = 99997;
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `BuyCount`, `BuyPrice`, `SellPrice`,
    `InventoryType`, `AllowableClass`, `AllowableRace`, `ItemLevel`, `RequiredLevel`,
    `StatsCount`, `bonding`, `description`, `Material`
) VALUES (
    99997, 4, 0, 'Shrine-Touched Pebble', 0, 1, 0, 1, 0, 0,
    2, -1, -1, 1, 1,
    0, 1, 'A small pebble that once touched a Shrine Fragment. It pulses faintly with residual energy. A memento of your first encounter with the Fracture.', 3, 1
);

