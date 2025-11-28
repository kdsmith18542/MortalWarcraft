-- ==================================================
-- Mortal Warcraft – Campaign Act V Lost Crown
-- Spec 73: Endgame Campaign
-- Quest IDs: 10300-10379
-- Target DB: world
-- ==================================================

-- ==================================================
-- LOST CROWN INTRODUCTION (10300-10319)
-- ==================================================

-- A5.1: Whispers of the Lost Crown (10300)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10301,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 15000,
    `RequiredNpcOrGo1` = 103000, -- Ancient Tome
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Read the ancient tome about the Lost Crown',
    `Title` = 'Whispers of the Lost Crown',
    `Objectives` = 'Find and read an Ancient Tome that speaks of the legendary Lost Crown.',
    `Details` = 'Strange whispers echo through the land about a crown of immense power lost to time. Ancient tomes speak of its location in the Crown Citadel, guarded by terrible beings. Find one of these tomes and learn what you can.',
    `OfferRewardText` = 'The Lost Crown... a relic of unimaginable power. Its location in Crown Citadel has been revealed.',
    `RequestItemsText` = 'Have you found an ancient tome?',
    `EndText` = 'You have learned of the Lost Crown.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 15000,
    `Flags` = 0
WHERE `entry` = 10300;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10300, 0, 40, 35, 10301, 0, 15000, 103000, 1,
    'Read the ancient tome about the Lost Crown',
    'Whispers of the Lost Crown',
    'Find and read an Ancient Tome that speaks of the legendary Lost Crown.',
    'Strange whispers echo through the land about a crown of immense power lost to time. Ancient tomes speak of its location in Crown Citadel, guarded by terrible beings. Find one of these tomes and learn what you can.',
    'The Lost Crown... a relic of unimaginable power. Its location in Crown Citadel has been revealed.',
    'Have you found an ancient tome?',
    'You have learned of the Lost Crown.',
    'Return to the Crown Seeker.',
    15000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10300);

-- A5.2: Crown Citadel Location (10301)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10302,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 16000,
    `RequiredNpcOrGo1` = 103001, -- Citadel Map Fragment
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Collect citadel map fragments',
    `Title` = 'Crown Citadel Location',
    `Objectives` = 'Gather 3 Citadel Map Fragments to piece together the location of Crown Citadel.',
    `Details` = 'The Crown Citadel is hidden in a remote location. Map fragments scattered across the land hold clues to its whereabouts. Collect them to reveal the path to this legendary fortress.',
    `OfferRewardText` = 'With these fragments assembled, the path to Crown Citadel is clear. But beware - the journey will be perilous.',
    `RequestItemsText` = 'Have you collected the map fragments?',
    `EndText` = 'You have located Crown Citadel.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 16000,
    `Flags` = 0
WHERE `entry` = 10301;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10301, 0, 40, 35, 10302, 0, 16000, 103001, 3,
    'Collect citadel map fragments',
    'Crown Citadel Location',
    'Gather 3 Citadel Map Fragments to piece together the location of Crown Citadel.',
    'The Crown Citadel is hidden in a remote location. Map fragments scattered across the land hold clues to its whereabouts. Collect them to reveal the path to this legendary fortress.',
    'With these fragments assembled, the path to Crown Citadel is clear. But beware - the journey will be perilous.',
    'Have you collected the map fragments?',
    'You have located Crown Citadel.',
    'Return to the Crown Seeker.',
    16000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10301);

-- A5.3: Citadel Guardians (10302)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10303,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 17000,
    `RequiredNpcOrGo1` = 103002, -- Guardian Echo
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Witness a guardian echo',
    `Title` = 'Citadel Guardians',
    `Objectives` = 'Find and observe a Guardian Echo to learn about the beings that protect Crown Citadel.',
    `Details` = 'The Crown Citadel is guarded by powerful entities that have protected it for millennia. Echoes of these guardians appear near the citadel entrance. Witness one to understand what awaits within.',
    `OfferRewardText` = 'These guardians are formidable indeed. The Crown Citadel will not yield easily to intruders.',
    `RequestItemsText` = 'Have you witnessed a guardian echo?',
    `EndText` = 'You have learned about the citadel guardians.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 17000,
    `Flags` = 0
WHERE `entry` = 10302;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10302, 0, 40, 35, 10303, 0, 17000, 103002, 1,
    'Witness a guardian echo',
    'Citadel Guardians',
    'Find and observe a Guardian Echo to learn about the beings that protect Crown Citadel.',
    'The Crown Citadel is guarded by powerful entities that have protected it for millennia. Echoes of these guardians appear near the citadel entrance. Witness one to understand what awaits within.',
    'These guardians are formidable indeed. The Crown Citadel will not yield easily to intruders.',
    'Have you witnessed a guardian echo?',
    'You have learned about the citadel guardians.',
    'Return to the Crown Seeker.',
    17000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10302);

-- A5.4: Raid Preparation Basics (10303)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10304,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 18000,
    `RequiredNpcOrGo1` = 103003, -- Raid Preparation Manual
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Study the raid preparation manual',
    `Title` = 'Raid Preparation Basics',
    `Objectives` = 'Read the Raid Preparation Manual to understand the fundamentals of large-scale combat.',
    `Details` = 'Attacking Crown Citadel will require coordination on a massive scale. This manual explains the basics of raid combat - roles, positioning, and communication. Study it carefully.',
    `OfferRewardText` = 'Raid combat requires discipline and teamwork. Each member has a crucial role to play.',
    `RequestItemsText` = 'Have you studied the preparation manual?',
    `EndText` = 'You have learned raid preparation basics.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 18000,
    `Flags` = 0
WHERE `entry` = 10303;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10303, 0, 40, 35, 10304, 0, 18000, 103003, 1,
    'Study the raid preparation manual',
    'Raid Preparation Basics',
    'Read the Raid Preparation Manual to understand the fundamentals of large-scale combat.',
    'Attacking Crown Citadel will require coordination on a massive scale. This manual explains the basics of raid combat - roles, positioning, and communication. Study it carefully.',
    'Raid combat requires discipline and teamwork. Each member has a crucial role to play.',
    'Have you studied the preparation manual?',
    'You have learned raid preparation basics.',
    'Return to the Crown Seeker.',
    18000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10303);

-- A5.5: Understanding Roles (10304)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10305,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 19000,
    `RequiredNpcOrGo1` = 103004, -- Role Demonstration
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Observe role demonstrations',
    `Title` = 'Understanding Roles',
    `Objectives` = 'Watch Role Demonstrations to understand Tank, Healer, and DPS roles in raid combat.',
    `Details` = 'Raid combat has three primary roles: Tanks hold aggro, Healers keep everyone alive, DPS deals damage. Watch these demonstrations to understand how each role contributes to success.',
    `OfferRewardText` = 'Each role is essential. Without tanks, the raid dies quickly. Without healers, wounds accumulate. Without DPS, encounters never end.',
    `RequestItemsText` = 'Have you observed the role demonstrations?',
    `EndText` = 'You understand raid roles.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 19000,
    `Flags` = 0
WHERE `entry` = 10304;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10304, 0, 40, 35, 10305, 0, 19000, 103004, 1,
    'Observe role demonstrations',
    'Understanding Roles',
    'Watch Role Demonstrations to understand Tank, Healer, and DPS roles in raid combat.',
    'Raid combat has three primary roles: Tanks hold aggro, Healers keep everyone alive, DPS deals damage. Watch these demonstrations to understand how each role contributes to success.',
    'Each role is essential. Without tanks, the raid dies quickly. Without healers, wounds accumulate. Without DPS, encounters never end.',
    'Have you observed the role demonstrations?',
    'You understand raid roles.',
    'Return to the Crown Seeker.',
    19000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10304);

-- A5.6: Tank Role Training (10305)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10306,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 20000,
    `RequiredNpcOrGo1` = 103005, -- Training Dummy
    `RequiredNpcOrGoCount1` = 5,
    `ObjectiveText1` = 'Practice tanking on training dummies',
    `Title` = 'Tank Role Training',
    `Objectives` = 'Use Training Dummies to practice holding aggro and positioning as a tank.',
    `Details` = 'Tanks must keep enemies focused on them while protecting the raid. Practice building and maintaining threat, using defensive abilities, and proper positioning.',
    `OfferRewardText` = 'Good tanking requires awareness, timing, and sacrifice. The raid depends on you.',
    `RequestItemsText` = 'Have you practiced tanking?',
    `EndText` = 'You have trained as a tank.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 20000,
    `Flags` = 0
WHERE `entry` = 10305;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10305, 0, 40, 35, 10306, 0, 20000, 103005, 5,
    'Practice tanking on training dummies',
    'Tank Role Training',
    'Use Training Dummies to practice holding aggro and positioning as a tank.',
    'Tanks must keep enemies focused on them while protecting the raid. Practice building and maintaining threat, using defensive abilities, and proper positioning.',
    'Good tanking requires awareness, timing, and sacrifice. The raid depends on you.',
    'Have you practiced tanking?',
    'You have trained as a tank.',
    'Return to the Crown Seeker.',
    20000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10305);

-- A5.7: Healer Role Training (10306)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10307,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 21000,
    `RequiredNpcOrGo1` = 103006, -- Injured Trainee
    `RequiredNpcOrGoCount1` = 8,
    `ObjectiveText1` = 'Heal injured trainees',
    `Title` = 'Healer Role Training',
    `Objectives` = 'Heal 8 Injured Trainees to practice healing mechanics and mana management.',
    `Details` = 'Healers must keep the raid alive through intense combat. Practice efficient healing, mana conservation, and prioritizing targets based on incoming damage.',
    `OfferRewardText` = 'Healing is about efficiency and anticipation. Know when to heal whom, and how much.',
    `RequestItemsText` = 'Have you healed the trainees?',
    `EndText` = 'You have trained as a healer.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 21000,
    `Flags` = 0
WHERE `entry` = 10306;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10306, 0, 40, 35, 10307, 0, 21000, 103006, 8,
    'Heal injured trainees',
    'Healer Role Training',
    'Heal 8 Injured Trainees to practice healing mechanics and mana management.',
    'Healers must keep the raid alive through intense combat. Practice efficient healing, mana conservation, and prioritizing targets based on incoming damage.',
    'Healing is about efficiency and anticipation. Know when to heal whom, and how much.',
    'Have you healed the trainees?',
    'You have trained as a healer.',
    'Return to the Crown Seeker.',
    21000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10306);

