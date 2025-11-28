-- ==================================================
-- Mortal Warcraft – Frontier Bruiser Quest Chain & NPCs
-- Spec 80: Content Lane - Frontier Bruiser Quest and Loot Bundle
-- Quest IDs: 70001-70008
-- NPC IDs: 61000-61010
-- ==================================================

-- ==================================================
-- NPCs: Port Meridian Barracks
-- ==================================================

-- Captain Arlen Stonefist (T1 Quest Giver)
DELETE FROM creature_template WHERE entry = 61000;
INSERT INTO creature_template (
    entry, modelid1, modelid2, name, subname, IconName, gossip_menu_id, minlevel, maxlevel,
    exp, faction, npcflag, speed_walk, speed_run, scale, rank, dmgschool, BaseAttackTime,
    RangeAttackTime, BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
    dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race,
    type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2,
    resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4,
    spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold,
    AIName, MovementType, InhabitType, HoverHeight, HealthModifier, ManaModifier,
    ArmorModifier, DamageModifier, ExperienceModifier, RacialLeader, movementId,
    RegenHealth, mechanic_immune_mask, flags_extra, ScriptName
) VALUES (
    61000, 0, 0, 'Captain Arlen Stonefist', 'Militia Commander', '', 0, 10, 10,
    0, 35, 2, 1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    '', 0, 3, 1, 1, 1,
    1, 1, 1, 0, 0,
    1, 0, 0, ''
);

-- Sergeant Lysa Hawktide (T1 Follow-up Quest Giver)
DELETE FROM creature_template WHERE entry = 61001;
INSERT INTO creature_template (
    entry, modelid1, modelid2, name, subname, IconName, gossip_menu_id, minlevel, maxlevel,
    exp, faction, npcflag, speed_walk, speed_run, scale, rank, dmgschool, BaseAttackTime,
    RangeAttackTime, BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
    dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race,
    type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2,
    resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4,
    spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold,
    AIName, MovementType, InhabitType, HoverHeight, HealthModifier, ManaModifier,
    ArmorModifier, DamageModifier, ExperienceModifier, RacialLeader, movementId,
    RegenHealth, mechanic_immune_mask, flags_extra, ScriptName
) VALUES (
    61001, 0, 0, 'Sergeant Lysa Hawktide', 'Militia Trainer', '', 0, 8, 8,
    0, 35, 2, 1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    '', 0, 3, 1, 1, 1,
    1, 1, 1, 0, 0,
    1, 0, 0, ''
);

-- Militia Quartermaster Bram (T1 Vendor)
DELETE FROM creature_template WHERE entry = 61002;
INSERT INTO creature_template (
    entry, modelid1, modelid2, name, subname, IconName, gossip_menu_id, minlevel, maxlevel,
    exp, faction, npcflag, speed_walk, speed_run, scale, rank, dmgschool, BaseAttackTime,
    RangeAttackTime, BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
    dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race,
    type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2,
    resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4,
    spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold,
    AIName, MovementType, InhabitType, HoverHeight, HealthModifier, ManaModifier,
    ArmorModifier, DamageModifier, ExperienceModifier, RacialLeader, movementId,
    RegenHealth, mechanic_immune_mask, flags_extra, ScriptName
) VALUES (
    61002, 0, 0, 'Militia Quartermaster Bram', 'Militia Quartermaster', '', 0, 5, 5,
    0, 35, 128, 1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    '', 0, 3, 1, 1, 1,
    1, 1, 1, 0, 0,
    1, 0, 0, ''
);

-- ==================================================
-- NPCs: Greycrag Stronghold
-- ==================================================

-- Captain Jorik Linebreaker (T2 Quest Giver)
DELETE FROM creature_template WHERE entry = 61010;
INSERT INTO creature_template (
    entry, modelid1, modelid2, name, subname, IconName, gossip_menu_id, minlevel, maxlevel,
    exp, faction, npcflag, speed_walk, speed_run, scale, rank, dmgschool, BaseAttackTime,
    RangeAttackTime, BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
    dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race,
    type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2,
    resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4,
    spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold,
    AIName, MovementType, InhabitType, HoverHeight, HealthModifier, ManaModifier,
    ArmorModifier, DamageModifier, ExperienceModifier, RacialLeader, movementId,
    RegenHealth, mechanic_immune_mask, flags_extra, ScriptName
) VALUES (
    61010, 0, 0, 'Captain Jorik Linebreaker', 'Linebreaker Captain', '', 0, 15, 15,
    0, 35, 2, 1, 1.14286, 1, 1, 0, 2000,
    2000, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    '', 0, 3, 1, 1, 1,
    1, 1, 1, 0, 0,
    1, 0, 0, ''
);

