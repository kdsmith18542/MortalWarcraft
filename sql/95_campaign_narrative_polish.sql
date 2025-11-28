-- ==================================================
-- Mortal Warcraft – Campaign Narrative Polish
-- Spec 62: Core Lore and Campaign Skeleton
-- Enhanced quest text and dialogue
-- Target DB: world
-- ==================================================

-- Enhanced Prologue Quest Text

-- Q90000: Waking in the Wreck - Enhanced Details
UPDATE `quest_template` SET
    `Details` = 'You wake up on a beach, surrounded by wreckage. The air feels wrong—thick with something unnatural. The sky above has an unnatural hue, as if reality itself has been torn. A weathered survivor approaches you, their eyes filled with a mix of fear and grim determination. They speak in hushed tones, as if afraid the very air might hear them.',
    `OfferRewardText` = 'Good. You''re alive. That''s more than many can say after the Fracture. The world broke, friend. Everything we knew... gone. But we''re still here. And that means we have work to do.',
    `RequestItemsText` = 'Please, help us... We need every able body we can find. The Fracture didn''t just break the land—it broke everything. But we can still survive. We can still fight.',
    `CompletedText` = 'You have taken your first steps in this broken world. The journey ahead will be long, but you are not alone.'
WHERE `entry` = 90000;

-- Q90001: Arms from Ruin - Enhanced Details
UPDATE `quest_template` SET
    `Details` = 'The survivor points to a pile of debris scattered along the shore. "We need weapons. The Fracture brought more than just broken ships—it brought things. Things that shouldn''t exist. Scavenge what you can from the wreck. Then test it on that dummy over there. You''ll need to know how to fight if you want to survive out there."',
    `OfferRewardText` = 'Good. You''ve learned the basics of combat. Remember: Brace when they attack, strike when they''re open. In this world, every fight could be your last. Make every blow count.',
    `RequestItemsText` = 'Have you found a weapon and tested it yet? We don''t have time to waste—the Rifts are getting worse.',
    `CompletedText` = 'You have learned basic combat. The survivor nods approvingly.'
WHERE `entry` = 90001;

-- Q90002: Driftwood & Flint - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"We can''t rely on scavenging forever. The wreckage will run out, and then what? We need to craft our own tools. Gather driftwood from the beach—there''s plenty washed up. And flint from the rocks over there. There''s a makeshift anvil near the camp—bring everything there. We''ll make something useful."',
    `OfferRewardText` = 'Excellent. These materials will be useful. Now let''s see if you can craft something with them. In this world, the ability to make your own gear is the difference between life and death.',
    `RequestItemsText` = 'Do you have the driftwood and flint? The anvil is waiting.',
    `CompletedText` = 'You have gathered the materials. The survivor examines them with a critical eye.'
WHERE `entry` = 90002;

-- Q90003: Edge of Survival - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"Now use those materials to craft a weapon. The anvil is crude, but it''ll do. Make a shiv—simple, but effective. When you''re done, equip it. You''ll need it soon. Remember: quality matters. Better materials and skill make better gear. This is just the beginning."',
    `OfferRewardText` = 'Well done. You''ve made your first weapon. Remember: quality matters. Better materials and skill make better gear. In this world, your gear is your life. Take care of it, and it''ll take care of you.',
    `RequestItemsText` = 'Have you crafted and equipped the shiv? Time is running short.',
    `CompletedText` = 'You have crafted your first weapon. The survivor tests its edge.'
WHERE `entry` = 90003;

-- Q90004: First Fracture - Enhanced Details
UPDATE `quest_template` SET
    `Details` = 'The survivor''s eyes widen as they point toward the horizon. "Look—a Rift. The Fracture is everywhere. Those creatures... they''re not natural. They''re twisted, wrong. Kill them, then check that Shrine Fragment. It''s broken, but it might tell us something. The Shrines... they''re anchors. They hold back the Fracture. But this one is damaged beyond repair."',
    `OfferRewardText` = 'The Shrine is damaged beyond repair here. But inland... there are real Shrines. They''re anchors against the Fracture. When you die, they''ll pull you back—but at a cost. Your gear stays where you fell. Remember that. Death is not the end here, but it''s not free either.',
    `RequestItemsText` = 'Have you dealt with the Rift creatures? We need to know what we''re facing.',
    `CompletedText` = 'You have encountered your first Rift. The survivor looks grim.'
WHERE `entry` = 90004;