-- A5.8: DPS Role Training (10307)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10308,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 22000,
    `RequiredNpcOrGo1` = 103007, -- Target Dummy
    `RequiredNpcOrGoCount1` = 10,
    `ObjectiveText1` = 'Practice DPS rotation on target dummies',
    `Title` = 'DPS Role Training',
    `Objectives` = 'Practice your DPS rotation on Target Dummies to maximize damage output.',
    `Details` = 'DPS must deal maximum damage while avoiding drawing aggro from tanks. Practice ability rotations, positioning, and resource management to optimize your damage.',
    `OfferRewardText` = 'DPS is about maximizing every second. Perfect rotations and positioning separate good DPS from great.',
    `RequestItemsText` = 'Have you practiced your DPS rotation?',
    `EndText` = 'You have trained as DPS.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 22000,
    `Flags` = 0
WHERE `entry` = 10307;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10307, 0, 40, 35, 10308, 0, 22000, 103007, 10,
    'Practice DPS rotation on target dummies',
    'DPS Role Training',
    'Practice your DPS rotation on Target Dummies to maximize damage output.',
    'DPS must deal maximum damage while avoiding drawing aggro from tanks. Practice ability rotations, positioning, and resource management to optimize your damage.',
    'DPS is about maximizing every second. Perfect rotations and positioning separate good DPS from great.',
    'Have you practiced your DPS rotation?',
    'You have trained as DPS.',
    'Return to the Crown Seeker.',
    22000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10307);

-- A5.9: Raid Communication (10308)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10309,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 23000,
    `RequiredNpcOrGo1` = 103008, -- Communication Exercise
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete communication exercise',
    `Title` = 'Raid Communication',
    `Objectives` = 'Participate in a Communication Exercise to practice raid coordination and callouts.',
    `Details` = 'Successful raids require clear communication. Practice calling out important events, coordinating movements, and relaying information to the raid leader.',
    `OfferRewardText` = 'Communication saves lives and wins fights. Know what to say and when to say it.',
    `RequestItemsText` = 'Have you completed the communication exercise?',
    `EndText` = 'You have learned raid communication.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 23000,
    `Flags` = 0
WHERE `entry` = 10308;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10308, 0, 40, 35, 10309, 0, 23000, 103008, 1,
    'Complete communication exercise',
    'Raid Communication',
    'Participate in a Communication Exercise to practice raid coordination and callouts.',
    'Successful raids require clear communication. Practice calling out important events, coordinating movements, and relaying information to the raid leader.',
    'Communication saves lives and wins fights. Know what to say and when to say it.',
    'Have you completed the communication exercise?',
    'You have learned raid communication.',
    'Return to the Crown Seeker.',
    23000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10308);

-- A5.10: Positioning and Movement (10309)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10310,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 24000,
    `RequiredNpcOrGo1` = 103009, -- Movement Challenge
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete movement challenge',
    `Title` = 'Positioning and Movement',
    `Objectives` = 'Navigate a Movement Challenge to practice positioning and raid movement mechanics.',
    `Details` = 'Raid encounters often require precise positioning and coordinated movement. Practice avoiding hazards, stacking properly, and moving as a group.',
    `OfferRewardText` = 'Positioning can make or break an encounter. Know where to stand and when to move.',
    `RequestItemsText` = 'Have you completed the movement challenge?',
    `EndText` = 'You have mastered positioning.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 24000,
    `Flags` = 0
WHERE `entry` = 10309;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10309, 0, 40, 35, 10310, 0, 24000, 103009, 1,
    'Complete movement challenge',
    'Positioning and Movement',
    'Navigate a Movement Challenge to practice positioning and raid movement mechanics.',
    'Raid encounters often require precise positioning and coordinated movement. Practice avoiding hazards, stacking properly, and moving as a group.',
    'Positioning can make or break an encounter. Know where to stand and when to move.',
    'Have you completed the movement challenge?',
    'You have mastered positioning.',
    'Return to the Crown Seeker.',
    24000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10309);

-- A5.11: Encounter Mechanics (10310)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10311,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 25000,
    `RequiredNpcOrGo1` = 103010, -- Encounter Simulator
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Study encounter mechanics simulator',
    `Title` = 'Encounter Mechanics',
    `Objectives` = 'Use the Encounter Simulator to learn about common raid encounter mechanics.',
    `Details` = 'Raid bosses have unique mechanics that must be handled properly. Study the simulator to understand interrupts, dispels, stacks, and other common mechanics.',
    `OfferRewardText` = 'Every encounter has its own rhythm and requirements. Learn them well.',
    `RequestItemsText` = 'Have you studied the encounter simulator?',
    `EndText` = 'You understand encounter mechanics.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 25000,
    `Flags` = 0
WHERE `entry` = 10310;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10310, 0, 40, 35, 10311, 0, 25000, 103010, 1,
    'Study encounter mechanics simulator',
    'Encounter Mechanics',
    'Use the Encounter Simulator to learn about common raid encounter mechanics.',
    'Raid bosses have unique mechanics that must be handled properly. Study the simulator to understand interrupts, dispels, stacks, and other common mechanics.',
    'Every encounter has its own rhythm and requirements. Learn them well.',
    'Have you studied the encounter simulator?',
    'You understand encounter mechanics.',
    'Return to the Crown Seeker.',
    25000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10310);

-- A5.12: Crown Citadel Approach (10311)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10312,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 26000,
    `RequiredNpcOrGo1` = 103011, -- Citadel Entrance
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Reach the Crown Citadel entrance',
    `Title` = 'Crown Citadel Approach',
    `Objectives` = 'Journey to the Crown Citadel and reach its entrance to begin the raid.',
    `Details` = 'The moment has come. With your training complete, journey to Crown Citadel. The entrance awaits, guarded by the first challenges.',
    `OfferRewardText` = 'The Crown Citadel looms before you. The greatest challenge of your career begins now.',
    `RequestItemsText` = 'Have you reached the citadel entrance?',
    `EndText` = 'You have approached Crown Citadel.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 26000,
    `Flags` = 0
WHERE `entry` = 10311;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10311, 0, 40, 35, 10312, 0, 26000, 103011, 1,
    'Reach the Crown Citadel entrance',
    'Crown Citadel Approach',
    'Journey to the Crown Citadel and reach its entrance to begin the raid.',
    'The moment has come. With your training complete, journey to Crown Citadel. The entrance awaits, guarded by the first challenges.',
    'The Crown Citadel looms before you. The greatest challenge of your career begins now.',
    'Have you reached the citadel entrance?',
    'You have approached Crown Citadel.',
    'Return to the Crown Seeker.',
    26000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10311);

-- A5.13: First Guardian (10312)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10313,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 27000,
    `RequiredNpcOrGo1` = 103012, -- First Guardian
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the First Guardian',
    `Title` = 'First Guardian',
    `Objectives` = 'Defeat the First Guardian protecting the Crown Citadel entrance.',
    `Details` = 'The first guardian blocks the path into Crown Citadel. This powerful entity tests your raid''s coordination and ability. Defeat it to prove your worth.',
    `OfferRewardText` = 'The First Guardian falls! Your raid shows promise.',
    `RequestItemsText` = 'Have you defeated the First Guardian?',
    `EndText` = 'You have defeated the First Guardian.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 27000,
    `Flags` = 0
WHERE `entry` = 10312;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10312, 0, 40, 35, 10313, 0, 27000, 103012, 1,
    'Defeat the First Guardian',
    'First Guardian',
    'Defeat the First Guardian protecting the Crown Citadel entrance.',
    'The first guardian blocks the path into Crown Citadel. This powerful entity tests your raid''s coordination and ability. Defeat it to prove your worth.',
    'The First Guardian falls! Your raid shows promise.',
    'Have you defeated the First Guardian?',
    'You have defeated the First Guardian.',
    'Return to the Crown Seeker.',
    27000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10312);

-- A5.14: Citadel Interior (10313)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10314,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 28000,
    `RequiredNpcOrGo1` = 103013, -- Interior Door
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Enter the Citadel interior',
    `Title` = 'Citadel Interior',
    `Objectives` = 'Pass through the interior doors and enter the main chambers of Crown Citadel.',
    `Details` = 'With the First Guardian defeated, the path into Crown Citadel opens. Enter the interior chambers where greater challenges await.',
    `OfferRewardText` = 'The heart of Crown Citadel awaits. The true trials begin here.',
    `RequestItemsText` = 'Have you entered the citadel interior?',
    `EndText` = 'You have entered the Citadel interior.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 28000,
    `Flags` = 0
WHERE `entry` = 10313;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10313, 0, 40, 35, 10314, 0, 28000, 103013, 1,
    'Enter the Citadel interior',
    'Citadel Interior',
    'Pass through the interior doors and enter the main chambers of Crown Citadel.',
    'With the First Guardian defeated, the path into Crown Citadel opens. Enter the interior chambers where greater challenges await.',
    'The heart of Crown Citadel awaits. The true trials begin here.',
    'Have you entered the citadel interior?',
    'You have entered the Citadel interior.',
    'Return to the Crown Seeker.',
    28000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10313);

-- A5.15: Chamber of Trials (10314)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10315,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 29000,
    `RequiredNpcOrGo1` = 103014, -- Trial Overseer
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete the Chamber of Trials',
    `Title` = 'Chamber of Trials',
    `Objectives` = 'Navigate the Chamber of Trials and defeat the Trial Overseer.',
    `Details` = 'The Chamber of Trials tests individual and group skills. Various challenges await, culminating in battle with the Trial Overseer.',
    `OfferRewardText` = 'The Chamber of Trials is complete. Your raid grows stronger.',
    `RequestItemsText` = 'Have you completed the Chamber of Trials?',
    `EndText` = 'You have completed the Chamber of Trials.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 29000,
    `Flags` = 0
