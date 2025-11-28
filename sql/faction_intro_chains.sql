
-- ==================================================
-- Project Mortal Warcraft
-- Feature: Faction Intro Chains
-- Description: Quest templates for Iron Ledger economic trials (10100-10124)
--              and Order of the Shrine Ether trials (10125-10149)
-- Based on: spec 69
-- ==================================================

-- ==================================================
-- IRON LEDGER ECONOMIC TRIALS (10100-10124)
-- ==================================================

-- Q10100: Introduction to the Iron Ledger
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10101,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `RequiredNpcOrGo1` = 101000, -- Iron Ledger Representative
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Iron Ledger Representative',
    `Title` = 'Introduction to the Iron Ledger',
    `Objectives` = 'Seek out the Iron Ledger Representative in Port Meridian and learn about their economic trials.',
    `Details` = 'The Iron Ledger controls the flow of wealth in this fractured world. Their economic trials test your ability to navigate markets, manage resources, and build prosperity. Speak with their representative to begin your trials.',
    `OfferRewardText` = 'Welcome, prospective member. The Iron Ledger values those who understand the true power of commerce. Your trials begin now.',
    `RequestItemsText` = 'Are you ready to prove your economic acumen?',
    `EndText` = 'You have met the Iron Ledger Representative.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 100,
    `Flags` = 0,
    `SpecialFlags` = 0
WHERE `entry` = 10100;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10100, 0, 1, 1, 10101, 0, 100, 101000, 'Speak with the Iron Ledger Representative',
    'Introduction to the Iron Ledger',
    'Seek out the Iron Ledger Representative in Port Meridian and learn about their economic trials.',
    'The Iron Ledger controls the flow of wealth in this fractured world. Their economic trials test your ability to navigate markets, manage resources, and build prosperity. Speak with their representative to begin your trials.',
    'Welcome, prospective member. The Iron Ledger values those who understand the true power of commerce. Your trials begin now.',
    'Are you ready to prove your economic acumen?',
    'You have met the Iron Ledger Representative.',
    'Return to the Iron Ledger Representative.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10100);

-- Q10101: Economic Fundamentals
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10102,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 150,
    `RequiredItemId1` = 101001, -- Copper Ledger
    `RequiredItemCount1` = 5,
    `RequiredItemId2` = 101002, -- Trade Manifest
    `RequiredItemCount2` = 1,
    `ObjectiveText1` = 'Collect 5 Copper Ledgers and 1 Trade Manifest',
    `Title` = 'Economic Fundamentals',
    `Objectives` = 'Gather copper ledgers from market vendors and obtain a trade manifest from the Task Board.',
    `Details` = '"To join the Iron Ledger, you must first understand the basics of economic tracking. Copper ledgers record transactions, and trade manifests show market flows. Gather these items to prove your understanding of economic fundamentals."',
    `OfferRewardText` = 'Well gathered. These documents show you understand how wealth moves through our world.',
    `RequestItemsText` = 'Have you collected the economic documents?',
    `EndText` = 'You have learned economic fundamentals.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 150,
    `Flags` = 0
WHERE `entry` = 10101;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `RequiredItemId2`,
    `RequiredItemCount2`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10101, 2, 1, 1, 10102, 0, 150, 101001, 5, 101002, 1, 'Collect 5 Copper Ledgers and 1 Trade Manifest',
    'Economic Fundamentals',
    'Gather copper ledgers from market vendors and obtain a trade manifest from the Task Board.',
    '"To join the Iron Ledger, you must first understand the basics of economic tracking. Copper ledgers record transactions, and trade manifests show market flows. Gather these items to prove your understanding of economic fundamentals."',
    'Well gathered. These documents show you understand how wealth moves through our world.',
    'Have you collected the economic documents?',
    'You have learned economic fundamentals.',
    'Return to the Iron Ledger Representative.',
    150, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10101);

