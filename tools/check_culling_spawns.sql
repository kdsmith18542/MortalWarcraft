-- Investigation Query for Issue #23830: Culling of Stratholme Wave Spawns
-- Run with: mysql -h127.0.0.1 -uroot -p realm2_world < check_culling_spawns.sql

-- Map 595 = Culling of Stratholme

-- Get all creature spawns in Culling of Stratholme
SELECT 
    c.id AS guid,
    c.id1 AS entry,
    ct.name,
    c.map,
    c.position_x,
    c.position_y,
    c.position_z,
    c.orientation,
    c.spawntimesecs,
    c.curhealth,
    c.curmana
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 595
ORDER BY c.position_x, c.position_y
LIMIT 200;

-- Check wave NPCs specifically (the ones that spawn in waves)
SELECT 
    c.id AS guid,
    c.id1 AS entry,
    ct.name,
    c.position_x,
    c.position_y,
    c.position_z,
    c.orientation
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 595
  AND c.id1 IN (
    27737,  -- Risen Zombie
    28249,  -- Devouring Ghoul
    28200,  -- Dark Necromancer
    28199,  -- Tomb Stalker
    27734,  -- Crypt Fiend
    28201,  -- Bile Golem
    27729,  -- Enraging Ghoul
    27736   -- Patchwork Construct
  )
ORDER BY c.id1, c.position_x;

-- Count spawns per NPC type
SELECT 
    c.id1 AS entry,
    ct.name,
    COUNT(*) AS spawn_count
FROM creature c
JOIN creature_template ct ON c.id1 = ct.entry
WHERE c.map = 595
  AND c.id1 IN (27737, 28249, 28200, 28199, 27734, 28201, 27729, 27736)
GROUP BY c.id1, ct.name
ORDER BY c.id1;

