# Project Canvas: Mortal Warcraft Overhaul
### Version 31.0 — Hybrid Technical Design Document  
### File: 45-eldens-eve-layer.md  
### Section: Traveler’s Notes, Insurance Vouchers, Anomalies & Planar Rifts

---

## 1. Purpose

Augment Mortal Warcraft with an **“Elden x EVE” flavor layer** that:

- Adds **asynchronous social flavor** (Elden Ring–style messages).
- Softens extreme loss via **bounded, economy-safe “insurance”** (EVE-style).
- Deepens exploration with **moving micro-dungeons** (EVE cosmic signatures).
- Creates **phased, multi-stage open world events** (RIFT-style rifts) using WotLK phasing.

All systems must:

- Respect the **full-loot, high-risk sandbox** identity.
- Plug into existing specs (economy, risk, events, telemetry, progression).
- Be implementable on **AzerothCore 3.3.5a** with minimal engine changes.

---

## Related Specs

For full context on Elden's Eve layer systems, see:

- **`91-mortal-anomalies-rifts-hellgates.md`** — Anomalies and rifts that are part of this layer
- **`37-economy-system-extensions.md`** — Economy extensions (blessed items, insurance) referenced
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that use planar rifts
- **`12-world-simulation.md`** — World simulation system that drives rift events
- **`06-pve.md`** — PvE content that includes rift encounters
- **`03-risk-zones.md`** — Risk zones where rifts and anomalies spawn
- **`24-webportal-mortal-atlas.md`** — Atlas web portal that provides intel on anomalies

---

## 2. Traveler’s Notes (Asynchronous Social Messaging)

### 2.1 Concept

Players can place **short, templated notes** in the world:

- “Ambush ahead.”
- “Ore vein in ravine.”
- “Secret path to shrine.”

Other players can **read and rate** them, getting that Elden Ring feeling of a shared, lived-in world—even when playing solo.

### 2.2 Design Constraints

- No free-text novels / spam.
- Notes are:

  - **Templated** (predefined fragments),
  - **Limited per character**,
  - **Ephemeral** (expire after a time).

- Small optional **tips** (copper/silver) reward helpful notes but cannot be abused as a trading back-door.

### 2.3 Data Model

**Templates:**