-- Q10102: Supply Chain Basics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10103,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200,
    `RequiredNpcOrGo1` = 101003, -- Supply Chain Node
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Inspect 3 Supply Chain Nodes',
    `Title` = 'Supply Chain Basics',
    `Objectives` = 'Visit and inspect supply chain nodes around Port Meridian to understand resource flow.',
    `Details` = '"The Iron Ledger maintains supply chains that keep goods moving. Visit these nodes and observe how resources flow from producers to consumers. Understanding supply chains is crucial for economic mastery."',
    `OfferRewardText` = 'You see how goods move through our economy. Supply chains are the arteries of wealth.',
    `RequestItemsText` = 'Have you inspected the supply chain nodes?',
    `EndText` = 'You have learned supply chain basics.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 200,
    `Flags` = 0
WHERE `entry` = 10102;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10102, 0, 1, 1, 10103, 0, 200, 101003, 3, 'Inspect 3 Supply Chain Nodes',
    'Supply Chain Basics',
    'Visit and inspect supply chain nodes around Port Meridian to understand resource flow.',
    '"The Iron Ledger maintains supply chains that keep goods moving. Visit these nodes and observe how resources flow from producers to consumers. Understanding supply chains is crucial for economic mastery."',
    'You see how goods move through our economy. Supply chains are the arteries of wealth.',
    'Have you inspected the supply chain nodes?',
    'You have learned supply chain basics.',
    'Return to the Iron Ledger Representative.',
    200, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10102);

-- Q10103: Market Manipulation Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10104,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 250,
    `ObjectiveText1` = 'Successfully manipulate market prices for profit',
    `Title` = 'Market Manipulation Trial',
    `Objectives` = 'Buy low and sell high to manipulate market prices and earn 100 gold profit.',
    `Details` = '"True economic power comes from understanding market forces. Buy items when prices are low, create artificial scarcity, then sell high. Show us you can bend the market to your will and earn 100 gold profit."',
    `OfferRewardText` = 'Impressive manipulation. You understand how markets can be controlled.',
    `RequestItemsText` = 'Have you mastered market manipulation?',
    `EndText` = 'You have passed the market manipulation trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 250,
    `Flags` = 0
WHERE `entry` = 10103;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10103, 0, 1, 1, 10104, 0, 250, 'Successfully manipulate market prices for profit',
    'Market Manipulation Trial',
    'Buy low and sell high to manipulate market prices and earn 100 gold profit.',
    '"True economic power comes from understanding market forces. Buy items when prices are low, create artificial scarcity, then sell high. Show us you can bend the market to your will and earn 100 gold profit."',
    'Impressive manipulation. You understand how markets can be controlled.',
    'Have you mastered market manipulation?',
    'You have passed the market manipulation trial.',
    'Return to the Iron Ledger Representative.',
    250, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10103);

-- Q10104: Banking Empire Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10105,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 300,
    `ObjectiveText1` = 'Establish a banking network across 5 regions',
    `Title` = 'Banking Empire Trial',
    `Objectives` = 'Use couriers to establish bank accounts in 5 different regions.',
    `Details` = '"The Iron Ledger built its empire on banking networks. Establish accounts in multiple regions using our courier network. This demonstrates your ability to manage wealth across vast distances."',
    `OfferRewardText` = 'Your banking empire grows. Regional networks are the foundation of true wealth.',
    `RequestItemsText` = 'Have you established your banking network?',
    `EndText` = 'You have passed the banking empire trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 300,
    `Flags` = 0
WHERE `entry` = 10104;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10104, 0, 1, 1, 10105, 0, 300, 'Establish a banking network across 5 regions',
    'Banking Empire Trial',
    'Use couriers to establish bank accounts in 5 different regions.',
    '"The Iron Ledger built its empire on banking networks. Establish accounts in multiple regions using our courier network. This demonstrates your ability to manage wealth across vast distances."',
    'Your banking empire grows. Regional networks are the foundation of true wealth.',
    'Have you established your banking network?',
    'You have passed the banking empire trial.',
    'Return to the Iron Ledger Representative.',
    300, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10104);

-- Q10105: Contract Monopoly Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10106,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 350,
    `ObjectiveText1` = 'Complete 10 high-value contracts exclusively',
    `Title` = 'Contract Monopoly Trial',
    `Objectives` = 'Complete 10 contracts worth at least 50 gold each, showing mastery of contract economics.',
    `Details` = '"Contracts are the Iron Ledger''s lifeblood. Complete 10 high-value contracts to prove you can monopolize economic opportunities. Each contract must be worth at least 50 gold to demonstrate your business acumen."',
    `OfferRewardText` = 'A monopoly well established. You control the flow of contracts in this region.',
    `RequestItemsText` = 'Have you completed the contract monopoly?',
    `EndText` = 'You have passed the contract monopoly trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 350,
    `Flags` = 0
