-- ==================================================
-- Mortal Warcraft – Healer/Ranger/Mage Sets (Item Templates)
-- Spec 78: Itemization - Healer, Ranger, Mage
-- Item ID Range: 700100-700299 (T1/T2 PvE gear)
-- ==================================================

-- Stat Type IDs: 1=STR, 2=AGI, 3=STA, 4=INT, 5=SPI

-- ==================================================
-- ARCHETYPE C: Sanctum Warden (Healer)
-- ==================================================

-- T1: Shrine Acolyte Set
-- Item IDs: 700100-700107

-- Weapon: Acolyte's Blessing Mace (1H Mace)
DELETE FROM item_template WHERE entry = 700100;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700100, 2, 4, 'Acolyte''s Blessing Mace', 0, 2, 0, 1, 5000, 1000,
    13, -1, -1, 10, 1,
    4, 6,  -- +6 Intellect
    5, 6,  -- +6 Spirit
    3, 4,  -- +4 Stamina
    3, 1, 'A mace blessed by the Shrine.', 1, 3
);

-- Helm: Acolyte's Circlet
DELETE FROM item_template WHERE entry = 700101;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700101, 4, 1, 'Acolyte''s Circlet', 0, 2, 0, 1, 3000, 600,
    1, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 3,  -- +3 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A simple circlet for shrine initiates.', 7, 20
);

-- Chest: Acolyte's Vestments
DELETE FROM item_template WHERE entry = 700102;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700102, 4, 1, 'Acolyte''s Vestments', 0, 2, 0, 1, 5000, 1000,
    5, -1, -1, 10, 1,
    4, 5,  -- +5 Intellect
    5, 5,  -- +5 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Robes for shrine acolytes.', 7, 40
);

-- Legs: Acolyte's Legwraps
DELETE FROM item_template WHERE entry = 700103;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700103, 4, 1, 'Acolyte''s Legwraps', 0, 2, 0, 1, 4000, 800,
    7, -1, -1, 10, 1,
    4, 4,  -- +4 Intellect
    5, 4,  -- +4 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Leg wraps for shrine acolytes.', 7, 35
);

-- Gloves: Acolyte's Handwraps
DELETE FROM item_template WHERE entry = 700104;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700104, 4, 1, 'Acolyte''s Handwraps', 0, 2, 0, 1, 2000, 400,
    10, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Hand wraps for healing work.', 7, 15
);

-- Boots: Acolyte's Sandals
DELETE FROM item_template WHERE entry = 700105;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700105, 4, 1, 'Acolyte''s Sandals', 0, 2, 0, 1, 2000, 400,
    8, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Simple sandals for shrine acolytes.', 7, 15
);

-- Ring: Shrine Prayer Band
DELETE FROM item_template WHERE entry = 700106;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700106, 4, 0, 'Shrine Prayer Band', 0, 2, 0, 1, 1500, 300,
    11, -1, -1, 10, 1,
    4, 2,  -- +2 Intellect
    5, 3,  -- +3 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A ring used in shrine prayers.', 5
);

-- Necklace: Shrine Rosary
DELETE FROM item_template WHERE entry = 700107;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700107, 4, 0, 'Shrine Rosary', 0, 2, 0, 1, 2000, 400,
    2, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 4,  -- +4 Spirit
    3, 1,  -- +1 Stamina
    3, 1, 'A rosary blessed by the Shrine.', 5
);

-- ==================================================
-- T2: Sanctum Warden's Regalia
-- Item IDs: 700110-700117
-- ==================================================

-- Weapon: Sanctum Warden's Staff
DELETE FROM item_template WHERE entry = 700110;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700110, 2, 10, 'Sanctum Warden''s Staff', 0, 3, 0, 1, 18000, 3600,
    17, -1, -1, 20, 4,
    4, 10, -- +10 Intellect
    5, 8,  -- +8 Spirit
    3, 4,  -- +4 Stamina
    3, 1, 'A staff for those who guard the shrines.', 2, 2
);

