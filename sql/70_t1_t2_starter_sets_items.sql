-- ==================================================
-- Mortal Warcraft – T1/T2 Starter Sets (Item Templates)
-- Spec 77: Itemization - T1/T2 Starter Sets
-- Item ID Range: 700000-700999 (T1/T2 PvE gear)
-- ==================================================

-- Stat Type IDs: 1=STR, 2=AGI, 3=STA, 4=INT, 5=SPI

-- ==================================================
-- ARCHETYPE A: Frontier Bruiser
-- ==================================================

-- T1: Greycrag Militia Set
-- Item IDs: 700001-700008

-- Weapon: Greycrag Militia Blade (1H Sword)
DELETE FROM item_template WHERE entry = 700001;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700001, 2, 7, 'Greycrag Militia Blade', 0, 2, 0, 1, 5000, 1000,
    13, -1, -1, 10, 1,
    1, 8,  -- +8 Strength
    3, 4,  -- +4 Stamina
    2, 4,  -- +4 Agility
    3, 1, 'A sturdy militia-issue blade.', 1, 1
);

-- Helm: Militia Iron Coif
DELETE FROM item_template WHERE entry = 700002;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700002, 4, 3, 'Militia Iron Coif', 0, 2, 0, 1, 3000, 600,
    1, -1, -1, 10, 1,
    1, 4,  -- +4 Strength
    3, 2,  -- +2 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Standard militia head protection.', 5, 50
);

-- Chest: Militia Chain Hauberk
DELETE FROM item_template WHERE entry = 700003;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700003, 4, 3, 'Militia Chain Hauberk', 0, 2, 0, 1, 5000, 1000,
    5, -1, -1, 10, 1,
    1, 6,  -- +6 Strength
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Chain mail hauberk issued to militia.', 5, 120
);

-- Legs: Militia Chain Leggings
DELETE FROM item_template WHERE entry = 700004;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700004, 4, 3, 'Militia Chain Leggings', 0, 2, 0, 1, 4000, 800,
    7, -1, -1, 10, 1,
    1, 5,  -- +5 Strength
    3, 3,  -- +3 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Chain leggings for militia duty.', 5, 100
);

-- Gloves: Militia Grips
DELETE FROM item_template WHERE entry = 700005;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700005, 4, 3, 'Militia Grips', 0, 2, 0, 1, 2000, 400,
    10, -1, -1, 10, 1,
    1, 3,  -- +3 Strength
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Sturdy militia gloves.', 5, 40
);

-- Boots: Militia Marching Boots
DELETE FROM item_template WHERE entry = 700006;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700006, 4, 3, 'Militia Marching Boots', 0, 2, 0, 1, 2000, 400,
    8, -1, -1, 10, 1,
    1, 3,  -- +3 Strength
    3, 2,  -- +2 Stamina
    2, 1,  -- +1 Agility
    3, 1, 'Heavy boots for long patrols.', 5, 40
);

-- Ring: Iron-Signed Band
DELETE FROM item_template WHERE entry = 700007;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700007, 4, 0, 'Iron-Signed Band', 0, 2, 0, 1, 1500, 300,
    11, -1, -1, 10, 1,
    1, 2,  -- +2 Strength
    3, 2,  -- +2 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'A simple iron ring with militia markings.', 5
);

-- Necklace: Greycrag Oath Pendant
DELETE FROM item_template WHERE entry = 700008;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700008, 4, 0, 'Greycrag Oath Pendant', 0, 2, 0, 1, 2000, 400,
    2, -1, -1, 10, 1,
    1, 4,  -- +4 Strength
    3, 2,  -- +2 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'A pendant symbolizing loyalty to Greycrag.', 5
);

-- ==================================================
-- T2: Linebreaker Vanguard Set
-- Item IDs: 700010-700017
-- ==================================================

-- Weapon: Linebreaker War-Axe (2H Axe)
DELETE FROM item_template WHERE entry = 700010;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700010, 2, 1, 'Linebreaker War-Axe', 0, 3, 0, 1, 15000, 3000,
    17, -1, -1, 20, 4,
    1, 16, -- +16 Strength
    3, 6,  -- +6 Stamina
    2, 4,  -- +4 Agility
    3, 1, 'A heavy war-axe for breaking enemy lines.', 1, 1
);

-- Helm: Linebreaker War-Visor
DELETE FROM item_template WHERE entry = 700011;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700011, 4, 4, 'Linebreaker War-Visor', 0, 3, 0, 1, 8000, 1600,
    1, -1, -1, 20, 4,
    1, 6,  -- +6 Strength
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'A visored helm for frontline combat.', 6, 120
);

