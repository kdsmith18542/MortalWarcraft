
-- ==================================================
-- Project Mortal Warcraft
-- Feature: Prologue & Act I Quest Pack
-- Description: Quest templates for Shipwreck Cove survival basics (10000-10014)
--              and Port Meridian economy/contracts quests (10015-10029)
-- Based on: spec 68
-- ==================================================

-- ==================================================
-- SHIPWRECK COVE SURVIVAL BASICS (10000-10014)
-- ==================================================

-- Q10000: Waking on the Beach
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10001,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 10,
    `RequiredNpcOrGo1` = 100000, -- Shipwreck Survivor
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Shipwreck Survivor',
    `Title` = 'Waking on the Beach',
    `Objectives` = 'You''ve washed up on a strange shore. Find the other survivors and learn what happened to your ship.',
    `Details` = 'Your head pounds as you struggle to your feet. Wreckage litters the beach, and the sky has an unnatural purple hue. A weathered survivor approaches you, their eyes filled with a mix of relief and fear.',
    `OfferRewardText` = 'Good, you''re alive. That''s more than I can say for most of the crew. The Fracture took them - rips in reality that spew out monsters.',
    `RequestItemsText` = 'Please, help us understand what happened.',
    `EndText` = 'You have met the Shipwreck Survivor.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 10,
    `Flags` = 0,
    `SpecialFlags` = 0
WHERE `entry` = 10000;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10000, 0, 1, 1, 10001, 0, 10, 100000, 'Speak with the Shipwreck Survivor',
    'Waking on the Beach',
    'You''ve washed up on a strange shore. Find the other survivors and learn what happened to your ship.',
    'Your head pounds as you struggle to your feet. Wreckage litters the beach, and the sky has an unnatural purple hue. A weathered survivor approaches you, their eyes filled with a mix of relief and fear.',
    'Good, you''re alive. That''s more than I can say for most of the crew. The Fracture took them - rips in reality that spew out monsters.',
    'Please, help us understand what happened.',
    'You have met the Shipwreck Survivor.',
    'Return to the Shipwreck Survivor.',
    10, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10000);

-- Q10001: First Loot
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10002,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 15,
    `RequiredItemId1` = 100001, -- Salvaged Supplies
    `RequiredItemCount1` = 1,
    `ObjectiveText1` = 'Loot supplies from the shipwreck debris',
    `Title` = 'First Loot',
    `Objectives` = 'Search the wreckage on the beach for any usable supplies. Right-click on containers to loot them.',
    `Details` = '"We need supplies to survive. Look through that wreckage over there. Right-click on crates and barrels to loot them - that''s how you get items in this world. Bring back anything useful."',
    `OfferRewardText` = 'Good work. Looting is essential for survival. Remember: right-click containers, check corpses after combat.',
    `RequestItemsText` = 'Have you found any supplies in the wreckage?',
    `EndText` = 'You have learned basic looting.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 15,
    `Flags` = 0
WHERE `entry` = 10001;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10001, 2, 1, 1, 10002, 0, 15, 100001, 1, 'Loot supplies from the shipwreck debris',
    'First Loot',
    'Search the wreckage on the beach for any usable supplies. Right-click on containers to loot them.',
    '"We need supplies to survive. Look through that wreckage over there. Right-click on crates and barrels to loot them - that''s how you get items in this world. Bring back anything useful."',
    'Good work. Looting is essential for survival. Remember: right-click containers, check corpses after combat.',
    'Have you found any supplies in the wreckage?',
    'You have learned basic looting.',
    'Return to the Shipwreck Survivor.',
    15, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10001);

-- Q10002: Basic Combat
UPDATE `quest_template` SET
    `QuestType` = 1,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10003,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 20,
    `RequiredNpcOrGo1` = 100002, -- Fractured Crab
    `RequiredNpcOrGoCount1` = 3,
    `ObjectiveText1` = 'Kill 3 Fractured Crabs',
    `Title` = 'Basic Combat',
    `Objectives` = 'Kill 3 of the strange crabs that have appeared on the beach. Right-click their corpses to loot them.',
    `Details` = '"Those crabs weren''t here before the Fracture. They''re aggressive now. Kill 3 of them and loot their corpses. Combat is simple: target with right-click, attack with your basic attack. Watch your health!"',
    `OfferRewardText` = 'Well fought. Combat is about positioning and timing. Always loot corpses - they often have useful materials.',
    `RequestItemsText` = 'Have you dealt with those crabs?',
    `EndText` = 'You have learned basic combat.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 20,
    `Flags` = 0
WHERE `entry` = 10002;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10002, 1, 1, 1, 10003, 0, 20, 100002, 3, 'Kill 3 Fractured Crabs',
    'Basic Combat',
    'Kill 3 of the strange crabs that have appeared on the beach. Right-click their corpses to loot them.',
    '"Those crabs weren''t here before the Fracture. They''re aggressive now. Kill 3 of them and loot their corpses. Combat is simple: target with right-click, attack with your basic attack. Watch your health!"',
    'Well fought. Combat is about positioning and timing. Always loot corpses - they often have useful materials.',
    'Have you dealt with those crabs?',
    'You have learned basic combat.',
    'Return to the Shipwreck Survivor.',
    20, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10002);

-- Q10003: Weapon Basics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10004,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 25,
    `RewardItemId1` = 100003, -- Makeshift Club
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Equip the club and test it on a training post',
    `Title` = 'Weapon Basics',
    `Objectives` = 'Take the club from the survivor and equip it. Then attack the training post nearby to practice.',
    `Details` = '"Here, take this club. Right-click it in your inventory to equip it. Then go attack that training post over there. Weapons make combat much easier - always equip the best gear you can find."',
    `OfferRewardText` = 'Good. You understand equipping weapons. Better gear means better survival. Keep upgrading as you progress.',
    `RequestItemsText` = 'Have you equipped the club and tested it?',
    `EndText` = 'You have learned about weapons.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 25,
    `Flags` = 0
WHERE `entry` = 10003;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10003, 0, 1, 1, 10004, 0, 25, 100003, 1, 'Equip the club and test it on a training post',
    'Weapon Basics',
    'Take the club from the survivor and equip it. Then attack the training post nearby to practice.',
    '"Here, take this club. Right-click it in your inventory to equip it. Then go attack that training post over there. Weapons make combat much easier - always equip the best gear you can find."',
    'Good. You understand equipping weapons. Better gear means better survival. Keep upgrading as you progress.',
    'Have you equipped the club and tested it?',
    'You have learned about weapons.',
    'Return to the Shipwreck Survivor.',
    25, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10003);

