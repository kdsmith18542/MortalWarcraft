
-- ==================================================
-- Project Mortal Warcraft
-- Feature: Act III Four Bargains
-- Description: Quest templates for advanced faction trials (10150-10199)
--              Shared setup quests and individual challenges for all four powers
-- Based on: spec 71
-- ==================================================

-- ==================================================
-- SHARED SETUP QUESTS (10150-10151)
-- ==================================================

-- Q10150: The Four Bargains
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10151,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500,
    `RequiredNpcOrGo1` = 101000, -- Iron Ledger Representative
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with faction representatives',
    `Title` = 'The Four Bargains',
    `Objectives` = 'Seek out representatives from the four great powers to learn about the advanced bargains they offer.',
    `Details` = 'The four powers - Iron Ledger, Order of the Shrine, Black Sun Cartel, and Rangers'' Pact - have prepared advanced trials for those who have proven their worth. These "Four Bargains" will test your mastery of their deepest secrets and grant access to advanced mechanics that shape the world itself.',
    `OfferRewardText` = 'The representatives await your arrival. Each bargain offers power beyond imagination.',
    `RequestItemsText` = 'Are you ready to bargain with the powers?',
    `EndText` = 'You have learned of the Four Bargains.',
    `CompletedText` = 'Return to the faction representatives.',
    `RewOrReqMoney` = 500,
    `Flags` = 0,
    `SpecialFlags` = 0
WHERE `entry` = 10150;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10150, 0, 1, 1, 10151, 0, 500, 101000, 'Speak with faction representatives',
    'The Four Bargains',
    'Seek out representatives from the four great powers to learn about the advanced bargains they offer.',
    'The four powers - Iron Ledger, Order of the Shrine, Black Sun Cartel, and Rangers'' Pact - have prepared advanced trials for those who have proven their worth. These "Four Bargains" will test your mastery of their deepest secrets and grant access to advanced mechanics that shape the world itself.',
    'The representatives await your arrival. Each bargain offers power beyond imagination.',
    'Are you ready to bargain with the powers?',
    'You have learned of the Four Bargains.',
    'Return to the faction representatives.',
    500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10150);

-- Q10151: Bargain Prerequisites
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 1000,
    `RequiredItemId1` = 101004, -- Iron Ledger Signet
    `RequiredItemCount1` = 1,
    `RequiredItemId2` = 101013, -- Shrine Sigil
    `RequiredItemCount2` = 1,
    `RequiredItemId3` = 101050, -- Cartel Badge
    `RequiredItemCount3` = 1,
    `RequiredItemId4` = 101060, -- Ranger's Totem
    `RequiredItemCount4` = 1,
    `ObjectiveText1` = 'Present faction tokens of mastery',
    `Title` = 'Bargain Prerequisites',
    `Objectives` = 'Present tokens of mastery from each of the four powers to prove your worthiness for the advanced bargains.',
    `Details` = '"To bargain with the powers at their highest level, you must prove you have mastered their basic teachings. Present the tokens of your previous trials - the Iron Signet, Shrine Sigil, Cartel Badge, and Ranger''s Totem. Only then will the advanced bargains be revealed."',
    `OfferRewardText` = 'Your tokens are recognized. The advanced bargains await.',
    `RequestItemsText` = 'Show me your tokens of mastery.',
    `EndText` = 'You have proven your worthiness.',
    `CompletedText` = 'Return to the faction representatives.',
    `RewOrReqMoney` = 1000,
    `Flags` = 0
WHERE `entry` = 10151;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `RequiredItemId1`, `RequiredItemCount1`, `RequiredItemId2`, `RequiredItemCount2`,
    `RequiredItemId3`, `RequiredItemCount3`, `RequiredItemId4`, `RequiredItemCount4`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10151, 2, 1, 1, 1000, 101004, 1, 101013, 1, 101050, 1, 101060, 1,
    'Present faction tokens of mastery',
    'Bargain Prerequisites',
    'Present tokens of mastery from each of the four powers to prove your worthiness for the advanced bargains.',
    '"To bargain with the powers at their highest level, you must prove you have mastered their basic teachings. Present the tokens of your previous trials - the Iron Signet, Shrine Sigil, Cartel Badge, and Ranger''s Totem. Only then will the advanced bargains be revealed."',
    'Your tokens are recognized. The advanced bargains await.',
    'Show me your tokens of mastery.',
    'You have proven your worthiness.',
    'Return to the faction representatives.',
    1000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10151);

-- ==================================================
-- IRON LEDGER ADVANCED ECONOMIC TRIALS (10152-10161)
-- ==================================================

-- Q10152: Derivatives Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10153,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2000,
    `ObjectiveText1` = 'Master derivatives trading and generate 50,000 gold profit',
    `Title` = 'Derivatives Mastery',
    `Objectives` = 'Learn and master derivatives trading by generating 50,000 gold profit through options, futures, and complex financial instruments.',
    `Details` = '"True economic mastery requires understanding derivatives - financial instruments whose value derives from underlying assets. Learn to trade options, futures, and swaps. Generate 50,000 gold profit to prove your mastery of these advanced instruments."',
    `OfferRewardText` = 'You have mastered the art of derivatives. Financial instruments bend to your will.',
    `RequestItemsText` = 'Have you mastered derivatives trading?',
    `EndText` = 'You have completed derivatives mastery.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 2000,
    `Flags` = 0
WHERE `entry` = 10152;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10152, 0, 1, 1, 10153, 2000, 'Master derivatives trading and generate 50,000 gold profit',
    'Derivatives Mastery',
    'Learn and master derivatives trading by generating 50,000 gold profit through options, futures, and complex financial instruments.',
    '"True economic mastery requires understanding derivatives - financial instruments whose value derives from underlying assets. Learn to trade options, futures, and swaps. Generate 50,000 gold profit to prove your mastery of these advanced instruments."',
    'You have mastered the art of derivatives. Financial instruments bend to your will.',
    'Have you mastered derivatives trading?',
    'You have completed derivatives mastery.',
    'Return to the Iron Ledger Representative.',
    2000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10152);

-- Q10153: Futures Empire
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10154,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2500,
    `ObjectiveText1` = 'Control futures markets across 10 commodities',
    `Title` = 'Futures Empire',
    `Objectives` = 'Establish control over futures markets for 10 different commodities by cornering positions and manipulating prices.',
    `Details` = '"Futures contracts allow you to buy or sell commodities at predetermined prices for future delivery. Build a futures empire by controlling positions in grains, metals, spices, and magical reagents. Your market manipulation will shape global trade."',
    `OfferRewardText` = 'The futures markets are yours. Commodities flow according to your contracts.',
    `RequestItemsText` = 'Have you built your futures empire?',
    `EndText` = 'You have completed the futures empire trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 2500,
    `Flags` = 0
WHERE `entry` = 10153;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10153, 0, 1, 1, 10154, 2500, 'Control futures markets across 10 commodities',
    'Futures Empire',
    'Establish control over futures markets for 10 different commodities by cornering positions and manipulating prices.',
    '"Futures contracts allow you to buy or sell commodities at predetermined prices for future delivery. Build a futures empire by controlling positions in grains, metals, spices, and magical reagents. Your market manipulation will shape global trade."',
    'The futures markets are yours. Commodities flow according to your contracts.',
    'Have you built your futures empire?',
    'You have completed the futures empire trial.',
    'Return to the Iron Ledger Representative.',
    2500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10153);

-- Q10154: Corporate Takeover
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10155,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3000,
    `ObjectiveText1` = 'Execute hostile takeover of a major trading company',
    `Title` = 'Corporate Takeover',
    `Objectives` = 'Use advanced financial tactics to execute a hostile takeover of a major trading company, gaining control of their assets and operations.',
    `Details` = '"Corporate takeovers are the ultimate expression of economic power. Use leveraged buyouts, proxy fights, and market manipulation to seize control of a major trading company. Their assets, contracts, and market position will become yours."',
    `OfferRewardText` = 'The company is yours. Corporate power is the highest form of economic dominance.',
    `RequestItemsText` = 'Have you completed the corporate takeover?',
    `EndText` = 'You have completed the corporate takeover trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 3000,
    `Flags` = 0
WHERE `entry` = 10154;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10154, 0, 1, 1, 10155, 3000, 'Execute hostile takeover of a major trading company',
    'Corporate Takeover',
    'Use advanced financial tactics to execute a hostile takeover of a major trading company, gaining control of their assets and operations.',
    '"Corporate takeovers are the ultimate expression of economic power. Use leveraged buyouts, proxy fights, and market manipulation to seize control of a major trading company. Their assets, contracts, and market position will become yours."',
    'The company is yours. Corporate power is the highest form of economic dominance.',
    'Have you completed the corporate takeover?',
    'You have completed the corporate takeover trial.',
    'Return to the Iron Ledger Representative.',
    3000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10154);

