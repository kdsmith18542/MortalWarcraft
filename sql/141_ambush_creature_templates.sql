
-- ==================================================
-- Mortal Warcraft – Ambush Creature Templates
-- PvP Ambush System for Red/Yellow Zones
-- IDs 40001-40013
-- ==================================================

-- Ambush Bandit (40001) - Level 20 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40001, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ambush Bandit', '', '', 0, 20, 20, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40001, 0, 0, 0, 0, 0, 10, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Brigand (40002) - Level 21 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40002, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ambush Brigand', '', '', 0, 21, 21, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40002, 0, 0, 0, 0, 0, 12, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Highwayman (40003) - Level 22 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40003, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ambush Highwayman', '', '', 0, 22, 22, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40003, 0, 0, 0, 0, 0, 14, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Wolf (40004) - Level 23 Beast
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40004, 0, 0, 0, 0, 0, 2070, 0, 0, 0, 'Ambush Wolf', '', '', 0, 23, 23, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 1, 0, 0, 0, 0,
    1, 0, 40004, 0, 40004, 0, 0, 0, 16, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `family` = VALUES(`family`),
    `lootid` = VALUES(`lootid`),
    `skinloot` = VALUES(`skinloot`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Bear (40005) - Level 24 Beast
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40005, 0, 0, 0, 0, 0, 381, 0, 0, 0, 'Ambush Bear', '', '', 0, 24, 24, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 4, 0, 0, 0, 0,
    1, 0, 40005, 0, 40005, 0, 0, 0, 18, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `family` = VALUES(`family`),
    `lootid` = VALUES(`lootid`),
    `skinloot` = VALUES(`skinloot`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Skeleton (40006) - Level 25 Undead
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40006, 0, 0, 0, 0, 0, 9783, 0, 0, 0, 'Ambush Skeleton', '', '', 0, 25, 25, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    6, 0, 40006, 0, 0, 0, 0, 0, 20, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Ghoul (40007) - Level 26 Undead
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40007, 0, 0, 0, 0, 0, 9782, 0, 0, 0, 'Ambush Ghoul', '', '', 0, 26, 26, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    6, 0, 40007, 0, 0, 0, 0, 0, 22, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Rogue (40008) - Level 27 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40008, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ambush Rogue', '', '', 0, 27, 27, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40008, 0, 0, 0, 0, 0, 24, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Assassin (40009) - Level 28 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40009, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ambush Assassin', '', '', 0, 28, 28, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40009, 0, 0, 0, 0, 0, 26, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Spider (40010) - Level 29 Beast
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40010, 0, 0, 0, 0, 0, 155, 0, 0, 0, 'Ambush Spider', '', '', 0, 29, 29, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 3, 0, 0, 0, 0,
    1, 0, 40010, 0, 40010, 0, 0, 0, 28, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `family` = VALUES(`family`),
    `lootid` = VALUES(`lootid`),
    `skinloot` = VALUES(`skinloot`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Worgen (40011) - Level 30 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40011, 0, 0, 0, 0, 0, 657, 0, 0, 0, 'Ambush Worgen', '', '', 0, 30, 30, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40011, 0, 0, 0, 0, 0, 30, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Ogre (40012) - Level 31 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40012, 0, 0, 0, 0, 0, 334, 0, 0, 0, 'Ambush Ogre', '', '', 0, 31, 31, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40012, 0, 0, 0, 0, 0, 32, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- Ambush Warlock (40013) - Level 32 Humanoid
INSERT INTO `creature_template` (`entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`, `modelid1`, `modelid2`, `modelid3`, `modelid4`, `name`, `subname`,
    `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `faction`, `npcflag`, `speed_walk`,
    `speed_run`, `speed_swim`, `speed_flight`, `detection_range`, `scale`, `rank`, `dmgschool`,
    `DamageModifier`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`,
    `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`,
    `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`,
    `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`,
    `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`, `flags_extra`, `ScriptName`,
    `VerifiedBuild`)
VALUES
(40013, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ambush Warlock', '', '', 0, 32, 32, 0, 16, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 40013, 0, 0, 0, 0, 0, 34, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `lootid` = VALUES(`lootid`),
    `mingold` = VALUES(`mingold`),
    `maxgold` = VALUES(`maxgold`);

-- ==================================================
-- LOOT TABLES
-- ==================================================

-- Ambush Bandit (40001)
DELETE FROM creature_loot_template WHERE Entry = 40001;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40001, 0, 0, 100.0, 0, 1, 0, 5, 15, 'Gold'),
(40001, 37711, 0, 10.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Brigand (40002)
DELETE FROM creature_loot_template WHERE Entry = 40002;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40002, 0, 0, 100.0, 0, 1, 0, 6, 16, 'Gold'),
(40002, 37711, 0, 12.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Highwayman (40003)
DELETE FROM creature_loot_template WHERE Entry = 40003;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40003, 0, 0, 100.0, 0, 1, 0, 7, 17, 'Gold'),
(40003, 37711, 0, 14.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Wolf (40004)
DELETE FROM creature_loot_template WHERE Entry = 40004;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40004, 0, 0, 100.0, 0, 1, 0, 8, 18, 'Gold'),
(40004, 37711, 0, 16.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Bear (40005)
DELETE FROM creature_loot_template WHERE Entry = 40005;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40005, 0, 0, 100.0, 0, 1, 0, 9, 19, 'Gold'),
(40005, 37711, 0, 18.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Skeleton (40006)
DELETE FROM creature_loot_template WHERE Entry = 40006;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40006, 0, 0, 100.0, 0, 1, 0, 10, 20, 'Gold'),
(40006, 37711, 0, 20.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Ghoul (40007)
DELETE FROM creature_loot_template WHERE Entry = 40007;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40007, 0, 0, 100.0, 0, 1, 0, 11, 21, 'Gold'),
(40007, 37711, 0, 22.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Rogue (40008)
DELETE FROM creature_loot_template WHERE Entry = 40008;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40008, 0, 0, 100.0, 0, 1, 0, 12, 22, 'Gold'),
(40008, 37711, 0, 24.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Assassin (40009)
DELETE FROM creature_loot_template WHERE Entry = 40009;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40009, 0, 0, 100.0, 0, 1, 0, 13, 23, 'Gold'),
(40009, 37711, 0, 26.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Spider (40010)
DELETE FROM creature_loot_template WHERE Entry = 40010;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40010, 0, 0, 100.0, 0, 1, 0, 14, 24, 'Gold'),
(40010, 37711, 0, 28.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Worgen (40011)
DELETE FROM creature_loot_template WHERE Entry = 40011;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40011, 0, 0, 100.0, 0, 1, 0, 15, 25, 'Gold'),
(40011, 37711, 0, 30.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Ogre (40012)
DELETE FROM creature_loot_template WHERE Entry = 40012;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40012, 0, 0, 100.0, 0, 1, 0, 16, 26, 'Gold'),
(40012, 37711, 0, 32.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Ambush Warlock (40013)
DELETE FROM creature_loot_template WHERE Entry = 40013;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40013
-- Ambush Warlock (40013)
DELETE FROM creature_loot_template WHERE Entry = 40013;
INSERT INTO creature_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40013, 0, 0, 100.0, 0, 1, 0, 17, 27, 'Gold'),
(40013, 37711, 0, 34.0, 0, 1, 0, 1, 1, 'Barleybrew Light');

-- Skinning loot for beasts
DELETE FROM skinning_loot_template WHERE Entry = 40004;
INSERT INTO skinning_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40004, 2318, 0, 50.0, 0, 1, 0, 1, 2, 'Light Leather'),
(40004, 2934, 0, 25.0, 0, 1, 0, 1, 1, 'Ruined Leather Scraps');

DELETE FROM skinning_loot_template WHERE Entry = 40005;
INSERT INTO skinning_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40005, 2319, 0, 50.0, 0, 1, 0, 1, 2, 'Medium Leather'),
(40005, 2934, 0, 25.0, 0, 1, 0, 1, 1, 'Ruined Leather Scraps');

DELETE FROM skinning_loot_template WHERE Entry = 40010;
INSERT INTO skinning_loot_template (Entry, Item, Reference, Chance, QuestRequired, LootMode, GroupId, MinCount, MaxCount, Comment) VALUES
(40010, 4234, 0, 50.0, 0, 1, 0, 1, 2, 'Heavy Leather'),
(40010, 2934, 0, 25.0, 0, 1, 0, 1, 1, 'Ruined Leather Scraps');