-- ==================================================
-- Project Mortal Warcraft
-- Feature: Spell ID Verification Script
-- Description: Verifies spell IDs from Wowhead against database
-- Usage: Run this to check if spell IDs exist and match names
-- ==================================================

-- Check if spell IDs from our ICC scaling script exist
SELECT 
    'Checking ICC Spell IDs' as check_type,
    ID as spell_id,
    Name_Lang_enUS as spell_name,
    CASE 
        WHEN ID IS NULL THEN 'MISSING'
        WHEN Name_Lang_enUS IS NULL THEN 'EXISTS (no name)'
        ELSE 'EXISTS'
    END as status
FROM spell_dbc
WHERE ID IN (
    -- Lich King
    69409, 72350, 72262,
    -- Marrowgar
    69055, 69076, 69057,
    -- Deathwhisper
    71001, 71237,
    -- Gunship
    70161, 70116,
    -- Saurfang
    72293, 72410,
    -- Rotface
    69774, 69508,
    -- Festergut
    69195, 69279,
    -- Putricide
    70341, 70475,
    -- Blood Prince
    72037, 72039,
    -- Lana'thel
    71446, 71478,
    -- Valithria
    70115, 70117,
    -- Sindragosa
    70126, 70127, 69762
)
ORDER BY ID;

-- Search for spell names to find correct IDs
SELECT 
    'Searching for spell names' as check_type,
    ID as spell_id,
    Name_Lang_enUS as spell_name
FROM spell_dbc
WHERE Name_Lang_enUS LIKE '%Soul Reaper%'
   OR Name_Lang_enUS LIKE '%Bone Storm%'
   OR Name_Lang_enUS LIKE '%Saber Lash%'
   OR Name_Lang_enUS LIKE '%Quake%' AND ID > 69000
   OR Name_Lang_enUS LIKE '%Fury of Frostmourne%'
   OR Name_Lang_enUS LIKE '%Death and Decay%' AND ID > 70000
   OR Name_Lang_enUS LIKE '%Frostbolt%' AND ID > 70000
ORDER BY ID
LIMIT 30;

-- Check creature spells for ICC bosses
SELECT 
    'ICC Boss Spells' as check_type,
    ct.entry as creature_id,
    ct.name as creature_name,
    cts.Spell as spell_id,
    s.Name_Lang_enUS as spell_name
FROM creature_template ct
INNER JOIN creature_template_spell cts ON ct.entry = cts.CreatureID
LEFT JOIN spell_dbc s ON cts.Spell = s.ID
WHERE ct.entry IN (
    36612,  -- Lord Marrowgar
    36597,  -- The Lich King (ICC)
    36855,  -- Lady Deathwhisper
    37813,  -- Deathbringer Saurfang
    36626,  -- Festergut
    36627,  -- Rotface
    36678,  -- Professor Putricide
    37970,  -- Blood-Queen Lana'thel
    38433,  -- Sindragosa
    36789   -- Valithria Dreamwalker
)
ORDER BY ct.entry, cts.`Index`
LIMIT 50;

