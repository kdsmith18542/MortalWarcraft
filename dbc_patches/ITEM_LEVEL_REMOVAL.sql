-- Mortal Warcraft - Remove Level Requirements from Items
-- Run this on the world database after applying standard AzerothCore updates
-- This removes level requirements and adds skill requirements based on item level

-- 1. Remove all level requirements from items
UPDATE item_template SET RequiredLevel = 0 WHERE RequiredLevel > 0;

-- 2. Add skill requirements based on item tier
-- Note: Skill ID 1001 is used for "Combat Mastery" (custom Mortal skill)
--       RequiredSkillRank = ItemLevel * 2 (approximate skill requirement)

-- T1 Gear (ItemLevel 60-70) - Requires ~120-140 Combat Mastery
UPDATE item_template 
SET RequiredSkill = 1001, RequiredSkillRank = (ItemLevel * 2)
WHERE ItemLevel BETWEEN 60 AND 70 AND RequiredSkill = 0;

-- T2 Gear (ItemLevel 71-80) - Requires ~142-160 Combat Mastery
UPDATE item_template 
SET RequiredSkill = 1001, RequiredSkillRank = (ItemLevel * 2)
WHERE ItemLevel BETWEEN 71 AND 80 AND RequiredSkill = 0;

-- T3/T4 Gear (ItemLevel 81-100) - Requires ~162-200 Combat Mastery
UPDATE item_template 
SET RequiredSkill = 1001, RequiredSkillRank = (ItemLevel * 2)
WHERE ItemLevel BETWEEN 81 AND 100 AND RequiredSkill = 0;

-- T5/T6 Gear (ItemLevel 101-120) - Requires ~202-240 Combat Mastery
UPDATE item_template 
SET RequiredSkill = 1001, RequiredSkillRank = (ItemLevel * 2)
WHERE ItemLevel BETWEEN 101 AND 120 AND RequiredSkill = 0;

-- T7+ Gear (ItemLevel 121+) - Requires 242+ Combat Mastery
UPDATE item_template 
SET RequiredSkill = 1001, RequiredSkillRank = (ItemLevel * 2)
WHERE ItemLevel > 120 AND RequiredSkill = 0;

-- 3. Remove class restrictions (optional - can be done via MortalClassRaceAudit.cpp instead)
-- UPDATE item_template SET AllowableClass = -1 WHERE AllowableClass > 0;
-- UPDATE item_template SET AllowableRace = -1 WHERE AllowableRace > 0;

-- 4. Verify changes
SELECT 
    COUNT(*) as total_items,
    COUNT(CASE WHEN RequiredLevel = 0 THEN 1 END) as no_level_req,
    COUNT(CASE WHEN RequiredSkill = 1001 THEN 1 END) as skill_req_added
FROM item_template;

-- Expected result: All items should have RequiredLevel = 0
-- High-tier items should have RequiredSkill = 1001

