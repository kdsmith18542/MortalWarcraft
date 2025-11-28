-- ==================================================
-- Project Mortal Warcraft
-- Feature: PvP Item Requirements Template
-- Description: Creates PvP item requirements for existing Gladiator gear
-- Based on: docs/specs/35-mortal-pvp-vendors-and-rewards.md
-- 
-- NOTE: This is a template. You need to:
-- 1. Find actual item IDs from database or Wowhead
-- 2. Adjust rating requirements based on your balance
-- 3. Set appropriate costs
-- ==================================================

-- ==================================================
-- P1 GEAR (Entry Combatant - Starter Sets)
-- Rating: 0-1400 (no rating requirement)
-- ==================================================
-- Example: Gladiator's gear (Season 1)
-- INSERT INTO mortal_pvp_item_requirements 
-- (item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
-- VALUES
-- (42527, 'P1', 0, 7, 500, 100, 'Gladiator''s Greatsword - P1 Starter'),
-- (42528, 'P1', 0, 7, 500, 100, 'Gladiator''s Waraxe - P1 Starter');

-- ==================================================
-- P2 GEAR (Challenger - 1500+ Rating)
-- Rating: 1500-1699
-- ==================================================
-- Example: Deadly Gladiator gear (Season 2)
-- INSERT INTO mortal_pvp_item_requirements 
-- (item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
-- VALUES
-- (42600, 'P2', 1500, 7, 800, 200, 'Deadly Gladiator''s Greatsword - P2 (1500+)'),
-- (42601, 'P2', 1500, 7, 800, 200, 'Deadly Gladiator''s Waraxe - P2 (1500+)');

-- ==================================================
-- P3 GEAR (Challenger - 1700+ Rating)
-- Rating: 1700-1899
-- ==================================================
-- Example: Furious Gladiator gear (Season 3)
-- INSERT INTO mortal_pvp_item_requirements 
-- (item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
-- VALUES
-- (42650, 'P3', 1700, 7, 1200, 300, 'Furious Gladiator''s Greatsword - P3 (1700+)'),
-- (42651, 'P3', 1700, 2, 1200, 300, 'Furious Gladiator''s Greatsword - P3 (1700+ in 3v3)');

-- ==================================================
-- P4 GEAR (Challenger - 1900+ Rating)
-- Rating: 1900-2099
-- ==================================================
-- Example: Relentless Gladiator gear (Season 4)
-- INSERT INTO mortal_pvp_item_requirements 
-- (item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
-- VALUES
-- (42700, 'P4', 1900, 7, 1600, 400, 'Relentless Gladiator''s Greatsword - P4 (1900+)'),
-- (42701, 'P4', 1900, 2, 1600, 400, 'Relentless Gladiator''s Greatsword - P4 (1900+ in 3v3)');

-- ==================================================
-- P5 GEAR (Elite - 2100+ Rating)
-- Rating: 2100-2299
-- ==================================================
-- Example: Wrathful Gladiator gear (Season 5)
-- INSERT INTO mortal_pvp_item_requirements 
-- (item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
-- VALUES
-- (42750, 'P5', 2100, 2, 2000, 500, 'Wrathful Gladiator''s Greatsword - P5 (2100+ in 3v3)'),
-- (42751, 'P5', 2100, 2, 2000, 500, 'Wrathful Gladiator''s Waraxe - P5 (2100+ in 3v3)');

-- ==================================================
-- P6 GEAR (Elite - 2300+ Rating)
-- Rating: 2300+
-- ==================================================
-- Example: Wrathful Gladiator gear (Season 6 - Top Tier)
-- INSERT INTO mortal_pvp_item_requirements 
-- (item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
-- VALUES
-- (42800, 'P6', 2300, 2, 2500, 600, 'Wrathful Gladiator''s Greatsword - P6 (2300+ in 3v3)'),
-- (42801, 'P6', 2300, 2, 2500, 600, 'Wrathful Gladiator''s Waraxe - P6 (2300+ in 3v3)');

-- ==================================================
-- INSTRUCTIONS
-- ==================================================
-- To populate this:
-- 1. Query item_template for Gladiator gear:
--    SELECT entry, name, ItemLevel FROM item_template 
--    WHERE name LIKE '%Gladiator%' ORDER BY ItemLevel, name;
--
-- 2. Map items to P-tiers based on ItemLevel:
--    - P1: ItemLevel 80-100 (Gladiator)
--    - P2: ItemLevel 100-120 (Deadly Gladiator)
--    - P3: ItemLevel 120-140 (Furious Gladiator)
--    - P4: ItemLevel 140-160 (Relentless Gladiator)
--    - P5: ItemLevel 160-180 (Wrathful Gladiator)
--    - P6: ItemLevel 180+ (Wrathful Gladiator Heroic)
--
-- 3. Set rating requirements:
--    - P1: 0 (no requirement)
--    - P2: 1500
--    - P3: 1700
--    - P4: 1900
--    - P5: 2100
--    - P6: 2300
--
-- 4. Set bracket_mask:
--    - 1 = 2v2 only
--    - 2 = 3v3 only
--    - 4 = 5v5 only
--    - 7 = any bracket
--
-- 5. Set costs (tokens and credits)
--
-- 6. Assign items to vendors via npc_vendor table

SELECT 'PvP Item Requirements Template' as status,
       'This file contains template INSERT statements' as note,
       'Uncomment and populate with actual item IDs' as instruction;