-- Q10155: Economic Intelligence Network
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10156,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3500,
    `ObjectiveText1` = 'Build intelligence network covering 20 market sectors',
    `Title` = 'Economic Intelligence Network',
    `Objectives` = 'Establish a comprehensive intelligence network that monitors and predicts economic activity across 20 different market sectors.',
    `Details` = '"Information is the lifeblood of advanced economics. Build a network of spies, analysts, and informants that covers every market sector - agriculture, mining, manufacturing, magic, transportation, and more. Use this intelligence to predict and profit from market movements."',
    `OfferRewardText` = 'Your intelligence network spans the world. No economic secret escapes your notice.',
    `RequestItemsText` = 'Have you built your intelligence network?',
    `EndText` = 'You have completed the intelligence network trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 3500,
    `Flags` = 0
WHERE `entry` = 10155;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10155, 0, 1, 1, 10156, 3500, 'Build intelligence network covering 20 market sectors',
    'Economic Intelligence Network',
    'Establish a comprehensive intelligence network that monitors and predicts economic activity across 20 different market sectors.',
    '"Information is the lifeblood of advanced economics. Build a network of spies, analysts, and informants that covers every market sector - agriculture, mining, manufacturing, magic, transportation, and more. Use this intelligence to predict and profit from market movements."',
    'Your intelligence network spans the world. No economic secret escapes your notice.',
    'Have you built your intelligence network?',
    'You have completed the intelligence network trial.',
    'Return to the Iron Ledger Representative.',
    3500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10155);

-- Q10156: Quantitative Trading Algorithm
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10157,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4000,
    `ObjectiveText1` = 'Develop and deploy algorithmic trading system',
    `Title` = 'Quantitative Trading Algorithm',
    `Objectives` = 'Create and deploy a sophisticated algorithmic trading system that generates consistent profits through mathematical models and high-frequency trading.',
    `Details` = '"The future of trading lies in algorithms. Develop quantitative models that analyze market data, identify patterns, and execute trades automatically. Your algorithm must generate 100,000 gold in profits while maintaining risk controls."',
    `OfferRewardText` = 'Your algorithm trades tirelessly. Mathematics has conquered the markets.',
    `RequestItemsText` = 'Have you deployed your trading algorithm?',
    `EndText` = 'You have completed the algorithmic trading trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 4000,
    `Flags` = 0
WHERE `entry` = 10156;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10156, 0, 1, 1, 10157, 4000, 'Develop and deploy algorithmic trading system',
    'Quantitative Trading Algorithm',
    'Create and deploy a sophisticated algorithmic trading system that generates consistent profits through mathematical models and high-frequency trading.',
    '"The future of trading lies in algorithms. Develop quantitative models that analyze market data, identify patterns, and execute trades automatically. Your algorithm must generate 100,000 gold in profits while maintaining risk controls."',
    'Your algorithm trades tirelessly. Mathematics has conquered the markets.',
    'Have you deployed your trading algorithm?',
    'You have completed the algorithmic trading trial.',
    'Return to the Iron Ledger Representative.',
    4000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10156);

-- Q10157: Global Economic Manipulation
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10158,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4500,
    `ObjectiveText1` = 'Orchestrate global economic event affecting 50 regions',
    `Title` = 'Global Economic Manipulation',
    `Objectives` = 'Orchestrate a major economic event that affects markets across 50 regions, demonstrating mastery of macroeconomic forces.',
    `Details` = '"True economic power shapes entire economies. Create a global economic event - whether a boom, bust, or transformation - that affects 50 regions simultaneously. Your actions will reshape the world''s wealth distribution."',
    `OfferRewardText` = 'The global economy moves at your command. Nations rise and fall by your design.',
    `RequestItemsText` = 'Have you orchestrated global economic change?',
    `EndText` = 'You have completed the global manipulation trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 4500,
    `Flags` = 0
WHERE `entry` = 10157;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10157, 0, 1, 1, 10158, 4500, 'Orchestrate global economic event affecting 50 regions',
    'Global Economic Manipulation',
    'Orchestrate a major economic event that affects markets across 50 regions, demonstrating mastery of macroeconomic forces.',
    '"True economic power shapes entire economies. Create a global economic event - whether a boom, bust, or transformation - that affects 50 regions simultaneously. Your actions will reshape the world''s wealth distribution."',
    'The global economy moves at your command. Nations rise and fall by your design.',
    'Have you orchestrated global economic change?',
    'You have completed the global manipulation trial.',
    'Return to the Iron Ledger Representative.',
    4500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10157);

-- Q10158: Economic Singularity
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10159,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 5000,
    `ObjectiveText1` = 'Achieve economic singularity - infinite wealth generation',
    `Title` = 'Economic Singularity',
    `Objectives` = 'Create a self-sustaining economic system that generates infinite wealth through perpetual motion of capital.',
    `Details` = '"The ultimate economic achievement is singularity - a system where wealth generates itself eternally. Create a perpetual motion machine of capital: investments that fund more investments, profits that create more profits, in an endless cycle of wealth generation."',
    `OfferRewardText` = 'You have achieved economic singularity. Wealth flows eternally from your creation.',
    `RequestItemsText` = 'Have you achieved economic singularity?',
    `EndText` = 'You have completed the economic singularity trial.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 5000,
    `Flags` = 0
WHERE `entry` = 10158;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10158, 0, 1, 1, 10159, 5000, 'Achieve economic singularity - infinite wealth generation',
    'Economic Singularity',
    'Create a self-sustaining economic system that generates infinite wealth through perpetual motion of capital.',
    '"The ultimate economic achievement is singularity - a system where wealth generates itself eternally. Create a perpetual motion machine of capital: investments that fund more investments, profits that create more profits, in an endless cycle of wealth generation."',
    'You have achieved economic singularity. Wealth flows eternally from your creation.',
    'Have you achieved economic singularity?',
    'You have completed the economic singularity trial.',
    'Return to the Iron Ledger Representative.',
    5000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10158);

-- Q10159: Iron Ledger Transcendence
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10160,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 6000,
    `RewardItemId1` = 101052, -- Advanced Iron Ledger Seal
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Complete the ultimate economic transcendence trial',
    `Title` = 'Iron Ledger Transcendence',
    `Objectives` = 'Demonstrate ultimate mastery of economic forces by transcending traditional wealth limitations.',
    `Details` = '"You stand at the threshold of economic transcendence. Go beyond mere wealth - become the economy itself. Your actions will shape reality through pure economic force. This is the highest bargain the Iron Ledger offers."',
    `OfferRewardText` = 'You have transcended economics. You are the market, the currency, the wealth of worlds.',
    `RequestItemsText` = 'Are you ready for economic transcendence?',
    `EndText` = 'You have achieved Iron Ledger transcendence.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 6000,
    `Flags` = 0
WHERE `entry` = 10159;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10159, 0, 1, 1, 10160, 6000, 101052, 1, 'Complete the ultimate economic transcendence trial',
    'Iron Ledger Transcendence',
    'Demonstrate ultimate mastery of economic forces by transcending traditional wealth limitations.',
    '"You stand at the threshold of economic transcendence. Go beyond mere wealth - become the economy itself. Your actions will shape reality through pure economic force. This is the highest bargain the Iron Ledger offers."',
    'You have transcended economics. You are the market, the currency, the wealth of worlds.',
    'Are you ready for economic transcendence?',
    'You have achieved Iron Ledger transcendence.',
    'Return to the Iron Ledger Representative.',
    6000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10159);

-- Q10160: Economic Sanctum Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 10000,
    `RewardItemId1` = 101053, -- Economic Sanctum Key
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Master the Economic Sanctum',
    `Title` = 'Economic Sanctum Mastery',
    `Objectives` = 'Complete your mastery of the Iron Ledger by unlocking the deepest secrets of the Economic Sanctum.',
    `Details` = '"The Economic Sanctum holds the ultimate secrets of wealth and power. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate reality itself through economic means."',
    `OfferRewardText` = 'The Economic Sanctum is yours. Economic reality bends to your command.',
    `RequestItemsText` = 'Claim your sanctum mastery.',
    `EndText` = 'You have mastered the Economic Sanctum.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 10000,
    `Flags` = 0
