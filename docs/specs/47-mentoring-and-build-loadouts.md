# Project Canvas: Mortal Warcraft Overhaul
### Version 31.6 — Hybrid Technical Design Document  
### File: 47-mentoring-and-build-loadouts.md  
### Section: Mentoring Down, Group Scaling & Build Loadouts

---

## 1. Purpose

Provide systems that:

- Let **friends play together regardless of progression**, without trivializing content.
- Encourage **build experimentation** without forcing rerolls.
- Avoid creating exploitable power-leveled “boosting” loops.
- **Do not affect PvP power** — scaling is strictly **PvE-only**.

This includes:

1. **Mentor Down**: higher-skill players scale down to match lower-band **PvE** content.
2. **Group scaling**: public **PvE** events adapt mildly to wide skill bands.
3. **Build Loadouts**: saved builds (skills + masteries + optional gear sets) that can be swapped at safe locations.

---

## Related Specs

For full context on mentoring and build systems, see:

- **`01-progression.md`** — Derived level formula and skill system that Mentor Down scales
- **`55-build-presets-and-loadouts.md`** — Extended build preset system and loadout management
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that are scaled in Mentor Mode
- **`75-mortal-gear-and-runes-spec.md`** — Gear and rune systems that can be saved in loadouts
- **`88-mortal-progression-era-map.md`** — Skill bands and progression eras used for scaling

---

## 2. Mentor Down (Dynamic Level Scaling Downward)

### 2.1 Concept

A higher-skill player can **voluntarily scale down** their *effective* power (dynamic level, HP, damage) to:

- Play with lower-skill friends,
- Participate in lower-tier **PvE** content without turning it into a faceroll.

Mentor Mode:

- Affects **only PvE combat resolution** vs NPCs and world objects.
- Never changes how hard the player hits or is hit in **PvP**.

They still:

- Gain skills normally,
- Receive progression-appropriate rewards (attenuated if needed).

### 2.2 Effective Level Bands

Use the shared **Derived Level** formula from `01-progression.md`:

```text
Character_Level = MIN(25, FLOOR(Total_Primary_Skill_Points / 48))
```

Define **target bands** (derived levels clamped to 25), e.g.:

- Band 1: Level 1–5
- Band 2: Level 6–10
- Band 3: Level 11–15
- Band 4: Level 16–20
- Band 5: Level 21–25

Mentoring down = temporarily clamping the character’s **effective derived level** in **PvE formulas** to a lower band.

### 2.3 Mechanics

- Players can toggle **Mentor Mode** in Green/Yellow PvE-safe zones via:

  - Mentor NPC,
  - MortalUI panel,
  - or group context menu (“Mentor [Player]”).

- When activated:

  - Player chooses **target band**:
    - Must be **≤ lowest band in their party**,
    - And **≤ content band** (zone/dungeon recommended level).

- Server applies:

  - An aura flag that:
    - Reduces their derived stats (HP, damage, mitigation) **only in PvE combat resolution** against NPCs at or below that band,
    - Adjusts hit/avoidance tables vs mobs in that content band.

### 2.4 Mentor Down Scaling Formula

When Mentor Mode is active, the player's effective power is scaled down to match the target band. Scaling applies **only to PvE combat** against NPCs at or below the target band level.

**Level Band Definitions:**
- **Band 1**: Levels 1-5 (midpoint: 3)
- **Band 2**: Levels 6-10 (midpoint: 8)
- **Band 3**: Levels 11-15 (midpoint: 13)
- **Band 4**: Levels 16-20 (midpoint: 18)
- **Band 5**: Levels 21-25 (midpoint: 23)

**Scaling Factor Calculation:**
```
TargetLevel = TargetBandMidpoint
ActualLevel = Player's actual derived level (1-25)
ScaleFactor = TargetLevel / ActualLevel
```

**Effective Stats (PvE Only):**
```
EffectiveHP = BaseHP * ScaleFactor
EffectiveDamage = BaseDamage * ScaleFactor
EffectiveAP = BaseAP * ScaleFactor
EffectiveSP = BaseSP * ScaleFactor
EffectiveMitigation = BaseMitigation * ScaleFactor
```

