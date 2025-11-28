-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Courier Contracts - Sealed Courier Crate Item
-- Description: Creates the Sealed Courier Crate item (Entry 90002) in azerothcore_world
-- ==================================================

-- WARNING: This script creates a custom item in azerothcore_world.
-- Make sure you have a database backup before running this!

START TRANSACTION;

-- Sealed Courier Crate
-- Entry: 90002 (90000 and 90001 are used for Token Economy items)
-- This is a container item that holds contract items during transit
INSERT INTO `item_template` (
    `entry`, `class`, `subclass`, `name`, `displayid`, `Quality`, `Flags`, `FlagsExtra`, 
    `BuyCount`, `BuyPrice`, `SellPrice`, `InventoryType`, `AllowableClass`, `AllowableRace`, 
    `ItemLevel`, `RequiredLevel`, `RequiredSkill`, `RequiredSkillRank`, `stackable`, 
    `ContainerSlots`, `stat_type1`, `stat_value1`, `bonding`, `description`, 
    `Material`, `sheath`, `RandomProperty`, `RandomSuffix`, `ItemSet`, `MaxDurability`, 
    `Area`, `Map`, `BagFamily`, `TotemCategory`, `socketColor_1`, `socketContent_1`, 
    `socketColor_2`, `socketContent_2`, `socketColor_3`, `socketContent_3`, `socketBonus`, 
    `GemProperties`, `RequiredDisenchantSkill`, `ArmorDamageModifier`, `duration`, 
    `ItemLimitCategory`, `HolidayId`, `ScriptName`, `DisenchantID`, `FoodType`, 
    `minMoneyLoot`, `maxMoneyLoot`, `flagsCustom`, `VerifiedBuild`
) VALUES (
    90002, -- entry
    1, -- class (Container)
    0, -- subclass
    'Sealed Courier Crate', -- name
    1301, -- displayid (Crate model)
    2, -- Quality (Uncommon/Green)
    0, -- Flags
    0, -- FlagsExtra
    1, -- BuyCount
    0, -- BuyPrice
    0, -- SellPrice
    0, -- InventoryType (Non-equippable)
    -1, -- AllowableClass (All)
    -1, -- AllowableRace (All)
    1, -- ItemLevel
    0, -- RequiredLevel
    0, -- RequiredSkill
    0, -- RequiredSkillRank
    1, -- stackable (Cannot stack)
    22, -- ContainerSlots (22-slot bag)
    0, -- stat_type1
    0, -- stat_value1
    0, -- bonding (No bind - can be traded/dropped)
    'A sealed crate containing items for delivery. Cannot be opened until delivered to the destination zone. If you die, the contract fails and items are returned to the issuer.', -- description
    0, -- Material
    0, -- sheath
    0, -- RandomProperty
    0, -- RandomSuffix
    0, -- ItemSet
    0, -- MaxDurability
    0, -- Area
    0, -- Map
    0, -- BagFamily
    0, -- TotemCategory
    0, -- socketColor_1
    0, -- socketContent_1
    0, -- socketColor_2
    0, -- socketContent_2
    0, -- socketColor_3
    0, -- socketContent_3
    0, -- socketBonus
    0, -- GemProperties
    -1, -- RequiredDisenchantSkill
    0, -- ArmorDamageModifier
    0, -- duration (permanent)
    0, -- ItemLimitCategory
    0, -- HolidayId
    'item_courier_crate', -- ScriptName (links to Lua script)
    0, -- DisenchantID
    0, -- FoodType
    0, -- minMoneyLoot
    0, -- maxMoneyLoot
    0, -- flagsCustom
    12340 -- VerifiedBuild (3.3.5a)
) ON DUPLICATE KEY UPDATE 
    `name` = 'Sealed Courier Crate',
    `description` = 'A sealed crate containing items for delivery. Cannot be opened until delivered to the destination zone. If you die, the contract fails and items are returned to the issuer.',
    `ScriptName` = 'item_courier_crate';

COMMIT;

-- Report results
SELECT 'Sealed Courier Crate item (Entry 90002) created successfully.' AS result;
SELECT 'Note: Update courier_contracts.lua to use item entry 90002 instead of 90000' AS result;

