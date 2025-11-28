# Project Canvas: Mortal Warcraft Overhaul
### Version 35.0 — Hybrid Technical Design Document  
### File: 55-build-presets-and-loadouts.md  
### Section: Build Presets & Loadout System

---

## 1. Purpose

Provide a **Build Preset / Loadout** system that:

- Captures a character’s **intended configuration**:
  - Attribute allocation,
  - Mastery Trees,
  - Gear set (items),
  - Runic & Augment layout.
- Allows quick **swapping between roles/styles** (within what you actually own).
- Integrates with:
  - Full-loot rules (presets are *plans*, not guarantees),
  - Factions & Seasons (sharing and aspirational builds),
  - Atlas (optional web viewing/sharing later).

Goals:

- Encourage **experimentation** (multiple builds, saved safely).
- Provide **quality-of-life** for active players:
  - “Red Zone Raider”, “Hellgate Support”, “Delve Tank”, etc.
- Avoid giving unfair combat advantages:
  - Respect combat-lock restrictions and risk rules.
  - Enforce realistic gear availability.

---

## Related Specs

For full context on build presets and loadouts, see:

- **`47-mentoring-and-build-loadouts.md`** — Mentor system and build loadout mechanics
- **`75-mortal-gear-and-runes-spec.md`** — Gear and rune system that presets configure
- **`53-rune-augments-and-gear-build-system.md`** — Rune and augment system used in presets
- **`01-progression.md`** — Attribute allocation and mastery trees stored in presets
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that presets optimize for
- **`03-risk-zones.md`** — Risk zones that affect when loadouts can be swapped

---

## 2. Concept Overview

### 2.1 What a Build Preset Is

A **Build Preset** is a named configuration that stores:

- **Attributes**:
  - Target distribution within 150/400 caps.
- **Mastery Trees**:
  - Selected talents in Warlord / Guardian / Explorer trees.
- **Gear Layout**:
  - Desired item IDs for each equipment slot.
- **Runes & Augments**:
  - Desired enhancement setup on each piece of gear.

Presets can be:

- Character-specific,
- Stored server-side and optionally mirrored by Atlas.

### 2.2 What a Build Preset Is NOT

- It is *not* an infinite wardrobe:
  - You must actually own the items.
- It is *not* a way to bypass:
  - Attribute caps,
  - Respec rules (still cost tokens / gold),
  - Combat-lock restrictions for swapping.

---

## 3. Use Cases

- **Role Switching**:
  - Solo roaming build vs group support build.
- **Content-Specific Builds**:
  - Hellgate build (high burst + survivability),
  - Stronghold Defense build (AoE + CC),
  - Caravan build (encumbrance + movement augments).
- **Aspirational Builds**:
  - “Endgame” loadout saved as a goal list:
    - Preset exists even if you don’t own all pieces yet,
    - UI marks missing pieces and requirements.

---

## 4. Preset Structure

### 4.1 Data Elements

Each preset includes:

1. **Metadata**
   - Name (e.g., “Red Zone Raider”),
   - Description/notes (optional),
   - Icon (optional),
   - Role tags (DPS/Tank/Support/Utility).

2. **Attributes**
   - Target values for Str/Agi/Sta/Int/Spi,
   - Must obey 150-per-stat / 400-total caps or be rejected.

3. **Mastery Trees**
   - Points in Warlord / Guardian / Explorer,
   - Must respect:
     - Tree rules (per-row unlocks, etc.),
     - Total Mastery points = `SkillPoints / 50`.

4. **Gear Layout**
   - For each slot (head, chest, main-hand, off-hand, etc.):
     - Desired item template entry (not instance),
     - Optional flags for “Any of this class of item” in future (e.g., any T2 Mortal Sword).

5. **Enhancements**
   - Per-slot list of:
     - Rune codes (e.g., `RUNE_WHIRLWIND`),
     - Augment codes (e.g., `AUG_STONE_BRACE`, `AUG_TRAILBLAZER`).

