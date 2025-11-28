-- ==================================================
-- Mortal Warcraft – Campaign Prologue Quests
-- Spec 62: Core Lore and Campaign Skeleton
-- Quest IDs: 90000-90005
-- Target DB: world
-- ==================================================

-- Q0: Waking in the Wreck (90000)
-- Simple talk quest to introduce the Survivor NPC
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90001,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 50,
    `RewardMoneyMaxLevel` = 0,
    `RequiredNpcOrGo1` = 99990,
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Talk to the Survivor',
    `Title` = 'Waking in the Wreck',
    `Objectives` = 'After the shipwreck, you find yourself on a strange shore. Find the other survivors and learn what happened.',
    `Details` = 'You wake up on a beach, surrounded by wreckage. The air feels wrong, and the sky has an unnatural hue. A weathered survivor approaches you, their eyes filled with a mix of fear and determination.',
    `OfferRewardText` = 'Good. You''re alive. That''s more than many can say after the Fracture.',
    `RequestItemsText` = 'Please, help us... We need every able body we can find.',
    `EndText` = 'You have taken your first steps in this broken world.',
    `CompletedText` = 'Return to the Survivor to complete the quest.',
    `RewOrReqMoney` = 50,
    `Flags` = 0,
    `SpecialFlags` = 0
WHERE `entry` = 90000;

-- If quest doesn't exist, create it
INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`, 
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90000, 0, 1, 1, 90001, 0, 50, 99990, 'Talk to the Survivor', 
    'Waking in the Wreck', 
    'After the shipwreck, you find yourself on a strange shore. Find the other survivors and learn what happened.',
    'You wake up on a beach, surrounded by wreckage. The air feels wrong, and the sky has an unnatural hue. A weathered survivor approaches you, their eyes filled with a mix of fear and determination.',
    'Good. You''re alive. That''s more than many can say after the Fracture.',
    'Please, help us... We need every able body we can find.',
    'You have taken your first steps in this broken world.',
    'Return to the Survivor to complete the quest.',
    50, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90000);

-- Q1: Arms from Ruin (90001)
-- Loot weapon from debris and attack training dummy
UPDATE `quest_template` SET
    `QuestType` = 2, -- ITEM quest
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90002,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 75,
    `RequiredItemId1` = 99991, -- Broken Weapon item
    `RequiredItemCount1` = 1,
    `RequiredNpcOrGo1` = 99992, -- Training Dummy
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Loot a broken weapon and test it on the training dummy',
    `Title` = 'Arms from Ruin',
    `Objectives` = 'Search the wreckage for a usable weapon. Then practice with it on the training dummy nearby.',
    `Details` = 'The survivor points to a pile of debris. "We need weapons. Scavenge what you can from the wreck. Then test it on that dummy over there - you''ll need to know how to fight if you want to survive."',
    `OfferRewardText` = 'Good. You''ve learned the basics of combat. Remember: Brace when they attack, strike when they''re open.',
    `RequestItemsText` = 'Have you found a weapon and tested it yet?',
    `EndText` = 'You have learned basic combat.',
    `CompletedText` = 'Return to the Survivor.',
    `RewOrReqMoney` = 75,
    `Flags` = 0
WHERE `entry` = 90001;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `RequiredNpcOrGo1`, 
    `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, 
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90001, 2, 1, 1, 90002, 0, 75, 99991, 1, 99992, 1, 
    'Loot a broken weapon and test it on the training dummy',
    'Arms from Ruin',
    'Search the wreckage for a usable weapon. Then practice with it on the training dummy nearby.',
    'The survivor points to a pile of debris. "We need weapons. Scavenge what you can from the wreck. Then test it on that dummy over there - you''ll need to know how to fight if you want to survive."',
    'Good. You''ve learned the basics of combat. Remember: Brace when they attack, strike when they''re open.',
    'Have you found a weapon and tested it yet?',
    'You have learned basic combat.',
    'Return to the Survivor.',
    75, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90001);