WHERE `entry` = 10314;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10314, 0, 40, 35, 10315, 0, 29000, 103014, 1,
    'Complete the Chamber of Trials',
    'Chamber of Trials',
    'Navigate the Chamber of Trials and defeat the Trial Overseer.',
    'The Chamber of Trials tests individual and group skills. Various challenges await, culminating in battle with the Trial Overseer.',
    'The Chamber of Trials is complete. Your raid grows stronger.',
    'Have you completed the Chamber of Trials?',
    'You have completed the Chamber of Trials.',
    'Return to the Crown Seeker.',
    29000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10314);

-- A5.16: Crown Vault Approach (10315)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10316,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 30000,
    `RequiredNpcOrGo1` = 103015, -- Vault Guardian
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the Vault Guardian',
    `Title` = 'Crown Vault Approach',
    `Objectives` = 'Defeat the Vault Guardian blocking access to the Crown Vault.',
    `Details` = 'The Crown Vault, where the Lost Crown resides, is protected by a powerful guardian. Defeat it to approach the vault itself.',
    `OfferRewardText` = 'The Vault Guardian is defeated. The Crown Vault is within reach.',
    `RequestItemsText` = 'Have you defeated the Vault Guardian?',
    `EndText` = 'You have approached the Crown Vault.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 30000,
    `Flags` = 0
WHERE `entry` = 10315;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10315, 0, 40, 35, 10316, 0, 30000, 103015, 1,
    'Defeat the Vault Guardian',
    'Crown Vault Approach',
    'Defeat the Vault Guardian blocking access to the Crown Vault.',
    'The Crown Vault, where the Lost Crown resides, is protected by a powerful guardian. Defeat it to approach the vault itself.',
    'The Vault Guardian is defeated. The Crown Vault is within reach.',
    'Have you defeated the Vault Guardian?',
    'You have approached the Crown Vault.',
    'Return to the Crown Seeker.',
    30000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10315);

-- A5.17: The Lost Crown (10316)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10317,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 35000,
    `RewardItemId1` = 103016, -- Lost Crown Fragment
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103016, -- Crown Vault
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Claim the Lost Crown',
    `Title` = 'The Lost Crown',
    `Objectives` = 'Enter the Crown Vault and claim the Lost Crown.',
    `Details` = 'The moment of triumph! Enter the Crown Vault and claim the legendary Lost Crown. But beware - its power may come at a cost.',
    `OfferRewardText` = 'You hold the Lost Crown! But its power is tainted...',
    `RequestItemsText` = 'Have you claimed the Lost Crown?',
    `EndText` = 'You have claimed the Lost Crown.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 35000,
    `Flags` = 0
WHERE `entry` = 10316;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10316, 0, 40, 35, 10317, 0, 35000, 103016, 1, 103016, 1,
    'Claim the Lost Crown',
    'The Lost Crown',
    'Enter the Crown Vault and claim the Lost Crown.',
    'The moment of triumph! Enter the Crown Vault and claim the legendary Lost Crown. But beware - its power may come at a cost.',
    'You hold the Lost Crown! But its power is tainted...',
    'Have you claimed the Lost Crown?',
    'You have claimed the Lost Crown.',
    'Return to the Crown Seeker.',
    35000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10316);

-- A5.18: Cursed Power (10317)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10318,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 32000,
    `RequiredNpcOrGo1` = 103017, -- Curse Manifestation
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Witness the crown''s curse',
    `Title` = 'Cursed Power',
    `Objectives` = 'Observe the Curse Manifestation triggered by claiming the Lost Crown.',
    `Details` = 'The Lost Crown carries a terrible curse. Its power corrupts those who wield it. Witness the manifestation of this curse.',
    `OfferRewardText` = 'The curse is real. The crown''s power demands extraction.',
    `RequestItemsText` = 'Have you witnessed the curse manifestation?',
    `EndText` = 'You have witnessed the crown''s curse.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 32000,
    `Flags` = 0
WHERE `entry` = 10317;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10317, 0, 40, 35, 10318, 0, 32000, 103017, 1,
    'Witness the crown''s curse',
    'Cursed Power',
    'Observe the Curse Manifestation triggered by claiming the Lost Crown.',
    'The Lost Crown carries a terrible curse. Its power corrupts those who wield it. Witness the manifestation of this curse.',
    'The curse is real. The crown''s power demands extraction.',
    'Have you witnessed the curse manifestation?',
    'You have witnessed the crown''s curse.',
    'Return to the Crown Seeker.',
    32000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10317);

-- A5.19: Extraction Preparation (10318)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 103
19,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 33000,
    `RequiredNpcOrGo1` = 103018, -- Extraction Tools
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Gather extraction tools',
    `Title` = 'Extraction Preparation',
    `Objectives` = 'Gather the specialized tools needed to extract the curse from the Lost Crown.',
    `Details` = 'To safely extract the curse from the Lost Crown, specialized tools and knowledge are required. Gather these tools from the citadel workshops.',
    `OfferRewardText` = 'The extraction tools are prepared. The ritual can begin.',
    `RequestItemsText` = 'Have you gathered the extraction tools?',
    `EndText` = 'You have prepared for extraction.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 33000,
    `Flags` = 0
WHERE `entry` = 10318;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10318, 0, 40, 35, 10319, 0, 33000, 103018, 1,
    'Gather extraction tools',
    'Extraction Preparation',
    'Gather the specialized tools needed to extract the curse from the Lost Crown.',
    'To safely extract the curse from the Lost Crown, specialized tools and knowledge are required. Gather these tools from the citadel workshops.',
    'The extraction tools are prepared. The ritual can begin.',
    'Have you gathered the extraction tools?',
    'You have prepared for extraction.',
    'Return to the Crown Seeker.',
    33000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10318);

-- A5.20: Lost Crown Mastery (10319)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 40,
    `MinLevel` = 35,
    `RewardNextQuest` = 10320,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 40000,
    `RewardItemId1` = 103019, -- Crown Seeker's Manual
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103019, -- Crown Knowledge Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete the crown knowledge test',
    `Title` = 'Lost Crown Mastery',
    `Objectives` = 'Take the Crown Knowledge Test to demonstrate your understanding of the Lost Crown and its challenges.',
    `Details` = 'You''ve learned about the Lost Crown from legend to curse. Now prove your mastery by taking the test. Answer questions about the crown''s history, the citadel, and raid tactics.',
    `OfferRewardText` = 'You have mastered the Lost Crown! Take this manual as your guide to crown hunting.',
    `RequestItemsText` = 'Have you completed the crown knowledge test?',
    `EndText` = 'You have mastered the Lost Crown.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 40000,
    `Flags` = 0
WHERE `entry` = 10319;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10319, 0, 40, 35, 10320, 0, 40000, 103019, 1, 103019, 1,
    'Complete the crown knowledge test',
    'Lost Crown Mastery',
    'Take the Crown Knowledge Test to demonstrate your understanding of the Lost Crown and its challenges.',
    'You''ve learned about the Lost Crown from legend to curse. Now prove your mastery by taking the test. Answer questions about the crown''s history, the citadel, and raid tactics.',
    'You have mastered the Lost Crown! Take this manual as your guide to crown hunting.',
    'Have you completed the crown knowledge test?',
    'You have mastered the Lost Crown.',
    'Return to the Crown Seeker.',
    40000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10319);

-- ==================================================
-- RAID MECHANICS TRAINING (10320-10339)
-- ==================================================

-- A5.21: Advanced Tank Training (10320)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10321,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 45000,
    `RequiredNpcOrGo1` = 103020, -- Elite Training Dummy
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Practice advanced tanking techniques',
    `Title` = 'Advanced Tank Training',
    `Objectives` = 'Use Elite Training Dummies to practice advanced tanking techniques like threat rotation and defensive cooldowns.',
    `Details` = 'Raid tanks must master advanced techniques. Practice threat rotation between multiple tanks, defensive cooldown timing, and positioning for complex encounters.',
    `OfferRewardText` = 'Advanced tanking requires perfect timing and awareness. You''re ready for elite encounters.',
    `RequestItemsText` = 'Have you practiced advanced tanking?',
    `EndText` = 'You have mastered advanced tanking.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 45000,
    `Flags` = 0
WHERE `entry` = 10320;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10320, 0, 45, 40, 10321, 0, 45000, 103020, 3,
    'Practice advanced tanking techniques',
    'Advanced Tank Training',
    'Use Elite Training Dummies to practice advanced tanking techniques like threat rotation and defensive cooldowns.',
    'Raid tanks must master advanced techniques. Practice threat rotation between multiple tanks, defensive cooldown timing, and positioning for complex encounters.',
    'Advanced tanking requires perfect timing and awareness. You''re ready for elite encounters.',
    'Have you practiced advanced tanking?',
    'You have mastered advanced tanking.',
    'Return to the Crown Seeker.',
    45000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10320);

-- A5.22: Healing Coordination (10321)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10322,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 46000,
    `RequiredNpcOrGo1` = 103021, -- Healing Coordination Drill
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete healing coordination drill',
    `Title` = 'Healing Coordination',
    `Objectives` = 'Participate in a Healing Coordination Drill to practice multi-healer raid healing.',
    `Details` = 'Multiple healers must coordinate to keep the raid alive. Practice assignment of healing duties, mana conservation, and emergency healing protocols.',
    `OfferRewardText` = 'Healing coordination saves raids. Know your role and trust your fellow healers.',
    `RequestItemsText` = 'Have you completed the healing drill?',
    `EndText` = 'You have mastered healing coordination.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 46000,
    `Flags` = 0
WHERE `entry` = 10321;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10321, 0, 45, 40, 10322, 0, 46000, 103021, 1,
    'Complete healing coordination drill',
    'Healing Coordination',
    'Participate in a Healing Coordination Drill to practice multi-healer raid healing.',
    'Multiple healers must coordinate to keep the raid alive. Practice assignment of healing duties, mana conservation, and emergency healing protocols.',
    'Healing coordination saves raids. Know your role and trust your fellow healers.',
    'Have you completed the healing drill?',
    'You have mastered healing coordination.',
    'Return to the Crown Seeker.',
    46000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10321);

