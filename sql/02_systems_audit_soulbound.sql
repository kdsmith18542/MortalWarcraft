-- Systems Audit Fix #1: Remove Soulbound Items
-- Prevents "Full Loot" mechanics from working
-- Preserves Quest Items (bonding = 4)

UPDATE `item_template` 
SET `bonding` = 0 
WHERE `bonding` != 4 
  AND `bonding` != 0;

-- Log the change
SELECT CONCAT('Removed soulbound from ', ROW_COUNT(), ' items') AS result;