-- Q10004: Gathering Materials
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10005,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 30,
    `RequiredItemId1` = 100004, -- Driftwood
    `RequiredItemCount1` = 5,
    `RequiredItemId2` = 100005, -- Beach Stones
    `RequiredItemCount2` = 3,
    `ObjectiveText1` = 'Gather 5 Driftwood and 3 Beach Stones',
    `Title` = 'Gathering Materials',
    `Objectives` = 'Collect driftwood from the beach and stones from the rocks. Right-click on nodes to gather materials.',
    `Details` = '"We can''t rely on scavenging forever. Gather some driftwood from the beach - look for the glowing nodes. And pick up some stones from those rocks over there. Materials are everywhere if you look."',
    `OfferRewardText` = 'Excellent gathering. Materials are the foundation of everything - weapons, tools, even shelter. Always be on the lookout.',
    `RequestItemsText` = 'Have you gathered the materials?',
    `EndText` = 'You have learned basic gathering.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 30,
    `Flags` = 0
WHERE `entry` = 10004;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `RequiredItemId2`,
    `RequiredItemCount2`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10004, 2, 1, 1, 10005, 0, 30, 100004, 5, 100005, 3, 'Gather 5 Driftwood and 3 Beach Stones',
    'Gathering Materials',
    'Collect driftwood from the beach and stones from the rocks. Right-click on nodes to gather materials.',
    '"We can''t rely on scavenging forever. Gather some driftwood from the beach - look for the glowing nodes. And pick up some stones from those rocks over there. Materials are everywhere if you look."',
    'Excellent gathering. Materials are the foundation of everything - weapons, tools, even shelter. Always be on the lookout.',
    'Have you gathered the materials?',
    'You have learned basic gathering.',
    'Return to the Shipwreck Survivor.',
    30, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10004);

-- Q10005: Simple Crafting
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10006,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 35,
    `RewardItemId1` = 100006, -- Stone Knife
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Craft a Stone Knife at the crafting station',
    `Title` = 'Simple Crafting',
    `Objectives` = 'Use the materials you gathered to craft a stone knife at the nearby crafting station.',
    `Details` = '"Now let''s make something useful. Take those materials to the crafting station over there. Right-click it and select ''Stone Knife'' from the crafting menu. Crafting turns raw materials into useful items."',
    `OfferRewardText` = 'Well crafted! Crafting is how you turn basic materials into powerful gear. Practice often to improve your skills.',
    `RequestItemsText` = 'Have you crafted the stone knife?',
    `EndText` = 'You have learned basic crafting.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 35,
    `Flags` = 0
WHERE `entry` = 10005;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10005, 0, 1, 1, 10006, 0, 35, 100006, 1, 'Craft a Stone Knife at the crafting station',
    'Simple Crafting',
    'Use the materials you gathered to craft a stone knife at the nearby crafting station.',
    '"Now let''s make something useful. Take those materials to the crafting station over there. Right-click it and select ''Stone Knife'' from the crafting menu. Crafting turns raw materials into useful gear."',
    'Well crafted! Crafting is how you turn basic materials into powerful gear. Practice often to improve your skills.',
    'Have you crafted the stone knife?',
    'You have learned basic crafting.',
    'Return to the Shipwreck Survivor.',
    35, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10005);

-- Q10006: Combat Training
UPDATE `quest_template` SET
    `QuestType` = 1,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10007,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 40,
    `RequiredNpcOrGo1` = 100007, -- Training Dummy
    `RequiredNpcOrGoCount1` = 5,
    `ObjectiveText1` = 'Destroy 5 Training Dummies',
    `Title` = 'Combat Training',
    `Objectives` = 'Use your new stone knife to destroy 5 training dummies. Practice different combat techniques.',
    `Details` = '"Time to hone your skills. Those training dummies over there are perfect for practice. Use your stone knife and try different attack patterns. Combat is about timing and positioning."',
    `OfferRewardText` = 'Good training session. You''re getting better. Remember: positioning is key, and always finish fights quickly.',
    `RequestItemsText` = 'Have you completed your training?',
    `EndText` = 'You have completed combat training.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 40,
    `Flags` = 0
WHERE `entry` = 10006;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10006, 1, 1, 1, 10007, 0, 40, 100007, 5, 'Destroy 5 Training Dummies',
    'Combat Training',
    'Use your new stone knife to destroy 5 training dummies. Practice different combat techniques.',
    '"Time to hone your skills. Those training dummies over there are perfect for practice. Use your stone knife and try different attack patterns. Combat is about timing and positioning."',
    'Good training session. You''re getting better. Remember: positioning is key, and always finish fights quickly.',
    'Have you completed your training?',
    'You have completed combat training.',
    'Return to the Shipwreck Survivor.',
    40, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10006);

-- Q10007: Looting Practice
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10008,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 45,
    `RequiredItemId1` = 100008, -- Crab Shell
    `RequiredItemCount1` = 3,
    `RequiredItemId2` = 100009, -- Fractured Crystal
    `RequiredItemCount2` = 2,
    `ObjectiveText1` = 'Loot 3 Crab Shells and 2 Fractured Crystals from enemies',
    `Title` = 'Looting Practice',
    `Objectives` = 'Kill more crabs and loot their shells and any crystals they drop. Check all corpses carefully.',
    `Details` = '"Let''s practice looting properly. Kill some more of those crabs and loot everything they drop - shells, crystals, anything. Some items are rare, so check every corpse. Loot everything!"',
    `OfferRewardText` = 'Excellent looting. You found some valuable crystals too. Always check corpses - rare materials make the best gear.',
    `RequestItemsText` = 'Have you collected the shells and crystals?',
    `EndText` = 'You have mastered looting.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 45,
    `Flags` = 0
WHERE `entry` = 10007;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `RequiredItemId2`,
    `RequiredItemCount2`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10007, 2, 1, 1, 10008, 0, 45, 100008, 3, 100009, 2, 'Loot 3 Crab Shells and 2 Fractured Crystals from enemies',
    'Looting Practice',
    'Kill more crabs and loot their shells and any crystals they drop. Check all corpses carefully.',
    '"Let''s practice looting properly. Kill some more of those crabs and loot everything they drop - shells, crystals, anything. Some items are rare, so check every corpse. Loot everything!"',
    'Excellent looting. You found some valuable crystals too. Always check corpses - rare materials make the best gear.',
    'Have you collected the shells and crystals?',
    'You have mastered looting.',
    'Return to the Shipwreck Survivor.',
    45, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10007);

