-- Fix for Issue #23326: Thunderstorm Crits don't grant Clearcasting
-- Problem: Thunderstorm critical strikes should grant Elemental Focus (Clearcasting) but don't
-- Expected: Like other nature spells, Thunderstorm crits should proc Clearcasting talent
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/23326

-- Thunderstorm spell IDs:
-- 51490 (Rank 1), 59006 (Rank 2), 59007 (Rank 3), 59008 (Rank 4)

-- Elemental Focus (Clearcasting) proc spell: 16246

-- Ensure Thunderstorm can proc spell effects properly
UPDATE `spell_dbc` SET
    `ProcFlags` = 0x00010000,  -- PROC_FLAG_DONE_SPELL_MAGIC_DMG_CLASS_POS
    `ProcChance` = 101,  -- Always check for proc
    `AttributesEx` = `AttributesEx` | 0x00000020,  -- SPELL_ATTR1_CANT_BE_REFLECTED
    `AttributesEx3` = `AttributesEx3` | 0x00100000  -- SPELL_ATTR3_CAN_PROC_WITH_TRIGGERED
WHERE `Id` IN (51490, 59006, 59007, 59008);

-- Add spell proc event for Thunderstorm to trigger Clearcasting
DELETE FROM `spell_proc_event` WHERE `entry` IN (51490, 59006, 59007, 59008);
INSERT INTO `spell_proc_event` (`entry`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `procFlags`, `procEx`, `ppmRate`, `CustomChance`, `Cooldown`) VALUES
(51490, 8, 11, 0x00000000, 0x00000000, 0x00000800, 0x00010000, 0x0002, 0, 0, 0),
(59006, 8, 11, 0x00000000, 0x00000000, 0x00000800, 0x00010000, 0x0002, 0, 0, 0),
(59007, 8, 11, 0x00000000, 0x00000000, 0x00000800, 0x00010000, 0x0002, 0, 0, 0),
(59008, 8, 11, 0x00000000, 0x00000000, 0x00000800, 0x00010000, 0x0002, 0, 0, 0);

-- Verification query
-- SELECT Id, SpellName, ProcFlags, ProcChance FROM spell_dbc WHERE Id IN (51490, 59006, 59007, 59008);
-- SELECT * FROM spell_proc_event WHERE entry IN (51490, 59006, 59007, 59008);
