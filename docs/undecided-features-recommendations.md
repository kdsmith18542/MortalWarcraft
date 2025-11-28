# Recommended Resolutions for Undecided Features

## Purpose

This document provides **optimal recommendations** for resolving undecided features based on Mortal Warcraft's core mission from `00-overview.md`:

**Core Pillars:**
1. Classless, Skill-Driven Character Progression
2. Risk-Based World With Meaningful Consequences
3. Player-Driven Economy
4. Emergent Gameplay Through World Systems
5. Modern Retention & Social Systems

**Vision:** "A classless, skill-based sandbox MMO that blends Mortal Online's danger, EVE's economy, Runescape's progression, and WoW's polish."

---

## Critical Undecided Features - Recommendations

### 1. **Dire Maul Dungeon** ✅ RECOMMENDATION

**Decision: Convert to Public Dungeon (M-T2)**

**Rationale:**
- Dire Maul is a large, multi-wing dungeon perfect for public dungeon gameplay
- Fits the "Emergent Gameplay Through World Systems" pillar
- Supports player-driven economy (resource competition)
- Aligns with existing dungeon conversion strategy

**Implementation:**
- **Type**: Public Dungeon
- **Mortal Tier**: M-T2 (mid-tier content)
- **Zone Risk**: Feralas = Yellow Zone
- **Mechanics**: 
  - All wings open simultaneously
  - No lockouts
  - Bosses respawn on timer
  - Resource nodes inside (supports economy)

**Spec Update**: Add to `06-pve.md` dungeon mapping

---

### 2. **Northrend-Specific Mechanics** ✅ RECOMMENDATION

**Decision: Convert to Mortal Environmental Hazard System**

**Rationale:**
- Supports "Risk-Based World With Meaningful Consequences" pillar
- Adds depth to risk zones without breaking core systems
- Creates emergent gameplay (players must prepare for cold)
- Aligns with existing world simulation systems

**Implementation:**
- **Cold Weather System**: 
  - Environmental hazard in Northrend zones
  - Requires warm clothing/consumables (crafting economy)
  - Increases risk in Red zones (cold + PvP = higher stakes)
  - Can be mitigated with crafted items (player-driven economy)
- **Integration**: 
  - Part of `12-world-simulation.md` environmental hazards
  - Scales with zone risk tier
  - Creates crafting demand (supports economy)

**Spec Update**: Add to `12-world-simulation.md` environmental hazards section

---

### 3. **Dungeon Lockouts & Keys** ✅ RECOMMENDATION

**Decision: Remove Lockouts, Convert Keys to Access Requirements**

**Rationale:**
- **No Lockouts**: Supports "Emergent Gameplay" - players can farm/compete freely
- **Keys as Access**: Creates player-driven economy (key crafting/trading)
- Aligns with public dungeon philosophy (open access)
- Keys become valuable trade goods (economy pillar)

**Implementation:**
- **Lockouts**: Completely removed for public dungeons
- **Keys**: 
  - Convert to crafted items (player-driven economy)
  - Required for certain boss rooms or treasure vaults
  - Can be traded/sold (supports economy)
  - Keys have durability (consumable = economy sink)
- **Access Requirements**: 
  - Some areas require keys (creates demand)
  - Keys can be looted from mobs or crafted
  - Supports crafting economy

**Spec Update**: Add to `06-pve.md` public dungeon mechanics

---

### 4. **Flight Path Conversion** ✅ RECOMMENDATION

**Decision: Restrict by Risk Zone, Support Regional Economy**

**Rationale:**
- Supports "Player-Driven Economy" pillar (forces travel, creates trade routes)
- Supports "Risk-Based World" pillar (Red zones = no flight paths)
- Creates meaningful travel decisions
- Aligns with caravan/courier systems

**Implementation:**
- **Green Zones**: Full flight path network (safe travel)
- **Yellow Zones**: Limited flight paths (only to/from Green zones)
- **Red Zones**: No flight paths (forces ground travel/caravans)
- **Economy Impact**: 
  - Creates demand for caravan escorts
  - Makes courier contracts valuable
  - Supports regional economy (players must travel)

**Spec Update**: Add to `03-risk-zones.md` travel restrictions section

---

### 5. **Vanity Pets (Non-Combat Pets)** ✅ RECOMMENDATION

**Decision: Convert to Companion System (Cosmetic + Utility)**

