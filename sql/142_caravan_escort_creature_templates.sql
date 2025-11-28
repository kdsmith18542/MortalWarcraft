-- ==================================================
-- Mortal Warcraft – Caravan Escort Creature Templates
-- Caravan Protection System
-- IDs 30001-30003
-- ==================================================

-- Caravan Guard (30001) - Level 40 Humanoid Escort
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
(30001, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Caravan Guard', 'Caravan Protector', '', 0, 40, 40, 0, 35, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0, 0, 0, 'EscortAI', 0, 3, 1.0, 2.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `AIName` = VALUES(`AIName`),
    `HealthModifier` = VALUES(`HealthModifier`);

-- Caravan Protector (30002) - Level 45 Humanoid Escort
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
(30002, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Caravan Protector', 'Elite Guard', '', 0, 45, 45, 0, 35, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0, 0, 0, 'EscortAI', 0, 3, 1.0, 2.5, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `AIName` = VALUES(`AIName`),
    `HealthModifier` = VALUES(`HealthModifier`);

-- Caravan Escort (30003) - Level 50 Humanoid Escort
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
(30003, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Caravan Escort', 'Veteran Guardian', '', 0, 50, 50, 0, 35, 0,
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0, 0, 0, 'EscortAI', 0, 3, 1.0, 3.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`),
    `faction` = VALUES(`faction`),
    `type` = VALUES(`type`),
    `AIName` = VALUES(`AIName`),
    `HealthModifier` = VALUES(`HealthModifier`);