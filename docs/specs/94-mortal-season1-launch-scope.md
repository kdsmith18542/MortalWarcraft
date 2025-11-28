# Project Canvas: Mortal Warcraft Overhaul  
### File: 94-mortal-season1-launch-scope.md  
### Topic: Season 1 Launch Scope – What Must Ship, What Can Land Later

> This document defines **what needs to be playable for a “real” launch**,  
> and what can arrive as post-launch updates (“Season 1.5”, “Season 2”)  
> without breaking the core Mortal fantasy.

You explicitly **do not** want an MVP; you want a **production-level first release**.  
This scope is about **sequencing**, not cutting vision.

---

## Related Specs

- `17-implementation-roadmap.md` - Implementation milestones and sequencing
- `01-progression.md` - Dynamic Level System (S1 Core)
- `84-mortal-core-stats-and-combat-model.md` - Stat Caps & Derived Stats (S1 Core)
- `02-combat.md` - Basic Combat Loop (S1 Core)
- `75-mortal-gear-and-runes-spec.md` - Rune-Based Abilities (S1 Core)
- `03-risk-zones.md` - Risk Zones & Death/Loot Rules (S1 Core)
- `04-economy.md` - Core Economy & Regional Banking (S1 Core)
- `05-crafting.md` - Crafting & Material Lore (S1 Core)
- `11-pvp-systems.md` - PvP Systems & Notoriety (S1 Core)
- `08-guilds-sovereignty.md` - Guild Sovereignty & Strongholds (S1.5)

---

## 1. Definitions

- **Launch-Critical (S1 Core)**  
  If this is missing, the game doesn’t feel like Mortal Warcraft.  
  These systems must exist in functioning form at launch (even if V1).

- **High-Priority Post-Launch (S1.5)**  
  Important for depth and long-term retention, but the game can launch without them  
  *as long as their absence is clearly communicated as “coming soon.”*

- **Later Expansions (S2+)**  
  Big systems that are better introduced when the population is stable and the core loop is proven.

---

## 2. Launch-Critical Systems (Season 1 Core)

### 2.1 Core Character & Combat

**Must be in:**

1. **Dynamic Level System**
   - Level from skill points, not XP.
   - Basic implementation in `MortalLeveling` + `MortalSkills`.

2. **Stat Caps & Derived Stats**
   - 150 per-stat / 400 total cap.
   - Clean derived stats without rating soup.

3. **Basic Combat Loop**
   - Brace mechanic,
   - Guard-counter style damage windows,
   - Flasks (Crimson Phial) instead of potion spam.

4. **Rune-Based Abilities (Classless Kit)**
   - At least:
     - One coherent melee kit (Linebreaker/Marshal),
     - One healer kit (Sanctum Warden),
     - One ranged physical (Ether Ranger),
     - One caster kit (Spellfire Magus).

5. **Shrine Respawn System**
   - Live respawn with naked body run,
   - No ghost scouting.

---

### 2.2 World Structure & Risk

**Must be in:**

1. **Risk Zones (Green/Yellow/Red)**
   - Rules for:
     - PvP enablement,
     - Corpse chest & full loot behavior,
     - Criminal flags in Yellow.

2. **Regional Banking**
   - Basic implementation:
     - City banks are distinct,
     - Some frontier/Stronghold banks.

3. **Core Task Boards & Contracts**
   - Civic, Frontier, Shrine, Atlas baseline boards:
     - Simple kill/deliver/scout tasks,
     - Gold + Standing rewards.

4. **At Least One Stronghold Territory**
   - A working Stronghold:
     - Ownership mechanics,
     - Taxation,
     - Local buffs.

---

### 2.3 Economy, Markets & Sinks

**Must be in:**

1. **Regional Market Stalls**
   - Functional stall rental,
   - Listing & buying items,
   - Local pickup (no mail delivery).

2. **Basic Crafting Overhaul**
   - Multi-part item construction (Blade/Hilt/Flux).
   - Material Lore affecting quality.
   - Durability & permanent decay on repairs.

3. **Foundational Gold Sinks**
   - Repair costs,
   - Stall fees,
   - Stabling/feeding mounts,
   - Mercenary wages (if mercs ship in S1 or S1.5).

4. **Token Economy Hook**
   - Adventurer’s License existing as:
     - Donation item,
     - Craftable (even if fragment sources are limited at launch).

---

### 2.4 Social, Chat & UI

**Must be in:**

1. **Chat Overhaul V1**
   - Clear channels (local, city, trade, world, guild).
   - Red Zone radio silence rules.
   - Basic broadcast messages for:
     - Major events,
     - World bosses,
     - Beginning/ending Warfronts.

2. **Titles & Role Tags**
   - Core titles:
     - Your Admin/GM titles,
     - Basic criminal/justice titles.

3. **MortalUI Addon Pack**
   - At least:
     - Immersion,
     - DynamicCam (optional),
     - Map overlays (risk zones, Stronghold territories),
     - Nameplate driver for PvP clarity.