**Rationale:**
- Supports "Modern Retention & Social Systems" pillar (cosmetic progression)
- Can provide minor utility (not combat power)
- Creates crafting/trading opportunities (economy)
- Maintains WoW polish while adding Mortal depth

**Implementation:**
- **Conversion**: Vanity pets become "Companions"
- **Functionality**: 
  - Cosmetic only (no combat)
  - Minor utility (light source, small inventory, etc.)
  - Can be traded (economy)
  - Require upkeep (food, etc.) = economy sink
- **Acquisition**: 
  - Crafted items
  - Task board rewards
  - Rare drops
  - Supports multiple content loops

**Spec Update**: Add to `29-companion-bond-and-mercenary-system.md`

---

### 6. **GameObject Conversion** ✅ RECOMMENDATION

**Decision: Systematic Conversion Based on Function**

**Rationale:**
- Supports all pillars through strategic conversion
- Maintains world polish while adding Mortal systems
- Creates opportunities for emergent gameplay

**Implementation:**
- **Keep Unchanged**: 
  - Basic world objects (trees, rocks, etc.)
  - Decorative objects
- **Convert to New Systems**: 
  - Quest objects → Task board objectives
  - Chests → Lootable containers (risk-based)
  - Workstations → Crafting stations (economy)
  - Shrines → Shrine system (already designed)
- **Remove**: 
  - Class-specific objects
  - XP-granting objects
- **Add New**: 
  - Purification altars (extraction system)
  - Task boards
  - Market stalls
  - Stronghold structures

**Spec Update**: Already covered in `12-world-simulation.md` GameObject conversion

---

### 7. **Holiday Events** ✅ RECOMMENDATION

**Decision: Convert to Mortal Seasonal Events (Keep Core, Adapt Mechanics)**

**Rationale:**
- Supports "Modern Retention & Social Systems" pillar
- Maintains WoW polish (familiar events)
- Can integrate with Mortal systems (economy, risk zones)
- Creates seasonal content loops

**Implementation:**
- **Keep Core Holidays**: 
  - Halloween, Christmas, etc. (familiar, polished)
- **Adapt Mechanics**: 
  - Remove XP rewards
  - Add gold/material rewards
  - Integrate with task boards
  - Add risk zone elements (some events in Red zones)
- **Mortal Integration**: 
  - Event-specific crafting recipes
  - Event-specific contracts
  - Seasonal economy shifts
  - Cosmetic rewards (retention)

**Spec Update**: Already covered in `42-gm-tools-and-live-events.md` holiday conversion

---

### 8. **Mount Breeding System** ✅ RECOMMENDATION

**Decision: Defer to Season 2+ (Design Now, Implement Later)**

**Rationale:**
- Not critical for launch (Season 1 scope)
- Complex system better introduced when core is stable
- Can be designed now for future implementation
- Supports long-term progression

**Implementation:**
- **Design Phase**: Create breeding system design now
- **Implementation**: Defer to Season 2+
- **Reasoning**: 
  - Core mount system must work first
  - Breeding adds complexity
  - Better as expansion feature
  - Supports long-term retention

**Spec Update**: Mark as "Future Expansion" in `28-mounts-living-system-and-mapping.md`

---

## Item System Undecided Features - Recommendations

### 9. **Heirlooms** ✅ RECOMMENDATION (UPDATED)

**Decision: Convert to Transmog Appearance Unlocks (Leverage mod-transmog)**

**Rationale:**
- **Better Mission Alignment**: Supports "Modern Retention & Social Systems" pillar (cosmetic progression)
- **Leverages Existing Module**: `mod-transmog` already installed and supports heirlooms
- **Maintains WoW Polish**: Keeps familiar, iconic items
- **Creates Opportunities**: Economy (trading, crafting), progression (collection goals), retention (long-term goals)
- **No Stat Advantages**: Maintains classless progression (heirlooms become cosmetic only)

**Implementation:**
- **Convert**: Heirloom items to appearance unlocks
- **Remove Stats**: Remove all stat bonuses, keep appearance
- **Integration**: 
  - Use `mod-transmog` as base system
  - Integrate with Spec 57 (Appearance Codex)
  - Add Mortal-specific features (faction unlocks, seasonal rewards)
- **Distribution**: 
  - Starter heirlooms for new players
  - Faction-themed heirlooms
  - Seasonal heirloom rewards
  - Crafted heirloom items
- **Economy**: 
  - Heirlooms can be traded
  - Appearance Tokens create economy sink
  - Heirloom crafting creates economy loop

