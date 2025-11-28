-- ==================================================
-- Mortal Warcraft – Campaign Act IV Breach of the Frontier
-- Spec 72: Stronghold/Invasion Campaign
-- Quest IDs: 10200-10259
-- Target DB: world
-- ==================================================

-- ==================================================
-- TERRITORY CONTROL BASICS (10200-10219)
-- ==================================================

-- A4.1: The Frontier Calls (10200)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10201,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500,
    `RequiredNpcOrGo1` = 102000, -- Frontier Scout
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with Frontier Scout about territory control',
    `Title` = 'The Frontier Calls',
    `Objectives` = 'Travel to the frontier outpost and speak with the Frontier Scout about the changing landscape of territorial control.',
    `Details` = 'The frontier is changing. Ancient strongholds that were once abandoned are now being claimed by guilds and factions. The balance of power shifts daily. Speak with the Frontier Scout - they''ll explain what you need to know about territory control.',
    `OfferRewardText` = 'Welcome to the frontier. Territory control is the new reality. Let me teach you the basics.',
    `RequestItemsText` = 'You''ve arrived at the frontier outpost.',
    `EndText` = 'You have learned about the frontier.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 500,
    `Flags` = 0
WHERE `entry` = 10200;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10200, 0, 20, 15, 10201, 0, 500, 102000, 0,
    'Speak with Frontier Scout about territory control',
    'The Frontier Calls',
    'Travel to the frontier outpost and speak with the Frontier Scout about the changing landscape of territorial control.',
    'The frontier is changing. Ancient strongholds that were once abandoned are now being claimed by guilds and factions. The balance of power shifts daily. Speak with the Frontier Scout - they''ll explain what you need to know about territory control.',
    'Welcome to the frontier. Territory control is the new reality. Let me teach you the basics.',
    'You''ve arrived at the frontier outpost.',
    'You have learned about the frontier.',
    'Return to the Frontier Scout.',
    500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10200);

-- A4.2: Zone States Explained (10201)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10202,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 750,
    `RequiredNpcOrGo1` = 102001, -- Territory Map
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Study the territory map and learn zone states',
    `Title` = 'Zone States Explained',
    `Objectives` = 'Examine the Territory Map at the outpost to understand the three zone states: Neutral, Contested, and Controlled.',
    `Details` = 'Every zone has a state that determines what happens there. Neutral zones are wild and uncontrolled. Contested zones are being fought over. Controlled zones belong to a guild or faction. Study the map to understand these states.',
    `OfferRewardText` = 'You understand the zone states now. Neutral zones are free for all. Contested zones are battlegrounds. Controlled zones have owners.',
    `RequestItemsText` = 'Have you studied the territory map?',
    `EndText` = 'You have learned about zone states.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 750,
    `Flags` = 0
WHERE `entry` = 10201;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10201, 0, 20, 15, 10202, 0, 750, 102001, 1,
    'Study the territory map and learn zone states',
    'Zone States Explained',
    'Examine the Territory Map at the outpost to understand the three zone states: Neutral, Contested, and Controlled.',
    'Every zone has a state that determines what happens there. Neutral zones are wild and uncontrolled. Contested zones are being fought over. Controlled zones belong to a guild or faction. Study the map to understand these states.',
    'You understand the zone states now. Neutral zones are free for all. Contested zones are battlegrounds. Controlled zones have owners.',
    'Have you studied the territory map?',
    'You have learned about zone states.',
    'Return to the Frontier Scout.',
    750, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10201);

-- A4.3: Control Points (10202)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10203,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1000,
    `RequiredNpcOrGo1` = 102002, -- Control Point Marker
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Locate and examine a control point marker',
    `Title` = 'Control Points',
    `Objectives` = 'Find a Control Point Marker in a nearby neutral zone and examine it to understand how territory control works.',
    `Details` = 'Control points are the keys to territory control. These markers show where zones can be claimed. In neutral zones, anyone can attempt to capture them. Once captured, they become contested, then controlled. Go find one and see how it works.',
    `OfferRewardText` = 'Control points are the heart of territory control. They determine zone ownership and provide benefits to controllers.',
    `RequestItemsText` = 'Have you found and examined a control point?',
    `EndText` = 'You have learned about control points.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 1000,
    `Flags` = 0
WHERE `entry` = 10202;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10202, 0, 20, 15, 10203, 0, 1000, 102002, 1,
    'Locate and examine a control point marker',
    'Control Points',
    'Find a Control Point Marker in a nearby neutral zone and examine it to understand how territory control works.',
    'Control points are the keys to territory control. These markers show where zones can be claimed. In neutral zones, anyone can attempt to capture them. Once captured, they become contested, then controlled. Go find one and see how it works.',
    'Control points are the heart of territory control. They determine zone ownership and provide benefits to controllers.',
    'Have you found and examined a control point?',
    'You have learned about control points.',
    'Return to the Frontier Scout.',
    1000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10202);

-- A4.4: Resource Siphoning (10203)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10204,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1250,
    `RequiredNpcOrGo1` = 102003, -- Resource Node
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Harvest resources from a controlled territory',
    `Title` = 'Resource Siphoning',
    `Objectives` = 'Visit a controlled territory and harvest resources from a Resource Node to understand resource siphoning mechanics.',
    `Details` = 'Controlled territories generate resources over time. Guilds that control zones get a share of these resources. Visit a controlled zone and harvest from a resource node to see how it works. You''ll need permission from the controlling guild.',
    `OfferRewardText` = 'Resource siphoning provides steady income to territory controllers. The more zones you control, the more resources you generate.',
    `RequestItemsText` = 'Have you harvested resources from a controlled territory?',
    `EndText` = 'You have learned about resource siphoning.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 1250,
    `Flags` = 0
WHERE `entry` = 10203;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10203, 0, 20, 15, 10204, 0, 1250, 102003, 1,
    'Harvest resources from a controlled territory',
    'Resource Siphoning',
    'Visit a controlled territory and harvest resources from a Resource Node to understand resource siphoning mechanics.',
    'Controlled territories generate resources over time. Guilds that control zones get a share of these resources. Visit a controlled zone and harvest from a resource node to see how it works. You''ll need permission from the controlling guild.',
    'Resource siphoning provides steady income to territory controllers. The more zones you control, the more resources you generate.',
    'Have you harvested resources from a controlled territory?',
    'You have learned about resource siphoning.',
    'Return to the Frontier Scout.',
    1250, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10203);

-- A4.5: Territory Services (10204)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10205,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1500,
    `RequiredNpcOrGo1` = 102004, -- Territory Service NPC
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Use a territory service in a controlled zone',
    `Title` = 'Territory Services',
    `Objectives` = 'Find and use a Territory Service (such as a repair bot or ammo vendor) in a controlled zone.',
    `Details` = 'Controlling territories isn''t just about resources. Guilds can establish services in their territories - repair bots, ammo vendors, guild banks. These services are only available in controlled zones. Find one and use it.',
    `OfferRewardText` = 'Territory services provide strategic advantages. Repair bots save time, ammo vendors ensure you''re always stocked, guild banks provide secure storage.',
    `RequestItemsText` = 'Have you used a territory service?',
    `EndText` = 'You have learned about territory services.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 1500,
    `Flags` = 0
WHERE `entry` = 10204;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10204, 0, 20, 15, 10205, 0, 1500, 102004, 1,
    'Use a territory service in a controlled zone',
    'Territory Services',
    'Find and use a Territory Service (such as a repair bot or ammo vendor) in a controlled zone.',
    'Controlling territories isn''t just about resources. Guilds can establish services in their territories - repair bots, ammo vendors, guild banks. These services are only available in controlled zones. Find one and use it.',
    'Territory services provide strategic advantages. Repair bots save time, ammo vendors ensure you''re always stocked, guild banks provide secure storage.',
    'Have you used a territory service?',
    'You have learned about territory services.',
    'Return to the Frontier Scout.',
    1500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10204);

