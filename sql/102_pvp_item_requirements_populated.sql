-- ==================================================
-- Project Mortal Warcraft
-- Feature: PvP Item Requirements - Populated
-- Description: Creates PvP item requirements for WotLK Gladiator gear
-- Based on: docs/specs/35-mortal-pvp-vendors-and-rewards.md
-- Data Source: item_template database
-- ==================================================

-- ==================================================
-- P1 GEAR (Entry Combatant - Starter Sets)
-- Rating: 0-1400 (no rating requirement)
-- ItemLevel: 200-213 (Savage/Hateful Gladiator)
-- ==================================================
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
SELECT 
    entry,
    'P1',
    0,
    7,  -- Any bracket
    500,
    100,
    CONCAT(name, ' - P1 Starter (no rating required)')
FROM item_template
WHERE (name LIKE '%Savage Gladiator%' OR name LIKE '%Hateful Gladiator%')
  AND ItemLevel >= 200 AND ItemLevel < 213
  AND Quality >= 3
  AND (Class = 2 OR Class = 4)  -- Weapons and Armor
ON DUPLICATE KEY UPDATE 
    rating_band_code = VALUES(rating_band_code),
    min_rating = VALUES(min_rating),
    cost_tokens = VALUES(cost_tokens),
    cost_credits = VALUES(cost_credits),
    notes = VALUES(notes);

-- ==================================================
-- P2 GEAR (Challenger - 1500+ Rating)
-- Rating: 1500-1699
-- ItemLevel: 213-232 (Deadly Gladiator)
-- ==================================================
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
SELECT 
    entry,
    'P2',
    1500,
    7,  -- Any bracket
    800,
    200,
    CONCAT(name, ' - P2 (1500+ rating)')
FROM item_template
WHERE name LIKE '%Deadly Gladiator%'
  AND ItemLevel >= 213 AND ItemLevel < 232
  AND Quality >= 3
  AND (Class = 2 OR Class = 4)  -- Weapons and Armor
ON DUPLICATE KEY UPDATE 
    rating_band_code = VALUES(rating_band_code),
    min_rating = VALUES(min_rating),
    cost_tokens = VALUES(cost_tokens),
    cost_credits = VALUES(cost_credits),
    notes = VALUES(notes);

-- ==================================================
-- P3 GEAR (Challenger - 1700+ Rating)
-- Rating: 1700-1899
-- ItemLevel: 232-245 (Furious Gladiator)
-- ==================================================
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
SELECT 
    entry,
    'P3',
    1700,
    2,  -- 3v3 bracket (primary)
    1200,
    300,
    CONCAT(name, ' - P3 (1700+ in 3v3)')
FROM item_template
WHERE name LIKE '%Furious Gladiator%'
  AND ItemLevel >= 232 AND ItemLevel < 245
  AND Quality >= 3
  AND (Class = 2 OR Class = 4)  -- Weapons and Armor
ON DUPLICATE KEY UPDATE 
    rating_band_code = VALUES(rating_band_code),
    min_rating = VALUES(min_rating),
    cost_tokens = VALUES(cost_tokens),
    cost_credits = VALUES(cost_credits),
    notes = VALUES(notes);

-- ==================================================
-- P4 GEAR (Challenger - 1900+ Rating)
-- Rating: 1900-2099
-- ItemLevel: 245-264 (Relentless Gladiator)
-- ==================================================
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
SELECT 
    entry,
    'P4',
    1900,
    2,  -- 3v3 bracket (primary)
    1600,
    400,
    CONCAT(name, ' - P4 (1900+ in 3v3)')
FROM item_template
WHERE name LIKE '%Relentless Gladiator%'
  AND ItemLevel >= 245 AND ItemLevel < 264
  AND Quality >= 3
  AND (Class = 2 OR Class = 4)  -- Weapons and Armor
ON DUPLICATE KEY UPDATE 
    rating_band_code = VALUES(rating_band_code),
    min_rating = VALUES(min_rating),
    cost_tokens = VALUES(cost_tokens),
    cost_credits = VALUES(cost_credits),
    notes = VALUES(notes);

-- ==================================================
-- P5 GEAR (Elite - 2100+ Rating)
-- Rating: 2100-2299
-- ItemLevel: 264+ (Wrathful Gladiator)
-- ==================================================
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
SELECT 
    entry,
    'P5',
    2100,
    2,  -- 3v3 bracket (primary)
    2000,
    500,
    CONCAT(name, ' - P5 (2100+ in 3v3)')
FROM item_template
WHERE name LIKE '%Wrathful Gladiator%'
  AND ItemLevel >= 264
  AND Quality >= 3
  AND (Class = 2 OR Class = 4)  -- Weapons and Armor
ON DUPLICATE KEY UPDATE 
    rating_band_code = VALUES(rating_band_code),
    min_rating = VALUES(min_rating),
    cost_tokens = VALUES(cost_tokens),
    cost_credits = VALUES(cost_credits),
    notes = VALUES(notes);

-- ==================================================
-- P6 GEAR (Elite - 2300+ Rating)
-- Rating: 2300+
-- ItemLevel: 264+ Heroic (Wrathful Gladiator Heroic)
-- Note: Using same items as P5 but with higher rating requirement
-- ==================================================
-- P6 uses same items as P5 but with higher rating
-- This would typically be Heroic versions, but for now we'll use
-- a subset of Wrathful items with 2300+ requirement
INSERT INTO mortal_pvp_item_requirements 
(item_entry, rating_band_code, min_rating, bracket_mask, cost_tokens, cost_credits, notes)
SELECT 
    entry,
    'P6',
    2300,
    2,  -- 3v3 bracket (primary)
    2500,
    600,
    CONCAT(name, ' - P6 (2300+ in 3v3)')
FROM item_template
WHERE name LIKE '%Wrathful Gladiator%'
  AND ItemLevel >= 264
  AND Quality = 4  -- Epic quality only for P6
  AND (Class = 2 OR Class = 4)  -- Weapons and Armor
  AND entry NOT IN (SELECT item_entry FROM mortal_pvp_item_requirements WHERE rating_band_code = 'P5')
LIMIT 50  -- Limit to avoid duplicates
ON DUPLICATE KEY UPDATE 
    rating_band_code = VALUES(rating_band_code),
    min_rating = VALUES(min_rating),
    cost_tokens = VALUES(cost_tokens),
    cost_credits = VALUES(cost_credits),
    notes = VALUES(notes);

-- ==================================================
-- SUMMARY
-- ==================================================
SELECT 
    'PvP Item Requirements' as summary,
    rating_band_code,
    COUNT(*) as item_count,
    MIN(min_rating) as min_rating,
    MAX(min_rating) as max_rating,
    AVG(cost_tokens) as avg_tokens,
    AVG(cost_credits) as avg_credits
FROM mortal_pvp_item_requirements
GROUP BY rating_band_code
ORDER BY 
    CASE rating_band_code
        WHEN 'P1' THEN 1
        WHEN 'P2' THEN 2
        WHEN 'P3' THEN 3
        WHEN 'P4' THEN 4
        WHEN 'P5' THEN 5
        WHEN 'P6' THEN 6
        ELSE 7
    END;