-- Q2: Driftwood & Flint (90002)
-- Gather materials for crafting
UPDATE `quest_template` SET
    `QuestType` = 2, -- ITEM quest
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90003,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `RequiredItemId1` = 99993, -- Driftwood
    `RequiredItemCount1` = 5,
    `RequiredItemId2` = 99994, -- Flint
    `RequiredItemCount2` = 3,
    `ObjectiveText1` = 'Gather 5 pieces of Driftwood and 3 pieces of Flint',
    `Title` = 'Driftwood & Flint',
    `Objectives` = 'Gather materials from the beach: 5 pieces of driftwood and 3 pieces of flint. Bring them to the improvised Anvil.',
    `Details` = '"We can''t rely on scavenging forever. We need to craft our own tools. Gather driftwood from the beach and flint from the rocks. There''s a makeshift anvil near the camp - bring everything there."',
    `OfferRewardText` = 'Excellent. These materials will be useful. Now let''s see if you can craft something with them.',
    `RequestItemsText` = 'Do you have the driftwood and flint?',
    `EndText` = 'You have gathered the materials.',
    `CompletedText` = 'Return to the Survivor with the materials.',
    `RewOrReqMoney` = 100,
    `Flags` = 0
WHERE `entry` = 90002;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `RequiredItemId2`, 
    `RequiredItemCount2`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, 
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90002, 2, 1, 1, 90003, 0, 100, 99993, 5, 99994, 3,
    'Gather 5 pieces of Driftwood and 3 pieces of Flint',
    'Driftwood & Flint',
    'Gather materials from the beach: 5 pieces of driftwood and 3 pieces of flint. Bring them to the improvised Anvil.',
    '"We can''t rely on scavenging forever. We need to craft our own tools. Gather driftwood from the beach and flint from the rocks. There''s a makeshift anvil near the camp - bring everything there."',
    'Excellent. These materials will be useful. Now let''s see if you can craft something with them.',
    'Do you have the driftwood and flint?',
    'You have gathered the materials.',
    'Return to the Survivor with the materials.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90002);

-- Q3: Edge of Survival (90003)
-- Craft a simple weapon (Shiv)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90004,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 125,
    `RewardItemId1` = 99995, -- Crafted Shiv
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Craft a Shiv at the Anvil and equip it',
    `Title` = 'Edge of Survival',
    `Objectives` = 'Use the materials you gathered to craft a simple weapon at the improvised Anvil. Equip it when done.',
    `Details` = '"Now use those materials to craft a weapon. The anvil is crude, but it''ll do. Make a shiv - simple, but effective. When you''re done, equip it. You''ll need it soon."',
    `OfferRewardText` = 'Well done. You''ve made your first weapon. Remember: quality matters. Better materials and skill make better gear.',
    `RequestItemsText` = 'Have you crafted and equipped the shiv?',
    `EndText` = 'You have crafted your first weapon.',
    `CompletedText` = 'Return to the Survivor.',
    `RewOrReqMoney` = 125,
    `Flags` = 0
WHERE `entry` = 90003;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, 
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, 
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90003, 0, 1, 1, 90004, 0, 125, 99995, 1,
    'Craft a Shiv at the Anvil and equip it',
    'Edge of Survival',
    'Use the materials you gathered to craft a simple weapon at the improvised Anvil. Equip it when done.',
    '"Now use those materials to craft a weapon. The anvil is crude, but it''ll do. Make a shiv - simple, but effective. When you''re done, equip it. You''ll need it soon."',
    'Well done. You''ve made your first weapon. Remember: quality matters. Better materials and skill make better gear.',
    'Have you crafted and equipped the shiv?',
    'You have crafted your first weapon.',
    'Return to the Survivor.',
    125, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90003);

-- Q4: First Fracture (90004)
-- Kill Ether-touched mobs from a minor Rift
UPDATE `quest_template` SET
    `QuestType` = 1, -- KILL quest
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90005,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 150,
    `RequiredNpcOrGo1` = 99996, -- Ether-touched Scavenger
    `RequiredNpcOrGoCount1` = 3,
    `RequiredNpcOrGo2` = 99997, -- Damaged Shrine Fragment (gameobject)
    `RequiredNpcOrGoCount2` = 1,
    `ObjectiveText1` = 'Kill 3 Ether-touched Scavengers and interact with the Damaged Shrine Fragment',
    `Title` = 'First Fracture',
    `Objectives` = 'A minor Rift has opened nearby, releasing Ether-touched creatures. Kill 3 of them, then examine the damaged Shrine Fragment.',
    `Details` = 'The survivor''s eyes widen. "Look - a Rift. The Fracture is everywhere. Those creatures... they''re not natural. Kill them, then check that Shrine Fragment. It''s broken, but it might tell us something."',
    `OfferRewardText` = 'The Shrine is damaged beyond repair here. But inland... there are real Shrines. They''re anchors against the Fracture. When you die, they''ll pull you back - but at a cost.',
    `RequestItemsText` = 'Have you dealt with the Rift creatures?',
    `EndText` = 'You have encountered your first Rift.',
    `CompletedText` = 'Return to the Survivor.',
    `RewOrReqMoney` = 150,
    `Flags` = 0
