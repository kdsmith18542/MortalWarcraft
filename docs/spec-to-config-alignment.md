# Spec-to-Config Alignment Analysis

## Purpose

This document verifies that our spec documents remain accurate after implementing AzerothCore configuration overrides. It confirms that specs (design documents) and configs (implementation details) are properly aligned.

**Date:** 2025-01-XX  
**Status:** ✅ **NO SPEC UPDATES REQUIRED**

---

## Analysis Summary

### ✅ Specs Are Design Documents

**Key Finding:** Spec documents define **WHAT** we want to achieve, not **HOW** we implement it.

- Specs define design goals (150/400 caps, tier scaling, etc.)
- Configs are implementation details that support those goals
- Using AzerothCore configs vs custom code is an implementation choice
- Design goals remain unchanged

---

## Spec-by-Spec Analysis

### Spec 84: Mortal Core Stats and Combat Model

**Design Goal:**
- "We enforce **hard caps (150 per stat, 400 total)** via C++"

**Config Implementation:**
- `Stats.Limits.Enable = 1` (percentage-based fallback)
- Actual 150/400 caps still enforced in C++ (`MortalStats.cpp`)

**Status:** ✅ **NO UPDATE NEEDED**
- Spec is accurate - caps are still enforced in C++
- Config provides percentage-based limits as fallback
- Design goal unchanged

---

### Spec 32: NPC and Encounter Rebalance

**Design Goal:**
- Scale creatures by Mortal tiers (M-T1 to M-T5)
- Shows C++ implementation example (`MortalNormalizeCreature`)

**Config Implementation:**
- `Rate.Creature.*.Damage/HP/SpellDamage = 0.25-0.55` (by tier)
- Configs provide base scaling, C++ can add fine-tuning

**Status:** ✅ **NO UPDATE NEEDED**
- Spec shows one implementation approach (C++)
- Configs are an alternative/complementary approach
- Design goal (tier-based scaling) unchanged
- Spec doesn't prohibit using configs

---

### Spec 01: Progression

**Design Goal:**
- Classless, skill-based progression (no XP)

**Config Implementation:**
- `Rate.XP.* = 0` (all XP disabled)

**Status:** ✅ **NO UPDATE NEEDED**
- Spec defines "no XP" design goal
- Config implements that goal
- Design unchanged

---

### Spec 05, 37: Durability System

**Design Goal:**
- Zone-based durability loss
- Custom decay system

**Config Implementation:**
- `DurabilityLoss.OnDeath = 10` (Green zones)
- `DurabilityLoss.InPvP = 1` (Yellow zones)
- Red zones handled by custom code

**Status:** ✅ **NO UPDATE NEEDED**
- Spec defines zone-based durability design
- Configs handle Green/Yellow zones
- Custom code handles Red zones (as designed)
- Design unchanged

---

### Spec 74: Cursed Artifacts and Extraction System

**Design Goal:**
- Corpse decay timers for extraction raids

**Config Implementation:**
- `Corpse.Decay.NORMAL = 300` (5 minutes)
- `Corpse.Decay.ELITE = 600` (10 minutes)
- `Rate.Corpse.Decay.Looted = 0.5` (half time after looting)

**Status:** ✅ **NO UPDATE NEEDED**
- Spec defines extraction mechanics
- Configs provide base decay timers
- Design unchanged

---

### Spec 06: PvE (Public Dungeons)

**Design Goal:**
- Public dungeons, extraction raids, lockouts

**Config Implementation:**
- `Instance.ResetTimeHour = 4`
- `Instance.UnloadDelay = 1800000`
- `AccountInstancesPerHour = 5`

**Status:** ✅ **NO UPDATE NEEDED**
- Spec defines public dungeon design
- Configs provide instance management
- Design unchanged

---

### Spec 11, 34: PvP Systems (Warfronts, Arena)

**Design Goal:**
- Warfront mechanics, arena rating system

**Config Implementation:**
- `Battleground.*` settings for warfronts
- `Arena.*` settings for arena system

**Status:** ✅ **NO UPDATE NEEDED**
- Specs define PvP design
- Configs provide base mechanics
- Design unchanged

---

## Key Principles

### 1. Specs Define Design, Not Implementation

**Example:**
- **Spec says:** "Enforce 150/400 stat caps"
- **Config does:** Provides percentage-based limits as fallback
- **C++ does:** Enforces actual hard caps
- **Result:** Design goal achieved, implementation flexible

### 2. Configs Support Specs, Don't Change Them

**Example:**
- **Spec says:** "Scale creatures by tier"
- **Config does:** Provides base scaling multipliers
- **C++ can:** Add fine-tuning, overrides, special cases
- **Result:** Design goal achieved, configs simplify implementation

### 3. Hybrid Approach Is Valid

**Example:**
- **Stat caps:** Config (percentage) + C++ (hard caps)
- **Creature scaling:** Config (base) + C++ (fine-tuning)
- **Durability:** Config (Green/Yellow) + C++ (Red zones)
- **Result:** Best of both worlds

---

## Optional Enhancements (Not Required)

While not required, we **could** optionally add notes to specs mentioning config usage:

### Example Addition to Spec 84:

```markdown
## Implementation Notes

**AzerothCore Configuration:**
- `Stats.Limits.Enable = 1` provides percentage-based limits as fallback
- Actual 150/400 hard caps enforced in C++ (`MortalStats.cpp`)
- See `docs/azerothcore-config-usage.md` for details
```

### Example Addition to Spec 32:

```markdown
## Implementation Notes

**AzerothCore Configuration:**
- `Rate.Creature.*.Damage/HP/SpellDamage` provide base tier scaling
- Values: 0.25 (M-T1) to 0.55 (M-T5)
- C++ code can add fine-tuning and special cases
- See `docs/azerothcore-config-usage.md` for details
```

**Recommendation:** These are **optional** and not required. Specs are design documents, and implementation details are documented in `docs/azerothcore-config-usage.md`.

---

## Conclusion

### ✅ No Spec Updates Required

**Reasons:**
1. **Specs are design documents** - They define WHAT, not HOW
2. **Configs support design goals** - They don't change them
3. **Implementation is flexible** - Configs vs C++ is an implementation choice
4. **Design goals unchanged** - All design requirements still met

### Optional: Reference Documentation

If desired, we could add brief notes to relevant specs referencing:
- `docs/azerothcore-config-usage.md` - Config usage guide
- `config/mortal-worldserver-overrides.conf` - Override file
- `docs/azerothcore-capabilities-analysis.md` - Capabilities analysis

But this is **optional** and not required for spec accuracy.

---

## Verification Checklist

- [x] Spec 84 (Stats) - No updates needed
- [x] Spec 32 (NPC Rebalance) - No updates needed
- [x] Spec 01 (Progression) - No updates needed
- [x] Spec 05, 37 (Durability) - No updates needed
- [x] Spec 74 (Extraction) - No updates needed
- [x] Spec 06 (PvE) - No updates needed
- [x] Spec 11, 34 (PvP) - No updates needed
- [x] All other specs - No updates needed

---

## References

- **Config Usage Guide:** `docs/azerothcore-config-usage.md`
- **Config Override File:** `config/mortal-worldserver-overrides.conf`
- **Capabilities Analysis:** `docs/azerothcore-capabilities-analysis.md`
- **Merge Summary:** `docs/worldserver-conf-merge-summary.md`
- **Verification Report:** `docs/worldserver-conf-verification.md`

---

**Conclusion:** ✅ **No spec updates required**  
**Reason:** Specs define design, configs are implementation details  
**Status:** Specs remain accurate and complete

