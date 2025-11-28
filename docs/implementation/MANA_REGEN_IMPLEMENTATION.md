# Mana Regeneration Implementation
## Custom Mortal Warcraft Mana Regen Formula

**Date:** 2025-01-XX  
**Status:** ✅ Complete

---

## Implementation Summary

### ✅ Completed: Custom Mortal Mana Regeneration Formula

**Files Modified:**
- `src/MortalDamage.h` - Added function declarations
- `src/MortalCombat.cpp` - Implemented mana regen calculation functions
- `src/ScriptMgr.cpp` - Added hook to override mana regen values

**Implementation Details:**

1. **Function: `CalculateManaRegenPerSecond(Player* player)`**
   - Calculates mana regeneration using Mortal formula
   - Formula: `(BaseRegen + SpiritBonus + ShrineBonus) * StateModifier`
   - Returns mana per second

2. **Function: `IsPlayerNearShrine(Player* player)`**
   - Checks if player is within 20 yards of a shrine GameObject
   - Uses shrine entry IDs (configurable)
   - Returns true if near shrine, false otherwise

3. **Function: `GetManaRegenStateModifier(Player* player)`**
   - Determines player state and returns appropriate modifier
   - Resting: 1.5x (not moving, out of combat)
   - Combat: 0.3x (in combat)
   - Normal: 1.0x (moving, not in combat)

4. **PlayerScript Hook: `OnPlayerUpdate`**
   - Overrides mana regen values every 2 seconds
   - Sets both normal and interrupted regen values
   - Ensures Mortal formula is always applied

**Formula Applied:**
```
ManaRegenPerSecond = (BaseRegen + SpiritBonus + ShrineBonus) * StateModifier

Where:
- BaseRegen = 2.0 mana/second
- SpiritBonus = Spirit * 0.1 (0.1 mana/sec per Spirit point)
- ShrineBonus = 5.0 mana/second (if near shrine), else 0.0
- StateModifier = 1.5 (resting), 0.3 (combat), 1.0 (normal)
```

**Examples:**

**Example 1: Resting with High Spirit**
```
Spirit = 50
NearShrine = false
State = Resting

BaseRegen = 2.0
SpiritBonus = 50 * 0.1 = 5.0
ShrineBonus = 0.0
StateModifier = 1.5

ManaRegenPerSecond = (2.0 + 5.0 + 0.0) * 1.5 = 10.5 mana/second
```

**Example 2: In Combat with Low Spirit**
```
Spirit = 20
NearShrine = false
State = Combat

BaseRegen = 2.0
SpiritBonus = 20 * 0.1 = 2.0
ShrineBonus = 0.0
StateModifier = 0.3

ManaRegenPerSecond = (2.0 + 2.0 + 0.0) * 0.3 = 1.2 mana/second
```

**Example 3: Near Shrine, Resting**
```
Spirit = 40
NearShrine = true
State = Resting

BaseRegen = 2.0
SpiritBonus = 40 * 0.1 = 4.0
ShrineBonus = 5.0
StateModifier = 1.5

ManaRegenPerSecond = (2.0 + 4.0 + 5.0) * 1.5 = 16.5 mana/second
```

---

## Shrine Detection

**Current Implementation:**
- Checks for nearby GameObjects with shrine entry IDs
- Range: 20 yards
- Shrine entry IDs are hardcoded (can be extended)

**Shrine Entry IDs (Examples):**
```cpp
static const uint32 SHRINE_ENTRY_IDS[] = {
    177193,  // Light's Hope Shrine (example)
    177194,  // Shrine of the Fallen (example)
    // Add more shrine entry IDs as needed
};
```

**Future Enhancement:**
- Query `mortal_map_pois` table for shrine POIs
- Use database-driven shrine locations
- Support multiple shrine types

---

## Player State Detection

**Resting State:**
- Player is not moving
- Player is not flying
- Player is not in combat
- Simple check (can be enhanced with movement tracking)

**Combat State:**
- Player is in combat (`IsInCombat()`)
- Returns 0.3x modifier (70% reduction)

**Normal State:**
- Player is moving but not in combat
- Returns 1.0x modifier (normal regen)

**Future Enhancement:**
- Track movement time to better detect resting state
- Add configurable resting time threshold
- Consider food/drink buffs for resting detection

---

## Integration with AzerothCore

**How It Works:**
1. Core calls `UpdateManaRegen()` which sets default WoW regen values
2. Our `OnPlayerUpdate` hook runs every 2 seconds
3. We calculate Mortal mana regen and override the core values
4. Core's `Regenerate()` function uses our overridden values

**Fields Modified:**
- `UNIT_FIELD_POWER_REGEN_FLAT_MODIFIER` - Normal regen (per second)
- `UNIT_FIELD_POWER_REGEN_INTERRUPTED_FLAT_MODIFIER` - Combat/interrupted regen (per second)

**Note:** Both fields are set to the same value since our formula already accounts for state modifiers.

---

## Testing Checklist

- [ ] Verify mana regen in resting state (1.5x modifier)
- [ ] Verify mana regen in combat state (0.3x modifier)
- [ ] Verify mana regen in normal state (1.0x modifier)
- [ ] Test with different Spirit values (0, 50, 100, 150)
- [ ] Test shrine detection (near shrine = +5.0 mana/sec)
- [ ] Verify regen updates every 2 seconds
- [ ] Test edge cases (no Spirit, max Spirit, etc.)

---

## Configuration

**Shrine Entry IDs:**
- Currently hardcoded in `IsPlayerNearShrine()`
- Should be moved to database or config file
- Can be extended to support multiple shrine types

**Shrine Range:**
- Currently 20 yards
- Can be made configurable

**Resting Detection:**
- Currently simple (not moving + not in combat)
- Can be enhanced with time-based tracking

---

## Next Steps

1. ✅ Mana Regen Formula - **COMPLETE**
2. ⚠️ Move shrine entry IDs to database/config
3. ⚠️ Enhance resting state detection
4. ⚠️ Add support for multiple shrine types
5. ⚠️ Testing and validation

---

## Files Modified

- `src/MortalDamage.h` - Added function declarations
- `src/MortalCombat.cpp` - Implemented mana regen calculation (3 new functions)
- `src/ScriptMgr.cpp` - Added mana regen override in OnPlayerUpdate hook

---

**Last Updated:** 2025-01-XX

