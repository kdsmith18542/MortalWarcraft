# Remaining Areas Summary

## Purpose

This document summarizes any remaining areas that need attention after completing the feature conversion decisions.

**Last Updated**: 2025-01-XX  
**Status**: Review of remaining areas

---

## ✅ Completed: All Undecided Features Resolved

All 16 undecided features have been **decided and documented** in their respective spec documents:

1. ✅ **Dire Maul** → Public Dungeon (M-T2) - `06-pve.md`
2. ✅ **Northrend Mechanics** → Environmental Hazards - `12-world-simulation.md`
3. ✅ **Lockouts & Keys** → Removed lockouts, keys as access - `06-pve.md`
4. ✅ **Flight Paths** → Risk zone restrictions - `03-risk-zones.md`
5. ✅ **Vanity Pets** → Companion system - `29-companion-bond-and-mercenary-system.md`
6. ✅ **GameObjects** → Systematic conversion - `12-world-simulation.md`
7. ✅ **Holidays** → Mortal events - `42-gm-tools-and-live-events.md`
8. ✅ **Mount Breeding** → Deferred to S2+ - `28-mounts-living-system-and-mapping.md`
9. ✅ **Heirlooms** → Transmog conversion - `19-itemization.md` & `57-appearance-codex-and-transmog.md`
10. ✅ **Emblems** → Regional tokens - `04-economy.md`
11. ✅ **Real ID** → Removed - `09-social-systems.md`
12. ✅ **Mail System** → Regional mail only - `04-economy.md`
13. ✅ **Guard Behavior** → Notoriety-based - `03-risk-zones.md`
14. ✅ **Trainers** → Skill trainers - `01-progression.md`
15. ✅ **Set Bonuses** → Rune synergies - `19-itemization.md`
16. ✅ **Ability Unlocks** → Multi-path system - `64-spell-and-ability-library.md`

---

## Remaining Areas

### 1. Implementation Gaps (Implementation Phase)

These are **formula/algorithm/schema gaps** that are documented in specs but need implementation details:

**Formula Gaps:**
- Hit/Miss formula (02-combat.md)
- Material Multiplier formula (02-combat.md)
- Mana regen formula (84-mortal-core-stats-and-combat-model.md)
- Skill gain rate formulas (01-progression.md)
- Encumbrance calculation formula (10-crafting-economy.md)
- Reward scaling formulas (76-dynamic-tasks-and-contracts-2-0-spec.md)
- And others (see implementation gap notes in specs)

**Schema Gaps:**
- Regional bank schema details (04-economy.md)
- Market stall schema details (04-economy.md)
- World simulation schema details (12-world-simulation.md)

**Algorithm Gaps:**
- Task board generation algorithm (76-dynamic-tasks-and-contracts-2-0-spec.md)
- Attribute overflow normalization (84-mortal-core-stats-and-combat-model.md)
- Stat calculation pipeline order (84-mortal-core-stats-and-combat-model.md)

**Status**: These are **implementation-phase** gaps, not design gaps. They're documented in specs with "⚠️ IMPLEMENTATION GAP" notes and will be filled during implementation.

---

### 2. Ongoing Conversion Work (Content Phase)

These are **content conversion tasks** that will be done during implementation:

**Item Conversion:**
- Full item conversion (not doing full conversion - converting as needed)
- Item stat assignment automation
- ETL pipeline completion

**Ability Library:**
- Complete spell/ability conversion (ongoing work)
- Ability tagging and categorization

**NPC Rebalancing:**
- Additional NPCs beyond the 1,416 already mapped (will be done as needed)

**Status**: These are **content conversion** tasks, not design gaps. The design is complete, these are implementation/content work.

---

### 3. Future Expansion Features

These are **intentionally deferred** to future seasons:

**Mount Breeding System:**
- Design complete
- Implementation deferred to Season 2+
- Status: Future expansion

**Housing System:**
- Mentioned in specs as "future expansion"
- Not critical for Season 1 launch
- Status: Future expansion

**Status**: These are **intentionally deferred** features, not gaps. They're designed but not implemented for Season 1.

---

### 4. Minor Design Details

These are **minor details** that may need clarification during implementation:

**Shrine Order Naming:**
- Shrine faction names marked as "TBD"
- Minor naming decision needed
- Status: Minor detail, doesn't block implementation

**Status**: These are **minor details**, not design gaps. Can be decided during implementation.

---

## Summary

### ✅ Design Phase: COMPLETE

**All design decisions are made:**
- ✅ All 16 undecided features resolved
- ✅ All major systems designed
- ✅ All feature conversions documented
- ✅ All spec documents updated

### ⚠️ Implementation Phase: PENDING

**Implementation details remain:**
- Formulas need mathematical definitions
- Schemas need complete table structures
- Algorithms need step-by-step definitions
- These are documented in specs with gap notes

### 📋 Content Phase: ONGOING

**Content conversion work:**
- Item conversion (as needed)
- Ability library (ongoing)
- NPC rebalancing (ongoing)
- These are content tasks, not design gaps

### 🔮 Future Expansions: PLANNED

**Intentionally deferred:**
- Mount breeding (Season 2+)
- Housing (future expansion)
- These are planned features, not gaps

---

## Conclusion

**Design phase is essentially complete.** All major design decisions have been made and documented. The remaining work is:

1. **Implementation details** (formulas, schemas, algorithms) - documented in specs with gap notes
2. **Content conversion** (items, abilities, NPCs) - ongoing work, not design gaps
3. **Future expansions** (mount breeding, housing) - intentionally deferred

**No remaining critical design decisions are needed.** The project is ready to move to implementation phase, where the documented implementation gaps will be filled with specific formulas, schemas, and algorithms.