WHERE `entry` = 10160;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10160, 0, 1, 1, 10000, 101053, 1, 'Master the Economic Sanctum',
    'Economic Sanctum Mastery',
    'Complete your mastery of the Iron Ledger by unlocking the deepest secrets of the Economic Sanctum.',
    '"The Economic Sanctum holds the ultimate secrets of wealth and power. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate reality itself through economic means."',
    'The Economic Sanctum is yours. Economic reality bends to your command.',
    'Claim your sanctum mastery.',
    'You have mastered the Economic Sanctum.',
    'Return to the Iron Ledger Representative.',
    10000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10160);

-- Q10161: Iron Ledger Ascension II
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 15000,
    `ObjectiveText1` = 'Achieve final ascension in the Iron Ledger',
    `Title` = 'Iron Ledger Ascension II',
    `Objectives` = 'Complete your final ascension within the Iron Ledger, gaining ultimate economic enlightenment.',
    `Details` = '"Your journey with the Iron Ledger reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate economic enlightenment. Wealth, power, and reality itself will be yours to command eternally."',
    `OfferRewardText` = 'You have achieved ultimate ascension. The Iron Ledger recognizes you as its equal.',
    `RequestItemsText` = 'Embrace your final ascension.',
    `EndText` = 'You have completed Iron Ledger Ascension II.',
    `CompletedText` = 'Return to the Iron Ledger Representative.',
    `RewOrReqMoney` = 15000,
    `Flags` = 0
WHERE `entry` = 10161;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10161, 0, 1, 1, 15000, 'Achieve final ascension in the Iron Ledger',
    'Iron Ledger Ascension II',
    'Complete your final ascension within the Iron Ledger, gaining ultimate economic enlightenment.',
    '"Your journey with the Iron Ledger reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate economic enlightenment. Wealth, power, and reality itself will be yours to command eternally."',
    'You have achieved ultimate ascension. The Iron Ledger recognizes you as its equal.',
    'Embrace your final ascension.',
    'You have completed Iron Ledger Ascension II.',
    'Return to the Iron Ledger Representative.',
    15000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10161);

-- ==================================================
-- ORDER OF THE SHRINE ADVANCED ETHER TRIALS (10162-10171)
-- ==================================================

-- Q10162: Reality Weaving
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10163,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2000,
    `ObjectiveText1` = 'Weave 10 reality threads into new forms',
    `Title` = 'Reality Weaving',
    `Objectives` = 'Master the art of reality weaving by manipulating Ether threads to create 10 new forms of matter, energy, or life.',
    `Details` = '"Reality is but threads of Ether waiting to be woven. Learn to manipulate these fundamental strands to create new forms - living beings from nothingness, elements from pure energy, structures from imagination alone. Weave 10 such creations to prove your mastery."',
    `OfferRewardText` = 'You weave reality itself. Creation flows from your Ether command.',
    `RequestItemsText` = 'Have you mastered reality weaving?',
    `EndText` = 'You have completed reality weaving.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 2000,
    `Flags` = 0
WHERE `entry` = 10162;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10162, 0, 1, 1, 10163, 2000, 'Weave 10 reality threads into new forms',
    'Reality Weaving',
    'Master the art of reality weaving by manipulating Ether threads to create 10 new forms of matter, energy, or life.',
    '"Reality is but threads of Ether waiting to be woven. Learn to manipulate these fundamental strands to create new forms - living beings from nothingness, elements from pure energy, structures from imagination alone. Weave 10 such creations to prove your mastery."',
    'You weave reality itself. Creation flows from your Ether command.',
    'Have you mastered reality weaving?',
    'You have completed reality weaving.',
    'Return to the Order of the Shrine Representative.',
    2000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10162);

-- Q10163: Soul Binding Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10164,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2500,
    `ObjectiveText1` = 'Bind 15 souls to Ether constructs',
    `Title` = 'Soul Binding Mastery',
    `Objectives` = 'Master soul binding by capturing and integrating 15 souls into Ether constructs, creating powerful servants.',
    `Details` = '"Souls are the most powerful Ether constructs. Learn to capture souls at the moment of death and bind them to Ether forms. These soul-bound constructs will serve you eternally, their life force fueling your power. Bind 15 such souls to prove your mastery."',
    `OfferRewardText` = 'Souls bend to your will. Eternal servants rise from your Ether binding.',
    `RequestItemsText` = 'Have you mastered soul binding?',
    `EndText` = 'You have completed soul binding mastery.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 2500,
    `Flags` = 0
WHERE `entry` = 10163;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10163, 0, 1, 1, 10164, 2500, 'Bind 15 souls to Ether constructs',
    'Soul Binding Mastery',
    'Master soul binding by capturing and integrating 15 souls into Ether constructs, creating powerful servants.',
    '"Souls are the most powerful Ether constructs. Learn to capture souls at the moment of death and bind them to Ether forms. These soul-bound constructs will serve you eternally, their life force fueling your power. Bind 15 such souls to prove your mastery."',
    'Souls bend to your will. Eternal servants rise from your Ether binding.',
    'Have you mastered soul binding?',
    'You have completed soul binding mastery.',
    'Return to the Order of the Shrine Representative.',
    2500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10163);

-- Q10164: Ether Storm Conduction
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10165,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3000,
    `ObjectiveText1` = 'Conduct and control 5 major Ether storms',
    `Title` = 'Ether Storm Conduction',
    `Objectives` = 'Master Ether storm conduction by summoning, directing, and dissipating 5 major Ether storms across different regions.',
    `Details` = '"Ether storms are nature''s most violent Ether expressions. Learn to conduct these chaotic forces - summon them from the Ether plane, direct their destructive power toward your enemies, and dissipate them harmlessly. Control 5 such storms to prove your conduction mastery."',
    `OfferRewardText` = 'Ether storms obey your conduction. Chaos itself is your instrument.',
    `RequestItemsText` = 'Have you mastered Ether storm conduction?',
    `EndText` = 'You have completed Ether storm conduction.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 3000,
    `Flags` = 0
WHERE `entry` = 10164;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10164, 0, 1, 1, 10165, 3000, 'Conduct and control 5 major Ether storms',
    'Ether Storm Conduction',
    'Master Ether storm conduction by summoning, directing, and dissipating 5 major Ether storms across different regions.',
    '"Ether storms are nature''s most violent Ether expressions. Learn to conduct these chaotic forces - summon them from the Ether plane, direct their destructive power toward your enemies, and dissipate them harmlessly. Control 5 such storms to prove your conduction mastery."',
    'Ether storms obey your conduction. Chaos itself is your instrument.',
    'Have you mastered Ether storm conduction?',
    'You have completed Ether storm conduction.',
    'Return to the Order of the Shrine Representative.',
    3000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10164);

-- Q10165: Dimensional Anchoring
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10166,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3500,
    `ObjectiveText1` = 'Anchor 20 dimensional rifts',
    `Title` = 'Dimensional Anchoring',
    `Objectives` = 'Master dimensional anchoring by stabilizing 20 Ether rifts that threaten to tear reality apart.',
    `Details` = '"Dimensions bleed into each other through Ether rifts. Learn to anchor these tears in reality using Ether weaves that stabilize the dimensional fabric. Prevent 20 major rifts from expanding and consuming entire regions. Your anchoring will preserve reality itself."',
    `OfferRewardText` = 'Dimensions hold firm under your anchoring. Reality is secure in your Ether webs.',
    `RequestItemsText` = 'Have you mastered dimensional anchoring?',
    `EndText` = 'You have completed dimensional anchoring.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 3500,
    `Flags` = 0
WHERE `entry` = 10165;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10165, 0, 1, 1, 10166, 3500, 'Anchor 20 dimensional rifts',
    'Dimensional Anchoring',
    'Master dimensional anchoring by stabilizing 20 Ether rifts that threaten to tear reality apart.',
    '"Dimensions bleed into each other through Ether rifts. Learn to anchor these tears in reality using Ether weaves that stabilize the dimensional fabric. Prevent 20 major rifts from expanding and consuming entire regions. Your anchoring will preserve reality itself."',
    'Dimensions hold firm under your anchoring. Reality is secure in your Ether webs.',
    'Have you mastered dimensional anchoring?',
    'You have completed dimensional anchoring.',
    'Return to the Order of the Shrine Representative.',
    3500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10165);

-- Q10166: Ether Prophecy Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10167,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4000,
    `ObjectiveText1` = 'Accurately predict 25 major Ether events',
    `Title` = 'Ether Prophecy Mastery',
    `Objectives` = 'Master Ether prophecy by accurately predicting 25 major Ether events before they occur.',
    `Details` = '"The Ether flows show glimpses of future events. Learn to read these prophetic currents and predict major Ether phenomena - storm formations, rift openings, soul migrations, and reality shifts. Accurately predict 25 such events to prove your prophetic mastery."',
    `OfferRewardText` = 'The Ether''s future unfolds before your eyes. Prophecy is your divine right.',
    `RequestItemsText` = 'Have you mastered Ether prophecy?',
    `EndText` = 'You have completed Ether prophecy mastery.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 4000,
    `Flags` = 0
