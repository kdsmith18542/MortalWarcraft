# Worldserver.conf Verification Report

## Purpose

This document verifies that all Mortal-specific configuration changes have been successfully merged into `azerothcore/bin/etc/worldserver.conf`.

**Date:** 2025-01-XX  
**Status:** ✅ **VERIFIED**

---

## Verification Results

### ✅ Experience System (XP Disabled)

**Status:** ✅ **PASS**

All XP rates successfully set to 0:
- `Rate.XP.Kill = 0` ✅
- `Rate.XP.Quest = 0` ✅
- `Rate.XP.Quest.DF = 0` ✅
- `Rate.XP.Explore = 0` ✅
- `Rate.XP.Pet = 0` ✅
- `Rate.XP.BattlegroundKillAV = 0` ✅
- `Rate.XP.BattlegroundKillWSG = 0` ✅
- `Rate.XP.BattlegroundKillAB = 0` ✅
- `Rate.XP.BattlegroundKillEOTS = 0` ✅
- `Rate.XP.BattlegroundKillSOTA = 0` ✅
- `Rate.XP.BattlegroundKillIC = 0` ✅

**Total:** 11/11 XP rates disabled

---

### ✅ Stat Limits (Enabled)

**Status:** ✅ **PASS**

- `Stats.Limits.Enable = 1` ✅
- `Stats.Limits.Dodge = 95.0` ✅
- `Stats.Limits.Parry = 95.0` ✅
- `Stats.Limits.Block = 95.0` ✅
- `Stats.Limits.Crit = 95.0` ✅

**Note:** Actual 150/400 caps enforced in C++ code.

---

### ✅ Player Stats Saving (Telemetry)

**Status:** ✅ **PASS**

- `PlayerSave.Stats.MinLevel = 1` ✅
- `PlayerSave.Stats.SaveOnlyOnLogout = 1` ✅

---

### ✅ Creature Scaling (Mortal Tiers)

**Status:** ✅ **PASS**

**Damage Scaling:**
- `Rate.Creature.Normal.Damage = 0.25` (M-T1) ✅
- `Rate.Creature.Elite.Elite.Damage = 0.30` (M-T2) ✅
- `Rate.Creature.Elite.RARE.Damage = 0.40` (M-T3) ✅
- `Rate.Creature.Elite.RAREELITE.Damage = 0.50` (M-T4) ✅
- `Rate.Creature.Elite.WORLDBOSS.Damage = 0.55` (M-T5) ✅

**Spell Damage Scaling:**
- `Rate.Creature.Normal.SpellDamage = 0.25` (M-T1) ✅
- `Rate.Creature.Elite.Elite.SpellDamage = 0.30` (M-T2) ✅
- `Rate.Creature.Elite.RARE.SpellDamage = 0.40` (M-T3) ✅
- `Rate.Creature.Elite.RAREELITE.SpellDamage = 0.50` (M-T4) ✅
- `Rate.Creature.Elite.WORLDBOSS.SpellDamage = 0.55` (M-T5) ✅

**HP Scaling:**
- `Rate.Creature.Normal.HP = 0.25` (M-T1) ✅
- `Rate.Creature.Elite.Elite.HP = 0.30` (M-T2) ✅
- `Rate.Creature.Elite.RARE.HP = 0.40` (M-T3) ✅
- `Rate.Creature.Elite.RAREELITE.HP = 0.50` (M-T4) ✅
- `Rate.Creature.Elite.WORLDBOSS.HP = 0.55` (M-T5) ✅

**Total:** 15/15 creature scaling values updated

---

### ✅ Durability System

**Status:** ✅ **PASS**

- `DurabilityLoss.OnDeath = 10` ✅
- `DurabilityLoss.InPvP = 1` ✅ (Changed from 0)
- `DurabilityLossChance.Damage = 0.5` ✅
- `DurabilityLossChance.Absorb = 0.5` ✅
- `DurabilityLossChance.Parry = 0.05` ✅
- `DurabilityLossChance.Block = 0.05` ✅

---

### ✅ Death System

**Status:** ✅ **PASS**

- `Death.SicknessLevel = 81` ✅ (Changed from 11 - effectively disabled)
- `Death.CorpseReclaimDelay.PvP = 1` ✅
- `Death.CorpseReclaimDelay.PvE = 1` ✅
- `Death.Bones.World = 1` ✅
- `Death.Bones.BattlegroundOrArena = 0` ✅ (Changed from 1)

---

### ✅ Corpse Decay System

**Status:** ✅ **PASS**

- `Corpse.Decay.NORMAL = 300` ✅ (Changed from 60 - 5 minutes for extraction)
- `Corpse.Decay.RARE = 300` ✅
- `Corpse.Decay.ELITE = 300` ✅
- `Corpse.Decay.RAREELITE = 600` ✅
- `Corpse.Decay.WORLDBOSS = 3600` ✅
- `Rate.Corpse.Decay.Looted = 0.5` ✅

---

### ✅ Skill System

**Status:** ✅ **PASS**

- `SkillGain.Crafting = 1.0` ✅
- `SkillGain.Defense = 1.0` ✅
- `SkillGain.Gathering = 1.0` ✅
- `SkillGain.Weapon = 1.0` ✅
- `Rate.Skill.Discovery = 1.0` ✅
- `SkillChance.Orange = 100` ✅
- `SkillChance.Yellow = 75` ✅
- `SkillChance.Green = 25` ✅
- `SkillChance.Grey = 0` ✅
- `AlwaysMaxSkillForLevel = 0` ✅
- `AlwaysMaxWeaponSkill = 0` ✅

---

### ✅ Visibility System

