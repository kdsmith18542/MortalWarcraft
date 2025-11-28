-- ==================================================
-- Mortal Warcraft – Campaign Quest Templates
-- Spec 62: Core Lore and Campaign Skeleton
-- Target DB: world
-- ==================================================

-- Note: These are template quest entries for the Campaign system
-- Actual quest implementation would be done via Eluna scripts and quest_template inserts

-- Prologue Quests (Shipwreck Cove)
-- Quest IDs: 90000-90005

-- Act I Quests (Mainland Hub)
-- Quest IDs: 90010-90014

-- Act II Quests (Shrines and Yellow Zone)
-- Quest IDs: 90020-90024

-- Act III Quests (Four Bargains - Factions)
-- Quest IDs: 90030-90034

-- Act IV Quests (Frontier - Red Zones)
-- Quest IDs: 90040-90044

-- Act V Quests (Lost Lands - Endgame)
-- Quest IDs: 90050-90054

-- Example quest template structure (would be in quest_template):
/*
INSERT INTO quest_template (entry, QuestType, QuestLevel, MinLevel, QuestSortID, 
                            QuestInfoID, SuggestedGroupNum, RequiredFactionId1, 
                            RequiredFactionValue1, RewardNextQuest, RewardXPDifficulty, 
                            RewardMoney, RewardMoneyMaxLevel, RewardSpell, RewardTitleId, 
                            RequiredNpcOrGo1, RequiredNpcOrGoCount1, RequiredItemId1, 
                            RequiredItemCount1, ObjectiveText1, Title, Objectives, 
                            Details, OfferRewardText, RequestItemsText, EndText, CompletedText)
VALUES 
(90000, 0, 1, 1, 0, 0, 0, 0, 0, 90001, 0, 100, 0, 0, 0, 
 0, 0, 0, 0, 'Talk to the Survivor NPC', 
 'Waking in the Wreck', 
 'After the shipwreck, you find yourself on a strange shore. Find the other survivors.',
 'You wake up on a beach, surrounded by wreckage. A weathered survivor approaches you...',
 'Well done. You have taken your first steps in this broken world.',
 'Please, help us...',
 'You have completed the first step of your journey.',
 'Return to the Survivor to complete the quest.');
*/

-- This file serves as a template/reference for campaign quest creation
-- Actual quests would be created via quest_template inserts or DBC editing

