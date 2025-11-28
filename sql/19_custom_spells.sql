-- ==================================================
-- Project Mortal Warcraft: Custom Spells
-- Module: mod-mortal-core
-- Feature: Register custom spells for Mortal Overhaul features
-- ==================================================

-- Create spell_custom_attr table if it doesn't exist
CREATE TABLE IF NOT EXISTS `spell_custom_attr` (
  `spell_id` int unsigned NOT NULL DEFAULT '0' COMMENT 'spell id',
  `attributes` int unsigned NOT NULL DEFAULT '0' COMMENT 'SpellCustomAttributes',
  PRIMARY KEY (`spell_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='SpellInfo custom attributes';

-- Note: Spells in WoW 3.3.5a are defined in Spell.dbc (client-side)
-- These SQL entries configure server-side behavior for existing or custom spell IDs
-- For full implementation, you would need to modify Spell.dbc or use existing spell IDs

-- Spell 50001: New Player Protection (Blue Shield)
-- Uses existing visual spell or create custom aura
INSERT IGNORE INTO `spell_custom_attr` (`spell_id`, `attributes`) VALUES
(50001, 0);

-- Spell 50002: Squire Summon (Supporter Status)
-- Summonable NPC for repairs and grey item sales
INSERT IGNORE INTO `spell_custom_attr` (`spell_id`, `attributes`) VALUES
(50002, 0);

-- Spell 50003: Rested Speed (Supporter Status)
-- Double skill gain rate when rested
INSERT IGNORE INTO `spell_custom_attr` (`spell_id`, `attributes`) VALUES
(50003, 0);

-- Spell 50004: Gold Name Aura (Supporter Status)
-- Visual indicator for premium accounts
INSERT IGNORE INTO `spell_custom_attr` (`spell_id`, `attributes`) VALUES
(50004, 0);

-- Spell 50010: Ranked Duel
-- Initiates a ranked duel (no item loss)
INSERT IGNORE INTO `spell_custom_attr` (`spell_id`, `attributes`) VALUES
(50010, 0);

-- Spell 50020: Brace (Active Combat)
-- Universal defensive ability: 50% damage reduction for 0.75s, 5s cooldown
-- Off-GCD ability
INSERT IGNORE INTO `spell_custom_attr` (`spell_id`, `attributes`) VALUES
(50020, 0);

-- Create playercreateinfo_spell_custom table if it doesn't exist
CREATE TABLE IF NOT EXISTS `playercreateinfo_spell_custom` (
  `racemask` int unsigned NOT NULL DEFAULT '0',
  `classmask` int unsigned NOT NULL DEFAULT '0',
  `Spell` int unsigned NOT NULL DEFAULT '0',
  `Note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`racemask`,`classmask`,`Spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Grant Brace spell to all players on character creation
-- Using racemask=0 and classmask=0 means all races and classes
INSERT IGNORE INTO `playercreateinfo_spell_custom` (`racemask`, `classmask`, `Spell`, `Note`) VALUES
(0, 0, 50020, 'Brace - Universal defensive ability (all races/classes)');

-- Spell Proc Data (if needed for custom behavior)
-- INSERT IGNORE INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
-- (50020, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- Note: Full spell implementation requires:
-- 1. Spell.dbc modification (client-side) OR
-- 2. Using existing spell IDs and modifying their behavior via Lua
-- 3. Spell visual effects (auras, icons) defined in client files

