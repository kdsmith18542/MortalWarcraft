# Project Canvas: Mortal Warcraft Overhaul  
### File: 95-wintergrasp-to-mortal-siege-adaptation.md  
### Topic: Adapting Wintergrasp into Mortal Stronghold Sieges

> This document describes **how to repurpose Wintergrasp** (3.3.5a outdoor PvP zone)  
> into the backbone of Mortal’s Stronghold Siege system.  
>  
> Goal: leverage existing siege mechanics (vehicles, walls, state machine) while  
> layering Mortal’s full-loot, Stronghold ownership, Standing, and war calendar on top.

---

## 1. High-Level Approach

1. **Keep**:
   - Siege vehicles and vehicle factories (workshops),
   - Destructible walls, towers, fortress gate,
   - Battle state machine (queue → battle → outcome → control),
   - Outdoor-PvP “zone-wide battle” baseline logic.

2. **Replace / Extend**:
   - Reward logic (Honor, marks, teleports) → **Military Credits, Standing, Stronghold ownership**,
   - Battle scheduling → **MortalSiegeController** + war calendar,
   - Death handling → **full-loot Red-Zone rules**,
   - Faction assumptions (Horde vs Alliance) → **Guild-based attacker/defender**.

3. **Expose** Wintergrasp-derived siege scenarios as:
   - The **first Stronghold siege map** (Fortress of Wintergrasp),
   - A general template for later custom Stronghold siege maps.

---

## 2. Current Wintergrasp Concepts (Vanilla WotLK / AzerothCore)

Wintergrasp provides:

- A dedicated **outdoor PvP zone** with:
  - Fortress (inner keep),
  - Walls, towers, gate,
  - Workshops and guard towers.

- A **battle state machine**:
  - Defending faction vs attacking faction,
  - Scheduled start/end,
  - Control persists outside battle.

- **Siege Vehicles**:
  - Catapults, Demolishers, Siege Engines,
  - Built at workshops using resources.

- **Victory Conditions**:
  - Attackers win: breach and capture inner keep,
  - Defenders win: hold until timer expires.

Right now it:
- Assumes **faction-based teams** (A vs H),
- Grants **Honor** and Wintergrasp marks,
- Controls access to Vault of Archavon.

---

## 3. Target Mortal Siege Concepts

From `92-mortal-warfronts-siege-flow.md` and Stronghold specs:

- **Stronghold**:
  - A fortress map with owner guild,
  - Generates resources, taxes, buffs.

- **Siege**:
  - Attacker guild challenges defender,
  - Occurs in a **vulnerability window**,
  - Full loot applies,
  - Outcome flips Stronghold ownership and realm economics.

- **Rewards**:
  - Military Credits,
  - Standing (Frontier, Civic, Cartel/Atlas hooks),
  - Resource shipments to owning Stronghold.

Wintergrasp is a **perfect fit** for the "physical battle" slice of this.

---

## Related Specs

For full context on siege adaptation, see:

- **`92-mortal-warfronts-siege-flow.md`** — Warfront and siege flow system that this adapts
- **`08-guilds-sovereignty.md`** — Stronghold system and territory control that sieges affect
- **`97-mortal-guild-war-and-alliances.md`** — Guild war mechanics used in sieges
- **`98-mortal-siege-prep-contracts.md`** — Siege preparation contracts and logistics
- **`11-pvp-systems.md`** — PvP systems and full-loot rules used in sieges
- **`02-combat.md`** — Combat mechanics used in siege warfare
- **`35-mortal-pvp-vendors-and-rewards.md`** — PvP rewards and Military Credits from sieges

---

## 4. Architecture: Layering Mortal on Wintergrasp

### 4.1 Module Roles

We define clear responsibilities:

- **Wintergrasp Scenario (existing / adapted)**  
  Location (example):  
  `src/server/game/Battlegrounds/Wintergrasp/WintergraspBattle.cpp` (or equivalent AC structure)
  - Handles:
    - Vehicle spawning,
    - Walls/tower HP,
    - Zone objectives,
    - Core battle flow.

