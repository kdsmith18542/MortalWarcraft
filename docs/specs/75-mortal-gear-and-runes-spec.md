# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Systems Implementation  
### File: 75-mortal-gear-and-runes-spec.md  
### Section: Mortal Gear Progression & Rune (Ashes) System

---

## 1. Purpose

This document defines:

1. The **Mortal Gear Progression model** for the overhaul, built on:
   - WoW 3.3.5a item models,
   - Mortal stat caps (150 per attribute, 400 total),
   - Classless, skill-based progression.

2. The **Rune System** (inspired by Elden Ring’s Ashes of War):
   - Runes are skills/spells attached to gear,
   - Gear identity is driven by **Runes + stats**, not “classes”,
   - Full-loot integration: losing gear often means losing abilities.

This spec is focused on:

- Data layout & tiering,
- Stat budgets and how to tune them,
- Rune categories, acquisition, and behavior on death,
- Hooks for crafting, dungeons, raids, Warfronts, and Strongholds.

---

## Related Specs

For full context on gear and rune systems, see:

- **`84-mortal-core-stats-and-combat-model.md`** — Core stat formulas, attribute caps, and derived stats that gear modifies
- **`53-rune-augments-and-gear-build-system.md`** — Extended rune system, enhancements, and build customization
- **`19-itemization.md`** — Overall itemization philosophy and tier mapping from WotLK items
- **`55-build-presets-and-loadouts.md`** — Build presets and loadout system that use gear and runes
- **`03-risk-zones.md`** — Risk tiers that affect gear drop rates and loot rules on death
- **`02-combat.md`** — Combat mechanics that use gear stats and rune abilities

**⚠️ IMPLEMENTATION GAP: Missing Integration Between Combat Formulas and Gear System**
- **Status**: Both systems exist but integration not fully specified
- **Need**: How gear stats integrate with base combat formulas (damage, hit/miss, crit, etc.)
- **Recommendation**: Document integration points: gear stats → base formulas, rune modifiers → combat calculations, stat calculation order
- **Impact**: Combat formulas and gear system may not integrate correctly
- **`05-crafting.md`** — Crafting system that produces gear and runes

---

## 2. Gear Tiering & Philosophy

### 2.1 Tier Names

We define **6 main gear tiers** for Mortal progression:

- **T0 – Scavenged / Makeshift**  
  - Starter weapons, shipwreck tools, cobbled armor.
  - Very low stats, often negative traits.

- **T1 – Settler / Local Craft**  
  - Port Meridian + early Yellow-zone crafted gear.
  - Good enough for early Contracts, low-risk zones.

- **T2 – Frontier / Militia**  
  - Yellow zone campaigns, early Stronghold skirmishes, Public Dungeons.
  - Entry-level for organized group play.

- **T3 – Veteran / Warforged**  
  - High Yellow + low Red zones, Major Rifts, advanced Strongholds.
  - Primary mid-to-late game “workhorse” gear.

- **T4 – Relic / Named Sets**  
  - Raids, Warfront victories, advanced crafting projects.
  - Strong synergies, powerful but still within caps.

- **T5 – Crown-Touched / Legendary**  
  - Crown Citadel, high-end Extraction rewards, world bosses.
  - Very limited availability, highly distinct visuals and Runes.

Each tier can be applied to:

- Weapons (1H, 2H, ranged),
- Armor (Light/Medium/Heavy per armor_weight_system),
- Accessories (rings, amulets, trinkets).

---

## 3. Stat Budgets & Caps

### 3.1 Attribute Context

Global rules:

- **Single Attribute Cap:** 150 (Str, Agi, Sta, Int, Spi).  
- **Total Attribute Cap:** 400 (sum of all attributes from base + gear).  
- Derived stats (Health, Crit, Mana) are computed from attributes.

### 3.2 Target Gear Contribution

Baseline assumption (tunable):

