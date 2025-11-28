-- ==================================================
-- Project Mortal Warcraft
-- Feature: Extract ICC Boss Spells from Database
-- Description: Queries creature_template_spell to find actual spell IDs used by ICC bosses
-- This gives us the REAL spell IDs we should use for scaling
-- ==================================================

-- ICC Boss Creature Entries
-- Source: https://www.wowhead.com/wotlk/zone=4817/icecrown-citadel

-- Extract all spells for ICC bosses
SELECT 
    'ICC Boss Spells' as source,
    ct.entry as creature_id,
    ct.name as creature_name,
    cts.`Index` as spell_index,
    cts.Spell as spell_id,
    s.Name_Lang_enUS as spell_name,
    CASE 
        WHEN s.Name_Lang_enUS IS NULL THEN 'Server-side spell (no client entry)'
        ELSE 'Client spell'
    END as spell_type
FROM creature_template ct
INNER JOIN creature_template_spell cts ON ct.entry = cts.CreatureID
LEFT JOIN spell_dbc s ON cts.Spell = s.ID
WHERE ct.entry IN (
    -- ICC Bosses (Normal)
    36612,  -- Lord Marrowgar
    36855,  -- Lady Deathwhisper
    37813,  -- Deathbringer Saurfang
    36626,  -- Festergut
    36627,  -- Rotface
    36678,  -- Professor Putricide
    37970,  -- Blood-Queen Lana'thel
    38433,  -- Sindragosa
    36597,  -- The Lich King
    36789   -- Valithria Dreamwalker
)
ORDER BY ct.entry, cts.`Index`;

-- Summary: Count spells per boss
SELECT 
    ct.name as boss_name,
    COUNT(*) as total_spells,
    SUM(CASE WHEN s.Name_Lang_enUS IS NOT NULL THEN 1 ELSE 0 END) as client_spells,
    SUM(CASE WHEN s.Name_Lang_enUS IS NULL THEN 1 ELSE 0 END) as server_side_spells
FROM creature_template ct
INNER JOIN creature_template_spell cts ON ct.entry = cts.CreatureID
LEFT JOIN spell_dbc s ON cts.Spell = s.ID
WHERE ct.entry IN (36612, 36855, 37813, 36626, 36627, 36678, 37970, 38433, 36597, 36789)
GROUP BY ct.entry, ct.name
ORDER BY ct.name;

