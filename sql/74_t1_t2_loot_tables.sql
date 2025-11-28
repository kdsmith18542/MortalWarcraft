-- ==================================================
-- Mortal Warcraft – T1/T2 Loot Table Configurations
-- Spec 79: Drop Mapping for T1/T2 Gear Sets & Runes
-- Description: Maps T1/T2 gear sets to dungeon bosses, chests, and reference loot pools
-- ==================================================

-- ==================================================
-- REFERENCE LOOT TEMPLATES
-- ==================================================
-- Reference IDs 40000-40099 reserved for Mortal T1/T2 gear sets

-- Ref 40001: T1 Greycrag Militia Set Pool
-- Used by: Deadmines bosses, Task Board rewards, quest completion rewards
DELETE FROM reference_loot_template WHERE Entry = 40001;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40001, 700001, 0, 8.0, 0, 1, 1, 1, 1, 'Greycrag Militia Blade'),
(40001, 700002, 0, 12.0, 0, 1, 1, 1, 1, 'Militia Iron Coif'),
(40001, 700003, 0, 10.0, 0, 1, 1, 1, 1, 'Militia Chain Hauberk'),
(40001, 700004, 0, 10.0, 0, 1, 1, 1, 1, 'Militia Chain Leggings'),
(40001, 700005, 0, 12.0, 0, 1, 1, 1, 1, 'Militia Grips'),
(40001, 700006, 0, 12.0, 0, 1, 1, 1, 1, 'Militia Marching Boots'),
(40001, 700007, 0, 10.0, 0, 1, 1, 1, 1, 'Militia Iron Spaulders'),
(40001, 700008, 0, 8.0, 0, 1, 1, 1, 1, 'Militia Iron Belt');

-- Ref 40002: T2 Linebreaker Vanguard Set Pool
-- Used by: Shadowfang Keep, Scarlet Monastery, Warfront rewards
DELETE FROM reference_loot_template WHERE Entry = 40002;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40002, 700010, 0, 8.0, 0, 1, 1, 1, 1, 'Linebreaker Warblade'),
(40002, 700011, 0, 12.0, 0, 1, 1, 1, 1, 'Vanguard Greathelm'),
(40002, 700012, 0, 10.0, 0, 1, 1, 1, 1, 'Vanguard Battleplate'),
(40002, 700013, 0, 10.0, 0, 1, 1, 1, 1, 'Vanguard Legplates'),
(40002, 700014, 0, 12.0, 0, 1, 1, 1, 1, 'Vanguard Gauntlets'),
(40002, 700015, 0, 12.0, 0, 1, 1, 1, 1, 'Vanguard Sabatons'),
(40002, 700016, 0, 10.0, 0, 1, 1, 1, 1, 'Vanguard Shoulderplates'),
(40002, 700017, 0, 8.0, 0, 1, 1, 1, 1, 'Vanguard Girdle');

-- Ref 40003: T1 Port Meridian Adept Set Pool (Waywatcher Arcanist)
DELETE FROM reference_loot_template WHERE Entry = 40003;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40003, 700020, 0, 8.0, 0, 1, 1, 1, 1, 'Adept\'s Staff'),
(40003, 700021, 0, 12.0, 0, 1, 1, 1, 1, 'Adept\'s Cap'),
(40003, 700022, 0, 10.0, 0, 1, 1, 1, 1, 'Adept\'s Robes'),
(40003, 700023, 0, 10.0, 0, 1, 1, 1, 1, 'Adept\'s Leggings'),
(40003, 700024, 0, 12.0, 0, 1, 1, 1, 1, 'Adept\'s Gloves'),
(40003, 700025, 0, 12.0, 0, 1, 1, 1, 1, 'Adept\'s Boots'),
(40003, 700026, 0, 10.0, 0, 1, 1, 1, 1, 'Adept\'s Shoulderpads'),
(40003, 700027, 0, 8.0, 0, 1, 1, 1, 1, 'Adept\'s Belt');

