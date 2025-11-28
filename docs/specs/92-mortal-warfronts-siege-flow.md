# Project Canvas: Mortal Warcraft Overhaul  
### File: 92-mortal-warfronts-siege-flow.md  
### Topic: Warfronts, Sieges & Realm Warfare – Weekly Flow

> This document formalizes **how wars actually happen** in Mortal:  
> - Warfronts (full-loot battlegrounds with map objectives),  
> - Stronghold sieges (territory control),  
> - The weekly rhythm of conflict and rewards.

---

## 1. Design Goals

1. Provide a **predictable, opt-in war structure**:
   - Players know *when* big fights happen,
   - Can prepare and rally guilds.

2. Tie war directly into:
   - **Stronghold sovereignty** (who owns what),
   - **Economy** (resource shipments, Military Credits),
   - **Factions & Standing** (Frontier, Civic, Atlas, Cartel).

3. Avoid:
   - 24/7 offline structure sniping,
   - Flaky one-off events with no realm meaning,
   - Queued instanced PvP that feels detached from the world.

Implementation bias:
- Core scheduling & capture logic in C++,
- Scenario scripting & rewards in Lua.

---

## Related Specs

For full context on warfronts and siege systems, see:

- **`08-guilds-sovereignty.md`** — Guild system and stronghold ownership that warfronts affect
- **`97-mortal-guild-war-and-alliances.md`** — Guild war mechanics and alliances used in warfronts
- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege adaptation and mechanics
- **`11-pvp-systems.md`** — Core PvP systems and full-loot rules used in warfronts
- **`02-combat.md`** — Combat mechanics used in siege warfare
- **`51-factions-and-standing-system.md`** — Faction standing that affects warfront participation
- **`35-mortal-pvp-vendors-and-rewards.md`** — PvP rewards and currencies from warfronts
- **`98-mortal-siege-prep-contracts.md`** — Contracts and preparation for sieges

---

## 2. Warfronts – Instanced Frontline Battles

Warfronts are **instanced battlegrounds** with:

- Physical entry portals in the world (no LFR-style remote queuing),
- Full loot inside the instance,
- Territory & economic impact outside.

### 2.0 Complete Battleground-to-Warfront Mapping

All WoW 3.3.5a battlegrounds are converted to either **Classic Battlegrounds** (lower-risk PvP, see `11-pvp-systems.md`) or **Warfronts** (full-loot, territory-impacting). This section details the warfront conversions.

#### Warfront Conversions

| Original Battleground | Original Type | Mortal Warfront | Battle Window | Territory Impact | Notes |
|----------------------|---------------|-----------------|---------------|------------------|-------|
| **Alterac Valley** | 40v40 | Alterac Warfront | 2-3x per week | Stronghold resources | Large-scale territory control |
| **Isle of Conquest** | 40v40 | Conquest Warfront | 2-3x per week | Stronghold resources | Siege warfare with vehicles |
| **Arathi Basin** | 15v15 | Basin Warfront | 2-3x per week | Stronghold resources | Converted from Classic BG |
| **Wintergrasp** | World PvP | Wintergrasp Siege | Continuous | Direct Stronghold control | World PvP zone (see spec 95) |

#### Classic Battlegrounds (Not Warfronts)

These remain as lower-risk PvP experiences (Yellow Zone loot rules):
- Warsong Gulch (10v10) - Classic BG
- Eye of the Storm (15v15) - Classic BG
- Strand of the Ancients (15v15) - Classic BG

**Note:** Classic Battlegrounds have no territory impact and use partial loot rules. See `11-pvp-systems.md` for details.

### 2.1 Access & Scheduling

1. **Warfront Windows**
   - Each Warfront has scheduled **battle windows** (multiple per week).
   - Windows configured per realm (e.g. 2–3 evenings).
   - Entry portals activate 15–30 minutes before battle start.

2. **Entry**
   - Players enter via **world portals** near major hubs or Strongholds.
   - Entry requirements:
     - Minimum skill-based level,
     - Optional Standing requirements (e.g. Frontier Standing >= 10).

3. **Team Formation**
   - Teams can be:
     - Guild-based (two coalitions),
     - Ad-hoc alliances if participation is low.
   - Simple “join attacker/defender” choice on entry.

### 2.2 Rules & Objectives

1. **Full Loot**
   - Death inside a Warfront:
     - Uses corpse chest and loot rules (like Red Zones).
   - Extracting alive:
     - You keep whatever you carried and looted.

2. **Map Objectives**
   - Resource nodes, bunkers, towers, capture points:
     - Generate **war score** and **resource throughput**.
   - Final objectives:
     - Capture/defend central fort,
     - Destroy or protect key siege objectives.

3. **Duration**
   - Fixed duration (e.g. 30–45 minutes).
   - Ends on:
     - Victory condition reached,
     - Or timer expiration with score tiebreaker.

### 2.3 Rewards

1. **Per-Player Rewards**
   - Frontier Standing,
   - Military Credits (Honor re-flavored),
   - Loot (gear, Runes, mats looted from enemies and objectives).

2. **Realm/Stronghold Rewards**
   - Winning side’s **backing Stronghold(s)** receive:
     - Resource shipments (wood, iron, stone),
     - Militia buff (temporary defensive buffs),
     - Tax modifiers in owned territory.

---

## 3. Stronghold Sieges – Territory Change Events

Sieges are **realm-shaping events** where guilds fight over Strongholds.

### 3.1 Vulnerability Windows

1. **Window Configuration**
   - Each Stronghold has:
     - **Siege windows** configured by the owning guild (within realm limits).
   - Windows determine when Stronghold can be:
     - Challenged,
     - Attacked,
     - Captured.

