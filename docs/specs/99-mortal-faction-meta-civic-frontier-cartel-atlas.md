# Project Canvas: Mortal Warcraft Overhaul  
### File: 99-mortal-faction-meta-civic-frontier-cartel-atlas.md  
### Topic: Faction Meta – Civic, Frontier, Cartel & Atlas Roles in the Sandbox

> This document defines the **four soft-power factions** that watch, react to,  
> and shape Mortal’s player-driven politics and economy:  
> - Civic (cities, law, stability)  
> - Frontier (strongholds, militias, outer territories)  
> - Cartel (black/grey markets, smuggling, profit)  
> - Atlas (intel, exploration, information markets)  
>  
> It explains how they respond to guild wars, sieges, Contracts, and crime,  
> and how Standing with each faction changes gameplay.

---

## 1. High-Level Concept

The world isn’t just “players vs mobs”; it’s:

- **Civic** – The cities, guards, magistrates, “civilized” world.
- **Frontier** – Strongholds, militias, risk-takers beyond the walls.
- **Cartel** – Smugglers, fences, black-market brokers.
- **Atlas** – Scholars, scouts, navigators, data-keepers.

Each faction:

1. Has a **Standing** meter per player (and optionally per guild),
2. Offers **services, discounts, Contracts** at high Standing,
3. Enforces **sanctions, guard hostility, or taxes** at low Standing.

They act as **soft governors** on player behavior:
- Encouraging healthy wars & trade,
- Discouraging griefing, degenerate crime, and economic abuse.

---

## Related Specs

For full context on faction meta systems, see:

- **`51-factions-and-standing-system.md`** — Core faction system and standing mechanics
- **`86-mortal-factions-and-standing.md`** — Faction and standing implementation details
- **`60-faction-sanctums.md`** — Faction sanctums for each major faction
- **`24-webportal-mortal-atlas.md`** — Atlas web portal for Atlas Consortium faction
- **`08-guilds-sovereignty.md`** — Stronghold system that Frontier faction supports
- **`11-pvp-systems.md`** — PvP systems that factions respond to
- **`04-economy.md`** — Economy system that Cartel faction operates in

---

## 2. Faction Roles & Personality

### 2.1 Civic

**Theme**: Law, order, infrastructure, city life.

- Likes:
  - Stability, fair trade, protection of civilians,
  - Successful defence Contracts, city supply deliveries,
  - Responsible use of Guild War (clear casus belli, minimal collateral).

- Dislikes:
  - Random murder in Green/Yellow zones,
  - Repeated siege spam on low-value targets,
  - Abuse of prisoners and civilians, excessive banditry.

**Standing effects:**

- High Civic Standing:
  - Safe city access (guards ignore minor mischief),
  - Lower taxes in capital markets,
  - Access to high-tier Civic Contracts:
    - Citywide construction, public works, infrastructure.
  - Civic-themed titles:
    - `the Warden`, `the Justicar`, `the Magistrate`.

- Low Civic Standing:
  - Guards may:
    - Demand bribes or attack on sight,
    - Restrict access to city services (banks, markets),
  - Higher stall fees and civic taxes,
  - Marked as “undesirable” in city UI.

---

### 2.2 Frontier

**Theme**: Strongholds, militias, grit, borderlands.

- Likes:
  - Stronghold defence & offence,
  - Siege prep Contracts,
  - Killing nightmare beasts and world bosses,
  - Guilds who hold & defend frontier territory.

- Dislikes:
  - Cowardice (avoiding responsibility for Strongholds),
  - Abandoning frontier zones to enemy control,
  - Neglecting shrines and leaving them corrupted.

**Standing effects:**

- High Frontier Standing:
  - Better Stronghold access:
    - Preferred Contracts,
    - Priority stall spots in frontier hubs,
  - Lower entry costs for Warfronts & sieges,
  - Frontier-themed titles:
    - `Bulwark of Wintergrasp`, `the Stormwatcher`, `the Vanguard`.

- Low Frontier Standing:
  - Limited participation in Stronghold-related content,
  - Weaker or no access to frontier services,
  - NPCs may refuse to aid in frontier Contracts.

---

### 2.3 Cartel

**Theme**: Profit, smuggling, black markets.

- Likes:
  - Trade volume (legal or not),
  - Smuggling Contracts,
  - Use of Black Market / Darkmoon Faire,
  - High-risk commerce in Red Zones.

- Dislikes:
  - Attacking Cartel assets without cause,
  - Snitching to Civic/Frontier on Cartel operations.

**Standing effects:**

- High Cartel Standing:
  - Access to:
    - Better prices at black markets,
    - Special Contraband Contracts,
    - Rare recipes & blueprints,
  - Reduced penalties when caught with illicit goods,
  - Titles:
    - `the Broker`, `the Smiling Knife`, `the Syndicate`.

- Low Cartel Standing:
  - Higher prices or refusal at black markets,
  - Target priority for Cartel-aligned mercs,
  - Difficulty using smuggling routes.

---

### 2.4 Atlas

**Theme**: Information, maps, intel, research.

- Likes:
  - Exploration, landmark discovery,
  - Anomaly/Rift/Hellgate intel,
  - War reporting and neutral observation,
  - Cartography & contributions to Mortal Atlas.

- Dislikes:
  - Destroying records and books,
  - Killing neutral Atlas scribes/reporters,
  - Feeding false intel (once detected).

**Standing effects:**