-- A5.23: DPS Optimization (10322)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10323,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 47000,
    `RequiredNpcOrGo1` = 103022, -- DPS Benchmark
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Achieve DPS benchmark',
    `Title` = 'DPS Optimization',
    `Objectives` = 'Meet the DPS Benchmark by optimizing your rotation and resource management.',
    `Details` = 'Elite raids demand peak DPS performance. Optimize your rotation, use cooldowns effectively, and manage resources to meet the benchmark.',
    `OfferRewardText` = 'Peak DPS performance achieved. Every point of damage counts in elite encounters.',
    `RequestItemsText` = 'Have you achieved the DPS benchmark?',
    `EndText` = 'You have optimized your DPS.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 47000,
    `Flags` = 0
WHERE `entry` = 10322;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10322, 0, 45, 40, 10323, 0, 47000, 103022, 1,
    'Achieve DPS benchmark',
    'DPS Optimization',
    'Meet the DPS Benchmark by optimizing your rotation and resource management.',
    'Elite raids demand peak DPS performance. Optimize your rotation, use cooldowns effectively, and manage resources to meet the benchmark.',
    'Peak DPS performance achieved. Every point of damage counts in elite encounters.',
    'Have you achieved the DPS benchmark?',
    'You have optimized your DPS.',
    'Return to the Crown Seeker.',
    47000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10322);

-- A5.24: Interrupt Discipline (10323)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10324,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 48000,
    `RequiredNpcOrGo1` = 103023, -- Interrupt Target
    `RequiredNpcOrGoCount1` = 10,
    `ObjectiveText1` = 'Successfully interrupt spell casts',
    `Title` = 'Interrupt Discipline',
    `Objectives` = 'Interrupt 10 spell casts on Interrupt Targets to practice timing and priority.',
    `Details` = 'Interrupting enemy spell casts is crucial in raids. Practice identifying interruptible spells, timing your interrupts, and coordinating with other interrupters.',
    `OfferRewardText` = 'Interrupt discipline prevents disaster. Perfect timing saves lives.',
    `RequestItemsText` = 'Have you practiced interrupt discipline?',
    `EndText` = 'You have mastered interrupt discipline.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 48000,
    `Flags` = 0
WHERE `entry` = 10323;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10323, 0, 45, 40, 10324, 0, 48000, 103023, 10,
    'Successfully interrupt spell casts',
    'Interrupt Discipline',
    'Interrupt 10 spell casts on Interrupt Targets to practice timing and priority.',
    'Interrupting enemy spell casts is crucial in raids. Practice identifying interruptible spells, timing your interrupts, and coordinating with other interrupters.',
    'Interrupt discipline prevents disaster. Perfect timing saves lives.',
    'Have you practiced interrupt discipline?',
    'You have mastered interrupt discipline.',
    'Return to the Crown Seeker.',
    48000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10323);

-- A5.25: Dispel Awareness (10324)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10325,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 49000,
    `RequiredNpcOrGo1` = 103024, -- Dispel Target
    `RequiredNpcOrGoCount1` = 8,
    `ObjectiveText1` = 'Dispel harmful effects',
    `Title` = 'Dispel Awareness',
    `Objectives` = 'Dispel 8 harmful effects from Dispel Targets to practice dispel timing and priority.',
    `Details` = 'Dispelling harmful effects from raid members is essential. Practice identifying dispellable debuffs, timing your dispels, and coordinating dispel assignments.',
    `OfferRewardText` = 'Dispel awareness prevents wipe. Know what to dispel and when.',
    `RequestItemsText` = 'Have you practiced dispelling?',
    `EndText` = 'You have mastered dispel awareness.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 49000,
    `Flags` = 0
WHERE `entry` = 10324;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10324, 0, 45, 40, 10325, 0, 49000, 103024, 8,
    'Dispel harmful effects',
    'Dispel Awareness',
    'Dispel 8 harmful effects from Dispel Targets to practice dispel timing and priority.',
    'Dispelling harmful effects from raid members is essential. Practice identifying dispellable debuffs, timing your dispels, and coordinating dispel assignments.',
    'Dispel awareness prevents wipe. Know what to dispel and when.',
    'Have you practiced dispelling?',
    'You have mastered dispel awareness.',
    'Return to the Crown Seeker.',
    49000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10324);

-- A5.26: Raid Leadership (10325)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10326,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 50000,
    `RequiredNpcOrGo1` = 103025, -- Leadership Challenge
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete leadership challenge',
    `Title` = 'Raid Leadership',
    `Objectives` = 'Lead a small group through a Leadership Challenge to practice raid leadership skills.',
    `Details` = 'Raid leaders must make quick decisions and clear calls. Practice assigning roles, adapting to changing situations, and motivating your team.',
    `OfferRewardText` = 'Leadership turns good players into great raids. Your decisions shape victory.',
    `RequestItemsText` = 'Have you completed the leadership challenge?',
    `EndText` = 'You have learned raid leadership.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 50000,
    `Flags` = 0
WHERE `entry` = 10325;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10325, 0, 45, 40, 10326, 0, 50000, 103025, 1,
    'Complete leadership challenge',
    'Raid Leadership',
    'Lead a small group through a Leadership Challenge to practice raid leadership skills.',
    'Raid leaders must make quick decisions and clear calls. Practice assigning roles, adapting to changing situations, and motivating your team.',
    'Leadership turns good players into great raids. Your decisions shape victory.',
    'Have you completed the leadership challenge?',
    'You have learned raid leadership.',
    'Return to the Crown Seeker.',
    50000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10325);

-- A5.27: Emergency Protocols (10326)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10327,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 51000,
    `RequiredNpcOrGo1` = 103026, -- Emergency Scenario
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Handle emergency scenario',
    `Title` = 'Emergency Protocols',
    `Objectives` = 'Navigate an Emergency Scenario to practice responding to raid wipes and critical failures.',
    `Details` = 'Raids sometimes go wrong. Practice emergency protocols for handling wipes, tank deaths, healer burnout, and other critical situations.',
    `OfferRewardText` = 'Emergency protocols turn disaster into recovery. Stay calm, follow procedure.',
    `RequestItemsText` = 'Have you handled the emergency scenario?',
    `EndText` = 'You have mastered emergency protocols.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 51000,
    `Flags` = 0
WHERE `entry` = 10326;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10326, 0, 45, 40, 10327, 0, 51000, 103026, 1,
    'Handle emergency scenario',
    'Emergency Protocols',
    'Navigate an Emergency Scenario to practice responding to raid wipes and critical failures.',
    'Raids sometimes go wrong. Practice emergency protocols for handling wipes, tank deaths, healer burnout, and other critical situations.',
    'Emergency protocols turn disaster into recovery. Stay calm, follow procedure.',
    'Have you handled the emergency scenario?',
    'You have mastered emergency protocols.',
    'Return to the Crown Seeker.',
    51000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10326);

-- A5.28: Phase Transitions (10327)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10328,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 52000,
    `RequiredNpcOrGo1` = 103027, -- Phase Transition Drill
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Navigate phase transition drill',
    `Title` = 'Phase Transitions',
    `Objectives` = 'Complete a Phase Transition Drill to practice adapting to encounter phase changes.',
    `Details` = 'Many raid encounters have multiple phases with different mechanics. Practice recognizing phase transitions and adapting your strategy accordingly.',
    `OfferRewardText` = 'Phase transitions catch unprepared raids. Anticipate and adapt.',
    `RequestItemsText` = 'Have you completed the phase transition drill?',
    `EndText` = 'You have mastered phase transitions.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 52000,
    `Flags` = 0
WHERE `entry` = 10327;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10327, 0, 45, 40, 10328, 0, 52000, 103027, 1,
    'Navigate phase transition drill',
    'Phase Transitions',
    'Complete a Phase Transition Drill to practice adapting to encounter phase changes.',
    'Many raid encounters have multiple phases with different mechanics. Practice recognizing phase transitions and adapting your strategy accordingly.',
    'Phase transitions catch unprepared raids. Anticipate and adapt.',
    'Have you completed the phase transition drill?',
    'You have mastered phase transitions.',
    'Return to the Crown Seeker.',
    52000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10327);

-- A5.29: Add Control (10328)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10329,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 53000,
    `RequiredNpcOrGo1` = 103028, -- Crowd Control Target
    `RequiredNpcOrGoCount1` = 6,
    `ObjectiveText1` = 'Apply crowd control effects',
    `Title` = 'Add Control',
    `Objectives` = 'Apply crowd control to 6 Crowd Control Targets to practice add management.',
    `Details` = 'Controlling additional enemies (adds) is crucial in raids. Practice applying and maintaining crowd control effects while managing your primary duties.',
    `OfferRewardText` = 'Add control prevents chaos. Know your CC and use it wisely.',
    `RequestItemsText` = 'Have you practiced add control?',
    `EndText` = 'You have mastered add control.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 53000,
    `Flags` = 0
WHERE `entry` = 10328;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10328, 0, 45, 40, 10329, 0, 53000, 103028, 6,
    'Apply crowd control effects',
    'Add Control',
    'Apply crowd control to 6 Crowd Control Targets to practice add management.',
    'Controlling additional enemies (adds) is crucial in raids. Practice applying and maintaining crowd control effects while managing your primary duties.',
    'Add control prevents chaos. Know your CC and use it wisely.',
    'Have you practiced add control?',
    'You have mastered add control.',
    'Return to the Crown Seeker.',
    53000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10328);

-- A5.30: Raid Mechanics Mastery (10329)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 45,
    `MinLevel` = 40,
    `RewardNextQuest` = 10340,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 60000,
    `RewardItemId1` = 103029, -- Raid Tactics Manual
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103029, -- Mechanics Mastery Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete mechanics mastery test',
    `Title` = 'Raid Mechanics Mastery',
    `Objectives` = 'Take the Mechanics Mastery Test to demonstrate your understanding of advanced raid mechanics.',
    `Details` = 'You''ve mastered individual raid roles and mechanics. Now prove your comprehensive understanding by taking the test. Answer questions about coordination, adaptation, and strategy.',
    `OfferRewardText` = 'You have mastered raid mechanics! Take this manual as your guide to elite raiding.',
    `RequestItemsText` = 'Have you completed the mechanics mastery test?',
    `EndText` = 'You have mastered raid mechanics.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 60000,
    `Flags` = 0
