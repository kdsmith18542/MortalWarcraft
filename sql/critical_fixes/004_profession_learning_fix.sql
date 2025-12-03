-- ============================================================================
-- CRITICAL FIX #4: Profession Learning Command Bug
-- ============================================================================
-- Issue: https://github.com/azerothcore/azerothcore-wotlk/issues/2330
-- Description: .learn all recipes command breaks profession system
-- Impact: Players can't unlearn professions, can learn unlimited professions
-- ============================================================================

-- This is primarily a CORE bug with the .learn command, but we can add safeguards

-- Add a stored procedure to clean up broken profession states
DELIMITER //

DROP PROCEDURE IF EXISTS `fix_character_professions`//

CREATE PROCEDURE `fix_character_professions`(IN char_guid INT)
BEGIN
    DECLARE prof_count INT;
    
    -- Count how many professions the character has
    SELECT COUNT(*) INTO prof_count
    FROM character_skills
    WHERE guid = char_guid
    AND skill IN (
        164,  -- Blacksmithing
        165,  -- Leatherworking
        171,  -- Alchemy
        182,  -- Herbalism
        186,  -- Mining
        197,  -- Tailoring
        202,  -- Engineering
        333,  -- Enchanting
        393,  -- Skinning
        755,  -- Jewelcrafting
        773   -- Inscription
    );
    
    -- If character has more than 2 primary professions, log to server console
    IF prof_count > 2 THEN
        -- Log the issue (using a simple approach that doesn't require gm_tickets table)
        -- Server logs will show this in the MySQL general log if enabled
        -- Alternatively, you can create a custom logging table
        SELECT CONCAT('WARNING: Character GUID ', char_guid, ' has ', prof_count, ' professions - exceeds limit of 2') AS profession_warning;
    END IF;
    
    -- Remove duplicate profession entries
    DELETE cs1 FROM character_skills cs1
    INNER JOIN character_skills cs2 
    WHERE cs1.guid = char_guid
    AND cs2.guid = char_guid
    AND cs1.skill = cs2.skill
    AND cs1.value < cs2.value;
    
END//

DELIMITER ;

-- ============================================================================
-- PREVENTION MEASURES
-- ============================================================================

-- Add a trigger to prevent more than 2 primary professions
DELIMITER //

DROP TRIGGER IF EXISTS `prevent_excess_professions`//

CREATE TRIGGER `prevent_excess_professions`
BEFORE INSERT ON `character_skills`
FOR EACH ROW
BEGIN
    DECLARE prof_count INT;
    DECLARE error_msg VARCHAR(255);
    
    -- Define primary profession IDs
    -- Blacksmithing(164), Leatherworking(165), Alchemy(171), Herbalism(182), 
    -- Mining(186), Tailoring(197), Engineering(202), Enchanting(333), 
    -- Skinning(393), Jewelcrafting(755), Inscription(773)
    
    -- Check if the skill being added is a primary profession
    IF NEW.skill IN (164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773) THEN
        -- Count existing primary professions
        SELECT COUNT(DISTINCT skill) INTO prof_count
        FROM character_skills
        WHERE guid = NEW.guid
        AND skill IN (164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773)
        AND skill != NEW.skill;  -- Don't count if updating same skill
        
        -- Prevent insertion if already at limit
        IF prof_count >= 2 THEN
            SET error_msg = CONCAT('Character already has 2 primary professions. Cannot add skill ', NEW.skill);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_msg;
        END IF;
    END IF;
END//

DELIMITER ;

-- ============================================================================
-- ADMIN COMMANDS
-- ============================================================================

-- To fix a specific character's professions:
-- CALL fix_character_professions(CHARACTER_GUID);

-- To find all characters with >2 professions:
-- SELECT guid, COUNT(DISTINCT skill) as prof_count
-- FROM character_skills
-- WHERE skill IN (164, 165, 171, 182, 186, 197, 202, 333, 393, 755, 773)
-- GROUP BY guid
-- HAVING prof_count > 2;

-- To manually remove all profession recipes from a character:
-- DELETE FROM character_spell 
-- WHERE guid = CHARACTER_GUID 
-- AND spell IN (SELECT spellId FROM skill_extra_item_template);

-- ============================================================================
-- RECOMMENDATIONS
-- ============================================================================
-- 1. Disable the .learn all recipes command for non-GM accounts
-- 2. Use .learn {spell_id} for individual recipes instead
-- 3. Educate GMs about this bug
-- 4. Monitor for players with >2 professions and clean up manually
-- 5. Wait for upstream core fix before enabling .learn all recipes again
--
-- Alternative: Create custom GM command that properly checks profession limits
-- Location: src/server/scripts/Commands/cs_learn.cpp
-- ============================================================================

-- ============================================================================
-- NOTES FOR MORTAL WARCRAFT CUSTOM SYSTEM
-- ============================================================================
-- If your custom skill system replaces professions:
-- - Update trigger to include custom profession skill IDs
-- - Modify fix_character_professions procedure for custom skills
-- - Consider if Mortal Warcraft should have profession limits at all
-- - Check MortalCraftingSkills.cpp for interactions
-- ============================================================================
