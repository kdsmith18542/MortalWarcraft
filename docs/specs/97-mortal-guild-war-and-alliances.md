# Project Canvas: Mortal Warcraft Overhaul  
### File: 97-mortal-guild-war-and-alliances.md  
### Topic: Guild Wars, Alliances & Political Status

> This document defines how **guild-level relationships** work in Mortal:  
> - Formal Wars (legal PvP everywhere between specific guilds),  
> - Alliances (blue status, shared services),  
> - Neutrality & temporary pacts,  
> and how these tie into sieges, Strongholds, Standing and Notoriety.

---

## 1. Design Goals

1. Replace binary A/H faction thinking with **player-made politics**:
   - Guild vs guild, coalition vs coalition,
   - Alliances and rivalries that matter mechanically.

2. Clarify **when PvP is “legal”**:
   - Guild Wars: legal targets everywhere (no Notoriety),
   - Non-war kills: follow Yellow/Red zone rules (crime, Notoriety).

3. Integrate:
   - **Stronghold ownership** (who controls what),
   - **Siege eligibility** (who can attack who),
   - **Task Boards & taxes**,
   - **Titles & guard behavior**.

Implementation bias:
- C++ core (`MortalGuildPolitics`) with DB tables,
- Lua only for UI glue and atlas reporting.

---

## Related Specs

For full context on guild war and alliance systems, see:

- **`08-guilds-sovereignty.md`** — Guild system and stronghold ownership that wars affect
- **`92-mortal-warfronts-siege-flow.md`** — Warfront and siege systems that use guild wars
- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege mechanics and territory control
- **`11-pvp-systems.md`** — PvP systems and criminal logic that interact with guild wars
- **`56-negative-titles-and-notoriety-labels.md`** — Notoriety system that guild wars bypass
- **`51-factions-and-standing-system.md`** — Faction standing affected by guild war actions

---

## 2. Core Concepts

### 2.1 Relationship Types

Between any two guilds `A` and `B`, there is exactly one status:

1. **Neutral** (default)
   - No special rules.
   - PvP governed by zone risk & crime rules only.
   - Members show as neutral in UI/nameplates.

2. **Alliance** (Blue)
   - “Friendly” status for cooperation:
     - No friendly fire in Green/Yellow Zones (unless configured),
     - Shared access to some Stronghold services,
     - Can co-own or co-defend Strongholds (coalition).
   - Members show as **blue** in UI/nameplates.

3. **Guild War** (Red)
   - Formal, declared war:
     - **Legal PvP anywhere**, no Notoriety from killing enemy guild members,
     - Red nameplates and clear UI markers,
     - Eligible to siege each other’s Strongholds (with constraints).
   - Can be:
     - Standard war (mutual declaration),
     - Vendetta (one-sided but costs more Civic Standing).

4. **Truce / Ceasefire** (temporary)
   - Time-limited freeze on hostilities:
     - Cannot start new wars or siege during active truce,
     - Breaking a truce has harsh Civic Standing penalties.

---

## 3. Data Model & Storage

### 3.1 Tables

- `mortal_guild_relations`
  - `guild_id_a`
  - `guild_id_b`
  - `relation_type` (NEUTRAL, ALLIANCE, WAR, TRUCE)
  - `initiator_guild_id`
  - `start_time`
  - `end_time` (for truce/war cooldowns)
  - `notes` (GM-facing text)

- `mortal_guild_pacts` (optional later)
  - For special agreements (e.g., trade, non-aggression).

### 3.2 C++ Module

- `src/server/game/Mortal/War/MortalGuildPolitics.h/cpp`

Core APIs:

```cpp
enum class GuildRelationType { Neutral, Alliance, War, Truce };

GuildRelationType GetRelation(GuildId a, GuildId b);
void SetRelation(GuildId a, GuildId b, GuildRelationType type);

bool AreAllied(GuildId a, GuildId b);
bool AreAtWar(GuildId a, GuildId b);
bool AreInTruce(GuildId a, GuildId b);
```

Integration helpers:

- `bool CanAttackWithoutNotoriety(Player* attacker, Player* victim);`
  - True if:
    - War relation between guilds, or
    - They are both in an active Warfront/Siege instance.

---

## 4. Declaring War & Forming Alliances

### 4.1 Guild War Declaration

**Initiation**:

- Only guild masters (or designated officers) can declare war.
- Done via:
  - `Guild Steward` NPC in capital cities,
  - Or Stronghold Steward if they own a Stronghold.

**Costs & Requirements**:

- Gold fee (scaled by guild size & existing wars),
- Civic Standing check:
  - Very low Civic Standing may restrict “legitimate war” and push toward “banditry” instead.
