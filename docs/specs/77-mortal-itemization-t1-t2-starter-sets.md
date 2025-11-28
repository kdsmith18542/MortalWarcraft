# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.1 — Itemization Detail  
### File: 77-mortal-itemization-t1-t2-starter-sets.md  
### Section: Concrete T1/T2 Gear & Rune Examples

---

## 1. Scope

This file takes the **abstract Mortal gear & rune model** and turns it into **concrete examples** your team can implement:

- Two **starter archetypes**:
  - **“Frontier Bruiser”** – melee-focused, medium/heavy armor.
  - **“Waywatcher Arcanist”** – hybrid caster/ranged, light/medium armor.
- Each with:
  - A **T1 Settler set** (early mainland progression),
  - A **T2 Frontier set** (ready for Yellow zones & early delves),
  - Example **Rune loadouts** that match the gear.
- Example **stat layouts** and **DB stubs** aligned with:
  - Attribute caps (150 per stat, 400 total),
  - Gear budgets from `75-mortal-gear-and-runes-spec.md`,
  - Full-loot + Rune-on-gear behavior.

These are **patterns**: you can clone/modify them to fill out full item tables later.

---

## Related Specs

For full context on itemization starter sets, see:

- **`75-mortal-gear-and-runes-spec.md`** — Core gear and rune system that these sets implement
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas and attribute caps used in these sets
- **`19-itemization.md`** — Overall itemization philosophy and tier structure
- **`78-mortal-itemization-healer-ranger-mage.md`** — Specialized itemization for other archetypes
- **`79-drop-mapping-t1-t2-gear-and-runes.md`** — Drop tables and loot sources for these sets
- **`03-risk-zones.md`** — Risk zones where these sets are appropriate
- **`01-progression.md`** — Progression system that determines when players use these sets

---

## 2. Shared Assumptions

- Character dynamic level is derived from **skills**, not XP.
- At the stage where players are using:
  - T1 sets: they’re roughly “Level 2–4” via skills.  
  - T2 sets: they’re roughly “Level 4–8” and beginning Yellow zone content.
- Attribute contribution targets (from 75-spec):
  - T1 full set ≈ **120 attribute points** total.
  - T2 full set ≈ **180–200 attribute points** total.
- The examples below assume **8 main slots** for simplicity:
  - Weapon, Helm, Chest, Legs, Gloves, Boots, Ring, Necklace.  
  - In reality you will distribute across all 14 slots; these just show ratios.

Derived stats reminder:

- Health: `50 + (Stamina * 10)`.
- Crit Chance: `(Agility / 20)%`.
- Mana: `100 + (Intellect * 10)`.

---

## 3. Archetype A — “Frontier Bruiser”

Role:  
- Frontline melee / skirmisher.  
- Emphasis on **Str + Sta**, decent **Agi**, minimal Int/Spi.  
- Uses **medium → heavy armor**; designed to work well with Brace & Guard Runes.

### 3.1 T1 Settler Set — “Greycrag Militia”

**Theme:**  
- Early mainland militia equipment distributed by Greycrag or Port Meridian quartermasters.  
- Visually: use recolors of low-level mail/plate sets and simple weapons.

#### 3.1.1 Target Budget (8-piece example)

Total attribute budget for partial set: **~70–80 points** (subset of full ~120).

Proposed distribution:

- Weapon: 16  
- Chest: 12  
- Legs: 10  
- Helm: 8  
- Gloves: 6  
- Boots: 6  
- Ring: 6  
- Necklace: 8  

Total ≈ 72 points.

#### 3.1.2 Per-Item Stat Layout (Conceptual)

**Weapon – “Greycrag Militia Blade” (T1, 1H sword)**  
- +8 Strength  
- +4 Stamina  
- +4 Agility  
- Armor Weight: Medium weapon (normal).

**Helm – “Militia Iron Coif”**  
- +4 Strength  
- +2 Stamina  
- +2 Agility  

**Chest – “Militia Chain Hauberk”**  
- +6 Strength  
- +4 Stamina  
- +2 Agility  

**Legs – “Militia Chain Leggings”**  
- +5 Strength  
- +3 Stamina  
- +2 Agility  

**Gloves – “Militia Grips”**  
- +3 Strength  
- +2 Stamina  
- +1 Agility  

