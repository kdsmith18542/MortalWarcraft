# Project Canvas: Mortal Warcraft Overhaul
### Version 34.0 — Hybrid Technical Design Document  
### File: 53-rune-augments-and-gear-build-system.md  
### Section: Rune Abilities & Augment Cards

---

## 1. Purpose

Extend the existing **Rune = ability-on-gear** system with a lightweight **Augment Card** layer inspired by Warframe mods, tuned for Mortal Warcraft’s:

- **Classless, gear-driven identity**,
- **Hard attribute caps & small level band**,
- **Full-loot, gear-loss risk**.

Goals:

- Increase **build diversity** and long-term theorycrafting.
- Make crafted and faction gear feel more **distinct**.
- Keep system:
  - Understandable (no 100-mod grids),
  - Tightly integrated with existing Crafting, Factions, and Economy,
  - Safe from runaway power creep.

High-level:

- **Runes** = define *what* abilities a piece of gear grants.
- **Augments** = modify *how* those abilities and core stats behave.

---

## Related Specs

For full context on rune and augment systems, see:

- **`75-mortal-gear-and-runes-spec.md`** — Core gear and rune system that augments extend
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that augments modify
- **`55-build-presets-and-loadouts.md`** — Build presets and loadouts that use runes and augments
- **`02-combat.md`** — Combat mechanics that runes and augments affect
- **`05-crafting.md`** — Crafting system that produces runes and augments
- **`51-factions-and-standing-system.md`** — Faction system that provides unique runes and augments
- **`19-itemization.md`** — Itemization system that defines rune and augment slots

---

## 2. Gear Slots, Runes & Augment Capacity

### 2.1 Gear Types

We distinguish:

- **Weapons** (1H/2H melee, ranged, caster focuses),
- **Armor** (head, chest, legs, hands, feet, belt, etc.),
- **Accessories** (rings, amulets, trinkets).

### 2.2 Slots per Gear Type

Base (tunable):

- Weapons:
  - 1x **Rune Slot**,
  - 2x **Augment Slots** (3x for high-end “Masterwork”).
- Armor pieces:
  - 0–1x Rune Slots (for specific archetypes: chest, helm),
  - 1x Augment Slot (2x for Masterwork).
- Accessories:
  - No Rune Slots,
  - 1x Augment Slot.

These are enforced via:

- Item templates in DB,
- Additional metadata in a `mortal_gear_sockets` table (below).

### 2.3 Capacity & Constraints

To keep builds readable and balanced:

- Each Augment has:
  - **Type** tag (OFFENSE, DEFENSE, UTILITY),
  - Optional **Affinity** (weapon type, armor weight, rune synergy).
- Each item has:
  - Max total Augments,
  - Optional per-type caps (e.g., no more than 1 OFFENSE augment on a chest).

---

## 3. Runes vs Augments

### 3.1 Runes (Existing Concept)

- Major, defining effects:
  - Grant active abilities (Whirlwind, Blink, Guard Counter variant),
  - Grant unique passives (thorns, lifesteal, special procs).
- Tied thematically to:
  - Elden / Mortal combat abilities,
  - Faction/globally-recognized ability names.

Source:

- Dungeon/raid drops,
- Public Delves,
- Faction vendors,
- Rare crafting outputs.

Risk:

- Losing gear = losing rune ability until replaced.

### 3.2 Augments (New Layer)

- Smaller, **tunable modifiers**:
  - “+X% stamina efficiency for Rune Y,”
  - “+Y% bleed damage on crits,”
  - “Brace grants a minor movespeed buff after use.”
- They **never provide core abilities** on their own.
- They are **reusable**:
  - Can be unsocketed (with a small fee),
  - Moved to a new piece of gear.

Source:

- Faction rewards,
- High-end crafting crits (“Masterwork”),
- Rifts/Hellgates, Endless Contracts,
- Seasonal track rewards (cosmetic/special variants).

---

## 4. Augment Types & Examples

### 4.1 Types

- **OFFENSE**:
  - Damage-side tweaks tied to weapon runes or basic attacks.
- **DEFENSE**:
  - Survivability constructs (mitigation, Guard Counter buffs, Brace synergy).