4. **Mortal Atlas – Minimal Web Portal**
   - Backend + frontend running with:
     - Killfeed,
     - Simple map (Stronghold ownership, risk zones),
     - Basic character lookup.

---

### 2.5 Content & Activities

**Must be in:**

1. **Onboarding Campaign**
   - Two-stage tutorial (Shipwreck + Mainland).
   - Basic Mortal-flavored story arc through early zones.

2. **Public Delves**
   - At least:
     - 1–2 low-tier public dungeons in Yellow Zones,
     - 1 public delve at mid-tier difficulty.

3. **Core Dungeons & Raids Integration**
   - A curated set of:
     - 3–5 dungeons with rebalance done,
     - 1–2 raids with minimum Mortal adjustments.
   - Not every instance fully reworked at launch, but enough to show the direction.

4. **World Events V1**
   - Midnight Horde (at least basic implementation),
   - 1–2 world bosses tied to token economy or crafting.

5. **Warfront Prototype**
   - At least **one** Warfront map:
     - With portals,
     - Rules,
     - Rewards wired.
   - It can be in “Season Preview” status but should be playable.

---

## 3. High-Priority Post-Launch (Season 1.5)

### 3.1 Exploration Layer

**Strongly desired Soon™ but not hard-blocking launch:**

1. **Anomalies V1**
   - Signature spawner,
   - Arcane Eye scanner,
   - A small set of anomaly archetypes (micro-dungeon, Shrine Echo).

2. **Rifts V1**
   - Rift Instability score per zone,
   - Minor invasions in select zones,
   - Emergency Contracts.

3. **Hellgates V1**
   - Single Key type in one or two zones,
   - Simple mirrored map layout,
   - Boss + loot.

---

### 3.2 War & Territory Depth

1. **Multiple Warfronts**
   - Additional maps,
   - More objective variety.

2. **Siege Flow Enhancements**
   - More Strongholds,
   - Better UI support for siege windows,
   - Expanded Contracts around sieges.

---

### 3.3 Living Assets Depth

1. **Mercenary System V1**
   - Contract-based healer/tank/DPS mercs.
   - Available in:
     - Open world,
     - Public delves,
     - Some dungeons.

2. **Pet & Mount Needs**
   - Unified Needs/Condition system for:
     - Mounts, beasts, utility companions.

3. **Pack Mules & Vendor Squires**
   - Risk-aware companions for trade runs and convenience.

---

### 3.4 Campaign & Story Expansion

1. **More Mortal-Flavored Quest Arcs**
   - Replacing or re-flavoring more WotLK chains in key zones.
   - Focus on:
     - Risk,
     - Standing,
     - Strongholds.

---

## 4. Later Expansions (Season 2+)

These are large systems that **benefit more from a mature playerbase**.

### 4.1 Full Rift & Invasion Campaigns

- Multi-zone invasion chains.
- Endless “Warframe-like” mission variants.
- Zone “falls” with deep economic impact.

### 4.2 Advanced Stronghold & City Politics

- More Strongholds per region.
- Civic elections or council systems.
- City-state politics with:
  - Taxes, law changes,
  - Public works projects.

### 4.3 Advanced Atlas Features

- Full route planner,
- Warfront prediction heatmaps,
- Player-run intel markets.

### 4.4 Niche Archetype Expansions

- Deeper support for:
  - Hardcore economic players (Cartel-focused seasons),
  - Shrine-heavy “holy war” content,
  - Deep occult anomalies and risk wizardry.

---

## 5. Tech & Tooling Milestones

### 5.1 For Launch (Infra)

- AzerothCore fork with:
  - Mortal modules compiled in,
  - mod-aio, mod-eluna, mod-playerbots (if still used) integrated.
- Build & deploy pipeline for:
  - Game server,
  - Atlas backend/frontend,
  - Launcher.

### 5.2 Post-Launch Enhancements

- Better GM/admin tools:
  - In-game dashboards for Standing, events, war.
- Automated diagnostics:
  - Economy health, Standing distributions,
  - Warfront participation metrics.

---

## 6. Player Communication

At launch, clearly communicate:

- **What’s already in**:
  - Dynamic Level, classless runes,
  - Regional banks, partial/full loot,
  - Task Boards, Stronghold V1,
  - Public delves, initial Warfront, Mortal campaign.

- **What’s coming soon (S1.5)**:
  - Anomalies/Rifts/Hellgates,
  - Mercs, pack mules,
  - Multiple Warfronts, richer sieges.

- **What’s long-term (S2+)**:
  - Realm-wide invasion campaigns,
  - Politics, advanced Atlas.

This way, you can **launch with a real, unique game** that already feels like Mortal Warcraft, while giving yourself breathing room to layer in the crazy-high-ceiling systems in controlled waves instead of trying to ship everything at once.