-- A4.6: Vulnerability Windows (10205)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10206,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1750,
    `RequiredNpcOrGo1` = 102005, -- Vulnerability Timer
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Observe a vulnerability window timer',
    `Title` = 'Vulnerability Windows',
    `Objectives` = 'Find a Vulnerability Timer at a control point and observe how vulnerability windows work.',
    `Details` = 'No territory is completely safe. Every controlled zone has vulnerability windows - specific times when it can be attacked. During these windows, defenders get buffs but attackers can challenge control. Check a vulnerability timer to understand this mechanic.',
    `OfferRewardText` = 'Vulnerability windows create strategic depth. Attack during windows for advantage, defend during them for bonuses.',
    `RequestItemsText` = 'Have you observed a vulnerability window?',
    `EndText` = 'You have learned about vulnerability windows.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 1750,
    `Flags` = 0
WHERE `entry` = 10205;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10205, 0, 20, 15, 10206, 0, 1750, 102005, 1,
    'Observe a vulnerability window timer',
    'Vulnerability Windows',
    'Find a Vulnerability Timer at a control point and observe how vulnerability windows work.',
    'No territory is completely safe. Every controlled zone has vulnerability windows - specific times when it can be attacked. During these windows, defenders get buffs but attackers can challenge control. Check a vulnerability timer to understand this mechanic.',
    'Vulnerability windows create strategic depth. Attack during windows for advantage, defend during them for bonuses.',
    'Have you observed a vulnerability window?',
    'You have learned about vulnerability windows.',
    'Return to the Frontier Scout.',
    1750, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10205);

-- A4.7: First Capture (10206)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10207,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2000,
    `RequiredNpcOrGo1` = 102006, -- Captured Control Point
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Participate in capturing a neutral control point',
    `Title` = 'First Capture',
    `Objectives` = 'Join other players in capturing a neutral control point. Work together to establish control.',
    `Details` = 'Time to put theory into practice. Find a neutral control point and help capture it. You''ll need to work with others - territory control is a team effort. Once captured, the zone becomes contested.',
    `OfferRewardText` = 'Congratulations on your first territory capture! You now understand the basics of claiming land.',
    `RequestItemsText` = 'Have you participated in capturing a control point?',
    `EndText` = 'You have captured your first territory.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 2000,
    `Flags` = 0
WHERE `entry` = 10206;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10206, 0, 20, 15, 10207, 0, 2000, 102006, 1,
    'Participate in capturing a neutral control point',
    'First Capture',
    'Join other players in capturing a neutral control point. Work together to establish control.',
    'Time to put theory into practice. Find a neutral control point and help capture it. You''ll need to work with others - territory control is a team effort. Once captured, the zone becomes contested.',
    'Congratulations on your first territory capture! You now understand the basics of claiming land.',
    'Have you participated in capturing a control point?',
    'You have captured your first territory.',
    'Return to the Frontier Scout.',
    2000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10206);

-- A4.8: Defense Basics (10207)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10208,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2250,
    `RequiredNpcOrGo1` = 102007, -- Defended Territory
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Help defend a contested territory',
    `Title` = 'Defense Basics',
    `Objectives` = 'Find a contested territory under attack and help defend it from invaders.',
    `Details` = 'Now you know how to capture territory, but can you hold it? Find a contested zone that''s being attacked and help defend it. Defense requires coordination and strategy.',
    `OfferRewardText` = 'Defense is just as important as offense. Holding territory requires vigilance and teamwork.',
    `RequestItemsText` = 'Have you helped defend a contested territory?',
    `EndText` = 'You have learned the basics of defense.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 2250,
    `Flags` = 0
WHERE `entry` = 10207;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10207, 0, 20, 15, 10208, 0, 2250, 102007, 1,
    'Help defend a contested territory',
    'Defense Basics',
    'Find a contested territory under attack and help defend it from invaders.',
    'Now you know how to capture territory, but can you hold it? Find a contested zone that''s being attacked and help defend it. Defense requires coordination and strategy.',
    'Defense is just as important as offense. Holding territory requires vigilance and teamwork.',
    'Have you helped defend a contested territory?',
    'You have learned the basics of defense.',
    'Return to the Frontier Scout.',
    2250, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10207);

-- A4.9: Territory Ownership (10208)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10209,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2500,
    `RequiredNpcOrGo1` = 102008, -- Ownership Marker
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Check ownership of a controlled territory',
    `Title` = 'Territory Ownership',
    `Objectives` = 'Visit a controlled territory and check its ownership marker to see which guild or faction controls it.',
    `Details` = 'Every controlled territory has an owner. Check the ownership markers to see who controls what. This information is crucial for planning attacks or alliances.',
    `OfferRewardText` = 'Knowing who controls what territory is essential for frontier strategy. Some territories are controlled by guilds, others by factions.',
    `RequestItemsText` = 'Have you checked a territory''s ownership?',
    `EndText` = 'You have learned about territory ownership.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 2500,
    `Flags` = 0
WHERE `entry` = 10208;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10208, 0, 20, 15, 10209, 0, 2500, 102008, 1,
    'Check ownership of a controlled territory',
    'Territory Ownership',
    'Visit a controlled territory and check its ownership marker to see which guild or faction controls it.',
    'Every controlled territory has an owner. Check the ownership markers to see who controls what. This information is crucial for planning attacks or alliances.',
    'Knowing who controls what territory is essential for frontier strategy. Some territories are controlled by guilds, others by factions.',
    'Have you checked a territory''s ownership?',
    'You have learned about territory ownership.',
    'Return to the Frontier Scout.',
    2500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10208);

-- A4.10: Guild Coordination (10209)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10210,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2750,
    `RequiredNpcOrGo1` = 102009, -- Guild Coordinator
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Speak with a guild coordinator about territory strategy',
    `Title` = 'Guild Coordination',
    `Objectives` = 'Find a Guild Coordinator in a controlled territory and learn about guild-based territory management.',
    `Details` = 'Guilds are the backbone of territory control. They coordinate defenses, manage resources, and plan expansions. Speak with a guild coordinator to understand how guilds operate territories.',
    `OfferRewardText` = 'Guilds bring organization to chaos. They turn individual efforts into coordinated campaigns.',
    `RequestItemsText` = 'Have you spoken with a guild coordinator?',
    `EndText` = 'You have learned about guild coordination.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 2750,
    `Flags` = 0
WHERE `entry` = 10209;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10209, 0, 20, 15, 10210, 0, 2750, 102009, 1,
    'Speak with a guild coordinator about territory strategy',
    'Guild Coordination',
    'Find a Guild Coordinator in a controlled territory and learn about guild-based territory management.',
    'Guilds are the backbone of territory control. They coordinate defenses, manage resources, and plan expansions. Speak with a guild coordinator to understand how guilds operate territories.',
    'Guilds bring organization to chaos. They turn individual efforts into coordinated campaigns.',
    'Have you spoken with a guild coordinator?',
    'You have learned about guild coordination.',
    'Return to the Frontier Scout.',
    2750, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10209);

-- A4.11: Territory Control Mastery (10210)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 20,
    `MinLevel` = 15,
    `RewardNextQuest` = 10220,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3000,
    `RewardItemId1` = 102010, -- Territory Control Manual
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 102010, -- Territory Control Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete the territory control knowledge test',
    `Title` = 'Territory Control Mastery',
    `Objectives` = 'Take the Territory Control Knowledge Test to demonstrate your understanding of territory control mechanics.',
    `Details` = 'You''ve learned the basics of territory control. Now prove your knowledge by taking the test. Answer questions about zone states, control points, resources, and strategy.',
    `OfferRewardText` = 'You have mastered the fundamentals of territory control! Take this manual as a reference for your frontier adventures.',
    `RequestItemsText` = 'Have you completed the knowledge test?',
    `EndText` = 'You have mastered territory control.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 3000,
    `Flags` = 0