-- Q10008: Inventory Management
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10009,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 50,
    `RewardItemId1` = 100010, -- Small Backpack
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Organize your inventory and use the backpack',
    `Title` = 'Inventory Management',
    `Objectives` = 'Sort your items by type, combine stacks, and equip the backpack to increase your carrying capacity.',
    `Details` = '"You''re carrying too much junk. Open your inventory (B key) and organize it. Stack similar items together, and here''s a backpack to carry more. Inventory management is crucial for survival."',
    `OfferRewardText` = 'Much better. Keep your inventory organized - you never know when you''ll need space for important loot.',
    `RequestItemsText` = 'Have you organized your inventory?',
    `EndText` = 'You have learned inventory management.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 50,
    `Flags` = 0
WHERE `entry` = 10008;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10008, 0, 1, 1, 10009, 0, 50, 100010, 1, 'Organize your inventory and use the backpack',
    'Inventory Management',
    'Sort your items by type, combine stacks, and equip the backpack to increase your carrying capacity.',
    '"You''re carrying too much junk. Open your inventory (B key) and organize it. Stack similar items together, and here''s a backpack to carry more. Inventory management is crucial for survival."',
    'Much better. Keep your inventory organized - you never know when you''ll need space for important loot.',
    'Have you organized your inventory?',
    'You have learned inventory management.',
    'Return to the Shipwreck Survivor.',
    50, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10008);

-- Q10009: Basic Survival
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10010,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 55,
    `ObjectiveText1` = 'Build and light a campfire for cooking and warmth',
    `Title` = 'Basic Survival',
    `Objectives` = 'Use your gathered materials to build a campfire. Light it and cook some food if you have any.',
    `Details` = '"Let''s build a proper camp. Use that driftwood and stones to make a campfire over there. Right-click the campfire spot and select ''Build Campfire''. It''ll provide warmth and let you cook food."',
    `OfferRewardText` = 'Good camp. Fire provides safety from the Fracture''s cold and lets you cook food for bonuses. Always have a base camp.',
    `RequestItemsText` = 'Have you built the campfire?',
    `EndText` = 'You have learned basic survival skills.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 55,
    `Flags` = 0
WHERE `entry` = 10009;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`,
    `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10009, 0, 1, 1, 10010, 0, 55, 'Build and light a campfire for cooking and warmth',
    'Basic Survival',
    'Use your gathered materials to build a campfire. Light it and cook some food if you have any.',
    '"Let''s build a proper camp. Use that driftwood and stones to make a campfire over there. Right-click the campfire spot and select ''Build Campfire''. It''ll provide warmth and let you cook food."',
    'Good camp. Fire provides safety from the Fracture''s cold and lets you cook food for bonuses. Always have a base camp.',
    'Have you built the campfire?',
    'You have learned basic survival skills.',
    'Return to the Shipwreck Survivor.',
    55, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10009);

-- Q10010: Rift Introduction
UPDATE `quest_template` SET
    `QuestType` = 1,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10011,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 60,
    `RequiredNpcOrGo1` = 100011, -- Void Spawn
    `RequiredNpcOrGoCount1` = 4,
    `RequiredNpcOrGo2` = 100012, -- Rift Crystal (gameobject)
    `RequiredNpcOrGoCount2` = 1,
    `ObjectiveText1` = 'Kill 4 Void Spawns and destroy the Rift Crystal',
    `Title` = 'Rift Introduction',
    `Objectives` = 'A small Rift has opened nearby. Kill the Void Spawns it released and destroy the Rift Crystal to close it.',
    `Details` = '"Look! A Rift just opened. Those purple tears in reality spawn monsters. Kill the Void Spawns and smash that glowing crystal to close it. Rifts are dangerous - deal with them quickly."',
    `OfferRewardText` = 'Well done. Rifts appear randomly and spawn enemies. Close them fast before they overwhelm the area.',
    `RequestItemsText` = 'Have you closed the Rift?',
    `EndText` = 'You have learned about Rifts.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 60,
    `Flags` = 0
WHERE `entry` = 10010;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10010, 1, 1, 1, 10011, 0, 60, 100011, 4, 100012, 1, 'Kill 4 Void Spawns and destroy the Rift Crystal',
    'Rift Introduction',
    'A small Rift has opened nearby. Kill the Void Spawns it released and destroy the Rift Crystal to close it.',
    '"Look! A Rift just opened. Those purple tears in reality spawn monsters. Kill the Void Spawns and smash that glowing crystal to close it. Rifts are dangerous - deal with them quickly."',
    'Well done. Rifts appear randomly and spawn enemies. Close them fast before they overwhelm the area.',
    'Have you closed the Rift?',
    'You have learned about Rifts.',
    'Return to the Shipwreck Survivor.',
    60, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10010);

-- Q10011: Shrine Basics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10012,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 65,
    `RequiredNpcOrGo1` = 100013, -- Cove Shrine Keeper
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Shrine Keeper about resurrection',
    `Title` = 'Shrine Basics',
    `Objectives` = 'Visit the small shrine nearby and speak with the Shrine Keeper. Learn about death and resurrection.',
    `Details` = '"You need to understand what happens when you die. Visit that shrine over there and talk to the keeper. Death isn''t the end here, but it has consequences. Listen carefully."',
    `OfferRewardText` = 'You understand now. When you die, the Shrine pulls you back to life - but your gear stays where you fell. Retrieve it quickly!',
    `RequestItemsText` = 'Have you spoken with the Shrine Keeper?',
    `EndText` = 'You have learned about resurrection.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 65,
    `Flags` = 0
WHERE `entry` = 10011;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10011, 0, 1, 1, 10012, 0, 65, 100013, 'Speak with the Shrine Keeper about resurrection',
    'Shrine Basics',
    'Visit the small shrine nearby and speak with the Shrine Keeper. Learn about death and resurrection.',
    '"You need to understand what happens when you die. Visit that shrine over there and talk to the keeper. Death isn''t the end here, but it has consequences. Listen carefully."',
    'You understand now. When you die, the Shrine pulls you back to life - but your gear stays where you fell. Retrieve it quickly!',
    'Have you spoken with the Shrine Keeper?',
    'You have learned about resurrection.',
    'Return to the Shipwreck Survivor.',
    65, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10011);