- **MortalSiegeController** (new)  
  Location:  
  `src/server/game/Mortal/War/MortalSiegeController.*`
  - Handles:
    - Which Stronghold is using Wintergrasp as its map,
    - Siege windows & challenge logic,
    - Attacker/defender guild selection,
    - Ownership flips & lockouts,
    - Notifications / war calendar integration.

- **MortalStrongholds** (existing from spec)  
  Location:  
  `src/server/game/Mortal/War/MortalStrongholds.*`
  - Handles:
    - Which guild owns the fortress,
    - Tax/resource buff changes after siege,
    - Territory map updates.

- **MortalChat / MortalBroadcasts**  
  - Handles in-game messaging around sieges.

- **MortalEconomyCore / MortalStanding**  
  - Calculate Military Credits and Standing payouts.

---

## 5. Concrete Adaptation Steps

### 5.1 Strip & Redirect Wintergrasp Rewards

- **Disable**:
  - Honor & Wintergrasp Mark rewards,
  - Teleport rewards / access gating to Vault of Archavon (or repurpose Vault later).

- **Add**:
  - Post-battle hook into `MortalSiegeController::OnSiegeEnded(...)`:
    - Parameters:
      - `SiegeResult result`,
      - `GuildId attackerGuild`,
      - `GuildId defenderGuild`,
      - `StrongholdId strongholdId`,
      - `std::vector<ObjectGuid> attackerPlayers`,
      - `std::vector<ObjectGuid> defenderPlayers`.

- Reward logic moved to Mortal:
  - Military Credits: `MortalEconomyCore::GrantMilitaryCredits(player, amount);`
  - Standing: e.g. `MortalStanding::AddStanding(player, FACTION_FRONTIER, +X);`

---

### 5.2 Replace Faction-Based Teams With Guild Coalitions

- Wintergrasp currently uses:
  - Horde vs Alliance as team 0/1.

- Mortal adaptation:
  - At siege start:
    - **Choose defender team** = owning guild + allies (friendly guilds),
    - **Choose attacker team** = challenger guild + allies.

- Implementation:
  - `MortalSiegeController` builds team rosters:
    - When players speak with siege NPC or click “Join Siege”:
      - Determine if their guild is attacker/defender/neutral,
      - Assign them to the appropriate side,
      - Neutral/non-involved guilds either:
        - Cannot join, or
        - Join “mercenary slots” for either side (configurable later).

- Wintergrasp code:
  - Accept guild-based team assignment instead of faction-based:
    - Map “Team 0” to defender side,
    - Map “Team 1” to attacker side,
    - Ignore faction for this context.

---

### 5.3 Full-Loot Integration

- Wintergrasp by default uses standard BG-style death (no full loot).

Adaptation:

1. **Mark the Wintergrasp zone as “Siege Mode Red Zone”** during active siege:
   - `MortalWorldHooks` / `MortalWarfrontEngine`:
     - On siege start, set zone flag `ZONEFLAG_MORTAL_FULL_LOOT`.

2. **Use existing Mortal death/loot hooks**:
   - In `MortalPlayerHooks::OnPlayerKilled(...)`:
     - If zone has `ZONEFLAG_MORTAL_FULL_LOOT` and player is in active siege:
       - Create corpse chest,
       - Apply normal Red Zone full-loot logic.

3. **Disable / bypass**:
   - Any BG-specific Spirit Healer logic inside Wintergrasp.
   - Ensure **Shrine respawn rules** still apply; possibly:
     - Use siege-appropriate shrines near fortress entry.

---

### 5.4 Siege Windows & War Calendar

Wintergrasp includes internal scheduling; we want **Mortal to own the schedule**.

Plan:

- **Disable automatic Wintergrasp timers**:
  - No global “battle every X hours” logic.

- **Use `MortalSiegeController` windows instead**:
  - Stronghold has configured “vulnerability windows”.
  - When a challenge is accepted:
    - `MortalSiegeController` schedules a battle in the Wintergrasp map at a given time.
    - On start:
      - It calls into Wintergrasp scenario to:
        - Open portals / queue entries,
        - Initialize battle state.

- Atlas integration:
  - Siege times show on Atlas war calendar via `MortalUIBridge` / web API.