WHERE `entry` = 10210;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10210, 0, 20, 15, 10220, 0, 3000, 102010, 1, 102010, 1,
    'Complete the territory control knowledge test',
    'Territory Control Mastery',
    'Take the Territory Control Knowledge Test to demonstrate your understanding of territory control mechanics.',
    'You''ve learned the basics of territory control. Now prove your knowledge by taking the test. Answer questions about zone states, control points, resources, and strategy.',
    'You have mastered the fundamentals of territory control! Take this manual as a reference for your frontier adventures.',
    'Have you completed the knowledge test?',
    'You have mastered territory control.',
    'Return to the Frontier Scout.',
    3000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10210);

-- ==================================================
-- ZONE INVASION SYSTEMS (10220-10239)
-- ==================================================

-- A4.12: Invasion Warning (10220)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10221,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3500,
    `RequiredNpcOrGo1` = 102011, -- Invasion Beacon
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Investigate an invasion beacon',
    `Title` = 'Invasion Warning',
    `Objectives` = 'Find an Invasion Beacon that has activated and investigate what it means.',
    `Details` = 'The frontier is about to get more dangerous. Invasion beacons activate when hostile forces are approaching. Find one that''s lit and see what information it provides about the incoming threat.',
    `OfferRewardText` = 'Invasion beacons warn of organized attacks. They tell you who''s coming and when.',
    `RequestItemsText` = 'Have you investigated an invasion beacon?',
    `EndText` = 'You have learned about invasion warnings.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 3500,
    `Flags` = 0
WHERE `entry` = 10220;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10220, 0, 25, 20, 10221, 0, 3500, 102011, 1,
    'Investigate an invasion beacon',
    'Invasion Warning',
    'Find an Invasion Beacon that has activated and investigate what it means.',
    'The frontier is about to get more dangerous. Invasion beacons activate when hostile forces are approaching. Find one that''s lit and see what information it provides about the incoming threat.',
    'Invasion beacons warn of organized attacks. They tell you who''s coming and when.',
    'Have you investigated an invasion beacon?',
    'You have learned about invasion warnings.',
    'Return to the Frontier Scout.',
    3500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10220);

-- A4.13: Invasion Forces (10221)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10222,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4000,
    `RequiredNpcOrGo1` = 102012, -- Invasion Scout
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Speak with an invasion scout',
    `Title` = 'Invasion Forces',
    `Objectives` = 'Find and speak with an Invasion Scout to learn about the composition of invasion forces.',
    `Details` = 'Invasions aren''t random attacks. They''re organized campaigns with specific goals. Speak with an invasion scout to understand what types of forces are involved - infantry, siege weapons, spellcasters, and their tactics.',
    `OfferRewardText` = 'Invasion forces are specialized. Infantry for control points, siege for strongholds, casters for disruption.',
    `RequestItemsText` = 'Have you spoken with an invasion scout?',
    `EndText` = 'You have learned about invasion forces.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 4000,
    `Flags` = 0
WHERE `entry` = 10221;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10221, 0, 25, 20, 10222, 0, 4000, 102012, 1,
    'Speak with an invasion scout',
    'Invasion Forces',
    'Find and speak with an Invasion Scout to learn about the composition of invasion forces.',
    'Invasions aren''t random attacks. They''re organized campaigns with specific goals. Speak with an invasion scout to understand what types of forces are involved - infantry for control points, siege weapons, spellcasters, and their tactics.',
    'Invasion forces are specialized. Infantry for control points, siege for strongholds, casters for disruption.',
    'Have you spoken with an invasion scout?',
    'You have learned about invasion forces.',
    'Return to the Frontier Scout.',
    4000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10221);

-- A4.14: Invasion Phases (10222)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10223,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4500,
    `RequiredNpcOrGo1` = 102013, -- Phase Indicator
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Observe an invasion phase indicator',
    `Title` = 'Invasion Phases',
    `Objectives` = 'Find a Phase Indicator during an active invasion and observe how invasions progress through different phases.',
    `Details` = 'Invasions happen in phases. First reconnaissance, then skirmishes, then main assaults, and finally occupation. Each phase requires different defensive strategies. Watch a phase indicator to understand this progression.',
    `OfferRewardText` = 'Invasion phases determine the appropriate response. Early phases need scouts, late phases need heavy defense.',
    `RequestItemsText` = 'Have you observed invasion phases?',
    `EndText` = 'You have learned about invasion phases.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 4500,
    `Flags` = 0
WHERE `entry` = 10222;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10222, 0, 25, 20, 10223, 0, 4500, 102013, 1,
    'Observe an invasion phase indicator',
    'Invasion Phases',
    'Find a Phase Indicator during an active invasion and observe how invasions progress through different phases.',
    'Invasions happen in phases. First reconnaissance, then skirmishes, then main assaults, and finally occupation. Each phase requires different defensive strategies. Watch a phase indicator to understand this progression.',
    'Invasion phases determine the appropriate response. Early phases need scouts, late phases need heavy defense.',
    'Have you observed invasion phases?',
    'You have learned about invasion phases.',
    'Return to the Frontier Scout.',
    4500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10222);

-- A4.15: Counter-Invasion Tactics (10223)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10224,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 5000,
    `RequiredNpcOrGo1` = 102014, -- Tactical Map
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Study counter-invasion tactics on a tactical map',
    `Title` = 'Counter-Invasion Tactics',
    `Objectives` = 'Examine a Tactical Map to learn about different strategies for countering invasions.',
    `Details` = 'Defending against invasions requires strategy. Study the tactical map to understand ambushes, fortifications, reinforcements, and evacuation tactics. Each invasion type needs a different response.',
    `OfferRewardText` = 'Counter-invasion tactics turn the tide of battle. Know when to fight, when to retreat, and when to reinforce.',
    `RequestItemsText` = 'Have you studied counter-invasion tactics?',
    `EndText` = 'You have learned counter-invasion tactics.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 5000,
    `Flags` = 0
WHERE `entry` = 10223;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10223, 0, 25, 20, 10224, 0, 5000, 102014, 1,
    'Study counter-invasion tactics on a tactical map',
    'Counter-Invasion Tactics',
    'Examine a Tactical Map to learn about different strategies for countering invasions.',
    'Defending against invasions requires strategy. Study the tactical map to understand ambushes, fortifications, reinforcements, and evacuation tactics. Each invasion type needs a different response.',
    'Counter-invasion tactics turn the tide of battle. Know when to fight, when to retreat, and when to reinforce.',
    'Have you studied counter-invasion tactics?',
    'You have learned counter-invasion tactics.',
    'Return to the Frontier Scout.',
    5000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10223);

-- A4.16: Invasion Participation (10224)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10225,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 5500,
    `RequiredNpcOrGo1` = 102015, -- Invasion Commander
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Join an invasion force as a participant',
    `Title` = 'Invasion Participation',
    `Objectives` = 'Find an Invasion Commander and join their forces for an active invasion.',
    `Details` = 'Theory is good, but experience is better. Join an active invasion as a participant. You''ll see firsthand how invasions work from the attacker''s perspective.',
    `OfferRewardText` = 'Participating in invasions teaches you their rhythm and requirements. Attackers need coordination too.',
    `RequestItemsText` = 'Have you participated in an invasion?',
    `EndText` = 'You have participated in an invasion.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 5500,
    `Flags` = 0