- **UTILITY**:
  - Movement, stamina/energy efficiency, crafting/logistics perks, vision/awareness.

### 4.2 Example Offense Augments

- *Razor Gale* (OFFENSE, Sword affinity):
  - “When using Whirlwind, apply a small Bleed (X over 4s).”
- *Measured Strikes*:
  - “Basic melee attacks gain +5% crit chance when above 80% stamina.”
- *Executioner’s Edge*:
  - “+10% damage vs low-health enemies (<20%).”

### 4.3 Example Defense Augments

- *Stone Brace*:
  - “Brace reduces damage by an additional 10% vs the first hit during its window.”
- *Iron Will*:
  - “Taking a Guard Counter opportunity grants +5% damage reduction for 3s.”
- *Shrinebound* (Order of the Shrine faction):
  - “+X% resistance to undead/holy damage near Shrines.”

### 4.4 Example Utility Augments

- *Trailblazer* (Rangers’ Pact):
  - “+5% movespeed on roads, +2% movespeed off-road.”
- *Packrat* (Iron Ledger):
  - “+5% carry capacity for materials (counted for encumbrance).”
- *Smuggler’s Guile* (Black Sun Cartel):
  - “Reduced gold loss on death by Y% (capped, tuned).”

---

## 5. Data Model

### 5.1 Gear Socket Definitions

```sql
CREATE TABLE IF NOT EXISTS mortal_gear_sockets (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  item_entry      INT NOT NULL,       -- reference to item_template.entry
  rune_slots      TINYINT NOT NULL DEFAULT 0,
  augment_slots   TINYINT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0,
  UNIQUE KEY uniq_item_entry (item_entry)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Optionally, we can add:

```sql
ALTER TABLE mortal_gear_sockets
  ADD COLUMN max_offense_augments TINYINT NOT NULL DEFAULT 2,
  ADD COLUMN max_defense_augments TINYINT NOT NULL DEFAULT 2,
  ADD COLUMN max_utility_augments TINYINT NOT NULL DEFAULT 2;
