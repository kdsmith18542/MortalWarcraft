# Project Canvas: Mortal Warcraft Overhaul  
### File: 91-mortal-anomalies-rifts-hellgates.md  
### Topic: Anomalies, Rifts & Hellgates – Exploration & PvPvE Layer

> This document unifies all **“weird space” content**:  
> - Elden Ring–style secrets & illusory content (Anomalies),  
> - Rift-style zone invasions (Rifts),  
> - PvPvE instanced showdowns (Hellgates).  
>  
> Goals:  
> - Give explorers and small groups **infinite side content**.  
> - Tie exploration directly into **economy, factions, and Atlas**.  
> - Provide structured, repeatable PvPvE without relying only on battlegrounds.

---

## 1. Design Goals

1. Create a **scalable exploration layer**:
   - Something players can always do instead of sitting in city chat.
   - Content that spawns in the world, moves, and reacts.

2. Blend inspirations:
   - **Elden Ring** – secrets, illusory walls, micro-dungeons, flasks pressure.
   - **EVE** – signatures scanned down, competitive access, loot races.
   - **Rift** – zone-wide invasions that temporarily change how areas function.

3. Tie into existing systems:
   - **Atlas Consortium** (intel & scanning),
   - **Shrine Orders** (rituals, purifications),
   - **Frontier Militia** (defensive events),
   - **Cartel** (illicit anomaly exploitation).

Implementation bias:
- Core spawn logic in C++,
- Content scripting (bosses, events) in Lua,
- Atlas integration via web API.

---

## Related Specs

For full context on anomalies, rifts, and hellgates, see:

- **`24-webportal-mortal-atlas.md`** — Atlas web portal that provides scanning and intel
- **`51-factions-and-standing-system.md`** — Faction system (Atlas Consortium, Shrine Orders, etc.) that interacts with anomalies
- **`58-world-contracts-and-map-pins.md`** — World contracts that include rift and anomaly objectives
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that can be triggered by rifts
- **`06-pve.md`** — PvE content system that includes anomaly encounters
- **`03-risk-zones.md`** — Risk zones where anomalies and rifts spawn
- **`11-pvp-systems.md`** — PvP systems used in hellgates

---

## 2. Anomalies – Micro-Dungeons & Hidden Sites

Anomalies are **small, short lifespan sites** that appear in the world:

- Think of them as **one-room dungeons, cursed chests, or weird portals**.
- Ideal for solo players or duos/trios.

### 2.1 Spawn & Discovery

1. **Signature Spawns**
   - C++ spawner places **invisible “Rift Signature” GameObjects** in zones:
     - Different archetypes (combat, puzzle, loot, shrine, Cartel, etc.).
   - Each signature has:
     - Hidden location,
     - Difficulty tier (1–5),
     - Time-to-live (e.g. 1–3 hours).

2. **Arcane Eye / Scanner**
   - Players need **scanning tools** to find anomalies:
     - Early game: a basic “Arcane Eye” trinket that pings when near.
     - Late game: Atlas scanners with range, precision, speed bonuses.
   - Scanner UI:
     - Simple compass or hot-cold mechanic,
     - Optional Atlas integration for direction hints.

3. **Activation**
   - Once found:
     - Player interacts with the signature to “stabilize” it.
     - Opens portal, spawns chest, reveals illusory wall, etc.

### 2.2 Anomaly Types

1. **Micro-Dungeon**
   - One or two rooms with:
     - Small packs of enemies,
     - One mini-boss or elite,
     - Chest or altar at the end.
   - Loot:
     - Rune fragments,
     - Rare crafting mats,
     - Atlas reputation tokens.

2. **Shrine Echo**
   - A hidden mini-shrine:
     - Offers temporary buff,
     - May require small offering.
   - Gains **Shrine Standing** if used correctly.
   - Risks:
     - Wrong action could spawn hostile spirits.

3. **Cartel Cache**
   - Smuggled goods stash.
   - Using it without Cartel Standing:
     - Chance to spawn Cartel enforcers.
   - With Cartel Standing:
     - Preferential rewards and Standing gains.

4. **Ether Tear**
   - Dangerous Occult anomalies:
     - Void entities,
     - Corruption buildup.
   - Best suited for **Riftbound Occultists** and Atlas explorers.

### 2.3 Risk & Competition

- Anomalies are:
  - Visible only to those with scanners (Arcane Eye) until activated,
  - Once activated, may spawn **visual cues** that others can see (light pillar, sounds).
- Some anomalies mark the group with a **temporary debuff** visible on Atlas killfeed:
  - “This group is currently inside an anomaly site; expect them to emerge nearby soon.”

### 2.4 Atlas Integration

- Atlas tracks:
  - Anomaly spawn density by zone,
  - Recent completions,
  - Deaths near anomalies.
- High **Atlas Standing**:
  - Unlocks better scanners,
  - Access to anomaly maps,
  - Higher-tier anomaly Contracts.

---

## 3. Rifts – Zone Invasions & Temporary Control Shifts

Rifts are **Rift (the MMO)–style invasions** blended with:

- Mortal’s zones (Green/Yellow/Red),
- Notoriety and Standing,
- WoW’s open world.

