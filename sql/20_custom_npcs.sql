-- ==================================================
-- Project Mortal Warcraft: Custom NPCs
-- Module: mod-mortal-core
-- Feature: Register NPCs for Territory Control and Bounty Board
-- ==================================================

-- Create creature_template_model table if it doesn't exist
CREATE TABLE IF NOT EXISTS `creature_template_model` (
  `CreatureID` int unsigned NOT NULL,
  `Idx` smallint unsigned NOT NULL DEFAULT '0',
  `CreatureDisplayID` int unsigned NOT NULL,
  `DisplayScale` float NOT NULL DEFAULT '1',
  `Probability` float NOT NULL DEFAULT '0',
  `VerifiedBuild` smallint unsigned,
  PRIMARY KEY (`CreatureID`,`Idx`),
  CONSTRAINT creature_template_model_chk_1 CHECK (`Idx` <= 3)
) ENGINE=InnoDB CHARSET=utf8mb4;

-- Note: In newer AzerothCore versions, modelid columns were moved to creature_template_model table
-- This script uses the current table structure

-- Territory Control NPC
-- Entry: 90000 (custom entry ID)
-- Used for territory claiming and management
INSERT IGNORE INTO `creature_template` (
    `entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`,
    `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`,
    `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`,
    `detection_range`, `scale`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`,
    `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`,
    `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`,
    `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`,
    `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`,
    `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`,
    `flags_extra`, `ScriptName`, `VerifiedBuild`
) VALUES (
    90000, 0, 0, 0,  -- entry, difficulty entries
    0, 0,  -- KillCredit
    'Territory Controller', 'Territory Management', '', 0,  -- name, subname, IconName, gossip_menu_id
    1, 1,  -- minlevel, maxlevel
    0, 35,  -- exp, faction (Human - adjust as needed)
    1,  -- npcflag (NPC_FLAG_GOSSIP)
    1.0, 1.14286, 1.0, 1.0,  -- speeds
    20.0, 1.0, 0,  -- detection_range, scale, rank
    0, 1.0,  -- dmgschool, DamageModifier
    2000, 2000,  -- BaseAttackTime, RangeAttackTime
    1.0, 1.0,  -- BaseVariance, RangeVariance
    1,  -- unit_class (Warrior)
    0, 0, 0,  -- unit_flags, unit_flags2, dynamicflags
    0, 0, 0, 0, 0,  -- family, trainer fields
    7, 0, 0,  -- type (Humanoid), type_flags, lootid
    0, 0,  -- pickpocketloot, skinloot
    0, 0,  -- PetSpellDataId, VehicleId
    0, 0,  -- mingold, maxgold
    '', 0,  -- AIName, MovementType
    1.0, 1.0, 1.0, 1.0, 1.0,  -- HoverHeight, HealthModifier, ManaModifier, ArmorModifier, ExperienceModifier
    0, 0, 1,  -- RacialLeader, movementId, RegenHealth
    0, 0,  -- mechanic_immune_mask, spell_school_immune_mask
    0, 'mortal_territory_controller',  -- flags_extra, ScriptName
    12340  -- VerifiedBuild (3.3.5a)
);

-- Add model to creature_template_model table (modelid 1298 = Human Male)
INSERT IGNORE INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(90000, 0, 1298, 1.0, 1.0, 12340);

-- Bounty Board NPC
-- Entry: 90001 (custom entry ID)
-- Used for viewing active bounties and notoriety
INSERT IGNORE INTO `creature_template` (
    `entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`,
    `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`,
    `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`,
    `detection_range`, `scale`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`,
    `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`,
    `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`,
    `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`,
    `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`,
    `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`,
    `flags_extra`, `ScriptName`, `VerifiedBuild`
) VALUES (
    90001, 0, 0, 0,  -- entry, difficulty entries
    0, 0,  -- KillCredit
    'Bounty Board', 'Wanted Posters', '', 0,  -- name, subname, IconName, gossip_menu_id
    1, 1,  -- minlevel, maxlevel
    0, 35,  -- exp, faction (Human - adjust as needed)
    1,  -- npcflag (NPC_FLAG_GOSSIP)
    1.0, 1.14286, 1.0, 1.0,  -- speeds
    20.0, 1.0, 0,  -- detection_range, scale, rank
    0, 1.0,  -- dmgschool, DamageModifier
    2000, 2000,  -- BaseAttackTime, RangeAttackTime
    1.0, 1.0,  -- BaseVariance, RangeVariance
    1,  -- unit_class (Warrior)
    0, 0, 0,  -- unit_flags, unit_flags2, dynamicflags
    0, 0, 0, 0, 0,  -- family, trainer fields
    7, 0, 0,  -- type (Humanoid), type_flags, lootid
    0, 0,  -- pickpocketloot, skinloot
    0, 0,  -- PetSpellDataId, VehicleId
    0, 0,  -- mingold, maxgold
    '', 0,  -- AIName, MovementType
    1.0, 1.0, 1.0, 1.0, 1.0,  -- HoverHeight, HealthModifier, ManaModifier, ArmorModifier, ExperienceModifier
    0, 0, 1,  -- RacialLeader, movementId, RegenHealth
    0, 0,  -- mechanic_immune_mask, spell_school_immune_mask
    0, 'mortal_bounty_board',  -- flags_extra, ScriptName
    12340  -- VerifiedBuild (3.3.5a)
);

