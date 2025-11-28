-- Systems Audit Fix #6: Remove Level Requirements from Items
-- "Requires Level 60" prevents equipping gear in Level 25 Cap system
-- Set all RequiredLevel to 1 (minimum)

UPDATE `item_template` 
SET `RequiredLevel` = 1 
WHERE `RequiredLevel` > 1;

-- Log the change
SELECT CONCAT('Removed level requirements from ', ROW_COUNT(), ' items') AS result;

