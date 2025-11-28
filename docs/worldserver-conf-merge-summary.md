# Worldserver.conf Merge Summary

## Purpose

This document summarizes the changes made to `azerothcore/bin/etc/worldserver.conf` when merging Mortal-specific configuration overrides.

**Date:** 2025-01-XX  
**Source:** `config/mortal-worldserver-overrides.conf` + `config/worldserver.conf.diff`

---

## Changes Applied

### 1. Experience System (XP Disabled)

**Changed:**
- `Rate.XP.Kill = 1` → `0`
- `Rate.XP.Quest = 1` → `0`
- `Rate.XP.Quest.DF = 1` → `0`
- `Rate.XP.Explore = 1` → `0`
- `Rate.XP.Pet = 1` → `0`
- `Rate.XP.BattlegroundKillAV = 1` → `0`
- `Rate.XP.BattlegroundKillWSG = 1` → `0`
- `Rate.XP.BattlegroundKillAB = 1` → `0`
- `Rate.XP.BattlegroundKillEOTS = 1` → `0`
- `Rate.XP.BattlegroundKillSOTA = 1` → `0`
- `Rate.XP.BattlegroundKillIC = 1` → `0`

**Reason:** Mortal uses classless, skill-based progression (no XP)

---

### 2. Stat Limits (Enabled)

**Changed:**
- `Stats.Limits.Enable = 0` → `1`

**Reason:** Enable stat limits (150/400 caps enforced in C++)

**Note:** Actual hard caps (150 per attribute, 400 total) are enforced in C++ code. These percentage-based limits are used as fallback.

---

### 3. Player Stats Saving (Telemetry)

**Changed:**
- `PlayerSave.Stats.MinLevel = 0` → `1`

**Reason:** Save stats to database for telemetry and analytics

---

### 4. Creature Scaling (Mortal Tiers)

**Changed:**
- `Rate.Creature.Normal.Damage = 1` → `0.25` (M-T1)
- `Rate.Creature.Normal.SpellDamage = 1` → `0.25` (M-T1)
- `Rate.Creature.Normal.HP = 1` → `0.25` (M-T1)
- `Rate.Creature.Elite.Elite.Damage = 1` → `0.30` (M-T2)
- `Rate.Creature.Elite.Elite.SpellDamage = 1` → `0.30` (M-T2)
- `Rate.Creature.Elite.Elite.HP = 1` → `0.30` (M-T2)
- `Rate.Creature.Elite.RARE.Damage = 1` → `0.40` (M-T3)
- `Rate.Creature.Elite.RARE.SpellDamage = 1` → `0.40` (M-T3)
- `Rate.Creature.Elite.RARE.HP = 1` → `0.40` (M-T3)
- `Rate.Creature.Elite.RAREELITE.Damage = 1` → `0.50` (M-T4)
- `Rate.Creature.Elite.RAREELITE.SpellDamage = 1` → `0.50` (M-T4)
- `Rate.Creature.Elite.RAREELITE.HP = 1` → `0.50` (M-T4)
- `Rate.Creature.Elite.WORLDBOSS.Damage = 1` → `0.55` (M-T5)
- `Rate.Creature.Elite.WORLDBOSS.SpellDamage = 1` → `0.55` (M-T5)
- `Rate.Creature.Elite.WORLDBOSS.HP = 1` → `0.55` (M-T5)

**Reason:** Map Mortal tiers (M-T1 to M-T5) to AzerothCore creature ranks for scaling

---

### 5. Durability Loss (PvP Enabled)

**Changed:**
- `DurabilityLoss.InPvP = 0` → `1`

**Reason:** Enable durability loss in PvP (Yellow zones). Red zones handled by custom code.

---

### 6. Death Sickness (Disabled)

**Changed:**
- `Death.SicknessLevel = 11` → `81`

**Reason:** Disable death sickness (we use Shrine system instead)

**Note:** Setting to 81 (above max level 80) effectively disables it.

---

### 7. Corpse Bones (BGs Disabled)

**Changed:**
- `Death.Bones.BattlegroundOrArena = 1` → `0`

**Reason:** Disable corpse bones in BGs/Arenas (Mortal uses different death mechanics)

---

### 8. Corpse Decay (Extended for Extraction)

**Changed:**
- `Corpse.Decay.NORMAL = 60` → `300` (5 minutes)

**Reason:** Extended corpse decay for extraction raid mechanics

**Note:** Other decay times (RARE, ELITE, RAREELITE, WORLDBOSS) already set correctly.

---

### 9. Battleground Statistics (Enabled)

