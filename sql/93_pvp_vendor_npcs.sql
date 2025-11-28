-- ==================================================
-- Project Mortal Warcraft
-- Feature: PvP Vendor NPCs
-- Description: Creates PvP vendor NPCs in Stormwind and Orgrimmar
-- Based on: docs/specs/35-mortal-pvp-vendors-and-rewards.md
-- ==================================================

-- Alliance PvP Vendors (Stormwind - Hall of Champions)
-- Entry Combatant Vendor (P1 gear)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90001, 'Entry Combatant Quartermaster', 'PvP Vendor', 80, 80, 11, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Challenger Vendor (P2-P4 gear)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90002, 'Challenger Quartermaster', 'PvP Vendor', 80, 80, 11, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Elite Vendor (P5-P6 gear)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90003, 'Elite Quartermaster', 'PvP Vendor', 80, 80, 11, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Warfront Quartermaster
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90004, 'Warfront Quartermaster', 'PvP Vendor', 80, 80, 11, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Horde PvP Vendors (Orgrimmar - Hall of Blood)
-- Entry Combatant Vendor (P1 gear)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90011, 'Entry Combatant Quartermaster', 'PvP Vendor', 80, 80, 68, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Challenger Vendor (P2-P4 gear)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90012, 'Challenger Quartermaster', 'PvP Vendor', 80, 80, 68, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Elite Vendor (P5-P6 gear)
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90013, 'Elite Quartermaster', 'PvP Vendor', 80, 80, 68, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Warfront Quartermaster
INSERT INTO `creature_template` (
    `entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`,
    `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`,
    `RangeAttackTime`, `unit_class`, `type`, `HealthModifier`, `ManaModifier`,
    `ArmorModifier`, `DamageModifier`, `AIName`, `ScriptName`
) VALUES (
    90014, 'Warfront Quartermaster', 'PvP Vendor', 80, 80, 68, 128,
    1, 1.14286, 1, 0, 0, 2000,
    2000, 1, 7, 1, 1,
    1, 1, '', ''
)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Register vendors in mortal_pvp_vendors table
INSERT INTO `mortal_pvp_vendors` (`npc_entry`, `vendor_type`, `tier_bands`, `location`, `notes`) VALUES
-- Alliance vendors
(90001, 'entry', 'P1', 'Stormwind - Hall of Champions', 'Entry Combatant vendor for P1 gear'),
(90002, 'challenger', 'P2,P3,P4', 'Stormwind - Hall of Champions', 'Challenger/Duelist vendor for P2-P4 gear'),
(90003, 'elite', 'P5,P6', 'Stormwind - Hall of Champions', 'Elite/Gladiator vendor for P5-P6 gear'),
(90004, 'warfront', NULL, 'Stormwind - Hall of Champions', 'Warfront Quartermaster for siege items'),
-- Horde vendors
(90011, 'entry', 'P1', 'Orgrimmar - Hall of Blood', 'Entry Combatant vendor for P1 gear'),
(90012, 'challenger', 'P2,P3,P4', 'Orgrimmar - Hall of Blood', 'Challenger/Duelist vendor for P2-P4 gear'),
(90013, 'elite', 'P5,P6', 'Orgrimmar - Hall of Blood', 'Elite/Gladiator vendor for P5-P6 gear'),
(90014, 'warfront', NULL, 'Orgrimmar - Hall of Blood', 'Warfront Quartermaster for siege items')
ON DUPLICATE KEY UPDATE `vendor_type` = VALUES(`vendor_type`), `tier_bands` = VALUES(`tier_bands`), `location` = VALUES(`location`), `notes` = VALUES(`notes`);