-- Q90005: The Raft to Mainland - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"We can''t stay here. The Rifts are getting worse, and this cove won''t protect us forever. Repair that raft—you''ll need more driftwood and some rope. Once it''s done, we''re leaving. The Mainland Hub is where the real work begins. That''s where you''ll find the Shrines, the Task Boards, the markets. That''s where you''ll make your mark—or die trying."',
    `OfferRewardText` = 'The world is broken, but there is work to be done inland. You''ve survived the shipwreck. Now survive the Frontier. Remember everything you''ve learned here. It might save your life.',
    `RequestItemsText` = 'Is the raft ready? We need to leave before the next Rift opens.',
    `CompletedText` = 'You are ready to leave Shipwreck Cove. The mainland awaits.'
WHERE `entry` = 90005;

-- Enhanced Act I Quest Text

-- Q90010: Welcome to the Hub - Enhanced Details
UPDATE `quest_template` SET
    `Details` = 'The Harbor Clerk greets you as you arrive, their eyes scanning you with practiced efficiency. "Welcome to Port Meridian. This is where the real work begins. Let me show you around—you''ll need to know where everything is. The Task Board is where you find work. The Market is where you buy and sell. The Bank is where you store your valuables. And the Shrine... well, you''ll learn about that soon enough."',
    `OfferRewardText` = 'Good. You know where the essentials are. Now let''s get you some actual work. This city runs on contracts, not charity. You work, you get paid. Simple as that.',
    `RequestItemsText` = 'Have you visited the Task Board and Market yet? Time is money, friend.',
    `CompletedText` = 'You have been introduced to Port Meridian. The city sprawls before you.'
WHERE `entry` = 90010;

-- Q90011: The First Contract - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"In this city, work is found at the board. Go there, pick a contract—something simple like clearing rats or gathering herbs. Complete it, and you''ll see how things work here. No handouts. No free rides. You work, you get paid. That''s the way it is now."',
    `OfferRewardText` = 'Well done. That''s how you make a living here—contracts, not quests. Gold and materials, not experience points. In this world, you don''t level up. You get stronger by using your skills, gathering better materials, and making better gear. That''s the only progression that matters.',
    `RequestItemsText` = 'Have you completed a contract yet? The board is waiting.',
    `CompletedText` = 'You have completed your first contract. The system works.'
WHERE `entry` = 90011;

-- Q90012: Pay, Not XP - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"You''ve done the work. Now collect your pay. Remember: in this world, you don''t level up. You get stronger by using your skills, gathering better materials, and making better gear. Gold and materials are what matter. Experience points? Those don''t exist anymore. The Fracture changed everything—including how we grow stronger."',
    `OfferRewardText` = 'Exactly. Skills improve with use. Materials make better gear. Gold buys what you need. That''s the economy here. Simple, brutal, and fair. You get what you earn.',
    `RequestItemsText` = 'Have you collected your contract payment? Don''t leave money on the table.',
    `CompletedText` = 'You have received your first contract payment. Gold clinks in your pocket.'
WHERE `entry` = 90012;

-- Q90013: Ledger of the Living - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"Your wealth needs protection. The Regional Bank here in Port Meridian is where you store valuables. But remember: what you deposit here stays here. If you travel to another city, you''ll need to withdraw and carry it, or use courier services. There''s no magical mail system anymore. Everything is physical. Everything has weight. Plan accordingly."',
    `OfferRewardText` = 'Good. You understand regional banking. Your items are safe here, but they''re also tied to this place. If you want your gear in another city, you''ll have to carry it yourself. That''s the price of safety.',
    `RequestItemsText` = 'Have you made a deposit at the bank? Your valuables aren''t safe in your bags.',
    `CompletedText` = 'You have learned about regional banking. Your wealth is secured.'
WHERE `entry` = 90013;

-- Q90014: A Whisper of Death - Enhanced Details
UPDATE `quest_template` SET
    `Details` = '"You should know what happens when you die. Speak with the Shrine Acolyte—they''ll explain. It''s not pleasant, but it''s better to know now than to learn the hard way. Death is different here. The Shrines pull you back, but there''s a cost. Always a cost."',
    `OfferRewardText` = 'You understand now. When you die, the Shrine will pull you back—but your steel stays where you fell. Your gear, your gold, your everything. It all stays behind. That''s the price of resurrection. Be careful out there. Every death is expensive.',
    `RequestItemsText` = 'Have you spoken with the Shrine Acolyte? Knowledge of death might save your life.',
    `CompletedText` = 'You have learned about death and resurrection. The knowledge weighs heavy.'
WHERE `entry` = 90014;

