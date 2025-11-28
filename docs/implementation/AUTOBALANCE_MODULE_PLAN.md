# Autobalance Module Plan - From Specs

**Date:** 2025-01-XX  
**Status:** 📋 **PLANNED** (Not yet implemented)

---

## Summary

The specs reference **`mod-autobalance`** as an **existing AzerothCore module** that will be used alongside our custom Mortal rebalance system. This document summarizes what's planned.

---

## What is `mod-autobalance`?

`mod-autobalance` is an **existing AzerothCore module** that:
- **Scales mobs based on party size**
- Automatically adjusts NPC difficulty when players enter instances
- Typically increases HP/damage as more players join

---

## Integration Plan (From Spec 40)

### 1. Module Status
- **Assumed to be enabled** alongside:
  - `mod-anticheat`
  - `mod-playerbots` (restricted)
  - `mod-premium` (for Supporter status)

### 2. Security Concerns

**Potential Abuse:**
- Single player + many bot accounts artificially boosting difficulty/rewards
- Exploiting autobalance scaling to get better loot/XP

**Mitigations Required:**
1. **Reward Scaling:**
   - Loot and tokens should scale with **real players only**, not total group size
   - Exclude bots from reward calculations

2. **Autobalance Settings:**
   - Must **not dramatically raise loot/xp** for higher group sizes
   - Tune scaling to prevent exploitation

3. **Security Checks:**
   - Compare "effective group size" vs "real players" in suspicious runs
   - Flag instances where bot count doesn't match real player count

---

## Relationship with Mortal Rebalance System

### Two Separate Systems:

1. **`mod-autobalance`** (Existing AC Module)
   - **Purpose:** Scale mobs based on party size
   - **When:** Applied at instance entry/party join
   - **Scope:** All instances (if enabled)

2. **Mortal Rebalance System** (Spec 32 - Custom)
   - **Purpose:** Scale NPCs to Mortal power band (HP/damage caps)
   - **When:** Applied on creature spawn
   - **Scope:** All NPCs mapped to Mortal tiers
   - **Tables:**
     - `mortal_creature_tiers`
     - `mortal_creature_tier_map`
     - `mortal_spell_scaling`

### How They Work Together:

```
NPC Spawn
  ↓
1. Mortal Rebalance (Spec 32)
   - Apply tier-based scaling (HP, damage, armor)
   - Apply spell scaling
  ↓
2. mod-autobalance (if enabled)
   - Further scale based on party size
  ↓
Final NPC Stats
```

**Order of Operations:**
1. **Mortal tier scaling** happens first (brings NPCs to Mortal power band)
2. **Autobalance scaling** happens second (adjusts for party size)

---

## Implementation Requirements

### 1. Configuration
- Enable `mod-autobalance` in AzerothCore
- Configure scaling factors to prevent abuse
- Set loot/XP scaling to use "real players only"

### 2. Bot Detection Integration
- Use `mortal_bot_characters` table (from Spec 40) to exclude bots from:
  - Autobalance party size calculations
  - Reward scaling
  - Security anomaly detection

### 3. Security Monitoring
- Track instances where:
  - Group size ≠ real player count
  - Autobalance scaling is unusually high
  - Reward rates are suspicious

---

## Spec References

### Spec 40: Anti-Bot, RMT & Security
- **Section 8.2: Autobalance Abuse**
  - Defines abuse scenarios
  - Lists mitigations
  - Requires security checks

### Spec 32: NPC and Encounter Rebalance
- **Our custom rebalance system**
- Works alongside (not replaces) mod-autobalance
- Handles Mortal-specific stat scaling

### Spec 41: Telemetry and Balancing
- Mentions balancing but doesn't specifically address autobalance
- Could be used to monitor autobalance effectiveness

---

## Current Status

### ✅ Implemented:
- Mortal rebalance system (Spec 32)
  - `mortal_creature_tiers` table
  - `mortal_creature_tier_map` table
  - `mortal_spell_scaling` table
  - C++ hooks in `MortalCreature.cpp`

### ❌ Not Yet Implemented:
- **`mod-autobalance` module** - **NOT INSTALLED** (needs to be added)
- Bot exclusion from autobalance calculations
- Security monitoring for autobalance abuse
- Reward scaling based on "real players only"

### 📋 Module Status:
**Current modules in `azerothcore/modules/`:**
- `mod-aio`
- `mod-anticheat`
- `mod-costumes`
- `mod-eluna`
- `mod-transmog`
- `mortal_overhaul`

**Missing:**
- `mod-autobalance` - **Needs to be installed/added**

---

## Next Steps

1. **Install `mod-autobalance` module:**
   - ⚠️ **Module is NOT currently installed**
   - Need to find/download `mod-autobalance` for AzerothCore
   - Add to `azerothcore/modules/` directory
   - Configure in CMake build
   - Review its configuration options
   - Test scaling behavior

2. **Implement bot exclusion:**
   - Create `mortal_bot_characters` table (Spec 40)
   - Modify autobalance to exclude bots from party size
   - Test with bot characters

3. **Configure reward scaling:**
   - Ensure loot/XP scales with real players only
   - Test reward rates at different party sizes

4. **Add security monitoring:**
   - Track autobalance scaling events
   - Flag suspicious patterns
   - Integrate with security dashboard (Spec 40)

---

## Questions to Resolve

1. **Where to get `mod-autobalance`?**
   - ✅ **ANSWERED:** Module is NOT currently installed
   - Need to find AzerothCore-compatible version
   - May need to adapt from other AC modules or create custom version

2. **How does it interact with our Mortal rebalance?**
   - Test order of operations
   - Ensure no double-scaling issues

3. **What are the default scaling factors?**
   - Review module configuration
   - Tune for Mortal's power band

4. **How to exclude bots from party size?**
   - Check if module has built-in support
   - Or need to patch/modify module

---

**Conclusion:** `mod-autobalance` is planned to work **alongside** our custom Mortal rebalance system, but requires careful configuration and security monitoring to prevent abuse.

