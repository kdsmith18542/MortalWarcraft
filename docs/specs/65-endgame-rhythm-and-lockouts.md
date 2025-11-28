# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Endgame & Live Ops  
### File: 65-endgame-rhythm-and-lockouts.md  
### Section: Endgame Rhythm, Lockouts & Seasonal Cadence

---

## 1. Goals

Define a **predictable but dynamic** endgame cadence that:

- Supports:
  - Raids (instanced),
  - Warfronts (physical-entry battlegrounds with full loot),
  - Strongholds & sieges,
  - World bosses,
  - Trials (Shrine & Faction challenges),
  - Rifts, Hellgates, Midnight Horde, Zone Invasions,
  - World Contracts & Hot Zones.
- Balances:
  - **Hardcore sandbox risk** (full loot, sovereignty),
  - **Player retention** (things to look forward to each day/week/season),
  - **Economy pacing** (material flow, sink timing).
- Integrates with:
  - Seasons of the Frontier,
  - Factions,
  - Guild sovereignty systems.

This document defines the **time-based rules**; separate specs still govern each system's internal logic.

---

## Related Specs

For full context on endgame rhythm and lockouts, see:

- **`52-season-of-the-frontier.md`** — Seasonal system that provides seasonal cadence
- **`92-mortal-warfronts-siege-flow.md`** — Warfront system that uses weekly rotations
- **`08-guilds-sovereignty.md`** — Stronghold system that uses vulnerability windows
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that follow daily/weekly rhythms
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task boards that rotate daily
- **`91-mortal-anomalies-rifts-hellgates.md`** — Rifts and hellgates that follow spawn schedules
- **`06-pve.md`** — PvE content (raids, world bosses) that uses lockouts

---

## 2. Time Scales

We define three main time layers:

1. **Daily Rhythm (Server Day)**  
   - When to expect:
     - Routine World Contracts,
     - Midnight Horde windows,
     - Rifts/Hellgate baseline spawn rates,
     - Hot Zone rotation.

2. **Weekly Rhythm (Server Week)**  
   - When to expect:
     - Raid lockouts,
     - Warfront rotations,
     - Stronghold vulnerability windows,
     - World boss spawn windows,
     - Faction & Trial resets.

3. **Seasonal Rhythm (Frontier Seasons)**  
   - Length: **8–12 weeks** (tunable, default 10 weeks).  
   - When to:
     - Rotate global Frontier themes,
     - Adjust reward tables and appearance unlocks,
     - Resolve long-term sovereignty,  
     - Soft-reset certain leaderboards and seasonal currencies.

---

## 3. Daily Rhythm

Daily systems ensure that logging in **any given day** offers:

- Something to do solo (Contracts, Trials),
- Something to do in small groups (Rifts, Hellgates, public dungeons),
- A mild sense of “the world is moving” (Hordes, Invasions).

### 3.1 World Contracts & Task Boards

**Daily Contract Rotations:**

- Each major hub and frontier town:
  - Rolls a **daily set of Contracts** from its pool at server reset.
- Contracts vary by:
  - Risk tier (Green/Yellow/Red),
  - Faction alignment,
  - Objective type (Hunt, Escort, Gather, Defend, Investigate).

Daily rules:

- **Per-character contract cap**:
  - e.g. 10 “featured” Contracts per day with full rewards; endless lower-tier Contracts have reduced returns after cap.
- **Faction contracts**:
  - Each Faction guarantees:
    - 1–3 daily contracts per aligned character,
    - With small standing bonuses and thematic objectives.

### 3.2 Rifts & Hellgates

**Rift Baseline:**

- Rifts:
  - Have a **baseline spawn rate** that slowly increases in:
    - Yellow and Red zones during peak hours.
- They do not respect daily reset:
  - They are dynamic, but their **intensity** can be higher during specific “Rift Surge” hours.

**Hellgates:**

- Hellgates:
  - Spawn in clusters on a **loose daily cycle**:
    - Example: 2–4 small Hellgate windows per day in various frontier zones.
- Each Hellgate has:
  - A **lifetime (e.g. 1 hour)**, after which it collapses if untouched.

### 3.3 Midnight Horde (Daily / Multi-Day)

**Midnight Horde:**

- Occurs in a **daily or every-2-days window**:
  - Example: between 22:00–02:00 server time, one or more regions can be flagged for “Midnight Risk”:
    - Sudden surge of undead,
    - Higher Ether activity,
    - Bonus rewards for defenders.