**Spec Update**: 
- Update `19-itemization.md` with heirloom → transmog conversion
- Update `57-appearance-codex-and-transmog.md` with heirloom integration
- Document `mod-transmog` usage

**See**: `/home/keith/wowpack/docs/heirloom-transmog-recommendation.md` for detailed analysis

---

### 10. **Emblems (Currency)** ✅ RECOMMENDATION

**Decision: Convert to Regional Tokens (Faction Currency)**

**Rationale:**
- Supports "Player-Driven Economy" pillar
- Aligns with regional economy design
- Creates faction-based progression
- Supports "Risk-Based World" (different tokens by region)

**Implementation:**
- **Conversion**: Emblems become "Regional Tokens"
- **Functionality**: 
  - Each region has its own token type
  - Earned from task boards/contracts
  - Used for regional vendors
  - Can be traded (economy)
- **Integration**: 
  - Faction standing affects token rewards
  - Supports regional economy
  - Creates trade opportunities

**Spec Update**: Add to `04-economy.md` regional currency section

---

## Social System Undecided Features - Recommendations

### 11. **Real ID** ✅ RECOMMENDATION

**Decision: Remove Entirely (Not Aligned with Mortal Vision)**

**Rationale:**
- Not aligned with sandbox MMO vision
- Adds unnecessary complexity
- Mortal should have its own social systems
- Supports "Emergent Gameplay" (in-game social tools)

**Implementation:**
- **Remove**: Real ID system
- **Replace**: In-game friend/ignore system
- **Reasoning**: 
  - Mortal has its own social systems
  - In-game tools are sufficient
  - Keeps focus on game world
  - Aligns with sandbox philosophy

**Spec Update**: Mark as "Removed" in `09-social-systems.md`

---

## Systems Requiring Design Decisions - Recommendations

### 12. **Mail System Implementation** ✅ RECOMMENDATION

**Decision: Regional Mail Only (No Cross-Region Mail)**

**Rationale:**
- Supports "Player-Driven Economy" pillar (forces physical transport)
- Aligns with regional banking design
- Creates demand for courier contracts
- Supports "Risk-Based World" (mail restrictions by zone)

**Implementation:**
- **Regional Mail**: 
  - Mail only works within same region
  - Green zones: Full mail access
  - Yellow zones: Limited mail (to/from Green only)
  - Red zones: No mail (forces courier contracts)
- **Restrictions**: 
  - No cross-region mail
  - Items must be physically transported
  - Creates courier contract demand
- **Integration**: 
  - Works with regional banking
  - Supports courier system
  - Creates economy opportunities

**Spec Update**: Add detailed implementation to `04-economy.md` regional mail section

---

### 13. **Guard Behavior Details** ✅ RECOMMENDATION

**Decision: Notoriety-Based Guard Response System**

**Rationale:**
- Supports "Risk-Based World With Meaningful Consequences" pillar
- Creates meaningful crime consequences
- Supports player-driven justice
- Aligns with notoriety system

**Implementation:**
- **Guard Response**: 
  - Based on notoriety level
  - Low notoriety: Warnings, fines
  - High notoriety: Aggressive response, arrest attempts
  - Outlaw: Instant kill on sight
- **Zone-Based**: 
  - Green zones: Strict enforcement
  - Yellow zones: Moderate enforcement
  - Red zones: No guards (player justice)
- **AI Behavior**: 
  - Patrol patterns
  - Response time based on standing
  - Escalation system

**Spec Update**: Add detailed guard behavior to `03-risk-zones.md` guard system section

---

### 14. **Trainer System Redesign** ✅ RECOMMENDATION

**Decision: Skill Trainers with Regional Specialization**

**Rationale:**
- Supports "Classless, Skill-Driven" pillar
- Supports "Player-Driven Economy" (trainers create travel demand)
- Aligns with regional economy
- Creates meaningful choices

**Implementation:**
- **Skill Trainers**: 
  - Replace class trainers
  - Teach specific skill categories
  - Regional specialization (some trainers better for certain skills)
- **Services**: 
  - Skill training (basic skills)
  - Skill respec (limited, costly)
  - Skill information/guidance
- **Placement**: 
  - Green zones: Basic trainers
  - Yellow zones: Specialized trainers
  - Red zones: Outlaw trainers (risky but powerful)
- **Economy**: 
  - Training costs gold
  - Creates travel demand
  - Supports regional economy

**Spec Update**: Add to `01-progression.md` trainer system section

---