**Boots – “Militia Marching Boots”**  
- +3 Strength  
- +2 Stamina  
- +1 Agility  

**Ring – “Iron-Signed Band”**  
- +2 Strength  
- +2 Stamina  
- +2 Agility  

**Necklace – “Greycrag Oath Pendant”**  
- +4 Strength  
- +2 Stamina  
- +2 Agility  

If a player wears the **full 8-piece mini-set**:

- Str ≈ +36  
- Sta ≈ +21  
- Agi ≈ +15  

This is a **low-but-meaningful bump** for early mainland, far from hitting caps.

#### 3.1.3 Example Runes for T1 Bruiser

T1 should give **simple, low-skill-floor abilities**:

1. **Rune of Cleaving Strike (Combat)**  
   - Category: Combat  
   - Slot: Weapon-only  
   - Effect: Small frontal cone attack, low cooldown.

2. **Rune of Guarded Brace (Guard)**  
   - Category: Guard  
   - Slot: Weapon or Shield  
   - Effect: When you successfully Brace, gain +X armor for 3 seconds.

3. **Rune of Militia Rally (Support)**  
   - Category: Support  
   - Slot: Necklace  
   - Effect: Short, small-radius shout granting minor Sta buff for 10s.

Attach pattern:

- Militia Blade: 1 Rune slot (weapon).  
- Necklace: 1 Rune slot (accessory, utility/support).  
- Other pieces: no Rune slots at T1 for this set.

---

### 3.2 T2 Frontier Set — “Linebreaker Vanguard”

**Theme:**  
- First “real” frontier war-gear, crafted from proper regional materials.  
- Visually: reuse early raid or upper-dungeon plate/mail models recolored.

#### 3.2.1 Target Budget (8-piece example)

Total attribute budget for partial set: **~110–120 points** (subset of full ~180–200).

Suggested:

- Weapon (2H axe for this variant): 26  
- Chest: 18  
- Legs: 16  
- Helm: 12  
- Gloves: 10  
- Boots: 10  
- Ring: 8  
- Necklace: 8  

Total ≈ 108 points.

#### 3.2.2 Per-Item Stat Layout

**Weapon – “Linebreaker War-Axe” (T2, 2H)**  
- +16 Strength  
- +6 Stamina  
- +4 Agility  

**Helm – “Linebreaker War-Visor”**  
- +6 Strength  
- +4 Stamina  
- +2 Agility  

**Chest – “Linebreaker Bulwark Cuirass”**  
- +10 Strength  
- +6 Stamina  
- +2 Agility  

**Legs – “Linebreaker March Greaves”**  
- +8 Strength  
- +6 Stamina  
- +2 Agility  

**Gloves – “Linebreaker Crusher Gauntlets”**  
- +5 Strength  
- +3 Stamina  
- +2 Agility  

**Boots – “Linebreaker Tread Boots”**  
- +5 Strength  
- +3 Stamina  
- +2 Agility  

**Ring – “Vanguard Signet”**  
- +4 Strength  
- +2 Stamina  
- +2 Agility  

**Necklace – “Vanguard Iron Torque”**  
- +4 Strength  
- +4 Stamina  

Full 8-piece mini-set:

- Str ≈ +58  
- Sta ≈ +34  
- Agi ≈ +16  

This is now **solid frontline gear** for Yellow zones but still far from the 150 per-stat cap.

#### 3.2.3 T2 Bruiser Rune Loadout

We step up complexity while staying accessible:

1. **Rune of Mortal Strike (Combat)**  
   - Weapon-only Rune.  
   - Grants a heavy single-target attack that applies healing reduction debuff.

2. **Rune of Brace Counter (Guard)**  
   - Weapon or Chest.  
   - When you Brace within X seconds of being hit:
     - Next melee swing is +Y% damage or guaranteed crit vs normal enemies.

3. **Rune of Iron Advance (Mobility/Guard)**  
   - Boots-only Rune.  
   - Short-range forward lunge that also grants a brief armor buff on landing.

Proposed slotting:

- Linebreaker War-Axe: 2 Rune slots (Combat + Guard).  
- Boots: 1 Rune slot (Mobility).  
- Optional: Chest or Helm with 1 Guard/Support slot for advanced patterns.

