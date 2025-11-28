# Attribute Overflow Normalization Implementation
## Proportional Reduction Algorithm for Stat Caps

**Date:** 2025-01-XX  
**Status:** ✅ Complete

---

## Implementation Summary

### ✅ Completed: Attribute Overflow Normalization Algorithm

**Files Modified:**
- `src/MortalLevel.cpp` - Updated `EnforceStatCaps()` with spec-compliant algorithm

**Implementation Details:**

The `EnforceStatCaps()` function now implements the complete attribute overflow normalization algorithm as specified in `84-mortal-core-stats-and-combat-model.md` §2.2.1.

**Algorithm Steps:**

1. **Individual Stat Clamping**
   - Clamp each stat to MAX_STAT_SINGLE (150)
   - `cappedStat = min(stat, 150)`

2. **Total Calculation**
   - Sum all capped stats
   - `total = cappedStr + cappedAgi + cappedSta + cappedInt + cappedSpi`

3. **Proportional Normalization (if total > 400)**
   - Calculate scale factor: `scaleFactor = 400.0 / total`
   - Apply proportional reduction with rounding:
     - `normalizedStr = round(cappedStr * scaleFactor)`
     - `normalizedAgi = round(cappedAgi * scaleFactor)`
     - `normalizedSta = round(cappedSta * scaleFactor)`
     - `normalizedInt = round(cappedInt * scaleFactor)`
     - `normalizedSpi = round(cappedSpi * scaleFactor)`

4. **Rounding Adjustment**
   - Recalculate total: `newTotal = sum of normalized stats`
   - Calculate difference: `diff = 400 - newTotal`
   - If difference is significant (> 0.1):
     - Sort stats by value (descending)
     - Adjust highest stat(s) by difference to reach exactly 400

5. **Apply Final Values**
   - Set all stats to normalized/clamped values
   - Ensures total is exactly 400 (or less if no overflow)

**Example 1: Simple Proportional Reduction**
```
Initial Stats:
  STR = 100, AGI = 100, STA = 100, INT = 100, SPI = 50
  Total = 450

After Individual Clamping (all <= 150):
  STR = 100, AGI = 100, STA = 100, INT = 100, SPI = 50
  Total = 450

Scale Factor = 400 / 450 = 0.8889

Normalized (rounded):
  STR = round(100 * 0.8889) = 89
  AGI = round(100 * 0.8889) = 89
  STA = round(100 * 0.8889) = 89
  INT = round(100 * 0.8889) = 89
  SPI = round(50 * 0.8889) = 44
  New Total = 400 ✓
```

**Example 2: With Rounding Adjustment**
```
Initial Stats:
  STR = 120, AGI = 110, STA = 100, INT = 90, SPI = 85
  Total = 505

After Individual Clamping:
  STR = 120, AGI = 110, STA = 100, INT = 90, SPI = 85
  Total = 505

Scale Factor = 400 / 505 = 0.7921

Normalized (rounded):
  STR = round(120 * 0.7921) = 95
  AGI = round(110 * 0.7921) = 87
  STA = round(100 * 0.7921) = 79
  INT = round(90 * 0.7921) = 71
  SPI = round(85 * 0.7921) = 67
  New Total = 399 (1 point short)

Rounding Adjustment:
  diff = 400 - 399 = 1
  Highest stat is STR (95)
  STR = 95 + 1 = 96
  Final Total = 400 ✓
```

**Example 3: Extreme Overflow**
```
Initial Stats:
  STR = 150, AGI = 150, STA = 150, INT = 50, SPI = 50
  Total = 550

After Individual Clamping:
  STR = 150, AGI = 150, STA = 150, INT = 50, SPI = 50
  Total = 550

Scale Factor = 400 / 550 = 0.7273

Normalized (rounded):
  STR = round(150 * 0.7273) = 109
  AGI = round(150 * 0.7273) = 109
  STA = round(150 * 0.7273) = 109
  INT = round(50 * 0.7273) = 36
  SPI = round(50 * 0.7273) = 36
  New Total = 399

Rounding Adjustment:
  diff = 400 - 399 = 1
  Highest stat is STR (tied with AGI and STA, but STR is first)
  STR = 109 + 1 = 110
  Final Total = 400 ✓
```

---

## Design Rationale

**Proportional Reduction:**
- Maintains relative stat distribution
- Fair to all builds (no stat priority bias)
- Preserves player investment choices

**Rounding Adjustment:**
- Ensures exact 400 total (no floating point errors)
- Adjusts highest stat(s) to account for rounding
- Maintains fairness (smallest possible adjustment)

**Why Not Priority-Based Clamping:**
- Priority-based would favor certain stats
- Could create meta-gaming around stat order
- Proportional is more intuitive and fair

---

## Integration Points

**When Called:**
- `EnforceStatCaps()` should be called after:
  1. Base attributes are set
  2. Gear modifiers are applied
  3. Rune modifiers are applied
  4. Buff/aura modifiers are applied

**Current Integration:**
- Function exists in `MortalLevel.cpp`
- Should be called from stat update hooks
- May need to be integrated into `PlayerScript_MortalStats::OnPlayerUpdate()`

**Future Integration:**
- Should be part of centralized stat calculation pipeline
- Called automatically when stats are updated
- Ensures caps are always enforced

---

## Testing Checklist

- [ ] Test with total < 400 (no normalization needed)
- [ ] Test with total = 400 (no normalization needed)
- [ ] Test with total > 400 (normalization applied)
- [ ] Test with extreme overflow (550+ total)
- [ ] Test rounding adjustment (399 or 401 total after rounding)
- [ ] Test with all stats at 150 (maximum individual caps)
- [ ] Test with mixed stat values
- [ ] Verify relative ratios are maintained
- [ ] Verify total is exactly 400 after normalization

---

## Files Modified

- `src/MortalLevel.cpp` - Updated `EnforceStatCaps()` with complete algorithm
  - Added `#include <algorithm>` for `std::sort`
  - Added `#include <cmath>` for `std::round`
  - Implemented proportional reduction with rounding
  - Implemented rounding adjustment logic

---

## Next Steps

1. ✅ Attribute Overflow Normalization - **COMPLETE**
2. ⚠️ Verify `EnforceStatCaps()` is called at correct point in stat pipeline
3. ⚠️ Integrate into centralized stat calculation system
4. ⚠️ Testing and validation

---

**Last Updated:** 2025-01-XX

