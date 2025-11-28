-- Systems Audit Fix #11: Delete Heirloom Gear
-- Scaling gear removes the need for crafting and loot
-- Heirloom items are identified by:
-- 1. Account-bound flag (ITEM_FLAG_IS_BOUND_TO_ACCOUNT = 0x08000000)
-- 2. Equipment items (Class 2 = Weapons, Class 4 = Armor)
-- 3. Have scaling stats (ScalingStatDistribution > 0)

-- Delete heirloom items from item_template
DELETE FROM `item_template`
WHERE (`Flags` & 0x08000000) != 0  -- Account-bound flag
  AND `Class` IN (2, 4)             -- Weapons and Armor only
  AND `ScalingStatDistribution` > 0 -- Has level scaling
  AND `Class` != 12;                 -- Exclude quest items

-- Also remove from vendor lists (npc_vendor)
DELETE FROM `npc_vendor`
WHERE `item` IN (
    SELECT `entry` FROM `item_template`
    WHERE (`Flags` & 0x08000000) != 0
      AND `Class` IN (2, 4)
      AND `ScalingStatDistribution` > 0
      AND `Class` != 12
);

-- Log the change
SELECT CONCAT('Deleted ', ROW_COUNT(), ' heirloom items') AS result;