- High Atlas Standing:
  - Better access to:
    - Map overlays:
      - Hot zones, invasion patterns, trade routes,
    - Early warnings for Rifts and anomalies,
    - Special Explorer/Reporter Contracts.
  - Titles:
    - `the Wayfinder`, `the Chronicler`, `Eyes of the Realm`.

- Low Atlas Standing:
  - Blurred or delayed intel on Atlas (foggy map, fewer details),
  - Exclusion from some high-level intel and Contracts.

---

## 3. Standing Sources

### 3.1 Civic Standing

Increases from:

- Completing Civic Task Board Contracts:
  - City defence, infrastructure, supply lines,
- Defending civilians in Green/Yellow zones,
- Stopping banditry (killing high-Notoriety criminals in non-Red zones),
- Maintaining limited, justified Guild Wars with minimal collateral.

Decreases from:

- Killing innocents in Green/Yellow zones,
- Repeatedly declaring wars without clear threat or purpose (vendetta spam),
- Leading large-scale raids into cities,
- Excessive use of black markets (minor hit if too dominant).

---

### 3.2 Frontier Standing

Increases from:

- Stronghold siege participation (attack or defence),
- Completing frontier-based Contracts (world bosses, Rift defence, scouting),
- Holding and defending Strongholds against superior odds.

Decreases from:

- Abandoning Strongholds (letting them fall without resistance),
- Exploiting frontier resources without defending the region,
- Colluding with enemy forces to undermine frontier stability.

---

### 3.3 Cartel Standing

Increases from:

- Using Black Market / Darkmoon Faire fences,
- Completing Cartel Contracts (smuggling, counter-smuggling, “asset recovery”),
- High trade volume in risky zones.

Decreases from:

- Killing Cartel NPCs or sabotaging their routes,
- Repeatedly siding with Civic/Frontier against Cartel operations,
- Intercepting Cartel shipments too often.

---

### 3.4 Atlas Standing

Increases from:

- Discovering landmarks, anomalies, Rifts,
- Completing scouting and mapping Contracts,
- Providing accurate siege and war reports.

Decreases from:

- Killing Atlas-aligned NPCs (scribes, scouts, reporters),
- Delivering obviously false intel,
- Destroying libraries and archives.

---

## 4. Reactions to Guild Wars & Sieges

### 4.1 Civic Reaction

- Approves:
  - Wars with clear justification:
    - Retaliation for previous aggression,
    - Defence of cities or civilians.
- Disapproves:
  - Endless war spam,
  - Sieges that primarily harm civilians and city economies.

Civic effects:

- Could temporarily:
  - Raise city guard strength vs aggressor guilds,
  - Increase taxes on war profiteers,
  - Offer special **Peacekeeping Contracts**.

---

### 4.2 Frontier Reaction

- Approves:
  - Wars that stabilize frontier, protect Strongholds from monsters,
  - Successful defence of frontier against large invasions.
- Disapproves:
  - Neglecting frontier Strongholds,
  - Letting enemy or monsters overrun shrines/fortresses.

Frontier effects:

- May:
  - Provide buffs to defenders with high Frontier Standing,
  - Open special Warfronts for guilds with strong frontier reputation.

---

### 4.3 Cartel Reaction

- Approves:
  - Wars that increase trade volume, smuggling, demand for contraband,
  - Chaos that opens black-market opportunities.
- Disapproves:
  - Peacekeeping efforts that reduce their profits,
  - Unprofitable wars that dry up trade.

Cartel effects:

- Might:
  - Offer lucrative smuggling & arms-dealing Contracts during wars,
  - Provide secret routes or intel to favored sides.

---

### 4.4 Atlas Reaction

- Approves:
  - Wars that generate “interesting data” and stories,
  - Exploration into new or dangerous zones.
- Disapproves:
  - Destruction of knowledge sites,
  - Targeting neutral Atlas agents.

Atlas effects:

- Provides:
  - Enhanced war reporting on Atlas (maps, battle summaries),
  - Special recognition titles for strategists and scouts.

---

## 5. Integration Points

### 5.1 With Guild Politics

- Certain actions in `MortalGuildPolitics` adjust Standing:
  - Declaring war:
    - +Frontier Standing, -Civic Standing (depending on context),
  - Ending war with Truce:
    - +Civic Standing,
  - Excessive war vs much weaker guilds:
    - -Civic, -Frontier, +Cartel (war profiteers).

### 5.2 With Sieges & Warfronts

- High Frontier Standing:
  - Better siege rewards,
  - Lower Warfront entry cost, or bonus pay.

- High Civic Standing:
  - Smaller penalties for collateral civilian damage (to a point),
  - Access to city-sponsored war Contracts.

- Cartel & Atlas:
  - Influence side Contracts, intel availability, smuggling channels.

---

## 6. UI & Atlas Representation

### 6.1 MortalUI

- Add Standing summary widget:
  - Small list of:
    - Civic, Frontier, Cartel, Atlas,
    - Numerical value + rank,
    - Simple text summarizing how NPCs react to you.

### 6.2 Atlas Web

- Player profile:
  - Standing bars or badges for each faction.
- World view:
  - Map overlays showing:
    - Frontier intensity zones,
    - Cartel influence in certain hubs,
    - Atlas observation posts.

---

## 7. Implementation Notes

- All Standing changes should:
  - Be incremental and soft,
  - Avoid “hard lock-outs” wherever possible (but strong discouragement is fine).
- Faction behavior:
  - Implemented server-side,
  - Lua used for specific NPC dialogues and Contracts.

---

This meta layer turns **Civic/Frontier/Cartel/Atlas** into a living “alignment system” that  
monitors and nudges player behavior across war, trade, and exploration, without removing agency.