WHERE `entry` = 10105;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10105, 0, 1, 1, 10106, 0, 350, 'Complete 10 high-value contracts exclusively',
    'Contract Monopoly Trial',
    'Complete 10 contracts worth at least 50 gold each, showing mastery of contract economics.',
    '"Contracts are the Iron Ledger''s lifeblood. Complete 10 high-value contracts to prove you can monopolize economic opportunities. Each contract must be worth at least 50 gold to demonstrate your business acumen."',
    'A monopoly well established. You control the flow of contracts in this region.',
    'Have you completed the contract monopoly?',
    'You have passed the contract monopoly trial.',
    'Return to the Iron Ledger Representative.',
    350, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10105);

-- Q10106: Resource Cartel Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10107,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 400,
    `ObjectiveText1` = 'Control 80% of a resource market',
    `Title` = 'Resource Cartel Trial',
    `Objectives` = 'Corner the market on a specific resource by controlling 80% of its supply.',
    `Details` = '"True economic power comes from controlling resources. Choose a resource and corner its market - buy up all available supplies, control the means of production, eliminate competition. Show us you can create a cartel."',
    `OfferRewardText` = 'The cartel is formed. You now control this resource''s destiny.',
    `RequestItemsText` = 'Have you established your resource cartel?',
    `EndText` = 'You have passed the resource cartel trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 400,
    `Flags` = 0
WHERE `entry` = 10106;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10106, 0, 1, 1, 10107, 0, 400, 'Control 80% of a resource market',
    'Resource Cartel Trial',
    'Corner the market on a specific resource by controlling 80% of its supply.',
    '"True economic power comes from controlling resources. Choose a resource and corner its market - buy up all available supplies, control the means of production, eliminate competition. Show us you can create a cartel."',
    'The cartel is formed. You now control this resource''s destiny.',
    'Have you established your resource cartel?',
    'You have passed the resource cartel trial.',
    'Return to the Iron Ledger Representative.',
    400, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10106);

-- Q10107: Economic Warfare Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10108,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 450,
    `ObjectiveText1` = 'Bankrupt a competing merchant guild',
    `Title` = 'Economic Warfare Trial',
    `Objectives` = 'Use economic tactics to drive a competing merchant guild into bankruptcy.',
    `Details` = '"War is not always fought with swords. Use pricing wars, supply disruption, and market manipulation to bankrupt a rival guild. Show us you can wage economic warfare as effectively as any general commands troops."',
    `OfferRewardText` = 'The rival is broken. Economic warfare is the most devastating kind.',
    `RequestItemsText` = 'Have you won the economic war?',
    `EndText` = 'You have passed the economic warfare trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 450,
    `Flags` = 0
WHERE `entry` = 10107;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10107, 0, 1, 1, 10108, 0, 450, 'Bankrupt a competing merchant guild',
    'Economic Warfare Trial',
    'Use economic tactics to drive a competing merchant guild into bankruptcy.',
    '"War is not always fought with swords. Use pricing wars, supply disruption, and market manipulation to bankrupt a rival guild. Show us you can wage economic warfare as effectively as any general commands troops."',
    'The rival is broken. Economic warfare is the most devastating kind.',
    'Have you won the economic war?',
    'You have passed the economic warfare trial.',
    'Return to the Iron Ledger Representative.',
    450, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10107);

-- Q10108: Wealth Preservation Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10109,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500,
    `ObjectiveText1` = 'Preserve 10,000 gold worth of assets during a market crash',
    `Title` = 'Wealth Preservation Trial',
    `Objectives` = 'During an artificial market crash, preserve at least 10,000 gold in assets.',
    `Details` = '"Markets crash, economies collapse, but the wise preserve their wealth. We will trigger a market crash. Use diversification, safe assets, and quick trading to preserve at least 10,000 gold in value. Show us you can weather any storm."',
    `OfferRewardText` = 'Your wealth endures. True economic masters preserve what others lose.',
    `RequestItemsText` = 'Have you preserved your wealth through the crash?',
    `EndText` = 'You have passed the wealth preservation trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 500,
    `Flags` = 0