WHERE `entry` = 10166;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10166, 0, 1, 1, 10167, 4000, 'Accurately predict 25 major Ether events',
    'Ether Prophecy Mastery',
    'Master Ether prophecy by accurately predicting 25 major Ether events before they occur.',
    '"The Ether flows show glimpses of future events. Learn to read these prophetic currents and predict major Ether phenomena - storm formations, rift openings, soul migrations, and reality shifts. Accurately predict 25 such events to prove your prophetic mastery."',
    'The Ether''s future unfolds before your eyes. Prophecy is your divine right.',
    'Have you mastered Ether prophecy?',
    'You have completed Ether prophecy mastery.',
    'Return to the Order of the Shrine Representative.',
    4000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10166);

-- Q10167: Reality Reconstruction
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10168,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4500,
    `ObjectiveText1` = 'Reconstruct 5 destroyed regions',
    `Title` = 'Reality Reconstruction',
    `Objectives` = 'Master reality reconstruction by rebuilding 5 regions that have been completely destroyed by Ether catastrophes.',
    `Details` = '"Even destroyed reality can be rebuilt. Learn to reconstruct matter, energy, and life from pure Ether. Take 5 regions devastated by Ether storms or dimensional rifts and rebuild them completely - restoring landscapes, populations, and natural order from nothingness."',
    `OfferRewardText` = 'Destroyed worlds rise anew from your reconstruction. You are creation incarnate.',
    `RequestItemsText` = 'Have you mastered reality reconstruction?',
    `EndText` = 'You have completed reality reconstruction.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 4500,
    `Flags` = 0
WHERE `entry` = 10167;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10167, 0, 1, 1, 10168, 4500, 'Reconstruct 5 destroyed regions',
    'Reality Reconstruction',
    'Master reality reconstruction by rebuilding 5 regions that have been completely destroyed by Ether catastrophes.',
    '"Even destroyed reality can be rebuilt. Learn to reconstruct matter, energy, and life from pure Ether. Take 5 regions devastated by Ether storms or dimensional rifts and rebuild them completely - restoring landscapes, populations, and natural order from nothingness."',
    'Destroyed worlds rise anew from your reconstruction. You are creation incarnate.',
    'Have you mastered reality reconstruction?',
    'You have completed reality reconstruction.',
    'Return to the Order of the Shrine Representative.',
    4500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10167);

-- Q10168: Ether Singularity
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10169,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 5000,
    `ObjectiveText1` = 'Create an Ether singularity',
    `Title` = 'Ether Singularity',
    'Achieve Ether singularity by collapsing infinite Ether energy into a single, controllable point.',
    `Details` = '"The ultimate Ether achievement is singularity - infinite energy contained in a single point. Learn to collapse Ether flows into a singularity that contains limitless power yet remains perfectly controlled. This singularity will be the source of all your Ether manipulations."',
    `OfferRewardText` = 'Ether singularity achieved. Infinite power contained in your grasp.',
    `RequestItemsText` = 'Have you created an Ether singularity?',
    `EndText` = 'You have completed Ether singularity.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 5000,
    `Flags` = 0
WHERE `entry` = 10168;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10168, 0, 1, 1, 10169, 5000, 'Create an Ether singularity',
    'Ether Singularity',
    'Achieve Ether singularity by collapsing infinite Ether energy into a single, controllable point.',
    '"The ultimate Ether achievement is singularity - infinite energy contained in a single point. Learn to collapse Ether flows into a singularity that contains limitless power yet remains perfectly controlled. This singularity will be the source of all your Ether manipulations."',
    'Ether singularity achieved. Infinite power contained in your grasp.',
    'Have you created an Ether singularity?',
    'You have completed Ether singularity.',
    'Return to the Order of the Shrine Representative.',
    5000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10168);

-- Q10169: Shrine Transcendence
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10170,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 6000,
    `RewardItemId1` = 101054, -- Advanced Shrine Sigil
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Complete the ultimate Ether transcendence trial',
    `Title` = 'Shrine Transcendence',
    `Objectives` = 'Demonstrate ultimate mastery of Ether forces by transcending traditional reality limitations.',
    `Details` = '"You stand at the threshold of Ether transcendence. Go beyond mere manipulation - become the Ether itself. Your consciousness will merge with the Ether flows, allowing you to reshape existence at will. This is the highest bargain the Order of the Shrine offers."',
    `OfferRewardText` = 'You have transcended Ether. You are the flows, the storms, the reality of worlds.',
    `RequestItemsText` = 'Are you ready for Ether transcendence?',
    `EndText` = 'You have achieved Shrine transcendence.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 6000,
    `Flags` = 0
WHERE `entry` = 10169;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10169, 0, 1, 1, 10170, 6000, 101054, 1, 'Complete the ultimate Ether transcendence trial',
    'Shrine Transcendence',
    'Demonstrate ultimate mastery of Ether forces by transcending traditional reality limitations.',
    '"You stand at the threshold of Ether transcendence. Go beyond mere manipulation - become the Ether itself. Your consciousness will merge with the Ether flows, allowing you to reshape existence at will. This is the highest bargain the Order of the Shrine offers."',
    'You have transcended Ether. You are the flows, the storms, the reality of worlds.',
    'Are you ready for Ether transcendence?',
    'You have achieved Shrine transcendence.',
    'Return to the Order of the Shrine Representative.',
    6000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10169);

-- Q10170: Ether Sanctum Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 10000,
    `RewardItemId1` = 101055, -- Ether Sanctum Key
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Master the Ether Sanctum',
    `Title` = 'Ether Sanctum Mastery',
    `Objectives` = 'Complete your mastery of the Order of the Shrine by unlocking the deepest secrets of the Ether Sanctum.',
    `Details` = '"The Ether Sanctum holds the ultimate secrets of Ether and reality. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate existence itself through Ether transcendence."',
    `OfferRewardText` = 'The Ether Sanctum is yours. Ether reality bends to your transcendent command.',
    `RequestItemsText` = 'Claim your sanctum mastery.',
    `EndText` = 'You have mastered the Ether Sanctum.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 10000,
    `Flags` = 0
WHERE `entry` = 10170;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10170, 0, 1, 1, 10000, 101055, 1, 'Master the Ether Sanctum',
    'Ether Sanctum Mastery',
    'Complete your mastery of the Order of the Shrine by unlocking the deepest secrets of the Ether Sanctum.',
    '"The Ether Sanctum holds the ultimate secrets of Ether and reality. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate existence itself through Ether transcendence."',
    'The Ether Sanctum is yours. Ether reality bends to your transcendent command.',
    'Claim your sanctum mastery.',
    'You have mastered the Ether Sanctum.',
    'Return to the Order of the Shrine Representative.',
    10000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10170);

-- Q10171: Shrine Ascension II
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 15000,
    `ObjectiveText1` = 'Achieve final ascension in the Order of the Shrine',
    `Title` = 'Shrine Ascension II',
    `Objectives` = 'Complete your final ascension within the Order of the Shrine, gaining ultimate Ether enlightenment.',
    `Details` = '"Your journey with the Order of the Shrine reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate Ether enlightenment. Reality, existence, and the Ether itself will be yours to command eternally."',
    `OfferRewardText` = 'You have achieved ultimate ascension. The Order of the Shrine recognizes you as its equal.',
    `RequestItemsText` = 'Embrace your final ascension.',
    `EndText` = 'You have completed Shrine Ascension II.',
    `CompletedText` = 'Return to the Order of the Shrine Representative.',
    `RewOrReqMoney` = 15000,
    `Flags` = 0
WHERE `entry` = 10171;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10171, 0, 1, 1, 15000, 'Achieve final ascension in the Order of the Shrine',
    'Shrine Ascension II',
    'Complete your final ascension within the Order of the Shrine, gaining ultimate Ether enlightenment.',
    '"Your journey with the Order of the Shrine reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate Ether enlightenment. Reality, existence, and the Ether itself will be yours to command eternally."',
    'You have achieved ultimate ascension. The Order of the Shrine recognizes you as its equal.',
    'Embrace your final ascension.',
    'You have completed Shrine Ascension II.',
    'Return to the Order of the Shrine Representative.',
    15000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10171);

-- ==================================================
-- BLACK SUN CARTEL ADVANCED CRIMINAL TRIALS (10172-10181)
-- ==================================================