```sql
CREATE TABLE IF NOT EXISTS mortal_notes_templates (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  category        VARCHAR(32) NOT NULL,  -- 'WARNING','RESOURCE','SECRET','HUMOR'
  text_base       VARCHAR(64) NOT NULL,  -- e.g. 'Enemy ahead', 'Hidden path'
  text_suffix     VARCHAR(64) NULL       -- e.g. 'on the left', 'above'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Placed notes:**

```sql
CREATE TABLE IF NOT EXISTS mortal_traveler_notes (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  creator_guid    INT NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  x               FLOAT NOT NULL,
  y               FLOAT NOT NULL,
  z               FLOAT NOT NULL,
  template_id     INT NOT NULL,
  created_time    INT NOT NULL,
  expires_time    INT NOT NULL,
  upvotes         INT NOT NULL DEFAULT 0,
  downvotes       INT NOT NULL DEFAULT 0,
  tips_copper     BIGINT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0 -- reserved (e.g. muted/spam)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2.4 Placement Rules

- Each character can have **max N active notes** (e.g. 3–5).
- Notes **expire** after configurable time (e.g. 24–72 hours).
- Notes may only be placed in:

  - Outdoor zones (no spam inside capitals’ inn interiors),
  - Non-instanced world maps (excluding dev/test maps).

- Placement uses a simple command or item:

  - Item: `Chalk of the Traveler`
  - On use: opens AIO/MortalUI dialog:
    - Choose template category,
    - Choose text variant,
    - Confirm placement.

### 2.5 Viewing & Tipping

- When near a note:

  - Player sees a small world icon + hint (“Press [Interact] to read traveler’s note.”).
  - Reading opens small popup:
    - Text composed from template,
    - “Helpful / Misleading” buttons,
    - Optional “Tip” button.

- **Tips**:

  - Fixed small denominations (e.g. 10, 25, 50 copper).
  - Tips accumulate in `tips_copper` and get **mailed to creator** at intervals (batch process) with small system fee sink (e.g. 10–20% cut).

### 2.6 Integration & Limits

- **Explorer Mastery tree:**

  - Nodes to:
    - Increase max notes,
    - Increase note lifetime,
    - Show highly-rated notes on MortalMap.

- **Security / Telemetry:**

  - Telemetry logs number of notes created/read per day (optional).
  - Security filters may auto-flag creators with excessive **downvotes** for GM review.

---

## 3. Insurance Vouchers (Economy-Safe Softening of Loss)

### 3.1 Concept

Instead of printing gold like EVE ship insurance, Mortal Warcraft uses:

- **Insurance Vouchers** = partial material or cost **credits** toward replacing specific items.
- On full-loot death, insured items still **drop** for the killer.
- The former owner gets **limited help** replacing them, without breaking the economy.

### 3.2 Policy Types

We define two insurance modes:

1. **Material Rebate Policy (Preferred)**
   - On insured item loss:
     - Player receives **Material Vouchers** representing a portion of the base material value.

2. **Crafting Discount Policy (Optional)**
   - On insured item loss:
     - Player gets a **discount token** redeemable at NPC crafters (or certain players) to reduce gold fees.

No policy ever returns the full cost. Target range: **30–60%** of base material value, depending on premium.

### 3.3 Data Model

**Policy configuration:**

```sql
CREATE TABLE IF NOT EXISTS mortal_insurance_policies (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  policy_code     VARCHAR(32) NOT NULL,    -- 'BASIC','ENHANCED'
  name            VARCHAR(64) NOT NULL,
  description     VARCHAR(255) NULL,
  coverage_pct    INT NOT NULL,            -- 30..60 (% of base value)
  duration_seconds INT NOT NULL,           -- coverage duration per purchase
  premium_pct     INT NOT NULL,            -- cost as % of base value
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Player item policies:**

```sql
CREATE TABLE IF NOT EXISTS mortal_insured_items (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,            -- owner guid
  item_guid       BIGINT NOT NULL,         -- unique item instance id
  policy_id       INT NOT NULL,
  insured_from    INT NOT NULL,
  insured_until   INT NOT NULL,
  last_claim_time INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Claims:**

```sql
CREATE TABLE IF NOT EXISTS mortal_insurance_claims (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,            -- claimant
  item_entry      INT NOT NULL,
  base_value_copper BIGINT NOT NULL,
  payout_copper   BIGINT NOT NULL,
  payout_type     VARCHAR(16) NOT NULL,    -- 'VOUCHER','DISCOUNT'
  created_time    INT NOT NULL,
  death_event_id  BIGINT NULL              -- link to death log, if any
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.4 Rules & Flow

1. Player visits **Goblin Insurer NPC** in city.
2. Insurer inspects eligible items:

   - Only **non-Blessed** gear.
   - Only specific slots / tiers (e.g. chest/leg main armor, weapons).
   - Items above minimum material value.

3. Player chooses policy for item:

   - Pays premium (gold sink).
   - Entry added to `mortal_insured_items`.

4. On full-loot death in zone where item is dropped:

   - Death handler checks:
     - Was item insured and within coverage time?
   - If yes:
     - Creates a claim in `mortal_insurance_claims`.
     - Issues **Insurance Voucher** item mailed to player (or directly credits a “Material Voucher” currency).

5. Voucher Redemption:

   - Player can redeem vouchers at:
     - Goblin Insurer (for raw mats),
     - Or special **Insurance-approved crafters**.

### 3.5 Constraints & Anti-Abuse

- Insured items **still fully lootable**.
- Cannot insure:
  - Blessed items,
  - Items of certain “legendary/relic” rarity (T6-level),
  - Items flagged as “trivial” (starter gear).
- No Supporter-only discounts on premiums or payouts.
- Telemetry monitors claim rates & payout vs premium to check for exploits.

---

## 4. Anomaly Scanning (Moving Micro-Dungeons)

### 4.1 Concept

Anomalies are **temporary, hidden micro-dungeons**:

- Appear as invisible “Rifts” in the world.
- Can only be detected via **Arcane Eye** skill/trinket.
- Lead to small instanced or phased encounters:
  - 1–3 rooms,
  - A mini-boss or elite pack,
  - Specialized loot (runes, rare reagents, cosmetics).

Once cleared, they **despawn** and respawn elsewhere.

### 4.2 Data Model

**Anomaly spawn definitions:**

```sql
CREATE TABLE IF NOT EXISTS mortal_anomaly_def (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,  -- 'ANOMALY_ARCANE_SHARD','ANOMALY_RUNE_FORGE'
  name            VARCHAR(64) NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  min_level       INT NOT NULL,
  max_level       INT NOT NULL,
  rarity_weight   INT NOT NULL DEFAULT 1, -- spawn weighting
  dungeon_template_code VARCHAR(64) NOT NULL, -- links to micro-dungeon templates
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Active anomalies:**

```sql
CREATE TABLE IF NOT EXISTS mortal_anomaly_active (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  anomaly_def_id  INT NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  x               FLOAT NOT NULL,
  y               FLOAT NOT NULL,
  z               FLOAT NOT NULL,
  spawned_time    INT NOT NULL,
  expires_time    INT NOT NULL,
  cleared         TINYINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.3 Detection Flow

- `Arcane Eye`:

  - Either a **trinket item** or **Explorer skill** unlocked at certain Mastery threshold.
  - When equipped/active:
    - Client periodically receives a “signal strength” value based on distance to nearest active anomaly in same zone.

- UI:

  - MortalUI shows:
    - A simple meter or pulsing indicator (“Arcane disturbance nearby”).
    - Optional directional hints as Mastery upgrades.

- Interaction:

  - When in proximity:
    - A visible “Rift” GameObject appears for Arcane Eye users.
    - Interacting triggers:
      - Instancing or phasing into the micro-dungeon defined by `dungeon_template_code`.

### 4.4 Rewards & Balancing

- Rewards focus on:

  - Unique Runes,
  - Exotic reagents,
  - Cosmetic unlock tokens.

- Avoid being **primary source** of:

  - Core progression mats,
  - Main gear tiers.

- Telemetry tracks:

  - Anomalies discovered vs spawned,
  - Time-to-clear,
  - Reward yields.

---

## 5. Planar Rifts (Phased Open-World Events)

### 5.1 Concept

Planar Rifts are **RIFT-like open world events** built on **WotLK phasing**:

- Stable open-world location, but event is overlaid using phase masks.
- Multi-stage structure:
  - Stage 1: stabilize minor tears.
  - Stage 2: defend a wardstone/shrine.
  - Stage 3: kill the Rift boss.

Players opt-in by interacting with a **Planar Tear** and being moved into the event **phase**.

### 5.2 Data Model

**Rift event definitions:**

```sql
CREATE TABLE IF NOT EXISTS mortal_rift_def (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,    -- 'RIFT_FIRE_ELWYNN'
  name            VARCHAR(64) NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  base_phase_mask INT NOT NULL,            -- normal world phase
  rift_phase_mask INT NOT NULL,            -- phase for rift participants
  stage_count     INT NOT NULL DEFAULT 3,
  config_json     TEXT NOT NULL,           -- stage configs, spawn entries, timings
  cooldown_seconds INT NOT NULL DEFAULT 3600,
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**Active Rifts:**

```sql
CREATE TABLE IF NOT EXISTS mortal_rift_active (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  rift_def_id     INT NOT NULL,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  x               FLOAT NOT NULL,
  y               FLOAT NOT NULL,
  z               FLOAT NOT NULL,
  started_time    INT NOT NULL,
  end_time        INT NULL,
  current_stage   INT NOT NULL DEFAULT 1,
  state           VARCHAR(16) NOT NULL DEFAULT 'RUNNING', -- 'RUNNING','FAILED','COMPLETED'
  participants_json TEXT NULL           -- optional summary of participants for rewards/fame
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.3 Flow & Phasing

1. A RIFT event is started (automatically or by GM via Event system, File 42).
2. A **Planar Tear object** appears in base phase at coordinates.

   - Everyone can see the tear.
   - No mobs yet in base phase.

3. Players who interact and opt-in:

   - Receive a **Rift Participant aura** that sets their phase to `rift_phase_mask`.
   - They now see:
     - Rift mobs,
     - Wardstones,
     - Corrupted sky FX (phased props),
     - Stage UI.

4. Stages progress:

   - Stage 1:
     - Kill X minor rift mobs / close mini-tears.
   - Stage 2:
     - Defend a wardstone / shrine from waves.
   - Stage 3:
     - Kill the Rift boss.

5. End conditions:

   - **Completed**:
     - Boss dies within time.
     - Participants get rewards.
   - **Failed**:
     - Wardstone destroyed,
     - Timer expired.
   - In either case:
     - Rift despawns,
     - Participant auras removed,
     - Optional world “scar” object appears in base phase as flavor.

### 5.4 Rewards & Integration

- Rifts are **side content**:

  - Rewards in line with:
    - Strong Task/World Event loops,
    - Explorer / Warlord / Guardian Mastery synergies.

- Reward types:

  - Planar Shards (new mat),
  - Chance at Runes,
  - Cosmetic unlock tokens,
  - Modest gold/mats (not beating Red-Zone trade/dungeons).

- Telemetry:

  - Tracks participation, completion/failure rates, reward yields.

- Events system:

  - Planar Rifts are implemented as a **special category** of Event Template (File 42),
  - With rift-specific config encoded in `config_json`.

---

## 6. Integration Summary

These four systems slot into existing specs as follows:

1. **Traveler’s Notes**
   - Extends:
     - Navigation & Wayfinding spec,
     - Social/Onboarding spec,
     - MortalMap integration.
   - Adds:
     - `mortal_notes_templates`,
     - `mortal_traveler_notes`,
     - A MortalUI panel for note templates & visibility filters.

2. **Insurance Vouchers**
   - Extends:
     - Economy spec,
     - Risk & Death spec.
   - Adds:
     - `mortal_insurance_policies`,
     - `mortal_insured_items`,
     - `mortal_insurance_claims`,
     - Goblin Insurer NPC & UI.

3. **Anomaly Scanning**
   - Extends:
     - PvE / World / Events spec,
     - Explorer Mastery tree,
     - Telemetry spec (optional counters).
   - Adds:
     - `mortal_anomaly_def`,
     - `mortal_anomaly_active`,
     - Arcane Eye trinket/skill and anomaly runner.

4. **Planar Rifts**
   - Extends:
     - GM Tools & Live Events spec,
     - World Events (Zombie Horde, Resource Surges),
     - Long-Term Progression & Eras (featured Rifts per Era).
   - Adds:
     - `mortal_rift_def`,
     - `mortal_rift_active`,
     - Rift participant aura & stage scripts.

Together, these features give Mortal Warcraft:

- Elden Ring–style **asynchronous social flavor**,
- EVE-like **risk softening that still respects full loot**,
- EVE/RIFT-style **moving exploratory content**,
- RIFT-style **phased open-world setpieces**—

All without undermining your core **skill-based, high-risk sandbox** identity.
