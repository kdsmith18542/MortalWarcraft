# Project Canvas: Mortal Warcraft Overhaul  
### File: 89-mortal-wiki-structure.md  
### Topic: Mortal Atlas Game Wiki – Structure & Content Plan

> This document defines the **information architecture** for the in-game / web wiki  
> (“Mortal Atlas – Game Guide”), tying together all core systems and spec docs into a  
> player-facing knowledge base.

---

## 1. Goals

1. Give new players a **single place** to understand:
   - What Mortal Warcraft is,
   - How it differs from WotLK,
   - How to survive, progress, and specialize.

2. Tie together existing spec docs into:
   - **Clear top-level sections** (Basics, Archetypes, Factions, Economy, Combat, etc.),
   - Simple, short, linkable pages (no 20k-word walls).

3. Make it easy for:
   - Designers/devs to know **where** to document new features,
   - Players to go from “I liked Fury Warrior in WoW” → “What do I play here?” in 1–2 clicks.

Implementation bias:
- Delivered as **Markdown-backed content** under the Atlas web portal.
- Simple slug structure (e.g. `/wiki/getting-started`, `/wiki/archetypes/linebreaker`).

---

## 2. Top-Level Navigation

Top nav sections for the Mortal Atlas wiki:

1. **Getting Started**
2. **Archetypes & Builds**
3. **World & Zones**
4. **Factions & Standing**
5. **Economy & Crafting**
6. **Combat & Death**
7. **Content & Activities**
8. **Guilds, Strongholds & Warfronts**
9. **Atlas & Tools**
10. **FAQ & Reference**

Each section below includes recommended pages and cross-links.

---

## Related Specs

For full context on wiki structure, see:

- **`49-webportal-wiki-spec.md`** — Wiki system implementation and technical details
- **`24-webportal-mortal-atlas.md`** — Atlas web portal that hosts the wiki
- **`87-mortal-archetype-grid.md`** — Archetype grid that wiki pages reference
- **`88-mortal-progression-era-map.md`** — Progression era map that wiki pages explain
- **`00-overview.md`** — Overview document that wiki pages summarize
- **`84-mortal-core-stats-and-combat-model.md`** — Core stats that wiki pages document

---

## 3. Getting Started

**URL:** `/wiki/getting-started`

### 3.1 Pages

1. **What Is Mortal Warcraft?**
   - Short pitch: classless, full-loot-leaning sandbox built on WotLK.
   - Key inspirations: WoW, Mortal Online, EVE, RuneScape, Elden Ring, Rift.
   - “If you just want to know if this game is for you, read this.”

2. **Differences from WotLK**
   - Bullet list of major changes:
     - Dynamic Level (no XP grind),
     - Full/partial loot rules,
     - Regional banks & trade runs,
     - Flasks instead of potion spam,
     - Runes instead of fixed classes,
     - Standing vs old reputation, etc.
   - Links:
     - `Combat & Death`,
     - `Factions & Standing`,
     - `Archetypes`.

3. **First Steps: Shipwreck to Mainland**
   - Walkthrough of the **two-stage tutorial**:
     - Shipwreck Cove (combat, harvesting, crafting, risk warning).
     - Mainland Hub (market, contracts, banking, mounts).
   - “What you should aim for in your first 2 hours.”
   - Link to:
     - `Progression & Era Map`,
     - `Archetypes & Builds`.

4. **UI & Chat Basics**
   - Explain:
     - MortalUI basic features,
     - Chat channels, `/world` rules, Red Zone radio silence.
   - Link to:
     - `Combat & Death` (for Red Zone rules),
     - `Chat & Social` subpage in FAQ.

---

## 4. Archetypes & Builds

**URL:** `/wiki/archetypes`

### 4.1 Landing Page

- Explain that Mortal is **classless**, but archetypes are recommended **build lanes**.
- Show the **Archetype Overview Table** (from `87-mortal-archetype-grid.md`):
  - Linebreaker, Sanctum Warden, Spellfire Magus, Ether Ranger, Cartel Broker, Frontier Marshal, Atlas Pathfinder, Riftbound Occultist.
- For each archetype:
  - Small description,
  - “If you liked X in WoW…”
  - Links to detail pages.

### 4.2 Detail Pages (One per Archetype)

Example: `/wiki/archetypes/linebreaker-vanguard`

Each page includes:

1. Fantasy & WoW Analogs
2. Recommended Stat Spread (example only; restat is allowed)
3. Recommended Skills:
   - Weapons, Armor, Material Lore, special Mortal skills.
4. Recommended Rune Families:
   - Offensive, defensive, utility.
5. Faction Synergies:
   - Which Standing tracks fit this archetype (Civic, Frontier, Shrine, etc.).
6. Content Loop:
   - Suggested activities solo / group / guild.
7. “Starter Path”:
   - Which Task Boards and Contracts to look for early.

All archetype pages link back to:
- `Factions & Standing`,
- `Progression & Era Map`.

---

## 5. World & Zones

**URL:** `/wiki/world-and-zones`

### 5.1 Pages

1. **Risk Zones: Green, Yellow, Red**
   - Definitions:
     - Green: PvE-safe, low-tier resources.
     - Yellow: Skulled, conditional full loot (criminals drop all).
     - Red: Full loot FFA.
   - Rules:
     - Criminal flags, corpse chests, innocent protections.
   - Link to:
     - `Combat & Death`,
     - `Economy & Trade Runs`.

2. **Shrines & Spirit Healers**
   - Shrine System:
     - Live respawn with 0 gear, 50% HP/mana.
     - No ghost scouting.
   - How flasks refill.
   - How Shrine Orders/St

anding interact here.

3. **Strongholds & Territories (Overview)**
   - High-level description; deep mechanics in the Strongholds section.
   - Display map snippets (static images) showing territory overlays.

4. **Events & Invasions**
   - Midnight Horde,
   - Zone Rifts/Rift-like invasions,
   - World bosses & fragments.

---

## 6. Factions & Standing

**URL:** `/wiki/factions-and-standing`

This is the **player-friendly version** of `86-mortal-factions-and-standing.md`.

### 6.1 Pages

1. **Standing Overview**
   - Simple explanation:
     - 0 = neutral, +100 = revered, -100 = hated.
   - Notoriety (short-term crime) vs Standing (long-term reputation).
   - Effects on:
     - Guards,
     - Taxes,
     - Access,
     - Markets, Black Market.

2. **Civic Authority**
   - City-state standings (Stormwind, Ironforge, etc.).
   - How to gain/lose Civic Standing.
   - Benefits:
     - Guard priority,
     - Taxes,
     - Bank perks.

3. **Shrine Orders**
   - Shrine Favour and its effects.
   - Shrine blessings, Warden gear, flask benefits.
   - Risks of negative Shrine standing.

4. **Cartel Syndicate**
   - Black Market and fencing.
   - How Cartel Standing helps/hurts you.

5. **Frontier Militia**
   - Stronghold/Warfront standing.
   - What it gets you in frontier territories.

6. **Atlas Consortium**
   - Atlas intel tiers.
   - Explorer & anomaly Contracts.

7. **Guild Sovereignty**
   - How guild relationships (member/ally/enemy) affect:
     - Access to Strongholds,
     - Taxes,
     - “Legal” PvP vs Notoriety.

---

## 7. Economy & Crafting

**URL:** `/wiki/economy-and-crafting`

### 7.1 Pages

1. **Currency & Tokens**
   - Gold, raw materials, blueprints, Adventurer’s License.
   - Donation → License → tradability.

2. **Regional Banks & Trade Runs**
   - How regional banks differ.
   - How trade runs work.
   - Risk/reward of moving goods through Yellow/Red.

3. **Market Stalls & Auction Network**
   - How Market Stalls work.
   - EVE-style AH (global visibility, local pickup).
   - Fees, taxes, and how Standing affects them.

4. **Crafting & Material Lore**
   - Multi-part crafting:
     - Blade + Hilt + Flux.
   - Quality tiers (Shoddy, Normal, Masterwork).
   - Material Lore skill and refining stations.
   - Durability, permanent decay.

5. **Runes & Gear Progression**
   - Basic explanation of Runes, sockets, and mortal gear tiers (T1–T5).
   - How losing gear = losing abilities (Elden-style).

6. **Cartel & Black Market**
   - How to access and use the Black Market.
   - How fencing, laundering, and Cartel Standing work.

---

## 8. Combat & Death

**URL:** `/wiki/combat-and-death`

### 8.1 Pages