-- Helm: Sanctum Warden's Halo
DELETE FROM item_template WHERE entry = 700111;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700111, 4, 1, 'Sanctum Warden''s Halo', 0, 3, 0, 1, 8000, 1600,
    1, -1, -1, 20, 4,
    4, 5,  -- +5 Intellect
    5, 5,  -- +5 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A halo for those who protect the shrines.', 7, 50
);

-- Chest: Sanctum Warden's Robes
DELETE FROM item_template WHERE entry = 700112;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700112, 4, 1, 'Sanctum Warden''s Robes', 0, 3, 0, 1, 12000, 2400,
    5, -1, -1, 20, 4,
    4, 7,  -- +7 Intellect
    5, 7,  -- +7 Spirit
    3, 4,  -- +4 Stamina
    3, 1, 'Robes for those who guard the shrines.', 7, 100
);

-- Legs: Sanctum Warden's Pants
DELETE FROM item_template WHERE entry = 700113;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700113, 4, 1, 'Sanctum Warden''s Pants', 0, 3, 0, 1, 10000, 2000,
    7, -1, -1, 20, 4,
    4, 6,  -- +6 Intellect
    5, 6,  -- +6 Spirit
    3, 4,  -- +4 Stamina
    3, 1, 'Pants for those who protect the shrines.', 7, 90
);

-- Gloves: Sanctum Warden's Handguards
DELETE FROM item_template WHERE entry = 700114;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700114, 4, 1, 'Sanctum Warden''s Handguards', 0, 3, 0, 1, 6000, 1200,
    10, -1, -1, 20, 4,
    4, 4,  -- +4 Intellect
    5, 4,  -- +4 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Handguards for healing work.', 7, 40
);

-- Boots: Sanctum Warden's Slippers
DELETE FROM item_template WHERE entry = 700115;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700115, 4, 1, 'Sanctum Warden''s Slippers', 0, 3, 0, 1, 6000, 1200,
    8, -1, -1, 20, 4,
    4, 4,  -- +4 Intellect
    5, 4,  -- +4 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Slippers for those who guard the shrines.', 7, 40
);

-- Ring: Halo-bound Band
DELETE FROM item_template WHERE entry = 700116;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700116, 4, 0, 'Halo-bound Band', 0, 3, 0, 1, 5000, 1000,
    11, -1, -1, 20, 4,
    4, 3,  -- +3 Intellect
    5, 3,  -- +3 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A ring bound to the halo of protection.', 5
);

-- Necklace: Shrine Guardian's Locket
DELETE FROM item_template WHERE entry = 700117;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material
) VALUES (
    700117, 4, 0, 'Shrine Guardian''s Locket', 0, 3, 0, 1, 5000, 1000,
    2, -1, -1, 20, 4,
    4, 4,  -- +4 Intellect
    5, 4,  -- +4 Spirit
    2, 1, 'A locket for those who guard the shrines.', 5
);

-- ==================================================
-- ARCHETYPE D: Longroad Ranger (Ranged Physical DPS)
-- ==================================================

-- T1: Greenway Scout Set
-- Item IDs: 700120-700127

-- Weapon: Greenway Scout's Bow
DELETE FROM item_template WHERE entry = 700120;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700120, 2, 2, 'Greenway Scout''s Bow', 0, 2, 0, 1, 6000, 1200,
    15, -1, -1, 10, 1,
    2, 8,  -- +8 Agility
    3, 4,  -- +4 Stamina
    4, 2,  -- +2 Intellect
    5, 2,  -- +2 Spirit
    4, 1, 'A bow for scouting the greenways.', 2, 0
);

-- Helm: Greenway Leather Hood
DELETE FROM item_template WHERE entry = 700121;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700121, 4, 2, 'Greenway Leather Hood', 0, 2, 0, 1, 3000, 600,
    1, -1, -1, 10, 1,
    2, 4,  -- +4 Agility
    3, 2,  -- +2 Stamina
    2, 1, 'A hood for scouting the greenways.', 8, 30
);

