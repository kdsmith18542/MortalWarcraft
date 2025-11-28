-- ==================================================
-- Mortal Warcraft – Campaign Act I Quests
-- Spec 62: Core Lore and Campaign Skeleton
-- Quest IDs: 90010-90014
-- Target DB: world
-- ==================================================

-- A1.1: Welcome to the Hub (90010)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90011,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `RequiredNpcOrGo1` = 99980, -- Harbor Clerk
    `RequiredNpcOrGoCount1` = 0,
    `RequiredNpcOrGo2` = 99981, -- Task Board (gameobject)
    `RequiredNpcOrGoCount2` = 1,
    `ObjectiveText1` = 'Talk to Harbor Clerk and visit the Task Board',
    `Title` = 'Welcome to the Hub',
    `Objectives` = 'Speak with the Harbor Clerk, then visit the Task Board, Market Stalls, and Regional Bank to get oriented.',
    `Details` = 'The Harbor Clerk greets you as you arrive. "Welcome to Port Meridian. This is where the real work begins. Let me show you around - you''ll need to know where everything is."',
    `OfferRewardText` = 'Good. You know where the essentials are. Now let''s get you some actual work.',
    `RequestItemsText` = 'Have you visited the Task Board and Market yet?',
    `EndText` = 'You have been introduced to Port Meridian.',
    `CompletedText` = 'Return to the Harbor Clerk.',
    `RewOrReqMoney` = 100,
    `Flags` = 0
