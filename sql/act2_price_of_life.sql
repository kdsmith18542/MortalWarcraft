-- ==================================================
-- Project Mortal Warcraft
-- Feature: Act II Price of Life
-- Description: Quest templates for Greycrag Hamlet death mechanics (10030-10039)
-- Based on: spec 70
-- ==================================================

-- ==================================================
-- ACT II PRICE OF LIFE QUESTS (10030-10039)
-- ==================================================

-- Q10030: Introduction to Death's Price
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10031,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 50,
    `RequiredNpcOrGo1` = 100300, -- Greycrag Elder
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Greycrag Elder',
    `Title` = 'Introduction to Death''s Price',
    `Objectives` = 'Seek out the Greycrag Elder in Greycrag Hamlet and learn about the harsh realities of death in this world.',
    `Details` = 'In this fractured world, death carries a heavy price. Full-loot PvP means everything you carry can be lost forever. Recovery costs gold, time, and sometimes your very survival. Speak with the Greycrag Elder to begin understanding death''s economics.',
    `OfferRewardText` = 'Welcome, newcomer. Death here is not merciful. Your trials begin now.',
    `RequestItemsText` = 'Are you ready to face death''s price?',
    `EndText` = 'You have met the Greycrag Elder.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 50,
    `Flags` = 0,
    `SpecialFlags` = 0
WHERE `entry` = 10030;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10030, 0, 1, 1, 10031, 0, 50, 100300, 'Speak with the Greycrag Elder',
    'Introduction to Death''s Price',
    'Seek out the Greycrag Elder in Greycrag Hamlet and learn about the harsh realities of death in this world.',
    'In this fractured world, death carries a heavy price. Full-loot PvP means everything you carry can be lost forever. Recovery costs gold, time, and sometimes your very survival. Speak with the Greycrag Elder to begin understanding death''s economics.',
    'Welcome, newcomer. Death here is not merciful. Your trials begin now.',
    'Are you ready to face death''s price?',
    'You have met the Greycrag Elder.',
    'Return to the Greycrag Elder.',
    50, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10030);

-- Q10031: First Death Experience
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10032,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 25,
    `ObjectiveText1` = 'Experience your first death and resurrection',
    `Title` = 'First Death Experience',
    `Objectives` = 'Die once to understand the mechanics of death and resurrection in this world.',
    `Details` = '"Death is inevitable, but its cost is what matters. Experience death firsthand - lose your equipment, feel the sting of resurrection sickness, understand what full-loot PvP truly means. Only through personal experience can you grasp death''s true price."',
    `OfferRewardText` = 'Death teaches the hardest lessons. You now understand its mechanics.',
    `RequestItemsText` = 'Have you experienced death?',
    `EndText` = 'You have died and been resurrected.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 25,
    `Flags` = 0
WHERE `entry` = 10031;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10031, 0, 1, 1, 10032, 0, 25, 'Experience your first death and resurrection',
    'First Death Experience',
    'Die once to understand the mechanics of death and resurrection in this world.',
    '"Death is inevitable, but its cost is what matters. Experience death firsthand - lose your equipment, feel the sting of resurrection sickness, understand what full-loot PvP truly means. Only through personal experience can you grasp death''s true price."',
    'Death teaches the hardest lessons. You now understand its mechanics.',
    'Have you experienced death?',
    'You have died and been resurrected.',
    'Return to the Greycrag Elder.',
    25, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10031);

-- Q10032: Loot Recovery Basics
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10033,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `RequiredItemId1` = 100301, -- Recovery Fee Voucher
    `RequiredItemCount1` = 1,
    `ObjectiveText1` = 'Obtain a Recovery Fee Voucher',
    `Title` = 'Loot Recovery Basics',
    `Objectives` = 'Learn about corpse recovery by obtaining a recovery fee voucher from the local undertaker.',
    `Details` = '"Your corpse holds your equipment, but recovering it costs gold. Full-loot PvP means if someone else loots your corpse first, everything is gone forever. Learn the basics of recovery fees and corpse protection."',
    `OfferRewardText` = 'Recovery fees are the first economic barrier of death.',
    `RequestItemsText` = 'Have you obtained the recovery fee voucher?',
    `EndText` = 'You have learned loot recovery basics.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 100,
    `Flags` = 0