WHERE `entry` = 10224;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10224, 0, 25, 20, 10225, 0, 5500, 102015, 1,
    'Join an invasion force as a participant',
    'Invasion Participation',
    'Find an Invasion Commander and join their forces for an active invasion.',
    'Theory is good, but experience is better. Join an active invasion as a participant. You''ll see firsthand how invasions work from the attacker''s perspective.',
    'Participating in invasions teaches you their rhythm and requirements. Attackers need coordination too.',
    'Have you participated in an invasion?',
    'You have participated in an invasion.',
    'Return to the Frontier Scout.',
    5500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10224);

-- A4.17: Invasion Defense (10225)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10226,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 6000,
    `RequiredNpcOrGo1` = 102016, -- Defense Coordinator
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Help coordinate defense against an invasion',
    `Title` = 'Invasion Defense',
    `Objectives` = 'Find a Defense Coordinator during an active invasion and help organize the defense.',
    `Details` = 'Now experience defense from the other side. During an active invasion, find a defense coordinator and help organize the resistance. You''ll learn about fortifications, troop placement, and reinforcement timing.',
    `OfferRewardText` = 'Defense coordination is an art. Position troops wisely, time reinforcements perfectly, and know when to retreat.',
    `RequestItemsText` = 'Have you helped coordinate a defense?',
    `EndText` = 'You have coordinated invasion defense.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 6000,
    `Flags` = 0
WHERE `entry` = 10225;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10225, 0, 25, 20, 10226, 0, 6000, 102016, 1,
    'Help coordinate defense against an invasion',
    'Invasion Defense',
    'Find a Defense Coordinator during an active invasion and help organize the defense.',
    'Now experience defense from the other side. During an active invasion, find a defense coordinator and help organize the resistance. You''ll learn about fortifications, troop placement, and reinforcement timing.',
    'Defense coordination is an art. Position troops wisely,
    'Defense coordination is an art. Position troops wisely, time reinforcements perfectly, and know when to retreat.',
    'Have you helped coordinate a defense?',
    'You have coordinated invasion defense.',
    'Return to the Frontier Scout.',
    6000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10225);

-- A4.18: Invasion Intelligence (10226)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10227,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 6500,
    `RequiredNpcOrGo1` = 102017, -- Intelligence Report
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Gather intelligence on invasion plans',
    `Title` = 'Invasion Intelligence',
    `Objectives` = 'Find and read an Intelligence Report about upcoming or ongoing invasion plans.',
    `Details` = 'Knowledge is power in territorial warfare. Intelligence reports contain information about enemy troop movements, supply lines, and strategic objectives. Find one and learn what it reveals.',
    `OfferRewardText` = 'Intelligence is the difference between victory and defeat. Know your enemy''s plans before they execute them.',
    `RequestItemsText` = 'Have you gathered invasion intelligence?',
    `EndText` = 'You have gathered invasion intelligence.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 6500,
    `Flags` = 0
WHERE `entry` = 10226;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10226, 0, 25, 20, 10227, 0, 6500, 102017, 1,
    'Gather intelligence on invasion plans',
    'Invasion Intelligence',
    'Find and read an Intelligence Report about upcoming or ongoing invasion plans.',
    'Knowledge is power in territorial warfare. Intelligence reports contain information about enemy troop movements, supply lines, and strategic objectives. Find one and learn what it reveals.',
    'Intelligence is the difference between victory and defeat. Know your enemy''s plans before they execute them.',
    'Have you gathered invasion intelligence?',
    'You have gathered invasion intelligence.',
    'Return to the Frontier Scout.',
    6500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10226);

-- A4.19: Invasion Logistics (10227)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10228,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 7000,
    `RequiredNpcOrGo1` = 102018, -- Supply Cache
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Disrupt or protect invasion supply lines',
    `Title` = 'Invasion Logistics',
    `Objectives` = 'Find an invasion Supply Cache and either disrupt it (if enemy) or protect it (if allied).',
    `Details` = 'Invasions require massive logistics. Supply caches feed armies, repair equipment, and maintain morale. During an invasion, find a supply cache and either destroy it to weaken attackers or defend it to support defenders.',
    `OfferRewardText` = 'Logistics win wars. Cut off supplies and armies starve. Protect supplies and armies thrive.',
    `RequestItemsText` = 'Have you affected invasion logistics?',
    `EndText` = 'You have affected invasion logistics.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 7000,
    `Flags` = 0
WHERE `entry` = 10227;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10227, 0, 25, 20, 10228, 0, 7000, 102018, 1,
    'Disrupt or protect invasion supply lines',
    'Invasion Logistics',
    'Find an invasion Supply Cache and either disrupt it (if enemy) or protect it (if allied).',
    'Invasions require massive logistics. Supply caches feed armies, repair equipment, and maintain morale. During an invasion, find a supply cache and either destroy it to weaken attackers or defend it to support defenders.',
    'Logistics win wars. Cut off supplies and armies starve. Protect supplies and armies thrive.',
    'Have you affected invasion logistics?',
    'You have affected invasion logistics.',
    'Return to the Frontier Scout.',
    7000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10227);