WHERE `entry` = 90010;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, 
    `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `Title`, `Objectives`, 
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90010, 0, 1, 1, 90011, 0, 100, 99980, 0, 99981, 1,
    'Talk to Harbor Clerk and visit the Task Board',
    'Welcome to the Hub',
    'Speak with the Harbor Clerk, then visit the Task Board, Market Stalls, and Regional Bank to get oriented.',
    'The Harbor Clerk greets you as you arrive. "Welcome to Port Meridian. This is where the real work begins. Let me show you around - you''ll need to know where everything is."',
    'Good. You know where the essentials are. Now let''s get you some actual work.',
    'Have you visited the Task Board and Market yet?',
    'You have been introduced to Port Meridian.',
    'Return to the Harbor Clerk.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90010);

-- A1.2: The First Contract (90011)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90012,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 150,
    `RequiredNpcOrGo1` = 99982, -- Contract completion NPC
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Accept and complete a simple contract from the Task Board',
    `Title` = 'The First Contract',
    `Objectives` = 'Go to the Task Board and accept a simple local contract. Complete it and return.',
    `Details` = '"In this city, work is found at the board. Go there, pick a contract - something simple like clearing rats or gathering herbs. Complete it, and you''ll see how things work here."',
    `OfferRewardText` = 'Well done. That''s how you make a living here - contracts, not quests. Gold and materials, not experience points.',
    `RequestItemsText` = 'Have you completed a contract yet?',
    `EndText` = 'You have completed your first contract.',
    `CompletedText` = 'Return to the Harbor Clerk.',
    `RewOrReqMoney` = 150,
    `Flags` = 0
WHERE `entry` = 90011;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, 
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, 
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90011, 0, 1, 1, 90012, 0, 150, 99982, 1,
    'Accept and complete a simple contract from the Task Board',
    'The First Contract',
    'Go to the Task Board and accept a simple local contract. Complete it and return.',
    '"In this city, work is found at the board. Go there, pick a contract - something simple like clearing rats or gathering herbs. Complete it, and you''ll see how things work here."',
    'Well done. That''s how you make a living here - contracts, not quests. Gold and materials, not experience points.',
    'Have you completed a contract yet?',
    'You have completed your first contract.',
    'Return to the Harbor Clerk.',
    150, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90011);

-- A1.3: Pay, Not XP (90012)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90013,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200,
    `RequiredItemId1` = 99985, -- Contract Payment Receipt
    `RequiredItemCount1` = 1,
    `ObjectiveText1` = 'Turn in your contract and receive gold and materials',
    `Title` = 'Pay, Not XP',
    `Objectives` = 'Return to the Task Board and turn in your completed contract. Receive your payment in gold and materials.',
    `Details` = '"You''ve done the work. Now collect your pay. Remember: in this world, you don''t level up. You get stronger by using your skills, gathering better materials, and making better gear. Gold and materials are what matter."',
    `OfferRewardText` = 'Exactly. Skills improve with use. Materials make better gear. Gold buys what you need. That''s the economy here.',
    `RequestItemsText` = 'Have you collected your contract payment?',
    `EndText` = 'You have received your first contract payment.',
    `CompletedText` = 'Return to the Harbor Clerk.',
    `RewOrReqMoney` = 200,
    `Flags` = 0
WHERE `entry` = 90012;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, 
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, 
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90012, 0, 1, 1, 90013, 0, 200, 99985, 1,
    'Turn in your contract and receive gold and materials',
    'Pay, Not XP',
    'Return to the Task Board and turn in your completed contract. Receive your payment in gold and materials.',
    '"You''ve done the work. Now collect your pay. Remember: in this world, you don''t level up. You get stronger by using your skills, gathering better materials, and making better gear. Gold and materials are what matter."',
    'Exactly. Skills improve with use. Materials make better gear. Gold buys what you need. That''s the economy here.',
    'Have you collected your contract payment?',
    'You have received your first contract payment.',
    'Return to the Harbor Clerk.',
    200, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90012);

-- A1.4: Ledger of the Living (90013)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90014,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 250,
    `RequiredNpcOrGo1` = 99983, -- Banker
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Deposit items in the Regional Bank',
    `Title` = 'Ledger of the Living',
    `Objectives` = 'Visit the Regional Bank and deposit at least 20 units of weight worth of items. Learn about regional banking.',
    `Details` = '"Your wealth needs protection. The Regional Bank here in Port Meridian is where you store valuables. But remember: what you deposit here stays here. If you travel to another city, you''ll need to withdraw and carry it, or use courier services."',
    `OfferRewardText` = 'Good. You understand regional banking. Your items are safe here, but they''re also tied to this place. Plan accordingly.',
    `RequestItemsText` = 'Have you made a deposit at the bank?',
    `EndText` = 'You have learned about regional banking.',
    `CompletedText` = 'Return to the Harbor Clerk.',
    `RewOrReqMoney` = 250,
    `Flags` = 0
WHERE `entry` = 90013;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, 
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, 
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90013, 0, 1, 1, 90014, 0, 250, 99983, 0,
    'Deposit items in the Regional Bank',
    'Ledger of the Living',
    'Visit the Regional Bank and deposit at least 20 units of weight worth of items. Learn about regional banking.',
    '"Your wealth needs protection. The Regional Bank here in Port Meridian is where you store valuables. But remember: what you deposit here stays here. If you travel to another city, you''ll need to withdraw and carry it, or use courier services."',
    'Good. You understand regional banking. Your items are safe here, but they''re also tied to this place. Plan accordingly.',
    'Have you made a deposit at the bank?',
    'You have learned about regional banking.',
    'Return to the Harbor Clerk.',
    250, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90013);

-- A1.5: A Whisper of Death (90014)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 90020, -- Links to Act II
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 300,
    `RewardTitleId` = 100, -- "Cove Survivor" title
    `RequiredNpcOrGo1` = 99984, -- Shrine Acolyte
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Shrine Acolyte about death and resurrection',
    `Title` = 'A Whisper of Death',
    `Objectives` = 'Visit the Shrine and speak with the Acolyte. Learn about death, resurrection, and the cost of returning.',
    `Details` = '"You should know what happens when you die. Speak with the Shrine Acolyte - they''ll explain. It''s not pleasant, but it''s better to know now than to learn the hard way."',
    `OfferRewardText` = 'You understand now. When you die, the Shrine will pull you back - but your steel stays where you fell. Be careful out there.',
    `RequestItemsText` = 'Have you spoken with the Shrine Acolyte?',
    `EndText` = 'You have learned about death and resurrection.',
    `CompletedText` = 'Return to the Harbor Clerk.',
    `RewOrReqMoney` = 300,
    `Flags` = 0
WHERE `entry` = 90014;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`, 
    `RewardXPDifficulty`, `RewardMoney`, `RewardTitleId`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, 
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, 
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 90014, 0, 1, 1, 90020, 0, 300, 100, 99984, 0,
    'Speak with the Shrine Acolyte about death and resurrection',
    'A Whisper of Death',
    'Visit the Shrine and speak with the Acolyte. Learn about death, resurrection, and the cost of returning.',
    '"You should know what happens when you die. Speak with the Shrine Acolyte - they''ll explain. It''s not pleasant, but it''s better to know now than to learn the hard way."',
    'You understand now. When you die, the Shrine will pull you back - but your steel stays where you fell. Be careful out there.',
    'Have you spoken with the Shrine Acolyte?',
    'You have learned about death and resurrection.',
    'Return to the Harbor Clerk.',
    300, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 90014);

-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(90010, 'STORY_REWRITE', NULL, 'Act I Quest - Welcome to the Hub'),
(90011, 'STORY_REWRITE', NULL, 'Act I Quest - The First Contract'),
(90012, 'STORY_REWRITE', NULL, 'Act I Quest - Pay, Not XP'),
(90013, 'STORY_REWRITE', NULL, 'Act I Quest - Ledger of the Living'),
(90014, 'STORY_REWRITE', NULL, 'Act I Quest - A Whisper of Death')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `notes` = VALUES(`notes`);