WHERE `entry` = 10108;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10108, 0, 1, 1, 10109, 0, 500, 'Preserve 10,000 gold worth of assets during a market crash',
    'Wealth Preservation Trial',
    'During an artificial market crash, preserve at least 10,000 gold in assets.',
    '"Markets crash, economies collapse, but the wise preserve their wealth. We will trigger a market crash. Use diversification, safe assets, and quick trading to preserve at least 10,000 gold in value. Show us you can weather any storm."',
    'Your wealth endures. True economic masters preserve what others lose.',
    'Have you preserved your wealth through the crash?',
    'You have passed the wealth preservation trial.',
    'Return to the Iron Ledger Representative.',
    500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10108);

-- Q10109: Investment Empire Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10110,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 550,
    `ObjectiveText1` = 'Build an investment portfolio worth 50,000 gold',
    `Title` = 'Investment Empire Trial',
    `Objectives` = 'Invest in various economic ventures to build a portfolio worth 50,000 gold.',
    `Details` = '"The Iron Ledger invests in everything profitable. Build a diverse investment portfolio - mines, caravans, contracts, properties. Reach 50,000 gold in total value to prove your investment acumen."',
    `OfferRewardText` = 'Your investment empire flourishes. You understand how wealth multiplies.',
    `RequestItemsText` = 'Have you built your investment empire?',
    `EndText` = 'You have passed the investment empire trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 550,
    `Flags` = 0
WHERE `entry` = 10109;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10109, 0, 1, 1, 10110, 0, 550, 'Build an investment portfolio worth 50,000 gold',
    'Investment Empire Trial',
    'Invest in various economic ventures to build a portfolio worth 50,000 gold.',
    '"The Iron Ledger invests in everything profitable. Build a diverse investment portfolio - mines, caravans, contracts, properties. Reach 50,000 gold in total value to prove your investment acumen."',
    'Your investment empire flourishes. You understand how wealth multiplies.',
    'Have you built your investment empire?',
    'You have passed the investment empire trial.',
    'Return to the Iron Ledger Representative.',
    550, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10109);

-- Q10110: Economic Espionage Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10111,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 600,
    `ObjectiveText1` = 'Steal trade secrets from 3 competing factions',
    `Title` = 'Economic Espionage Trial',
    `Objectives` = 'Infiltrate and steal economic intelligence from three competing factions.',
    `Details` = '"Knowledge is the ultimate currency. Infiltrate three rival factions and steal their trade secrets, market strategies, and economic plans. Use this intelligence to strengthen the Iron Ledger''s position."',
    `OfferRewardText` = 'The secrets are ours. Information is more valuable than gold.',
    `RequestItemsText` = 'Have you completed your economic espionage?',
    `EndText` = 'You have passed the economic espionage trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 600,
    `Flags` = 0
WHERE `entry` = 10110;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10110, 0, 1, 1, 10111, 0, 600, 'Steal trade secrets from 3 competing factions',
    'Economic Espionage Trial',
    'Infiltrate and steal economic intelligence from three competing factions.',
    '"Knowledge is the ultimate currency. Infiltrate three rival factions and steal their trade secrets, market strategies, and economic plans. Use this intelligence to strengthen the Iron Ledger''s position."',
    'The secrets are ours. Information is more valuable than gold.',
    'Have you completed your economic espionage?',
    'You have passed the economic espionage trial.',
    'Return to the Iron Ledger Representative.',
    600, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10110);

-- Q10111: Merchant Fleet Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10112,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 650,
    `ObjectiveText1` = 'Establish and protect a merchant caravan fleet',
    `Title` = 'Merchant Fleet Trial',
    `Objectives` = 'Build and successfully escort 5 merchant caravans through dangerous territories.',
    `Details` = '"Trade routes must be protected. Establish a fleet of 5 merchant caravans and escort them safely through bandit-infested territories. Show us you can secure the arteries of commerce."',
    `OfferRewardText` = 'Your fleet sails safely. Trade routes are the lifeblood of economies.',
    `RequestItemsText` = 'Have you established your merchant fleet?',
    `EndText` = 'You have passed the merchant fleet trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 650,
    `Flags` = 0