-- Chest: Greenway Scout's Jerkin
DELETE FROM item_template WHERE entry = 700122;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700122, 4, 2, 'Greenway Scout''s Jerkin', 0, 2, 0, 1, 5000, 1000,
    5, -1, -1, 10, 1,
    2, 5,  -- +5 Agility
    3, 3,  -- +3 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'A jerkin for scouting the greenways.', 8, 60
);

-- Legs: Greenway Leggings
DELETE FROM item_template WHERE entry = 700123;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700123, 4, 2, 'Greenway Leggings', 0, 2, 0, 1, 4000, 800,
    7, -1, -1, 10, 1,
    2, 5,  -- +5 Agility
    3, 3,  -- +3 Stamina
    2, 1, 'Leggings for scouting the greenways.', 8, 50
);

-- Gloves: Greenway Grips
DELETE FROM item_template WHERE entry = 700124;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700124, 4, 2, 'Greenway Grips', 0, 2, 0, 1, 2000, 400,
    10, -1, -1, 10, 1,
    2, 3,  -- +3 Agility
    3, 2,  -- +2 Stamina
    2, 1, 'Gloves for scouting the greenways.', 8, 25
);

-- Boots: Greenway Boots
DELETE FROM item_template WHERE entry = 700125;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700125, 4, 2, 'Greenway Boots', 0, 2, 0, 1, 2000, 400,
    8, -1, -1, 10, 1,
    2, 3,  -- +3 Agility
    3, 2,  -- +2 Stamina
    2, 1, 'Boots for scouting the greenways.', 8, 25
);

-- Ring: Pathfinder's Band
DELETE FROM item_template WHERE entry = 700126;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700126, 4, 0, 'Pathfinder''s Band', 0, 2, 0, 1, 1500, 300,
    11, -1, -1, 10, 1,
    2, 2,  -- +2 Agility
    3, 2,  -- +2 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'A ring for those who find paths.', 5
);

-- Necklace: Greenway Whistle Charm
DELETE FROM item_template WHERE entry = 700127;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700127, 4, 0, 'Greenway Whistle Charm', 0, 2, 0, 1, 2000, 400,
    2, -1, -1, 10, 1,
    2, 3,  -- +3 Agility
    3, 2,  -- +2 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'A charm with a whistle for signaling.', 5
);

-- ==================================================
-- T2: Longroad Tracker Set
-- Item IDs: 700130-700137
-- ==================================================

-- Weapon: Longroad Tracker's Bow
DELETE FROM item_template WHERE entry = 700130;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700130, 2, 2, 'Longroad Tracker''s Bow', 0, 3, 0, 1, 18000, 3600,
    15, -1, -1, 20, 4,
    2, 14, -- +14 Agility
    3, 6,  -- +6 Stamina
    4, 3,  -- +3 Intellect
    5, 2,  -- +2 Spirit
    4, 1, 'A bow for tracking the long roads.', 2, 0
);

-- Helm: Longroad Tracker's Cap
DELETE FROM item_template WHERE entry = 700131;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700131, 4, 2, 'Longroad Tracker''s Cap', 0, 3, 0, 1, 8000, 1600,
    1, -1, -1, 20, 4,
    2, 7,  -- +7 Agility
    3, 4,  -- +4 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'A cap for tracking the long roads.', 8, 70
);

-- Chest: Longroad Tracker's Coat
DELETE FROM item_template WHERE entry = 700132;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700132, 4, 2, 'Longroad Tracker''s Coat', 0, 3, 0, 1, 12000, 2400,
    5, -1, -1, 20, 4,
    2, 9,  -- +9 Agility
    3, 5,  -- +5 Stamina
    4, 2,  -- +2 Intellect
    5, 2,  -- +2 Spirit
    4, 1, 'A coat for tracking the long roads.', 8, 140
);

