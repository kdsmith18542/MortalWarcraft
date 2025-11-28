-- ==================================================
-- Mortal Warcraft Spell Conversion Patches
-- Generated from mortal_spell_tags
-- This script applies spell conversions based on classification
-- ==================================================

-- Disable REMOVED spells (prevent learning)
UPDATE spell_template st
INNER JOIN mortal_spell_tags mst ON st.Id = mst.spell_id
SET st.Attributes = st.Attributes | 0x00000080  -- SPELL_ATTR0_NOT_SHAPESHIFT (prevent learning)
WHERE mst.category = 'REMOVED';

-- Note: PvP flags and modifiers are applied at runtime via C++ hooks
-- Duration caps and coefficient modifiers are handled in MortalSpellLibrary

-- Mark rank spells for consolidation (lower ranks point to canonical)
UPDATE spell_template st
INNER JOIN mortal_spell_rank_map msrm ON st.Id = msrm.spell_id
SET st.Attributes = st.Attributes | 0x00000080  -- Prevent direct learning
WHERE msrm.spell_id != msrm.canonical_spell_id;

-- Update trainers to only teach canonical spell ranks
-- (This would require trainer_spell table updates - placeholder)
-- UPDATE trainer_spell ts
-- INNER JOIN mortal_spell_rank_map msrm ON ts.spell = msrm.spell_id
-- SET ts.spell = msrm.canonical_spell_id
-- WHERE msrm.spell_id != msrm.canonical_spell_id;

-- Log conversion statistics
INSERT INTO mortal_conversion_stats (stat_key, stat_value, last_updated, notes)
VALUES ('spells_patched', 
        (SELECT COUNT(*) FROM mortal_spell_tags WHERE category != 'REMOVED'),
        UNIX_TIMESTAMP(),
        'Spells tagged and categorized')
ON DUPLICATE KEY UPDATE
    stat_value = VALUES(stat_value),
    last_updated = VALUES(last_updated),
    notes = VALUES(notes);