-- Q10172: Grand Heist Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10173,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2000,
    `ObjectiveText1` = 'Execute 5 grand heists worth 100,000 gold each',
    `Title` = 'Grand Heist Mastery',
    `Objectives` = 'Master grand heists by planning and executing 5 elaborate thefts, each netting at least 100,000 gold in valuables.',
    `Details` = '"The Black Sun Cartel lives for the grand heist - the perfect crime that turns the tables on the wealthy and powerful. Learn to plan intricate operations involving multiple teams, diversions, and flawless execution. Complete 5 such heists to prove your criminal mastery."',
    `OfferRewardText` = 'The grand heists are yours. Fortune favors the bold criminal.',
    `RequestItemsText` = 'Have you mastered grand heists?',
    `EndText` = 'You have completed grand heist mastery.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 2000,
    `Flags` = 0
WHERE `entry` = 10172;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10172, 0, 1, 1, 10173, 2000, 'Execute 5 grand heists worth 100,000 gold each',
    'Grand Heist Mastery',
    'Master grand heists by planning and executing 5 elaborate thefts, each netting at least 100,000 gold in valuables.',
    '"The Black Sun Cartel lives for the grand heist - the perfect crime that turns the tables on the wealthy and powerful. Learn to plan intricate operations involving multiple teams, diversions, and flawless execution. Complete 5 such heists to prove your criminal mastery."',
    'The grand heists are yours. Fortune favors the bold criminal.',
    'Have you mastered grand heists?',
    'You have completed grand heist mastery.',
    'Return to the Black Sun Cartel Representative.',
    2000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10172);

-- Q10173: Underworld Empire
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10174,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2500,
    `ObjectiveText1` = 'Build an underworld empire controlling 15 criminal operations',
    `Title` = 'Underworld Empire',
    `Objectives` = 'Establish control over 15 different criminal operations, creating a vast underworld empire under your command.',
    `Details` = '"True criminal power comes from organization. Build an empire of thieves, smugglers, assassins, and fences. Control 15 different operations across smuggling, protection, gambling, and illicit trade. Your underworld empire will rival legitimate kingdoms in power and wealth."',
    `OfferRewardText` = 'The underworld bows to your empire. Criminal enterprise is your domain.',
    `RequestItemsText` = 'Have you built your underworld empire?',
    `EndText` = 'You have completed the underworld empire trial.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 2500,
    `Flags` = 0
WHERE `entry` = 10173;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10173, 0, 1, 1, 10174, 2500, 'Build an underworld empire controlling 15 criminal operations',
    'Underworld Empire',
    'Establish control over 15 different criminal operations, creating a vast underworld empire under your command.',
    '"True criminal power comes from organization. Build an empire of thieves, smugglers, assassins, and fences. Control 15 different operations across smuggling, protection, gambling, and illicit trade. Your underworld empire will rival legitimate kingdoms in power and wealth."',
    'The underworld bows to your empire. Criminal enterprise is your domain.',
    'Have you built your underworld empire?',
    'You have completed the underworld empire trial.',
    'Return to the Black Sun Cartel Representative.',
    2500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10173);

-- Q10174: Smuggling Networks
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10175,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3000,
    `ObjectiveText1` = 'Establish smuggling routes across 20 regions',
    `Title` = 'Smuggling Networks',
    `Objectives` = 'Master smuggling by establishing covert trade routes that bypass 20 different regional authorities and borders.',
    `Details` = '"Smuggling is the lifeblood of the Black Sun Cartel. Learn to establish hidden routes, bribe officials, create false manifests, and move goods undetected. Build smuggling networks across 20 regions, ensuring that no border or authority can stop your illicit trade."',
    `OfferRewardText` = 'Smuggling networks span the world. No border contains your enterprise.',
    `RequestItemsText` = 'Have you established your smuggling networks?',
    `EndText` = 'You have completed the smuggling networks trial.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 3000,
    `Flags` = 0
WHERE `entry` = 10174;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10174, 0, 1, 1, 10175, 3000, 'Establish smuggling routes across 20 regions',
    'Smuggling Networks',
    'Master smuggling by establishing covert trade routes that bypass 20 different regional authorities and borders.',
    '"Smuggling is the lifeblood of the Black Sun Cartel. Learn to establish hidden routes, bribe officials, create false manifests, and move goods undetected. Build smuggling networks across 20 regions, ensuring that no border or authority can stop your illicit trade."',
    'Smuggling networks span the world. No border contains your enterprise.',
    'Have you established your smuggling networks?',
    'You have completed the smuggling networks trial.',
    'Return to the Black Sun Cartel Representative.',
    3000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10174);

-- Q10175: Assassination Contracts
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10176,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3500,
    `ObjectiveText1` = 'Complete 25 high-profile assassination contracts',
    `Title` = 'Assassination Contracts',
    `Objectives` = 'Master assassination by completing 25 contracts targeting powerful figures in politics, business, and crime.',
    `Details` = '"The Black Sun Cartel eliminates threats and collects debts through assassination. Learn the arts of poison, stealth, sabotage, and direct action. Complete 25 high-profile contracts, each targeting individuals of significant power or influence. Your reputation as a killer will become legendary."',
    `OfferRewardText` = 'Assassination contracts fulfilled. Fear is your greatest weapon.',
    `RequestItemsText` = 'Have you completed the assassination contracts?',
    `EndText` = 'You have completed the assassination contracts trial.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 3500,
    `Flags` = 0
WHERE `entry` = 10175;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10175, 0, 1, 1, 10176, 3500, 'Complete 25 high-profile assassination contracts',
    'Assassination Contracts',
    'Master assassination by completing 25 contracts targeting powerful figures in politics, business, and crime.',
    '"The Black Sun Cartel eliminates threats and collects debts through assassination. Learn the arts of poison, stealth, sabotage, and direct action. Complete 25 high-profile contracts, each targeting individuals of significant power or influence. Your reputation as a killer will become legendary."',
    'Assassination contracts fulfilled. Fear is your greatest weapon.',
    'Have you completed the assassination contracts?',
    'You have completed the assassination contracts trial.',
    'Return to the Black Sun Cartel Representative.',
    3500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10175);

-- Q10176: Criminal Intelligence Network
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10177,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4000,
    `ObjectiveText1` = 'Build criminal intelligence network covering 30 targets',
    `Title` = 'Criminal Intelligence Network',
    `Objectives` = 'Establish a comprehensive intelligence network that monitors and predicts the activities of 30 high-value criminal and law enforcement targets.',
    `Details` = '"Information is the criminal''s most valuable asset. Build a network of informants, hackers, spies, and surveillance experts. Monitor 30 key targets - rival criminals, law enforcement officials, wealthy marks, and political figures. Use this intelligence to plan perfect crimes and avoid detection."',
    `OfferRewardText` = 'Your intelligence network knows all secrets. No criminal escapes your notice.',
    `RequestItemsText` = 'Have you built your criminal intelligence network?',
    `EndText` = 'You have completed the intelligence network trial.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 4000,
    `Flags` = 0
WHERE `entry` = 10176;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10176, 0, 1, 1, 10177, 4000, 'Build criminal intelligence network covering 30 targets',
    'Criminal Intelligence Network',
    'Establish a comprehensive intelligence network that monitors and predicts the activities of 30 high-value criminal and law enforcement targets.',
    '"Information is the criminal''s most valuable asset. Build a network of informants, hackers, spies, and surveillance experts. Monitor 30 key targets - rival criminals, law enforcement officials, wealthy marks, and political figures. Use this intelligence to plan perfect crimes and avoid detection."',
    'Your intelligence network knows all secrets. No criminal escapes your notice.',
    'Have you built your criminal intelligence network?',
    'You have completed the intelligence network trial.',
    'Return to the Black Sun Cartel Representative.',
    4000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10176);

-- Q10177: Money Laundering Empire
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10178,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4500,
    `ObjectiveText1` = 'Launder 1,000,000 gold through legitimate businesses',
    `Title` = 'Money Laundering Empire',
    `Objectives` = 'Master money laundering by cleaning 1,000,000 gold worth of illicit funds through legitimate business fronts.',
    `Details` = '"Dirty money must become clean money. Learn the art of money laundering - creating shell companies, manipulating financial records, using casinos and real estate, establishing legitimate business fronts. Launder 1,000,000 gold to prove your mastery of financial deception."',
    `OfferRewardText` = 'Money laundering empire established. Illicit wealth becomes legitimate power.',
    `RequestItemsText` = 'Have you built your money laundering empire?',
    `EndText` = 'You have completed the money laundering trial.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 4500,
    `Flags` = 0
