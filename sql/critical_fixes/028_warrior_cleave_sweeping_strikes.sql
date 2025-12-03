-- Fix for Issue #22427: Warrior Cleave does not interact with Sweeping Strikes
-- Problem: Cleave doesn't consume 2 Sweeping Strikes stacks as it should
-- Expected: Cleave should consume 2 stacks (one per target hit) and trigger SS on both
-- Source: https://github.com/azerothcore/azerothcore-wotlk/issues/22427

-- Cleave spell IDs: 845, 7369, 11608, 11609, 20569, 25231, 47519, 47520
-- Sweeping Strikes spell ID: 12328 (buff)
-- Glyph of Cleave: 54934

-- Add spell script to handle Sweeping Strikes interaction
DELETE FROM `spell_script_names` WHERE `spell_id` IN (845, 7369, 11608, 11609, 20569, 25231, 47519, 47520) AND `ScriptName` = 'spell_warr_cleave_sweeping_strikes';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(845, 'spell_warr_cleave_sweeping_strikes'),
(7369, 'spell_warr_cleave_sweeping_strikes'),
(11608, 'spell_warr_cleave_sweeping_strikes'),
(11609, 'spell_warr_cleave_sweeping_strikes'),
(20569, 'spell_warr_cleave_sweeping_strikes'),
(25231, 'spell_warr_cleave_sweeping_strikes'),
(47519, 'spell_warr_cleave_sweeping_strikes'),
(47520, 'spell_warr_cleave_sweeping_strikes');

-- Ensure Cleave can proc Sweeping Strikes properly
UPDATE `spell_dbc` SET
    `ProcFlags` = 0x00000004,  -- PROC_FLAG_DONE_MELEE_AUTO_ATTACK
    `procChance` = 101,  -- Always proc
    `AttributesEx3` = `AttributesEx3` | 0x00100000  -- SPELL_ATTR3_CAN_PROC_WITH_TRIGGERED
WHERE `Id` IN (845, 7369, 11608, 11609, 20569, 25231, 47519, 47520);

-- Update Sweeping Strikes to handle Cleave specially
UPDATE `spell_dbc` SET
    `procCharges` = 10,  -- Allow for extra charge consumption
    `ProcFlags` = 0x00000004  -- PROC_FLAG_DONE_MELEE_AUTO_ATTACK
WHERE `Id` = 12328;

-- Add proc event for Cleave interaction
DELETE FROM `spell_proc_event` WHERE `entry` IN (845, 7369, 11608, 11609, 20569, 25231, 47519, 47520);
INSERT INTO `spell_proc_event` (`entry`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `procFlags`, `procEx`, `ppmRate`, `CustomChance`, `Cooldown`) VALUES
(845, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(7369, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(11608, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(11609, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(20569, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(25231, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(47519, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0),
(47520, 1, 4, 0x00000001, 0x00000000, 0x00000000, 0x00000004, 0x0000, 0, 100, 0);

-- Note: Full fix requires C++ implementation to consume 2 SS charges per Cleave
-- and trigger SS on each Cleave target individually
-- This SQL prepares the database for the spell script

-- Verification query
-- SELECT Id, SpellName, ProcFlags, procChance FROM spell_dbc WHERE Id IN (845, 12328);
-- SELECT * FROM spell_proc_event WHERE entry IN (845, 7369, 11608, 11609);