WHERE `entry` = 10111;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10111, 0, 1, 1, 10112, 0, 650, 'Establish and protect a merchant caravan fleet',
    'Merchant Fleet Trial',
    'Build and successfully escort 5 merchant caravans through dangerous territories.',
    '"Trade routes must be protected. Establish a fleet of 5 merchant caravans and escort them safely through bandit-infested territories. Show us you can secure the arteries of commerce."',
    'Your fleet sails safely. Trade routes are the lifeblood of economies.',
    'Have you established your merchant fleet?',
    'You have passed the merchant fleet trial.',
    'Return to the Iron Ledger Representative.',
    650, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10111);

-- Q10112: Black Market Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10113,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 700,
    `ObjectiveText1` = 'Control the black market in Port Meridian',
    `Title` = 'Black Market Trial',
    `Objectives` = 'Establish control over the underground economy by eliminating rivals and setting prices.',
    `Details` = '"Not all commerce happens in the light. The black market is where fortunes are made and lost. Eliminate rival smugglers, establish your control, and set the prices for illicit goods. Show us you can rule the shadows."',
    `OfferRewardText` = 'The shadows are yours. The black market bows to your will.',
    `RequestItemsText` = 'Have you seized control of the black market?',
    `EndText` = 'You have passed the black market trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 700,
    `Flags` = 0
WHERE `entry` = 10112;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10112, 0, 1, 1, 10113, 0, 700, 'Control the black market in Port Meridian',
    'Black Market Trial',
    'Establish control over the underground economy by eliminating rivals and setting prices.',
    '"Not all commerce happens in the light. The black market is where fortunes are made and lost. Eliminate rival smugglers, establish your control, and set the prices for illicit goods. Show us you can rule the shadows."',
    'The shadows are yours. The black market bows to your will.',
    'Have you seized control of the black market?',
    'You have passed the black market trial.',
    'Return to the Iron Ledger Representative.',
    700, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10112);

-- Q10113: Tax Collection Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10114,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 750,
    `ObjectiveText1` = 'Collect taxes from 20 merchants and businesses',
    `Title` = 'Tax Collection Trial',
    `Objectives` = 'Act as the Iron Ledger''s tax collector and gather dues from 20 merchants.',
    `Details` = '"The Iron Ledger collects tariffs and taxes that keep the economy functioning. Visit 20 merchants and collect their dues. Those who resist must be... persuaded. Show us you can enforce economic order."',
    `OfferRewardText` = 'Taxes collected. The economy runs on such enforcement.',
    `RequestItemsText` = 'Have you collected all the taxes?',
    `EndText` = 'You have passed the tax collection trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 750,
    `Flags` = 0
WHERE `entry` = 10113;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10113, 0, 1, 1, 10114, 0, 750, 'Collect taxes from 20 merchants and businesses',
    'Tax Collection Trial',
    'Act as the Iron Ledger''s tax collector and gather dues from 20 merchants.',
    '"The Iron Ledger collects tariffs and taxes that keep the economy functioning. Visit 20 merchants and collect their dues. Those who resist must be... persuaded. Show us you can enforce economic order."',
    'Taxes collected. The economy runs on such enforcement.',
    'Have you collected all the taxes?',
    'You have passed the tax collection trial.',
    'Return to the Iron Ledger Representative.',
    750, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10113);

-- Q10114: Economic Alliance Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10115,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 800,
    `ObjectiveText1` = 'Forge economic alliances with 5 regional powers',
    `Title` = 'Economic Alliance Trial',
    `Objectives` = 'Negotiate trade agreements and alliances with five regional powers.',
    `Details` = '"No empire stands alone. Forge alliances with five regional powers through trade agreements, mutual defense pacts, and economic cooperation. Show us you can build a coalition that strengthens the Iron Ledger."',
    `OfferRewardText` = 'Alliances forged. United we stand, divided we fall economically.',
    `RequestItemsText` = 'Have you secured the economic alliances?',
    `EndText` = 'You have passed the economic alliance trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 800,
    `Flags` = 0
