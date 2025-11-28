# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 21-elden-systems.md  
### Section: Elden Ring–Inspired Systems (Flasks, Weapon Runes, Guard Counters)

---

# 1. Purpose

This document formalizes **three Elden Ring–inspired mechanics** adapted for Mortal Warcraft:

1. **Crimson Phial** – refillable healing flask (replaces potion spam).
2. **Runes of Mastery** – weapon-embedded abilities (Ashes of War analogue).
3. **Guard Counter** – timed defensive responses (perfect block → empowered counter).

These systems:

- Reinforce **risk, travel, and resource scarcity**.
- Support **classless identity via gear**.
- Raise the **skill ceiling** for both PvE and PvP.
- Integrate cleanly with AzerothCore (C++ hooks, Lua logic, MortalUI, AIO).

---

## Related Specs

For full context on Elden systems, see:

- **`75-mortal-gear-and-runes-spec.md`** — Rune system that includes Runes of Mastery
- **`02-combat.md`** — Combat mechanics that include Guard Counter
- **`22-healing-and-restoration.md`** — Healing system that uses Crimson Phial
- **`59-shrine-and-faction-trials.md`** — Shrine system where Crimson Phial refills
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that affect Guard Counter effectiveness
- **`64-spell-and-ability-library.md`** — Spell and ability library that includes rune abilities
- **`45-eldens-eve-layer.md`** — Extended Elden's Eve layer systems

---

# 2. The Crimson Phial (Flask System)

## 2.1 Design Goals

- Replace “100 health potions in bags” with **limited, strategic healing**.
- Tightly couple **healing capacity** to:
  - Shrines (respawn)
  - Inns (social hubs)
  - Guild halls (progression)
- Encourage:
  - Retreat & planning
  - Risk evaluation before entering Red zones
  - Base-building and guild logistics

## 2.2 Core Rules

**Item:** `Crimson Phial`

- Type: Soulbound, Unique, Non-tradable.
- Slot: Trinket or Unique “Flask” slot (server-side enforcement).
- Charge Limit:
  - Base: **3 charges**.
  - Scales with Guardian mastery (see below).

**Effect:**

- Use effect:  
  - Heals **35–45%** of max HP (tunable via feature flag).
  - 1.5s cast or instant with GCD (decide per balance).
- Cooldown:
  - Per-charge cooldown: 15–30 seconds (tunable).
  - Globally shared with **other flasks** (prevent stacking exploit).

**Refill Conditions:**

- Charges are **only restored to full** when:
  - Player interacts with a **Shrine** (Spirit Healer).
  - Player sleeps/rests at an **Inn** bed or Tavern object.
  - Optional: Guild Hall shrine for higher-level guilds.

- Charges are **not** restored by:
  - Logging out and back in.
  - Using consumables or spells.
  - AFK time.

**Death Interaction:**

- On death:
  - Phial stays Soulbound to the character (not looted by others).
  - Upon respawn at Shrine, Phial charges are **reset to full**.
- This keeps death meaningful (you still lose gear) but avoids degenerate “no flask after one death” frustration.

> Optional Hardcore Variant:  
> Phials drop **empty** on death in Red zones and must be recharged at a Shrine or Inn. Implement via feature flags if testing shows it’s fun.

---

## 2.3 Implementation Details

### 2.3.1 Database

**Item Template:**

- Define one or more items, e.g.:
  - `item_crimson_phial` (`entry = 900000`)
- Fields:
  - `bonding = 1` (Soulbound)
  - `Unique` flag set
  - Use spell = custom `SPELL_CRIMSON_PHIAL` (see C++)

**Character State:**

Use a new table for persistent charge tracking:

`mortal_crimson_phial`

- `guid` (PK, FK → `characters.guid`)
- `max_charges` (TINYINT) – base 3 + bonuses.
- `current_charges` (TINYINT)
- `last_refill_time` (INT)

---

### 2.3.2 C++ Hooks

**Files:**

- `MortalFlask.h / .cpp`
- Integrated with `MortalHooks.cpp`.

**Responsibilities:**

- Register `SPELL_CRIMSON_PHIAL`.
- On spell cast:
  - Check `current_charges > 0`.
  - If yes:
    - Heal player for configured percentage of max HP.
    - Decrement `current_charges`.
  - If not:
    - Deny cast / show error.

- On login:
  - If row missing in `mortal_crimson_phial`, initialize (max=3, current=3).

- On interacting with:
  - **Shrine** (Spirit Healer).
  - **Inn rest trigger (Gossip/GO)**.
  - **Guild Shrine** (optional).
  - Call `MortalFlask::Refill(player)`, setting `current_charges = max_charges`.

---

### 2.3.3 Lua & Feature Flags

