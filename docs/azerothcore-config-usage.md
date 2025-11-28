# AzerothCore Configuration Usage for Mortal Warcraft

## Purpose

This document explains how Mortal Warcraft uses AzerothCore's built-in configuration options, which settings we leverage, which we override, and which we ignore.

---

## Configuration Files

### 1. Main Configuration File

**Location:** `azerothcore/bin/etc/worldserver.conf`

This is the main AzerothCore configuration file. It contains all default settings.

### 2. Mortal Override File

**Location:** `config/mortal-worldserver-overrides.conf`

This file contains Mortal-specific configuration overrides. It should be merged into or included with the main `worldserver.conf`.

### 3. Existing Diff File

**Location:** `config/worldserver.conf.diff`

Contains additional Mortal-specific settings that need to be added to `worldserver.conf`.

---

## How to Apply Mortal Configuration

### Method 1: Manual Merge (Recommended)

1. Open `azerothcore/bin/etc/worldserver.conf`
2. Open `config/mortal-worldserver-overrides.conf`
3. Copy relevant sections from override file to main config
4. Ensure no conflicts with existing settings

### Method 2: Include File (If Supported)

If AzerothCore supports include files, you can add:

```ini
# Include Mortal overrides
#include "config/mortal-worldserver-overrides.conf"
```

### Method 3: Apply Diff

1. Review `config/worldserver.conf.diff`
2. Manually add those settings to `worldserver.conf`

---

## Configuration Categories

### ✅ Used Configurations

These AzerothCore configs are **actively used** by Mortal:

#### Experience System
- **Status:** Disabled (all XP rates = 0)
- **Reason:** Mortal uses classless, skill-based progression
- **Settings:**
  - `Rate.XP.Kill = 0`
  - `Rate.XP.Quest = 0`
  - `Rate.XP.Explore = 0`
  - `Rate.XP.Pet = 0`

#### Stat Limits
- **Status:** Enabled (percentage-based caps)
- **Reason:** Native stat capping support
- **Note:** Actual 150/400 caps enforced in C++ code
- **Settings:**
  - `Stats.Limits.Enable = 1`
  - `Stats.Limits.Dodge = 95.0`
  - `Stats.Limits.Parry = 95.0`
  - `Stats.Limits.Block = 95.0`
  - `Stats.Limits.Crit = 95.0`

#### Creature Scaling
- **Status:** Used for tier-based scaling
- **Reason:** Map Mortal tiers (M-T1 to M-T5) to creature ranks
- **Settings:**
  - `Rate.Creature.Normal.Damage = 0.25` (M-T1)
  - `Rate.Creature.Elite.Elite.Damage = 0.30` (M-T2)
  - `Rate.Creature.Elite.RARE.Damage = 0.40` (M-T3)
  - `Rate.Creature.Elite.RAREELITE.Damage = 0.50` (M-T4)
  - `Rate.Creature.Elite.WORLDBOSS.Damage = 0.55` (M-T5)

#### Durability Loss
- **Status:** Used for zone-based penalties
- **Reason:** Green/Yellow zone durability loss
- **Note:** Red zones handled by custom code
- **Settings:**
  - `DurabilityLoss.OnDeath = 10` (Green zones)
  - `DurabilityLoss.InPvP = 1` (Yellow zones)

#### Corpse Decay
- **Status:** Used for extraction raids
- **Reason:** Timed corpse decay for extraction mechanics
- **Settings:**
  - `Corpse.Decay.NORMAL = 300` (5 minutes)
  - `Corpse.Decay.ELITE = 600` (10 minutes)
  - `Rate.Corpse.Decay.Looted = 0.5` (Half time after looting)

#### Skill Gain Rates
- **Status:** Used for skill progression tuning
- **Reason:** Control skill gain speed
- **Settings:**
  - `SkillGain.Crafting = 1.0`
  - `SkillGain.Gathering = 1.0`
  - `SkillGain.Weapon = 1.0`

#### Visibility Settings
- **Status:** Used for Red Zone fog-of-war
- **Reason:** Native visibility control
- **Settings:**
  - `Visibility.Distance.Continents = 100`
  - `Visibility.GroupMode = 1`

#### Instance Settings
- **Status:** Used for extraction raids
- **Reason:** Lockout and reset management
- **Settings:**
  - `Instance.ResetTimeHour = 4`
  - `Instance.UnloadDelay = 1800000`

#### Battleground Settings
- **Status:** Used for warfront mechanics
- **Reason:** Reward and respawn configuration
- **Settings:**
  - `Battleground.RewardWinnerHonorFirst = 30`
  - `Battleground.PlayerRespawn = 30`

#### Arena Settings
- **Status:** Used for Mortal arena system
- **Reason:** Rating and reward configuration
- **Settings:**
  - `Arena.ArenaWinRatingModifier1 = 48`
  - `Arena.ArenaStartRating = 0`

#### Reputation Rates
- **Status:** Used for faction standing gains
- **Reason:** Tune faction standing progression
- **Settings:**
  - `Rate.Reputation.Gain = 1.0`