WHERE `entry` = 10114;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10114, 0, 1, 1, 10115, 0, 800, 'Forge economic alliances with 5 regional powers',
    'Economic Alliance Trial',
    'Negotiate trade agreements and alliances with five regional powers.',
    '"No empire stands alone. Forge alliances with five regional powers through trade agreements, mutual defense pacts, and economic cooperation. Show us you can build a coalition that strengthens the Iron Ledger."',
    'Alliances forged. United we stand, divided we fall economically.',
    'Have you secured the economic alliances?',
    'You have passed the economic alliance trial.',
    'Return to the Iron Ledger Representative.',
    800, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10114);

-- Q10115: Currency Manipulation Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10116,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 850,
    `ObjectiveText1` = 'Manipulate currency exchange rates for profit',
    `Title` = 'Currency Manipulation Trial',
    `Objectives` = 'Control currency exchange rates between regions to generate 25,000 gold profit.',
    `Details` = '"Currency is power. Manipulate exchange rates between regions - buy low in one area, sell high in another. Create artificial shortages, spread rumors, use your network. Generate 25,000 gold profit to prove your mastery."',
    `OfferRewardText` = 'Currency bends to your will. You control the very flow of money.',
    `RequestItemsText` = 'Have you mastered currency manipulation?',
    `EndText` = 'You have passed the currency manipulation trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 850,
    `Flags` = 0
WHERE `entry` = 10115;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10115, 0, 1, 1, 10116, 0, 850, 'Manipulate currency exchange rates for profit',
    'Currency Manipulation Trial',
    'Control currency exchange rates between regions to generate 25,000 gold profit.',
    '"Currency is power. Manipulate exchange rates between regions - buy low in one area, sell high in another. Create artificial shortages, spread rumors, use your network. Generate 25,000 gold profit to prove your mastery."',
    'Currency bends to your will. You control the very flow of money.',
    'Have you mastered currency manipulation?',
    'You have passed the currency manipulation trial.',
    'Return to the Iron Ledger Representative.',
    850, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10115);

-- Q10116: Debt Empire Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10117,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 900,
    `ObjectiveText1` = 'Create a debt network controlling 15 debtors',
    `Title` = 'Debt Empire Trial',
    `Objectives` = 'Lend money to 15 individuals/factions and establish a controlling interest in their operations.',
    `Details` = '"Debt is the sweetest chain. Lend money to 15 desperate individuals and factions. Ensure they cannot repay without becoming your puppets. Build an empire of debtors who serve your interests. Show us you can turn gold into power."',
    `OfferRewardText` = 'Your debtors serve you well. Debt is eternal servitude.',
    `RequestItemsText` = 'Have you built your debt empire?',
    `EndText` = 'You have passed the debt empire trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 900,
    `Flags` = 0
WHERE `entry` = 10116;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10116, 0, 1, 1, 10117, 0, 900, 'Create a debt network controlling 15 debtors',
    'Debt Empire Trial',
    'Lend money to 15 individuals/factions and establish a controlling interest in their operations.',
    '"Debt is the sweetest chain. Lend money to 15 desperate individuals and factions. Ensure they cannot repay without becoming your puppets. Build an empire of debtors who serve your interests. Show us you can turn gold into power."',
    'Your debtors serve you well. Debt is eternal servitude.',
    'Have you built your debt empire?',
    'You have passed the debt empire trial.',
    'Return to the Iron Ledger Representative.',
    900, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10116);

-- Q10117: Economic Prophecy Trial
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10118,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 950,
    `ObjectiveText1` = 'Predict and profit from 3 major economic events',
    `Title` = 'Economic Prophecy Trial',
    `Objectives` = 'Accurately predict three major economic events and position yourself to profit from them.',
    `Details` = '"The greatest economic minds can see the future. Study trends, analyze data, predict three major economic events. Position your assets to profit from each one. Show us you can see what others cannot."',
    `OfferRewardText` = 'Your predictions were flawless. You see the economic future.',
    `RequestItemsText` = 'Have you predicted and profited from the economic events?',
    `EndText` = 'You have passed the economic prophecy trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 950,
    `Flags` = 0