-- Chest: Linebreaker Bulwark Cuirass
DELETE FROM item_template WHERE entry = 700012;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700012, 4, 4, 'Linebreaker Bulwark Cuirass', 0, 3, 0, 1, 12000, 2400,
    5, -1, -1, 20, 4,
    1, 10, -- +10 Strength
    3, 6,  -- +6 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Heavy plate cuirass for breaking enemy formations.', 6, 200
);

-- Legs: Linebreaker March Greaves
DELETE FROM item_template WHERE entry = 700013;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700013, 4, 4, 'Linebreaker March Greaves', 0, 3, 0, 1, 10000, 2000,
    7, -1, -1, 20, 4,
    1, 8,  -- +8 Strength
    3, 6,  -- +6 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Plate greaves for long marches.', 6, 180
);

-- Gloves: Linebreaker Crusher Gauntlets
DELETE FROM item_template WHERE entry = 700014;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700014, 4, 4, 'Linebreaker Crusher Gauntlets', 0, 3, 0, 1, 6000, 1200,
    10, -1, -1, 20, 4,
    1, 5,  -- +5 Strength
    3, 3,  -- +3 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Heavy gauntlets for crushing blows.', 6, 80
);

-- Boots: Linebreaker Tread Boots
DELETE FROM item_template WHERE entry = 700015;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700015, 4, 4, 'Linebreaker Tread Boots', 0, 3, 0, 1, 6000, 1200,
    8, -1, -1, 20, 4,
    1, 5,  -- +5 Strength
    3, 3,  -- +3 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'Sturdy boots for frontline combat.', 6, 80
);

-- Ring: Vanguard Signet
DELETE FROM item_template WHERE entry = 700016;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700016, 4, 0, 'Vanguard Signet', 0, 3, 0, 1, 5000, 1000,
    11, -1, -1, 20, 4,
    1, 4,  -- +4 Strength
    3, 2,  -- +2 Stamina
    2, 2,  -- +2 Agility
    3, 1, 'A signet ring marking a true vanguard.', 5
);

-- Necklace: Vanguard Iron Torque
DELETE FROM item_template WHERE entry = 700017;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material
) VALUES (
    700017, 4, 0, 'Vanguard Iron Torque', 0, 3, 0, 1, 5000, 1000,
    2, -1, -1, 20, 4,
    1, 4,  -- +4 Strength
    3, 4,  -- +4 Stamina
    2, 1, 'A heavy iron torque for vanguards.', 5
);

-- ==================================================
-- ARCHETYPE B: Waywatcher Arcanist
-- ==================================================

-- T1: Port Meridian Adept Set
-- Item IDs: 700020-700027

-- Weapon: Adept's Cedar Staff
DELETE FROM item_template WHERE entry = 700020;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700020, 2, 10, 'Adept''s Cedar Staff', 0, 2, 0, 1, 6000, 1200,
    17, -1, -1, 10, 1,
    4, 8,  -- +8 Intellect
    5, 4,  -- +4 Spirit
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    4, 1, 'A simple staff for academy students.', 2, 2
);

-- Helm: Adept's Hood
DELETE FROM item_template WHERE entry = 700021;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700021, 4, 1, 'Adept''s Hood', 0, 2, 0, 1, 3000, 600,
    1, -1, -1, 10, 1,
    4, 4,  -- +4 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A scholar''s hood from Port Meridian.', 7, 20
);

-- Chest: Adept's Vestments
DELETE FROM item_template WHERE entry = 700022;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700022, 4, 1, 'Adept''s Vestments', 0, 2, 0, 1, 5000, 1000,
    5, -1, -1, 10, 1,
    4, 6,  -- +6 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    2, 2,  -- +2 Agility
    4, 1, 'Academy vestments for students.', 7, 40
);

-- Legs: Adept's Trousers
DELETE FROM item_template WHERE entry = 700023;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700023, 4, 1, 'Adept''s Trousers', 0, 2, 0, 1, 4000, 800,
    7, -1, -1, 10, 1,
    4, 4,  -- +4 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    2, 2,  -- +2 Agility
    4, 1, 'Comfortable trousers for study and travel.', 7, 35
);

-- Gloves: Adept's Grips
DELETE FROM item_template WHERE entry = 700024;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700024, 4, 1, 'Adept''s Grips', 0, 2, 0, 1, 2000, 400,
    10, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 1,  -- +1 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Light gloves for spellcasting.', 7, 15
);

-- Boots: Adept's Sandals
DELETE FROM item_template WHERE entry = 700025;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700025, 4, 1, 'Adept''s Sandals', 0, 2, 0, 1, 2000, 400,
    8, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 1,  -- +1 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'Simple sandals for walking and study.', 7, 15
);

-- Ring: Cedar-Focused Band
DELETE FROM item_template WHERE entry = 700026;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700026, 4, 0, 'Cedar-Focused Band', 0, 2, 0, 1, 1500, 300,
    11, -1, -1, 10, 1,
    4, 3,  -- +3 Intellect
    5, 1,  -- +1 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A ring that helps focus magical energy.', 5
);

