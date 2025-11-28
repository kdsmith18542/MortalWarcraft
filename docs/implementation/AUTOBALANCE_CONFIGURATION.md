# AutoBalance Configuration for Mortal Warcraft

**Date:** 2025-01-XX  
**Status:** ⏳ **CONFIGURATION IN PROGRESS**

---

## Overview

This document outlines the configuration of `mod-autobalance` for Mortal Warcraft, ensuring it works correctly with our custom Mortal rebalance system and meets security requirements from Spec 40.

---

## Configuration File

**Location:** `azerothcore/bin/etc/AutoBalance.conf`

**Source:** Copied from `AutoBalance.conf.dist`

---

## Key Configuration Points

### 1. Enable AutoBalance
```conf
AutoBalance.Enable.Global=1
```

### 2. Instance Size Settings
Enable for all instance sizes:
```conf
AutoBalance.Enable.5M=1
AutoBalance.Enable.10M=1
AutoBalance.Enable.15M=1
AutoBalance.Enable.20M=1
AutoBalance.Enable.25M=1
AutoBalance.Enable.40M=1
AutoBalance.Enable.OtherNormal=1

AutoBalance.Enable.5MHeroic=1
AutoBalance.Enable.10MHeroic=1
AutoBalance.Enable.25MHeroic=1
AutoBalance.Enable.OtherHeroic=1
```

### 3. Minimum Players
Set to 1 to allow solo scaling:
```conf
AutoBalance.MinPlayers = 1
AutoBalance.MinPlayers.Heroic = 1
AutoBalance.MinPlayers.Raid = 1
AutoBalance.MinPlayers.RaidHeroic = 1
```

### 4. Stat Scaling (Inflection Point)
These settings control how difficulty scales with player count:
- **InflectionPoint**: Controls curve shape (default: 0.5)
- **CurveFloor**: Minimum multiplier for low player counts
- **CurveCeiling**: Maximum multiplier for high player counts

**For Mortal:**
- We want moderate scaling (not too easy solo, not too hard in groups)
- Consider: `InflectionPoint = 0.5` (default)
- Consider: `CurveFloor = 0.0` (default)
- Consider: `CurveCeiling = 1.0` (default)

### 5. Stat Modifiers
Controls HP, damage, armor, etc. scaling:
```conf
AutoBalance.StatModifier.HP = 1.0
AutoBalance.StatModifier.Damage = 1.0
AutoBalance.StatModifier.Armor = 1.0
```

**Note:** These are applied AFTER Mortal tier scaling (Spec 32).

---

## Integration with Mortal Rebalance System

### Order of Operations:
1. **Mortal Tier Scaling** (Spec 32)
   - Applied on creature spawn
   - Uses `mortal_creature_tiers` and `mortal_creature_tier_map`
   - Scales HP, damage, armor to Mortal power band

2. **AutoBalance Scaling** (mod-autobalance)
   - Applied based on party size
   - Further adjusts stats for group size

### Compatibility:
- ✅ Both systems work together
- ✅ Mortal scaling happens first (on spawn)
- ✅ AutoBalance scaling happens second (based on party)

---

## Security Requirements (Spec 40)

### 1. Bot Exclusion
**Requirement:** Exclude bots from party size calculations

**Current Status:** ⚠️ **NOT YET IMPLEMENTED**

**Implementation Plan:**
1. Create `mortal_bot_characters` table (Spec 40)
2. Modify AutoBalance to check this table
3. Exclude bot GUIDs from player count

**Workaround for Now:**
- Monitor autobalance scaling manually
- Use `.ab mapstat` to verify player counts
- Flag suspicious patterns manually

### 2. Reward Scaling
**Requirement:** Loot/XP should scale with "real players only"

**Current Status:** ⚠️ **NOT YET IMPLEMENTED**

**Note:** AutoBalance only scales NPC stats, not rewards. Reward scaling needs to be handled separately in:
- Loot system
- XP system
- Token system

### 3. Security Monitoring
**Requirement:** Track autobalance scaling events

**Implementation:**
- Enable logging:
```conf
Logger.module.AutoBalance=4,Console Server
Logger.module.AutoBalance_StatGeneration=4,Console Server
```

- Monitor logs for:
  - Group size vs real player count mismatches
  - Unusual scaling factors
  - Suspicious patterns

---

## Recommended Settings for Mortal

### Conservative Scaling (Recommended):
```conf
# Moderate scaling - not too easy, not too hard
AutoBalance.InflectionPoint = 0.5
AutoBalance.CurveFloor = 0.0
AutoBalance.CurveCeiling = 1.0

# Stat modifiers (applied after Mortal scaling)
AutoBalance.StatModifier.HP = 1.0
AutoBalance.StatModifier.Damage = 1.0
AutoBalance.StatModifier.Armor = 1.0
```

### Aggressive Scaling (Alternative):
```conf
# More aggressive scaling - harder solo, easier in groups
AutoBalance.InflectionPoint = 0.3
AutoBalance.CurveFloor = -0.2
AutoBalance.CurveCeiling = 0.8
```

---

## Testing

### In-Game Commands:
- `.ab mapstat` - Shows current map scaling settings
- `.ab creaturestat` - Shows creature scaling (target a creature)
- `.ab getoffset` - Shows player difficulty offset
- `.ab setoffset <value>` - Sets difficulty offset (GM only)

### Test Scenarios:
1. **Solo Dungeon:**
   - Enter dungeon alone
   - Use `.ab mapstat` to verify scaling
   - Check creature stats with `.ab creaturestat`

2. **Group Dungeon:**
   - Enter with 2-5 players
   - Verify scaling increases appropriately
   - Check that rewards don't scale (security requirement)

3. **Raid:**
   - Enter raid with 10-25 players
   - Verify scaling works correctly
   - Check boss scaling

---

## Logging Configuration

Add to `worldserver.conf`:
```conf
Logger.module.AutoBalance=4,Console Server
Logger.module.AutoBalance_CombatLocking=4,Console Server
Logger.module.AutoBalance_DamageHealingCC=4,Console Server
Logger.module.AutoBalance_StatGeneration=4,Console Server
```

**Log Levels:**
- `4` = Info (default)
- `5` = Debug (verbose)

---

## Next Steps

1. ✅ Configuration file created
2. ⏳ Review and adjust scaling factors
3. ⏳ Enable logging in `worldserver.conf`
4. ⏳ Test in-game with commands
5. ⏳ Implement bot exclusion (requires `mortal_bot_characters` table)
6. ⏳ Implement reward scaling (separate from autobalance)
7. ⏳ Set up security monitoring

---

## References

- **Spec 40:** Anti-Bot, RMT & Security (defines requirements)
- **Spec 32:** NPC and Encounter Rebalance (works alongside autobalance)
- **MODULES_INSTALLATION_COMPLETE.md:** Installation details
- **AUTOBALANCE_MODULE_PLAN.md:** Overall plan

---

**Status:** ⏳ **Configuration file ready, needs tuning and testing**