**Hit/Chance Adjustments:**
- Hit chance vs NPCs in target band uses **TargetLevel** instead of ActualLevel
- Crit chance is scaled proportionally
- Avoidance/dodge uses scaled stats

### 2.5 Scaling Examples

**Example 1: Level 20 Player Mentors to Band 2**
```
ActualLevel = 20
TargetBand = 2 (Levels 6-10, midpoint = 8)
TargetLevel = 8

ScaleFactor = 8 / 20 = 0.4

BaseHP = 1000
EffectiveHP = 1000 * 0.4 = 400 HP

BaseDamage = 100
EffectiveDamage = 100 * 0.4 = 40 damage

BaseAP = 200
EffectiveAP = 200 * 0.4 = 80 AP
```

**Example 2: Level 15 Player Mentors to Band 1**
```
ActualLevel = 15
TargetBand = 1 (Levels 1-5, midpoint = 3)
TargetLevel = 3

ScaleFactor = 3 / 15 = 0.2

BaseHP = 800
EffectiveHP = 800 * 0.2 = 160 HP

BaseDamage = 80
EffectiveDamage = 80 * 0.2 = 16 damage
```

**Example 3: Level 25 Player Mentors to Band 3**
```
ActualLevel = 25
TargetBand = 3 (Levels 11-15, midpoint = 13)
TargetLevel = 13

ScaleFactor = 13 / 25 = 0.52

BaseHP = 1500
EffectiveHP = 1500 * 0.52 = 780 HP

BaseDamage = 150
EffectiveDamage = 150 * 0.52 = 78 damage
```

### 2.6 Scaling Constraints

**Minimum Scaling:**
- ScaleFactor cannot go below 0.1 (10% of base stats)
- Prevents complete stat elimination
- Ensures mentor still has some effectiveness

**Maximum Scaling:**
- ScaleFactor cannot exceed 1.0 (100% of base stats)
- Mentor Mode only scales down, never up
- If TargetLevel >= ActualLevel, scaling is disabled

**PvP Safety:**
- All scaling is **completely disabled** in PvP contexts
- Red zones, arenas, battlegrounds, duels: No scaling applied
- PvP always uses true stats regardless of Mentor Mode

### 2.7 Reward Scaling

**Experience/Skill Gains:**
- Players still gain skills normally while mentoring
- No reduction to skill gain rates
- Rewards are **not** scaled down (full rewards for content difficulty)

**Loot Rewards:**
- Loot quality/tier based on **actual level**, not target level
- Mentor still receives appropriate rewards for their true progression
- Prevents exploitation of low-level content for high-tier rewards

- Visual indicator:

  - Small “Mentor” icon next to name,
  - Optional buff icon.

---

## 3. PvP Safety Constraints for Mentor Mode

### 3.1 Automatic Suspension in PvP Contexts

Mentor Mode must **never** modify PvP power.

Whenever a player:

- Enters a **Red Zone**,
- Enters **Arena** maps,
- Enters **Battleground / Warfront** instances,
- Initiates or accepts a **duel**,
- Gains a PvP flag state (e.g., attacking/being attacked by another player),

the server must:

- Either:
  - **Completely remove the Mentor aura**, or
  - Mark it **inactive for PvP** (recommended: remove to avoid confusion).
- Show a short notification in MortalUI:

  > “Mentor Mode is disabled in PvP contexts.”

Result:

- All PvP damage, mitigation, and combat formulas use the **player’s true stats**, unaffected by mentoring.

### 3.2 No Enabling Mentor in PvP Zones

- Mentor Mode can only be **enabled**:

  - In Green/Yellow safe PvE spaces,
  - Outside Red Zones, Arenas, Warfronts, and duel flags.

- Attempting to enable Mentor Mode in a PvP context should:

  - Fail,
  - Show an error message (“Cannot mentor in PvP zones.”).

---

## 4. Group Scaling in Public PvE Events

### 4.1 Concept

Public **PvE** events (Rifts, public dungeons, world boss fights) should:

- Work for mixed groups where some players are much stronger,
- Without perfectly scaling everything (which feels artificial),
- **Never** affect player-vs-player power or formulas.

### 4.2 Approach (PvE-Only)

Per **PvE event instance**:

- Compute **group average effective level**:

  ```text
  AvgLevel = average(EffectiveLevel of all participants)
  ```