Lua script: `MortalFlask.cpp/h (if implemented)` (C++ implementation)

- Reads configuration from:
  - `mortal_feature_flags` keys:
    - `flask_heal_percent`
    - `flask_base_charges`
    - `flask_cd_seconds`
    - `flask_hardcore_drop_empty`

- Can handle:
  - Shrine events (hooking OnGossipSelect etc.).
  - Special Inn / Guild Hall interactions.

---

### 2.3.4 Mastery Integration

In the **Guardian Mastery Tree**:

- Example talents:
  - `Reinforced Phial`:
    - +1 max charge (up to cap, e.g. 5).
  - `Potent Brew`:
    - +10% healing per charge.
  - `Efficient Sips`:
    - 10% chance not to consume a charge (careful with balance).

Implementation:

- Store modifiers in:
  - `mortal_mastery_points` or a dedicated `mortal_mastery_effects` table.
- C++ reads modifiers when calculating:
  - `max_charges`.
  - Effective heal amount.

---

# 3. Runes of Mastery (Weapon Arts / Ashes of War)

## 3.1 Design Goals

- Provide **distinct character identity** in a classless system.
- Tie abilities to:
  - **Weapons**
  - **Runes**
  - **Risk (you can lose gear and thus lose abilities)**.
- Make weapons feel **mortal**, valuable, and expressive:
  - “I’m dangerous because of my sword’s Rune” not because of a locked-in class.

---

## 3.2 Core Rules

**Runes:**

- Items: `Rune of Whirlwind`, `Rune of Mortal Strike`, `Rune of Blink`, etc.
- Type:  
  - Unique per weapon slot (1 Rune per weapon).
  - Can be Soulbound or tradable depending on tier.

**Application:**

- Runes are applied to weapons using:
  - A custom `Rune Engraving` workstation or NPC.
  - Or your existing **socket/enchant** UI, repurposed.

**Effect:**

- When a weapon has a Rune:
  - The character gains the associated **spell/ability** while that weapon is equipped.
- When weapon is unequipped:
  - Ability is removed (or hidden).
- When weapon is lost (full loot):
  - Rune and its ability are lost until a new weapon is runed.

**Restrictions:**

- One Rune per weapon instance.
- Some Runes may be:
  - Weapon-type restricted (only swords, only staves).
  - Tier-restricted (cannot place M-T4 Rune on M-T1 weapon).
- Skill requirements:
  - `Blades 50` to wield Whirlwind Rune on sword.
  - `Arcana 75` to wield Blink Rune on staff.

---

## 3.3 Implementation Details

### 3.3.1 Database

**Tables:**

`mortal_runes`

- `rune_id` (PK)
- `name` (VARCHAR)
- `spell_id` (INT) – ability granted
- `weapon_type_mask` (INT)
- `required_skill_id` (INT)
- `required_skill_level` (INT)
- `tier` (TINYINT)
- `notes` (TEXT)

`mortal_weapon_runes`

- `item_guid` (PK, BIGINT)
- `rune_id` (FK → `mortal_runes.rune_id`)
- `applied_at` (INT)

**Item Templates:**

- Rune items in `item_template`:
  - Map to `mortal_runes` entries via script.
  - Category: glyph/consumable-like.

---

### 3.3.2 C++ Hooks

**Files:**

- `MortalRunes.h / .cpp`.

**Core Logic:**

- On weapon equip:
  - Look up `mortal_weapon_runes` by `item_guid`.
  - If a rune exists:
    - Check skill requirements.
    - Grant spell/ability (`spell_id`) to player (permanent aura or temporary learned).
- On weapon unequip:
  - Remove rune-granted abilities.

- On player login:
  - Scan all equipped weapons.
  - Apply rune abilities as needed.

---

### 3.3.3 Rune Engraving (Lua + AIO)

Lua script: `rune_engraving.lua`  
AIO client script: `aio/rune_engraving_ui.lua`

Flow:

1. Player interacts with `Rune Engraver` NPC or workstation.
2. Server opens AIO window:
   - Shows:
     - Currently equipped weapons.
     - Rune items in bags.
3. Player chooses:
   - Weapon slot → Rune item → “Engrave.”
4. Server validates:
   - Correct weapon type.
   - No existing rune bound.
   - Rune item in inventory.
5. On success:
   - Insert record into `mortal_weapon_runes`.
   - Consume Rune item.
   - Apply ability immediately if weapon is equipped.

---

### 3.3.4 Sources & Balance

**Rune Sources:**

- Dungeon/public delve bosses.
- Hellgates.
- Raids (especially via Cursed Artifacts → Rune BPO/BPC).
- Crafting (Enchanter + Alchemist + Scribe synergy).