-- Legs: Longroad Tracker's Leggings
DELETE FROM item_template WHERE entry = 700133;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700133, 4, 2, 'Longroad Tracker''s Leggings', 0, 3, 0, 1, 10000, 2000,
    7, -1, -1, 20, 4,
    2, 8,  -- +8 Agility
    3, 5,  -- +5 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'Leggings for tracking the long roads.', 8, 120
);

-- Gloves: Longroad Tracker's Grips
DELETE FROM item_template WHERE entry = 700134;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700134, 4, 2, 'Longroad Tracker''s Grips', 0, 3, 0, 1, 6000, 1200,
    10, -1, -1, 20, 4,
    2, 5,  -- +5 Agility
    3, 3,  -- +3 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'Gloves for tracking the long roads.', 8, 50
);

-- Boots: Longroad Tracker's Boots
DELETE FROM item_template WHERE entry = 700135;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700135, 4, 2, 'Longroad Tracker''s Boots', 0, 3, 0, 1, 6000, 1200,
    8, -1, -1, 20, 4,
    2, 5,  -- +5 Agility
    3, 3,  -- +3 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'Boots for tracking the long roads.', 8, 50
);

-- Ring: Tracker's Mark
DELETE FROM item_template WHERE entry = 700136;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700136, 4, 0, 'Tracker''s Mark', 0, 3, 0, 1, 5000, 1000,
    11, -1, -1, 20, 4,
    2, 4,  -- +4 Agility
    3, 3,  -- +3 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'A ring marking a true tracker.', 5
);

-- Necklace: Longroad Compass
DELETE FROM item_template WHERE entry = 700137;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700137, 4, 0, 'Longroad Compass', 0, 3, 0, 1, 5000, 1000,
    2, -1, -1, 20, 4,
    2, 5,  -- +5 Agility
    3, 4,  -- +4 Stamina
    4, 2,  -- +2 Intellect
    3, 1, 'A compass for finding the long roads.', 5
);

-- ==================================================
-- ARCHETYPE E: Spellfire Magus (Pure Offensive Mage)
-- ==================================================

-- T1: Apprentice's Robes Set
-- Item IDs: 700140-700147

-- Weapon: Apprentice's Staff
DELETE FROM item_template WHERE entry = 700140;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700140, 2, 10, 'Apprentice''s Staff', 0, 2, 0, 1, 6000, 1200,
    17, -1, -1, 10, 1,
    4, 9,  -- +9 Intellect
    3, 3,  -- +3 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'A simple staff for apprentices.', 2, 2
);

-- Helm: Apprentice's Cap
DELETE FROM item_template WHERE entry = 700141;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700141, 4, 1, 'Apprentice''s Cap', 0, 2, 0, 1, 3000, 600,
    1, -1, -1, 10, 1,
    4, 4,  -- +4 Intellect
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'A cap for apprentices.', 7, 20
);

-- Chest: Apprentice's Robes
DELETE FROM item_template WHERE entry = 700142;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700142, 4, 1, 'Apprentice''s Robes', 0, 2, 0, 1, 5000, 1000,
    5, -1, -1, 10, 1,
    4, 6,  -- +6 Intellect
    3, 3,  -- +3 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Robes for apprentices.', 7, 40
);

-- Legs: Apprentice's Pants
DELETE FROM item_template WHERE entry = 700143;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700143, 4, 1, 'Apprentice''s Pants', 0, 2, 0, 1, 4000, 800,
    7, -1, -1, 10, 1,
    4, 5,  -- +5 Intellect
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Pants for apprentices.', 7, 35
);

-- Gloves: Apprentice's Gloves
DELETE FROM item_template WHERE entry = 700144;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700144, 4, 1, 'Apprentice''s Gloves', 0, 2, 0, 1, 2000, 400,
    10, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Gloves for apprentices.', 7, 15
);