-- A4.20: Invasion Mastery (10228)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardNextQuest` = 10240,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 7500,
    `RewardItemId1` = 102011, -- Invasion Tactics Manual
-- ==================================================
-- STRONGHOLD DEFENSE/OFFENSE (10240-10259)
-- ==================================================

-- A4.21: Stronghold Basics (10240)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10241,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 8000,
    `RequiredNpcOrGo1` = 102020, -- Stronghold Gate
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Examine a stronghold gate and defenses',
    `Title` = 'Stronghold Basics',
    `Objectives` = 'Visit a stronghold and examine its gate and defensive structures.',
    `Details` = 'Strongholds are the ultimate prizes of territorial control. These fortified positions can withstand sieges and project power over large areas. Examine a stronghold''s defenses to understand their construction.',
    `OfferRewardText` = 'Strongholds are engineering marvels. Gates, walls, towers, and traps work together to create impregnable fortresses.',
    `RequestItemsText` = 'Have you examined a stronghold?',
    `EndText` = 'You have learned about strongholds.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 8000,
    `Flags` = 0
WHERE `entry` = 10240;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10240, 0, 30, 25, 10241, 0, 8000, 102020, 1,
    'Examine a stronghold gate and defenses',
    'Stronghold Basics',
    'Visit a stronghold and examine its gate and defensive structures.',
    'Strongholds are the ultimate prizes of territorial control. These fortified positions can withstand sieges and project power over large areas. Examine a stronghold''s defenses to understand their construction.',
    'Strongholds are engineering marvels. Gates, walls, towers, and traps work together to create impregnable fortresses.',
    'Have you examined a stronghold?',
    'You have learned about strongholds.',
    'Return to the Frontier Scout.',
    8000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10240);

-- A4.22: Siege Weapons (10241)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10242,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 8500,
    `RequiredNpcOrGo1` = 102021, -- Siege Engine
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Study siege weapons and their use',
    `Title` = 'Siege Weapons',
    `Objectives` = 'Find and examine siege weapons used in stronghold assaults.',
    `Details` = 'Siege weapons turn the tide of stronghold warfare. Catapults, ballistae, battering rams, and siege towers each have specific roles. Study them to understand siegecraft.',
    `OfferRewardText` = 'Siege weapons are specialized tools. Catapults for distance bombardment, rams for gates, towers for walls.',
    `RequestItemsText` = 'Have you studied siege weapons?',
    `EndText` = 'You have learned about siege weapons.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 8500,
    `Flags` = 0
WHERE `entry` = 10241;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10241, 0, 30, 25, 10242, 0, 8500, 102021, 1,
    'Study siege weapons and their use',
    'Siege Weapons',
    'Find and examine siege weapons used in stronghold assaults.',
    'Siege weapons turn the tide of stronghold warfare. Catapults, ballistae, battering rams, and siege towers each have specific roles. Study them to understand siegecraft.',
    'Siege weapons are specialized tools. Catapults for distance bombardment, rams for gates, towers for walls.',
    'Have you studied siege weapons?',
    'You have learned about siege weapons.',
    'Return to the Frontier Scout.',
    8500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10241);

-- A4.23: Defensive Positions (10242)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10243,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 9000,
    `RequiredNpcOrGo1` = 102022, -- Defensive Tower
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Man defensive positions in a stronghold',
    `Title` = 'Defensive Positions',
    `Objectives` = 'Take up a defensive position in a stronghold tower or wall during a siege.',
    `Details` = 'Stronghold defense requires positioning troops effectively. Towers provide archery positions, walls offer melee defense, gates need special protection. Experience manning these positions.',
    `OfferRewardText` = 'Defensive positioning is crucial. High ground advantages, chokepoints, and fields of fire determine victory.',
    `RequestItemsText` = 'Have you manned defensive positions?',
    `EndText` = 'You have learned defensive positioning.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 9000,
    `Flags` = 0
WHERE `entry` = 10242;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10242, 0, 30, 25, 10243, 0, 9000, 102022, 1,
    'Man defensive positions in a stronghold',
    'Defensive Positions',
    'Take up a defensive position in a stronghold tower or wall during a siege.',
    'Stronghold defense requires positioning troops effectively. Towers provide archery positions, walls offer melee defense, gates need special protection. Experience manning these positions.',
    'Defensive positioning is crucial. High ground advantages, chokepoints, and fields of fire determine victory.',
    'Have you manned defensive positions?',
    'You have learned defensive positioning.',
    'Return to the Frontier Scout.',
    9000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10242);

-- A4.24: Breach Tactics (10243)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10244,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 9500,
    `RequiredNpcOrGo1` = 102023, -- Breached Wall
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Witness or participate in breaching stronghold defenses',
    `Title` = 'Breach Tactics',
    `Objectives` = 'Observe or participate in breaching stronghold walls or gates.',
    `Details` = 'Breaching is the art of breaking through defenses. Siege weapons create openings, sappers tunnel under walls, magic weakens fortifications. Learn how breaches are created and exploited.',
    `OfferRewardText` = 'Breaches decide sieges. Create them to win attacks, prevent them to win defenses.',
    `RequestItemsText` = 'Have you witnessed breach tactics?',
    `EndText` = 'You have learned breach tactics.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 9500,
    `Flags` = 0
WHERE `entry` = 10243;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10243, 0, 30, 25, 10244, 0, 9500, 102023, 1,
    'Witness or participate in breaching stronghold defenses',
    'Breach Tactics',
    'Observe or participate in breaching stronghold walls or gates.',
    'Breaching is the art of breaking through defenses. Siege weapons create openings, sappers tunnel under walls, magic weakens fortifications. Learn how breaches are created and exploited.',
    'Breaches decide sieges. Create them to win attacks, prevent them to win defenses.',
    'Have you witnessed breach tactics?',
    'You have learned breach tactics.',
    'Return to the Frontier Scout.',
    9500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10243);

-- A4.25: Garrison Management (10244)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10245,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 10000,
    `RequiredNpcOrGo1` = 102024, -- Garrison Commander
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Speak with a garrison commander about troop management',
    `Title` = 'Garrison Management',
    `Objectives` = 'Find a Garrison Commander and learn about managing troops in a stronghold.',
    `Details` = 'Strongholds require garrisons to function. Managing supplies, rotation schedules, training, and morale is crucial. Speak with a garrison commander to understand these responsibilities.',
    `OfferRewardText` = 'Garrison management sustains strongholds. Well-fed, well-trained troops hold longer than starving conscripts.',
    `RequestItemsText` = 'Have you spoken with a garrison commander?',
    `EndText` = 'You have learned garrison management.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 10000,
    `Flags` = 0
WHERE `entry` = 10244;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10244, 0, 30, 25, 10245, 0, 10000, 102024, 1,
    'Speak with a garrison commander about troop management',
    'Garrison Management',
    'Find a Garrison Commander and learn about managing troops in a stronghold.',
    'Strongholds require garrisons to function. Managing supplies, rotation schedules, training, and morale is crucial. Speak with a garrison commander to understand these responsibilities.',
    'Garrison management sustains strongholds. Well-fed, well-trained troops hold longer than starving conscripts.',
    'Have you spoken with a garrison commander?',
    'You have learned garrison management.',
    'Return to the Frontier Scout.',
    10000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10244);

-- A4.26: Stronghold Offense (10245)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10246,
-- ==================================================
-- REPEATABLE CONTENT (10250-10259)
-- ==================================================

-- A4.31: Daily Territory Patrol (10250) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500,
    `RequiredNpcOrGo1` = 102030, -- Patrol Route Marker
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Complete a territory patrol route',
    `Title` = 'Daily Territory Patrol',
    `Objectives` = 'Patrol a territory and check 3 Patrol Route Markers for signs of enemy activity.',
    `Details` = 'Territories need constant vigilance. Patrol the borders and check for invasion signs, resource thieves, or control point tampering. Report any findings.',
    `OfferRewardText` = 'Good patrol work helps maintain control. Stay vigilant - the frontier never sleeps.',
    `RequestItemsText` = 'Have you completed your patrol?',
    `EndText` = 'Patrol completed.',
    `CompletedText` = 'Return to any Territory Guard.',
    `RewOrReqMoney` = 500,
    `Flags` = 4096, -- Repeatable flag
    `SpecialFlags` = 1 -- Daily quest
WHERE `entry` = 10250;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`, `SpecialFlags`)
SELECT 10250, 0, 25, 20, 0, 500, 102030, 3, 'Complete a territory patrol route',
    'Daily Territory Patrol',
    'Patrol a territory and check 3 Patrol Route Markers for signs of enemy activity.',
    'Territories need constant vigilance. Patrol the borders and check for invasion signs, resource thieves, or control point tampering. Report any findings.',
    'Good patrol work helps maintain control. Stay vigilant - the frontier never sleeps.',
    'Have you completed your patrol?',
    'Patrol completed.',
    'Return to any Territory Guard.',
    500, 4096, 1
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10250);

-- A4.32: Resource Defense (10251) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 750,
    `RequiredNpcOrGo1` = 102031, -- Resource Thief
    `RequiredNpcOrGoCount1` = 5,
    `ObjectiveText1` = 'Defend resource nodes from thieves',
    `Title` = 'Resource Defense',
    `Objectives` = 'Kill 5 Resource Thieves attempting to steal from controlled territory resource nodes.',
    `Details` = 'Resource thieves constantly try to steal from controlled territories. They reduce the income guilds earn from their lands. Help protect these vital assets.',
    `OfferRewardText` = 'Resource protection ensures steady income for territory controllers. Every thief stopped helps the economy.',
    `RequestItemsText` = 'Have you defended the resources?',
    `EndText` = 'Resources defended.',
    `CompletedText` = 'Return to any Resource Warden.',
    `RewOrReqMoney` = 750,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10251;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10251, 0, 25, 20, 0, 750, 102031, 5, 'Defend resource nodes from thieves',
    'Resource Defense',
    'Kill 5 Resource Thieves attempting to steal from controlled territory resource nodes.',
    'Resource thieves constantly try to steal from controlled territories. They reduce the income guilds earn from their lands. Help protect these vital assets.',
    'Resource protection ensures steady income for territory controllers. Every thief stopped helps the economy.',
    'Have you defended the resources?',
    'Resources defended.',
    'Return to any Resource Warden.',
    750, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10251);