### 15. **Set Bonus Redesign** ✅ RECOMMENDATION

**Decision: Rune Synergies Replace Set Bonuses (Faction-Themed Sets)**

**Rationale:**
- Supports "Classless, Skill-Driven" pillar (no class requirements)
- Aligns with rune system design
- Creates build diversity
- Supports faction system

**Implementation:**
- **Rune Synergies**: 
  - Multiple runes of same type = synergy bonus
  - Faction-themed rune sets
  - Build-focused sets (Warlord/Guardian/Explorer)
- **Set Bonuses**: 
  - No class requirements
  - Based on rune combinations
  - Faction alignment affects bonuses
- **Acquisition**: 
  - Crafted sets
  - Faction rewards
  - Task board rewards

**Spec Update**: Already covered in `19-itemization.md` set bonus redesign

---

### 16. **Ability Unlock System** ✅ RECOMMENDATION

**Decision: Multi-Path Unlock System (Skill + Item + Faction + Trial)**

**Rationale:**
- Supports "Classless, Skill-Driven" pillar
- Creates multiple progression paths
- Supports all content types
- Aligns with sandbox philosophy

**Implementation:**
- **Unlock Methods**: 
  - Skill-based (train skills to unlock)
  - Item-based (find/earn ability items)
  - Faction-based (faction standing unlocks)
  - Trial-based (complete challenges)
  - Rune-based (rune unlocks abilities)
- **Progression**: 
  - Multiple paths to same ability
  - Player choice matters
  - Supports different playstyles
- **Integration**: 
  - Works with skill system
  - Supports faction system
  - Creates content goals

**Spec Update**: Already covered in `64-spell-and-ability-library.md` ability unlock system

---

## Summary: All Recommendations

| Feature | Recommendation | Priority | Spec Update |
|---------|----------------|----------|-------------|
| 1. Dire Maul | Public Dungeon (M-T2) | High | `06-pve.md` |
| 2. Northrend Mechanics | Environmental Hazards | High | `12-world-simulation.md` |
| 3. Lockouts & Keys | Remove lockouts, keys as access | High | `06-pve.md` |
| 4. Flight Paths | Restrict by risk zone | High | `03-risk-zones.md` |
| 5. Vanity Pets | Companion system | Medium | `29-companion-bond-and-mercenary-system.md` |
| 6. GameObjects | Systematic conversion | High | `12-world-simulation.md` |
| 7. Holidays | Convert to Mortal events | Medium | `42-gm-tools-and-live-events.md` |
| 8. Mount Breeding | Defer to S2+ | Low | `28-mounts-living-system-and-mapping.md` |
| 9. Heirlooms | Remove entirely | High | `19-itemization.md` |
| 10. Emblems | Regional tokens | High | `04-economy.md` |
| 11. Real ID | Remove entirely | Medium | `09-social-systems.md` |
| 12. Mail System | Regional mail only | High | `04-economy.md` |
| 13. Guard Behavior | Notoriety-based | High | `03-risk-zones.md` |
| 14. Trainers | Skill trainers, regional | High | `01-progression.md` |
| 15. Set Bonuses | Rune synergies | High | `19-itemization.md` |
| 16. Ability Unlocks | Multi-path system | High | `64-spell-and-ability-library.md` |

---

## Implementation Priority

### Season 1 Core (Must Have)
- Dire Maul conversion
- Northrend mechanics
- Lockouts & keys
- Flight paths
- Heirlooms removal
- Emblems conversion
- Mail system
- Guard behavior
- Trainers
- Set bonuses
- Ability unlocks

### Season 1.5 (High Priority)
- Vanity pets conversion
- GameObjects conversion
- Holidays conversion

### Season 2+ (Future)
- Mount breeding system
- Real ID removal (low impact)

---

## Alignment with Core Pillars

All recommendations align with Mortal Warcraft's core mission:

✅ **Classless, Skill-Driven**: Trainers, ability unlocks, set bonuses  
✅ **Risk-Based World**: Flight paths, guard behavior, mail restrictions  
✅ **Player-Driven Economy**: Emblems, mail, keys, trainers  
✅ **Emergent Gameplay**: GameObjects, holidays, environmental hazards  
✅ **Modern Retention**: Vanity pets, holidays, mount breeding (future)

---

## Next Steps

1. **Review Recommendations** - Validate against mission
2. **Update Specs** - Document decisions in relevant specs
3. **Update Mapping** - Mark features as decided
4. **Implementation Planning** - Prioritize by season scope