- For a maxed-out character, **~60–70% of their attributes come from gear**,
- Remaining from:
  - Backgrounds,
  - Skill perks,
  - Minor permanent bonuses.

Example target for fully geared T3–T4 character:

- Total attribute from gear ≈ 240–280 points total,  
- Remaining 120–160 from:
  - Base stats,
  - Mastery trees,
  - Background / titles.

### 3.3 Per-Tier Gear Budget

We define a **per-slot budget** multiplier by tier:

| Tier | Relative Power | Total Gear Attribute Budget (full set, all slots) |
|------|----------------|---------------------------------------------------|
| T0   | 0.2x           | ~60 total attributes                              |
| T1   | 0.4x           | ~120 total                                       |
| T2   | 0.7x           | ~180–200 total                                   |
| T3   | 1.0x           | ~240–260 total                                   |
| T4   | 1.2x           | ~280–300 total (pushing toward cap)              |
| T5   | 1.4x           | ~320–340 total, but gated & rare                 |

These budgets should be tuned with real numbers in templates, but **relative multipliers** are key.

### 3.4 Slot Weighting

We distribute the budget per slot (for a full 14-slot setup):

- Weapon (mainhand or 2H): 18–22%  
- Off-hand / shield / quiver: 8–10%  
- Chest: 12–14%  
- Legs: 10–12%  
- Helm: 8–10%  
- Shoulders: 6–8%  
- Gloves: 5–7%  
- Boots: 5–7%  
- Belt: 4–6%  
- Bracers: 3–5%  
- Rings (2): 3–4% each  
- Neck: 4–6%  
- Trinkets (2): 4–5% each (often more utility than raw stats)

Example (T3 full set, 250 points total):

- Weapon (2H): ~50  
- Chest: ~32  
- Legs: ~28  
- Helm: ~24  
- Shoulders: ~18  
- Gloves/Boots/Belt/Bracers: ~12–16 each  
- Accessories: 8–12 each

---

## 4. Armor Types & Weight System Hooks

Integrate with `armor_weight_system.lua` and `encumbrance_logic.lua`:

- **Light Armor:**  
  - Lower armor value, bonus to Agi/Int, lower weight, better Brace/stamina regen.
- **Medium Armor:**  
  - Balanced armor/weight, moderate penalties, flexible stat layouts.
- **Heavy Armor:**  
  - High armor value, more Sta/Str, high weight, larger encumbrance penalties.

Gear tier interacts with weight via:

- T0/T1:
  - Often less efficient: too heavy for their stats, or brittle (higher decay).  
- T2/T3:
  - “Optimal” civilian/militia gear.  
- T4/T5:
  - High stat density **but** may have:
    - Extra decay on death,  
    - Stronger repair penalties,  
    - Special weaknesses (e.g., shock vulnerability).

---

## 5. Visual Sourcing (WoW 3.3.5a Models)

### 5.1 Model Mapping

We use **original 3.3.5a model IDs** (display IDs) for aesthetics:

- **PvE Raid Sets (Tier 7–10)**:
  - Reused as Mortal **T3–T5** gear visuals (re-themed flavor text).
- **PvP Gladiator Sets:**
  - Used for **Warfront / Stronghold rewards**,
  - Slightly different stat distribution leaning toward PvP (mitigation, crowd-control resist).

### 5.2 Implementation Approach

- Add a `mortal_tier` field via auxiliary table or item_custom table:

```sql
CREATE TABLE mortal_item_meta (
    item_entry INT PRIMARY KEY,
    mortal_tier TINYINT NOT NULL DEFAULT 0,   -- 0-5
    mortal_role_mask INT NOT NULL DEFAULT 0   -- bitmask for recommended roles/styles
);
```

- `mortal_role_mask` examples:
  - 1 = Melee Bruiser,  
  - 2 = Agile Duelist,  
  - 4 = Arcanist,  
  - 8 = Support/Healer,  
  - 16 = Ranger/Marksman, etc.