WHERE `entry` = 10329;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10329, 0, 45, 40, 10340, 0, 60000, 103029, 1, 103029, 1,
    'Complete mechanics mastery test',
    'Raid Mechanics Mastery',
    'Take the Mechanics Mastery Test to demonstrate your understanding of advanced raid mechanics.',
    'You''ve mastered individual raid roles and mechanics. Now prove your comprehensive understanding by taking the test. Answer questions about coordination, adaptation, and strategy.',
    'You have mastered raid mechanics! Take this manual as your guide to elite raiding.',
    'Have you completed the mechanics mastery test?',
    'You have mastered raid mechanics.',
    'Return to the Crown Seeker.',
    60000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10329);

-- ==================================================
-- CROWN CITADEL RAID (10340-10359)
-- ==================================================

-- A5.31: Citadel Re-Entry (10340)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10341,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 70000,
    `RequiredNpcOrGo1` = 103030, -- Citadel Raid Entrance
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Enter Crown Citadel for the raid',
    `Title` = 'Citadel Re-Entry',
    `Objectives` = 'Form a raid group and enter Crown Citadel to begin the elite raid encounter.',
    `Details` = 'With your training complete, it''s time for the real challenge. Form a raid group and enter Crown Citadel. The true guardians await.',
    `OfferRewardText` = 'The elite raid begins. Coordinate perfectly - there are no second chances.',
    `RequestItemsText` = 'Have you entered the citadel for the raid?',
    `EndText` = 'You have entered Crown Citadel.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 70000,
    `Flags` = 0
WHERE `entry` = 10340;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10340, 0, 50, 45, 10341, 0, 70000, 103030, 1,
    'Enter Crown Citadel for the raid',
    'Citadel Re-Entry',
    'Form a raid group and enter Crown Citadel to begin the elite raid encounter.',
    'With your training complete, it''s time for the real challenge. Form a raid group and enter Crown Citadel. The true guardians await.',
    'The elite raid begins. Coordinate perfectly - there are no second chances.',
    'Have you entered the citadel for the raid?',
    'You have entered Crown Citadel.',
    'Return to the Crown Seeker.',
    70000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10340);

-- A5.32: Guardian of the Throne (10341)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10342,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 75000,
    `RequiredNpcOrGo1` = 103031, -- Guardian of the Throne
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the Guardian of the Throne',
    `Title` = 'Guardian of the Throne',
    `Objectives` = 'Defeat the Guardian of the Throne, the first elite boss in Crown Citadel.',
    `Details` = 'The Guardian of the Throne tests your raid''s basic coordination. This powerful entity requires perfect tanking, healing, and DPS execution.',
    `OfferRewardText` = 'The Guardian falls! Your raid coordination is exemplary.',
    `RequestItemsText` = 'Have you defeated the Guardian of the Throne?',
    `EndText` = 'You have defeated the Guardian of the Throne.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 75000,
    `Flags` = 0
WHERE `entry` = 10341;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10341, 0, 50, 45, 10342, 0, 75000, 103031, 1,
    'Defeat the Guardian of the Throne',
    'Guardian of the Throne',
    'Defeat the Guardian of the Throne, the first elite boss in Crown Citadel.',
    'The Guardian of the Throne tests your raid''s basic coordination. This powerful entity requires perfect tanking, healing, and DPS execution.',
    'The Guardian falls! Your raid coordination is exemplary.',
    'Have you defeated the Guardian of the Throne?',
    'You have defeated the Guardian of the Throne.',
    'Return to the Crown Seeker.',
    75000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10341);

-- A5.33: Crown Sentinel (10342)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10343,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 80000,
    `RequiredNpcOrGo1` = 103032, -- Crown Sentinel
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the Crown Sentinel',
    `Title` = 'Crown Sentinel',
    `Objectives` = 'Defeat the Crown Sentinel, testing raid interrupt and dispel coordination.',
    `Details` = 'The Crown Sentinel requires precise interrupt timing and dispel coordination. Missing interrupts or failing to dispel can wipe the raid.',
    `OfferRewardText` = 'The Sentinel is silenced! Interrupt discipline carries the day.',
    `RequestItemsText` = 'Have you defeated the Crown Sentinel?',
    `EndText` = 'You have defeated the Crown Sentinel.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 80000,
    `Flags` = 0
WHERE `entry` = 10342;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10342, 0, 50, 45, 10343, 0, 80000, 103032, 1,
    'Defeat the Crown Sentinel',
    'Crown Sentinel',
    'Defeat the Crown Sentinel, testing raid interrupt and dispel coordination.',
    'The Crown Sentinel requires precise interrupt timing and dispel coordination. Missing interrupts or failing to dispel can wipe the raid.',
    'The Sentinel is silenced! Interrupt discipline carries the day.',
    'Have you defeated the Crown Sentinel?',
    'You have defeated the Crown Sentinel.',
    'Return to the Crown Seeker.',
    80000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10342);

-- A5.34: Chamber of Echoes (10343)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10344,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 85000,
    `RequiredNpcOrGo1` = 103033, -- Echo Lord
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the Echo Lord',
    `Title` = 'Chamber of Echoes',
    `Objectives` = 'Navigate the Chamber of Echoes and defeat the Echo Lord.',
    `Details` = 'The Chamber of Echoes creates illusions and echoes that must be managed. The Echo Lord requires careful positioning and crowd control.',
    `OfferRewardText` = 'The echoes fade! Positioning and CC mastery prevails.',
    `RequestItemsText` = 'Have you defeated the Echo Lord?',
    `EndText` = 'You have completed the Chamber of Echoes.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 85000,
    `Flags` = 0
WHERE `entry` = 10343;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10343, 0, 50, 45, 10344, 0, 85000, 103033, 1,
    'Defeat the Echo Lord',
    'Chamber of Echoes',
    'Navigate the Chamber of Echoes and defeat the Echo Lord.',
    'The Chamber of Echoes creates illusions and echoes that must be managed. The Echo Lord requires careful positioning and crowd control.',
    'The echoes fade! Positioning and CC mastery prevails.',
    'Have you defeated the Echo Lord?',
    'You have completed the Chamber of Echoes.',
    'Return to the Crown Seeker.',
    85000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10343);

-- A5.35: Crown Weaver (10344)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10345,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 90000,
    `RequiredNpcOrGo1` = 103034, -- Crown Weaver
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the Crown Weaver',
    `Title` = 'Crown Weaver',
    `Objectives` = 'Defeat the Crown Weaver, master of phase transitions and adaptations.',
    `Details` = 'The Crown Weaver changes tactics mid-fight, requiring the raid to adapt quickly. Phase transitions test your raid''s flexibility.',
    `OfferRewardText` = 'The Weaver is undone! Adaptation and quick thinking wins.',
    `RequestItemsText` = 'Have you defeated the Crown Weaver?',
    `EndText` = 'You have defeated the Crown Weaver.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 90000,
    `Flags` = 0
WHERE `entry` = 10344;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10344, 0, 50, 45, 10345, 0, 90000, 103034, 1,
    'Defeat the Crown Weaver',
    'Crown Weaver',
    'Defeat the Crown Weaver, master of phase transitions and adaptations.',
    'The Crown Weaver changes tactics mid-fight, requiring the raid to adapt quickly. Phase transitions test your raid''s flexibility.',
    'The Weaver is undone! Adaptation and quick thinking wins.',
    'Have you defeated the Crown Weaver?',
    'You have defeated the Crown Weaver.',
    'Return to the Crown Seeker.',
    90000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10344);

-- A5.36: Vault of Whispers (10345)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10346,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 95000,
    `RequiredNpcOrGo1` = 103035, -- Whisper King
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Defeat the Whisper King',
    `Title` = 'Vault of Whispers',
    `Objectives` = 'Navigate the Vault of Whispers and defeat the Whisper King.',
    `Details` = 'The Vault of Whispers tests raid awareness and communication. The Whisper King''s mechanics require perfect coordination.',
    `OfferRewardText` = 'The whispers cease! Communication and awareness triumph.',
    `RequestItemsText` = 'Have you defeated the Whisper King?',
    `EndText` = 'You have completed the Vault of Whispers.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 95000,
    `Flags` = 0
WHERE `entry` = 10345;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10345, 0, 50, 45, 10346, 0, 95000, 103035, 1,
    'Defeat the Whisper King',
    'Vault of Whispers',
    'Navigate the Vault of Whispers and defeat the Whisper King.',
    'The Vault of Whispers tests raid awareness and communication. The Whisper King''s mechanics require perfect coordination.',
    'The whispers cease! Communication and awareness triumph.',
    'Have you defeated the Whisper King?',
    'You have completed the Vault of Whispers.',
    'Return to the Crown Seeker.',
    95000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10345);

-- A5.37: Crown Citadel Completion (10346)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10360,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100000,
    `RewardItemId1` = 103036, -- Citadel Completion Token
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103036, -- Citadel Completion Marker
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete Crown Citadel raid',
    `Title` = 'Crown Citadel Completion',
    `Objectives` = 'Successfully complete the full Crown Citadel raid encounter.',
    `Details` = 'You have conquered Crown Citadel! The raid mechanics have been mastered, and the path to the Lost Crown is clear.',
    `OfferRewardText` = 'Crown Citadel is yours! The ultimate raid victory is achieved.',
    `RequestItemsText` = 'Have you completed Crown Citadel?',
    `EndText` = 'You have completed Crown Citadel.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 100000,
    `
Flags` = 0
WHERE `entry` = 10346;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10346, 0, 50, 45, 10360, 0, 100000, 103036, 1, 103036, 1,
    'Complete Crown Citadel raid',
    'Crown Citadel Completion',
    'Successfully complete the full Crown Citadel raid encounter.',
    'You have conquered Crown Citadel! The raid mechanics have been mastered, and the path to the Lost Crown is clear.',
    'Crown Citadel is yours! The ultimate raid victory is achieved.',
    'Have you completed Crown Citadel?',
    'You have completed Crown Citadel.',
    'Return to the Crown Seeker.',
    100000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10346);

-- ==================================================
-- CURSED ARTIFACT EXTRACTION (10360-10369)
-- ==================================================

