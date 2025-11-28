-- Systems Audit Fix #3: Disable Flight Masters (Taxis)
-- Bypasses PvP zones; trivializes Regional Banking trade runs
-- Remove gossip flag from all flight master NPCs

-- Find all NPCs with flight master flag (npcflag = 8192 or has flag in npcflag)
UPDATE `creature_template` 
SET `npcflag` = `npcflag` & ~8192 
WHERE `npcflag` & 8192 != 0;

-- Also remove from creature table (for spawned NPCs)
UPDATE `creature` c
INNER JOIN `creature_template` ct ON c.id = ct.entry
SET c.npcflag = c.npcflag & ~8192
WHERE c.npcflag & 8192 != 0;

-- Log the change
SELECT CONCAT('Disabled flight masters: ', 
  (SELECT COUNT(*) FROM creature_template WHERE npcflag & 8192 = 0 AND npcflag != 0)
) AS result;