-- A4.33: Invasion Scout (10252) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1000,
    `RequiredNpcOrGo1` = 102032, -- Invasion Scout
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Kill invasion scouts probing defenses',
    `Title` = 'Invasion Scout',
    `Objectives` = 'Kill 3 Invasion Scouts that are probing territory defenses and gathering intelligence.',
    `Details` = 'Invasion scouts gather information about defenses, troop numbers, and weaknesses. Eliminating them delays attacks and preserves the element of surprise for defenders.',
    `OfferRewardText` = 'Scouts removed means invaders fight blind. Good work protecting territorial secrets.',
    `RequestItemsText` = 'Have you eliminated the scouts?',
    `EndText` = 'Scouts eliminated.',
    `CompletedText` = 'Return to any Intelligence Officer.',
    `RewOrReqMoney` = 1000,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10252;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10252, 0, 25, 20, 0, 1000, 102032, 3, 'Kill invasion scouts probing defenses',
    'Invasion Scout',
    'Kill 3 Invasion Scouts that are probing territory defenses and gathering intelligence.',
    'Invasion scouts gather information about defenses, troop numbers, and weaknesses. Eliminating them delays attacks and preserves the element of surprise for defenders.',
    'Scouts removed means invaders fight blind. Good work protecting territorial secrets.',
    'Have you eliminated the scouts?',
    'Scouts eliminated.',
    'Return to any Intelligence Officer.',
    1000, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10252);

-- A4.34: Control Point Reinforcement (10253) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1250,
    `RequiredNpcOrGo1` = 102033, -- Control Point
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Reinforce a control point under attack',
    `Title` = 'Control Point Reinforcement',
    `Objectives` = 'Respond to a control point under attack and help reinforce its defenses.',
    `Details` = 'Control points are constantly under threat. When one comes under attack, defenders need immediate reinforcement. Respond quickly to maintain control.',
    `OfferRewardText` = 'Quick reinforcement saved the control point. Territory control maintained.',
    `RequestItemsText` = 'Have you reinforced the control point?',
    `EndText` = 'Control point reinforced.',
    `CompletedText` = 'Return to any Control Point Guardian.',
    `RewOrReqMoney` = 1250,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10253;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10253, 0, 25, 20, 0, 1250, 102033, 1, 'Reinforce a control point under attack',
    'Control Point Reinforcement',
    'Respond to a control point under attack and help reinforce its defenses.',
    'Control points are constantly under threat. When one comes under attack, defenders need immediate reinforcement. Respond quickly to maintain control.',
    'Quick reinforcement saved the control point. Territory control maintained.',
    'Have you reinforced the control point?',
    'Control point reinforced.',
    'Return to any Control Point Guardian.',
    1250, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10253);

-- A4.35: Siege Equipment Sabotage (10254) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1500,
    `RequiredNpcOrGo1` = 102034, -- Siege Equipment
    `RequiredNpcOrGoCount1` = 2,
    `ObjectiveText1` = 'Sabotage enemy siege equipment',
    `Title` = 'Siege Equipment Sabotage',
    `Objectives` = 'Find and sabotage 2 pieces of enemy siege equipment during a stronghold siege.',
    `Details` = 'During sieges, enemy siege equipment must be destroyed or disabled. Catapults, rams, and towers are prime targets. Sabotage them to weaken the assault.',
    `OfferRewardText` = 'Siege equipment sabotaged. The assault will be much harder now.',
    `RequestItemsText` = 'Have you sabotaged the siege equipment?',
    `EndText` = 'Equipment sabotaged.',
    `CompletedText` = 'Return to any Siege Engineer.',
    `RewOrReqMoney` = 1500,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10254;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10254, 0, 30, 25, 0, 1500, 102034, 2, 'Sabotage enemy siege equipment',
    'Siege Equipment Sabotage',
    'Find and sabotage 2 pieces of enemy siege equipment during a stronghold siege.',
    'During sieges, enemy siege equipment must be destroyed or disabled. Catapults, rams, and towers are prime targets. Sabotage them to weaken the assault.',
    'Siege equipment sabotaged. The assault will be much harder now.',
    'Have you sabotaged the siege equipment?',
    'Equipment sabotaged.',
    'Return to any Siege Engineer.',
    1500, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10254);

-- A4.36: Territory Survey (10255) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 600,
    `RequiredNpcOrGo1` = 102035, -- Survey Marker
    `RequiredNpcOrGoCount1` = 4,
    `ObjectiveText1` = 'Survey territory for strategic information',
    `Title` = 'Territory Survey',
    `Objectives` = 'Visit 4 Survey Markers in a territory to gather strategic information about defenses, resources, and potential invasion routes.',
    `Details` = 'Strategic surveys provide crucial information for territory management. Check survey markers to assess defensive positions, resource availability, and potential threats.',
    `OfferRewardText` = 'Survey complete. This information will help maintain territorial security.',
    `RequestItemsText` = 'Have you completed the territory survey?',
    `EndText` = 'Survey completed.',
    `CompletedText` = 'Return to any Survey Coordinator.',
    `RewOrReqMoney` = 600,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10255;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10255, 0, 25, 20, 0, 600, 102035, 4, 'Survey territory for strategic information',
    'Territory Survey',
    'Visit 4 Survey Markers in a territory to gather strategic information about defenses, resources, and potential invasion routes.',
    'Strategic surveys provide crucial information for territory management. Check survey markers to assess defensive positions, resource availability, and potential threats.',
    'Survey complete. This information will help maintain territorial security.',
    'Have you completed the territory survey?',
    'Survey completed.',
    'Return to any Survey Coordinator.',
    600, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10255);

-- A4.37: Supply Line Protection (10256) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 800,
    `RequiredNpcOrGo1` = 102036, -- Supply Caravan Guard
    `RequiredNpcOrGoCount1` = 6,
    `ObjectiveText1` = 'Protect supply caravans from bandits',
    `Title` = 'Supply Line Protection',
    `Objectives` = 'Escort or defend 6 Supply Caravan Guards as they transport goods through dangerous territory.',
    `Details` = 'Supply lines are the lifeblood of territories. Bandits and invaders constantly threaten caravans. Help protect these vital shipments.',
    `OfferRewardText` = 'Caravans protected. Territory supply lines remain secure.',
    `RequestItemsText` = 'Have you protected the supply caravans?',
    `EndText` = 'Caravans protected.',
    `CompletedText` = 'Return to any Caravan Master.',
    `RewOrReqMoney` = 800,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10256;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10256, 0, 25, 20, 0, 800, 102036, 6, 'Protect supply caravans from bandits',
    'Supply Line Protection',
    'Escort or defend 6 Supply Caravan Guards as they transport goods through dangerous territory.',
    'Supply lines are the lifeblood of territories. Bandits and invaders constantly threaten caravans. Help protect these vital shipments.',
    'Caravans protected. Territory supply lines remain secure.',
    'Have you protected the supply caravans?',
    'Caravans protected.',
    'Return to any Caravan Master.',
    800, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10256);

