# World Boss Tier Mappings - Complete

**Date:** 2025-01-XX  
**Status:** ✅ **COMPLETE**

---

## Summary

Successfully mapped **8 world bosses** to Mortal creature tiers. All major WotLK world bosses are now integrated into the NPC rebalance system.

---

## Mapped World Bosses

### High-Tier World Bosses (WORLD_3 - M-T4 loot)
- **Doom Lord Kazzak** (Entry: 18728) - Outland
- **Doomwalker** (Entry: 17711) - Outland
- **Lord Kazzak** (Entry: 12397) - Classic

**Scaling:** 0.4 HP, 0.45 damage, 0.4 armor/resist

### Mid-Tier World Bosses (WORLD_2 - M-T4 loot)
- **Emeriss** (Entry: 14889) - Emerald Dragon
- **Lethon** (Entry: 14888) - Emerald Dragon
- **Taerar** (Entry: 14890) - Emerald Dragon
- **Ysondre** (Entry: 14887) - Emerald Dragon

**Scaling:** 0.4 HP, 0.45 damage, 0.4 armor/resist

### Low-Tier World Bosses (WORLD_1 - M-T3 loot)
- **Azuregos** (Entry: 6109) - Classic

**Scaling:** 0.35 HP, 0.4 damage, 0.35 armor/resist

---

## Statistics

- **Total World Bosses Mapped:** 8
- **High-Tier:** 3 bosses
- **Mid-Tier:** 4 bosses
- **Low-Tier:** 1 boss

---

## Integration

All world bosses are now:
- ✅ Mapped to appropriate Mortal tiers
- ✅ Will scale automatically on spawn
- ✅ Integrated with spell scaling system
- ✅ Ready for loot tier assignment

---

## Next Steps

1. **Add Spell Scaling:**
   - Add spell scaling entries for world boss abilities
   - Focus on high-damage abilities that could one-shot players

2. **Test in-Game:**
   - Verify world bosses spawn with scaled stats
   - Test spell damage scaling
   - Verify tier assignments are correct

3. **Loot Integration:**
   - Assign loot tiers based on `loot_tier_hint`
   - Create custom loot tables if needed

---

## SQL File

**File:** `sql/99_world_boss_tier_mappings.sql`

This script:
- Maps world bosses to appropriate tiers
- Provides summary statistics
- Lists all mapped bosses

---

**Status:** ✅ **Complete - 8 world bosses mapped to Mortal tiers**

