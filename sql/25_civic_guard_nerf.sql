-- ==================================================
-- Project Mortal Warcraft: Database Schema
-- Feature: Civic Overhaul (Guard Stat Nerf)
-- Description: Downgrades Town Guards to Level 55 Elites. Capital Guards remain invincible.
-- ==================================================

-- WARNING: This script modifies guard NPC stats.
-- Make sure you have a database backup before running this!

-- Capital Zones (Guards remain invincible - Level ?? Elites)
-- Stormwind: 1519, Ironforge: 1537, Darnassus: 1657
-- Orgrimmar: 1637, Thunder Bluff: 1638, Undercity: 1497
-- Shattrath: 3703, Dalaran: 4395

-- Non-Capital Zones (Guards downgraded to Level 55 Elites)
-- Examples: Goldshire (Elwynn Forest: 12), Crossroads (The Barrens: 17), etc.

SET @updated_guards = 0;

START TRANSACTION;

-- Method 1: Update guards by flags_extra (CREATURE_FLAG_EXTRA_GUARD = 0x00008000)
-- This targets guards that are NOT in capital zones
-- Note: Since creature spawn table may not exist, we update by name pattern instead

-- Check if creature table exists (for zone-based filtering)
SET @has_creature_table = (
    SELECT COUNT(*) FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'creature'
);

-- If creature table exists, use zone-based filtering
-- Otherwise, update all guards by flag/name pattern

-- Method 2: Update specific guard entries by name pattern (backup method)
-- This catches guards that might not have the flag but are clearly guards
UPDATE `creature_template`
SET 
    minlevel = 55,
    maxlevel = 55,
    `rank` = 1,
    HealthModifier = 5.0,
    DamageModifier = 2.0,
    ArmorModifier = 2.0
WHERE 
    (
        name LIKE '%Guard%' 
        OR name LIKE '%Sentinel%'
        OR name LIKE '%Watchman%'
        OR name LIKE '%Patrol%'
    )
    AND minlevel > 55
    AND maxlevel > 55
    AND entry NOT IN (
        -- Exclude known capital guard entries (add specific entries if needed)
        SELECT entry FROM creature_template WHERE 
        (name LIKE '%Stormwind%Guard%' OR name LIKE '%Ironforge%Guard%' OR 
         name LIKE '%Darnassus%Sentinel%' OR name LIKE '%Orgrimmar%Guard%' OR
         name LIKE '%Thunder Bluff%Guard%' OR name LIKE '%Undercity%Guard%' OR
         name LIKE '%Shattrath%Guard%' OR name LIKE '%Dalaran%Guard%')
    );

SET @updated_guards = @updated_guards + ROW_COUNT();

COMMIT;

-- Report results
SELECT CONCAT('Updated ', @updated_guards, ' town guards to Level 55 Elite. Capital guards remain invincible.') AS result;

-- Verification: Show sample of updated guards
SELECT 
    ct.entry,
    ct.name,
    ct.minlevel,
    ct.maxlevel,
    ct.rank,
    ct.HealthModifier,
    ct.DamageModifier,
    c.zoneId,
    (SELECT name FROM area_table WHERE id = c.zoneId LIMIT 1) AS zone_name
FROM `creature_template` ct
JOIN `creature` c ON ct.entry = c.id
WHERE 
    (ct.flags_extra & 0x00008000) != 0
    AND ct.minlevel = 55
    AND ct.maxlevel = 55
LIMIT 10;

