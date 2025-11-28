# Specs 21-22: Missing Systems Implementation

**Date:** 2025-01-XX  
**Status:** ✅ **IMPLEMENTED**

---

## Summary

Implemented the missing systems from Specs 21 and 22:

1. ✅ **Crimson Phial System** (Spec 21)
2. ✅ **Restoration Magic Support** (Spec 22)

---

## Crimson Phial System (Spec 21)

### Files Created

1. **`sql/110_crimson_phial.sql`**
   - Database table: `mortal_crimson_phial`
   - Tracks charges per player

2. **`azerothcore/modules/mortal_overhaul/src/MortalFlask.h`**
   - Core flask system interface
   - Functions for charge management, refill, usage

3. **`azerothcore/modules/mortal_overhaul/src/MortalFlask.cpp`**
   - Implementation of flask logic
   - Charge tracking, healing calculation, refill logic

4. **`azerothcore/modules/mortal_overhaul/src/MortalFlaskSpell.h`**
   - Spell script for `SPELL_CRIMSON_PHIAL` (ID: 90010)
   - Validates charges before cast
   - Handles healing effect

5. **`azerothcore/modules/mortal_overhaul/src/MortalFlaskSpell.cpp`**
   - Spell script implementation

6. **`azerothcore/modules/mortal_overhaul/src/MortalFlaskRefill.h`**
   - Helper functions for detecting Spirit Healers and Inns

7. **`azerothcore/modules/mortal_overhaul/src/MortalFlaskRefill.cpp`**
   - Implementation of refill detection

8. **`azerothcore/modules/mortal_overhaul/src/MortalFlaskHooks.h`**
   - PlayerScript for login initialization and respawn refill
   - CreatureScript for Innkeeper refill option

9. **`azerothcore/modules/mortal_overhaul/src/MortalFlaskHooks.cpp`**
   - Implementation of hooks

### Features Implemented

- ✅ Charge tracking (base 3 charges)
- ✅ Healing effect (40% of max HP per charge)
- ✅ Charge cooldown (20 seconds between uses)
- ✅ Refill at Spirit Healers (on respawn)
- ✅ Refill at Inns (via gossip menu)
- ✅ Login initialization (creates flask data if missing)
- ✅ Spell handler integration
- ✅ Mastery bonus support (structure ready, needs Guardian tree integration)

### Integration Points

- Registered in `ScriptMgr.cpp`:
  - `MortalFlask::Initialize()`
  - `AddSC_MortalFlaskHooks()`
  - `RegisterSpellScript(SpellScript_MortalCrimsonPhial)`

- Added to `CMakeLists.txt`:
  - `MortalFlask.cpp`
  - `MortalFlaskSpell.cpp`
  - `MortalFlaskRefill.cpp`
  - `MortalFlaskHooks.cpp`

---

## Restoration Magic (Spec 22)

### Files Created/Modified

1. **`sql/111_restoration_skill.sql`**
   - Documentation for Restoration skill (ID: 5001)
   - Spell book item entry references

2. **`azerothcore/modules/mortal_overhaul/src/MortalSpellLearning.cpp`** (Modified)
   - Added Restoration spell books:
     - 80010: Minor Mend (Restoration 10)
     - 80011: Rejuvenating Prayer (Restoration 25)
     - 80012: Circle of Mending (Restoration 50)
     - 80013: Aegis of Renewal (Restoration 40)
     - 80014: Rite of Restoration (Restoration 75)
   - Added Restoration skill name mapping

### Features Implemented

- ✅ Restoration skill line support (ID: 5001)
- ✅ Spell book system integration
- ✅ Skill requirement checking
- ✅ Spell learning from books

### Spell IDs (Placeholder)

The following spell IDs are referenced in the code but need to be created in `spell_template`:
- 90020: Minor Mend
- 90021: Rejuvenating Prayer
- 90022: Circle of Mending
- 90023: Aegis of Renewal
- 90024: Rite of Restoration

**Note:** These spells need to be created separately in the database with proper effects, cast times, cooldowns, and mana costs as specified in Spec 22.

---

## Next Steps

1. **Create Spell Templates**
   - Add Restoration spells (90020-90024) to `spell_template`
   - Configure effects, cast times, cooldowns, mana costs

2. **Create Item Templates**
   - Add Restoration spell books (80010-80014) to `item_template`
   - Set proper item properties (consumable, unique, etc.)

3. **Guardian Mastery Integration**
   - Add "Reinforced Phial" talent (+1 charge)
   - Add "Potent Brew" talent (increased heal %)

4. **Testing**
   - Test flask charge tracking
   - Test refill at Shrines/Inns
   - Test spell learning from books
   - Test Restoration skill gains

---

## Production Readiness

**Status:** ✅ **IMPLEMENTED** (Core systems complete)

- ✅ Crimson Phial: Complete
- ✅ Restoration Magic: Complete (spell books integrated)
- ⚠️ Spell templates: Need to be created
- ⚠️ Item templates: Need to be created
- ⚠️ Mastery integration: Structure ready, needs talent definitions

**Ready for testing once spell/item templates are created.**

