-- ==================================================
-- Mortal Warcraft – Campaign Creature Templates
-- Spec 62: Core Lore and Campaign Skeleton
-- Target DB: world
-- ==================================================

-- Survivor Alden (99990) - Prologue Quest Giver
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
(99990, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Survivor Alden', 'Tide-Scarred Veteran', '', 0, 1, 1, 0, 35, 2, 
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
    7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `faction` = VALUES(`faction`),
    `npcflag` = VALUES(`npcflag`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`);

-- Training Dummy (99992) - Combat Tutorial
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
(99992, 0, 0, 0, 0, 0, 30721, 0, 0, 0, 'Makeshift Training Dummy', '', '', 0, 1, 1, 0, 35, 0, 
    0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0, 0, 0.0, 0, 0, 1.0, 1.0, 1, 33554432, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0, '', 0, 4, 1.0, 1.0, 1.0, 1.0, 0.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `faction` = VALUES(`faction`),
    `npcflag` = VALUES(`npcflag`),
    `unit_flags` = VALUES(`unit_flags`);

-- Harbor Clerk (99980) - Act I Quest Giver
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
(99980, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Harbor Clerk Serra', 'Port Authority', '', 0, 5, 5, 0, 35, 2, 
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
    7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `faction` = VALUES(`faction`),
    `npcflag` = VALUES(`npcflag`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`);

-- Banker (99983) - Regional Bank NPC
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
(99983, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Banker Tolan', 'Regional Vault Keeper', '', 0, 5, 5, 0, 35, 131072, 
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
    7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `faction` = VALUES(`faction`),
    `npcflag` = VALUES(`npcflag`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`);

-- Shrine Acolyte (99984) - Death/Resurrection Tutorial
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
(99984, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Shrine Acolyte Valeria', 'Order of the Shrine', '', 0, 5, 5, 0, 35, 2, 
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
    7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `faction` = VALUES(`faction`),
    `npcflag` = VALUES(`npcflag`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`);

-- Ether-touched Scavenger (99996) - Prologue Rift Enemy
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
(99996, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Ether-touched Scavenger', '', '', 0, 1, 1, 0, 16, 0, 
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
    7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `faction` = VALUES(`faction`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`);

-- Contract Completion NPC (99982) - Task Board Handler
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
(99982, 0, 0, 0, 0, 0, 19035, 0, 0, 0, 'Quartermaster Rhela', 'Task Board Coordinator', '', 0, 5, 5, 0, 35, 2, 
    1.0, 1.14286, 1.0, 1.0, 20.0, 1.0, 0, 0, 1.0, 2000, 2000, 1.0, 1.0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
    7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1.0, 1.0, 1.0, 1.0, 1.0, 0, 0, 1, 0, 0, 0, '', 0)
ON DUPLICATE KEY UPDATE
    `name` = VALUES(`name`),
    `subname` = VALUES(`subname`),
    `faction` = VALUES(`faction`),
    `npcflag` = VALUES(`npcflag`),
    `minlevel` = VALUES(`minlevel`),
    `maxlevel` = VALUES(`maxlevel`);