This allows recommendation and filtering in UI (MortalUI, Atlas).

---

## 6. Rune (Ashes) System

### 6.1 Core Concept

- **Runes are ability containers**:
  - Attaching a Rune to an item **grants a spell/skill**.
- A character’s “build” is primarily:
  - Their **attributes**,  
  - The **Runes** they’ve socketed into items,  
  - And their **Mastery Tree** (Warlord/Guardian/Explorer).

Losing a weapon/armor piece with a Rune → often lose that ability.

### 6.2 Rune Types

Define categories (bitmask/enum):

1. **Combat Runes**  
   - Direct damage abilities, execute attacks, special shots.
2. **Control Runes**  
   - Stuns, roots, slows, pulls, displacement.
3. **Guard / Brace Runes**  
   - Enhance Brace, parries, Guard Counters.
4. **Support / Healing Runes**  
   - Heals, shields, buffs, totem-like effects.
5. **Mobility Runes**  
   - Dashes, blinks, leaps, disengages.
6. **Utility / Economy Runes**  
   - Prospecting, tracking, improved gathering, slight contract bonuses.

### 6.3 Rune Slots

- **Weapons:**
  - 1–2 Rune slots by default (2H might have 2, 1H = 1).  
- **Armor:**
  - 0–1 Rune slots per major piece (helm, chest, legs, boots).  
- **Accessories:**
  - Rare: 1 specialized Rune slot (e.g., support/utility only).

Rune slots can be implemented via:

- Enchant slots (repurposed),
- Gem socket system,
- Or a new `mortal_rune_slots` table.

Example:

```sql
CREATE TABLE mortal_rune_slots (
    item_entry INT PRIMARY KEY,
    weapon_slots TINYINT NOT NULL DEFAULT 0,
    armor_slots TINYINT NOT NULL DEFAULT 0,
    accessory_slots TINYINT NOT NULL DEFAULT 0
);
```

### 6.4 Rune Definitions

```sql
CREATE TABLE mortal_rune_def (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rune_key VARCHAR(64) UNIQUE NOT NULL,         -- 'RUNE_WHIRLWIND', 'RUNE_BRACE_SHIELD'
    item_entry INT NOT NULL,                      -- the rune as an item
    category TINYINT NOT NULL,                    -- combat/control/guard/support/etc
    spell_id INT NOT NULL,                        -- spell granted when socketed
    allowed_slot_mask INT NOT NULL,               -- bitmask: weapon/armor/accessory
    max_rank TINYINT NOT NULL DEFAULT 1,          -- rune ranks for tuning
    is_consumable TINYINT NOT NULL DEFAULT 0      -- consumed on socket if 1
);
```

### 6.5 Attaching & Removing Runes

- **Attaching:**
  - Player uses Rune item on gear piece.  
  - Checks:
    - Item has free Rune slot,
    - Rune allowed on that slot type,
    - Player meets Rune requirements (if any, e.g., minimum stats or skill).  
  - On success:
    - Link `rune_def` to item instance in, e.g., `mortal_item_runes`:

```sql
CREATE TABLE mortal_item_runes (
    item_guid BIGINT NOT NULL,
    rune_id INT NOT NULL,
    slot_index TINYINT NOT NULL,
    PRIMARY KEY (item_guid, slot_index)
);
```

    - Apply passive aura or ability to the owning character.

- **Removing:**
  - Two options (configurable):
    - **Soft detach**:
      - Rune is removed and returned as item (with cost).  
    - **Hard imprint**:
      - Rune is destroyed when removed, supporting economic sinks.

### 6.6 Runes & Death / Loot

- Runes are bound to **items**, not the player.
- When item is:
  - Looted (full-loot PvP): new owner gains Rune abilities.
  - Destroyed:
    - Optionally:
      - Rune is destroyed too,
      - Or drops as separate “Damaged Rune” relic for salvage.