-- Ref 40004: T2 Waywatcher's Pact Set Pool
DELETE FROM reference_loot_template WHERE Entry = 40004;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40004, 700030, 0, 8.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Staff'),
(40004, 700031, 0, 12.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Circlet'),
(40004, 700032, 0, 10.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Vestments'),
(40004, 700033, 0, 10.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Leggings'),
(40004, 700034, 0, 12.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Gloves'),
(40004, 700035, 0, 12.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Boots'),
(40004, 700036, 0, 10.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Shoulderpads'),
(40004, 700037, 0, 8.0, 0, 1, 1, 1, 1, 'Waywatcher\'s Belt');

-- Ref 40005: T1 Shrine Acolyte Set Pool (Sanctum Warden)
DELETE FROM reference_loot_template WHERE Entry = 40005;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40005, 700100, 0, 8.0, 0, 1, 1, 1, 1, 'Acolyte\'s Mace'),
(40005, 700101, 0, 12.0, 0, 1, 1, 1, 1, 'Acolyte\'s Cap'),
(40005, 700102, 0, 10.0, 0, 1, 1, 1, 1, 'Acolyte\'s Robes'),
(40005, 700103, 0, 10.0, 0, 1, 1, 1, 1, 'Acolyte\'s Leggings'),
(40005, 700104, 0, 12.0, 0, 1, 1, 1, 1, 'Acolyte\'s Gloves'),
(40005, 700105, 0, 12.0, 0, 1, 1, 1, 1, 'Acolyte\'s Boots'),
(40005, 700106, 0, 10.0, 0, 1, 1, 1, 1, 'Acolyte\'s Shoulderpads'),
(40005, 700107, 0, 8.0, 0, 1, 1, 1, 1, 'Acolyte\'s Belt');

-- Ref 40006: T2 Sanctum Warden's Regalia Set Pool
DELETE FROM reference_loot_template WHERE Entry = 40006;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40006, 700110, 0, 8.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Mace'),
(40006, 700111, 0, 12.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Crown'),
(40006, 700112, 0, 10.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Vestments'),
(40006, 700113, 0, 10.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Leggings'),
(40006, 700114, 0, 12.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Gloves'),
(40006, 700115, 0, 12.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Boots'),
(40006, 700116, 0, 10.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Shoulderpads'),
(40006, 700117, 0, 8.0, 0, 1, 1, 1, 1, 'Sanctum Warden\'s Belt');

-- Ref 40007: T1 Greenway Scout Set Pool (Longroad Ranger)
DELETE FROM reference_loot_template WHERE Entry = 40007;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40007, 700120, 0, 8.0, 0, 1, 1, 1, 1, 'Scout\'s Bow'),
(40007, 700121, 0, 12.0, 0, 1, 1, 1, 1, 'Scout\'s Cap'),
(40007, 700122, 0, 10.0, 0, 1, 1, 1, 1, 'Scout\'s Tunic'),
(40007, 700123, 0, 10.0, 0, 1, 1, 1, 1, 'Scout\'s Leggings'),
(40007, 700124, 0, 12.0, 0, 1, 1, 1, 1, 'Scout\'s Gloves'),
(40007, 700125, 0, 12.0, 0, 1, 1, 1, 1, 'Scout\'s Boots'),
(40007, 700126, 0, 10.0, 0, 1, 1, 1, 1, 'Scout\'s Shoulderpads'),
(40007, 700127, 0, 8.0, 0, 1, 1, 1, 1, 'Scout\'s Belt');

-- Ref 40008: T2 Longroad Tracker Set Pool
DELETE FROM reference_loot_template WHERE Entry = 40008;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40008, 700130, 0, 8.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Bow'),
(40008, 700131, 0, 12.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Cap'),
(40008, 700132, 0, 10.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Tunic'),
(40008, 700133, 0, 10.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Leggings'),
(40008, 700134, 0, 12.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Gloves'),
(40008, 700135, 0, 12.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Boots'),
(40008, 700136, 0, 10.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Shoulderpads'),
(40008, 700137, 0, 8.0, 0, 1, 1, 1, 1, 'Longroad Tracker\'s Belt');

-- Ref 40009: T1 Apprentice's Robes Set Pool (Spellfire Magus)
DELETE FROM reference_loot_template WHERE Entry = 40009;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40009, 700140, 0, 8.0, 0, 1, 1, 1, 1, 'Apprentice\'s Staff'),
(40009, 700141, 0, 12.0, 0, 1, 1, 1, 1, 'Apprentice\'s Cap'),
(40009, 700142, 0, 10.0, 0, 1, 1, 1, 1, 'Apprentice\'s Robes'),
(40009, 700143, 0, 10.0, 0, 1, 1, 1, 1, 'Apprentice\'s Leggings'),
(40009, 700144, 0, 12.0, 0, 1, 1, 1, 1, 'Apprentice\'s Gloves'),
(40009, 700145, 0, 12.0, 0, 1, 1, 1, 1, 'Apprentice\'s Boots'),
(40009, 700146, 0, 10.0, 0, 1, 1, 1, 1, 'Apprentice\'s Shoulderpads'),
(40009, 700147, 0, 8.0, 0, 1, 1, 1, 1, 'Apprentice\'s Belt');

-- Ref 40010: T2 Spellfire Adept Set Pool
DELETE FROM reference_loot_template WHERE Entry = 40010;
INSERT INTO reference_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40010, 700150, 0, 8.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Staff'),
(40010, 700151, 0, 12.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Circlet'),
(40010, 700152, 0, 10.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Robes'),
(40010, 700153, 0, 10.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Leggings'),
(40010, 700154, 0, 12.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Gloves'),
(40010, 700155, 0, 12.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Boots'),
(40010, 700156, 0, 10.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Shoulderpads'),
(40010, 700157, 0, 8.0, 0, 1, 1, 1, 1, 'Spellfire Adept\'s Belt');

-- ==================================================
-- CREATURE LOOT TEMPLATES
-- ==================================================
-- NOTE: Creature entry IDs are placeholders. Update with actual boss entry IDs from your database.

-- Deadmines (T1 Content) - Lower Layers
-- Boss: Rhahk'Zor (entry ~644) or similar Deadmines boss
-- Assign to appropriate Deadmines boss entry ID
-- DELETE FROM creature_loot_template WHERE Entry = <DEADMINES_BOSS_ENTRY> AND Item IN (700001, 700002, 700003, 700004, 700005, 700006, 700007, 700008);
-- INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
-- (<DEADMINES_BOSS_ENTRY>, 0, 40001, 25.0, 0, 1, 0, 1, 1, 'T1 Greycrag Militia Set Pool');

-- Shadowfang Keep (T2 Content) - Frontier Delve
-- Boss: Commander Springvale (entry ~4278) or Baron Silverlaine (entry ~3887)
-- Example for Commander Springvale:
-- DELETE FROM creature_loot_template WHERE Entry = 4278 AND (Item IN (700010, 700011, 700012, 700013, 700014, 700015, 700016, 700017) OR Reference = 40002);
-- INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
-- (4278, 0, 40002, 30.0, 0, 1, 0, 1, 1, 'T2 Linebreaker Vanguard Set Pool'),
-- (4278, 700011, 0, 12.0, 0, 1, 1, 1, 1, 'Vanguard Greathelm'),
-- (4278, 700015, 0, 10.0, 0, 1, 1, 1, 1, 'Vanguard Sabatons');

-- Baron Silverlaine (Shadowfang Keep)
-- DELETE FROM creature_loot_template WHERE Entry = 3887 AND (Item IN (700010, 700011, 700012, 700013, 700014, 700015, 700016, 700017) OR Reference = 40002);
-- INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
-- (3887, 0, 40002, 25.0, 0, 1, 0, 1, 1, 'T2 Linebreaker Vanguard Set Pool'),
-- (3887, 700012, 0, 10.0, 0, 1, 1, 1, 1, 'Vanguard Battleplate'),
-- (3887, 700010, 0, 8.0, 0, 1, 1, 1, 1, 'Linebreaker Warblade');

-- Scarlet Monastery (T2 Content) - Graveyard & Armory
-- Boss: Interrogator Vishas (entry ~3983) or Herod (entry ~3975)
-- Example for Herod (Armory):
-- DELETE FROM creature_loot_template WHERE Entry = 3975 AND (Item IN (700010, 700011, 700012, 700013, 700014, 700015, 700016, 700017) OR Reference = 40002);
-- INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
-- (3975, 0, 40002, 28.0, 0, 1, 0, 1, 1, 'T2 Linebreaker Vanguard Set Pool'),
-- (3975, 700013, 0, 10.0, 0, 1, 1, 1, 1, 'Vanguard Legplates'),
-- (3975, 700014, 0, 12.0, 0, 1, 1, 1, 1, 'Vanguard Gauntlets');

-- ==================================================
-- GAMEOBJECT LOOT TEMPLATES
-- ==================================================
-- For chests and containers in dungeons
-- NOTE: Gameobject entry IDs are placeholders. Update with actual chest entry IDs.

-- Deadmines Chest (T1 Content)
-- DELETE FROM gameobject_loot_template WHERE Entry = <DEADMINES_CHEST_ENTRY> AND (Item IN (700001, 700002, 700003, 700004, 700005, 700006, 700007, 700008) OR Reference = 40001);
-- INSERT INTO gameobject_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
-- (<DEADMINES_CHEST_ENTRY>, 0, 40001, 20.0, 0, 1, 0, 1, 1, 'T1 Greycrag Militia Set Pool');

-- Shadowfang Keep Chest (T2 Content)
-- DELETE FROM gameobject_loot_template WHERE Entry = <SHADOWFANG_CHEST_ENTRY> AND (Item IN (700010, 700011, 700012, 700013, 700014, 700015, 700016, 700017) OR Reference = 40002);
-- INSERT INTO gameobject_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
-- (<SHADOWFANG_CHEST_ENTRY>, 0, 40002, 25.0, 0, 1, 0, 1, 1, 'T2 Linebreaker Vanguard Set Pool');

-- ==================================================
-- NOTES
-- ==================================================
-- 1. Creature entry IDs need to be updated with actual boss entry IDs from your database
-- 2. Gameobject entry IDs need to be updated with actual chest/container entry IDs
-- 3. Quest rewards are handled separately in quest_template (see Spec 80)
-- 4. Task Board and Contract rewards are handled via Eluna scripts (see Spec 80)
-- 5. Vendor configurations are handled separately (see Spec 80)
-- 6. Drop rates can be adjusted based on testing and balance requirements
-- 7. Reference loot templates allow easy sharing of loot pools across multiple sources