Preset does not store GUIDs of actual items, only **desired templates**, making it resilient to losing/reacquiring items.

---

## 5. Data Model (MySQL)

### 5.1 Preset Header

```sql
CREATE TABLE IF NOT EXISTS mortal_build_presets (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,              -- character guid
  name            VARCHAR(64) NOT NULL,
  description     TEXT NULL,
  icon            VARCHAR(64) NULL,
  role_tag        VARCHAR(32) NULL,          -- 'DPS','TANK','SUPPORT','UTILITY',etc.
  is_active       TINYINT(1) NOT NULL DEFAULT 1,
  created_ts      INT NOT NULL,
  updated_ts      INT NOT NULL,
  INDEX idx_presets_guid (guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.2 Preset Attributes & Masteries

```sql
CREATE TABLE IF NOT EXISTS mortal_build_preset_stats (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  preset_id       INT NOT NULL,
  str_value       INT NOT NULL DEFAULT 0,
  agi_value       INT NOT NULL DEFAULT 0,
  sta_value       INT NOT NULL DEFAULT 0,
  int_value       INT NOT NULL DEFAULT 0,
  spi_value       INT NOT NULL DEFAULT 0,
  mastery_json    JSON NULL,                 -- serialized Mastery tree picks
  CONSTRAINT fk_mortal_build_preset_stats
    FOREIGN KEY (preset_id) REFERENCES mortal_build_presets(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`mastery_json` could store a structure like:

```json
{
  "WARLORD": {"1_1": 3, "2_2": 2},
  "GUARDIAN": {"1_3": 1},
  "EXPLORER": {}
}
```

### 5.3 Gear Layout

```sql
CREATE TABLE IF NOT EXISTS mortal_build_preset_gear (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  preset_id       INT NOT NULL,
  slot_id         TINYINT NOT NULL,           -- consistent with equipment slot enum
  item_entry      INT NOT NULL,               -- desired item_template.entry
  flags           INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_mortal_build_preset_gear
    FOREIGN KEY (preset_id) REFERENCES mortal_build_presets(id)
    ON DELETE CASCADE,
  UNIQUE KEY uniq_preset_slot (preset_id, slot_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.4 Enhancements (Runes & Augments)

```sql
CREATE TABLE IF NOT EXISTS mortal_build_preset_enhancements (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  preset_id       INT NOT NULL,
  slot_id         TINYINT NOT NULL,      -- equipment slot
  enhancement_code VARCHAR(64) NOT NULL, -- matches mortal_enhancements.code
  priority        TINYINT NOT NULL DEFAULT 0,
  CONSTRAINT fk_mortal_build_preset_enh
    FOREIGN KEY (preset_id) REFERENCES mortal_build_presets(id)
    ON DELETE CASCADE,
  INDEX idx_preset_slot (preset_id, slot_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`priority` can determine which augment is applied first if capacity is limited.

---

## 6. Applying Presets

### 6.1 Validity & Constraints

When a player activates a preset:

1. Server validates:
   - Attribute totals <= 400, individual <= 150.
   - Mastery total points <= `SkillPoints / 50` and meets tree rules.
2. For gear:
   - Check inventory, bank, current equipment for items that match each `item_entry`.
   - Pick a concrete instance (GUID) per slot, preferring:
     - Items with best condition,
     - Items not already in use by another slot in the same preset apply operation.
3. For enhancements:
   - Check whether the chosen items:
     - Have appropriate rune/augment sockets defined in `mortal_gear_sockets`,
     - Are not currently locked/unique in a conflicting preset (no global restrictions here unless designed).

If any element is invalid or missing, system:

- Applies the **valid subset**,
- Reports to the player what could not be applied (e.g., missing chest or rune).

### 6.2 Combat Lock Rules

To avoid unfair instant swapping:

- Presets can be applied:
  - Out of combat only, OR
  - In specific low-risk contexts (Shrine, Inn, Stronghold).
- Certain components might be:
  - Lockable in combat (gear & runes),
  - More flexible out of combat (augments, masteries via respec tokens).

Tunable rule:

- Start strict: presets are fully out-of-combat only.
- Consider loosening only for non-combat features after testing.

---

## 7. Integration with Existing Systems

### 7.1 Respec System

- Applying a preset that changes Mastery/Attributes may:
  - Require spending **Respec Tokens** if the changes exceed a free threshold.
- UX:
  - Show cost upfront,
  - Reject or confirm based on token availability.

### 7.2 Factions & Seasons

- Factions can reward:
  - Extra preset slots,
  - Special role tags,
  - Cosmetic badges on UI for faction builds.
- Seasonal challenges can:
  - Encourage creating/using builds in certain content:
    - “Complete a Hellgate using a preset tagged ‘RANGERS’ PACT’.”

### 7.3 Atlas (Web Build Viewer)

Future integration:

- Atlas can read preset data via API:
  - Display builds per character (opt-in/public),
  - Support “share build link” for community theorycrafting.

Optional later:

- Import/export build strings:
  - textual codes or JSON,
  - enable sharing between players (still constrained to items they own).

---

## 8. UI & UX (MortalUI)

### 8.1 Preset Management Panel

- List of presets:
  - Name, role tag, brief summary.
- Per-preset actions:
  - Activate,
  - Edit,
  - Duplicate,
  - Delete.

### 8.2 Preset Detail View

Tabs:

1. **Summary**:
   - Name, role, short description.
   - Highlight main strengths (based on augments/attributes).
2. **Attributes & Mastery**:
   - Visual tree with points allocated.
   - Attribute bars with cap indicators.
3. **Gear & Enhancements**:
   - Paperdoll showing targeted items.
   - Rune/Augment layout by slot.
   - Indicators for:
     - “Owned and available”,
     - “Owned but currently equipped elsewhere” (if relevant),
     - “Missing”.

### 8.3 Activation Feedback

When applying a preset:

- Show:
  - Which parts were applied successfully.
  - List of failures:
    - “Missing item: Mortal Iron Helm (T1),
      Missing rune: RUNE_WHIRLWIND.”
- Option to:
  - Save partial application,
  - Cancel and revert (if possible).

---

## 9. Limits & Safeguards

To keep system manageable and performant:

- **Preset limit per character**:
  - Start with 5–10,
  - Expand via Faction rewards or monetization (Supporter perks) if desired.
- **Rate limiting**:
  - Cooldown on applying a preset (e.g., 30–60 seconds),
  - Prevents macro-level abuse.
- **Logging**:
  - Optional logging for preset activations for debugging and abuse analysis.

---

## 10. Implementation Checklist

1. **DB**
   - Create `mortal_build_presets`, `mortal_build_preset_stats`,
     `mortal_build_preset_gear`, `mortal_build_preset_enhancements`.
2. **Server**
   - Implement preset creation, update, delete, list APIs.
   - Implement apply logic:
     - Validate stats/masteries,
     - Map desired gear to actual owned items,
     - Apply runes/augments where possible.
   - Enforce combat/out-of-combat application rules.
3. **UI – MortalUI**
   - Preset management panel and detail views.
   - Activation flow with clear success/failure feedback.
4. **Integration**
   - Hook into respec token usage for stat/mind changes.
   - Expose endpoints for Atlas to read presets (later).
5. **Balancing / Tuning**
   - Decide initial preset cap per character.
   - Decide where presets can be changed (Shrines, Inns, Strongholds).
   - Iterate based on playtests (e.g., if players feel forced to micromanage too often).

---

This build preset system makes your Rune/Augment layers and Mastery trees far more user-friendly and “Warframe-like” (multiple builds per frame), while respecting Mortal Warcraft’s full-loot, harsh-world identity.