WHERE `entry` = 10032;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10032, 2, 1, 1, 10033, 0, 100, 100301, 1, 'Obtain a Recovery Fee Voucher',
    'Loot Recovery Basics',
    'Learn about corpse recovery by obtaining a recovery fee voucher from the local undertaker.',
    '"Your corpse holds your equipment, but recovering it costs gold. Full-loot PvP means if someone else loots your corpse first, everything is gone forever. Learn the basics of recovery fees and corpse protection."',
    'Recovery fees are the first economic barrier of death.',
    'Have you obtained the recovery fee voucher?',
    'You have learned loot recovery basics.',
    'Return to the Greycrag Elder.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10032);

-- Q10033: Economic Impact of Death
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10034,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 50,
    `ObjectiveText1` = 'Calculate the total cost of your death',
    `Title` = 'Economic Impact of Death',
    `Objectives` = 'Calculate how much gold you''ve spent on death-related costs (repair bills, recovery fees, lost items).',
    `Details` = '"Death has cascading economic consequences. Repair your damaged equipment, pay recovery fees, replace lost items - each death drains your wealth. Calculate your total death costs to understand how mortality impacts your prosperity."',
    `OfferRewardText` = 'Death is expensive. Every resurrection costs more than you think.',
    `RequestItemsText` = 'Have you calculated your death costs?',
    `EndText` = 'You have calculated death''s economic impact.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 50,
    `Flags` = 0
WHERE `entry` = 10033;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10033, 0, 1, 1, 10034, 0, 50, 'Calculate the total cost of your death',
    'Economic Impact of Death',
    'Calculate how much gold you''ve spent on death-related costs (repair bills, recovery fees, lost items).',
    '"Death has cascading economic consequences. Repair your damaged equipment, pay recovery fees, replace lost items - each death drains your wealth. Calculate your total death costs to understand how mortality impacts your prosperity."',
    'Death is expensive. Every resurrection costs more than you think.',
    'Have you calculated your death costs?',
    'You have calculated death''s economic impact.',
    'Return to the Greycrag Elder.',
    50, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10033);

-- Q10034: Full-Loot PvP Introduction
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10035,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 75,
    `ObjectiveText1` = 'Participate in controlled PvP combat',
    `Title` = 'Full-Loot PvP Introduction',
    `Objectives` = 'Engage in PvP combat where the loser risks losing all carried items.',
    `Details` = '"Full-loot PvP is the ultimate test of skill and preparation. Everything you carry can be lost - weapons, armor, gold, quest items. Learn to assess risk vs reward, understand when to fight and when to flee. PvP here is not a game, it''s economic warfare."',
    `OfferRewardText` = 'Full-loot PvP demands respect. Every fight carries the weight of total loss.',
    `RequestItemsText` = 'Have you experienced full-loot PvP?',
    `EndText` = 'You have been introduced to full-loot PvP.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 75,
    `Flags` = 0
WHERE `entry` = 10034;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10034, 0, 1, 1, 10035, 0, 75, 'Participate in controlled PvP combat',
    'Full-Loot PvP Introduction',
    'Engage in PvP combat where the loser risks losing all carried items.',
    '"Full-loot PvP is the ultimate test of skill and preparation. Everything you carry can be lost - weapons, armor, gold, quest items. Learn to assess risk vs reward, understand when to fight and when to flee. PvP here is not a game, it''s economic warfare."',
    'Full-loot PvP demands respect. Every fight carries the weight of total loss.',
    'Have you experienced full-loot PvP?',
    'You have been introduced to full-loot PvP.',
    'Return to the Greycrag Elder.',
    75, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10034);