-- Necklace: Port Meridian Focus Charm
DELETE FROM item_template WHERE entry = 700027;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700027, 4, 0, 'Port Meridian Focus Charm', 0, 2, 0, 1, 2000, 400,
    2, -1, -1, 10, 1,
    4, 4,  -- +4 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A charm that enhances magical focus.', 5
);

-- ==================================================
-- T2: Waywatcher's Pact Set
-- Item IDs: 700030-700037
-- ==================================================

-- Weapon: Waywatcher's Oaken Staff
DELETE FROM item_template WHERE entry = 700030;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, sheath
) VALUES (
    700030, 2, 10, 'Waywatcher''s Oaken Staff', 0, 3, 0, 1, 18000, 3600,
    17, -1, -1, 20, 4,
    4, 12, -- +12 Intellect
    5, 6,  -- +6 Spirit
    3, 4,  -- +4 Stamina
    3, 1, 'A staff for those who watch the frontier ways.', 2, 2
);

-- Helm: Waywatcher's Hood
DELETE FROM item_template WHERE entry = 700031;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700031, 4, 2, 'Waywatcher''s Hood', 0, 3, 0, 1, 8000, 1600,
    1, -1, -1, 20, 4,
    4, 6,  -- +6 Intellect
    5, 3,  -- +3 Spirit
    3, 3,  -- +3 Stamina
    3, 1, 'A hood for those who walk the frontier paths.', 8, 50
);

-- Chest: Waywatcher's Mantlecoat
DELETE FROM item_template WHERE entry = 700032;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700032, 4, 2, 'Waywatcher''s Mantlecoat', 0, 3, 0, 1, 12000, 2400,
    5, -1, -1, 20, 4,
    4, 8,  -- +8 Intellect
    5, 4,  -- +4 Spirit
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    4, 1, 'A coat for those who guard the frontier.', 8, 100
);

-- Legs: Waywatcher's Treadpants
DELETE FROM item_template WHERE entry = 700033;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3, stat_type4, stat_value4,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700033, 4, 2, 'Waywatcher''s Treadpants', 0, 3, 0, 1, 10000, 2000,
    7, -1, -1, 20, 4,
    4, 7,  -- +7 Intellect
    5, 3,  -- +3 Spirit
    3, 4,  -- +4 Stamina
    2, 2,  -- +2 Agility
    4, 1, 'Durable pants for long frontier journeys.', 8, 90
);

-- Gloves: Waywatcher's Grasp
DELETE FROM item_template WHERE entry = 700034;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700034, 4, 2, 'Waywatcher''s Grasp', 0, 3, 0, 1, 6000, 1200,
    10, -1, -1, 20, 4,
    4, 4,  -- +4 Intellect
    5, 2,  -- +2 Spirit
    3, 3,  -- +3 Stamina
    3, 1, 'Gloves for those who grasp the frontier ways.', 8, 40
);

-- Boots: Waywatcher's Boots
DELETE FROM item_template WHERE entry = 700035;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material, armor
) VALUES (
    700035, 4, 2, 'Waywatcher''s Boots', 0, 3, 0, 1, 6000, 1200,
    8, -1, -1, 20, 4,
    4, 4,  -- +4 Intellect
    5, 2,  -- +2 Spirit
    3, 3,  -- +3 Stamina
    3, 1, 'Boots for those who walk the frontier paths.', 8, 40
);

-- Ring: Pact Binder's Loop
DELETE FROM item_template WHERE entry = 700036;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2, stat_type3, stat_value3,
    StatsCount, bonding, description, Material
) VALUES (
    700036, 4, 0, 'Pact Binder''s Loop', 0, 3, 0, 1, 5000, 1000,
    11, -1, -1, 20, 4,
    4, 4,  -- +4 Intellect
    5, 2,  -- +2 Spirit
    3, 2,  -- +2 Stamina
    3, 1, 'A ring that binds one to the frontier pact.', 5
);

-- Necklace: Frontier Pact Charm
DELETE FROM item_template WHERE entry = 700037;
INSERT INTO item_template (
    entry, class, subclass, name, displayid, Quality, Flags, BuyCount, BuyPrice, SellPrice,
    InventoryType, AllowableClass, AllowableRace, ItemLevel, RequiredLevel,
    stat_type1, stat_value1, stat_type2, stat_value2,
    StatsCount, bonding, description, Material
) VALUES (
    700037, 4, 0, 'Frontier Pact Charm', 0, 3, 0, 1, 5000, 1000,
    2, -1, -1, 20, 4,
    4, 5,  -- +5 Intellect
    5, 3,  -- +3 Spirit
    2, 1, 'A charm symbolizing the frontier pact.', 5
);

