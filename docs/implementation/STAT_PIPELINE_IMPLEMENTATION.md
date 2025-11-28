# Stat Calculation Pipeline Implementation
## Centralized Stat Calculation with Proper Order of Operations

**Date:** 2025-01-XX  
**Status:** ✅ Complete

---

## Implementation Summary

### ✅ Completed: Centralized Stat Calculation Pipeline

**Files Created:**
- `src/MortalStats.h` - Stat calculation system header
- `src/MortalStats.cpp` - Stat calculation pipeline implementation

**Files Modified:**
- `src/ScriptMgr.cpp` - Integrated pipeline into PlayerScript hooks

**Implementation Details:**

The stat calculation pipeline follows the exact order specified in `84-mortal-core-stats-and-combat-model.md` §2.2.3:

**Pipeline Order:**
```
1. Base Attributes (from database)
   ↓
2. Gear Modifiers (from equipped items)
   ↓
3. Rune Modifiers (from socketed runes)
   ↓
4. Buff/Aura Modifiers (from active auras)
   ↓
5. Individual Stat Clamping (Max 150 per stat)
   ↓
6. Total Attribute Clamping (Max 400 total, with overflow normalization)
   ↓
7. Derived Stats Calculation (AP, SP, HP, Mana - handled by AzerothCore)
```

**Key Functions:**

1. **`CalculateAndApplyStats(Player* player)`** - Main pipeline function
   - Orchestrates the entire stat calculation process
   - Calls each step in order
   - Applies final clamped values to player

2. **`GetBaseAttributes(Player* player)`** - Step 1
   - Queries `mortal_character_attributes` table
   - Falls back to AzerothCore's base stats if not found

3. **`GetGearModifiers(Player* player)`** - Step 2
   - Sums stat bonuses from all equipped items
   - Checks item stats and on-equip spell effects

4. **`GetRuneModifiers(Player* player)`** - Step 3
   - Sums stat bonuses from socketed runes
   - Placeholder for future rune system implementation

5. **`GetBuffModifiers(Player* player)`** - Step 4
   - Sums stat bonuses from active auras
   - Handles both positive and negative modifiers

6. **`ApplyClamping(MortalStatValues& stats)`** - Steps 5 & 6
   - Applies individual stat caps (150 max)
   - Applies total attribute normalization (400 max)
   - Uses the attribute overflow normalization algorithm

7. **`ApplyStatsToPlayer(Player* player, const MortalStatValues& stats)`** - Step 7
   - Sets final stat values on player
   - AzerothCore then calculates derived stats automatically

**Integration Points:**

1. **OnPlayerLogin** - Recalculates stats on login
2. **OnPlayerUpdate** - Recalculates stats every 2 seconds
3. **OnEquip** - Recalculates stats when equipment changes

**Example Calculation:**

```
Step 1: Base Attributes
  STR = 80, AGI = 60, STA = 100, INT = 50, SPI = 40
  Total = 330

Step 2: Gear Modifiers
  +20 STR (weapon), +15 AGI (boots), +30 STA (chest), +10 INT (helm), +5 SPI (ring)
  STR = 100, AGI = 75, STA = 130, INT = 60, SPI = 45
  Total = 410

Step 3: Rune Modifiers
  +10 STR, +5 AGI
  STR = 110, AGI = 80, STA = 130, INT = 60, SPI = 45
  Total = 425

Step 4: Buff Modifiers
  +20 STR (buff), -5 STA (debuff)
  STR = 130, AGI = 80, STA = 125, INT = 60, SPI = 45
  Total = 440

Step 5: Individual Stat Clamping
  All stats <= 150: No change
  STR = 130, AGI = 80, STA = 125, INT = 60, SPI = 45
  Total = 440

Step 6: Total Attribute Clamping
  Scale Factor = 400 / 440 = 0.9091
  Normalized: STR = 118, AGI = 73, STA = 114, INT = 55, SPI = 41
  New Total = 401 (adjust: -1 from STR)
  Final: STR = 117, AGI = 73, STA = 114, INT = 55, SPI = 41
  Total = 400 ✓

Step 7: Derived Stats (calculated by AzerothCore)
  AP_melee = (2.0 * 117) + (0.5 * 73) + WeaponSkillBonus
  HP = 50 + (114 * 10) = 1190
  Mana = 100 + (55 * 10) = 650
```

---

## Design Decisions

**Why Separate Pipeline?**
- Ensures consistent order of operations
- Makes stat calculation predictable and debuggable
- Allows for future extensions (rune system, etc.)

**Integration with AzerothCore:**
- Uses AzerothCore's functions for gear and buff detection
- Applies our own clamping and normalization
- Lets AzerothCore handle derived stats (AP, SP, HP, Mana)

**Performance:**
- Pipeline runs every 2 seconds (configurable)
- Also runs on equipment changes
- Caching could be added for optimization

---

## Future Enhancements

1. **Rune System Integration**
   - Currently returns 0 for rune bonuses
   - Will need to query rune system when implemented

2. **Caching**
   - Cache stat values until inputs change
   - Only recalculate when needed

3. **Realm Check**
   - Only apply to Realm 1 (Mortal) players
   - Skip for Realm 2 (Legacy) players

4. **Debug Logging**
   - Add optional logging for stat calculation steps
   - Useful for debugging stat issues

---

## Testing Checklist

- [ ] Test with base attributes only (no gear/buffs)
- [ ] Test with gear equipped
- [ ] Test with buffs active
- [ ] Test with runes socketed (when implemented)
- [ ] Test individual stat clamping (150 max)
- [ ] Test total attribute clamping (400 max)
- [ ] Test attribute overflow normalization
- [ ] Test equipment change triggers recalculation
- [ ] Test stat calculation on login
- [ ] Verify derived stats update correctly

---

## Files Created/Modified

**New Files:**
- `src/MortalStats.h` - Stat calculation system header
- `src/MortalStats.cpp` - Stat calculation pipeline implementation

**Modified Files:**
- `src/ScriptMgr.cpp` - Integrated pipeline into PlayerScript hooks
  - Added to `OnPlayerLogin`
  - Added to `OnPlayerUpdate`
  - Added to `OnEquip`

---

## Next Steps

1. ✅ Stat Calculation Pipeline - **COMPLETE**
2. ⚠️ Integrate rune system when implemented
3. ⚠️ Add realm check (Realm 1 only)
4. ⚠️ Add caching for performance
5. ⚠️ Testing and validation

---

**Last Updated:** 2025-01-XX