-- A5.38: Curse Analysis (10360)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10361,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 80000,
    `RequiredNpcOrGo1` = 103037, -- Curse Analyzer
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Analyze the crown''s curse',
    `Title` = 'Curse Analysis',
    `Objectives` = 'Use the Curse Analyzer to understand the nature of the Lost Crown''s curse.',
    `Details` = 'The Lost Crown''s curse is complex and dangerous. Use specialized equipment to analyze its properties before attempting extraction.',
    `OfferRewardText` = 'The curse is analyzed. It feeds on power and corrupts the wielder.',
    `RequestItemsText` = 'Have you analyzed the curse?',
    `EndText` = 'You have analyzed the crown''s curse.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 80000,
    `Flags` = 0
WHERE `entry` = 10360;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10360, 0, 50, 45, 10361, 0, 80000, 103037, 1,
    'Analyze the crown''s curse',
    'Curse Analysis',
    'Use the Curse Analyzer to understand the nature of the Lost Crown''s curse.',
    'The Lost Crown''s curse is complex and dangerous. Use specialized equipment to analyze its properties before attempting extraction.',
    'The curse is analyzed. It feeds on power and corrupts the wielder.',
    'Have you analyzed the curse?',
    'You have analyzed the crown''s curse.',
    'Return to the Crown Seeker.',
    80000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10360);

-- A5.39: Extraction Ritual Setup (10361)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10362,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 85000,
    `RequiredNpcOrGo1` = 103038, -- Ritual Component
    `RequiredNpcOrGoCount1` = 5,
    `ObjectiveText1` = 'Gather ritual components',
    `Title` = 'Extraction Ritual Setup',
    `Objectives` = 'Gather 5 Ritual Components needed for the curse extraction ceremony.',
    `Details` = 'Extracting the curse requires a complex ritual. Gather the necessary components from throughout the citadel ruins.',
    `OfferRewardText` = 'The ritual components are gathered. The extraction can begin.',
    `RequestItemsText` = 'Have you gathered the ritual components?',
    `EndText` = 'You have set up the extraction ritual.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 85000,
    `Flags` = 0
WHERE `entry` = 10361;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10361, 0, 50, 45, 10362, 0, 85000, 103038, 5,
    'Gather ritual components',
    'Extraction Ritual Setup',
    'Gather 5 Ritual Components needed for the curse extraction ceremony.',
    'Extracting the curse requires a complex ritual. Gather the necessary components from throughout the citadel ruins.',
    'The ritual components are gathered. The extraction can begin.',
    'Have you gathered the ritual components?',
    'You have set up the extraction ritual.',
    'Return to the Crown Seeker.',
    85000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10361);

-- A5.40: Curse Binding (10362)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10363,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 90000,
    `RequiredNpcOrGo1` = 103039, -- Binding Circle
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Perform curse binding ritual',
    `Title` = 'Curse Binding',
    `Objectives` = 'Activate the Binding Circle to begin containing the crown''s curse.',
    `Details` = 'The first step of extraction is binding the curse to prevent it from spreading. Activate the binding circle at the ritual site.',
    `OfferRewardText` = 'The curse is bound! The extraction can proceed safely.',
    `RequestItemsText` = 'Have you performed the binding ritual?',
    `EndText` = 'You have bound the curse.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 90000,
    `Flags` = 0
WHERE `entry` = 10362;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10362, 0, 50, 45, 10363, 0, 90000, 103039, 1,
    'Perform curse binding ritual',
    'Curse Binding',
    'Activate the Binding Circle to begin containing the crown''s curse.',
    'The first step of extraction is binding the curse to prevent it from spreading. Activate the binding circle at the ritual site.',
    'The curse is bound! The extraction can proceed safely.',
    'Have you performed the binding ritual?',
    'You have bound the curse.',
    'Return to the Crown Seeker.',
    90000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10362);

-- A5.41: Essence Separation (10363)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10364,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 95000,
    `RequiredNpcOrGo1` = 103040, -- Essence Separator
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Separate the cursed essence',
    `Title` = 'Essence Separation',
    `Objectives` = 'Use the Essence Separator to begin separating the curse from the crown''s power.',
    `Details` = 'The curse is intertwined with the crown''s magical essence. Use the separator to carefully divide the two without destroying either.',
    `OfferRewardText` = 'The essence is separated! The crown''s true power emerges.',
    `RequestItemsText` = 'Have you separated the essence?',
    `EndText` = 'You have separated the cursed essence.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 95000,
    `Flags` = 0
WHERE `entry` = 10363;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10363, 0, 50, 45, 10364, 0, 95000, 103040, 1,
    'Separate the cursed essence',
    'Essence Separation',
    'Use the Essence Separator to begin separating the curse from the crown''s power.',
    'The curse is intertwined with the crown''s magical essence. Use the separator to carefully divide the two without destroying either.',
    'The essence is separated! The crown''s true power emerges.',
    'Have you separated the essence?',
    'You have separated the cursed essence.',
    'Return to the Crown Seeker.',
    95000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10363);

-- A5.42: Curse Containment (10364)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10365,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100000,
    `RequiredNpcOrGo1` = 103041, -- Containment Vessel
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Seal the curse in containment vessel',
    `Title` = 'Curse Containment',
    `Objectives` = 'Seal the separated curse into a Containment Vessel for safe storage.',
    `Details` = 'The extracted curse must be contained to prevent it from finding a new host. Seal it in the specially prepared containment vessel.',
    `OfferRewardText` = 'The curse is contained! It can no longer harm the living.',
    `RequestItemsText` = 'Have you contained the curse?',
    `EndText` = 'You have contained the curse.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 100000,
    `Flags` = 0
WHERE `entry` = 10364;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10364, 0, 50, 45, 10365, 0, 100000, 103041, 1,
    'Seal the curse in containment vessel',
    'Curse Containment',
    'Seal the separated curse into a Containment Vessel for safe storage.',
    'The extracted curse must be contained to prevent it from finding a new host. Seal it in the specially prepared containment vessel.',
    'The curse is contained! It can no longer harm the living.',
    'Have you contained the curse?',
    'You have contained the curse.',
    'Return to the Crown Seeker.',
    100000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10364);

-- A5.43: Crown Purification (10365)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10366,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 110000,
    `RequiredNpcOrGo1` = 103042, -- Purification Altar
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Purify the Lost Crown',
    `Title` = 'Crown Purification',
    `Objectives` = 'Use the Purification Altar to cleanse any remaining corruption from the Lost Crown.',
    `Details` = 'Even after curse extraction, residual corruption may remain. Use the purification altar to cleanse the crown completely.',
    `OfferRewardText` = 'The crown is purified! Its true power shines through.',
    `RequestItemsText` = 'Have you purified the crown?',
    `EndText` = 'You have purified the Lost Crown.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 110000,
    `Flags` = 0
WHERE `entry` = 10365;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10365, 0, 50, 45, 10366, 0, 110000, 103042, 1,
    'Purify the Lost Crown',
    'Crown Purification',
    'Use the Purification Altar to cleanse any remaining corruption from the Lost Crown.',
    'Even after curse extraction, residual corruption may remain. Use the purification altar to cleanse the crown completely.',
    'The crown is purified! Its true power shines through.',
    'Have you purified the crown?',
    'You have purified the Lost Crown.',
    'Return to the Crown Seeker.',
    110000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10365);

-- A5.44: Power Calibration (10366)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10367,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 120000,
    `RequiredNpcOrGo1` = 103043, -- Calibration Device
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Calibrate the crown''s power',
    `Title` = 'Power Calibration',
    `Objectives` = 'Use the Calibration Device to stabilize and measure the Lost Crown''s purified power.',
    `Details` = 'The purified crown''s power must be calibrated to ensure it''s safe for use. The calibration device will measure and stabilize its energies.',
    `OfferRewardText` = 'The crown''s power is calibrated! It is now safe and stable.',
    `RequestItemsText` = 'Have you calibrated the power?',
    `EndText` = 'You have calibrated the crown''s power.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 120000,
    `Flags` = 0
WHERE `entry` = 10366;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10366, 0, 50, 45, 10367, 0, 120000, 103043, 1,
    'Calibrate the crown''s power',
    'Power Calibration',
    'Use the Calibration Device to stabilize and measure the Lost Crown''s purified power.',
    'The purified crown''s power must be calibrated to ensure it''s safe for use. The calibration device will measure and stabilize its energies.',
    'The crown''s power is calibrated! It is now safe and stable.',
    'Have you calibrated the power?',
    'You have calibrated the crown''s power.',
    'Return to the Crown Seeker.',
    120000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10366);

-- A5.45: Final Extraction (10367)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10368,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 130000,
    `RequiredNpcOrGo1` = 103044, -- Extraction Complete
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete the final extraction',
    `Title` = 'Final Extraction',
    `Objectives` = 'Perform the final ritual to complete the curse extraction from the Lost Crown.',
    `Details` = 'All preparations are complete. Perform the final extraction ritual to fully separate the curse from the crown''s essence.',
    `OfferRewardText` = 'The extraction is complete! The Lost Crown is free of its curse.',
    `RequestItemsText` = 'Have you completed the final extraction?',
    `EndText` = 'You have completed the final extraction.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 130000,
    `Flags` = 0
WHERE `entry` = 10367;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10367, 0, 50, 45, 10368, 0, 130000, 103044, 1,
    'Complete the final extraction',
    'Final Extraction',
    'Perform the final ritual to complete the curse extraction from the Lost Crown.',
    'All preparations are complete. Perform the final extraction ritual to fully separate the curse from the crown''s essence.',
    'The extraction is complete! The Lost Crown is free of its curse.',
    'Have you completed the final extraction?',
    'You have completed the final extraction.',
    'Return to the Crown Seeker.',
    130000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10367);

-- A5.46: Artifact Mastery (10368)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10369,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 140000,
    `RewardItemId1` = 103045, -- Purified Crown
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103045, -- Artifact Mastery Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete artifact mastery test',
    `Title` = 'Artifact Mastery',
    `Objectives` = 'Take the Artifact Mastery Test to demonstrate your understanding of cursed artifact extraction.',
    `Details` = 'You''ve mastered the extraction of the Lost Crown''s curse. Prove your knowledge by taking the mastery test covering all aspects of artifact handling.',
    `OfferRewardText` = 'You are a master of artifact extraction! Take the purified crown as your reward.',
    `RequestItemsText` = 'Have you completed the mastery test?',
    `EndText` = 'You have mastered artifact extraction.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 140000,
    `Flags` = 0