-- Q10012: Final Survival Test
UPDATE `quest_template` SET
    `QuestType` = 1,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10013,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 70,
    `RequiredNpcOrGo1` = 100014, -- Survival Test Mob
    `RequiredNpcOrGoCount1` = 8,
    `ObjectiveText1` = 'Survive and defeat 8 attacking enemies',
    `Title` = 'Final Survival Test',
    `Objectives` = 'A group of enemies is attacking the camp. Defend yourself and defeat all 8 attackers.',
    `Details` = '"This is your final test. A group of Fracture creatures is attacking. Survive and defeat them all. Use everything you''ve learned - positioning, looting, your gear. Show me you can survive!"',
    `OfferRewardText` = 'Impressive survival. You''ve learned the basics well. You''re ready for the wider world now.',
    `RequestItemsText` = 'Have you survived the attack?',
    `EndText` = 'You have passed the survival test.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 70,
    `Flags` = 0
WHERE `entry` = 10012;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10012, 1, 1, 1, 10013, 0, 70, 100014, 8, 'Survive and defeat 8 attacking enemies',
    'Final Survival Test',
    'A group of enemies is attacking the camp. Defend yourself and defeat all 8 attackers.',
    '"This is your final test. A group of Fracture creatures is attacking. Survive and defeat them all. Use everything you''ve learned - positioning, looting, your gear. Show me you can survive!"',
    'Impressive survival. You''ve learned the basics well. You''re ready for the wider world now.',
    'Have you survived the attack?',
    'You have passed the survival test.',
    'Return to the Shipwreck Survivor.',
    70, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10012);

-- Q10013: Prepare to Leave
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10014,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 75,
    `RequiredItemId1` = 100015, -- Survival Rations
    `RequiredItemCount1` = 5,
    `RequiredItemId2` = 100016, -- Travel Supplies
    `RequiredItemCount2` = 1,
    `ObjectiveText1` = 'Gather 5 Survival Rations and 1 set of Travel Supplies',
    `Title` = 'Prepare to Leave',
    `Objectives` = 'Gather food and supplies for your journey to Port Meridian. Cook rations at the campfire if needed.',
    `Details` = '"We can''t stay here forever. Gather some food and supplies for the journey inland. Cook those rations at the campfire for better effects. Port Meridian awaits - it''s the first real city in this broken world."',
    `OfferRewardText` = 'Good preparations. The journey inland is dangerous, but necessary. Stay alert and loot everything.',
    `RequestItemsText` = 'Have you gathered the supplies?',
    `EndText` = 'You are prepared for the journey.',
    `CompletedText` = 'Return to the Shipwreck Survivor.',
    `RewOrReqMoney` = 75,
    `Flags` = 0
WHERE `entry` = 10013;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `RequiredItemId2`,
    `RequiredItemCount2`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10013, 2, 1, 1, 10014, 0, 75, 100015, 5, 100016, 1, 'Gather 5 Survival Rations and 1 set of Travel Supplies',
    'Prepare to Leave',
    'Gather food and supplies for your journey to Port Meridian. Cook rations at the campfire if needed.',
    '"We can''t stay here forever. Gather some food and supplies for the journey inland. Cook those rations at the campfire for better effects. Port Meridian awaits - it''s the first real city in this broken world."',
    'Good preparations. The journey inland is dangerous, but necessary. Stay alert and loot everything.',
    'Have you gathered the supplies?',
    'You are prepared for the journey.',
    'Return to the Shipwreck Survivor.',
    75, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10013);

-- Q10014: Journey to Port Meridian
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10015,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `RewardItemId1` = 100017, -- Cove Survivor Token
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Travel to Port Meridian and speak with the Harbor Master',
    `Title` = 'Journey to Port Meridian',
    `Objectives` = 'Follow the path inland to Port Meridian. Speak with the Harbor Master when you arrive.',
    `Details` = '"It''s time. Follow this path inland to Port Meridian. It''s a trading hub where survivors gather. Speak with the Harbor Master when you arrive - he''ll get you settled. Good luck, and remember what you''ve learned."',
    `OfferRewardText` = 'Welcome to Port Meridian, survivor. You''ve made it through the wilderness. Now learn about civilization in this broken world.',
    `RequestItemsText` = 'Safe travels.',
    `EndText` = 'You have arrived in Port Meridian.',
    `CompletedText` = 'Speak with the Harbor Master.',
    `RewOrReqMoney` = 100,
    `Flags` = 0
WHERE `entry` = 10014;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10014, 0, 1, 1, 10015, 0, 100, 100017, 1, 'Travel to Port Meridian and speak with the Harbor Master',
    'Journey to Port Meridian',
    'Follow the path inland to Port Meridian. Speak with the Harbor Master when you arrive.',
    '"It''s time. Follow this path inland to Port Meridian. It''s a trading hub where survivors gather. Speak with the Harbor Master when you arrive - he''ll get you settled. Good luck, and remember what you''ve learned."',
    'Welcome to Port Meridian, survivor. You''ve made it through the wilderness. Now learn about civilization in this broken world.',
    'Safe travels.',
    'You have arrived in Port Meridian.',
    'Speak with the Harbor Master.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10014);

-- ==================================================
-- PORT MERIDIAN ECONOMY QUESTS (10015-10029)
-- ==================================================

-- Q10015: Arrival in Port Meridian
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10016,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 50,
    `RequiredNpcOrGo1` = 100018, -- Harbor Master
    `RequiredNpcOrGoCount1` = 0,
    `RequiredNpcOrGo2` = 100019, -- Task Board (gameobject)
    `RequiredNpcOrGoCount2` = 1,
    `ObjectiveText1` = 'Speak with the Harbor Master and examine the Task Board',
    `Title` = 'Arrival in Port Meridian',
    `Objectives` = 'Get oriented in Port Meridian. Speak with the Harbor Master and examine the Task Board.',
    `Details` = 'The Harbor Master welcomes you to Port Meridian. "Welcome, survivor. This city runs on contracts and commerce. Let me show you around. First, check that Task Board over there - it''s where work gets done."',
    `OfferRewardText` = 'Good. You''ve seen the Task Board. That''s where you''ll find contracts - paid work that drives our economy.',
    `RequestItemsText` = 'Have you examined the Task Board?',
    `EndText` = 'You have arrived in Port Meridian.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 50,
    `Flags` = 0