This creates:

- Strong incentive to protect Rune-bearing weapons,
- Natural demand for crafting & salvaging Runecraft.

---

## 7. Acquisition Sources

### 7.1 Gear

- **T0:**  
  - Starter quests, Shipwreck Cove, makeshift crafting.

- **T1:**
  - Early mainland quests, Port Meridian vendors, basic crafting.

- **T2:**
  - Yellow-zone Contracts, early dungeons, Greycrag crafting, public delves.

- **T3:**
  - Public/delved dungeons, advanced Contracts, Stronghold contracts, Warfront participation.

- **T4:**
  - Raids (non-final wings), advanced Stronghold sieges, many-currency crafting projects.

- **T5:**
  - Crown Citadel, Extraction, high-end world bosses, seasonal end rewards.

### 7.2 Runes

- **Combat / Control:**
  - Drop from:
    - Dungeon & raid bosses (thematically appropriate),
    - PvP-focused Stronghold/Warfront content.

- **Guard / Brace Runes:**
  - Shrine Trials, Vigil events, tank-oriented bosses.

- **Support / Healing Runes:**
  - Shrine & support-centric encounters, some world events.

- **Mobility Runes:**
  - Hellgates, rift anomalies, specific bosses known for movement phases.

- **Utility / Economy Runes:**
  - Iron Ledger & Cartel Contracts, high reputation vendors.

---

## 8. Example Rune Designs (Conceptual)

1. **Rune of Mortal Strike (Combat)**  
   - Category: Combat  
   - Type: Weapon-only  
   - Effect: Grants `Mortal Strike` active ability:
     - High damage, applies short **Healing Reduction** debuff.

2. **Rune of Brace Shield (Guard)**  
   - Category: Guard  
   - Weapon or Shield slot.  
   - Effect: When you **Brace** within 0.5s of being hit:
     - Gain a 1.5s damage shield equal to X% of your Sta.

3. **Rune of Blinkstep (Mobility)**  
   - Category: Mobility  
   - Weapon or Boots.  
   - Effect: Short-range targeted blink with small cooldown.

4. **Rune of Field Ministry (Support)**  
   - Category: Support  
   - Armor or Accessory.  
   - Effect: Small AoE heal around you when you kill an enemy (internal cooldown).

5. **Rune of Cartel Ledger (Utility/Economy)**  
   - Category: Utility  
   - Accessory only.  
   - Effect: +1–3% increased gold from Contracts and Caravan payouts (small but meaningful).

---

## 9. Implementation Checklist

1. **DB:**
   - Add `mortal_item_meta`, `mortal_rune_def`, `mortal_item_runes`, `mortal_rune_slots`.  

2. **Item Template:**
   - Tag core Mortal gear with `mortal_tier` + `role_mask`.  
   - Configure Rune items with category, allowed slots, spells.

3. **C++ Core Hooks:**
   - On item equip/unequip:
     - Apply/remove Rune spells & auras.  
   - On item use:
     - Attach Rune to item if target is socketable.  
   - Integrate with encumbrance & armor weight systems.

4. **Loot & Drops:**
   - Update loot tables:
     - Dungeons → T2/T3 gear + lower-tier Runes,  
     - Raids → T3–T5 gear + higher-tier Runes,  
     - Strongholds/Warfronts → PvP-tuned gear & Runes.

5. **UI:**
   - MortalUI:
     - Display gear Mortal Tier, Rune slots, and attached Runes,  
     - Provide simple Rune socketing UI panel.  
   - Atlas:
     - Show generic drop distribution: where to find certain Rune categories/tier gear.

---

This system ensures that:

- Gear **progression respects your hard caps and sandbox economy**,  
- Builds are **item + Rune-driven**, not rigid “classes”,  
- And equipment loss is emotionally and mechanically meaningful without overcomplicating the stat math.  