2. **Challenge Mechanic**
   - Attacking guild must:
     - Declare war (formal Guild War),
     - Pay a **challenge fee** (gold, Military Credits, or resources),
     - Meet minimum criteria (member count, existing holdings).

3. **Lockouts**
   - Once a Stronghold is captured:
     - Short immunity window (no immediate re-challenge).
   - Prevents whiplash ownership changes.

### 3.2 Siege Flow

1. **Pre-Siege**
   - Announcement:
     - Broadcasts in-game and through Atlas.
   - Task Boards:
     - Generate prep Contracts (gather siege materials, repair walls, etc.).
   - Attacker & Defender:
     - Muster forces, deploy siege engines.

2. **Active Siege**
   - Multi-stage encounter:
     1. **Outer defenses** – towers, gates, traps.
     2. **Inner courtyard** – choke points, Stronghold core.
     3. **Flag / Sigil capture** – physical Stronghold sigil item that needs to be channeled and replaced.

   - Full loot is active:
     - Attackers/defenders risk gear,
     - Corpse chests litter the battlefield.

3. **Resolution**
   - Defenders hold out until timer ends → **defense win**.
   - Attackers capture and secure sigil → **capture win**.

4. **Post-Siege**
   - Ownership changes (if attackers win):
     - Guild taxes,
     - Resource generation,
     - Territory color on the map.
   - Debris & aftermath events:
     - Scavenger Contracts,
     - Repair Contracts.

### 3.3 Economic Effects

- **Strongholds**:
  - Generate passive resources and influence.
- **Siege outcomes**:
  - Rewrite regional economy:
    - Which guild controls local Task Boards,
    - Who collects certain Contract taxes,
    - Who gets resource shipments from Warfront victories.

---

## 4. Weekly Realm Warfare Flow

To make war feel structured, not random:

### 4.1 Weekly “Season” Rhythm (Example)

1. **Early Week – Build & Skirmish**
   - Warfronts:
     - One or two smaller, “seed” battles.
   - Stronghold:
     - Minimal sieges, more Contracts.
   - Focus:
     - Gathering resources,
     - Running Contracts,
     - Mapping enemy habits.

2. **Midweek – Ramping Conflict**
   - More sieges scheduled.
   - Warfronts become:
     - Higher stakes,
     - More Military Credits.

3. **End of Week – Major Push**
   - One or two **major Warfronts** with realm-wide stakes.
   - Big siege windows:
     - “Siege Night”.

4. **Reset**
   - Weekly summary in Atlas:
     - Which guilds gained/lost territory,
     - Standings adjusted,
     - Titles and achievements allocated.

### 4.2 Atlas & Killfeed

Atlas provides:

- Warfront schedule and Stronghold siege calendar.
- Live Warfront and siege status.
- Killfeed highlights:
  - “Top slayers,”
  - “Most valuable death (gear value),”
  - “Stronghold under attack” alerts.

---

## 5. Factions & Standing Interactions

War connects deeply with Standing:

1. **Frontier Militia Standing**
   - Gains from:
     - Warfront participation,
     - Stronghold defense/assault.
   - Scales war rewards.

2. **Civic Standing**
   - City-backed Warfronts:
     - Civic Standing gains for “state-sanctioned” wars.
   - Aggressive warbands that cause civilian collateral may lose Civic Standing.

3. **Atlas Standing**
   - Providing intel (map data, war reports) to Atlas:
     - Standing gains.
   - Special Contracts:
     - Scout enemy movements before sieges.

4. **Cartel Standing**
   - Cartel may sponsor:
     - Mercenary work during sieges,
     - Smuggling through war zones.

---

## 6. Integration with Other Systems

1. **Stronghold Sovereignty System**
   - Sieges maintain & flip the ownership flags.
   - Territory overlays on the map update after sieges.

2. **Task Boards**
   - Generate war-related Contracts:
     - Supply runs,
     - Scout Contracts,
     - Sabotage missions.

3. **Military Credits & Siege Tech**
   - Military Credits earned in Warfronts & sieges:
     - Spent on siege engines, fortifications, war consumables.

4. **Living Assets**
   - Mounts, pack mules, mercs:
     - Used heavily during sieges and Warfronts.
   - Risk:
     - Losing valuable mounts & companion assets in major battles.

---

## 7. Implementation Plan

1. **Warfront Engine**
   - C++ module for:
     - Warfront scenarios,
     - Team assignment,
     - Objective scoring,
     - Full-loot handling.

2. **Siege Controller**
   - C++ module managing:
     - Stronghold windows,
     - Siege states,
     - Ownership changes.

3. **Database**
   - Tables for:
     - Warfront definitions & schedules,
     - Stronghold configs,
     - Past results (for Atlas & history).

4. **Lua Scripting**
   - Scenario-specific mechanics:
     - Towers, flags, NPC reinforcements.
   - Reward distribution.

5. **Atlas Integration**
   - API for:
     - Current & upcoming Warfronts,
     - Siege schedule & results.

6. **UI & Wiki**
   - MortalUI:
     - War calendar view.
   - Wiki:
     - `/wiki/guilds-strongholds-warfronts/warfronts`,
     - `/wiki/guilds-strongholds-warfronts/sieges`.

---

## 8. Summary

This Warfront & Siege Flow:

- Gives Mortal a **clear, repeatable war cadence** that:
  - Feels big and meaningful,
  - Rewards preparation and intelligence,
  - Avoids random offline snipes.

- Binds together:
  - Strongholds,
  - Warfronts,
  - Standing,
  - Economy,
  - Atlas & killfeed,
  - Living Assets,

into a **single, coherent realm warfare loop** that fits your EVE + Mortal + WoW mashup vision.