WHERE `entry` = 10015;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`,
    `RequiredNpcOrGo2`, `RequiredNpcOrGoCount2`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10015, 0, 1, 1, 10016, 0, 50, 100018, 0, 100019, 1, 'Speak with the Harbor Master and examine the Task Board',
    'Arrival in Port Meridian',
    'Get oriented in Port Meridian. Speak with the Harbor Master and examine the Task Board.',
    'The Harbor Master welcomes you to Port Meridian. "Welcome, survivor. This city runs on contracts and commerce. Let me show you around. First, check that Task Board over there - it''s where work gets done."',
    'Good. You''ve seen the Task Board. That''s where you''ll find contracts - paid work that drives our economy.',
    'Have you examined the Task Board?',
    'You have arrived in Port Meridian.',
    'Return to the Harbor Master.',
    50, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10015);

-- Q10016: Contract Basics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10017,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 75,
    `ObjectiveText1` = 'Read about contract types on the Task Board',
    `Title` = 'Contract Basics',
    `Objectives` = 'Study the different types of contracts available on the Task Board. Learn about gathering, combat, and delivery contracts.',
    `Details` = '"Contracts are the lifeblood of Port Meridian. Right-click the Task Board and read about the different types. Gathering contracts pay for materials, combat contracts for clearing threats, delivery contracts for transport. Each has different risks and rewards."',
    `OfferRewardText` = 'You understand contracts now. Choose wisely - high risk means high reward, but also high danger.',
    `RequestItemsText` = 'Have you read about contract types?',
    `EndText` = 'You have learned about contracts.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 75,
    `Flags` = 0
WHERE `entry` = 10016;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`,
    `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10016, 0, 1, 1, 10017, 0, 75, 'Read about contract types on the Task Board',
    'Contract Basics',
    'Study the different types of contracts available on the Task Board. Learn about gathering, combat, and delivery contracts.',
    '"Contracts are the lifeblood of Port Meridian. Right-click the Task Board and read about the different types. Gathering contracts pay for materials, combat contracts for clearing threats, delivery contracts for transport. Each has different risks and rewards."',
    'You understand contracts now. Choose wisely - high risk means high reward, but also high danger.',
    'Have you read about contract types?',
    'You have learned about contracts.',
    'Return to the Harbor Master.',
    75, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10016);

-- Q10017: First Contract
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10018,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 100,
    `RequiredNpcOrGo1` = 100020, -- Contract Completion NPC
    `RequiredNpcOrGoCount1` = 1,
    `ObjectiveText1` = 'Accept and complete your first contract from the Task Board',
    `Title` = 'First Contract',
    `Objectives` = 'Accept a simple gathering or delivery contract from the Task Board and complete it successfully.',
    `Details` = '"Time to try it yourself. Go to the Task Board, accept a simple contract - maybe gathering herbs or delivering a package. Complete it and return here. This is how you earn gold and materials in Port Meridian."',
    `OfferRewardText` = 'Excellent work! You''ve completed your first contract. Notice how you earned both gold and materials?',
    `RequestItemsText` = 'Have you completed a contract?',
    `EndText` = 'You have completed your first contract.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 100,
    `Flags` = 0
WHERE `entry` = 10017;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `RequiredNpcOrGoCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10017, 0, 1, 1, 10018, 0, 100, 100020, 1, 'Accept and complete your first contract from the Task Board',
    'First Contract',
    'Accept a simple gathering or delivery contract from the Task Board and complete it successfully.',
    '"Time to try it yourself. Go to the Task Board, accept a simple contract - maybe gathering herbs or delivering a package. Complete it and return here. This is how you earn gold and materials in Port Meridian."',
    'Excellent work! You''ve completed your first contract. Notice how you earned both gold and materials?',
    'Have you completed a contract?',
    'You have completed your first contract.',
    'Return to the Harbor Master.',
    100, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10017);

-- Q10018: Contract Rewards
UPDATE `quest_template` SET
    `QuestType` = 2,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10019,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 125,
    `RequiredItemId1` = 100021, -- Contract Payout Receipt
    `RequiredItemCount1` = 1,
    `ObjectiveText1` = 'Turn in your contract and examine the rewards',
    `Title` = 'Contract Rewards',
    `Objectives` = 'Return to the Task Board and turn in your completed contract. Examine both the gold and material rewards.',
    `Details` = '"Now let''s look at what you earned. Go back to the Task Board and turn in your contract. You should receive both gold coins and crafting materials. In this world, materials are just as valuable as gold - they make better gear."',
    `OfferRewardText` = 'See? Contracts give you both currency and materials. Use the materials to craft better gear, spend the gold on supplies.',
    `RequestItemsText` = 'Have you turned in your contract?',
    `EndText` = 'You have learned about contract rewards.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 125,
    `Flags` = 0
WHERE `entry` = 10018;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredItemId1`, `RequiredItemCount1`, `ObjectiveText1`,
    `Title`, `Objectives`, `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`,
    `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10018, 2, 1, 1, 10019, 0, 125, 100021, 1, 'Turn in your contract and examine the rewards',
    'Contract Rewards',
    'Return to the Task Board and turn in your completed contract. Examine both the gold and material rewards.',
    '"Now let''s look at what you earned. Go back to the Task Board and turn in your contract. You should receive both gold coins and crafting materials. In this world, materials are just as valuable as gold - they make better gear."',
    'See? Contracts give you both currency and materials. Use the materials to craft better gear, spend the gold on supplies.',
    'Have you turned in your contract?',
    'You have learned about contract rewards.',
    'Return to the Harbor Master.',
    125, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10018);

-- Q10019: Market Basics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10020,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 150,
    `RequiredNpcOrGo1` = 100022, -- Market Vendor
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Visit the market and learn about buying and selling',
    `Title` = 'Market Basics',
    `Objectives` = 'Visit the market stalls and speak with a vendor. Learn about supply and demand pricing.',
    `Details` = '"The market is where you trade goods. Visit the stalls over there and talk to a vendor. Prices change based on what people need. Buy low when items are plentiful, sell high when they''re scarce. The economy drives everything here."',
    `OfferRewardText` = 'Good. You understand the market now. Watch the prices - they tell you what''s valuable and what''s not.',
    `RequestItemsText` = 'Have you visited the market?',
    `EndText` = 'You have learned market basics.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 150,
    `Flags` = 0
WHERE `entry` = 10019;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10019, 0, 1, 1, 10020, 0, 150, 100022, 'Visit the market and learn about buying and selling',
    'Market Basics',
    'Visit the market stalls and speak with a vendor. Learn about supply and demand pricing.',
    '"The market is where you trade goods. Visit the stalls over there and talk to a vendor. Prices change based on what people need. Buy low when items are plentiful, sell high when they''re scarce. The economy drives everything here."',
    'Good. You understand the market now. Watch the prices - they tell you what''s valuable and what''s not.',
    'Have you visited the market?',
    'You have learned market basics.',
    'Return to the Harbor Master.',
    150, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10019);