-- Ironhand Thora (Frontier Smith - T2 Crafting Vendor)
DELETE FROM creature_template WHERE entry = 61011;
INSERT INTO creature_template (
    entry, modelid1, modelid2, name, subname, IconName, gossip_menu_id, minlevel, maxlevel,
    exp, faction, npcflag, speed_walk, speed_run, scale, rank, dmgschool, BaseAttackTime,
    RangeAttackTime, BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
    dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race,
    type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2,
    resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4,
    spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold,
    AIName, MovementType, InhabitType, HoverHeight, HealthModifier, ManaModifier,
    ArmorModifier, DamageModifier, ExperienceModifier, RacialLeader, movementId,
    RegenHealth, mechanic_immune_mask, flags_extra, ScriptName
) VALUES (
    61011, 0, 0, 'Ironhand Thora', 'Frontier Smith', '', 0, 10, 10,
    0, 35, 128, 1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    '', 0, 3, 1, 1, 1,
    1, 1, 1, 0, 0,
    1, 0, 0, ''
);

-- Stronghold Quartermaster Rurik (T2 Token Vendor)
DELETE FROM creature_template WHERE entry = 61012;
INSERT INTO creature_template (
    entry, modelid1, modelid2, name, subname, IconName, gossip_menu_id, minlevel, maxlevel,
    exp, faction, npcflag, speed_walk, speed_run, scale, rank, dmgschool, BaseAttackTime,
    RangeAttackTime, BaseVariance, RangeVariance, unit_class, unit_flags, unit_flags2,
    dynamicflags, family, trainer_type, trainer_spell, trainer_class, trainer_race,
    type, type_flags, lootid, pickpocketloot, skinloot, resistance1, resistance2,
    resistance3, resistance4, resistance5, resistance6, spell1, spell2, spell3, spell4,
    spell5, spell6, spell7, spell8, PetSpellDataId, VehicleId, mingold, maxgold,
    AIName, MovementType, InhabitType, HoverHeight, HealthModifier, ManaModifier,
    ArmorModifier, DamageModifier, ExperienceModifier, RacialLeader, movementId,
    RegenHealth, mechanic_immune_mask, flags_extra, ScriptName
) VALUES (
    61012, 0, 0, 'Stronghold Quartermaster Rurik', 'Stronghold Quartermaster', '', 0, 8, 8,
    0, 35, 128, 1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0,
    '', 0, 3, 1, 1, 1,
    1, 1, 1, 0, 0,
    1, 0, 0, ''
);

-- ==================================================
-- T1 Quest Chain: Port Meridian Militia Arc
-- ==================================================

-- Q1: Call to the Line (70001)
DELETE FROM quest_template WHERE ID = 70001;
INSERT INTO quest_template (
    ID, Method, ZoneOrSort, QuestLevel, MinLevel, QuestSortID, QuestType, SuggestedPlayers,
    LimitTime, RequiredClasses, RequiredRaces, RequiredSkillId, RequiredSkillPoints,
    RequiredFactionId1, RequiredFactionValue1, RequiredMinRepFaction, RequiredMinRepValue,
    RequiredMaxRepFaction, RequiredMaxRepValue, PrevQuestId, NextQuestId, ExclusiveGroup,
    NextQuestInChain, RewardXPId, RewardOrRequiredMoney, RewardMoneyMaxLevel,
    RewardSpell, RewardSpellCast, RewardHonor, RewardKillHonor, StartItem, Flags,
    RewardTitleId, RequiredPlayerKills, RewardTalents, RewardArenaPoints, RewardItem1,
    RewardAmount1, RewardItem2, RewardAmount2, RewardItem3, RewardAmount3, RewardItem4,
    RewardAmount4, RewardChoiceItemID1, RewardChoiceItemQuantity1, RewardChoiceItemID2,
    RewardChoiceItemQuantity2, RewardChoiceItemID3, RewardChoiceItemQuantity3,
    RewardChoiceItemID4, RewardChoiceItemQuantity4, RewardChoiceItemID5,
    RewardChoiceItemQuantity5, RewardChoiceItemID6, RewardChoiceItemQuantity6,
    POIContinent, POIx, POIy, POIPriority, Title, Objectives, Details, EndText,
    CompletedText, OfferRewardText, RequestItemsText, ObjectiveText1, ObjectiveText2,
    ObjectiveText3, ObjectiveText4
) VALUES (
    70001, 2, 0, 1, 1, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 70002, 0,
    0, 0, 0,
    500, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 700006,  -- Militia Marching Boots
    1, 700005, 1, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    0, 0, 0, 0,
    'Call to the Line',
    'Speak to Sergeant Lysa Hawktide and complete basic Brace training.',
    'Captain Stonefist has called for all able recruits to report for militia training. Find Sergeant Hawktide in the training yard and learn the basics of combat.',
    '',
    '',
    'You''ve shown enough grit to stand in the line, recruit. Here''s your first gear.',
    '',
    'Speak to Sergeant Hawktide', 'Complete Brace training', '', ''
);