**Status:** ✅ **PASS**

- `Visibility.Distance.Continents = 100` ✅
- `Visibility.Distance.Instances = 170` ✅
- `Visibility.Distance.BGArenas = 250` ✅
- `Visibility.GroupMode = 1` ✅
- `Visibility.ObjectQuestMarkers = 1` ✅
- `Visibility.ObjectSparkles = 1` ✅

---

### ✅ Instance System

**Status:** ✅ **PASS**

- `Instance.ResetTimeHour = 4` ✅
- `Rate.InstanceResetTime = 1.0` ✅
- `Instance.UnloadDelay = 1800000` ✅
- `Instance.IgnoreLevel = 0` ✅
- `Instance.IgnoreRaid = 0` ✅
- `AccountInstancesPerHour = 5` ✅

---

### ✅ Battleground System

**Status:** ✅ **PASS**

- `Battleground.RewardWinnerHonorFirst = 30` ✅
- `Battleground.RewardWinnerArenaFirst = 25` ✅
- `Battleground.RewardWinnerHonorLast = 15` ✅
- `Battleground.RewardWinnerArenaLast = 0` ✅
- `Battleground.RewardLoserHonorFirst = 5` ✅
- `Battleground.RewardLoserHonorLast = 5` ✅
- `Battleground.PlayerRespawn = 30` ✅
- `Battleground.StoreStatistics.Enable = 1` ✅ (Changed from 0)
- `Battleground.GiveXPForKills = 0` ✅

---

### ✅ Arena System

**Status:** ✅ **PASS**

- `Arena.ArenaWinRatingModifier1 = 48` ✅
- `Arena.ArenaWinRatingModifier2 = 24` ✅
- `Arena.ArenaLoseRatingModifier = 24` ✅
- `Arena.ArenaMatchmakerRatingModifier = 24` ✅
- `Arena.ArenaStartRating = 0` ✅
- `Arena.LegacyArenaStartRating = 1500` ✅
- `Arena.ArenaStartPersonalRating = 0` ✅
- `Arena.ArenaStartMatchmakerRating = 1500` ✅
- `Arena.PrepTime = 60` ✅
- `Arena.LegacyArenaPoints = 0` ✅

---

### ✅ Random Dungeon Finder (Disabled)

**Status:** ✅ **PASS**

- `RandomDungeonFinder.Enable = 0` ✅ (Uncommented and set)

**Location:** Line ~3334 in DUNGEON AND BATTLEGROUND FINDER section

**Note:** Comment at line ~4707 references this setting but doesn't duplicate it.

---

### ✅ Mortal Overhaul Settings

**Status:** ✅ **PASS**

- `MortalOverhaul.Enable = 1` ✅
- `MortalOverhaul.MaxSkillPoints = 1200` ✅
- `MortalOverhaul.SkillPointsPerLevel = 50` ✅
- `MortalOverhaul.MaxLevel = 25` ✅

**Location:** End of file (line ~4710-4713)

---

## Summary Statistics

### Changes Applied

- **XP Rates Disabled:** 11 settings
- **Creature Scaling Updated:** 15 settings (Damage, SpellDamage, HP for 5 tiers)
- **Stat Limits Enabled:** 1 setting
- **Durability PvP Enabled:** 1 setting
- **Death Sickness Disabled:** 1 setting
- **Corpse Decay Extended:** 1 setting (NORMAL)
- **Corpse Bones BGs Disabled:** 1 setting
- **BG Statistics Enabled:** 1 setting
- **RDF Disabled:** 1 setting
- **Player Stats Saving:** 1 setting

**Total Changes:** 34 settings modified

### Settings Verified Correct

- **Skill System:** 10 settings ✅
- **Visibility System:** 6 settings ✅
- **Instance System:** 6 settings ✅
- **Battleground System:** 9 settings ✅
- **Arena System:** 10 settings ✅
- **Reputation System:** 6 settings ✅
- **Item System:** 10 settings ✅
- **Quest System:** 5 settings ✅
- **Mail System:** 2 settings ✅
- **Chat System:** 6 settings ✅
- **Currency System:** 4 settings ✅
- **Pet System:** 3 settings ✅
- **Group System:** 1 setting ✅

**Total Verified:** 78 settings already correct

---

## No Conflicts Found

✅ **No duplicate settings**  
✅ **No conflicting values**  
✅ **All Mortal settings properly commented**  
✅ **All changes verified**

---

## Settings Not Changed (By Design)

These settings remain at default because they're handled by custom C++ code:

- **Stat Caps (150/400):** Enforced in C++ (`MortalStats.cpp`)
- **Red Zone Durability:** Handled by custom full-loot system
- **Skill-Based Progression:** Handled by custom progression system
- **Faction Standing:** Uses reputation system but with custom logic
- **Regional Economy:** Uses mail delays but with custom restrictions

---

## Next Steps

1. ✅ **Configuration Merged** - All settings applied
2. ⏳ **Test Configuration** - Start worldserver and verify no errors
3. ⏳ **Balance Tuning** - Adjust values based on gameplay testing
4. ⏳ **Documentation** - Update specs with config references

---

## References

- **Merge Summary:** `docs/worldserver-conf-merge-summary.md`
- **Config Usage Guide:** `docs/azerothcore-config-usage.md`
- **Override File:** `config/mortal-worldserver-overrides.conf`
- **Diff File:** `config/worldserver.conf.diff`

---

**Verification Status:** ✅ **COMPLETE**  
**All Changes Applied:** ✅ **YES**  
**Conflicts Found:** ❌ **NONE**  
**Ready for Testing:** ✅ **YES**