```

### 5.2 Rune & Augment Definitions

If not already present for Runes, define unified table for both:

```sql
CREATE TABLE IF NOT EXISTS mortal_enhancements (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE, -- 'RUNE_WHIRLWIND', 'AUG_STONE_BRACE'
  name            VARCHAR(128) NOT NULL,
  type            VARCHAR(16) NOT NULL,       -- 'RUNE','AUGMENT'
  category        VARCHAR(16) NOT NULL,       -- for augments: 'OFFENSE','DEFENSE','UTILITY'
  affinity        VARCHAR(32) NULL,           -- 'SWORD','SHIELD','PLATE','ANY'
  description     TEXT NOT NULL,
  icon            VARCHAR(128) NULL,
  script_hook     VARCHAR(64) NULL,           -- link to Lua/C++ hooks
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.3 Socketed Enhancements on Items

For each item instance (character equipment, bank, inventory), we need a record of what’s slotted:

```sql
CREATE TABLE IF NOT EXISTS mortal_item_enhancements (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  item_guid       BIGINT NOT NULL,    -- unique item instance guid
  slot_index      TINYINT NOT NULL,   -- 0..N-1 (runes/augments distinguished via flags)
  enhancement_id  INT NOT NULL,       -- FK to mortal_enhancements.id
  flags           INT NOT NULL DEFAULT 0,
  INDEX idx_item_guid (item_guid),
  CONSTRAINT fk_mortal_item_enhancements_enh
    FOREIGN KEY (enhancement_id) REFERENCES mortal_enhancements(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

We can define fixed mapping:

- `slot_index` range for **runes** (e.g., 0–3),
- `slot_index` range for **augments** (e.g., 10–19),
or store type in `flags`.

---

## 6. Server Logic

### 6.1 Applying Enhancements

When calculating combat stats/abilities:

1. Look up the currently equipped items.
2. For each item:
   - Determine available rune / augment slots from `mortal_gear_sockets`.
   - Load `mortal_item_enhancements` rows for that `item_guid`.
3. Aggregate effects:
   - Runes:
     - Grant abilities/passives (added to spellbook/ability list).
   - Augments:
     - Modify:
       - Ability params (cooldowns, costs, multipliers),
       - Character stats (within allowed budgets),
       - Event hooks (on-crit, on-Guard Counter, etc.).

The logic to apply augment effects will live in:

- C++ for core stat hooks (damage, resistances),
- Lua for ability tweaks and on-event scripts.

### 6.2 Socketing / Unsocketing

NPC or UI-driven process:

- Socketing:
  - Check:
    - Item has free slots,
    - Augment type/affinity matches item type and limits.
  - Insert row into `mortal_item_enhancements`.
- Unsocketing:
  - Remove mapping row.
  - Decide:
    - Augment returned intact, or
    - Chance to break on removal (for economy sink).

### 6.3 Limiters & Anti-Stacking

To avoid degenerate stacking:

- Augment uniqueness:
  - Per item:
    - Disallow duplicates of the same augment.
  - Per character:
    - Optional cap on certain rare augments (“You may equip only 1 instance of this augment”).
- Category caps:
  - Enforce `max_offense_augments` / etc. from `mortal_gear_sockets`.

---

## 7. Integration with Existing Systems

### 7.1 Crafting (Masterwork & Crits)

- When crafting gear:
  - Normal success:
    - Uses default socket layout.
  - **High “crit” success (“Masterwork”)**:
    - Adds +1 augment slot (within absolute maximum),
    - Or automatically rolls a random appropriate augment (optionally).

This makes **crafters** primary suppliers of high-socket gear.

### 7.2 Factions

Factions sell:

- **Faction-specific augments**:
  - Order of the Shrine = defensive/anti-undead augments.
  - Iron Ledger = encumbrance/logistics augments.
  - Black Sun Cartel = risk/economy augments.
  - Rangers’ Pact = movement/exploration augments.

Higher ranks unlock more exotic augments (but still within balance constraints).

### 7.3 Rifts, Hellgates, Endless Contracts

- Drop tables for these systems include:
  - Raw Augments,
  - Augment Fragments (craft into specific augments),
  - Blueprint-style items that unlock the ability to craft certain augments.

### 7.4 Seasonal Track

- Seasonal rewards:
  - Cosmetic variants of augments (VFX, rename) but same stats, or
  - Access tokens / commendations to buy augments from factions.

Avoid permanent, never-again-available unique power augments.

---

## 8. Balance Guidelines

To keep things healthy:

- No augment should:
  - Add more than a small % bonus to a **core stat** alone,
  - Completely remove a downside (e.g., zero stamina cost), though partial mitigation is fine.
- Many augments should:
  - Be **conditional**:
    - “When above 80% stamina,”
    - “After a Guard Counter,”
    - “In Red Zones,” etc.
- Handle big effects via:
  - **Mutual exclusivity**:
    - Only one of a set can be equipped at a time,
  - **Strong opportunity costs**:
    - Taking one big augment uses a whole category quota.

---

## 9. UI & UX (MortalUI)

- Gear detail window:
  - Show Rune and Augment slots with icons.
  - Tooltip for each:
    - Name, category, effect, source (Crafted/Faction/Event).
- Socketing UI:
  - Drag-and-drop or click-to-assign.
  - Show warnings when:
    - Exceeding type caps,
    - Trying to use incompatible augments.
- Build Presets (planned):
  - Save `attributes + mastery + rune/augment layout` for easy swapping.

---

## 10. Implementation Checklist

1. **DB**
   - Create `mortal_gear_sockets`, `mortal_enhancements`, `mortal_item_enhancements`.
   - Seed initial Rune and Augment definitions.
2. **Server**
   - Implement socket resolution and enhancement aggregation in core.
   - Expose Lua hooks for ability/rune-specific augment behaviors.
   - Add socketing/unsocketing calls (NPC or UI-driven).
3. **Content**
   - Define initial augment set for:
     - Factions,
     - Core combat loops (Brace, Guard Counter),
     - Basic trading/exploration.
   - Update crafting scripts to support Masterwork + extra slots.
4. **UI**
   - MortalUI panels for gear sockets and enhancements.
   - Feedback when augments affect abilities.
5. **Balancing**
   - Initial tuning pass with small numbers.
   - Internal tests with a limited set of augments before adding many more.