WHERE `entry` = 10368;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10368, 0, 50, 45, 10369, 0, 140000, 103045, 1, 103045, 1,
    'Complete artifact mastery test',
    'Artifact Mastery',
    'Take the Artifact Mastery Test to demonstrate your understanding of cursed artifact extraction.',
    'You''ve mastered the extraction of the Lost Crown''s curse. Prove your knowledge by taking the mastery test covering all aspects of artifact handling.',
    'You are a master of artifact extraction! Take the purified crown as your reward.',
    'Have you completed the mastery test?',
    'You have mastered artifact extraction.',
    'Return to the Crown Seeker.',
    140000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10368);

-- A5.47: Extraction System Mastery (10369)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 50,
    `MinLevel` = 45,
    `RewardNextQuest` = 10370,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 150000,
    `RewardItemId1` = 103046, -- Extraction Mastery Manual
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103046, -- System Mastery Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete system mastery test',
    `Title` = 'Extraction System Mastery',
    `Objectives` = 'Take the System Mastery Test to demonstrate complete understanding of extraction systems.',
    `Details` = 'You have successfully extracted the curse from the Lost Crown. Now prove your mastery of the entire extraction system through comprehensive testing.',
    `OfferRewardText` = 'You have mastered extraction systems! Take this manual as your guide to future extractions.',
    `RequestItemsText` = 'Have you completed the system mastery test?',
    `EndText` = 'You have mastered extraction systems.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 150000,
    `Flags` = 0
WHERE `entry` = 10369;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10369, 0, 50, 45, 10370, 0, 150000, 103046, 1, 103046, 1,
    'Complete system mastery test',
    'Extraction System Mastery',
    'Take the System Mastery Test to demonstrate complete understanding of extraction systems.',
    'You have successfully extracted the curse from the Lost Crown. Now prove your mastery of the entire extraction system through comprehensive testing.',
    'You have mastered extraction systems! Take this manual as your guide to future extractions.',
    'Have you completed the system mastery test?',
    'You have mastered extraction systems.',
    'Return to the Crown Seeker.',
    150000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10369);

-- ==================================================
-- SEASONAL CONSEQUENCES (10370-10379)
-- ==================================================

-- A5.48: Crown''s Awakening (10370)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10371,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200000,
    `RequiredNpcOrGo1` = 103047, -- Crown Awakening Event
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Witness the crown''s awakening',
    `Title` = 'Crown''s Awakening',
    `Objectives` = 'Observe the awakening of the purified Lost Crown''s true power.',
    `Details` = 'With the curse removed, the Lost Crown begins to awaken its true potential. This event marks the beginning of endgame progression.',
    `OfferRewardText` = 'The crown awakens! New powers and challenges emerge.',
    `RequestItemsText` = 'Have you witnessed the awakening?',
    `EndText` = 'You have witnessed the crown''s awakening.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 200000,
    `Flags` = 0
WHERE `entry` = 10370;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10370, 0, 55, 50, 10371, 0, 200000, 103047, 1,
    'Witness the crown''s awakening',
    'Crown''s Awakening',
    'Observe the awakening of the purified Lost Crown''s true power.',
    'With the curse removed, the Lost Crown begins to awaken its true potential. This event marks the beginning of endgame progression.',
    'The crown awakens! New powers and challenges emerge.',
    'Have you witnessed the awakening?',
    'You have witnessed the crown''s awakening.',
    'Return to the Crown Seeker.',
    200000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10370);

-- A5.49: Seasonal Shifts (10371)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10372,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 180000,
    `RequiredNpcOrGo1` = 103048, -- Seasonal Nexus
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Investigate seasonal shifts',
    `Title` = 'Seasonal Shifts',
    `Objectives` = 'Investigate the Seasonal Nexus to understand how the crown''s awakening affects world seasons.',
    `Details` = 'The crown''s awakening has begun altering the world''s seasonal patterns. Investigate the nexus to understand these changes.',
    `OfferRewardText` = 'The seasons shift unnaturally. The crown''s power affects all of Azeroth.',
    `RequestItemsText` = 'Have you investigated the seasonal shifts?',
    `EndText` = 'You have investigated seasonal shifts.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 180000,
    `Flags` = 0
WHERE `entry` = 10371;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10371, 0, 55, 50, 10372, 0, 180000, 103048, 1,
    'Investigate seasonal shifts',
    'Seasonal Shifts',
    'Investigate the Seasonal Nexus to understand how the crown''s awakening affects world seasons.',
    'The crown''s awakening has begun altering the world''s seasonal patterns. Investigate the nexus to understand these changes.',
    'The seasons shift unnaturally. The crown''s power affects all of Azeroth.',
    'Have you investigated the seasonal shifts?',
    'You have investigated seasonal shifts.',
    'Return to the Crown Seeker.',
    180000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10371);

-- A5.50: Endgame Progression (10372)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10373,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 190000,
    `RequiredNpcOrGo1` = 103049, -- Progression Altar
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Activate endgame progression',
    `Title` = 'Endgame Progression',
    `Objectives` = 'Activate the Progression Altar to unlock advanced endgame content and challenges.',
    `Details` = 'The crown''s awakening opens new paths for the truly powerful. Activate the altar to begin your endgame journey.',
    `OfferRewardText` = 'Endgame progression unlocked! New challenges and rewards await.',
    `RequestItemsText` = 'Have you activated endgame progression?',
    `EndText` = 'You have activated endgame progression.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 190000,
    `Flags` = 0
WHERE `entry` = 10372;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10372, 0, 55, 50, 10373, 0, 190000, 103049, 1,
    'Activate endgame progression',
    'Endgame Progression',
    'Activate the Progression Altar to unlock advanced endgame content and challenges.',
    'The crown''s awakening opens new paths for the truly powerful. Activate the altar to begin your endgame journey.',
    'Endgame progression unlocked! New challenges and rewards await.',
    'Have you activated endgame progression?',
    'You have activated endgame progression.',
    'Return to the Crown Seeker.',
    190000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10372);

-- A5.51: Crown''s Influence (10373)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10374,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200000,
    `RequiredNpcOrGo1` = 103050, -- Influence Beacon
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Calibrate influence beacons',
    `Title` = 'Crown''s Influence',
    `Objectives` = 'Calibrate 3 Influence Beacons to stabilize the crown''s growing power across Azeroth.',
    `Details` = 'The crown''s influence spreads across the world. Calibrate beacons to ensure its power benefits rather than destroys.',
    `OfferRewardText` = 'The beacons are calibrated. The crown''s influence brings prosperity.',
    `RequestItemsText` = 'Have you calibrated the influence beacons?',
    `EndText` = 'You have stabilized the crown''s influence.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 200000,
    `Flags` = 0
WHERE `entry` = 10373;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10373, 0, 55, 50, 10374, 0, 200000, 103050, 3,
    'Calibrate influence beacons',
    'Crown''s Influence',
    'Calibrate 3 Influence Beacons to stabilize the crown''s growing power across Azeroth.',
    'The crown''s influence spreads across the world. Calibrate beacons to ensure its power benefits rather than destroys.',
    'The beacons are calibrated. The crown''s influence brings prosperity.',
    'Have you calibrated the influence beacons?',
    'You have stabilized the crown''s influence.',
    'Return to the Crown Seeker.',
    200000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10373);

-- A5.52: Eternal Winter (10374)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10375,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 210000,
    `RequiredNpcOrGo1` = 103051, -- Winter Nexus
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Stabilize the winter nexus',
    `Title` = 'Eternal Winter',
    `Objectives` = 'Stabilize the Winter Nexus to prevent the crown''s power from causing eternal winter.',
    `Details` = 'The crown''s awakening has disrupted seasonal balance, causing an eternal winter. Stabilize the nexus to restore natural cycles.',
    `OfferRewardText` = 'The winter nexus is stabilized. Seasons flow naturally once more.',
    `RequestItemsText` = 'Have you stabilized the winter nexus?',
    `EndText` = 'You have ended the eternal winter.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 210000,
    `Flags` = 0
WHERE `entry` = 10374;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10374, 0, 55, 50, 10375, 0, 210000, 103051, 1,
    'Stabilize the winter nexus',
    'Eternal Winter',
    'Stabilize the Winter Nexus to prevent the crown''s power from causing eternal winter.',
    'The crown''s awakening has disrupted seasonal balance, causing an eternal winter. Stabilize the nexus to restore natural cycles.',
    'The winter nexus is stabilized. Seasons flow naturally once more.',
    'Have you stabilized the winter nexus?',
    'You have ended the eternal winter.',
    'Return to the Crown Seeker.',
    210000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10374);

-- A5.53: Crown''s Legacy (10375)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10376,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 220000,
    `RequiredNpcOrGo1` = 103052, -- Legacy Vault
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Secure the crown''s legacy',
    `Title` = 'Crown''s Legacy',
    `Objectives` = 'Enter the Legacy Vault and secure the historical records of the Lost Crown.',
    `Details` = 'The crown has a long history that must be preserved. Enter the legacy vault to secure its records for future generations.',
    `OfferRewardText` = 'The crown''s legacy is secured. Its history will inspire future heroes.',
    `RequestItemsText` = 'Have you secured the legacy?',
    `EndText` = 'You have secured the crown''s legacy.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 220000,
    `Flags` = 0
WHERE `entry` = 10375;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10375, 0, 55, 50, 10376, 0, 220000, 103052, 1,
    'Secure the crown''s legacy',
    'Crown''s Legacy',
    'Enter the Legacy Vault and secure the historical records of the Lost Crown.',
    'The crown has a long history that must be preserved. Enter the legacy vault to secure its records for future generations.',
    'The crown''s legacy is secured. Its history will inspire future heroes.',
    'Have you secured the legacy?',
    'You have secured the crown''s legacy.',
    'Return to the Crown Seeker.',
    220000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10375);