-- Q10035: Recovery Cost Calculation
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10036,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `ObjectiveText1` = 'Calculate recovery costs for different scenarios',
    `Title` = 'Recovery Cost Calculation',
    `Objectives` = 'Learn to calculate recovery costs for various death scenarios (durability loss, resurrection sickness, lost items).',
    `Details` = '"Death''s costs are not random - they''re calculated. Learn the formulas: repair costs based on durability loss, resurrection sickness duration and penalties, replacement value of lost items. Understanding these costs helps you make better survival decisions."',
    `OfferRewardText` = 'You now understand death''s mathematics. Knowledge is your best defense.',
    `RequestItemsText` = 'Have you mastered recovery cost calculations?',
    `EndText` = 'You have learned recovery cost calculations.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 100,
    `Flags` = 0
WHERE `entry` = 10035;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10035, 0, 1, 1, 10036, 0, 100, 'Calculate recovery costs for different scenarios',
    'Recovery Cost Calculation',
    'Learn to calculate recovery costs for various death scenarios (durability loss, resurrection sickness, lost items).',
    '"Death''s costs are not random - they''re calculated. Learn the formulas: repair costs based on durability loss, resurrection sickness duration and penalties, replacement value of lost items. Understanding these costs helps you make better survival decisions."',
    'You now understand death''s mathematics. Knowledge is your best defense.',
    'Have you mastered recovery cost calculations?',
    'You have learned recovery cost calculations.',
    'Return to the Greycrag Elder.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10035);

-- Q10036: Death Prevention Strategies
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10037,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 125,
    `ObjectiveText1` = 'Demonstrate death prevention techniques',
    `Title` = 'Death Prevention Strategies',
    `Objectives` = 'Show mastery of survival techniques: fleeing combat, using defensive abilities, avoiding high-risk areas.',
    `Details` = '"Prevention is cheaper than cure. Learn when to fight and when to flee. Master defensive positioning, escape abilities, and risk assessment. The best way to avoid death''s costs is to never die in the first place."',
    `OfferRewardText` = 'Survival is the ultimate skill. Prevention beats recovery every time.',
    `RequestItemsText` = 'Have you demonstrated death prevention?',
    `EndText` = 'You have learned death prevention strategies.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 125,
    `Flags` = 0
WHERE `entry` = 10036;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10036, 0, 1, 1, 10037, 0, 125, 'Demonstrate death prevention techniques',
    'Death Prevention Strategies',
    'Show mastery of survival techniques: fleeing combat, using defensive abilities, avoiding high-risk areas.',
    '"Prevention is cheaper than cure. Learn when to fight and when to flee. Master defensive positioning, escape abilities, and risk assessment. The best way to avoid death''s costs is to never die in the first place."',
    'Survival is the ultimate skill. Prevention beats recovery every time.',
    'Have you demonstrated death prevention?',
    'You have learned death prevention strategies.',
    'Return to the Greycrag Elder.',
    125, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10036);

-- Q10037: Corpse Recovery Mechanics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10038,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 150,
    `ObjectiveText1` = 'Successfully recover your corpse 3 times',
    `Title` = 'Corpse Recovery Mechanics',
    `Objectives` = 'Die and recover your corpse 3 times, learning the mechanics of corpse location, recovery fees, and resurrection sickness.',
    `Details` = '"Corpse recovery is both art and science. Learn to find your corpse quickly, pay the recovery fees, endure resurrection sickness. Each recovery teaches you about death''s practical mechanics and the race against time and other players."',
    `OfferRewardText` = 'You master the grim art of corpse recovery.',
    `RequestItemsText` = 'Have you recovered your corpse 3 times?',
    `EndText` = 'You have mastered corpse recovery mechanics.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 150,
    `Flags` = 0
WHERE `entry` = 10037;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10037, 0, 1, 1, 10038, 0, 150, 'Successfully recover your corpse 3 times',
    'Corpse Recovery Mechanics',
    'Die and recover your corpse 3 times, learning the mechanics of corpse location, recovery fees, and resurrection sickness.',
    '"Corpse recovery is both art and science. Learn to find your corpse quickly, pay the recovery fees, endure resurrection sickness. Each recovery teaches you about death''s practical mechanics and the race against time and other players."',
    'You master the grim art of corpse recovery.',
    'Have you recovered your corpse 3 times?',
    'You have mastered corpse recovery mechanics.',
    'Return to the Greycrag Elder.',
    150, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10037);