### 3.1 Trigger & Phasing

1. **Rift Seeds**
   - Zones have a background **Rift Instability score** (0–100).
   - Score increases from:
     - Over-harvesting,
     - Ignoring minor events,
     - World boss cycles,
     - GM triggers.

2. **Invasion Threshold**
   - When instability crosses a threshold:
     - A **Rift event spawns**:
       - Multiple invasion points,
       - Rifts that spawn enemies over time,
       - Phase changes in key subzones.

3. **Temporary Zone State**
   - Zone may flip into:
     - “Invasion” state:
       - NPCs retreat behind defenses,
       - Task Boards update with emergency Contracts,
       - Banks/markets in sub-areas may close or change rules.

### 3.2 Participation & Rewards

1. **Defense & Counter-Invasions**
   - Players can:
     - Close Rifts by defeating waves and anchors,
     - Take offensive Contracts to strike into invasion bases (micro-instanced).

2. **Rewards**
   - Shrine Standing for defending sacred sites.
   - Frontier Standing for defending/retaking frontier zones.
   - Special invasion loot:
     - Cursed materials,
     - Unique Runes,
     - Temporary titles.

3. **Failure Consequences**
   - If Rifts not handled:
     - Zone remains partially under enemy control longer.
     - Certain services remain suspended (banks, Task Boards in hotspots).
     - Higher-level invasions may propagate to nearby zones.

### 3.3 Faction Ties

- **Shrine Orders**
  - Rifts near shrines heavily tied to Shrine Standing and lore.
- **Frontier Militia**
  - Gains from major defense events.
- **Cartel**
  - Might exploit invasions for smuggling and looting (Cartel tasks).

### 3.4 Warframe-Style “Mode” Variants (Later)

- Over time, Rifts can gain:
  - Survival/Defense modes,
  - Endless waves,
  - Multi-stage “invasion campaigns” spanning multiple zones.

---

## 4. Hellgates – PvPvE Showdown Instances

Hellgates are **instanced PvPvE dungeons**:

- Two (or more) groups enter **separate entrances**,
- Converge toward a central boss,
- Winner takes the best loot.

### 4.1 Access & Entry

1. **Keys & Portals**
   - Hellgate Keys:
     - Crafted via high-tier materials,
     - Dropped from anomalies or Rifts,
     - Bound to certain zones.
   - Using a key:
     - Opens a Hellgate portal in the world.
     - Nearby players can see it and contest entry.

2. **Group Size & Caps**
   - Designed for small groups (2–5 players).
   - Hard capped at N groups per gate (usually 2).

### 4.2 Layout & Rules

1. **Map Layout**
   - Symmetrical or mirrored designs:
     - Two spawn points,
     - Branching paths,
     - Convergence on central boss room.

2. **Rules**
   - Full loot enabled.
   - Flasks do **not** refill inside.
   - Shrines may appear as **one-time-use** safety nodes.

3. **Win Conditions**
   - Kill the central boss **and** either:
     - Survive and extract,
     - Or be the last group standing.

### 4.3 Rewards

- Boss drops:
  - High-tier materials,
  - Unique Runes,
  - Hellgate-only cosmetics/titles.
- Atlas/Standing:
  - Frontier/Atlas Standing gains,
  - Potential Cartel interactions (illicit Hellgate loots).

### 4.4 Matchmaking & Risk

- No queue UI:
  - Hellgates are spawned in the world via keys.
- Some danger:
  - Other players can gank at the portal *before* you enter.
  - Hellgate mini-meta emerges around timing, scouting, and Atlas intel.

---

## 5. Contracts & Task Boards Tie-In

All three systems feed Contract generation:

1. **Anomaly Contracts**
   - “Scan and stabilize 3 anomalies in X zone.”
   - “Find and clear Ether Tear anomalies.”

2. **Rift Contracts**
   - “Close 2 minor Rifts.”
   - “Defend Y area during an invasion.”

3. **Hellgate Contracts**
   - “Successfully clear 1 Hellgate instance.”
   - “Bring back Hellgate fragments.”

Rewards scale with:

- Difficulty tier,
- Participant Standing (e.g. Frontier/Atlas),
- Zone risk (Green/Yellow/Red).

---

## 6. Implementation Plan

1. **C++ Spawn Systems**
   - Anomaly signature spawner.
   - Rift instability & invasion spawner.
   - Hellgate portal & instance manager.

2. **Data & Tables**
   - Tables for anomaly archetypes, loot pools, difficulty tiers.
   - Rift event templates & zone links.
   - Hellgate maps & configuration.

3. **Lua Scripts**
   - Boss mechanics,
   - Event waves,
   - Anomaly interactions.

4. **Atlas Integration**
   - API endpoints for:
     - Current instability per zone,
     - Recent anomalies/hellgates,
     - Recent deaths & completions.

5. **Wiki & UI**
   - Pages under:
     - `/wiki/content-and-activities/anomalies`,
     - `/wiki/content-and-activities/rifts`,
     - `/wiki/content-and-activities/hellgates`.
   - MortalUI: simple scanners & event prompts.

This creates a **robust exploration/PvPvE layer** that makes the world feel alive and gives non-raid content a deep, reusable structure.