-- Q10020: Banking Introduction
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10021,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 175,
    `RequiredNpcOrGo1` = 100023, -- Regional Banker
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Visit the Regional Bank and make your first deposit',
    `Title` = 'Banking Introduction',
    `Objectives` = 'Visit the Regional Bank and deposit at least 10 gold worth of items. Learn about secure storage.',
    `Details` = '"Your wealth needs protection. Visit the Regional Bank and deposit some items. What you store here stays safe, but remember - banking is regional. If you travel to another city, you''ll need to withdraw first or use expensive courier services."',
    `OfferRewardText` = 'Excellent. Your items are secure in the bank. Regional banking keeps your wealth safe, but plan your travels accordingly.',
    `RequestItemsText` = 'Have you made a bank deposit?',
    `EndText` = 'You have learned about banking.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 175,
    `Flags` = 0
WHERE `entry` = 10020;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardXPDifficulty`, `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10020, 0, 1, 1, 10021, 0, 175, 100023, 'Visit the Regional Bank and make your first deposit',
    'Banking Introduction',
    'Visit the Regional Bank and deposit at least 10 gold worth of items. Learn about secure storage.',
    '"Your wealth needs protection. Visit the Regional Bank and deposit some items. What you store here stays safe, but remember - banking is regional. If you travel to another city, you''ll need to withdraw first or use expensive courier services."',
    'Excellent. Your items are secure in the bank. Regional banking keeps your wealth safe, but plan your travels accordingly.',
    'Have you made a bank deposit?',
    'You have learned about banking.',
    'Return to the Harbor Master.',
    175, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10020);

-- Q10021: Regional Banking
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10022,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 200,
    `ObjectiveText1` = 'Learn about regional banking limitations and courier services',
    `Title` = 'Regional Banking',
    `Objectives` = 'Speak with the banker about the limitations of regional banking and learn about courier services.',
    `Details` = '"Banking here is regional - your deposits stay in Port Meridian. If you travel to another city, you can''t access them directly. That''s where courier services come in. They''ll transport your goods between cities for a fee. Plan your wealth management carefully."',
    `OfferRewardText` = 'You understand regional banking now. Courier services let you move wealth between cities, but they''re expensive. Choose wisely.',
    `RequestItemsText` = 'Have you learned about regional banking?',
    `EndText` = 'You have learned about regional banking.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 200,
    `Flags` = 0
WHERE `entry` = 10021;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10021, 0, 1, 1, 10022, 0, 200, 'Learn about regional banking limitations and courier services',
    'Regional Banking',
    'Speak with the banker about the limitations of regional banking and learn about courier services.',
    '"Banking here is regional - your deposits stay in Port Meridian. If you travel to another city, you can''t access them directly. That''s where courier services come in. They''ll transport your goods between cities for a fee. Plan your wealth management carefully."',
    'You understand regional banking now. Courier services let you move wealth between cities, but they''re expensive. Choose wisely.',
    'Have you learned about regional banking?',
    'You have learned about regional banking.',
    'Return to the Harbor Master.',
    200, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10021);

-- Q10022: Courier Services
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10023,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 225,
    `RequiredNpcOrGo1` = 100024, -- Courier Agent
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Courier Agent and arrange a small shipment',
    `Title` = 'Courier Services',
    `Objectives` = 'Visit the Courier Agent and learn about shipping items between cities. Arrange a small test shipment.',
    `Details` = '"For moving goods between cities, we use couriers. Visit the Courier Agent and learn about their services. They charge based on distance, weight, and urgency. Try arranging a small shipment to understand the costs."',
    `OfferRewardText` = 'Good. Couriers make regional banking practical. Use them wisely - their fees add up quickly.',
    `RequestItemsText` = 'Have you spoken with the Courier Agent?',
    `EndText` = 'You have learned about courier services.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 225,
    `Flags` = 0
WHERE `entry` = 10022;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`, `Details`,
    `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10022, 0, 1, 1, 10023, 0, 225, 100024, 'Speak with the Courier Agent and arrange a small shipment',
    'Courier Services',
    'Visit the Courier Agent and learn about shipping items between cities. Arrange a small test shipment.',
    '"For moving goods between cities, we use couriers. Visit the Courier Agent and learn about their services. They charge based on distance, weight, and urgency. Try arranging a small shipment to understand the costs."',
    'Good. Couriers make regional banking practical. Use them wisely - their fees add up quickly.',
    'Have you spoken with the Courier Agent?',
    'You have learned about courier services.',
    'Return to the Harbor Master.',
    225, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10022);

-- Q10023: Contract Types
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10024,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 250,
    `ObjectiveText1` = 'Complete one contract of each major type (gathering, combat, delivery)',
    `Title` = 'Contract Types',
    `Objectives` = 'Complete one gathering contract, one combat contract, and one delivery contract from the Task Board.',
    `Details` = '"Let''s try different contract types. Go to the Task Board and complete one of each: a gathering contract (collect materials), a combat contract (kill enemies), and a delivery contract (transport goods). Each teaches different skills and offers different rewards."',
    `OfferRewardText` = 'Excellent variety! You''ve experienced all the major contract types. Each has its place in the economy.',
    `RequestItemsText` = 'Have you completed all three contract types?',
    `EndText` = 'You have learned about contract types.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 250,
    `Flags` = 0
WHERE `entry` = 10023;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10023, 0, 1, 1, 10024, 0, 250, 'Complete one contract of each major type (gathering, combat, delivery)',
    'Contract Types',
    'Complete one gathering contract, one combat contract, and one delivery contract from the Task Board.',
    '"Let''s try different contract types. Go to the Task Board and complete one of each: a gathering contract (collect materials), a combat contract (kill enemies), and a delivery contract (transport goods). Each teaches different skills and offers different rewards."',
    'Excellent variety! You''ve experienced all the major contract types. Each has its place in the economy.',
    'Have you completed all three contract types?',
    'You have learned about contract types.',
    'Return to the Harbor Master.',
    250, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10023);

-- Q10024: Economy Basics
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10025,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 275,
    `ObjectiveText1` = 'Observe market prices and understand supply/demand',
    `Title` = 'Economy Basics',
    `Objectives` = 'Spend time observing how market prices change. Buy low and sell high to make a profit.',
    `Details` = '"The economy is dynamic. Watch the market stalls - prices change based on what people need. When materials are scarce, prices rise. When abundant, they fall. Try buying low and selling high to make a profit. This is how smart survivors get ahead."',
    `OfferRewardText` = 'You''re learning the economy. Supply and demand drive prices. Time your trades wisely.',
    `RequestItemsText` = 'Have you observed the market dynamics?',
    `EndText` = 'You have learned economy basics.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 275,
    `Flags` = 0
