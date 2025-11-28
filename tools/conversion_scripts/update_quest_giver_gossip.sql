-- ==================================================
-- Mortal Warcraft – Quest Giver Gossip Updates
-- Spec 63: Quest Conversion Strategy
-- Target DB: world
-- ==================================================

-- Update NPC gossip to point players to Task Board for CONTRACT_BOARD quests
-- This script modifies creature_template gossip_menu_id to use custom gossip that
-- directs players to check the Task Board instead of offering the quest directly

-- Note: This is a template - actual gossip_menu entries would need to be created
-- and linked to NPCs via creature_template.gossip_menu_id

-- Example gossip menu entry (would be in gossip_menu):
/*
INSERT INTO gossip_menu (entry, text_id) VALUES
(50000, 50000); -- Task Board redirect menu

INSERT INTO gossip_menu_option (menu_id, id, option_icon, option_text, option_id, npc_option_npcflag, action_menu_id, action_poi_id, box_coded, box_money, box_text) VALUES
(50000, 0, 0, 'Check the Task Board for available contracts.', 1, 1, 0, 0, 0, 0, '');
*/

-- Update creature_template to use redirect gossip for CONTRACT_BOARD quests
UPDATE creature_template ct
INNER JOIN creature_questrelation cq ON ct.entry = cq.id
INNER JOIN mortal_quest_conversion_map qcm ON cq.quest = qcm.quest_id
SET ct.gossip_menu_id = 50000  -- Redirect to Task Board menu
WHERE qcm.conversion_type = 'CONTRACT_BOARD'
  AND ct.gossip_menu_id IS NULL;

-- Note: Actual implementation would require:
-- 1. Creating custom gossip_menu entries
-- 2. Creating gossip_menu_option entries
-- 3. Linking NPCs to new gossip menus
-- 4. Potentially using Eluna scripts for dynamic gossip