---

## 4. Archetype B — “Waywatcher Arcanist”

Role:  
- Hybrid caster/ranged scout.  
- Emphasis on **Int + Agi + Spi**, moderate Sta, low Str.  
- Uses **light / medium armor**; built to kite, reposition, and weave spells.

### 4.1 T1 Settler Set — “Port Meridian Adept”

**Theme:**  
- Early “Academy” gear provided by Port Meridian mentors.  
- Visually: reuse cloth/leather scholar sets with muted dyes.

#### 4.1.1 Target Budget (8-piece example)

Again aim for **~70–80 points**.

Distribution:

- Weapon (staff): 18  
- Chest: 12  
- Legs: 10  
- Helm: 8  
- Gloves: 6  
- Boots: 6  
- Ring: 6  
- Necklace: 8  

Total ≈ 74 points.

#### 4.1.2 Per-Item Stat Layout

**Weapon – “Adept’s Cedar Staff”**  
- +8 Intellect  
- +4 Spirit  
- +4 Stamina  
- +2 Agility  

**Helm – “Adept’s Hood”**  
- +4 Intellect  
- +2 Spirit  
- +2 Stamina  

**Chest – “Adept’s Vestments”**  
- +6 Intellect  
- +2 Spirit  
- +2 Stamina  
- +2 Agility  

**Legs – “Adept’s Trousers”**  
- +4 Intellect  
- +2 Spirit  
- +2 Stamina  
- +2 Agility  

**Gloves – “Adept’s Grips”**  
- +3 Intellect  
- +1 Spirit  
- +2 Stamina  

**Boots – “Adept’s Sandals”**  
- +3 Intellect  
- +1 Spirit  
- +2 Stamina  

**Ring – “Cedar-Focused Band”**  
- +3 Intellect  
- +1 Spirit  
- +2 Stamina  

**Necklace – “Port Meridian Focus Charm”**  
- +4 Intellect  
- +2 Spirit  
- +2 Stamina  

Full 8-piece mini-set:

- Int ≈ +35  
- Spi ≈ +15  
- Sta ≈ +18  
- Agi ≈ +4  

Enough to make spells feel better than naked, but clearly early-game.

#### 4.1.3 T1 Arcanist Rune Loadout

1. **Rune of Arcane Bolt (Combat)**  
   - Weapon-only.  
   - Simple ranged nuke on short cooldown, low mana cost.

2. **Rune of Ether Step (Mobility)**  
   - Boots.  
   - Small backwards hop or side-step.

3. **Rune of Focusing Chant (Support)**  
   - Necklace.  
   - Short self-buff: minor Intellect increase for X seconds, moderate cooldown.

Slotting:

- Staff: 1 Rune slot.  
- Boots: 1 Rune slot.  
- Necklace: 1 Rune slot.

---

### 4.2 T2 Frontier Set — “Waywatcher’s Pact”

**Theme:**  
- Gear awarded/earned through early Frontier scouting, Ranger faction contracts, and Rifts.  
- Visually: leather/cloth ranger-mage hybrid sets (greens and muted blues).

#### 4.2.1 Target Budget (8-piece example)

Aim for **~110–120 points** again.

Distribution:

- Weapon (staff or wand+offhand; here we use staff): 22  
- Chest: 18  
- Legs: 16  
- Helm: 12  
- Gloves: 10  
- Boots: 10  
- Ring: 8  
- Necklace: 8  

Total ≈ 104 points (tweakable upward by 5–10).

#### 4.2.2 Per-Item Stat Layout

**Weapon – “Waywatcher’s Oaken Staff”**  
- +12 Intellect  
- +6 Spirit  
- +4 Stamina  

**Helm – “Waywatcher’s Hood”**  
- +6 Intellect  
- +3 Spirit  
- +3 Stamina  

**Chest – “Waywatcher’s Mantlecoat”**  
- +8 Intellect  
- +4 Spirit  
- +4 Stamina  
- +2 Agility  

**Legs – “Waywatcher’s Treadpants”**  
- +7 Intellect  
- +3 Spirit  
- +4 Stamina  
- +2 Agility  

**Gloves – “Waywatcher’s Grasp”**  
- +4 Intellect  
- +2 Spirit  
- +3 Stamina  