-- A5.54: Final Consequence (10376)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10377,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 250000,
    `RequiredNpcOrGo1` = 103053, -- Consequence Altar
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Accept the final consequence',
    `Title` = 'Final Consequence',
    `Objectives` = 'Activate the Consequence Altar to accept the final responsibility of wielding the Lost Crown.',
    `Details` = 'True power comes with responsibility. Activate the altar to accept the consequences of the crown''s full awakening.',
    `OfferRewardText` = 'You accept the final consequence. The crown''s true power is yours.',
    `RequestItemsText` = 'Have you accepted the final consequence?',
    `EndText` = 'You have accepted the final consequence.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 250000,
    `Flags` = 0
WHERE `entry` = 10376;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10376, 0, 55, 50, 10377, 0, 250000, 103053, 1,
    'Accept the final consequence',
    'Final Consequence',
    'Activate the Consequence Altar to accept the final responsibility of wielding the Lost Crown.',
    'True power comes with responsibility. Activate the altar to accept the consequences of the crown''s full awakening.',
    'You accept the final consequence. The crown''s true power is yours.',
    'Have you accepted the final consequence?',
    'You have accepted the final consequence.',
    'Return to the Crown Seeker.',
    250000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10376);

-- A5.55: Crown''s Guardian (10377)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10378,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 300000,
    `RequiredNpcOrGo1` = 103054, -- Guardian Challenge
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Prove worthy as crown guardian',
    `Title` = 'Crown''s Guardian',
    `Objectives` = 'Complete the Guardian Challenge to prove you are worthy of being the Lost Crown''s guardian.',
    `Details` = 'As the crown''s power grows, it requires a worthy guardian. Prove your worth through this ultimate challenge.',
    `OfferRewardText` = 'You are worthy! The crown recognizes you as its guardian.',
    `RequestItemsText` = 'Have you proven worthy?',
    `EndText` = 'You have proven worthy as crown guardian.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 300000,
    `Flags` = 0
WHERE `entry` = 10377;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10377, 0, 55, 50, 10378, 0, 300000, 103054, 1,
    'Prove worthy as crown guardian',
    'Crown''s Guardian',
    'Complete the Guardian Challenge to prove you are worthy of being the Lost Crown''s guardian.',
    'As the crown''s power grows, it requires a worthy guardian. Prove your worth through this ultimate challenge.',
    'You are worthy! The crown recognizes you as its guardian.',
    'Have you proven worthy?',
    'You have proven
worthy as crown guardian.',
    'Return to the Crown Seeker.',
    300000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10377);

-- A5.56: Eternal Crown (10378)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardNextQuest` = 10379,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 350000,
    `RequiredNpcOrGo1` = 103055, -- Crown Synthesis
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete crown synthesis',
    `Title` = 'Eternal Crown',
    `Objectives` = 'Perform the final synthesis to merge with the Lost Crown''s power.',
    `Details` = 'The ultimate step: merge your essence with the crown''s power to become its eternal guardian. This is the final endgame progression.',
    `OfferRewardText` = 'You are one with the crown! Eternal power flows through you.',
    `RequestItemsText` = 'Have you completed the synthesis?',
    `EndText` = 'You have become the Eternal Crown.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 350000,
    `Flags` = 0
WHERE `entry` = 10378;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10378, 0, 55, 50, 10379, 0, 350000, 103055, 1,
    'Complete crown synthesis',
    'Eternal Crown',
    'Perform the final synthesis to merge with the Lost Crown''s power.',
    'The ultimate step: merge your essence with the crown''s power to become its eternal guardian. This is the final endgame progression.',
    'You are one with the crown! Eternal power flows through you.',
    'Have you completed the synthesis?',
    'You have become the Eternal Crown.',
    'Return to the Crown Seeker.',
    350000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10378);

-- A5.57: Crown''s Dominion (10379)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 55,
    `MinLevel` = 50,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500000,
    `RewardItemId1` = 103056, -- Crown of Dominion
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 103056, -- Dominion Achievement
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Achieve crown dominion',
    `Title` = 'Crown''s Dominion',
    `Objectives` = 'Complete the final achievement to gain dominion over the Lost Crown''s power.',
    `Details` = 'You have mastered every aspect of the Lost Crown. This final achievement grants you complete dominion over its power and marks the end of your endgame journey.',
    `OfferRewardText` = 'You have achieved dominion! The Lost Crown is yours to command eternally.',
    `RequestItemsText` = 'Have you achieved dominion?',
    `EndText` = 'You have achieved Crown''s Dominion.',
    `CompletedText` = 'Return to the Crown Seeker.',
    `RewOrReqMoney` = 500000,
    `Flags` = 0
WHERE `entry` = 10379;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10379, 0, 55, 50, 0, 500000, 103056, 1, 103056, 1,
    'Achieve crown dominion',
    'Crown''s Dominion',
    'Complete the final achievement to gain dominion over the Lost Crown''s power.',
    'You have mastered every aspect of the Lost Crown. This final achievement grants you complete dominion over its power and marks the end of your endgame journey.',
    'You have achieved dominion! The Lost Crown is yours to command eternally.',
    'Have you achieved dominion?',
    'You have achieved Crown''s Dominion.',
    'Return to the Crown Seeker.',
    500000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10379);

-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10300, 'STORY_REWRITE', NULL, 'Act V Quest - Whispers of the Lost Crown'),
(10301, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Citadel Location'),
(10302, 'STORY_REWRITE', NULL, 'Act V Quest - Citadel Guardians'),
(10303, 'STORY_REWRITE', NULL, 'Act V Quest - Raid Preparation Basics'),
(10304, 'STORY_REWRITE', NULL, 'Act V Quest - Understanding Roles'),
(10305, 'STORY_REWRITE', NULL, 'Act V Quest - Tank Role Training'),
(10306, 'STORY_REWRITE', NULL, 'Act V Quest - Healer Role Training'),
(10307, 'STORY_REWRITE', NULL, 'Act V Quest - DPS Role Training'),
(10308, 'STORY_REWRITE', NULL, 'Act V Quest - Raid Communication'),
(10309, 'STORY_REWRITE', NULL, 'Act V Quest - Positioning and Movement'),
(10310, 'STORY_REWRITE', NULL, 'Act V Quest - Encounter Mechanics'),
(10311, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Citadel Approach'),
(10312, 'STORY_REWRITE', NULL, 'Act V Quest - First Guardian'),
(10313, 'STORY_REWRITE', NULL, 'Act V Quest - Citadel Interior'),
(10314, 'STORY_REWRITE', NULL, 'Act V Quest - Chamber of Trials'),
(10315, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Vault Approach'),
(10316, 'STORY_REWRITE', NULL, 'Act V Quest - The Lost Crown'),
(10317, 'STORY_REWRITE', NULL, 'Act V Quest - Cursed Power'),
(10318, 'STORY_REWRITE', NULL, 'Act V Quest - Extraction Preparation'),
(10319, 'STORY_REWRITE', NULL, 'Act V Quest - Lost Crown Mastery'),
(10320, 'STORY_REWRITE', NULL, 'Act V Quest - Advanced Tank Training'),
(10321, 'STORY_REWRITE', NULL, 'Act V Quest - Healing Coordination'),
(10322, 'STORY_REWRITE', NULL, 'Act V Quest - DPS Optimization'),
(10323, 'STORY_REWRITE', NULL, 'Act V Quest - Interrupt Discipline'),
(10324, 'STORY_REWRITE', NULL, 'Act V Quest - Dispel Awareness'),
(10325, 'STORY_REWRITE', NULL, 'Act V Quest - Raid Leadership'),
(10326, 'STORY_REWRITE', NULL, 'Act V Quest - Emergency Protocols'),
(10327, 'STORY_REWRITE', NULL, 'Act V Quest - Phase Transitions'),
(10328, 'STORY_REWRITE', NULL, 'Act V Quest - Add Control'),
(10329, 'STORY_REWRITE', NULL, 'Act V Quest - Raid Mechanics Mastery'),
(10340, 'STORY_REWRITE', NULL, 'Act V Quest - Citadel Re-Entry'),
(10341, 'STORY_REWRITE', NULL, 'Act V Quest - Guardian of the Throne'),
(10342, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Sentinel'),
(10343, 'STORY_REWRITE', NULL, 'Act V Quest - Chamber of Echoes'),
(10344, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Weaver'),
(10345, 'STORY_REWRITE', NULL, 'Act V Quest - Vault of Whispers'),
(10346, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Citadel Completion'),
(10360, 'STORY_REWRITE', NULL, 'Act V Quest - Curse Analysis'),
(10361, 'STORY_REWRITE', NULL, 'Act V Quest - Extraction Ritual Setup'),
(10362, 'STORY_REWRITE', NULL, 'Act V Quest - Curse Binding'),
(10363, 'STORY_REWRITE', NULL, 'Act V Quest - Essence Separation'),
(10364, 'STORY_REWRITE', NULL, 'Act V Quest - Curse Containment'),
(10365, 'STORY_REWRITE', NULL, 'Act V Quest - Crown Purification'),
(10366, 'STORY_REWRITE', NULL, 'Act V Quest - Power Calibration'),
(10367, 'STORY_REWRITE', NULL, 'Act V Quest - Final Extraction'),
(10368, 'STORY_REWRITE', NULL, 'Act V Quest - Artifact Mastery'),
(10369, 'STORY_REWRITE', NULL, 'Act V Quest - Extraction System Mastery'),
(10370, 'STORY_REWRITE', NULL, 'Act V Quest - Crown''s Awakening'),
(10371, 'STORY_REWRITE', NULL, 'Act V Quest - Seasonal Shifts'),
(10372, 'STORY_REWRITE', NULL, 'Act V Quest - Endgame Progression'),
(10373, 'STORY_REWRITE', NULL, 'Act V Quest - Crown''s Influence'),
(10374, 'STORY_REWRITE', NULL, 'Act V Quest - Eternal Winter'),
(10375, 'STORY_REWRITE', NULL, 'Act V Quest - Crown''s Legacy'),
(10376, 'STORY_REWRITE', NULL, 'Act V Quest - Final Consequence'),
(10377, 'STORY_REWRITE', NULL, 'Act V Quest - Crown''s Guardian'),
(10378, 'STORY_REWRITE', NULL, 'Act V Quest - Eternal Crown'),
(10379, 'STORY_REWRITE', NULL, 'Act V Quest - Crown''s Dominion')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `notes` = VALUES(`notes`);