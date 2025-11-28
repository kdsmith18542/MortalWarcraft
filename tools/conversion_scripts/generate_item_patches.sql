-- ==================================================
-- Mortal Warcraft Item Conversion Patches
-- Generated from mortal_item_tags
-- This script applies item conversions based on classification
-- ==================================================

-- Disable items marked as DISABLED
UPDATE item_template it
INNER JOIN mortal_item_tags mit ON it.entry = mit.item_id
SET it.Flags = it.Flags | 0x00000008  -- ITEM_FLAG_NO_PICKUP (disable)
WHERE mit.usage_policy = 'DISABLED';

-- Mark APPEARANCE_ONLY items (can be used for transmog but not equipped)
UPDATE item_template it
INNER JOIN mortal_item_tags mit ON it.entry = mit.item_id
SET it.Flags = it.Flags | 0x00000010,  -- ITEM_FLAG_HAS_LOOT (appearance only)
    it.Quality = 0  -- Common quality for appearance items
WHERE mit.usage_policy = 'APPEARANCE_ONLY';

-- Update item levels to match Mortal tiers (optional - can be done manually)
-- T5 items: ilvl 245+
-- T4 items: ilvl 200-244
-- T3 items: ilvl 180-199
-- T2 items: ilvl 150-179
-- T1 items: ilvl < 150
UPDATE item_template it
INNER JOIN mortal_item_tags mit ON it.entry = mit.item_id
SET it.ItemLevel = CASE
    WHEN mit.mortal_tier = 5 THEN GREATEST(it.ItemLevel, 245)
    WHEN mit.mortal_tier = 4 THEN GREATEST(it.ItemLevel, 200)
    WHEN mit.mortal_tier = 3 THEN GREATEST(it.ItemLevel, 180)
    WHEN mit.mortal_tier = 2 THEN GREATEST(it.ItemLevel, 150)
    WHEN mit.mortal_tier = 1 THEN LEAST(it.ItemLevel, 149)
    ELSE it.ItemLevel
END
WHERE mit.mortal_tier IS NOT NULL;

-- Mark mount items for Living Mounts system
UPDATE item_template it
INNER JOIN mortal_item_tags mit ON it.entry = mit.item_id
SET it.Flags = it.Flags | 0x00000020,  -- ITEM_FLAG_REFUNDABLE (mount flag)
    it.Bonding = 0  -- No binding for mount reins
WHERE mit.category = 'MOUNT_REINS';

-- Log conversion statistics
INSERT INTO mortal_conversion_stats (stat_key, stat_value, last_updated, notes)
VALUES ('items_patched', 
        (SELECT COUNT(*) FROM mortal_item_tags WHERE usage_policy != 'DISABLED'),
        UNIX_TIMESTAMP(),
        'Items tagged and tiered')
ON DUPLICATE KEY UPDATE
    stat_value = VALUES(stat_value),
    last_updated = VALUES(last_updated),
    notes = VALUES(notes);

