-- Systems Audit Fix #5: Remove Talent Points
-- Talents are linked to Class IDs and incompatible with classless system
-- Unlearn all talent points for all characters

-- Clear talent points
UPDATE `character_talent` 
SET `talentId` = 0, `currentRank` = 0;

-- Clear talent spell records
DELETE FROM `character_spell` 
WHERE `spell` IN (
  SELECT `spell` FROM `talent` WHERE `TalentID` > 0
);

-- Log the change
SELECT CONCAT('Cleared talents from all characters') AS result;

