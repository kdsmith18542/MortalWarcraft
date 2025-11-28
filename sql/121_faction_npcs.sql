-- ==================================================
-- Project Mortal Warcraft
-- Feature: Faction Embassy NPCs
-- Description: Creates NPCs for faction embassies and vendors
-- Based on: docs/specs/51-factions-and-standing-system.md
-- ==================================================

-- Faction Embassy NPCs (4 factions)
INSERT INTO `creature_template` (`entry`, `name`, `subname`, `minlevel`, `maxlevel`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `rank`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `unit_class`, `unit_flags`, `unit_flags2`, `dynamicflags`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `type`, `type_flags`, `lootid`, `pickpocketloot`, `skinloot`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `ExperienceModifier`, `RacialLeader`, `movementId`, `RegenHealth`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`) VALUES
-- Iron Ledger Embassy
(900100, 'Iron Ledger Ambassador', 'Faction Embassy', 80, 80, 11, 128, 1, 1.14286, 1, 0, 0, 2000, 2000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, ''),
-- Order of the Shrine Embassy
(900101, 'Shrine Keeper', 'Faction Embassy', 80, 80, 11, 128, 1, 1.14286, 1, 0, 0, 2000, 2000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, ''),
-- Black Sun Cartel Embassy
(900102, 'Cartel Representative', 'Faction Embassy', 80, 80, 11, 128, 1, 1.14286, 1, 0, 0, 2000, 2000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, ''),
-- Rangers' Pact Embassy
(900103, 'Ranger Liaison', 'Faction Embassy', 80, 80, 11, 128, 1, 1.14286, 1, 0, 0, 2000, 2000, 1, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, '')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `subname` = VALUES(`subname`), `npcflag` = VALUES(`npcflag`);

-- Link NPCs to factions
INSERT INTO `mortal_pvp_vendors` (`npc_entry`, `vendor_type`, `tier_band_min`, `tier_band_max`, `notes`) VALUES
(900100, 'FACTION_IRON_LEDGER', 'P1', 'P6', 'Iron Ledger Embassy'),
(900101, 'FACTION_ORDER_SHRINE', 'P1', 'P6', 'Order of the Shrine Embassy'),
(900102, 'FACTION_BLACK_SUN', 'P1', 'P6', 'Black Sun Cartel Embassy'),
(900103, 'FACTION_RANGERS', 'P1', 'P6', 'Rangers'' Pact Embassy')
ON DUPLICATE KEY UPDATE `notes` = VALUES(`notes`);

-- Summary
SELECT 
    'Faction Embassy NPCs Created' as summary,
    COUNT(*) as total_npcs
FROM creature_template WHERE entry BETWEEN 900100 AND 900103;