-- A4.38: Garrison Training (10257) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1200,
    `RequiredNpcOrGo1` = 102037, -- Training Dummy
    `RequiredNpcOrGoCount1` = 10,
    `ObjectiveText1` = 'Train garrison troops in combat techniques',
    `Title` = 'Garrison Training',
    `Objectives` = 'Use Training Dummies to demonstrate combat techniques to 10 garrison troops.',
    `Details` = 'Well-trained garrisons hold strongholds longer. Demonstrate proper combat techniques using training dummies to improve garrison effectiveness.',
    `OfferRewardText` = 'Training complete. Garrison troops are now better prepared for defense.',
    `RequestItemsText` = 'Have you trained the garrison troops?',
    `EndText` = 'Garrison trained.',
    `CompletedText` = 'Return to any Drill Sergeant.',
    `RewOrReqMoney` = 1200,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10257;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10257, 0, 30, 25, 0, 1200, 102037, 10, 'Train garrison troops in combat techniques',
    'Garrison Training',
    'Use Training Dummies to demonstrate combat techniques to 10 garrison troops.',
    'Well-trained garrisons hold strongholds longer. Demonstrate proper combat techniques using training dummies to improve garrison effectiveness.',
    'Training complete. Garrison troops are now better prepared for defense.',
    'Have you trained the garrison troops?',
    'Garrison trained.',
    'Return to any Drill Sergeant.',
    1200, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10257);

-- A4.39: Frontier Scout (10258) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 25,
    `MinLevel` = 20,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 900,
    `RequiredNpcOrGo1` = 102038, -- Frontier Outpost
    `RequiredNpcOrGoCount1` = 5,
    `ObjectiveText1` = 'Scout frontier outposts for activity',
    `Title` = 'Frontier Scout',
    `Objectives` = 'Visit 5 Frontier Outposts and report on any unusual activity or potential threats.',
    `Details` = 'The frontier is vast and ever-changing. Regular scouting of outposts helps detect threats early and maintain awareness of territorial developments.',
    `OfferRewardText` = 'Scouting complete. Your vigilance helps keep the frontier secure.',
    `RequestItemsText` = 'Have you scouted the frontier outposts?',
    `EndText` = 'Outposts scouted.',
    `CompletedText` = 'Return to any Frontier Ranger.',
    `RewOrReqMoney` = 900,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10258;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardXPDifficulty`,
    `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10258, 0, 25, 20, 0, 900, 102038, 5, 'Scout frontier outposts for activity',
    'Frontier Scout',
    'Visit 5 Frontier Outposts and report on any unusual activity or potential threats.',
    'The frontier is vast and ever-changing. Regular scouting of outposts helps detect threats early and maintain awareness of territorial developments.',
    'Scouting complete. Your vigilance helps keep the frontier secure.',
    'Have you scouted the frontier outposts?',
    'Outposts scouted.',
    'Return to any Frontier Ranger.',
    900, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10258);

-- A4.40: Breach Repair (10259) - Repeatable
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1800,
    `RequiredNpcOrGo1` = 102039, -- Damaged Wall Section
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Repair breached stronghold walls',
    `Title` = 'Breach Repair',
    `Objectives` = 'Find and repair 3 Damaged Wall Sections in a stronghold that has been breached during a siege.',
    `Details` = 'Sieges create breaches that must be repaired quickly. Help restore stronghold defenses by repairing damaged wall sections before invaders can exploit them.',
    `OfferRewardText` = 'Walls repaired. Stronghold defenses restored.',
    `RequestItemsText` = 'Have you repaired the breached walls?',
    `EndText` = 'Walls repaired.',
    `CompletedText` = 'Return to any Master Mason.',
    `RewOrReqMoney` = 1800,
    `Flags` = 4096 -- Repeatable flag
WHERE `entry` = 10259;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10259, 0, 30, 25, 0, 1800, 102039, 3, 'Repair breached stronghold walls',
    'Breach Repair',
    'Find and repair 3 Damaged Wall Sections in a stronghold that has been breached during a siege.',
    'Sieges create breaches that must be repaired quickly. Help restore stronghold defenses by repairing damaged wall sections before invaders can exploit them.',
    'Walls repaired. Stronghold defenses restored.',
    'Have you repaired the breached walls?',
    'Walls repaired.',
    'Return to any Master Mason.',
    1800, 4096
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10259);