-- Q10038: Economic Recovery Planning
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10039,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200,
    `ObjectiveText1` = 'Create an economic recovery plan',
    `Title` = 'Economic Recovery Planning',
    `Objectives` = 'Develop a comprehensive plan for recovering from death''s economic impacts, including emergency funds, backup equipment, and recovery strategies.',
    `Details` = '"Wise players prepare for death''s economic consequences. Create emergency funds, maintain backup equipment, establish recovery networks. Learn to bounce back from total loss and turn death''s costs into calculated risks."',
    `OfferRewardText` = 'Preparation turns death''s costs into manageable risks.',
    `RequestItemsText` = 'Have you created your recovery plan?',
    `EndText` = 'You have developed an economic recovery plan.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 200,
    `Flags` = 0
WHERE `entry` = 10038;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10038, 0, 1, 1, 10039, 0, 200, 'Create an economic recovery plan',
    'Economic Recovery Planning',
    'Develop a comprehensive plan for recovering from death''s economic impacts, including emergency funds, backup equipment, and recovery strategies.',
    '"Wise players prepare for death''s economic consequences. Create emergency funds, maintain backup equipment, establish recovery networks. Learn to bounce back from total loss and turn death''s costs into calculated risks."',
    'Preparation turns death''s costs into manageable risks.',
    'Have you created your recovery plan?',
    'You have developed an economic recovery plan.',
    'Return to the Greycrag Elder.',
    200, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10038);

-- Q10039: Mastering Death's Economics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500,
    `RewardItemId1` = 100302, -- Death Economics Manual
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Demonstrate mastery of death''s economic realities',
    `Title` = 'Mastering Death''s Economics',
    `Objectives` = 'Show complete understanding of death mechanics, full-loot PvP, and economic recovery strategies.',
    `Details` = '"You have learned death''s harsh lessons. Full-loot PvP is not punishment - it''s consequence. Recovery costs teach preparation. Economic impacts demand respect. You now understand that in this world, death is the ultimate economic teacher."',
    `OfferRewardText` = 'You have mastered death''s economics. Survival is now a choice, not chance.',
    `RequestItemsText` = 'Are you ready to demonstrate your mastery?',
    `EndText` = 'You have mastered death''s economics.',
    `CompletedText` = 'Return to the Greycrag Elder.',
    `RewOrReqMoney` = 500,
    `Flags` = 0
WHERE `entry` = 10039;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`, `Details`,
    `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10039, 0, 1, 1, 0, 500, 100302, 1, 'Demonstrate mastery of death''s economic realities',
    'Mastering Death''s Economics',
    'Show complete understanding of death mechanics, full-loot PvP, and economic recovery strategies.',
    '"You have learned death''s harsh lessons. Full-loot PvP is not punishment - it''s consequence. Recovery costs teach preparation. Economic impacts demand respect. You now understand that in this world, death is the ultimate economic teacher."',
    'You have mastered death''s economics. Survival is now a choice, not chance.',
    'Are you ready to demonstrate your mastery?',
    'You have mastered death''s economics.',
    'Return to the Greycrag Elder.',
    500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10039);

-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10030, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Introduction to Death''s Price'),
(10031, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - First Death Experience'),
(10032, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Loot Recovery Basics'),
(10033, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Economic Impact of Death'),
(10034, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Full-Loot PvP Introduction'),
(10035, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Recovery Cost Calculation'),
(10036, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Death Prevention Strategies'),
(10037, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Corpse Recovery Mechanics'),
(10038, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Economic Recovery Planning'),
(10039, 'ACT_II_PRICE_OF_LIFE', 'GREYCRAG_HAMLET', 'Act II - Mastering Death''s Economics')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `faction_tag` = VALUES(`faction_tag`),
    `notes` = VALUES(`notes`);

-- Summary
SELECT
    'Act II Price of Life Implementation Complete' as status,
    COUNT(*) as total_quests_created,
    'Greycrag Hamlet: 10030-10039 (10 quests)' as quest_range,
    'Death mechanics, full-loot recovery, economic consequences' as death_mechanics_focused
FROM quest_template
WHERE entry BETWEEN 10030 AND 10039;