WHERE `entry` = 90004;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, 
    `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `Title`, `Objectives`, 
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90004, 1, 1, 1, 90005, 0, 150, 99996, 3, 99997, 1,
    'Kill 3 Ether-touched Scavengers and interact with the Damaged Shrine Fragment',
    'First Fracture',
    'A minor Rift has opened nearby, releasing Ether-touched creatures. Kill 3 of them, then examine the damaged Shrine Fragment.',
    'The survivor''s eyes widen. "Look - a Rift. The Fracture is everywhere. Those creatures... they''re not natural. Kill them, then check that Shrine Fragment. It''s broken, but it might tell us something."',
    'The Shrine is damaged beyond repair here. But inland... there are real Shrines. They''re anchors against the Fracture. When you die, they''ll pull you back - but at a cost.',
    'Have you dealt with the Rift creatures?',
    'You have encountered your first Rift.',
    'Return to the Survivor.',
    150, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90004);

-- Q5: The Raft to Mainland (90005)
-- Final prologue quest - repair raft and leave
UPDATE `quest_template` SET
    `QuestType` = 2, -- ITEM quest
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90010, -- Links to Act I
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200,
    `RewardItemId1` = 99998, -- Starter gear pack
    `RewardItemCount1` = 1,
    `RequiredItemId1` = 99999, -- Repaired Raft (crafted item)
    `RequiredItemCount1` = 1,
    `ObjectiveText1` = 'Repair the raft using collected materials and prepare to leave Shipwreck Cove',
    `Title` = 'The Raft to Mainland',
    `Objectives` = 'Gather the remaining materials needed to repair the raft. Once it''s ready, use it to travel to the Mainland Hub.',
    `Details` = '"We can''t stay here. The Rifts are getting worse. Repair that raft - you''ll need more driftwood and some rope. Once it''s done, we''re leaving. The Mainland Hub is where the real work begins."',
    `OfferRewardText` = 'The world is broken, but there is work to be done inland. You''ve survived the shipwreck. Now survive the Frontier.',
    `RequestItemsText` = 'Is the raft ready?',
    `EndText` = 'You are ready to leave Shipwreck Cove.',
    `CompletedText` = 'Use the raft to travel to the Mainland.',
    `RewOrReqMoney` = 200,
    `Flags` = 0
WHERE `entry` = 90005;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `RequiredItemId1`, 
    `RequiredItemCount1`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, 
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90005, 2, 1, 1, 90010, 0, 200, 99998, 1, 99999, 1,
    'Repair the raft using collected materials and prepare to leave Shipwreck Cove',
    'The Raft to Mainland',
    'Gather the remaining materials needed to repair the raft. Once it''s ready, use it to travel to the Mainland Hub.',
    '"We can''t stay here. The Rifts are getting worse. Repair that raft - you''ll need more driftwood and some rope. Once it''s done, we''re leaving. The Mainland Hub is where the real work begins."',
    'The world is broken, but there is work to be done inland. You''ve survived the shipwreck. Now survive the Frontier.',
    'Is the raft ready?',
    'You are ready to leave Shipwreck Cove.',
    'Use the raft to travel to the Mainland.',
    200, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90005);

-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(90000, 'STORY_REWRITE', NULL, 'Prologue Quest - Waking in the Wreck'),
(90001, 'STORY_REWRITE', NULL, 'Prologue Quest - Arms from Ruin'),
(90002, 'STORY_REWRITE', NULL, 'Prologue Quest - Driftwood & Flint'),
(90003, 'STORY_REWRITE', NULL, 'Prologue Quest - Edge of Survival'),
(90004, 'STORY_REWRITE', NULL, 'Prologue Quest - First Fracture'),
(90005, 'STORY_REWRITE', NULL, 'Prologue Quest - The Raft to Mainland')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `notes` = VALUES(`notes`);
