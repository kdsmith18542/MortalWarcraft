# Project Canvas: Mortal Warcraft Overhaul  
### File: 100-mortal-post-war-aftermath-and-reconstruction.md  
### Topic: Post-War Aftermath & Reconstruction Loops

> This document defines what happens **after sieges and heavy wars**:  
> - Damage, instability, and temporary penalties,  
> - Repair & reconstruction Contracts,  
> - Faction reactions,  
> - How guilds and players bring a region back to stability (or keep it in chaos).

---

## 1. Design Goals

1. Make wars and sieges **leave scars**:
   - Strongholds and regions don’t magically snap back,
   - Visible damage and temporary debuffs.

2. Provide **new content after war ends**:
   - Reconstruction, cleanup, and stabilizing Contracts,
   - Economic opportunities and Standing shifts.

3. Prevent:
   - Perma-war degeneracy,
   - Unfun “locked in rubble forever” states.

Implementation bias:
- C++ `MortalWarAftermathManager` + DB flags,
- Task Boards + Lua contracts for reconstruction.

---

## Related Specs

For full context on post-war aftermath and reconstruction, see:

- **`92-mortal-warfronts-siege-flow.md`** — Siege flow system that triggers aftermath
- **`08-guilds-sovereignty.md`** — Stronghold system that requires reconstruction
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task boards that provide reconstruction contracts
- **`51-factions-and-standing-system.md`** — Faction system that reacts to war aftermath
- **`04-economy.md`** — Economy system for reconstruction costs and economic opportunities
- **`37-economy-system-extensions.md`** — Economy extensions that affect post-war recovery
- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege adaptation that causes damage

---

## 2. Stronghold State After Siege

Each Stronghold has at least these states:

1. **Stable** – Intact, fully functional.
2. **Under Siege** – Active battle.
3. **Recently Sacked** – Just fell to attackers.
4. **Damaged** – Ownership resolved, but structures & services not fully restored.

### 2.1 Recently Sacked

Immediately after an attacker victory:

- Visuals:
  - Smoke, fires, partial ruins,
  - Dead NPCs, broken props.

- Systems:
  - Some vendors unavailable,
  - Stall capacity reduced,
  - Local guard presence weakened.

- Bonuses:
  - Attackers may get temporary:
    - Loot rights,
    - Reduced taxes / free access.

Duration:
- Short window (e.g. 30–60 minutes real time) before moving to `Damaged`.

---

### 2.2 Damaged

Once the initial chaos fades:

- Stronghold is usable, but impaired:
  - Reduced:
    - Resource generation,
    - Contract variety,
    - Defensive strength.
- Reconstruction becomes available.

State persists until:
- Enough reconstruction Contracts are completed, or
- A global event/passage of time auto-restores minimal functionality.

---

## 3. Reconstruction Contracts

### 3.1 Categories

1. **Structural Repairs**
   - “Rebuild the Walls”
   - “Repair the Gate”
   - “Raise New Towers”
   - Requirements:
     - Deliver Building Materials (stone, wood, metal),
     - Pay worker wages (gold).
   - Effects:
     - Increase Stronghold **Fortification Level**,
     - Restore wall/tower HP to baseline or above.

2. **Civilian Recovery**
   - “Aid the Refugees”
   - “Provision the Homeless”
   - Requirements:
     - Deliver food, blankets, crafted goods,
     - Escort refugees back.
   - Effects:
     - Increases Civic Standing for participants,
     - Reduces long-term Civic penalties from war.

3. **Garrison Reconstitution**
   - “Recruit the New Guard”
   - “Arm the Watch”
   - Requirements:
     - Deliver weapons, armor kits,
     - Gold for wages.
   - Effects:
     - Restores / improves Stronghold guard NPCs and patrols,
     - Boosts defensive response to future attacks.

4. **Sanitation & Plague Prevention**
   - “Burn the Corpses”
   - “Cleanse the Water”
   - Requirements:
     - Destroy body piles, purify wells,
     - Deliver alchemical agents.
   - Effects:
     - Prevents or ends negative environmental effects:
       - Disease, morale penalties, damaged Standing.

---

### 3.2 Metrics & Completion

`MortalWarAftermathManager` tracks:

- `fortification_repair` (0–100),
- `civilian_recovery` (0–100),
- `garrison_readiness` (0–100),
- `sanitation_level` (0–100).

Completion thresholds:

- At certain thresholds (e.g. 50, 75, 100), the Stronghold:
  - Unlocks more vendors,
  - Restores full resource generation,
  - Becomes fully fortified for next siege.

Players/guilds that contribute heavily may:

- Get their names on **Stronghold plaques** (lore flavor),
- Gain special titles:
  - `the Rebuilder`, `the Steward of Wintergrasp`.

---

## 4. War Fatigue & Cooldowns

To avoid siege spam:

- After a Stronghold is **Recently Sacked**:
  - A **War Fatigue** flag is applied:
    - Prevents another siege challenge for X hours,
    - Or makes subsequent challenges significantly more expensive.

Additional systems:

- Guilds that constantly launch sieges:
  - May suffer Civic Standing penalties,
  - May trigger Civic “Peacekeeping” Contracts against them.

---

## 5. Faction Reactions Post-War

### 5.1 Civic

- If reconstruction proceeds:
  - Civic Standing bonuses for participants,
  - Civic might:
    - Reduce or forgive some prior legal penalties.

- If Stronghold remains in ruins:
  - Civic may:
    - Raise taxes in that region,
    - Deploy additional guards or lock down roads,
    - Offer Contracts to other guilds to restore order.

### 5.2 Frontier

- Successful reconstruction:
  - Frontier Standing gains for guilds that participate heavily,
  - Stronghold becomes a more important frontier hub.

- Neglect:
  - Frontier Standing penalties:
    - “You let the frontier burn.”
  - Frontier may shift its support to other guilds.

### 5.3 Cartel

- During chaos:
  - Cartel may:
    - Spawn Black Market stalls in temporary camps,
    - Offer scavenging/smuggling Contracts.

- After stabilization:
  - Cartel’s presence may:
    - Diminish if Civic/Frontier push them out,
    - Or become entrenched if they helped “rebuild” in their own way.

### 5.4 Atlas

- After major wars & sieges:
  - Atlas updates:
    - War reports,
    - Historical overlays on Atlas map.
- Reconstruction participation:
  - Rewards Atlas Standing when rebuilding historically notable Strongholds.

---

## 6. Aftermath Events & Hooks

### 6.1 Dynamic Events

Leaving a Stronghold damaged may:

- Spawn:
  - Bandit gangs,
  - Plague outbreaks,
  - Monster incursions in surrounding zones.

Reconstruction progress:

- Gradually reduces these adverse events,
- Adds side quests and Contracts around them.

### 6.2 Long-Term Consequences

Choices matter:

- A Stronghold rebuilt with Cartel help:
  - May become a smuggling hub,
  - Shift its **internal politics** toward Cartel-friendly options.

- A Stronghold rebuilt with Civic/Frontier focus:
  - Becomes a bastion of law & defense,
  - Gains higher guard presence and protective perks.

---

## 7. Economic & Player Retention Benefits

- After a big war, the **world doesn’t go idle**:
  - Players log in to find:
    - Reconstruction tasks,
    - Cheap scavenging opportunities,
    - Special post-war prices and Contracts.

- This keeps:
  - Crafters busy (repair kits, building materials),
  - Gatherers in demand,
  - Solo & small group players involved even outside of siege hours.

---

## 8. Implementation Sketch

### 8.1 C++ Manager

`src/server/game/Mortal/War/MortalWarAftermathManager.*`

Responsibilities:

- Track Stronghold state (Stable, Recently Sacked, Damaged),
- Track reconstruction metrics,
- Apply:
  - Resource generation multipliers,
  - Vendor availability flags,
  - Guard strength modifiers.

### 8.2 Task Boards & Lua

- New Contract types flagged as **Reconstruction**:
  - Spawn automatically post-siege,
  - Retire when Stronghold metrics are restored.

Lua handles:

- Per-Contract logic (accept, track progress, completion),
- Calling C++ APIs to modify recovery metrics.

---

## 9. Summary

The aftermath system makes wars:

- **Matter beyond the battle**:
  - Strongholds can be left ruined, vulnerable, or rebuilt stronger than before.
- **Feed the economy and Standing systems**:
  - Reconstruction is lucrative and reputation-heavy work.
- **Drive emergent stories**:
  - “We sacked Wintergrasp, then rebuilt it as a Cartel den,”
  - “Frontier militias saved the region after Civic pulled out.”

This keeps Mortal’s war gameplay feeling like a **living campaign**, not disconnected matches.
