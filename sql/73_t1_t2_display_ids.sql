-- ==================================================
-- Mortal Warcraft – T1/T2 Display ID Mapping
-- Spec 26: Gear Visual Mapping
-- Maps T1 items to T7 (Heroes') visuals
-- Maps T2 items to T8 (Ulduar) visuals
-- ==================================================

-- Based on Spec 26:
-- T1 (Greycrag Militia) -> T7 (Heroes') visuals
-- T2 (Linebreaker Vanguard) -> T8 (Ulduar) visuals

-- ==================================================
-- T1: Greycrag Militia Set (Frontier Bruiser)
-- Using T7 Heroes' visuals
-- ==================================================

-- Weapon: Greycrag Militia Blade (1H Sword)
-- Using a simple low-level sword model (placeholder - should use appropriate weapon model)
UPDATE item_template SET displayid = 13488 WHERE entry = 700001;

-- Helm: Militia Iron Coif (Mail/Plate hybrid - using T7 Mail Helm)
UPDATE item_template SET displayid = 57068 WHERE entry = 700002; -- Heroes' Earthshatter Helm

-- Chest: Militia Chain Hauberk (Mail - using T7 Mail Chest)
UPDATE item_template SET displayid = 57023 WHERE entry = 700003; -- Heroes' Earthshatter Chestguard

-- Legs: Militia Chain Leggings (Mail - using T7 Mail Legs if available, or chest model)
UPDATE item_template SET displayid = 57023 WHERE entry = 700004; -- Using chest model as placeholder

-- Gloves: Militia Chain Gauntlets (Mail - using T7 Mail Gloves)
UPDATE item_template SET displayid = 57066 WHERE entry = 700005; -- Heroes' Earthshatter Gloves

-- Boots: Militia Iron Greaves (Mail/Plate - using T7 Mail Boots if available)
UPDATE item_template SET displayid = 57066 WHERE entry = 700006; -- Using gloves model as placeholder

-- Shoulders: Militia Iron Spaulders (Mail/Plate - using T7 Mail Shoulders)
UPDATE item_template SET displayid = 57071 WHERE entry = 700007; -- Heroes' Earthshatter Shoulderpads

-- Belt: Militia Iron Belt (Mail/Plate - using simple belt model)
UPDATE item_template SET displayid = 57066 WHERE entry = 700008; -- Placeholder

-- ==================================================
-- T2: Linebreaker Vanguard Set (Frontier Bruiser)
-- Using T8 Ulduar visuals
-- ==================================================

-- Weapon: Linebreaker Warblade (2H Sword)
-- Using a mid-level 2H sword model (placeholder)
UPDATE item_template SET displayid = 13488 WHERE entry = 700010;

-- Helm: Vanguard Greathelm (Plate - using T8 Plate Helm if available, or T7)
UPDATE item_template SET displayid = 54403 WHERE entry = 700011; -- Heroes' Dreadnaught Helmet (T7, placeholder for T8)

-- Chest: Vanguard Battleplate (Plate - using T8 Plate Chest if available, or T7)
UPDATE item_template SET displayid = 55369 WHERE entry = 700012; -- Heroes' Dreadnaught Battleplate (T7, placeholder for T8)

-- Legs: Vanguard Legplates (Plate - using T8 Plate Legs if available, or T7)
UPDATE item_template SET displayid = 55376 WHERE entry = 700013; -- Heroes' Dreadnaught Legplates (T7, placeholder for T8)

-- Gloves: Vanguard Gauntlets (Plate - using T8 Plate Gloves if available, or T7)
UPDATE item_template SET displayid = 54419 WHERE entry = 700014; -- Heroes' Redemption Gloves (T7, placeholder for T8)

-- Boots: Vanguard Sabatons (Plate - using T8 Plate Boots if available, or T7)
UPDATE item_template SET displayid = 54419 WHERE entry = 700015; -- Placeholder

-- Shoulders: Vanguard Shoulderplates (Plate - using T8 Plate Shoulders if available, or T7)
UPDATE item_template SET displayid = 56214 WHERE entry = 700016; -- Heroes' Dreadnaught Shoulderplates (T7, placeholder for T8)

-- Belt: Vanguard Girdle (Plate - using simple belt model)
UPDATE item_template SET displayid = 54419 WHERE entry = 700017; -- Placeholder

-- ==================================================
-- T1: Port Meridian Adept Set (Waywatcher Arcanist)
-- Using T7 Cloth visuals
-- ==================================================

-- Weapon: Adept's Staff (Staff)
UPDATE item_template SET displayid = 13488 WHERE entry = 700020; -- Placeholder

-- Helm: Adept's Cap (Cloth - using T7 Cloth Helm if available)
UPDATE item_template SET displayid = 56597 WHERE entry = 700021; -- Heroes' Frostfire Shoulderpads (placeholder for helm)

-- Chest: Adept's Robes (Cloth - using T7 Cloth Chest if available)
UPDATE item_template SET displayid = 56597 WHERE entry = 700022; -- Placeholder

-- Legs: Adept's Leggings (Cloth - using T7 Cloth Legs if available)
UPDATE item_template SET displayid = 56597 WHERE entry = 700023; -- Placeholder

-- Gloves: Adept's Gloves (Cloth - using T7 Cloth Gloves)
UPDATE item_template SET displayid = 57016 WHERE entry = 700024; -- Heroes' Frostfire Gloves

-- Boots: Adept's Boots (Cloth - using T7 Cloth Boots if available)
UPDATE item_template SET displayid = 57016 WHERE entry = 700025; -- Placeholder

-- Shoulders: Adept's Shoulderpads (Cloth - using T7 Cloth Shoulders)
UPDATE item_template SET displayid = 56597 WHERE entry = 700026; -- Heroes' Frostfire Shoulderpads

-- Belt: Adept's Belt (Cloth - using simple belt model)
UPDATE item_template SET displayid = 57016 WHERE entry = 700027; -- Placeholder

-- ==================================================
-- T2: Waywatcher's Pact Set (Waywatcher Arcanist)
-- Using T8 Cloth visuals (placeholder with T7)
-- ==================================================

-- Weapon: Waywatcher's Staff (Staff)
UPDATE item_template SET displayid = 13488 WHERE entry = 700030; -- Placeholder

-- Helm: Waywatcher's Circlet (Cloth - using T8 Cloth Helm if available)
UPDATE item_template SET displayid = 54302 WHERE entry = 700031; -- Heroes' Shoulderpads of Faith (placeholder)

-- Chest: Waywatcher's Vestments (Cloth - using T8 Cloth Chest if available)
UPDATE item_template SET displayid = 54302 WHERE entry = 700032; -- Placeholder

-- Legs: Waywatcher's Leggings (Cloth - using T8 Cloth Legs if available)
UPDATE item_template SET displayid = 54302 WHERE entry = 700033; -- Placeholder

-- Gloves: Waywatcher's Gloves (Cloth - using T8 Cloth Gloves if available)
UPDATE item_template SET displayid = 54422 WHERE entry = 700034; -- Heroes' Gloves of Faith (placeholder)

-- Boots: Waywatcher's Boots (Cloth - using T8 Cloth Boots if available)
UPDATE item_template SET displayid = 54422 WHERE entry = 700035; -- Placeholder

-- Shoulders: Waywatcher's Shoulderpads (Cloth - using T8 Cloth Shoulders if available)
UPDATE item_template SET displayid = 54302 WHERE entry = 700036; -- Heroes' Shoulderpads of Faith (placeholder)

-- Belt: Waywatcher's Belt (Cloth - using simple belt model)
UPDATE item_template SET displayid = 54422 WHERE entry = 700037; -- Placeholder

-- ==================================================
-- NOTE: These are initial mappings using available T7/T8 display IDs
-- Some slots may need adjustment once full T8 sets are identified
-- Weapon models should be replaced with appropriate weapon display IDs
-- Belt models are placeholders and should be replaced with proper belt display IDs
-- ==================================================