**Balance Tuning:**

Use `mortal_feature_flags` for:

- `rune_power_scaling` (global multiplier).
- `rune_max_per_character` (if you want a cap on active runes).
- Per-rune power adjustments.

---

# 4. Guard Counter (Active Defense 2.0)

## 4.1 Design Goals

- Reward **timed defensive play**:
  - Blocking/parrying/Bracing at the right moment.
- Make melee combat:
  - Rhythmic
  - Expressive
  - High-skill-cap
- Integrate with your existing **Brace** universal spell.

---

## 4.2 Core Rules

**Key Concept:**  
If a player **successfully blocks/parries/Braces** an incoming attack within a short timing window, they gain a short-lived **Opportunity** buff.

**Trigger Conditions:**

- Player uses:
  - Block (shield).
  - Parry (weapon).
  - Brace (universal spell).
- An enemy melee attack:
  - Hits or is mitigated by the defensive action.
- Timing window:
  - Example: defensive action used within **0.3–0.4s** before impact.

**Effect:**

- Buff: `Opportunity` (hidden or visible aura).
- Duration: **2 seconds**.
- Next melee attack:
  - Guaranteed Crit, **OR**
  - +50% damage, **OR**
  - +X armor penetration / stagger.

**Restrictions:**

- Only melee swings (not spells) trigger Opportunity.
- Only the **first** hit during Opportunity consumes it.

---

## 4.3 Implementation Details

### 4.3.1 C++ Hooks

**Files:**

- `MortalGuardCounter.h / .cpp`.

**Core Logic:**

- On melee swing event (e.g., in `Unit::MeleeDamage` or equivalent hook):

  - Determine if target has:
    - Recently used Block/Parry/Brace.
    - The action timestamp is within configured window before the hit.
  - If yes:
    - Apply `Opportunity` buff to defender **or** attacker based on desired flavor:
      - Option 1: buff defender for **next attack** (defender’s counter).
      - Option 2: buff attacker to add offensive buff to next swing.

- On `Opportunity` buff gained:
  - Track via aura or internal flags.

- On melee attack while `Opportunity` active:
  - Apply bonus:
    - Force crit, or
    - Multiply damage, etc.
  - Remove `Opportunity`.

**Timing State Storage:**

- Add small state fields to `Player`:
  - `last_block_time`
  - `last_parry_time`
  - `last_brace_time`

Set these when:

- Block/parry events occur.
- Brace spell is cast successfully.

---

### 4.3.2 Configuration

Use `mortal_feature_flags`:

- `guard_counter_window_ms` (e.g., 350 ms).
- `guard_counter_bonus_type` (crit / damage / armor_pen).
- `guard_counter_bonus_value` (percentage).
- `guard_counter_pve_scale` / `guard_counter_pvp_scale` (if you want separate tuning).

---

### 4.3.3 Lua & UI

Lua: `guard_counter.lua`

- Can implement visual cues (via AIO or chat messages).
- May allow Mastery talents to extend window or increase reward.

MortalUI:

- `ui_guard_counter.lua`:
  - Simple icon/flash when `Opportunity` is active.
  - Optional small sound indicator.

---

## 4.4 Mastery Tree Synergies

In Mastery Trees:

- **Warlord**:
  - `Relentless Counter`:
    - Guard Counter buff also increases Attack Speed for 2s.
- **Guardian**:
  - `Iron Wall`:
    - Slightly extends timing window (e.g., +50 ms).
- **Explorer**:
  - `Opportunist`:
    - Guard Counter grants small movement speed boost (hit-and-run PvP).

All of these multiply the feeling that **your build affects how you fight**, even in a classless world.

---

# 5. Integration into Roadmap & Phases

### Recommended Roadmap Slotting

- **Crimson Phial**:
  - Add in **Milestone 1–2** (Progression & Risk Foundations).
  - It replaces health potion spam and shapes all downstream content.

- **Runes of Mastery**:
  - Slot into **Milestone 4 (Crafting Slice)** and **Milestone 6 (PvP)**:
    - Once crafting and risk loops exist, runes add identity and progression.

- **Guard Counter**:
  - Implement in **Milestone 2–3**:
    - As part of core combat and PvP foundation.
    - Tune with early dueling and small-group tests.

---

# 6. Status

This document is the **authoritative design for Elden Ring–inspired systems** in Mortal Warcraft:

- **Crimson Phial** – limited refillable healing, anchored to Shrines & Inns.
- **Runes of Mastery** – weapon-bound abilities lost and gained through gear.
- **Guard Counter** – timing-based defensive play with high-impact counterattacks.

These features should be treated as **core pillars**, not optional extras, when you continue implementing the v26.1 design.

