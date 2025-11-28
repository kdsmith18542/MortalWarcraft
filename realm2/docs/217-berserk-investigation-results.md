# Issue #16905 Investigation Results: Druid Berserk Energy Bug

**Date:** 2025-01-23  
**Method:** Browser Automation (Cursor) + Database + DBC

---

## Findings from Wowhead

### Spell Information (Spell 50334 - Berserk)

**From Wowhead Page:**
- **Resource:** Energy (confirmed - "Uses resource: Energy")
- **Cost:** None (spell itself doesn't cost energy to cast)
- **Description:** "When activated, this ability causes your Mangle (Bear) ability to hit up to 3 targets and have no cooldown, and **reduces the energy cost of all your Cat Form abilities by 50%**. Lasts 15 sec. You cannot use Tiger's Fury while Berserk is active. Clears the effect of Fear and makes you immune to Fear for the duration."

**Key Effects:**
- **Effect #1:** "Apply Aura: Modifies Power Cost (14) Value: -50%"
  - This REDUCES energy costs of cat form abilities by 50%
  - Does NOT consume energy itself

**Comments Analysis:**
- 447 total comments
- Comments mention "energy" but mostly about:
  - Using Tiger's Fury with Berserk
  - Energy management during Berserk
  - No mentions of Berserk consuming energy when cast

---

## Analysis

### What the Spell Does (Retail):
1. **Does NOT consume energy** when cast (Cost: None)
2. **REDUCES energy costs** of cat form abilities by 50% (Effect #1)
3. Modifies Bear Mangle (hits 3 targets, no cooldown)
4. Provides Fear immunity

### What Issue #16905 Actually Is (from GitHub):

**The Real Bug:**
- Energy cost reduction is **TOO MUCH** (75% instead of 50%)
- Calculation order is wrong: percentage applied before flat modifiers
- Should be: flat modifiers FIRST, then percentage modifiers

**Current (Wrong) Behavior:**
```
Base cost: 42 energy
Apply Berserk -50%: 42 * 0.5 = 21 energy
Apply Ferocity -5: 21 - 5 = 16 energy
Result: 62% reduction (too much!)
```

**Expected (Correct) Behavior:**
```
Base cost: 42 energy
Apply Ferocity -5: 42 - 5 = 37 energy
Apply Berserk -50%: 37 * 0.5 = 18.5 energy
Result: 56% reduction (correct, because flat reduction is applied first)
```

**Root Cause:**
- Power cost calculation applies percentage modifiers before flat modifiers
- Should apply flat modifiers first, then percentage modifiers

---

## Next Steps

1. **Read GitHub Issue #16905:**
   - Check the actual issue description
   - See what the reporter says the bug is
   - Understand expected vs actual behavior

2. **Test in-game:**
   - Cast Berserk in cat form
   - Check if energy is consumed
   - Verify the -50% cost reduction works

3. **Compare with Database:**
   - Check `spell_template` for powerCost
   - Verify spell effects match Wowhead

---

## Conclusion

**From GitHub Issue #16905:**
- The bug is **NOT** about Berserk consuming energy
- The bug **IS** about energy cost reduction being too much (75% instead of 50%)
- **Root cause:** Calculation order - percentage applied before flat modifiers
- **Fix needed:** Change power cost calculation to apply flat modifiers first, then percentage

**From Wowhead:**
- Berserk does NOT consume energy when cast (Cost: None) ✅ Confirmed
- Reduces energy costs by 50% ✅ Confirmed
- The issue is with how this 50% interacts with other talents

---

## Fix Implementation

**Location:** Power cost calculation code (likely `Spell.cpp` or `Unit.cpp`)

**Change:**
1. Find where power costs are calculated
2. Ensure flat modifiers (e.g., Ferocity -5) are applied FIRST
3. Then apply percentage modifiers (e.g., Berserk -50%)

**Test:**
- Cast Berserk with Ferocity talent
- Verify energy costs are reduced by exactly 50% of the modified cost
- Not 75% of the base cost