-- Update quest chain registration for stronghold and repeatable quests
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10240, 'STORY_REWRITE', NULL, 'Act IV Quest - Stronghold Basics'),
(10241, 'STORY_REWRITE', NULL, 'Act IV Quest - Siege Weapons'),
(10242, 'STORY_REWRITE', NULL, 'Act IV Quest - Defensive Positions'),
(10243, 'STORY_REWRITE', NULL, 'Act IV Quest - Breach Tactics'),
(10244, 'STORY_REWRITE', NULL, 'Act IV Quest - Garrison Management'),
(10245, 'STORY_REWRITE', NULL, 'Act IV Quest - Stronghold Offense'),
(10246, 'STORY_REWRITE', NULL, 'Act IV Quest - Stronghold Defense'),
(10247, 'STORY_REWRITE', NULL, 'Act IV Quest - Siege Engineering'),
(10248, 'STORY_REWRITE', NULL, 'Act IV Quest - Stronghold Economy'),
(10249, 'STORY_REWRITE', NULL, 'Act IV Quest - Stronghold Mastery'),
(10250, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Daily Territory Patrol'),
(10251, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Resource Defense'),
(10252, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Invasion Scout'),
(10253, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Control Point Reinforcement'),
(10254, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Siege Equipment Sabotage'),
(10255, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Territory Survey'),
(10256, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Supply Line Protection'),
(10257, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Garrison Training'),
(10258, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Frontier Scout'),
(10259, 'REPEATABLE_ACTIVITY', NULL, 'Act IV Repeatable - Breach Repair')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `notes` = VALUES(`notes`);
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 10500,
    `RequiredNpcOrGo1` = 102025, -- Assault Commander
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Join a stronghold assault force',
    `Title` = 'Stronghold Offense',
    `Objectives` = 'Find an Assault Commander and participate in attacking a stronghold.',
    `Details` = 'Attacking strongholds requires careful planning and overwhelming force. Join an assault force to experience offense from the attacker''s perspective.',
    `OfferRewardText` = 'Stronghold assaults are brutal but decisive. Coordination, timing, and overwhelming numbers overcome fortifications.',
    `RequestItemsText` = 'Have you participated in a stronghold assault?',
    `EndText` = 'You have participated in stronghold offense.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 10500,
    `Flags` = 0
WHERE `entry` = 10245;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10245, 0, 30, 25, 10246, 0, 10500, 102025, 1,
    'Join a stronghold assault force',
    'Stronghold Offense',
    'Find an Assault Commander and participate in attacking a stronghold.',
    'Attacking strongholds requires careful planning and overwhelming force. Join an assault force to experience offense from the attacker''s perspective.',
    'Stronghold assaults are brutal but decisive. Coordination, timing, and overwhelming numbers overcome fortifications.',
    'Have you participated in a stronghold assault?',
    'You have participated in stronghold offense.',
    'Return to the Frontier Scout.',
    10500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10245);

-- A4.27: Stronghold Defense (10246)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10247,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 11000,
    `RequiredNpcOrGo1` = 102026, -- Defense Commander
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Help defend a stronghold under siege',
    `Title` = 'Stronghold Defense',
    `Objectives` = 'Find a Defense Commander and help defend a stronghold during an active siege.',
    `Details` = 'Defending a stronghold tests endurance and ingenuity. During an active siege, find a defense commander and contribute to holding the fortress.',
    `OfferRewardText` = 'Stronghold defense rewards patience and preparation. Hold the walls, repair breaches, and wait for relief.',
    `RequestItemsText` = 'Have you helped defend a stronghold?',
    `EndText` = 'You have defended a stronghold.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 11000,
    `Flags` = 0
WHERE `entry` = 10246;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10246, 0, 30, 25, 10247, 0, 11000, 102026, 1,
    'Help defend a stronghold under siege',
    'Stronghold Defense',
    'Find a Defense Commander and help defend a stronghold during an active siege.',
    'Defending a stronghold tests endurance and ingenuity. During an active siege, find a defense commander and contribute to holding the fortress.',
    'Stronghold defense rewards patience and preparation. Hold the walls, repair breaches, and wait for relief.',
    'Have you helped defend a stronghold?',
    'You have defended a stronghold.',
    'Return to the Frontier Scout.',
    11000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10246);

-- A4.28: Siege Engineering (10247)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10248,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 11500,
    `RequiredNpcOrGo1` = 102027, -- Siege Engineer
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Learn siege engineering from a specialist',
    `Title` = 'Siege Engineering',
    `Objectives` = 'Find a Siege Engineer and learn about constructing and countering siege works.',
    `Details` = 'Siege engineering combines construction and destruction. Engineers build siege weapons, fortifications, tunnels, and countermeasures. Learn from a specialist.',
    `OfferRewardText` = 'Siege engineering turns the tide. Build better than your enemy, destroy what they build.',
    `RequestItemsText` = 'Have you learned siege engineering?',
    `EndText` = 'You have learned siege engineering.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 11500,
    `Flags` = 0
WHERE `entry` = 10247;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10247, 0, 30, 25, 10248, 0, 11500, 102027, 1,
    'Learn siege engineering from a specialist',
    'Siege Engineering',
    'Find a Siege Engineer and learn about constructing and countering siege works.',
    'Siege engineering combines construction and destruction. Engineers build siege weapons, fortifications, tunnels, and countermeasures. Learn from a specialist.',
    'Siege engineering turns the tide. Build better than your enemy, destroy what they build.',
    'Have you learned siege engineering?',
    'You have learned siege engineering.',
    'Return to the Frontier Scout.',
    11500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10247);

-- A4.29: Stronghold Economy (10248)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10249,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 12000,
    `RequiredNpcOrGo1` = 102028, -- Quartermaster
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Manage stronghold supplies and resources',
    `Title` = 'Stronghold Economy',
    `Objectives` = 'Speak with a Quartermaster about managing resources during a siege.',
    `Details` = 'Strongholds require vast resources to function. Food, ammunition, repair materials, and gold all flow through the quartermaster. Learn how sieges affect the economy.',
    `OfferRewardText` = 'Stronghold economy is siege economy. Stockpiles determine endurance, supply lines determine victory.',
    `RequestItemsText` = 'Have you managed stronghold resources?',
    `EndText` = 'You have learned stronghold economy.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 12000,
    `Flags` = 0
WHERE `entry` = 10248;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`,
    `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10248, 0, 30, 25, 10249, 0, 12000, 102028, 1,
    'Manage stronghold supplies and resources',
    'Stronghold Economy',
    'Speak with a Quartermaster about managing resources during a siege.',
    'Strongholds require vast resources to function. Food, ammunition, repair materials, and gold all flow through the quartermaster. Learn how sieges affect the economy.',
    'Stronghold economy is siege economy. Stockpiles determine endurance, supply lines determine victory.',
    'Have you managed stronghold resources?',
    'You have learned stronghold economy.',
    'Return to the Frontier Scout.',
    12000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10248);

-- A4.30: Stronghold Mastery (10249)
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 30,
    `MinLevel` = 25,
    `RewardNextQuest` = 10250,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 12500,
    `RewardItemId1` = 102012, -- Stronghold Warfare Manual
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 102029, -- Stronghold Mastery Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete the stronghold warfare knowledge test',
    `Title` = 'Stronghold Mastery',
    `Objectives` = 'Take the Stronghold Warfare Knowledge Test to demonstrate your understanding of siegecraft.',
    `Details` = 'You''ve learned about strongholds from gates to garrisons. Now prove your mastery by taking the test. Answer questions about defense, offense, engineering, and economy.',
    `OfferRewardText` = 'You have mastered stronghold warfare! Take this manual as your guide to commanding fortresses.',
    `RequestItemsText` = 'Have you completed the stronghold mastery test?',
    `EndText` = 'You have mastered stronghold warfare.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 12500,
    `Flags` = 0
WHERE `entry` = 10249;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10249, 0, 30, 25, 10250, 0, 12500, 102012, 1, 102029, 1,
    'Complete the stronghold warfare knowledge test',
    'Stronghold Mastery',
    'Take the Stronghold Warfare Knowledge Test to demonstrate your understanding of siegecraft.',
    'You''ve learned about strongholds from gates to garrisons. Now prove your mastery by taking the test. Answer questions about defense, offense, engineering, and economy.',
    'You have mastered stronghold warfare! Take this manual as your guide to commanding fortresses.',
    'Have you completed the stronghold mastery test?',
    'You have mastered stronghold warfare.',
    'Return to the Frontier Scout.',
    12500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10249);
    `RewardItemCount1` = 1,
    `RequiredNpcOrGo1` = 102019, -- Invasion Mastery Test
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Complete the invasion systems knowledge test',
    `Title` = 'Invasion Mastery',
    `Objectives` = 'Take the Invasion Systems Knowledge Test to demonstrate your understanding of invasion mechanics.',
    `Details` = 'You''ve learned about invasions from warning to logistics. Now prove your mastery by taking the test. Answer questions about invasion phases, tactics, intelligence, and logistics.',
    `OfferRewardText` = 'You have mastered invasion systems! Take this manual as a guide for offensive and defensive campaigns.',
    `RequestItemsText` = 'Have you completed the invasion mastery test?',
    `EndText` = 'You have mastered invasion systems.',
    `CompletedText` = 'Return to the Frontier Scout.',
    `RewOrReqMoney` = 7500,
    `Flags` = 0
WHERE `entry` = 10228;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`,
    `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10228, 0, 25, 20, 10240, 0, 7500, 102011, 1, 102019, 1,
    'Complete the invasion systems knowledge test',
    'Invasion Mastery',
    'Take the Invasion Systems Knowledge Test to demonstrate your understanding of invasion mechanics.',
    'You''ve learned about invasions from warning to logistics. Now prove your mastery by taking the test. Answer questions about invasion phases, tactics, intelligence, and logistics.',
    'You have mastered invasion systems! Take this manual as a guide for offensive and defensive campaigns.',
    'Have you completed the invasion mastery test?',
    'You have mastered invasion systems.',
    'Return to the Frontier Scout.',
    7500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10228);

-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10200, 'STORY_REWRITE', NULL, 'Act IV Quest - The Frontier Calls'),
(10201, 'STORY_REWRITE', NULL, 'Act IV Quest - Zone States Explained'),
(10202, 'STORY_REWRITE', NULL, 'Act IV Quest - Control Points'),
(10203, 'STORY_REWRITE', NULL, 'Act IV Quest - Resource Siphoning'),
(10204, 'STORY_REWRITE', NULL, 'Act IV Quest - Territory Services'),
(10205, 'STORY_REWRITE', NULL, 'Act IV Quest - Vulnerability Windows'),
(10206, 'STORY_REWRITE', NULL, 'Act IV Quest - First Capture'),
(10207, 'STORY_REWRITE', NULL, 'Act IV Quest - Defense Basics'),
(10208, 'STORY_REWRITE', NULL, 'Act IV Quest - Territory Ownership'),
(10209, 'STORY_REWRITE', NULL, 'Act IV Quest - Guild Coordination'),
(10210, 'STORY_REWRITE', NULL, 'Act IV Quest - Territory Control Mastery'),
(10220, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Warning'),
(10221, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Forces'),
(10222, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Phases'),
(10223, 'STORY_REWRITE', NULL, 'Act IV Quest - Counter-Invasion Tactics'),
(10224, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Participation'),
(10225, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Defense'),
(10226, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Intelligence'),
(10227, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Logistics'),
(10228, 'STORY_REWRITE', NULL, 'Act IV Quest - Invasion Mastery')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `notes` = VALUES(`notes`);