WHERE `entry` = 10024;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10024, 0, 1, 1, 10025, 0, 275, 'Observe market prices and understand supply/demand',
    'Economy Basics',
    'Spend time observing how market prices change. Buy low and sell high to make a profit.',
    '"The economy is dynamic. Watch the market stalls - prices change based on what people need. When materials are scarce, prices rise. When abundant, they fall. Try buying low and selling high to make a profit. This is how smart survivors get ahead."',
    'You''re learning the economy. Supply and demand drive prices. Time your trades wisely.',
    'Have you observed the market dynamics?',
    'You have learned economy basics.',
    'Return to the Harbor Master.',
    275, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10024);

-- Q10025: Trading
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10026,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 300,
    `ObjectiveText1` = 'Make a successful trade at the market for profit',
    `Title` = 'Trading',
    `Objectives` = 'Buy items at a low price and sell them at the market for a profit. Make at least 50 gold profit.',
    `Details` = '"Now try real trading. Buy items when prices are low, then sell them when prices rise. Watch the market carefully - timing is everything. Make at least 50 gold profit to prove you understand trading."',
    `OfferRewardText` = 'Well traded! You''ve made a profit. Trading is a skill that can make you wealthy if you master it.',
    `RequestItemsText` = 'Have you made a profitable trade?',
    `EndText` = 'You have learned trading.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 300,
    `Flags` = 0
WHERE `entry` = 10025;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10025, 0, 1, 1, 10026, 0, 300, 'Make a successful trade at the market for profit',
    'Trading',
    'Buy items at a low price and sell them at the market for a profit. Make at least 50 gold profit.',
    '"Now try real trading. Buy items when prices are low, then sell them when prices rise. Watch the market carefully - timing is everything. Make at least 50 gold profit to prove you understand trading."',
    'Well traded! You''ve made a profit. Trading is a skill that can make you wealthy if you master it.',
    'Have you made a profitable trade?',
    'You have learned trading.',
    'Return to the Harbor Master.',
    300, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10025);

-- Q10026: Specialization
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10027,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 325,
    `RequiredNpcOrGo1` = 100025, -- Trade Master
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with the Trade Master and choose a profession',
    `Title` = 'Specialization',
    `Objectives` = 'Visit the Trade Master and learn about professions. Choose one to specialize in.',
    `Details` = '"To excel, you need focus. Visit the Trade Master and learn about professions. Each offers different skills and opportunities. Choose wisely - your profession will define your path in this world. Specialization leads to mastery."',
    `OfferRewardText` = 'A good choice. Your profession will open new contracts and opportunities. Master it well.',
    `RequestItemsText` = 'Have you chosen a profession?',
    `EndText` = 'You have chosen a profession.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 325,
    `Flags` = 0
WHERE `entry` = 10026;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`, `Details`,
    `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10026, 0, 1, 1, 10027, 0, 325, 100025, 'Speak with the Trade Master and choose a profession',
    'Specialization',
    'Visit the Trade Master and learn about professions. Choose one to specialize in.',
    '"To excel, you need focus. Visit the Trade Master and learn about professions. Each offers different skills and opportunities. Choose wisely - your profession will define your path in this world. Specialization leads to mastery."',
    'A good choice. Your profession will open new contracts and opportunities. Master it well.',
    'Have you chosen a profession?',
    'You have chosen a profession.',
    'Return to the Harbor Master.',
    325, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10026);

-- Q10027: Advanced Contracts
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10028,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 350,
    `ObjectiveText1` = 'Complete a high-risk, high-reward contract',
    `Title` = 'Advanced Contracts',
    `Objectives` = 'Accept and complete a challenging contract from the Task Board. Higher risk means higher reward.',
    `Details` = '"You''re ready for more challenging work. Go to the Task Board and accept a high-risk contract. These pay better but are more dangerous. Use everything you''ve learned - good gear, smart positioning, and quick looting. The rewards are worth the risk."',
    `OfferRewardText` = 'Impressive! You handled the challenge well. High-risk contracts offer the best rewards for those skilled enough.',
    `RequestItemsText` = 'Have you completed an advanced contract?',
    `EndText` = 'You have mastered advanced contracts.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 350,
    `Flags` = 0
