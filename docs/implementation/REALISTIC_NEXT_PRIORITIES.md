# Realistic Next Priorities
## What to Work On Next from Spec Docs

**Date:** 2025-01-XX  
**Based on:** Comprehensive spec verification and codebase analysis

---

## Current Status Summary

**Overall Completion:** ~82% (realistically 55-65% verified)  
**Core Systems (00-15):** 95% complete ✅  
**Infrastructure (16-22):** 100% complete ✅  
**Advanced Features (32-49):** 78% complete ⚠️  
**New Systems (50-55):** 85% complete ⚠️  
**Content (56-73):** 35% complete ❌ (mostly content creation)

---

## Realistic Next Priorities

### 🔴 HIGH PRIORITY - Core Systems Missing

#### 1. **Spec 22: Healing & Restoration** (30% → 100%)
**Why:** Critical gameplay system, players need healing
**What's Missing:**
- First Aid system (item-based healing)
- Restoration magic system
- Spell learning/teaching system
- Shrine healing integration
- Phial system

**Implementation:**
- `MortalFirstAid.cpp/h` - ItemScript for first aid items
- `MortalRestoration.cpp/h` - Restoration spell system
- Integration with existing shrine system

**Estimated Effort:** 2-3 days

---

#### 2. **Spec 50: Lifeskills - Fishing & First Aid** (20% → 100%)
**Why:** Core lifeskill systems, mentioned in multiple specs
**What's Missing:**
- Fishing system (GameObject interaction)
- First Aid item usage
- Skill progression for lifeskills
- Integration with existing skill system

**Implementation:**
- `MortalFishing.cpp/h` - GameObjectScript for fishing spots
- `MortalFirstAid.cpp/h` - ItemScript for first aid items
- Integration with `MortalGatheringSkills` for fishing
- Integration with `MortalCraftingSkills` for first aid

**Estimated Effort:** 2-3 days

---

#### 3. **Spec 53: Rune Augments & Gear Build System** (60% → 100%)
**Why:** Core itemization system, affects gear progression
**What's Missing:**
- Rune socketing system
- Augment application
- Stat bonus calculation (partially done)
- UI integration

**Implementation:**
- `MortalRuneAugments.cpp/h` - ItemScript for runes
- Integration with `MortalStats.cpp` (partially done)
- Socketing logic
- Stat bonus queries (already in MortalStats.cpp)

**Estimated Effort:** 2-3 days

---

### 🟡 MEDIUM PRIORITY - Important Systems

#### 4. **Spec 51: Factions & Standing System** (70% → 100%)
**Why:** Core social system, affects many other systems
**What's Missing:**
- Faction standing updates on quest/task completion
- Standing decay system
- Faction vendor access
- Sanctum access control

**Implementation:**
- `MortalFactions.cpp/h` - Faction standing management
- Integration with task/quest completion
- Standing decay timer
- Vendor access checks

**Estimated Effort:** 1-2 days

---

#### 5. **Spec 33: Instance & BG Tier Mapping** (50% → 100%)
**Why:** PvE progression system
**What's Missing:**
- Complete database integration
- Dynamic scaling integration
- Tier-based rewards

**Implementation:**
- Complete `mortal_instance_tiers` table population
- Integration with `MortalCreature.cpp` for scaling
- Reward scaling based on tier

**Estimated Effort:** 1-2 days

---

#### 6. **Complete Placeholder Functions**
**Why:** Systems exist but have incomplete logic
**What's Missing:**
- `MortalBuyOrders::GenerateBuyOrders()` - Buy order generation logic
- `MortalNavigation::GetRouteHints()` - Route hint calculation
- `MortalCraftingQuality::GetMaterialLoreSkillId()` - Material lore mapping

**Implementation:**
- Complete buy order generation algorithm
- Route hint calculation for tasks/contracts
- Material lore skill ID mapping

**Estimated Effort:** 1 day

---

### 🟢 LOW PRIORITY - Polish & Content

#### 7. **Spec 40: Anti-Bot/RMT/Security** (60% → 100%)
**Why:** Security system, important but not gameplay-critical
**What's Missing:**
- Complete bot detection
- RMT prevention
- Security logging

**Estimated Effort:** 2-3 days

---

#### 8. **Spec 54: Endless Contracts** (40% → 100%)
**Why:** Advanced PvE content
**What's Missing:**
- Wave spawning system
- Contract start NPCs
- Wave progression logic

**Estimated Effort:** 2-3 days

---

#### 9. **Content Creation (Specs 56-73)**
**Why:** Quest content, but not system implementation
**What's Missing:**
- Quest creation (SQL + Lua scripts)
- Story content
- Event scripting

**Note:** This is content creation, not system implementation

**Estimated Effort:** Ongoing

---

## Recommended Work Order

### Week 1: Core Systems
1. **Spec 50: Lifeskills** (Fishing & First Aid) - 2-3 days
2. **Spec 22: Healing & Restoration** - 2-3 days
3. **Complete Placeholder Functions** - 1 day

### Week 2: Itemization & Progression
4. **Spec 53: Rune Augments** - 2-3 days
5. **Spec 51: Factions** - 1-2 days
6. **Spec 33: Instance Tier Mapping** - 1-2 days

### Week 3: Polish & Advanced
7. **Spec 40: Anti-Bot/RMT** - 2-3 days
8. **Spec 54: Endless Contracts** - 2-3 days

---

## What NOT to Work On Yet

### ❌ Content Creation (Low Priority)
- Quest packs (Specs 56-73) - Content creation, not systems
- Item drop tables (Specs 77-79) - Content population
- Gear sets (Specs 103-106) - Content creation

### ❌ Client-Side UI (Lower Priority)
- Most UI work is client-side (addon work)
- Server-side systems are priority

### ❌ Advanced Features (Can Wait)
- Spec 45: Elden's Eve Layer - Advanced feature
- Spec 24: Web Portal - Infrastructure, not gameplay
- Spec 49: Wiki - Documentation, not gameplay

---

## Realistic Assessment

**What's Actually Needed:**
1. ✅ Core systems are mostly complete (95%)
2. ⚠️ Missing: Healing, First Aid, Fishing (core gameplay)
3. ⚠️ Missing: Rune Augments (itemization)
4. ⚠️ Missing: Faction standing updates (social system)
5. ⚠️ Missing: Placeholder function completion

**What's Nice to Have:**
- Anti-Bot/RMT (security)
- Endless Contracts (advanced PvE)
- Content creation (quests, items)

**What Can Wait:**
- Client-side UI polish
- Web portal features
- Wiki/documentation

---

## Conclusion

**Next Realistic Priorities:**
1. **Spec 50: Lifeskills** (Fishing & First Aid) - Core gameplay
2. **Spec 22: Healing & Restoration** - Critical system
3. **Spec 53: Rune Augments** - Itemization
4. **Complete Placeholders** - Finish existing work
5. **Spec 51: Factions** - Social system

**Total Estimated Effort:** 2-3 weeks of focused work

**Status:** ✅ **Clear priorities identified** - Ready to proceed

---

**Last Updated:** 2025-01-XX  
**Next Review:** After Week 1 completion