- Use `AvgLevel` to:

  - Slightly adjust **mob HP and damage**:
    - Within configured bounds for that event.

Group scaling:

- Applies **only** to NPCs and environmental hazards inside that event.
- Does **not**:

  - Change player-vs-player damage,
  - Change player-vs-player mitigation,
  - Alter any PvP hit/crit tables.

### 4.3 Non-Goals

- No perfectly level-scaled world:
  - High-level players should still feel stronger in older content.
- No “clamping up”:
  - Low-level players are not scaled *up* artificially; that’s covered by mentoring if desired.
- No hidden PvP normalization:
  - If future structured PvP normalization is added, it must be a **separate, explicit system**.

---

## 5. Build Loadouts

### 5.1 Concept

Players can save **named builds** that capture:

- Skill allocations (which skill lines invested in),
- Mastery tree choices (Warlord/Guardian/Explorer),
- Optionally: a reference to a **Gear Set** (via equipment manager).

They can quickly swap between these builds at:

- Shrines,
- Taverns,
- Stronghold interiors,
- (Optionally) at Guild Halls.

### 5.2 Data Model

```sql
CREATE TABLE IF NOT EXISTS mortal_build_loadouts (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,           -- owner character guid
  slot_index      INT NOT NULL,           -- 0..N-1
  name            VARCHAR(32) NOT NULL,
  skills_json     TEXT NOT NULL,          -- serialized skill allocations
  mastery_json    TEXT NOT NULL,          -- Warlord/Guardian/Explorer choices
  gearset_ref     VARCHAR(64) NULL,       -- optional reference to gear manager set
  last_used_time  INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.3 Slots & Unlocks

- Default: **2 loadout slots** per character.
- Additional slots unlocked via:

  - Mastery tree nodes,
  - Rare drops / crafting items,
  - Shop (cosmetic quality-of-life, not raw power).

### 5.4 Swapping Rules

- Builds can be swapped:

  - Only **out of combat**,
  - Only at designated locations (Shrines, taverns, strongholds, guild halls).

- Swapping:

  - Resets:
    - Skill allocations to saved state,
    - Mastery tree choices to saved state,
    - Optionally triggers gear change if `gearset_ref` is valid.

- Cooldown:

  - Optional small cooldown (e.g. 60–180 seconds) or resource cost to discourage constant micro-swapping mid-run.

### 5.5 Interaction with Mentor Mode

- When in Mentor Mode:

  - Players can still swap builds at safe locations.
  - Effective level band still clamps **PvE** derived stats only.

- Design intent:

  - Allow “mentor healer build”, “mentor tank build” etc. for playing with newer friends.

---

## 6. Integration Points

1. **Dynamic Level & Attribute Caps**
   - Mentor Mode uses the same derived stat logic with:
     - Level-based clamps & modifiers **applied only in PvE**.
2. **Mastery Trees**
   - Loadouts are serialization of mastery choices (plus skill lines).
3. **Risk & PvP**
   - Mentor Mode is **automatically disabled** in:
     - Red Zones,
     - Arenas,
     - Battlegrounds / Warfronts,
     - Duels.
   - Group scaling logic never touches player-vs-player formulas.
4. **MortalUI**
   - Needs:
     - Mentor toggle + band selection UI,
     - Clear messaging that Mentor is PvE-only,
     - Loadout management pane (rename, reorder, save, load).

---

## 7. Implementation Checklist

1. Implement **Mentor Mode** aura and effective-level clamp logic:
   - Apply only in PvE combat resolution.
2. Implement automatic **Mentor suspension** when:
   - Entering Red Zones / Arenas / Warfronts / duels,
   - Becoming PvP-flagged.
3. Create **Mentor NPC** or MortalUI controls for enabling/disabling Mentor Mode in safe zones.
4. Implement **group scaling** in public PvE events (Rifts, public dungeons, world bosses) for NPC stats only.
5. Implement **build loadout** serialization & storage:
   - Skill allocations,
   - Mastery trees,
   - Optional gear set hooks.
6. Build **MortalUI Loadout panel** and updated **Mentor controls** with PvE-only messaging.
7. Add **telemetry** around:
   - Use of Mentor Mode,
   - Loadout swaps,
   - Group scaling impact in PvE events.