WHERE `entry` = 10177;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10177, 0, 1, 1, 10178, 4500, 'Launder 1,000,000 gold through legitimate businesses',
    'Money Laundering Empire',
    'Master money laundering by cleaning 1,000,000 gold worth of illicit funds through legitimate business fronts.',
    '"Dirty money must become clean money. Learn the art of money laundering - creating shell companies, manipulating financial records, using casinos and real estate, establishing legitimate business fronts. Launder 1,000,000 gold to prove your mastery of financial deception."',
    'Money laundering empire established. Illicit wealth becomes legitimate power.',
    'Have you built your money laundering empire?',
    'You have completed the money laundering trial.',
    'Return to the Black Sun Cartel Representative.',
    4500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10177);

-- Q10178: Criminal Singularity
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10179,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 5000,
    `ObjectiveText1` = 'Achieve criminal singularity - perfect crime execution',
    `Title` = 'Criminal Singularity',
    `Objectives` = 'Create a criminal organization so efficient and undetectable that crime becomes indistinguishable from legitimate business.',
    `Details` = '"The ultimate criminal achievement is singularity - when criminal enterprise becomes so sophisticated that it operates as legitimate business. Create an organization where smuggling appears as trade, assassination as natural death, theft as business acquisition. Crime becomes the new normal under your command."',
    `OfferRewardText` = 'Criminal singularity achieved. Crime is now the foundation of society.',
    `RequestItemsText` = 'Have you achieved criminal singularity?',
    `EndText` = 'You have completed the criminal singularity trial.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 5000,
    `Flags` = 0
WHERE `entry` = 10178;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10178, 0, 1, 1, 10179, 5000, 'Achieve criminal singularity - perfect crime execution',
    'Criminal Singularity',
    'Create a criminal organization so efficient and undetectable that crime becomes indistinguishable from legitimate business.',
    '"The ultimate criminal achievement is singularity - when criminal enterprise becomes so sophisticated that it operates as legitimate business. Create an organization where smuggling appears as trade, assassination as natural death, theft as business acquisition. Crime becomes the new normal under your command."',
    'Criminal singularity achieved. Crime is now the foundation of society.',
    'Have you achieved criminal singularity?',
    'You have completed the criminal singularity trial.',
    'Return to the Black Sun Cartel Representative.',
    5000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10178);

-- Q10179: Cartel Transcendence
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10180,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 6000,
    `RewardItemId1` = 101056, -- Advanced Cartel Badge
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Complete the ultimate criminal transcendence trial',
    `Title` = 'Cartel Transcendence',
    `Objectives` = 'Demonstrate ultimate mastery of criminal forces by transcending traditional underworld limitations.',
    `Details` = '"You stand at the threshold of criminal transcendence. Go beyond mere crime - become the underworld itself. Your operations will shape society through shadow influence. This is the highest bargain the Black Sun Cartel offers."',
    `OfferRewardText` = 'You have transcended crime. You are the shadows, the deals, the corruption of worlds.',
    `RequestItemsText` = 'Are you ready for criminal transcendence?',
    `EndText` = 'You have achieved Cartel transcendence.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 6000,
    `Flags` = 0
WHERE `entry` = 10179;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10179, 0, 1, 1, 10180, 6000, 101056, 1, 'Complete the ultimate criminal transcendence trial',
    'Cartel Transcendence',
    'Demonstrate ultimate mastery of criminal forces by transcending traditional underworld limitations.',
    '"You stand at the threshold of criminal transcendence. Go beyond mere crime - become the underworld itself. Your operations will shape society through shadow influence. This is the highest bargain the Black Sun Cartel offers."',
    'You have transcended crime. You are the shadows, the deals, the corruption of worlds.',
    'Are you ready for criminal transcendence?',
    'You have achieved Cartel transcendence.',
    'Return to the Black Sun Cartel Representative.',
    6000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10179);

-- Q10180: Shadow Sanctum Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 10000,
    `RewardItemId1` = 101057, -- Shadow Sanctum Key
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Master the Shadow Sanctum',
    `Title` = 'Shadow Sanctum Mastery',
    `Objectives` = 'Complete your mastery of the Black Sun Cartel by unlocking the deepest secrets of the Shadow Sanctum.',
    `Details` = '"The Shadow Sanctum holds the ultimate secrets of crime and power. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate society itself through criminal transcendence."',
    `OfferRewardText` = 'The Shadow Sanctum is yours. Criminal reality bends to your transcendent command.',
    `RequestItemsText` = 'Claim your sanctum mastery.',
    `EndText` = 'You have mastered the Shadow Sanctum.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 10000,
    `Flags` = 0
WHERE `entry` = 10180;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10180, 0, 1, 1, 10000, 101057, 1, 'Master the Shadow Sanctum',
    'Shadow Sanctum Mastery',
    'Complete your mastery of the Black Sun Cartel by unlocking the deepest secrets of the Shadow Sanctum.',
    '"The Shadow Sanctum holds the ultimate secrets of crime and power. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate society itself through criminal transcendence."',
    'The Shadow Sanctum is yours. Criminal reality bends to your transcendent command.',
    'Claim your sanctum mastery.',
    'You have mastered the Shadow Sanctum.',
    'Return to the Black Sun Cartel Representative.',
    10000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10180);

-- Q10181: Cartel Ascension II
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 15000,
    `ObjectiveText1` = 'Achieve final ascension in the Black Sun Cartel',
    `Title` = 'Cartel Ascension II',
    `Objectives` = 'Complete your final ascension within the Black Sun Cartel, gaining ultimate criminal enlightenment.',
    `Details` = '"Your journey with the Black Sun Cartel reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate criminal enlightenment. Crime, power, and society itself will be yours to command eternally."',
    `OfferRewardText` = 'You have achieved ultimate ascension. The Black Sun Cartel recognizes you as its equal.',
    `RequestItemsText` = 'Embrace your final ascension.',
    `EndText` = 'You have completed Cartel Ascension II.',
    `CompletedText` = 'Return to the Black Sun Cartel Representative.',
    `RewOrReqMoney` = 15000,
    `Flags` = 0
WHERE `entry` = 10181;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardMoney`,
    `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10181, 0, 1, 1, 15000, 'Achieve final ascension in the Black Sun Cartel',
    'Cartel Ascension II',
    'Complete your final ascension within the Black Sun Cartel, gaining ultimate criminal enlightenment.',
    '"Your journey with the Black Sun Cartel reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate criminal enlightenment. Crime, power, and society itself will be yours to command eternally."',
    'You have achieved ultimate ascension. The Black Sun Cartel recognizes you as its equal.',
    'Embrace your final ascension.',
    'You have completed Cartel Ascension II.',
    'Return to the Black Sun Cartel Representative.',
    15000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10181);

-- ==================================================
-- RANGERS' PACT ADVANCED SURVIVAL TRIALS (10182-10191)
-- ==================================================

-- Q10182: Wilderness Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10183,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2000,
    `ObjectiveText1` = 'Master survival in 10 extreme wilderness environments',
    `Title` = 'Wilderness Mastery',
    `Objectives` = 'Demonstrate ultimate wilderness survival skills by thriving in 10 different extreme environmental conditions.',
    `Details` = '"The Rangers'' Pact survives where others perish. Learn to master deserts, tundras, jungles, mountains, and deadly wastelands. Adapt to extreme temperatures, poisonous flora, predatory fauna, and environmental hazards. Survive 10 such environments to prove your wilderness mastery."',
    `OfferRewardText` = 'The wilderness is your home. Nature itself recognizes your mastery.',
    `RequestItemsText` = 'Have you mastered wilderness survival?',
    `EndText` = 'You have completed wilderness mastery.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 2000,
    `Flags` = 0
WHERE `entry` = 10182;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10182, 0, 1, 1, 10183, 2000, 'Master survival in 10 extreme wilderness environments',
    'Wilderness Mastery',
    'Demonstrate ultimate wilderness survival skills by thriving in 10 different extreme environmental conditions.',
    '"The Rangers'' Pact survives where others perish. Learn to master deserts, tundras, jungles, mountains, and deadly wastelands. Adapt to extreme temperatures, poisonous flora, predatory fauna, and environmental hazards. Survive 10 such environments to prove your wilderness mastery."',
    'The wilderness is your home. Nature itself recognizes your mastery.',
    'Have you mastered wilderness survival?',
    'You have completed wilderness mastery.',
    'Return to the Rangers'' Pact Representative.',
    2000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10182);