-- Q2: First Patrol (70002)
DELETE FROM quest_template WHERE ID = 70002;
INSERT INTO quest_template (
    ID, Method, ZoneOrSort, QuestLevel, MinLevel, QuestSortID, QuestType, SuggestedPlayers,
    LimitTime, RequiredClasses, RequiredRaces, RequiredSkillId, RequiredSkillPoints,
    RequiredFactionId1, RequiredFactionValue1, RequiredMinRepFaction, RequiredMinRepValue,
    RequiredMaxRepFaction, RequiredMaxRepValue, PrevQuestId, NextQuestId, ExclusiveGroup,
    NextQuestInChain, RewardXPId, RewardOrRequiredMoney, RewardMoneyMaxLevel,
    RewardSpell, RewardSpellCast, RewardHonor, RewardKillHonor, StartItem, Flags,
    RewardTitleId, RequiredPlayerKills, RewardTalents, RewardArenaPoints, RewardItem1,
    RewardAmount1, RewardItem2, RewardAmount2, RewardItem3, RewardAmount3, RewardItem4,
    RewardAmount4, RewardChoiceItemID1, RewardChoiceItemQuantity1, RewardChoiceItemID2,
    RewardChoiceItemQuantity2, RewardChoiceItemID3, RewardChoiceItemQuantity3,
    RewardChoiceItemID4, RewardChoiceItemQuantity4, RewardChoiceItemID5,
    RewardChoiceItemQuantity5, RewardChoiceItemID6, RewardChoiceItemQuantity6,
    POIContinent, POIx, POIy, POIPriority, Title, Objectives, Details, EndText,
    CompletedText, OfferRewardText, RequestItemsText, ObjectiveText1, ObjectiveText2,
    ObjectiveText3, ObjectiveText4, RequiredNpcOrGo1, RequiredNpcOrGoCount1,
    RequiredNpcOrGo2, RequiredNpcOrGoCount2, RequiredNpcOrGo3, RequiredNpcOrGoCount3,
    RequiredNpcOrGo4, RequiredNpcOrGoCount4
) VALUES (
    70002, 2, 0, 2, 1, 0, 1, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 70001, 70003, 0,
    0, 0, 0,
    750, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 700002,  -- Militia Iron Coif
    1, 700007, 1, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0,
    0, 0, 0,
    0, 0, 0, 0,
    'First Patrol',
    'Kill 8 Highway Bandits and investigate 3 Disturbed Ground locations.',
    'Your first real assignment: patrol the road outside Port Meridian. Bandits have been harassing travelers. Clear them out and investigate any suspicious activity.',
    '',
    '',
    'Good work, recruit. You''re learning fast.',
    '',
    'Kill Highway Bandits', 'Investigate Disturbed Ground', '', '',
    0, 8,  -- Highway Bandit (placeholder NPC ID)
    0, 3,  -- Disturbed Ground (placeholder GO ID)
    0, 0,
    0, 0
);

-- Q3: Hold the Crossing (70003)
DELETE FROM quest_template WHERE ID = 70003;
INSERT INTO quest_template (
    ID, Method, ZoneOrSort, QuestLevel, MinLevel, QuestSortID, QuestType, SuggestedPlayers,
    LimitTime, RequiredClasses, RequiredRaces, RequiredSkillId, RequiredSkillPoints,
    RequiredFactionId1, RequiredFactionValue1, RequiredMinRepFaction, RequiredMinRepValue,
    RequiredMaxRepFaction, RequiredMaxRepValue, PrevQuestId, NextQuestId, ExclusiveGroup,
    NextQuestInChain, RewardXPId, RewardOrRequiredMoney, RewardMoneyMaxLevel,
    RewardSpell, RewardSpellCast, RewardHonor, RewardKillHonor, StartItem, Flags,
    RewardTitleId, RequiredPlayerKills, RewardTalents, RewardArenaPoints, RewardItem1,
    RewardAmount1, RewardItem2, RewardAmount2, RewardItem3, RewardAmount3, RewardItem4,
    RewardAmount4, POIContinent, POIx, POIy, POIPriority, Title, Objectives, Details,
    EndText, CompletedText, OfferRewardText, RequestItemsText, ObjectiveText1,
    ObjectiveText2, ObjectiveText3, ObjectiveText4
) VALUES (
    70003, 2, 0, 3, 2, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 70002, 70004, 0,
    0, 0, 0,
    1000, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 700003,  -- Militia Chain Hauberk
    1, 0, 0, 0, 0,
    0, 0, 0, 0,
    'Hold the Crossing',
    'Defend the bridge against waves of bandits.',
    'A bridge outside Port Meridian is under threat. Travel there and help defend it against the bandit assault. This will be your first real test of combat.',
    '',
    '',
    'You held the line. The bridge is safe, and you''ve earned this.',
    '',
    'Defend the bridge', '', '', ''
);