- The system:
  - Randomly picks:
    - 1–3 candidate zones,
    - Notifies:
      - Order of the Shrine & Rangers’ Pact aligned players via in-game & Atlas alerts.

---

## 4. Weekly Rhythm

Weekly structures give players:

- Medium-term goals,
- Reason to organize guild activities,
- Clear windows when “big stuff happens.”

### 4.1 Raid Lockouts

**Raids (MC, Ony, ICC, etc. in Mortal form):**

- Use a **weekly lockout per character per raid**:
  - Standard: 1 clear per week with full boss loot.
- Raid ID:
  - Tied to:
    - Guild or group leader ID,
    - Used for:
      - Cursed Artifacts extraction,
      - Seasonal tracking.

**Extraction & Cursed Artifacts:**

- Cursed Artifacts:
  - Drop from bosses,
  - Must be extracted in the open world,
  - Still limited by:
    - Weekly kill lockouts,
    - Seasonal soft caps (e.g. some items flagged “Seasonal Unique”).

### 4.2 Trials & Shrines

**Shrine Trials (Mage Tower–like):**

- **Lockout:**
  - Soft lockout with diminishing returns:
    - First victory of the week → full rewards,
    - Repeat clears → small tokens, cosmetics only.
- Trials by role:
  - Bulwark, Blade, Veil, Lifeline:
    - Each can have its own **weekly challenge** variant.

**Faction Trials:**

- Faction-specific instanced challenges:
  - Iron Ledger profit runs,
  - Cartel smuggle operations,
  - Rangers anomaly hunts,
  - Shrine survival/attrition tasks.

- Weekly:
  - Each Faction offers:
    - 1 “major” Trial (big reward with weekly lockout),
    - 2–3 “minor” Trials (repeatable but with tokenized returns).

### 4.3 Warfronts

**Warfronts (Physical-entry BGs with full loot inside):**

- Operate on **weekly rotations** between:

  - Azshara Crater (40v40),
  - Alterac-style valley,
  - Other configured battlefields.

**Match cadence:**

- Each Warfront location:
  - Opens for **specific time windows**:
    - Example: 2–3 evenings per week,
    - Matches run back-to-back while player interest supports them.

**Rewards:**

- **Winning side:**
  - Gains Warfront control for the **next week**:
    - Guilds from that side receive:
      - Resource shipments,
      - Bonuses to Stronghold production,
      - Access to special Contracts.
- **Losing side:**
  - May receive:
    - “Reclaim” contracts next week,
    - Slight catch-up incentives.

### 4.4 Strongholds & Siege Windows

Strongholds (towers, ruins, mines):

- Have **vulnerability windows** for sieges:
  - Example:
    - Each Stronghold is vulnerable:
      - 2 times per week,
      - 2–3 hours each window.

- Outside vulnerability:
  - Strongholds cannot change hands:
    - Only local skirmishes,
    - No structure damage.

Governance:

- Guilds can:
  - Configure **preferred vulnerability windows** (within server-determined bands),
  - But not avoid them entirely.

Rewards:

- Weekly:
  - Stronghold owners earn:
    - Resource trickle,
    - Tax income,
    - Strategic benefits (local banking, respawn options).

### 4.5 World Bosses

World bosses (Azuregos, Kazzak, Dragons, etc.):

- **Spawn windows** tied to weekly cycles:

  - Example:
    - Azuregos window: 24–48h early in the week,
    - Kazzak: mid-week,
    - Dragons: weekend cluster.

- Exact spawn times:
  - Within those windows are **randomized** to:
    - Prevent pure “timer camping.”

Drops:

- Fragments for Token economy,
- Rune recipes,
- Appearance unlocks,
- Some season-limited items.

Lockout:

- Per-character weekly loot lock:
  - Can help multiple kills, but only first yields full loot.

---

## 5. Seasonal Rhythm (Frontier Seasons)

**Frontier Seasons** are the big framing layer.

### 5.1 Season Length & Theme

- **Length:** 8–12 weeks (default 10).  
- Each Season has a **theme**, e.g.:

  - “Season of Black Ice” (Cold Rifts, undead navies),
  - “Season of Ashen Crowns” (necromantic kings, Shrine focus),
  - “Season of Rusted Gold” (economic war, Iron Ledger vs Cartel).

Theme affects:

- Rift modifier sets,
- Special World Contracts,
- Season Trial variants,
- Seasonal appearance sets,
- Seasonal achievements & titles.

### 5.2 Seasonal Progression Track

We align with the existing **Season of the Frontier** spec (if present), and define:

- A **Season progression bar** per character:
  - Filled by:
    - Completing world contracts,
    - Winning or participating in Warfronts,
    - Defending Shrines during Midnight Horde,
    - Clearing Trials,
    - Participating in Stronghold sieges.

Reward milestones:

- Gold/material caches,
- Faction standing bundles,
- Seasonal currency,
- Cosmetic appearances & titles,
- Rune recipes or appearance tokens.

### 5.3 Sovereignty & Season Resets

At Season end:

- **Stronghold owners**:
  - May retain ownership (soft reset),
  - Or have some structures contested again during a:
    - “Transitional Warfront Week” between seasons.

Design options (configurable):

1. **Soft Reset:**
   - Stronghold ownership persists,
   - Taxes & resource production reset to baseline,
   - New season adds new **outer frontier nodes**.

2. **Partial Reset:**
   - Certain high-value Strongholds become contested again:
     - Must be re-defended or re-captured.

Leaderboards:

- Seasonal:
  - Top guilds (territory, Warfront wins, production),
  - Top individuals (contracts, PvP, Trials).
- Rewards:
  - Titles,
  - Cosmetic banners/standards,
  - Minor persistent perks (small QoL, not extra power).

### 5.4 Seasonal Currencies & Items

- Seasonal currency:
  - Earned from participating in:
    - Rifts, Warfronts, Trials, Contracts.
  - Spent at:
    - Seasonal vendors,
    - Faction Sanctums.

End of Season:

- Seasonal currency:
  - Partially converted into:
    - Gold or long-term tokens,
    - To avoid complete loss while still incentivizing spending.

---

## 6. Lockout & Reset Summary

### 6.1 Per-Activity Lockouts

- **Raids:**
  - Weekly per-character lockout per raid.
- **Trials (Shrine/Faction):**
  - Weekly “major reward” lockout per Trial,
  - Infinite practice with reduced/no major rewards.
- **World Bosses:**
  - Weekly per-character loot lock per boss.
- **Warfronts:**
  - No per-character lockout to join matches,
  - Weekly control-resolution per battlefield.
- **Strongholds:**
  - Guild-level control persists,
  - Vulnerability windows 2× per week.
- **Contracts:**
  - Daily “full reward” caps, then diminishing returns.

### 6.2 Reset Times

- **Daily reset:**
  - Resets:
    - Contract caps,
    - Some minor systems (e.g. daily Sanctum tasks).
- **Weekly reset:**
  - Resets:
    - Raid lockouts,
    - Trial major rewards,
    - World boss loot flags,
    - Warfront control resolution,
    - Certain Faction standing bonuses (weekly tasks).
- **Seasonal reset:**
  - Rotates:
    - Season theme,
    - Seasonal reward tracks,
    - Some Stronghold & Warfront meta,
    - Seasonal appearance/currency context.

---

## 7. Integration with Atlas & In-Game UI

To keep players informed:

- **Atlas (Web Portal):**
  - Shows:
    - Upcoming Warfront windows,
    - Current Warfront control,
    - Stronghold ownership and vulnerability windows,
    - Season progression & leaderboard,
    - Rift/Hellgate & Midnight Horde “heatmap” and upcoming windows.

- **In-Game UI (MortalUI):**
  - A **“Frontier Journal”** or Season panel:
    - Daily/weekly objectives,
    - Season milestones,
    - Next major events (Horde, Warfront, World Boss windows).

This ensures the endgame rhythm is:

- Transparent,
- Predictable,
- Yet still dynamic due to randomization within windows.

---

## 8. Implementation Notes

1. **Central Scheduler**
   - Implement a central “Frontier Scheduler” module:
     - Maintains time-based state,
     - Triggers:
       - Rifts surges,
       - Midnight Horde,
       - Warfront open/close,
       - Stronghold vulnerability,
       - Weekly/Seasonal resets.

2. **Config-First Design**
   - All timings (daily reset hour, weekly day, season length, windows) should be:
     - In a **config table**, not hard-coded,
     - So you can tune based on population and feedback.

3. **Low Population Safety**
   - For early population:
     - Allow fallback behavior:
       - If Warfront queue is low, reduce required players,
       - Scale world bosses / events via auto-balance.

4. **Sandbox Respect**
   - Even with schedules:
     - The world remains open; nothing forces you into one activity.
   - The schedule’s job:
     - Provide **high points** where people naturally cluster,
     - Not force everyone into a narrow lane.

---

This document should be your reference whenever you:

- Add a new raid, Warfront, Trial, or event,
- Decide when it should be available,
- Or need to adjust how often players can farm a given activity without breaking the economy or burning out.