**Boots – “Waywatcher’s Boots”**  
- +4 Intellect  
- +2 Spirit  
- +3 Stamina  

**Ring – “Pact Binder’s Loop”**  
- +4 Intellect  
- +2 Spirit  
- +2 Stamina  

**Necklace – “Frontier Pact Charm”**  
- +5 Intellect  
- +3 Spirit  

Full 8-piece mini-set:

- Int ≈ +50  
- Spi ≈ +25  
- Sta ≈ +23  
- Agi ≈ +4  

Very solid caster stats, still well under caps and leaving room for future T3–T5.

#### 4.2.3 T2 Arcanist Rune Loadout

1. **Rune of Starfall Volley (Combat)**  
   - Weapon-only.  
   - Small ground-targeted AoE, moderate cooldown.

2. **Rune of Aether Shield (Guard/Support)**  
   - Chest or Helm.  
   - When you Brace, also gain a small absorb shield that scales with Int.

3. **Rune of Windbound Step (Mobility)**  
   - Boots.  
   - Short blink/dash with slight movement speed buff for 2–3 seconds.

4. **Rune of Insightful Pact (Utility/Economy)**  
   - Ring or Necklace.  
   - Small chance to refund some mana or increase Rune fragment drops on spell kills (tunable).

Slotting:

- Staff: 2 Rune slots (Combat + Guard/Support).  
- Boots: 1 Rune slot (Mobility).  
- Ring or Necklace: 1 Rune slot (Utility).

---

## 5. Example DB Stubs (Item Template & Meta)

> These are **illustrative** and may need adjustments to match your exact AzerothCore schema.

### 5.1 Item Template Example (Linebreaker War-Axe)

```sql
-- Base item
INSERT INTO item_template (
    entry, name, class, subclass, Quality, InventoryType,
    Displayid, sheath, bonding, MaxCount, stackable,
    stat_type1, stat_value1,
    stat_type2, stat_value2,
    stat_type3, stat_value3
    -- ... other fields omitted
) VALUES (
    900001, 'Linebreaker War-Axe', 2, 1, 3, 17,
    30001, 1, 1, 1, 1,
    4, 16,    -- Strength
    7, 6,     -- Stamina
    3, 4      -- Agility
);
```

```sql
-- Mortal metadata
INSERT INTO mortal_item_meta (item_entry, mortal_tier, mortal_role_mask)
VALUES (900001, 2, 1); -- Tier 2, Bruiser/Frontline mask
```

```sql
-- Rune slots (2 weapon slots)
INSERT INTO mortal_rune_slots (item_entry, weapon_slots, armor_slots, accessory_slots)
VALUES (900001, 2, 0, 0);
```

### 5.2 Rune Definition Example (Rune of Mortal Strike)

```sql
INSERT INTO mortal_rune_def (
    rune_key, item_entry, category, spell_id,
    allowed_slot_mask, max_rank, is_consumable
) VALUES (
    'RUNE_MORTAL_STRIKE',
    910001,       -- rune item entry
    1,            -- Combat
    50001,        -- custom spell id for Mortal Strike-style ability
    1,            -- weapon-only bitmask
    1,
    1             -- consumed on socket
);
```

---

## 6. How to Expand This Pattern

1. **Clone archetypes**:  
   - Create additional archetypes (Ranger, Dedicated Healer, Assassin, Heavy Guardian) using same budgeting logic.

2. **Fill T1/T2 catalog**:  
   - For each archetype:
     - 1–2 T1 sets (different visual themes),
     - 1–2 T2 sets,  
     - A small curated list of starter Runes.

3. **Link to content sources**:  
   - Decide:
     - Which **dungeons / Contracts / Strongholds** drop which tier & archetype.  
   - Keep **overlap** so there are choices, not strict locks.

4. **Iterate tuning**:  
   - After implementation:
     - Log average stats of active players in each band,
     - Ensure progression from T1→T2→T3 feels:
       - Noticeable,
       - But not hard-gated.

---

These T1/T2 examples give your team concrete **numbers, item entries, and rune setups** so Cursor can start churning out real SQL + script stubs without guessing how to fit into your caps, Rune system, and sandbox philosophy.  