-- Add model to creature_template_model table
INSERT IGNORE INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(90001, 0, 1298, 1.0, 1.0, 12340);

-- Squire NPC (for Supporter Status)
-- Entry: 90002 (custom entry ID)
-- Summonable NPC for repairs and grey item sales
INSERT IGNORE INTO `creature_template` (
    `entry`, `difficulty_entry_1`, `difficulty_entry_2`, `difficulty_entry_3`,
    `KillCredit1`, `KillCredit2`,
    `name`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`,
    `exp`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `speed_swim`, `speed_flight`,
    `detection_range`, `scale`, `rank`, `dmgschool`, `DamageModifier`, `BaseAttackTime`,
    `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`,
    `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`,
    `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`,
    `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`,
    `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `ExperienceModifier`,
    `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `spell_school_immune_mask`,
    `flags_extra`, `ScriptName`, `VerifiedBuild`
) VALUES (
    90002, 0, 0, 0,  -- entry, difficulty entries
    0, 0,  -- KillCredit
    'Squire', 'Personal Servant', '', 0,  -- name, subname, IconName, gossip_menu_id
    1, 1,  -- minlevel, maxlevel
    0, 35,  -- exp, faction (Human - adjust as needed)
    130,  -- npcflag (NPC_FLAG_VENDOR | NPC_FLAG_REPAIR)
    1.0, 1.14286, 1.0, 1.0,  -- speeds
    20.0, 1.0, 0,  -- detection_range, scale, rank
    0, 1.0,  -- dmgschool, DamageModifier
    2000, 2000,  -- BaseAttackTime, RangeAttackTime
    1.0, 1.0,  -- BaseVariance, RangeVariance
    1,  -- unit_class (Warrior)
    0, 0, 0,  -- unit_flags, unit_flags2, dynamicflags
    0, 0, 0, 0, 0,  -- family, trainer fields
    7, 0, 0,  -- type (Humanoid), type_flags, lootid
    0, 0,  -- pickpocketloot, skinloot
    0, 0,  -- PetSpellDataId, VehicleId
    0, 0,  -- mingold, maxgold
    '', 0,  -- AIName, MovementType
    1.0, 1.0, 1.0, 1.0, 1.0,  -- HoverHeight, HealthModifier, ManaModifier, ArmorModifier, ExperienceModifier
    0, 0, 1,  -- RacialLeader, movementId, RegenHealth
    0, 0,  -- mechanic_immune_mask, spell_school_immune_mask
    0, 'mortal_squire',  -- flags_extra, ScriptName
    12340  -- VerifiedBuild (3.3.5a)
);

-- Add model to creature_template_model table
INSERT IGNORE INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(90002, 0, 1298, 1.0, 1.0, 12340);
