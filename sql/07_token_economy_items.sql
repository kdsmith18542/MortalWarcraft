-- ==================================================
-- Project Mortal Warcraft: Token Economy Items
-- Module: mod-mortal-core
-- Feature: Create custom items for Adventurer's License system
-- ==================================================

-- Adventurer's License (Tradable Token)
-- Item ID: 90000
-- Grants 30 days of Supporter Status when consumed
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
    90000, -- entry
    0, -- class (Consumable)
    0, -- subclass
    'Adventurer\'s License', -- name
    13262, -- displayid (scroll/parchment icon)
    3, -- Quality (Rare/Blue)
    0, -- Flags
    0, -- FlagsExtra
    1, -- BuyCount
    0, -- BuyPrice (not sold by vendors)
    0, -- SellPrice (not sellable)
    0, -- InventoryType (Not specified/Quest item)
    -1, -- AllowableClass (All classes)
    -1, -- AllowableRace (All races)
    1, -- ItemLevel
    1, -- RequiredLevel
    0, -- RequiredSkill
    0, -- RequiredSkillRank
    1, -- stackable (can stack, but typically used one at a time)
    0, -- ContainerSlots
    0, -- stat_type1
    0, -- stat_value1
    0, -- bonding (Not soulbound - TRADABLE)
    'A tradable license that grants 30 days of Supporter Status. Can be purchased from other players or crafted from 100 Fragments of the Crown.', -- description
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
    0, -- duration (permanent until used)
    0, -- ItemLimitCategory
    0, -- HolidayId
    'item_mortal_bond', -- ScriptName (links to Lua script)
    0, -- DisenchantID
    0, -- FoodType
    0, -- minMoneyLoot
    0, -- maxMoneyLoot
    0, -- flagsCustom
    12340 -- VerifiedBuild (3.3.5a)
) ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- Fragment of the Crown
-- Item ID: 90001
-- Drops from Red Zone Bosses and Delve Chests (1% drop rate)
-- Combine 100 to create 1 Adventurer's License
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
    90001, -- entry
    12, -- class (Quest)
    0, -- subclass
    'Fragment of the Crown', -- name
    13262, -- displayid (crown/jewel fragment icon - may need custom)
    2, -- Quality (Uncommon/Green)
    0, -- Flags
    0, -- FlagsExtra
    1, -- BuyCount
    0, -- BuyPrice
    0, -- SellPrice
    0, -- InventoryType
    -1, -- AllowableClass
    -1, -- AllowableRace
    1, -- ItemLevel
    1, -- RequiredLevel
    0, -- RequiredSkill
    0, -- RequiredSkillRank
    200, -- stackable (can stack up to 200)
    0, -- ContainerSlots
    0, -- stat_type1
    0, -- stat_value1
    0, -- bonding (NOT soulbound - can be lost on death!)
    'A rare fragment that can be combined with 99 others to create an Adventurer\'s License. Drops only from Red Zone Bosses and Delve Chests. WARNING: Not soulbound - you will lose this if you die!', -- description
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
    0, -- duration
    0, -- ItemLimitCategory
    0, -- HolidayId
    'item_mortal_bond', -- ScriptName (for combination logic)
    0, -- DisenchantID
    0, -- FoodType
    0, -- minMoneyLoot
    0, -- maxMoneyLoot
    0, -- flagsCustom
    12340 -- VerifiedBuild
) ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