-- Q10183: Beast Taming
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10184,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 2500,
    `ObjectiveText1` = 'Tame and bond with 12 legendary beasts',
    `Title` = 'Beast Taming',
    `Objectives` = 'Master beast taming by forming spiritual bonds with 12 legendary creatures of the wild.',
    `Details` = '"The Rangers'' Pact communes with the great beasts of the world. Learn ancient bonding rituals, understand animal spirits, and form pacts with legendary creatures. Tame wolves, bears, eagles, serpents, and mythical beasts. Your bond with 12 such creatures will make you one with the wild."',
    `OfferRewardText` = 'Beasts recognize you as kin. The wild is your ally and servant.',
    `RequestItemsText` = 'Have you mastered beast taming?',
    `EndText` = 'You have completed beast taming.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 2500,
    `Flags` = 0
WHERE `entry` = 10183;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10183, 0, 1, 1, 10184, 2500, 'Tame and bond with 12 legendary beasts',
    'Beast Taming',
    'Master beast taming by forming spiritual bonds with 12 legendary creatures of the wild.',
    '"The Rangers'' Pact communes with the great beasts of the world. Learn ancient bonding rituals, understand animal spirits, and form pacts with legendary creatures. Tame wolves, bears, eagles, serpents, and mythical beasts. Your bond with 12 such creatures will make you one with the wild."',
    'Beasts recognize you as kin. The wild is your ally and servant.',
    'Have you mastered beast taming?',
    'You have completed beast taming.',
    'Return to the Rangers'' Pact Representative.',
    2500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10183);

-- Q10184: Ancient Lore Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10185,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3000,
    `ObjectiveText1` = 'Uncover and master 15 ancient wilderness secrets',
    `Title` = 'Ancient Lore Mastery',
    `Objectives` = 'Master ancient wilderness lore by discovering and understanding 15 hidden secrets of the natural world.',
    `Details` = '"The Rangers'' Pact preserves ancient knowledge of the wild. Learn forgotten languages, decipher natural runes, discover hidden groves, and understand ley lines. Uncover 15 ancient secrets - lost civilizations, magical flora, spirit pathways, and natural phenomena that modern scholars have forgotten."',
    `OfferRewardText` = 'Ancient lore flows through you. The wilderness reveals its deepest secrets.',
    `RequestItemsText` = 'Have you mastered ancient lore?',
    `EndText` = 'You have completed ancient lore mastery.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 3000,
    `Flags` = 0
WHERE `entry` = 10184;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10184, 0, 1, 1, 10185, 3000, 'Uncover and master 15 ancient wilderness secrets',
    'Ancient Lore Mastery',
    'Master ancient wilderness lore by discovering and understanding 15 hidden secrets of the natural world.',
    '"The Rangers'' Pact preserves ancient knowledge of the wild. Learn forgotten languages, decipher natural runes, discover hidden groves, and understand ley lines. Uncover 15 ancient secrets - lost civilizations, magical flora, spirit pathways, and natural phenomena that modern scholars have forgotten."',
    'Ancient lore flows through you. The wilderness reveals its deepest secrets.',
    'Have you mastered ancient lore?',
    'You have completed ancient lore mastery.',
    'Return to the Rangers'' Pact Representative.',
    3000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10184);

-- Q10185: Guardian Spirit Bonding
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10186,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 3500,
    `ObjectiveText1` = 'Bond with 8 guardian spirits of nature',
    `Title` = 'Guardian Spirit Bonding',
    `Objectives` = 'Form sacred bonds with 8 powerful guardian spirits that protect natural realms and ancient sites.',
    `Details` = '"Guardian spirits watch over the sacred places of the world. Learn to commune with these powerful entities - tree spirits, mountain guardians, river deities, and storm keepers. Form bonds with 8 such spirits, gaining their protection and wisdom. Your pact will make you a guardian of the natural world."',
    `OfferRewardText` = 'Guardian spirits accept your bond. Nature''s power flows through you.',
    `RequestItemsText` = 'Have you bonded with guardian spirits?',
    `EndText` = 'You have completed guardian spirit bonding.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 3500,
    `Flags` = 0
WHERE `entry` = 10185;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10185, 0, 1, 1, 10186, 3500, 'Bond with 8 guardian spirits of nature',
    'Guardian Spirit Bonding',
    'Form sacred bonds with 8 powerful guardian spirits that protect natural realms and ancient sites.',
    '"Guardian spirits watch over the sacred places of the world. Learn to commune with these powerful entities - tree spirits, mountain guardians, river deities, and storm keepers. Form bonds with 8 such spirits, gaining their protection and wisdom. Your pact will make you a guardian of the natural world."',
    'Guardian spirits accept your bond. Nature''s power flows through you.',
    'Have you bonded with guardian spirits?',
    'You have completed guardian spirit bonding.',
    'Return to the Rangers'' Pact Representative.',
    3500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10185);

-- Q10186: Elemental Harmony
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10187,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4000,
    `ObjectiveText1` = 'Achieve harmony with 12 elemental forces',
    `Title` = 'Elemental Harmony',
    `Objectives` = 'Master elemental harmony by achieving balance and control over 12 different elemental forces of nature.',
    `Details` = '"The Rangers'' Pact maintains harmony with the elements. Learn to commune with fire, water, earth, air, and their advanced manifestations - lightning, ice, magma, and more. Achieve harmony with 12 elemental forces, bending them to your will while maintaining natural balance."',
    `OfferRewardText` = 'Elements flow in harmony with your command. Nature''s fury is your ally.',
    `RequestItemsText` = 'Have you achieved elemental harmony?',
    `EndText` = 'You have completed elemental harmony.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 4000,
    `Flags` = 0
WHERE `entry` = 10186;