**Changed:**
- `Battleground.StoreStatistics.Enable = 0` → `1`

**Reason:** Enable BG statistics for warfront tracking

---

### 10. Random Dungeon Finder (Disabled)

**Added:**
- `RandomDungeonFinder.Enable = 0` (uncommented and set)

**Reason:** RDF teleportation bypasses risk mechanics; role checks fail in classless system

**Source:** `config/worldserver.conf.diff`

---

## Settings Already Correct

These settings were already set correctly and didn't need changes:

- `Stats.Limits.Dodge = 95.0` ✅
- `Stats.Limits.Parry = 95.0` ✅
- `Stats.Limits.Block = 95.0` ✅
- `Stats.Limits.Crit = 95.0` ✅
- `PlayerSave.Stats.SaveOnlyOnLogout = 1` ✅
- `Death.CorpseReclaimDelay.PvP = 1` ✅
- `Death.CorpseReclaimDelay.PvE = 1` ✅
- `Death.Bones.World = 1` ✅
- `Corpse.Decay.RARE = 300` ✅
- `Corpse.Decay.ELITE = 300` ✅
- `Corpse.Decay.RAREELITE = 300` ✅
- `Corpse.Decay.WORLDBOSS = 3600` ✅
- `Rate.Corpse.Decay.Looted = 0.5` ✅
- `DurabilityLoss.OnDeath = 10` ✅
- `DurabilityLossChance.*` (all correct) ✅
- `SkillGain.*` (all correct) ✅
- `Rate.Skill.Discovery = 1` ✅
- `SkillChance.*` (all correct) ✅
- `AlwaysMaxSkillForLevel = 0` ✅
- `AlwaysMaxWeaponSkill = 0` ✅
- `Visibility.*` (all correct) ✅
- `Instance.*` (all correct) ✅
- `Rate.InstanceResetTime = 1` ✅
- `AccountInstancesPerHour = 5` ✅
- `Battleground.*` (rewards, respawn, etc. all correct) ✅
- `Arena.*` (all correct) ✅
- `Rate.Reputation.*` (all correct) ✅
- `Rate.Drop.*` (all correct) ✅
- `Rate.RewardQuestMoney = 1` ✅
- `Quests.*` (all correct) ✅
- `MailDeliveryDelay = 3600` ✅
- `LevelReq.Mail = 1` ✅
- `ChatFlood.*` (all correct) ✅
- `ChatStrictLinkChecking.*` (all correct) ✅
- `ChatFakeMessagePreventing = 1` ✅
- `Rate.Honor = 1` ✅
- `Rate.ArenaPoints = 1` ✅
- `Arena.LegacyArenaPoints = 0` ✅
- `Rate.Pet.LevelXP = 0.05` ✅
- `Pet.RankMod.Health = 1` ✅
- `MaxGroupXPDistance = 74` ✅
- `MortalOverhaul.*` (all already set) ✅

---

## Settings Not Changed (By Design)

These settings remain at default values because they're handled by custom code:

- **Stat Caps (150/400):** Enforced in C++ (`MortalStats.cpp`)
- **Red Zone Durability:** Handled by custom full-loot system
- **Skill-Based Progression:** Handled by custom progression system
- **Faction Standing:** Uses reputation system but with custom logic
- **Regional Economy:** Uses mail delays but with custom restrictions

---

## Verification Checklist

After merging, verify:

- [x] All XP rates set to 0
- [x] Stat limits enabled
- [x] Creature scaling set to Mortal tier values
- [x] Durability loss in PvP enabled
- [x] Death sickness disabled
- [x] Corpse decay extended for extraction
- [x] BG statistics enabled
- [x] Random Dungeon Finder disabled
- [x] All other settings verified

---

## Next Steps

1. **Test Configuration:**
   - Start worldserver
   - Verify no errors on startup
   - Test each system (XP disabled, creature scaling, etc.)

2. **Documentation:**
   - Update `docs/azerothcore-config-usage.md` if needed
   - Document any issues found during testing

3. **Balance Tuning:**
   - Adjust creature scaling values based on gameplay
   - Tune skill gain rates
   - Adjust durability loss rates

---

## References

- **Override File:** `config/mortal-worldserver-overrides.conf`
- **Diff File:** `config/worldserver.conf.diff`
- **Config Usage Guide:** `docs/azerothcore-config-usage.md`
- **Capabilities Analysis:** `docs/azerothcore-capabilities-analysis.md`

---

**Document Status:** ✅ Complete  
**Last Updated:** 2025-01-XX  
**Verified By:** Design Team