-- Boots: Apprentice's Boots
DELETE FROM item_template WHERE entry = 700145;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700145, 4, 1, 'Apprentice''s Boots', 0, 2, 0, 1, 2000, 400,
    8, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Boots for apprentices.', 7, 15
);

-- Ring: Apprentice's Band
DELETE FROM item_template WHERE entry = 700146;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700146, 4, 0, 'Apprentice''s Band', 0, 2, 0, 1, 1500, 300,
    11, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'A ring for apprentices.', 5
);

-- Necklace: Apprentice's Pendant
DELETE FROM item_template WHERE entry = 700147;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700147, 4, 0, 'Apprentice''s Pendant', 0, 2, 0, 1, 2000, 400,
    2, -1, -1, 10, 1,
    4, 4,  -- +4 Intellect
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'A pendant for apprentices.', 5
);

-- ==================================================
-- T2: Spellfire Adept Set
-- Item IDs: 700150-700157
-- ==================================================

-- Weapon: Spellfire Adept's Staff
DELETE FROM item_template WHERE entry = 700150;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700150, 2, 10, 'Spellfire Adept''s Staff', 0, 3, 0, 1, 18000, 3600,
    17, -1, -1, 20, 4,
    4, 14, -- +14 Intellect
    3, 5,  -- +5 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'A staff for spellfire adepts.', 2, 2
);

-- Helm: Spellfire Adept's Crown
DELETE FROM item_template WHERE entry = 700151;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700151, 4, 1, 'Spellfire Adept''s Crown', 0, 3, 0, 1, 8000, 1600,
    1, -1, -1, 20, 4,
    4, 7,  -- +7 Intellect
    3, 3,  -- +3 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'A crown for spellfire adepts.', 7, 50
);

-- Chest: Spellfire Adept's Robes
DELETE FROM item_template WHERE entry = 700152;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700152, 4, 1, 'Spellfire Adept''s Robes', 0, 3, 0, 1, 12000, 2400,
    5, -1, -1, 20, 4,
    4, 10, -- +10 Intellect
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Robes for spellfire adepts.', 7, 100
);

-- Legs: Spellfire Adept's Leggings
DELETE FROM item_template WHERE entry = 700153;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700153, 4, 1, 'Spellfire Adept''s Leggings', 0, 3, 0, 1, 10000, 2000,
    7, -1, -1, 20, 4,
    4, 8,  -- +8 Intellect
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Leggings for spellfire adepts.', 7, 90
);

-- Gloves: Spellfire Adept's Gloves
DELETE FROM item_template WHERE entry = 700154;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700154, 4, 1, 'Spellfire Adept''s Gloves', 0, 3, 0, 1, 6000, 1200,
    10, -1, -1, 20, 4,
    4, 5,  -- +5 Intellect
    3, 3,  -- +3 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Gloves for spellfire adepts.', 7, 40
);

-- Boots: Spellfire Adept's Boots
DELETE FROM item_template WHERE entry = 700155;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700155, 4, 1, 'Spellfire Adept''s Boots', 0, 3, 0, 1, 6000, 1200,
    8, -1, -1, 20, 4,
    4, 5,  -- +5 Intellect
    3, 3,  -- +3 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Boots for spellfire adepts.', 7, 40
);

-- Ring: Spellfire Band
DELETE FROM item_template WHERE entry = 700156;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700156, 4, 0, 'Spellfire Band', 0, 3, 0, 1, 5000, 1000,
    11, -1, -1, 20, 4,
    4, 5,  -- +5 Intellect
    3, 3,  -- +3 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'A ring infused with spellfire.', 5
);

-- Necklace: Spellfire Pendant
DELETE FROM item_template WHERE entry = 700157;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700157, 4, 0, 'Spellfire Pendant', 0, 3, 0, 1, 5000, 1000,
    2, -1, -1, 20, 4,
    4, 6,  -- +6 Intellect
    3, 3,  -- +3 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'A pendant infused with spellfire.', 5
);