WHERE `entry` = 10117;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10117, 0, 1, 1, 10118, 0, 950, 'Predict and profit from 3 major economic events',
    'Economic Prophecy Trial',
    'Accurately predict three major economic events and position yourself to profit from them.',
    '"The greatest economic minds can see the future. Study trends, analyze data, predict three major economic events. Position your assets to profit from each one. Show us you can see what others cannot."',
    'Your predictions were flawless. You see the economic future.',
    'Have you predicted and profited from the economic events?',
    'You have passed the economic prophecy trial.',
    'Return to the Iron Ledger Representative.',
    950, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10117);

-- Q10118: Iron Ledger Ascension
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10119,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 1000,
    `RewardItemId1` = 101004, -- Iron Ledger Signet
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Complete the final economic trial and earn faction standing',
    `Title` = 'Iron Ledger Ascension',
    `Objectives` = 'Demonstrate ultimate economic mastery by completing a grand economic project.',
    `Details` = '"You stand at the threshold of true power. Complete one final grand project - restructure an entire region''s economy, create a new trade empire, or orchestrate the greatest market event in history. Show us you are worthy of the Iron Ledger."',
    `OfferRewardText` = 'You are now a member of the Iron Ledger. The economy is yours to command.',
    `RequestItemsText` = 'Are you ready for ascension?',
    `EndText` = 'You have ascended to the Iron Ledger.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 1000,
    `Flags` = 0
WHERE `entry` = 10118;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10118, 0, 1, 1, 10119, 0, 1000, 101004, 1, 'Complete the final economic trial and earn faction standing',
    'Iron Ledger Ascension',
    'Demonstrate ultimate economic mastery by completing a grand economic project.',
    '"You stand at the threshold of true power. Complete one final grand project - restructure an entire region''s economy, create a new trade empire, or orchestrate the greatest market event in history. Show us you are worthy of the Iron Ledger."',
    'You are now a
-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10100, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Introduction to the Iron Ledger'),
(10101, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Economic Fundamentals'),
(10102, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Supply Chain Basics'),
(10103, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Market Manipulation Trial'),
(10104, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Banking Empire Trial'),
(10105, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Contract Monopoly Trial'),
(10106, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Resource Cartel Trial'),
(10107, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Economic Warfare Trial'),
(10108, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Wealth Preservation Trial'),
(10109, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Investment Empire Trial'),
(10110, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Economic Espionage Trial'),
(10111, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Merchant Fleet Trial'),
(10112, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Black Market Trial'),
(10113, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Tax Collection Trial'),
(10114, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Economic Alliance Trial'),
(10115, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Currency Manipulation Trial'),
(10116, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Debt Empire Trial'),
(10117, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Economic Prophecy Trial'),
(10118, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Iron Ledger Ascension'),
(10119, 'FACTION_INTRO', 'IRON_LEDGER', 'Iron Ledger - Sanctum Access Granted'),
(10125, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Introduction to the Order of the Shrine'),
(10126, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Ether Awareness Trial'),
(10127, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Shrine Cleansing Trial'),
(10128, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Ether Channeling Trial'),
(10129, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Resurrection Mastery Trial'),
(10130, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Rift Sealing Trial'),
(10131, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Ether Binding Trial'),
(10132, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Soul Harvesting Trial'),
(10133, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Ether Storm Trial'),
(10134, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Shrine Guardian Trial'),
(10135, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Ether Nexus Trial'),
(10136, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Death Weaver Trial'),
(10137, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Reality Anchoring Trial'),
(10138, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Ether Prophecy Trial'),
(10139, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Order of the Shrine Ascension'),
(10140, 'FACTION_INTRO', 'ORDER_SHRINE', 'Order of the Shrine - Sanctum Access Granted')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `faction_tag` = VALUES(`faction_tag`),
    `notes` = VALUES(`notes`);

-- Summary
SELECT
    'Faction Intro Chains Implementation Complete' as status,
    COUNT(*) as total_quests_created,
    'Iron Ledger: 10100-10119 (20 quests)' as iron_ledger_range,
    'Order of the Shrine: 10125-10140 (16 quests)' as order_shrine_range,
    'Economic trials and Ether trials teach faction mechanics, grant standing, unlock Sanctum' as faction_mechanics
FROM quest_template
WHERE entry BETWEEN 10100 AND 10149;