# Project Canvas: Mortal Warcraft Overhaul
### Version 35.5 — Hybrid Technical Design Document  
### File: 56-negative-titles-and-notoriety-labels.md  
### Section: Criminal & Notoriety Titles (All System-Enforced)

---

## 1. Purpose

Define a **fully system-enforced negative title system** for Mortal Warcraft that:

- Makes the world feel **dangerous and reactive**.
- Visibly brands criminals, griefers, and betrayers with **unavoidable labels** while their behavior persists.
- Integrates with:
  - **Notoriety**, **Bounty Board**, **Black Market**, **Factions**, and **Guard AI**.
- Avoids pure grief-celebration:
  - Titles are cool and flavorful, but carry **real social and mechanical consequences**.

Design constraint from owner:
- **No negative titles are optional.**
  - If the condition is met, the title is automatically assigned.
  - Player cannot hide or unequip these while the trigger condition remains active.

---

## Related Specs

For full context on notoriety and criminal systems, see:

- **`02-combat.md`** — Crime system, criminal flags, and Outlaw state that generate notoriety
- **`03-risk-zones.md`** — Zone-based restrictions for Outlaws and how notoriety affects zone access
- **`11-pvp-systems.md`** — PvP systems, anti-zerg mechanics, and bounty systems that interact with notoriety
- **`51-factions-and-standing-system.md`** — Faction standing system that can trigger faction disgrace titles
- **`36-mortal-achievements-and-titles-core.md`** — Core title system architecture that these negative titles integrate with

---

## 2. Core Concepts

### 2.1 Title Categories

All negative titles are **system-controlled**, but we use categories for logic:

1. **Notoriety Tiers (Global Criminality)**
   - Based purely on **Notoriety score** and related metrics.
   - Always active while the score is above thresholds.

2. **Behavioral Criminal Titles**
   - Triggered by specific **criminal behaviors**:
     - Thievery, grave robbing, contract breaking, smuggling, etc.
   - Active while a rolling “crime score” is above thresholds.

3. **Faction Disgrace Titles**
   - Triggered by **extreme rep drops or betrayals** of major factions.
   - Active while the faction despises you (standing below harsh thresholds).

All of these:

- Can stack internally (system remembers all you’ve earned).
- Only a **single highest-priority negative title** is displayed at any given time (per category priority rules).

---

## 3. Data Model

### 3.1 Negative Title Definition

We assume a general titles table exists or is planned. Here’s a focused table for negative titles, or you can fold it into a general `mortal_titles` structure.