INSERT INTO `quest_template` (`entry`, `
    `Objectives` =
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10186, 0, 1, 1, 10187, 4000, 'Achieve harmony with 12 elemental forces',
    'Elemental Harmony',
    'Master elemental harmony by achieving balance and control over 12 different elemental forces of nature.',
    '"The Rangers'' Pact maintains harmony with the elements. Learn to commune with fire, water, earth, air, and their advanced manifestations - lightning, ice, magma, and more. Achieve harmony with 12 elemental forces, bending them to your will while maintaining natural balance."',
    'Elements flow in harmony with your command. Nature''s fury is your ally.',
    'Have you achieved elemental harmony?',
    'You have completed elemental harmony.',
    'Return to the Rangers'' Pact Representative.',
    4000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10186);

-- Q10187: Nature's Wrath
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10188,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 4500,
    `ObjectiveText1` = 'Unleash nature''s wrath against 20 corruption sites',
    `Title` = 'Nature''s Wrath',
    `Objectives` = 'Master nature''s wrath by directing elemental forces to destroy 20 sites of corruption and darkness.',
    `Details` = '"The Rangers'' Pact wields nature''s wrath against those who defile the wild. Learn to summon elemental storms, earthquake swarms, and wildfire tempests. Direct nature''s fury against 20 corruption sites - dark temples, poison factories, and despoiled lands. Let the wild reclaim what is hers."',
    `OfferRewardText` = 'Nature''s wrath cleanses the land. Corruption trembles before the wild.',
    `RequestItemsText` = 'Have you unleashed nature''s wrath?',
    `EndText` = 'You have completed nature''s wrath.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 4500,
    `Flags` = 0
WHERE `entry` = 10187;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10187, 0, 1, 1, 10188, 4500, 'Unleash nature''s wrath against 20 corruption sites',
    'Nature''s Wrath',
    'Master nature''s wrath by directing elemental forces to destroy 20 sites of corruption and darkness.',
    '"The Rangers'' Pact wields nature''s wrath against those who defile the wild. Learn to summon elemental storms, earthquake swarms, and wildfire tempests. Direct nature''s fury against 20 corruption sites - dark temples, poison factories, and despoiled lands. Let the wild reclaim what is hers."',
    'Nature''s wrath cleanses the land. Corruption trembles before the wild.',
    'Have you unleashed nature''s wrath?',
    'You have completed nature''s wrath.',
    'Return to the Rangers'' Pact Representative.',
    4500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10187);

-- Q10188: Survival Singularity
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10189,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 5000,
    `ObjectiveText1` = 'Achieve survival singularity - become one with the wilderness',
    `Title` = 'Survival Singularity',
    `Objectives` = 'Achieve survival singularity by becoming so attuned to nature that survival becomes instinctual and limitless.',
    `Details` = '"The ultimate survival achievement is singularity - when you become one with the wilderness itself. Learn to draw sustenance from the air, heal wounds through natural energies, and perceive threats before they manifest. Survival becomes not a skill, but your very essence."',
    `OfferRewardText` = 'Survival singularity achieved. The wilderness is your eternal self.',
    `RequestItemsText` = 'Have you achieved survival singularity?',
    `EndText` = 'You have completed the survival singularity trial.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 5000,
    `Flags` = 0
WHERE `entry` = 10188;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10188, 0, 1, 1, 10189, 5000, 'Achieve survival singularity - become one with the wilderness',
    'Survival Singularity',
    'Achieve survival singularity by becoming so attuned to nature that survival becomes instinctual and limitless.',
    '"The ultimate survival achievement is singularity - when you become one with the wilderness itself. Learn to draw sustenance from the air, heal wounds through natural energies, and perceive threats before they manifest. Survival becomes not a skill, but your very essence."',
    'Survival singularity achieved. The wilderness is your eternal self.',
    'Have you achieved survival singularity?',
    'You have completed the survival singularity trial.',
    'Return to the Rangers'' Pact Representative.',
    5000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10188);

-- Q10189: Pact Transcendence
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10190,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 6000,
    `RewardItemId1` = 101058, -- Advanced Ranger's Totem
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Complete the ultimate survival transcendence trial',
    `Title` = 'Pact Transcendence',
    `Objectives` = 'Demonstrate ultimate mastery of survival forces by transcending traditional natural limitations.',
    `Details` = '"You stand at the threshold of survival transcendence. Go beyond mere survival - become nature itself. Your existence will merge with the wild, allowing you to shape ecosystems at will. This is the highest bargain the Rangers'' Pact offers."',
    `OfferRewardText` = 'You have transcended survival. You are the wild, the beasts, the elements of worlds.',
    `RequestItemsText` = 'Are you ready for survival transcendence?',
    `EndText` = 'You have achieved Pact transcendence.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 6000,
    `Flags` = 0
WHERE `entry` = 10189;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10189, 0, 1, 1, 10190, 6000, 101058, 1, 'Complete the ultimate survival transcendence trial',
    'Pact Transcendence',
    'Demonstrate ultimate mastery of survival forces by transcending traditional natural limitations.',
    '"You stand at the threshold of survival transcendence. Go beyond mere survival - become nature itself. Your existence will merge with the wild, allowing you to shape ecosystems at will. This is the highest bargain the Rangers'' Pact offers."',
    'You have transcended survival. You are the wild, the beasts, the elements of worlds.',
    'Are you ready for survival transcendence?',
    'You have achieved Pact transcendence.',
    'Return to the Rangers'' Pact Representative.',
    6000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10189);

-- Q10190: Wild Sanctum Mastery
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 10000,
    `RewardItemId1` = 101059, -- Wild Sanctum Key
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Master the Wild Sanctum',
    `Title` = 'Wild Sanctum Mastery',
    `Objectives` = 'Complete your mastery of the Rangers'' Pact by unlocking the deepest secrets of the Wild Sanctum.',
    `Details` = '"The Wild Sanctum holds the ultimate secrets of survival and nature. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate life itself through survival transcendence."',
    `OfferRewardText` = 'The Wild Sanctum is yours. Natural reality bends to your transcendent command.',
    `RequestItemsText` = 'Claim your sanctum mastery.',
    `EndText` = 'You have mastered the Wild Sanctum.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 10000,
    `Flags` = 0
WHERE `entry` = 10190;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10190, 0, 1, 1, 10191, 10000, 101059, 1, 'Master the Wild Sanctum',
    'Wild Sanctum Mastery',
    'Complete your mastery of the Rangers'' Pact by unlocking the deepest secrets of the Wild Sanctum.',
    '"The Wild Sanctum holds the ultimate secrets of survival and nature. With your transcendence complete, you may now access its deepest chambers. There you will learn to manipulate life itself through survival transcendence."',
    'The Wild Sanctum is yours. Natural reality bends to your transcendent command.',
    'Claim your sanctum mastery.',
    'You have mastered the Wild Sanctum.',
    'Return to the Rangers'' Pact Representative.',
    10000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10190);

-- Q10191: Pact Ascension II
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardMoney` = 15000,
    `ObjectiveText1` = 'Achieve final ascension in the Rangers'' Pact',
    `Title` = 'Pact Ascension II',
    `Objectives` = 'Complete your final ascension within the Rangers'' Pact, gaining ultimate survival enlightenment.',
    `Details` = '"Your journey with the Rangers'' Pact reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate survival enlightenment. Nature, life, and the wilderness itself will be yours to command eternally."',
    `OfferRewardText` = 'You have achieved ultimate ascension. The Rangers'' Pact recognizes you as its equal.',
    `RequestItemsText` = 'Embrace your final ascension.',
    `EndText` = 'You have completed Pact Ascension II.',
    `CompletedText` = 'Return to the Rangers'' Pact Representative.',
    `RewOrReqMoney` = 15000,
    `Flags` = 0
WHERE `entry` = 10191;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10191, 0, 1, 1, 0, 15000, 'Achieve final ascension in the Rangers'' Pact',
    'Pact Ascension II',
    'Complete your final ascension within the Rangers'' Pact, gaining ultimate survival enlightenment.',
    '"Your journey with the Rangers'' Pact reaches its pinnacle. Through the sanctum''s teachings, you will achieve ultimate survival enlightenment. Nature, life, and the wilderness itself will be yours to command eternally."',
    'You have achieved ultimate ascension. The Rangers'' Pact recognizes you as its equal.',
    'Embrace your final ascension.',
    'You have completed Pact Ascension II.',
    'Return to the Rangers'' Pact Representative.',
    15000, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10191);

-- ==================================================
-- QUEST REGISTRATION
-- ==================================================

INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10150, 'ACT3_FOUR_BARGINS', 'SHARED', 'Act III - The Four Bargains (Shared Setup)'),
(10151, 'ACT3_FOUR_BARGINS', 'SHARED', 'Act III - Bargain Prerequisites (Shared Setup)'),
(10152, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Derivatives Mastery'),
(10153, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Futures Empire'),
(10154, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Corporate Takeover'),
(10155, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Economic Intelligence Network'),
(10156, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Quantitative Trading Algorithm'),
(10157, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Global Economic Manipulation'),
(10158, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Economic Singularity'),
(10159, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Iron Ledger Transcendence'),
(10160, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Economic Sanctum Mastery'),
(10161, 'ACT3_FOUR_BARGINS', 'IRON_LEDGER', 'Act III - Iron Ledger Ascension II'),
(10162, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Reality Weaving'),
(10163, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Soul Binding Mastery'),
(10164, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Ether Storm Conduction'),
(10165, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Dimensional Anchoring'),
(10166, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Ether Prophecy Mastery'),
(10167, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Reality Reconstruction'),
(10168, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Ether Singularity'),
(10169, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Shrine Transcendence'),
(10170, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Ether Sanctum Mastery'),
(10171, 'ACT3_FOUR_BARGINS', 'ORDER_SHRINE', 'Act III - Shrine Ascension II'),
(10172, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Grand Heist Mastery'),
(10173, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Underworld Empire'),
(10174, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Smuggling Networks'),
(10175, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Assassination Contracts'),
(10176, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Criminal Intelligence Network'),
(10177, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Money Laundering Empire'),
(10178, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Criminal Singularity'),
(10179, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Cartel Transcendence'),
(10180, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Shadow Sanctum Mastery'),
(10181, 'ACT3_FOUR_BARGINS', 'BLACK_SUN_CARTEL', 'Act III - Cartel Ascension II'),
(10182, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Wilderness Mastery'),
(10183, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Beast Taming'),
(10184, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Ancient Lore Mastery'),
(10185, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Guardian Spirit Bonding'),
(10186, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Elemental Harmony'),
(10187, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Nature''s Wrath'),
(10188, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Survival Singularity'),
(10189, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Pact Transcendence'),
(10190, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Wild Sanctum Mastery'),
(10191, 'ACT3_FOUR_BARGINS', 'RANGERS_PACT', 'Act III - Pact Ascension II')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `faction_tag` = VALUES(`faction_tag`),
    `notes` = VALUES(`notes`);

-- ==================================================
-- SUMMARY
-- ==================================================

SELECT
    'Act III Four Bargains Implementation Complete' as status,
    COUNT(*) as total_quests_created,
    'Shared Setup: 10150-10151 (2 quests)' as shared_setup_range,
    'Iron Ledger: 10152-10161 (10 quests)' as iron_ledger_range,
    'Order of the Shrine: 10162-10171 (10 quests)' as order_shrine_range,
    'Black Sun Cartel: 10172-10181 (10 quests)' as black_sun_cartel_range,
    'Rangers'' Pact: 10182-10191 (10 quests)' as rangers_pact_range,
    'Advanced trials unlock transcendent mechanics and sanctum access' as advanced_mechanics
FROM quest_template
WHERE entry BETWEEN 10150 AND 10191;