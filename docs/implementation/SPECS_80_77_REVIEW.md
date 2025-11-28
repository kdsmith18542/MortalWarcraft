# Specs 80-77 Implementation Review

## Overview

These specs are **content design documents** rather than system implementation specs. They define:
- Quest chains and NPCs
- Item stat layouts and drop sources
- Vendor configurations
- Content progression patterns

These require **content creation** (database entries) rather than **system code** (C++ modules).

---

## Spec 80: Content Lane - Frontier Bruiser Quest and Loot Bundle

### Type: Content Design Document

### Status: **Design Complete, Implementation Pending**

### What It Defines:
- T1 Quest Chain: Port Meridian Militia Arc (4 quests)
- T2 Quest Chain: Greycrag Frontier Contracts
- NPCs: Captain Arlen Stonefist, Sergeant Lysa Hawktide, etc.
- Quest templates with SQL stubs
- Vendor configurations
- Eluna event script skeletons

### Implementation Requirements:
- Create quest entries in `quest_template` table
- Create NPC entries in `creature_template` table
- Create item entries for Greycrag Militia set
- Create vendor entries in `npc_vendor` table
- Create loot tables for quest rewards
- Implement Eluna scripts for events ("Hold the Crossing", etc.)

### Notes:
- This is a **pattern/template** for other content lanes
- Actual implementation requires hundreds of database entries
- Can be done incrementally as content is needed

---

## Spec 79: Drop Mapping for T1/T2 Gear and Runes

### Type: Content Design Document

### Status: **Design Complete, Implementation Pending**

### What It Defines:
- Where T1/T2 gear sets drop (quests, dungeons, vendors, contracts)
- Primary vs secondary sources for each set
- Restrictions (no world drops, faction requirements)
- Drop rates and loot table configurations

### Implementation Requirements:
- Configure loot tables in `creature_loot_template`
- Configure quest rewards in `quest_template`
- Configure vendor items in `npc_vendor`
- Configure contract rewards (if using contract system)
- Set up dungeon loot tables

### Notes:
- Defines **where** items come from, not the items themselves
- Requires items from Spec 77/78 to exist first
- Can be implemented as content is created

---

## Spec 78: Itemization - Healer, Ranger, Mage

### Type: Content Design Document

### Status: **Design Complete, Implementation Pending**

### What It Defines:
- Three archetype sets:
  - Sanctum Warden (T1: Shrine Acolyte, T2: Sanctum Keeper)
  - Longroad Ranger (T1: Scout's Kit, T2: Longroad Tracker)
  - Spellfire Magus (T1: Apprentice's Robes, T2: Spellfire Adept)
- Stat layouts for each item
- Rune loadouts per archetype
- 8-slot mini-set examples

### Implementation Requirements:
- Create item entries in `item_template` table
- Set stat values (STR, AGI, STA, INT, SPI)
- Create visual models/textures
- Configure rune sockets
- Create vendor entries if needed

### Notes:
- Provides **concrete stat numbers** for items
- Follows attribute cap rules (150 per stat, 400 total)
- Can be implemented as items are needed

---

## Spec 77: Itemization - T1/T2 Starter Sets

### Type: Content Design Document

### Status: **Design Complete, Implementation Pending**

### What It Defines:
- Two starter archetypes:
  - Frontier Bruiser (T1: Greycrag Militia, T2: Linebreaker Vanguard)
  - Waywatcher Arcanist (T1: Waywatcher's Kit, T2: Arcanist's Regalia)
- Stat layouts for each item
- Rune examples
- 8-slot mini-set examples

### Implementation Requirements:
- Create item entries in `item_template` table
- Set stat values per spec
- Create visual models/textures
- Configure rune sockets
- Create vendor entries

### Notes:
- Provides **concrete stat numbers** for starter items
- Foundation for other content lanes
- Can be implemented as starter content is needed

---

## Summary

### Implementation Status:
- **System Code**: N/A (these are content specs)
- **Content Creation**: Pending (requires database entries)

### Priority:
These specs are **content design templates**. They should be implemented when:
1. Core systems are complete (quest system, item system, vendor system)
2. Content team is ready to create quests/items
3. Starter content is needed for player onboarding

### Recommendation:
- **Mark as "Design Complete"** - specs provide clear patterns
- **Defer implementation** until content creation phase
- Use as **reference** when creating actual quests/items
- Can be implemented incrementally (one archetype at a time)

### Next Steps:
- Continue with system implementation specs (if any remain)
- These content specs can be implemented later during content creation phase