-- Q4: Militia Muster (70004)
DELETE FROM quest_template WHERE ID = 70004;
INSERT INTO quest_template (
    ID, Method, ZoneOrSort, QuestLevel, MinLevel, QuestSortID, QuestType, SuggestedPlayers,
    LimitTime, RequiredClasses, RequiredRaces, RequiredSkillId, RequiredSkillPoints,
    RequiredFactionId1, RequiredFactionValue1, RequiredMinRepFaction, RequiredMinRepValue,
    RequiredMaxRepFaction, RequiredMaxRepValue, PrevQuestId, NextQuestId, ExclusiveGroup,
    NextQuestInChain, RewardXPId, RewardOrRequiredMoney, RewardMoneyMaxLevel,
    RewardSpell, RewardSpellCast, RewardHonor, RewardKillHonor, StartItem, Flags,
    RewardTitleId, RequiredPlayerKills, RewardTalents, RewardArenaPoints, RewardItem1,
    RewardAmount1, RewardItem2, RewardAmount2, RewardItem3, RewardAmount3, RewardItem4,
    RewardAmount4, Title, Objectives, Details,
    EndText, CompletedText, OfferRewardText, RequestItemsText, ObjectiveText1,
    ObjectiveText2, ObjectiveText3, ObjectiveText4
) VALUES (
    70004, 2, 0, 4, 3, 0, 0, 3,
    0, 0, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 70003, 0, 0,
    0, 0, 0,
    1500, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 700001,  -- Greycrag Militia Blade
    1, 0, 0, 0, 0,  -- TODO: Add Rune of Cleaving Strike item ID
    'Militia Muster',
    'Complete the militia training scenario with up to 3 players.',
    'Captain Stonefist is organizing a final training exercise. You''ll need to work with other recruits to defend a choke point and defeat a named bandit leader. This is your final test before becoming a full militia member.',
    '',
    '',
    'You''ve proven yourself. Welcome to the Greycrag Militia.',
    '',
    'Complete the training scenario', 'Defeat the bandit leader', '', ''
);

-- ==================================================
-- Vendor Configurations
-- ==================================================

-- Militia Quartermaster Bram - Sells T1 Greycrag Militia Set
DELETE FROM npc_vendor WHERE entry = 61002;
INSERT INTO npc_vendor (entry, slot, item, maxcount, incrtime, ExtendedCost) VALUES
(61002, 0, 700001, 0, 0, 0),  -- Greycrag Militia Blade
(61002, 0, 700002, 0, 0, 0),  -- Militia Iron Coif
(61002, 0, 700003, 0, 0, 0),  -- Militia Chain Hauberk
(61002, 0, 700004, 0, 0, 0),  -- Militia Chain Leggings
(61002, 0, 700005, 0, 0, 0),  -- Militia Grips
(61002, 0, 700006, 0, 0, 0),  -- Militia Marching Boots
(61002, 0, 700007, 0, 0, 0),  -- Iron-Signed Band
(61002, 0, 700008, 0, 0, 0);  -- Greycrag Oath Pendant

-- Stronghold Quartermaster Rurik - Sells T2 Linebreaker Vanguard Set
DELETE FROM npc_vendor WHERE entry = 61012;
INSERT INTO npc_vendor (entry, slot, item, maxcount, incrtime, ExtendedCost) VALUES
(61012, 0, 700010, 0, 0, 0),  -- Linebreaker War-Axe
(61012, 0, 700011, 0, 0, 0),  -- Linebreaker War-Visor
(61012, 0, 700012, 0, 0, 0),  -- Linebreaker Bulwark Cuirass
(61012, 0, 700013, 0, 0, 0),  -- Linebreaker March Greaves
(61012, 0, 700014, 0, 0, 0),  -- Linebreaker Crusher Gauntlets
(61012, 0, 700015, 0, 0, 0),  -- Linebreaker Tread Boots
(61012, 0, 700016, 0, 0, 0),  -- Vanguard Signet
(61012, 0, 700017, 0, 0, 0);  -- Vanguard Iron Torque

