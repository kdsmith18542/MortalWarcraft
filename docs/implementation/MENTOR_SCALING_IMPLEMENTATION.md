# Mentor Scaling Implementation
## Mentor Down Scaling Formula for PvE Content

**Date:** 2025-01-XX  
**Status:** ✅ Complete

---

## Implementation Summary

### ✅ Completed: Mentor Down Scaling System

**Files Created:**
- `src/MortalMentor.h` - Mentor system header
- `src/MortalMentor.cpp` - Mentor scaling implementation

**Files Modified:**
- `src/MortalCombat.cpp` - Integrated mentor scaling into damage calculation
- `src/ScriptMgr.cpp` - Added mentor scaling to health calculation

**Implementation Details:**

The mentor scaling system allows high-level players to scale down their effective power to play with lower-level friends in PvE content, while maintaining full power in PvP.

**Key Functions:**

1. **`GetMentorScaleFactor(Player* player, Unit* target)`**
   - Calculates scale factor based on target band and actual level
   - Formula: `ScaleFactor = TargetBandMidpoint / ActualLevel`
   - Returns 1.0 if mentor mode inactive or in PvP context
   - Constrained to 0.1 (minimum) to 1.0 (maximum)

2. **`IsMentorModeActive(Player* player)`**
   - Checks if mentor mode is active for player
   - Automatically returns false if in PvP context

3. **`IsInPvPContext(Player* player)`**
   - Checks if player is in PvP zone/context
   - Returns true for: Battlegrounds, Arenas, Red zones, PvP flagged, duels

4. **`IsValidMentorTarget(Player* player, Unit* target)`**
   - Checks if target is valid for mentor scaling
   - Must be NPC (not player)
   - Must be at or below target band level

5. **`ApplyMentorScalingToDamage(Player* attacker, Unit* victim, float baseDamage)`**
   - Applies mentor scaling to damage calculation
   - Only scales for PvE (NPCs at or below target band)

6. **`SetMentorMode(Player* player, bool activate, uint8 targetBand)`**
   - Activates/deactivates mentor mode
   - Validates target band
   - Updates database

**Scaling Formula:**
```
TargetLevel = TargetBandMidpoint
ActualLevel = Player's actual derived level (1-25)
ScaleFactor = TargetLevel / ActualLevel

EffectiveHP = BaseHP * ScaleFactor
EffectiveDamage = BaseDamage * ScaleFactor
EffectiveAP = BaseAP * ScaleFactor
EffectiveSP = BaseSP * ScaleFactor
```

**Level Band Midpoints:**
- Band 1: Level 3 (Levels 1-5)
- Band 2: Level 8 (Levels 6-10)
- Band 3: Level 13 (Levels 11-15)
- Band 4: Level 18 (Levels 16-20)
- Band 5: Level 23 (Levels 21-25)

**Scaling Constraints:**
- Minimum: 0.1 (10% of base stats)
- Maximum: 1.0 (100% of base stats)
- Only scales down, never up
- Disabled if TargetLevel >= ActualLevel

**PvP Safety:**
- All scaling completely disabled in PvP contexts
- Red zones, arenas, battlegrounds, duels: No scaling
- PvP always uses true stats

**Example Calculations:**

**Example 1: Level 20 Player Mentors to Band 2**
```
ActualLevel = 20
TargetBand = 2 (midpoint = 8)
ScaleFactor = 8 / 20 = 0.4

BaseHP = 1000 → EffectiveHP = 400
BaseDamage = 100 → EffectiveDamage = 40
BaseAP = 200 → EffectiveAP = 80
```

**Example 2: Level 15 Player Mentors to Band 1**
```
ActualLevel = 15
TargetBand = 1 (midpoint = 3)
ScaleFactor = 3 / 15 = 0.2

BaseHP = 800 → EffectiveHP = 160
BaseDamage = 80 → EffectiveDamage = 16
```

**Example 3: Level 25 Player Mentors to Band 3**
```
ActualLevel = 25
TargetBand = 3 (midpoint = 13)
ScaleFactor = 13 / 25 = 0.52

BaseHP = 1500 → EffectiveHP = 780
BaseDamage = 150 → EffectiveDamage = 78
```

---

## Integration Points

**Damage Calculation:**
- Integrated into `MortalDamageSystem::CalculateDamage()`
- Scaling applied after all other damage modifiers
- Only applies to PvE combat (NPCs)

**Health Calculation:**
- Integrated into `PlayerScript_MortalStats::OnPlayerUpdate()`
- Applies scaling to max health for display purposes
- Actual combat scaling handled in damage calculation

**Database:**
- Uses `mortal_mentor_mode` table (from `sql/117_mentoring_enhancements.sql`)
- Stores mentor mode state per character
- Tracks target band and effective level

---

## PvP Safety Implementation

**Automatic Disabling:**
- Mentor mode automatically disabled when:
  - Player enters battleground
  - Player enters arena
  - Player enters Red zone (when implemented)
  - Player becomes PvP flagged
  - Player enters duel

**Detection:**
- `IsInPvPContext()` checks all PvP conditions
- `IsPvPZone()` checks zone-specific PvP flags
- Scaling functions return 1.0 (no scaling) in PvP contexts

**Result:**
- All PvP damage uses true stats
- No scaling applied to player-vs-player combat
- Mentor mode cannot be enabled in PvP zones

---

## Future Enhancements

1. **Visual Indicators**
   - Add "Mentor" icon next to player name
   - Add buff icon for mentor mode
   - Show target band in UI

2. **Mentor NPC**
   - Create NPC for enabling/disabling mentor mode
   - Validate target band selection
   - Show available bands based on party/content

3. **Group Context Menu**
   - Add "Mentor [Player]" option
   - Auto-select appropriate target band
   - Coordinate with party members

4. **Zone Validation**
   - Check if zone allows mentor mode
   - Validate target band against content level
   - Prevent enabling in inappropriate zones

---

## Testing Checklist

- [ ] Test mentor mode activation/deactivation
- [ ] Test scaling with different level bands
- [ ] Test scaling in PvE combat (NPCs)
- [ ] Test no scaling in PvP combat (players)
- [ ] Test automatic disabling in PvP zones
- [ ] Test minimum scaling constraint (0.1)
- [ ] Test maximum scaling constraint (1.0)
- [ ] Test with different actual levels (1-25)
- [ ] Test with different target bands (1-5)
- [ ] Verify database updates correctly

---

## Files Created/Modified

**New Files:**
- `src/MortalMentor.h` - Mentor system header
- `src/MortalMentor.cpp` - Mentor scaling implementation

**Modified Files:**
- `src/MortalCombat.cpp` - Added mentor scaling to damage calculation
- `src/ScriptMgr.cpp` - Added mentor scaling to health calculation
- `src/MortalDamage.h` - Added comment about mentor scaling

---

## Next Steps

1. ✅ Mentor Scaling Formula - **COMPLETE**
2. ⚠️ Add visual indicators (Mentor icon, buff)
3. ⚠️ Create Mentor NPC for UI
4. ⚠️ Add group context menu integration
5. ⚠️ Testing and validation

---

**Last Updated:** 2025-01-XX