1. **Stats & Derived Values**
   - Primary attributes:
     - STR/AGI/STA/INT/SPI, caps and 400-genetic cap.
   - Derived stats (HP, Mana, AP, SP, Crit, Armor).
   - No rating soup (no defense, resilience, hit, etc. on gear).

2. **Flasks & Healing**
   - Crimson Phial:
     - 3 charges, refilled at Shrines/Inn.
   - Healing sources: Runes, Sanctum Wardens, consumables.

3. **Brace & Guard Counters**
   - How Brace works (damage reduction).
   - Guard Counter style buffs (Opportunity window).

4. **Death, Loot & Corpse Chests**
   - Full loot rules by zone.
   - Corpse chest logic.
   - Insurance / Soul Insurance explanation.

5. **PvP Rules**
   - Notoriety, Bounty Board, Guilt by Association.
   - Group gank penalties and bounty markers.
   - World PvP vs Warfront vs Arena.

---

## 9. Content & Activities

**URL:** `/wiki/content-and-activities`

### 9.1 Pages

1. **Task Boards & Contracts**
   - Types of boards (Civic, Shrine, Frontier, Atlas, Cartel).
   - Infinite procedural tasks vs handcrafted Contracts.
   - How rewards scale with risk.

2. **Dungeons & Public Delves**
   - Difference between:
     - Classic dungeons,
     - Public delves (open-world dungeons),
     - Hellgates (PvPvE dungeons).

3. **Raids & Cursed Artifacts**
   - How instanced raids work.
   - Cursed Loot and extraction mechanic.
   - Purification altars in the open world.

4. **World Events**
   - Midnight Horde,
   - Large Rift invasions,
   - World Boss cycles.

5. **Arena & Fighting Pits**
   - Wager matches,
   - Titles/achievements for champions.

---

## 10. Guilds, Strongholds & Warfronts

**URL:** `/wiki/guilds-strongholds-warfronts`

### 10.1 Pages

1. **Guild Basics**
   - How to create, roles, taxes, war declarations.

2. **Strongholds & Sovereignty**
   - How to claim, upgrade, and defend Strongholds.
   - Resource generation, local banking, crafting.

3. **Warfronts**
   - How to join.
   - Risk/reward and Warfront victory effects.

4. **Siege & Military Credits**
   - Honor → Military Credits.
   - Siege blueprints and tech tree.

---

## 11. Atlas & Tools

**URL:** `/wiki/atlas-and-tools`

### 11.1 Pages

1. **Mortal Atlas Overview**
   - Web portal features:
     - Killboard,
     - Territory map,
     - Market tracker,
     - Character profiles.

2. **Using Atlas as a Player**
   - Finding safe routes,
   - Tracking war hotspots,
   - Reading killfeeed intel.

3. **Discord & External Integration**
   - Killfeed, territory alerts, global chat bridging.

---

## 12. FAQ & Reference

**URL:** `/wiki/faq`

### 12.1 FAQ Topics

- “Is this just a WotLK private server?”
- “Do I lose all my gear when I die?”
- “How do I make money early?”
- “What should I play if I liked X in WoW?”
- “How do I avoid getting ganked constantly?”
- “How dangerous are Red Zones really?”
- “How does regional banking work?”

### 12.2 Technical Reference (For Power Users)

- Links to:
  - Full stat formulas (from `84-mortal-core-stats-and-combat-model.md`),
  - Standing references (`86-mortal-factions-and-standing.md`),
  - Archetype grid (`87-…`),
  - Progression map (`88-…`).

---

## 13. Implementation Notes

1. **Content Source**
   - Store wiki pages as Markdown files in a `docs/wiki/` folder in the Atlas repo.
   - Use a simple generator or direct render in the React frontend.

2. **In-Game Access**
   - MortalUI can:
     - Open embedded webviews for wiki URLs,
     - Or show a simplified, cached subset of content (for common pages).

3. **Cross-Linking**
   - Every page should:
     - Link to relevant Factions, Archetypes, and Activities.
   - Archetype pages must link:
     - “Best task boards for this archetype,”
     - “Best factions to align with.”

4. **Change Discipline**
   - When a core system changes:
     - Update its spec doc,
     - Update the corresponding wiki page(s),
     - Add a short “Changelog” or “Season Notes” piece.

This wiki structure should be the **canonical player-facing map** of the game’s systems, letting new and old players alike understand the Mortal sandbox without ever reading the internal spec docs.