WHERE `entry` = 10027;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `ObjectiveText1`, `Title`, `Objectives`, `Details`, `OfferRewardText`,
    `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10027, 0, 1, 1, 10028, 0, 350, 'Complete a high-risk, high-reward contract',
    'Advanced Contracts',
    'Accept and complete a challenging contract from the Task Board. Higher risk means higher reward.',
    '"You''re ready for more challenging work. Go to the Task Board and accept a high-risk contract. These pay better but are more dangerous. Use everything you''ve learned - good gear, smart positioning, and quick looting. The rewards are worth the risk."',
    'Impressive! You handled the challenge well. High-risk contracts offer the best rewards for those skilled enough.',
    'Have you completed an advanced contract?',
    'You have mastered advanced contracts.',
    'Return to the Harbor Master.',
    350, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10027);

-- Q10028: Faction Introduction
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 10029,
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 375,
    `RequiredNpcOrGo1` = 100026, -- Faction Representative
    `RequiredNpcOrGoCount1` = 0,
    `ObjectiveText1` = 'Speak with a Faction Representative and learn about alliances',
    `Title` = 'Faction Introduction',
    `Objectives` = 'Visit a faction representative and learn about the different groups vying for power in the region.',
    `Details` = '"Power in this world belongs to factions. Visit one of the faction representatives and learn about their goals. Each offers different contracts, allies, and enemies. Your choices here will shape your path. Some factions are honorable, others ruthless - choose carefully."',
    `OfferRewardText` = 'You understand factions now. Each offers power and protection, but also obligations. Choose your alliances wisely.',
    `RequestItemsText` = 'Have you spoken with a faction representative?',
    `EndText` = 'You have learned about factions.',
    `CompletedText` = 'Return to the Harbor Master.',
    `RewOrReqMoney` = 375,
    `Flags` = 0
WHERE `entry` = 10028;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RequiredNpcOrGo1`, `ObjectiveText1`, `Title`, `Objectives`, `Details`,
    `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10028, 0, 1, 1, 10029, 0, 375, 100026, 'Speak with a Faction Representative and learn about alliances',
    'Faction Introduction',
    'Visit a faction representative and learn about the different groups vying for power in the region.',
    '"Power in this world belongs to factions. Visit one of the faction representatives and learn about their goals. Each offers different contracts, allies, and enemies. Your choices here will shape your path. Some factions are honorable, others ruthless - choose carefully."',
    'You understand factions now. Each offers power and protection, but also obligations. Choose your alliances wisely.',
    'Have you spoken with a faction representative?',
    'You have learned about factions.',
    'Return to the Harbor Master.',
    375, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10028);

-- Q10029: Ready for Adventure
UPDATE `quest_template` SET
    `QuestType` = 0,
    `QuestLevel` = 1,
    `MinLevel` = 1,
    `RewardNextQuest` = 0, -- End of prologue/act I
    `RewardXPDifficulty` = 0,
    `RewardMoney` = 500,
    `RewardItemId1` = 100027, -- Adventurer's Starter Kit
    `RewardItemCount1` = 1,
    `ObjectiveText1` = 'Complete your final preparations and get ready to leave Port Meridian',
    `Title` = 'Ready for Adventure',
    `Objectives` = 'Gather any final supplies, check your gear, and prepare to venture into the wider world.',
    `Details` = '"You''ve learned the basics of survival and economy in this broken world. You understand looting, combat, crafting, contracts, markets, and factions. Now you''re ready for the Frontier. The world beyond Port Meridian is dangerous, but opportunity awaits the prepared."',
    `OfferRewardText` = 'You''re ready. Go forth and survive. The Frontier needs people like you - skilled, prepared, and determined.',
    `RequestItemsText` = 'Are you prepared for the Frontier?',
    `EndText` = 'You are ready for adventure.',
    `CompletedText` = 'Speak with the Harbor Master for final words.',
    `RewOrReqMoney` = 500,
    `Flags` = 0
WHERE `entry` = 10029;

INSERT INTO `quest_template` (`entry`, `QuestType`, `QuestLevel`, `MinLevel`, `RewardNextQuest`,
    `RewardMoney`, `RewardItemId1`, `RewardItemCount1`, `ObjectiveText1`, `Title`, `Objectives`,
    `Details`, `OfferRewardText`, `RequestItemsText`, `EndText`, `CompletedText`, `RewOrReqMoney`, `Flags`)
SELECT 10029, 0, 1, 1, 0, 0, 500, 100027, 1, 'Complete your final preparations and get ready to leave Port Meridian',
    'Ready for Adventure',
    'Gather any final supplies, check your gear, and prepare to venture into the wider world.',
    '"You''ve learned the basics of survival and economy in this broken world. You understand looting, combat, crafting, contracts, markets, and factions. Now you''re ready for the Frontier. The world beyond Port Meridian is dangerous, but opportunity awaits the prepared."',
    'You''re ready. Go forth and survive. The Frontier needs people like you - skilled, prepared, and determined.',
    'Are you prepared for the Frontier?',
    'You are ready for adventure.',
    'Speak with the Harbor Master for final words.',
    500, 0
WHERE NOT EXISTS (SELECT 1 FROM `quest_template` WHERE `entry` = 10029);

-- Quest chain registration
INSERT INTO `mortal_quest_conversion_map` (`quest_id`, `conversion_type`, `faction_tag`, `notes`)
VALUES
(10000, 'STORY_REWRITE', NULL, 'Prologue Quest - Waking on the Beach'),
(10001, 'STORY_REWRITE', NULL, 'Prologue Quest - First Loot'),
(10002, 'STORY_REWRITE', NULL, 'Prologue Quest - Basic Combat'),
(10003, 'STORY_REWRITE', NULL, 'Prologue Quest - Weapon Basics'),
(10004, 'STORY_REWRITE', NULL, 'Prologue Quest - Gathering Materials'),
(10005, 'STORY_REWRITE', NULL, 'Prologue Quest - Simple Crafting'),
(10006, 'STORY_REWRITE', NULL, 'Prologue Quest - Combat Training'),
(10007, 'STORY_REWRITE', NULL, 'Prologue Quest - Looting Practice'),
(10008, 'STORY_REWRITE', NULL, 'Prologue Quest - Inventory Management'),
(10009, 'STORY_REWRITE', NULL, 'Prologue Quest - Basic Survival'),
(10010, 'STORY_REWRITE', NULL, 'Prologue Quest - Rift Introduction'),
(10011, 'STORY_REWRITE', NULL, 'Prologue Quest - Shrine Basics'),
(10012, 'STORY_REWRITE', NULL, 'Prologue Quest - Final Survival Test'),
(10013, 'STORY_REWRITE', NULL, 'Prologue Quest - Prepare to Leave'),
(10014, 'STORY_REWRITE', NULL, 'Prologue Quest - Journey to Port Meridian'),
(10015, 'STORY_REWRITE', NULL, 'Act I Quest - Arrival in Port Meridian'),
(10016, 'STORY_REWRITE', NULL, 'Act I Quest - Contract Basics'),
(10017, 'STORY_REWRITE', NULL, 'Act I Quest - First Contract'),
(10018, 'STORY_REWRITE', NULL, 'Act I Quest - Contract Rewards'),
(10019, 'STORY_REWRITE', NULL, 'Act I Quest - Market Basics'),
(10020, 'STORY_REWRITE', NULL, 'Act I Quest - Banking Introduction'),
(10021, 'STORY_REWRITE', NULL, 'Act I Quest - Regional Banking'),
(10022, 'STORY_REWRITE', NULL, 'Act I Quest - Courier Services'),
(10023, 'STORY_REWRITE', NULL, 'Act I Quest - Contract Types'),
(10024, 'STORY_REWRITE', NULL, 'Act I Quest - Economy Basics'),
(10025, 'STORY_REWRITE', NULL, 'Act I Quest - Trading'),
(10026, 'STORY_REWRITE', NULL, 'Act I Quest - Specialization'),
(10027, 'STORY_REWRITE', NULL, 'Act I Quest - Advanced Contracts'),
(10028, 'STORY_REWRITE', NULL, 'Act I Quest - Faction Introduction'),
(10029, 'STORY_REWRITE', NULL, 'Act I Quest - Ready for Adventure')
ON DUPLICATE KEY UPDATE
    `conversion_type` = VALUES(`conversion_type`),
    `notes` = VALUES(`notes`);

-- Summary
SELECT
    'Prologue & Act I Quest Pack Implementation Complete' as status,
    COUNT(*) as total_quests_created,
    'Shipwreck Cove: 10000-10014 (15 quests)' as shipwreck_cove_range,
    'Port Meridian: 10015-10029 (15 quests)' as port_meridian_range,
    'Core mechanics taught: looting, combat, crafting, contracts, economy, factions' as mechanics_covered
FROM quest_template
WHERE entry BETWEEN 10000 AND 10029;