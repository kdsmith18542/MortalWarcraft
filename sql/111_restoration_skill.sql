-- ==================================================
-- Project Mortal Warcraft
-- Feature: Restoration (Life Magic) Skill Line
-- Description: Skill-based healing magic system
-- Spec: 22-healing-and-restoration.md
-- ==================================================

-- Restoration skill is defined in the skill system (character_mortal_skills)
-- Skill ID: 5001
-- This SQL file documents the skill and provides seed data for spell books

-- Note: The actual skill is created when a player first uses a Restoration spell book
-- or casts a Restoration spell. This is handled by the C++ code.

-- Restoration Spell Books (item_template entries should be created separately)
-- These are documented here for reference:
-- 
-- Item Entry 80010: "Tome of Minor Mend" - Teaches spell 90020 (Minor Mend)
--   - Requires: Restoration 10
--   - Source: Temple vendors, basic healing tome
--
-- Item Entry 80011: "Tome of Rejuvenating Prayer" - Teaches spell 90021
--   - Requires: Restoration 25
--   - Source: Temple vendors, rare drops
--
-- Item Entry 80012: "Tome of Circle of Mending" - Teaches spell 90022
--   - Requires: Restoration 50
--   - Source: Dungeon drops, crafted by Scribes
--
-- Item Entry 80013: "Tome of Aegis of Renewal" - Teaches spell 90023
--   - Requires: Restoration 40
--   - Source: Temple vendors, rare drops
--
-- Item Entry 80014: "Tome of Rite of Restoration" - Teaches spell 90024
--   - Requires: Restoration 75
--   - Source: Raid drops, high-level crafted tomes

-- Restoration skill gains experience by:
-- 1. Casting healing spells in combat
-- 2. Completing healer-flavored quests
-- 3. Using Restoration spell books (small skill gain)

-- This is handled by the C++ code in MortalSpellLearning.cpp and spell handlers