#### Mail Delays
- **Status:** Used for regional mail simulation
- **Reason:** Simulate regional restrictions
- **Settings:**
  - `MailDeliveryDelay = 3600`

#### Chat Protection
- **Status:** Used for chat security
- **Reason:** Flood protection and link checking
- **Settings:**
  - `ChatFlood.MessageCount = 10`
  - `ChatStrictLinkChecking.Severity = 0`

---

### ⚠️ Overridden Configurations

These AzerothCore configs are **overridden** by custom Mortal code:

#### Stat Caps (150/400)
- **AzerothCore:** Percentage-based caps (95%)
- **Mortal:** Hard caps (150 per attribute, 400 total)
- **Implementation:** C++ code in `MortalStats.cpp`
- **Config:** `Stats.Limits.*` used as fallback

#### Red Zone Durability
- **AzerothCore:** `DurabilityLoss.InPvP`
- **Mortal:** Custom full-loot system
- **Implementation:** C++ code in durability system
- **Config:** `DurabilityLoss.*` used for Green/Yellow zones only

#### Skill-Based Progression
- **AzerothCore:** XP-based leveling
- **Mortal:** Skill-based progression (no XP)
- **Implementation:** C++ code in progression system
- **Config:** All XP rates disabled

#### Faction Standing
- **AzerothCore:** Standard reputation system
- **Mortal:** Custom faction standing system
- **Implementation:** C++ code + Lua scripts
- **Config:** `Rate.Reputation.*` used for tuning

#### Regional Economy
- **AzerothCore:** Global mail system
- **Mortal:** Regional-only mail
- **Implementation:** C++ code + Lua scripts
- **Config:** `MailDeliveryDelay` used for simulation

---

### ❌ Ignored Configurations

These AzerothCore configs are **not used** by Mortal:

#### Auction House
- **Reason:** Replaced by market stalls (spec 04)
- **Config:** All auction house settings ignored

#### Standard Factions
- **Reason:** Replaced by Mortal faction system (spec 51, 86)
- **Config:** Faction interaction settings ignored (except for compatibility)

#### Standard Quests
- **Reason:** Replaced by task board system (spec 76)
- **Config:** Quest settings used minimally (for task board compatibility)

#### Talent System
- **Reason:** Replaced by skill/rune system (spec 01, 53)
- **Config:** Talent-related settings ignored

#### Class System
- **Reason:** Mortal is classless (spec 01)
- **Config:** Class-related settings ignored

---

## Configuration Rationale

### Why Use Config vs Custom Code?

#### Use Config When:
1. **Simple tuning** - Easy to adjust without code changes
2. **Native support** - AzerothCore already handles it
3. **Compatibility** - Works with existing systems
4. **Performance** - Native implementation is faster

#### Use Custom Code When:
1. **Complex logic** - Requires custom algorithms
2. **Integration** - Needs to integrate with multiple systems
3. **Security** - Requires server-side validation
4. **Design requirements** - Doesn't match AzerothCore defaults

---

## Configuration Testing

### Testing Checklist

Before applying Mortal configuration:

1. **Backup original config**
   ```bash
   cp azerothcore/bin/etc/worldserver.conf azerothcore/bin/etc/worldserver.conf.backup
   ```

2. **Test each category**
   - Experience: Verify no XP gains
   - Stats: Verify stat limits work
   - Creatures: Verify scaling applies correctly
   - Durability: Verify loss on death
   - Corpse decay: Verify timers work
   - Visibility: Verify fog-of-war works

3. **Integration testing**
   - Test with custom C++ code
   - Test with Lua scripts
   - Test with AIO UI system

4. **Performance testing**
   - Monitor server performance
   - Check for config-related lag
   - Verify no conflicts

---

## Configuration Maintenance

### Regular Updates

- **Quarterly review:** Check for new AzerothCore config options
- **After updates:** Verify configs still work after AzerothCore updates
- **Balance tuning:** Adjust rates based on gameplay feedback

### Documentation Updates

- **Update this document** when adding new configs
- **Update override file** when changing values
- **Update specs** when config affects design

---

## Troubleshooting

### Common Issues

#### Config Not Applied
- **Symptom:** Settings don't take effect
- **Solution:** Restart worldserver, check config file syntax

#### Conflicts with Custom Code
- **Symptom:** Custom code overrides config
- **Solution:** Review C++ code, ensure config is read first

#### Performance Issues
- **Symptom:** Server lag after config changes
- **Solution:** Review rate multipliers, test incrementally

---

## References

- **AzerothCore Config Analysis:** `docs/azerothcore-capabilities-analysis.md`
- **Mortal Override File:** `config/mortal-worldserver-overrides.conf`
- **Stat System Spec:** `docs/specs/84-mortal-core-stats-and-combat-model.md`
- **Creature Rebalance Spec:** `docs/specs/32-npc-and-encounter-rebalance.md`
- **AzerothCore Documentation:** [Official Wiki](https://www.azerothcore.org/wiki/)

---

**Document Status:** ✅ Complete  
**Last Updated:** 2025-01-XX  
**Maintained By:** Design Team