```sql
CREATE TABLE IF NOT EXISTS mortal_negative_titles (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE,   -- 'NOTO_SCOURGE_FRONTIER', 'CRIME_GRAVE_ROBBER'
  name            VARCHAR(128) NOT NULL,         -- display name
  description     TEXT NOT NULL,
  category        VARCHAR(16) NOT NULL,          -- 'NOTORIETY','CRIME','FACTION'
  priority        INT NOT NULL DEFAULT 0,        -- higher = overrides lower when multiple apply
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.2 Title Conditions

We store machine-readable triggers for each negative title.

```sql
CREATE TABLE IF NOT EXISTS mortal_negative_title_conditions (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  title_id        INT NOT NULL,
  condition_type  VARCHAR(32) NOT NULL,           -- 'NOTORIETY_THRESHOLD','CRIME_COUNTER','FACTION_STANDING'
  param_json      JSON NOT NULL,                  -- parameters vary by type
  CONSTRAINT fk_mortal_negative_title_conditions_title
    FOREIGN KEY (title_id) REFERENCES mortal_negative_titles(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Examples:

- `condition_type = 'NOTORIETY_THRESHOLD'`  
  `param_json = {"min": 5000, "max": 9999}`

- `condition_type = 'CRIME_COUNTER'`  
  `param_json = {"crime_code": "THIEVERY_ITEMS_STOLEN", "min": 25, "window_sec": 604800}`

- `condition_type = 'FACTION_STANDING'`  
  `param_json = {"faction_code": "ORDER_SHRINE", "max": -50000}`

### 3.3 Per-Character Active Title State

While negative titles are system-controlled, we keep a snapshot per character for performance and history.

```sql
CREATE TABLE IF NOT EXISTS mortal_negative_title_state (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,                   -- character guid
  active_title_id INT NULL,                       -- currently displayed negative title
  last_update_ts  INT NOT NULL,
  history_json    JSON NULL,                      -- log of titles earned/lost with timestamps
  UNIQUE KEY uniq_guid (guid),
  CONSTRAINT fk_mortal_negative_title_state_title
    FOREIGN KEY (active_title_id) REFERENCES mortal_negative_titles(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 4. Notoriety Tier Titles

### 4.1 Design

These reflect **overall player danger level** to the world.

- Driven mainly by:
  - Player kills of innocents,
  - Yellow/Red-zone aggression,
  - Corpse camping & ganking patterns.

Only one Notoriety title can be active at a time; higher tier overrides lower.

### 4.2 Proposed Notoriety Titles & Conditions

(Pseudo-values; tune numbers later.)

1. **Petty Cutpurse** (`NOTO_PETTY_CUTPURSE`)  
   - Notoriety: `500 ≤ N < 1500`  
   - Represents low-level criminal activity.

2. **Roadside Menace** (`NOTO_ROADSIDE_MENACE`)  
   - Notoriety: `1500 ≤ N < 4000`  
   - Repeated aggression in travel routes (weighted for caravan/road kills).

3. **Butcher of the Ways** (`NOTO_BUTCHER_OF_WAYS`)  
   - Notoriety: `4000 ≤ N < 8000`  
   - Many kills in Yellow Zones, especially against lower-geared players.

4. **Redhanded** (`NOTO_REDHANDED`)  
   - Notoriety: `8000 ≤ N < 15000`  
   - Refuses to atone/pay bounties; kills while heavily wanted.

5. **Scourge of the Frontier** (`NOTO_SCOURGE_FRONTIER`)  
   - Notoriety: `N ≥ 15000`  
   - Top-tier, map-marked, bounty-magnet. Always visible on Atlas & killfeed.

Each title has:

- `category = 'NOTORIETY'`
- Increasing `priority` values:

```text
Petty Cutpurse      priority 10
Roadside Menace     priority 20
Butcher of the Ways priority 30
Redhanded           priority 40
Scourge of Frontier priority 50
```

When Notoriety drops:

- The system recomputes and assigns the appropriate lower-tier or no Notoriety title.

---

## 5. Crime Behavior Titles

### 5.1 Crime Framework

We assume a basic “crime counter” framework:

- Each time a crime event occurs (steal, grave rob, failed contract, smuggling, etc.),
  - Increment a `crime_code` counter in memory and/or DB,
  - Maintain recent-window sums (e.g., last 7 days).

### 5.2 Defined Crime Codes

Examples:

- `THIEVERY_ITEMS_STOLEN`
- `GRAVE_LOOTS`
- `CONTRACT_FAILS`
- `BLACKMARKET_SALES`
- `SMUGGLER_RUNS_SUCCESS`

### 5.3 Titles & Conditions (Always System-Enforced)

1. **Gutter-Thief** (`CRIME_GUTTER_THIEF`)  
   - Condition: `THIEVERY_ITEMS_STOLEN ≥ 10` in last 7 days.

2. **Grave Robber** (`CRIME_GRAVE_ROBBER`)  
   - Condition: `GRAVE_LOOTS ≥ 10` in last 7 days.

3. **Fence of Ill Repute** (`CRIME_FENCE`)  
   - Condition: `BLACKMARKET_SALES ≥ X` gold volume or Y sales in last 7 days.

4. **Contract Breaker** (`CRIME_CONTRACT_BREAKER`)  
   - Condition: `CONTRACT_FAILS ≥ 5` in last 7 days.

5. **Cloaked Smuggler** (`CRIME_SMUGGLER`)  
   - Condition: `SMUGGLER_RUNS_SUCCESS ≥ N` without being caught (no guard detection / no confiscation).

6. **Shadow of the Routes** (`CRIME_SHADOW_ROUTES`)  
   - Condition:
     - High volume of **successful** smuggling + contraband trade,
     - Very low detection rate.

Category & priority:

- All `category = 'CRIME'`.
- Priorities tuned relative to each other; crime category itself can be lower priority than Notoriety, *or* you can decide a strict ordering among categories (see Section 7).

---

## 6. Faction Disgrace Titles

### 6.1 Concept

These represent **extreme betrayal or hatred** by an organized faction.

Trigger sources:

- Standing plunges below a harsh threshold,
- Specific storyline/betrayal quest choices.

### 6.2 Example Titles

1. **Excommunicated** (`FACT_EXCOMMUNICATED`)  
   - Faction: `Order of the Shrine`.  
   - Condition: `standing(Order of the Shrine) ≤ -50,000`  
   - Possible extra: Desecrated X Shrines or sided with undead events.

2. **Persona Non Grata** (`FACT_PERSONA_NON_GRATA`)  
   - Faction: `Iron Ledger`.  
   - Condition: `standing(Iron Ledger) ≤ -30,000`  
   - Additional: Repeated contract breaking or repeated attacks on trade hubs.

3. **Mark of the Snitch** (`FACT_MARK_SNITCH`)  
   - Faction: `Black Sun Cartel`.  
   - Condition: Turned in Cartel NPCs/contracts to Guards multiple times.

4. **Oathbreaker of the Pact** (`FACT_OATHBREAKER_PACT`)  
   - Faction: `Rangers’ Pact`.  
   - Condition: Abandoned or sabotaged major expeditions & Pact contracts.

Title behavior:

- NPCs of that faction:
  - Adjust dialogue and pricing,
  - Maybe deny access to higher-tier services / vendors.
- Title remains enforced until:
  - Standing rises above threshold **and/or**
  - Specific atonement quests are completed.

---

## 7. Priority & Display Rules

We must decide which negative title is visible when multiple conditions are met.

Recommended order:

1. **Notoriety** (highest priority)  
   - If you are a global threat, the world should present you as such.
2. **Faction Disgrace**  
   - When inside or near faction territory, UI may show the disgrace title as a secondary line or override locally.
3. **Crime Behavior**  
   - Flavor labeling; primarily used when Notoriety is low or moderate.

Implementation approach:

- Global active title:
  - Determine the highest-priority title across all categories using `priority` field.
- Contextual UI (optional advanced behavior):
  - In Shrine zones, display `Excommunicated` instead of `Petty Cutpurse`.
  - In Caravan hubs, show `Contract Breaker` above your head when interacting with trade NPCs.

For v1, keep it simple:

- One **global active negative title**, computed from all current-condition matches by `priority`.

---

## 8. Mechanical Effects (Hooks)

All negative titles should **mean something** beyond flavor.

### 8.1 Guard & Shrine Behavior

- Notoriety titles at higher tiers:
  - Guards attack on sight or demand bribes.
  - Shrines may:
    - Charge higher durability penalties,
    - Deny certain respawn perks.

- Faction Disgrace titles:
  - Faction guards may be hostile or avoid helping you.
  - Faction NPCs:
    - Charge more,
    - Block certain quests or services.

### 8.2 Bounty Board & Atlas

- Higher-tier Notoriety titles:
  - Appear on **Bounty Board UI** with:
    - Bounty amount,
    - Last known zone.
  - Atlas web portal:
    - Shows leaderboard of “Most Wanted” characters.
- Killing someone with `NOTO_SCOURGE_FRONTIER`:
  - Extra reward (gold, standing with certain factions).

### 8.3 Economy & Services

- Some titles could:
  - Increase AH fees,
  - Negatively impact **Iron Ledger** services,
  - Block access to premium insurance rates.

---

## 9. Redemption & Decay

Even though titles are not optional, players must be able to **shed them over time**.

### 9.1 Time & Behavior-Based Decay

- Notoriety and Crime counters:
  - Naturally decay over time when:
    - Player stays out of trouble,
    - Does opposite-behavior content (e.g., helping Shrines).

- When values fall below threshold:
  - Corresponding title conditions fail,
  - System recalculates active title and removes that label.

### 9.2 Explicit Atonement Paths

For heavier titles (Scourge, faction disgrace):

- Atonement quests:

  - Spend significant gold/resources on reparations.
  - Run Shrine defense or trade protection contracts.
  - Escort NPCs, defend caravans, etc.

- Only after finishing atonement chain:
  - Locks in a cooldown to **prevent immediate re-offending** without consequences.
  - The title is removed and may be logged into history as “Redeemed.”

---

## 10. Implementation Checklist

1. **DB**
   - Create:
     - `mortal_negative_titles`,
     - `mortal_negative_title_conditions`,
     - `mortal_negative_title_state`.
   - Seed titles:
     - Notoriety: Petty Cutpurse → Scourge of the Frontier.
     - Crime: Gutter-Thief, Grave Robber, Fence of Ill Repute, Contract Breaker, Cloaked Smuggler, Shadow of the Routes.
     - Faction: Excommunicated, Persona Non Grata, Mark of the Snitch, Oathbreaker of the Pact.

2. **Server Logic**
   - Implement:
     - Notoriety system hooking into PvP kills, criminal actions.
     - Crime counters with time windows per `crime_code`.
     - Faction standing checks for disgrace titles.
   - Periodic evaluation:
     - Recompute eligible titles for each character.
     - Choose highest-priority and store in `mortal_negative_title_state.active_title_id`.

3. **UI & UX**
   - Nameplate & tooltip:
     - Display active negative title under character name.
   - Bounty Board:
     - Show highest-tier Notoriety titles with bounty values.
   - MortalUI:
     - Titles panel can show:
       - Active negative title (read-only),
       - History log (for flavor).

4. **Integration**
   - Guards & Shrines:
     - Hook behavior based on active title + Notoriety.
   - Factions:
     - Adjust AI/NPC services for faction disgrace titles.
   - Atlas & Discord:
     - Display negative titles in killfeed and Most Wanted lists.

5. **Tuning & Safety**
   - Tune thresholds to avoid:
     - Newbie gankers instantly being hard-branded,
     - Legit PvP players being punished for normal activity.
   - Iterate on decay/atonement pacing based on playtests.

---

This spec ensures **all negative titles are hardwired and non-optional** while still giving players a path to lose them through time, behavior, and explicit atonement, and it ties tightly into your Notoriety, Factions, Bounty, and Atlas systems.