---

### 5.5 Ownership Flip & Stronghold Integration

Wintergrasp normally flips **zone control** between factions.  
Mortal needs to flip a **Stronghold guild owner** instead.

- On battle end:
  - Wintergrasp calls `MortalSiegeController::OnSiegeEnded` with attacker/defender scores.
  - `MortalSiegeController` decides:
    - If attackers win → call `MortalStrongholds::SetStrongholdOwner(strongholdId, attackerGuild);`
    - If defenders win → keep existing owner.

- Side effects handled by `MortalStrongholds`:
  - Update:
    - Resource generation owner,
    - Territory overlays (map color),
    - Tax recipients,
    - Standing hooks (Frontier Militia, Civic, etc.).

---

## 6. Gameplay Tuning for Mortal

### 6.1 Adjust Siege Vehicle Power & Cost

Wintergrasp vehicles expect WotLK stat budgets.

We need to:

- Lower overall HP/damage to fit Mortal’s stat squish.
- Tie vehicle construction cost into:
  - Siege materials crafted by professions,
  - Military Credits (optional),
  - Stronghold stockpiles.

Design rule:

- Vehicles should be **expensive but powerful**, not spammy:
  - Their loss should **hurt** the attacking/defending side economy.

---

### 6.2 Death & Respawn Flow

To align with Mortal’s risk model:

- Respawn:
  - Use **Shrine-style** respawn nodes in/around siege zone:
    - Maybe forward shrines captured by attackers,
    - Defender shrines behind inner walls.

- Corpse run:
  - Players respawn at shrine **without gear** (gear is in siege corpse chest).
  - Must fight/scout their way back to reclaim it (if possible).

---

### 6.3 Participation & Lockouts

- Players joining sieges:
  - Limited to:
    - Members of attacking/defending guilds (and allies),
    - A small pool of mercenary spot-joiners (future).

- Lockouts:
  - Players who desert early might:
    - Lose some Standing,
    - Get tagged with a deserter penalty for future siege signups.

Implementation later; note it here as design intent.

---

## 7. Season 1 vs Later Phases

### 7.1 Season 1 (Launch)

- Ship Wintergrasp-based siege as:
  - **The primary Stronghold siege**:
    - “Fortress of Wintergrasp” = key frontier Stronghold.
- Ensure:
  - Basic full-loot rules inside,
  - Ownership flip works,
  - Rewards use Mortal currency & Standing,
  - War calendar integration is functioning.

### 7.2 Season 1.5+

- Clone/adapt Wintergrasp siege scenario code into:
  - A reusable `MortalSiegeScenario` base.
- Add additional siege maps:
  - Smaller fortress layouts,
  - Coastal Strongholds,
  - Tower-focused maps.

### 7.3 Season 2+

- Deeper features:
  - Additional siege engines (Meat Wagon, Arcane Cannon),
  - Stronghold upgrade trees (walls, traps),
  - Siege campaigns chaining multiple Strongholds.

---

## 8. Spec & Code References

**Specs this depends on:**

- `92-mortal-warfronts-siege-flow.md` – War & sieges weekly flow.
- `86-mortal-factions-and-standing.md` – Standing & factions.
- `90-mortal-living-assets-companions.md` – Mount & asset risk in sieges.
- `93-mortal-cpp-module-index.md` – where `MortalSiegeController` and `MortalStrongholds` live.

**Core modules involved:**

- `MortalStrongholds`
- `MortalSiegeController`
- `MortalWarfrontEngine` (for shared logic)
- `MortalEconomyCore`
- `MortalStanding`
- `MortalChat` / `MortalBroadcasts`
- Wintergrasp battleground/scenario code.

---

## 9. Summary

- Wintergrasp already **is** a functional siege: walls, vehicles, state machine.
- Mortal wraps it with:
  - Full-loot Red-Zone rules,
  - Guild-based attacker/defender,
  - Stronghold ownership flips,
  - Military Credits & Standing rewards,
  - War calendar & Atlas integration.

This approach drastically **reduces implementation risk** while still delivering a  
distinct Mortal-style siege experience from Season 1 onward.
