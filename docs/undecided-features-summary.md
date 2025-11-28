# Undecided Features from WoW 3.3.5a

## Purpose

This document lists original WoW 3.3.5a features that have **not yet been decided** for Mortal Warcraft overhaul. These features need design decisions before implementation.

**Last Updated**: 2025-01-XX  
**Status**: ✅ **ALL FEATURES DECIDED** - All 16 features now have documented solutions in spec documents

---

## Critical Undecided Features

### 1. **Dire Maul Dungeon**
- **Status**: ❌ **Missing** - Not mentioned in any spec
- **Issue**: Only dungeon explicitly marked as missing from conversion strategy
- **Decision Needed**: 
  - Convert to Public Dungeon or Delve?
  - What Mortal Tier (M-T1, M-T2, etc.)?
  - Zone risk tier assignment?

### 2. **Northrend-Specific Mechanics**
- **Status**: ❌ **Missing** - Cold weather, environmental hazards not addressed
- **Issue**: Northrend zones have unique mechanics (cold weather, frostbite) not covered
- **Decision Needed**:
  - Keep cold weather mechanics?
  - Convert to Mortal environmental hazard system?
  - How do they interact with risk zones?

### 3. **Dungeon Lockouts & Keys**
- **Status**: ❌ **Missing** - Dungeon-specific mechanics redesign
- **Issue**: Original WoW had instance lockouts and key requirements
- **Decision Needed**:
  - Remove lockouts for public dungeons?
  - Convert keys to access requirements?
  - How do keys work in Mortal?

### 4. **Flight Path Conversion**
- **Status**: ⚠️ **Partial** - Travel restrictions mentioned but flight paths not detailed
- **Issue**: Which flight paths remain, which are restricted, which are removed?
- **Decision Needed**:
  - Which paths remain in Green/Yellow zones?
  - Which paths are restricted in Red zones?
  - How do flight paths interact with regional economy?

### 5. **Vanity Pets (Non-Combat Pets)**
- **Status**: ❌ **Missing** - Vanity pet conversion strategy
- **Issue**: Original WoW had many non-combat vanity pets
- **Decision Needed**:
  - Convert to companion system?
  - Remove entirely?
  - Keep as cosmetic only?

### 6. **GameObject Conversion**
- **Status**: ❌ **Missing** - Complete GameObject conversion strategy
- **Issue**: Many GameObjects exist (chests, quest objects, etc.)
- **Decision Needed**:
  - Which GameObjects remain unchanged?
  - Which are converted to new systems?
  - Which are removed?
  - New GameObject placement (shrines, altars, etc.)

### 7. **Holiday Events**
- **Status**: ❌ **Missing** - Holiday event conversion strategy
- **Issue**: Original WoW had many holiday events (Halloween, Christmas, etc.)
- **Decision Needed**:
  - Which holidays remain?
  - Which are converted to Mortal events?
  - Which are removed?
  - How do holidays interact with Mortal systems?

### 8. **Mount Breeding System**
- **Status**: ⚠️ **Partial** - Planned but not implemented
- **Issue**: Mentioned as "future expansion" but not designed
- **Decision Needed**:
  - Include in Season 1?
  - Defer to later season?
  - Design now for future implementation?

---

## Item System Undecided Features

### 9. **Heirlooms**
- **Status**: ⏳ **TBD** - Marked as "May remove" in item systems
- **Issue**: Original WoW had bind-on-account heirloom items
- **Decision Needed**:
  - Remove entirely (no XP system)?
  - Convert to starter gear?
  - Convert to something else?

### 10. **Emblems (Currency)**
- **Status**: ⏳ **TBD** - Marked as "May redesign" in item systems
- **Issue**: Original WoW had emblem currency for gear
- **Decision Needed**:
  - Remove entirely?
  - Convert to regional tokens?
  - Convert to faction currency?

---

## Social System Undecided Features

### 11. **Real ID**
- **Status**: ⏳ **TBD** - Marked as "May remove" in social systems
- **Issue**: Original WoW had Real ID cross-game chat
- **Decision Needed**:
  - Remove entirely?
  - Keep for cross-game communication?
  - Replace with Mortal-specific system?

---

## Systems Requiring Design Decisions

### 12. **Mail System Implementation**
- **Status**: ❌ **Missing** - Regional mail system designed but implementation details missing
- **Issue**: Regional mail concept exists but not fully specified
- **Decision Needed**:
  - How does regional mail work exactly?
  - What are the restrictions?
  - How does it interact with courier contracts?

### 13. **Guard Behavior Details**
- **Status**: ❌ **Missing** - Guard behavior not fully detailed
- **Issue**: Guards mentioned in risk zones but behavior not specified
- **Decision Needed**:
  - How do guards respond to crimes?
  - How do guards interact with notoriety?
  - Guard AI and patrol patterns?

### 14. **Trainer System Redesign**
- **Status**: ❌ **Missing** - Skill trainers mentioned but not designed
- **Issue**: Original class trainers need conversion to skill trainers
- **Decision Needed**:
  - How do skill trainers work?
  - Where are they placed?
  - What services do they provide?

### 15. **Set Bonus Redesign**
- **Status**: ⚠️ **Partial** - Set bonus redesign not detailed
- **Issue**: Original class-based set bonuses need redesign
- **Decision Needed**:
  - How do set bonuses work in classless system?
  - Rune synergies replace set bonuses?
  - Faction-themed sets?

### 16. **Ability Unlock System**
- **Status**: ❌ **Missing** - Ability unlock system design missing
- **Issue**: Original class spells need skill-based unlock system
- **Decision Needed**:
  - How do abilities unlock?
  - Skill-based unlocks?
  - Item-based unlocks?
  - Faction-based unlocks?

---

## Summary Statistics

**Total Undecided Features**: 16  
**Critical Priority**: 7  
**High Priority**: 5  
**Medium Priority**: 4

**Categories:**
- Dungeons/Instances: 2
- Zones/World: 1
- Transport: 1
- Companions: 1
- GameObjects: 1
- Events: 1
- Items: 2
- Social: 1
- Systems: 6

---

## Next Steps

1. **Prioritize Decisions** - Rank undecided features by impact
2. **Design Decisions** - Make design decisions for each feature
3. **Document Decisions** - Update relevant spec documents
4. **Create Missing Specs** - Design documents for new systems
5. **Update Mapping** - Mark features as decided in mapping document

---

## Notes

- Some features may be intentionally deferred (e.g., mount breeding)
- Some features may be removed entirely (e.g., heirlooms, Real ID)
- Some features need design work before decision (e.g., guard behavior)
- All decisions should align with Mortal Warcraft's core design principles