- Optional: pre-requisite history (kill counts, disputes).

**Process**:

1. Guild A selects “Declare War” on Guild B:
   - UI shows:
     - War cost,
     - Base duration (e.g., minimum 7 days),
     - Consequences (legal PvP everywhere).

2. Guild B receives notification:
   - If **mutual war** required:
     - B must accept (like EVE’s mutual wars).
   - If **vendetta** allowed:
     - War can start unilaterally but:
       - A loses Civic Standing,
       - B gains some “defender sympathy” with Civic Standing.

**Result**:

- Relation set to `WAR`,
- Start/end times recorded,
- Both sides see:
  - Red “War” tag in guild UI and nameplates,
  - War listed in MortalUI “Politics” panel and on Atlas.

---

### 4.2 Alliances

**Initiation**:

- Similar to war but cooperative:
  - Guild A proposes alliance to Guild B.

**Effects**:

- Allied guilds:
  - Cannot declare war on each other,
  - Can share Stronghold services:
    - Banks, vendors, crafting stations (configurable),
  - May contribute to each other’s sieges (defence and sometimes offence).

**Costs**:

- Small upkeep cost (gold or Civic Standing),
- Too many alliances may:
  - Reduce Civic Standing (seen as forming “hegemony”), or
  - Increase Stronghold resource drain (overextension).

---

### 4.3 Truce / Ceasefire

Truce ends a war early:

- Both guilds (or a superior authority later) agree to ceasefire.
- Effects:
  - Relation becomes `TRUCE` with an expiry time,
  - During truce:
    - No legal war-based PvP,
    - Violations:
      - Attackers get heavy Civic Standing penalties,
      - Possibly fines or temporary debuffs.

---

## 5. Interaction with Sieges & Strongholds

### 5.1 Who Can Siege Whom?

Basic rule:

- A guild may **launch a siege** against a Stronghold if:
  - They are at **WAR** with the owning guild, **and**
  - The Stronghold is inside a region where sieges are enabled, **and**
  - Siege vulnerability window is open.

Allied guilds:

- Can join the defender side automatically.
- Attacker may invite allied guilds to join their side (creating coalitions).

### 5.2 Multi-Guild Coalitions

In `MortalSiegeController`:

- For each siege:

  ```txt
  Defenders = OwnerGuild + Alliances
  Attackers = AttackerGuild + Alliances
  ```

- Coalition size can be:
  - Limited by:
    - Stronghold type (small vs major),
    - Server config.

Nameplate & UI coloration:

- All members of defender coalition = Blue/Green to each other (depending on config),
- All members of attacker coalition = Blue/Green to each other,
- Attackers vs defenders = Red to each other.

---

## 6. Crime, Notoriety & Guild Wars

### 6.1 Legal Target Logic

When player A attacks player B:

1. If:
   - Both are in same siege/Warfront team vs enemy team,
   - Or their guilds are at `WAR`,
   → Attack is **legal**, no Notoriety.

2. Else:
   - Normal zone rules apply:
     - Green: typically no PvP allowed,
     - Yellow: attacking innocents = Criminal flag & Notoriety,
     - Red: FFA, but Notoriety may still apply for some crimes (e.g., killing neutrals or shrine defenders).

### 6.2 Titles & Reputation

War-heavy guilds may unlock:

- Titles like:
  - `the Warmonger`, `the Warlord`, `the Iron Pact`.
- Civic Standing:
  - Aggressive war usage with collateral damage:
    - Decreases Civic Standing,
    - Increases guard hostility in civilized regions.
- Frontier Standing:
  - Successful defence/assault on frontier Strongholds:
    - Increases Frontier Standing.

---

## 7. UI & Atlas Integration

### 7.1 MortalUI

Add a **Politics Panel**:

- Shows:
  - Your guild’s alliances,
  - Active wars,
  - Truces (with timers),
  - Simple status tags: `Ally`, `At War`, `Neutral`.

### 7.2 Atlas Web

On Atlas:

- “Guild Politics” page:
  - Public information:
    - Which guilds are at war,
    - Which guilds are allied,
    - Which Strongholds they control.
  - Sensitive details (exact numbers, etc.) can be approximated.

---

## 8. Implementation Notes

- Ensure symmetric storage:
  - Relations always stored with `(minGuildId, maxGuildId)` ordering.
- Avoid explosive complexity:
  - Limit number of alliances and wars per guild to sane values.
- Provide GM tools:
  - Force set relations,
  - Override/clear broken states,
  - Inspect relation logs.

---

This system turns **guild relationships** into a real, mechanical backbone for:
- Legal open-world PvP,
- Stronghold sieges,
- Resource control,
- Political storytelling in Mortal Warcraft.
