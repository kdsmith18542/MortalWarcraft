# Project Canvas: Mortal Warcraft Overhaul  
### Version 37.0 — Core Systems  
### File: 84-mortal-core-stats-and-combat-model.md  
### Topic: Primary Attributes, Derived Stats & Combat Model (C++-First)

> **Note:** This document codifies the **final direction** for Mortal's stats and combat model.  
> It is written with a **C++-first** implementation bias (AzerothCore modules), with Lua reserved for light glue / prototyping.

---

## Related Specs

This document defines the core stat and combat formulas. For full context, see:

- **`02-combat.md`** — Combat mechanics, PvP rules, crime system, and Brace mechanic that use these stat formulas
- **`01-progression.md`** — Attribute caps, derived level system, and skill system that interact with these stats
- **`03-risk-zones.md`** — Zone-based PvP rules and loot mechanics that affect combat outcomes
- **`75-mortal-gear-and-runes-spec.md`** — How stats interact with gear, runes, and sockets
- **`19-itemization.md`** — Item stat rules and how primary attributes appear on items
- **`53-rune-augments-and-gear-build-system.md`** — Rune system that modifies derived stats
- **`11-pvp-systems.md`** — PvP-specific rules and mechanics that use these combat formulas

---

## 1. Goals

We want a stat and combat model that:

1. **Reuses WoW’s primary attributes** for maximum compatibility:
   - Strength, Agility, Stamina, Intellect, Spirit.

2. **Removes WotLK “rating soup”** from player-facing itemization:
   - No more defense rating, resilience rating, hit rating, crit rating, haste rating, expertise rating, etc. as item lines.

3. **Ties power to readable values** and hard caps:
   - Per-attribute cap = **150**.
   - Total attribute (“Genetic”) cap = **400**.

4. **Keeps PvE and PvP unified**:
   - No PvP-only defensive stats (resilience).  
   - Gear works across PvE/PvP; “builds” and **skills/runes** create specialization, not separate item lines.

5. **Pushes complexity into skills & runes**, not base stats:
   - Weapon/Armor Mastery, Material Lore, Ether Attunement, Notoriety, etc.
   - Class fantasy delivered by **Rune + Skill combos**, not 14 different ratings.

Implementation priority: **C++ mods for core logic**, **Lua for scripting content + glue**.

---

## 2. Primary Attributes (Core Stats)

We **keep** the original 5 attributes, but reinterpret them for Mortal:

- **Strength (STR)**
  - Increases melee Attack Power.
  - Increases carrying capacity / encumbrance tolerance.
  - Slight bonus to stagger/knockback resistance (optional).

- **Agility (AGI)**
  - Increases melee/ranged accuracy and crit chance.
  - Slight bonus to dodge / reaction-based mitigation.

- **Stamina (STA)**
  - Increases maximum Health.
  - Slight bonus to bleed/DoT resistance (optional).

- **Intellect (INT)**
  - Increases maximum Mana and Spell Power.
  - Slight bonus to spell crit and Rune effectiveness.

- **Spirit (SPI)**
  - Increases mana regeneration out of combat.
  - Interfaces with Shrine blessings, Ether corruption checks, and some healing formulas.

### 2.1 Mortal Attribute Caps

Enforced in **C++** via a central module (e.g. `MortalLevel.cpp`):

- **Per-Attribute Hard Cap**
  - `STR, AGI, STA, INT, SPI <= 150`.

- **Total “Genetic” Stat Cap**
  - `STR + AGI + STA + INT + SPI <= 400`.

Clamping logic:

```cpp
// Pseudocode for central enforcement
void MortalStats::ClampBaseAttributes(Player* player)
{
    int str = player->GetStat(STAT_STRENGTH);
    int agi = player->GetStat(STAT_AGILITY);
    int sta = player->GetStat(STAT_STAMINA);
    int inte = player->GetStat(STAT_INTELLECT);
    int spi = player->GetStat(STAT_SPIRIT);

    int cappedStr  = std::min(str, 150);
    int cappedAgi  = std::min(agi, 150);
    int cappedSta  = std::min(sta, 150);
    int cappedInt  = std::min(inte, 150);
    int cappedSpi  = std::min(spi, 150);

    int total = cappedStr + cappedAgi + cappedSta + cappedInt + cappedSpi;
    if (total > 400)
    {
        // Apply proportional normalization algorithm (see Attribute Overflow Normalization below)
    }

    // Apply final values back to player
}
```

### 2.2.1 Attribute Overflow Normalization Algorithm

When total attributes exceed 400, attributes are normalized proportionally to maintain relative ratios while bringing the total to exactly 400.

**Algorithm:**
```
1. Calculate total: total = str + agi + sta + inte + spi
2. If total <= 400: No normalization needed, return
3. Calculate scale factor: scaleFactor = 400.0 / total
4. Apply proportional reduction to each stat:
   - normalizedStr = round(str * scaleFactor)
   - normalizedAgi = round(agi * scaleFactor)
   - normalizedSta = round(sta * scaleFactor)
   - normalizedInt = round(inte * scaleFactor)
   - normalizedSpi = round(spi * scaleFactor)
5. Recalculate total: newTotal = sum of normalized stats
6. If newTotal != 400 due to rounding:
   - Calculate difference: diff = 400 - newTotal
   - Adjust highest stat(s) by difference to reach exactly 400
```

**Example 1: Simple Proportional Reduction**
```
Initial Stats:
  STR = 100
  AGI = 100
  STA = 100
  INT = 100
  SPI = 50
  Total = 450

Scale Factor = 400 / 450 = 0.8889

Normalized:
  STR = round(100 * 0.8889) = 89
  AGI = round(100 * 0.8889) = 89
  STA = round(100 * 0.8889) = 89
  INT = round(100 * 0.8889) = 89
  SPI = round(50 * 0.8889) = 44
  New Total = 400 ✓
```

**Example 2: With Rounding Adjustment**
```
Initial Stats:
  STR = 120
  AGI = 110
  STA = 100
  INT = 90
  SPI = 85
  Total = 505

Scale Factor = 400 / 505 = 0.7921

Normalized:
  STR = round(120 * 0.7921) = 95
  AGI = round(110 * 0.7921) = 87
  STA = round(100 * 0.7921) = 79
  INT = round(90 * 0.7921) = 71
  SPI = round(85 * 0.7921) = 67
  New Total = 399 (1 point short)

Adjustment: Add 1 to highest stat (STR)
  STR = 96
  Final Total = 400 ✓
```

**Example 3: Extreme Overflow**
```
Initial Stats:
  STR = 150 (capped)
  AGI = 150 (capped)
  STA = 150 (capped)
  INT = 50
  SPI = 50
  Total = 550

Scale Factor = 400 / 550 = 0.7273

Normalized:
  STR = round(150 * 0.7273) = 109
  AGI = round(150 * 0.7273) = 109
  STA = round(150 * 0.7273) = 109
  INT = round(50 * 0.7273) = 36
  SPI = round(50 * 0.7273) = 36
  New Total = 399

Adjustment: Add 1 to highest stat (STR, AGI, STA tied - add to STR)
  STR = 110
  Final Total = 400 ✓
```

### 2.2.2 Design Rationale

**Proportional Reduction:**
- Maintains relative stat distribution
- Fair to all builds (no stat priority bias)
- Preserves player investment choices

**Rounding Adjustment:**
- Ensures exact 400 total (no floating point errors)
- Adjusts highest stat(s) to account for rounding
- Maintains fairness (smallest possible adjustment)

**Why Not Priority-Based Clamping:**
- Priority-based would favor certain stats
- Could create meta-gaming around stat order
- Proportional is more intuitive and fair

> This clamp should be applied in a single, well-defined pipeline (e.g. after recalculating stats from gear and buffs).

### 2.2.3 Stat Calculation Pipeline Specification

Stat calculation follows a strict order of operations to ensure consistent results:

**Pipeline Order:**
```
1. Base Attributes (Player Distribution)
   ↓
2. Gear Modifiers (Equipment bonuses)
   ↓
3. Rune Modifiers (Socketed runes)
   ↓
4. Buff/Aura Modifiers (Temporary effects)
   ↓
5. Individual Stat Clamping (Max 150 per stat)
   ↓
6. Total Attribute Clamping (Max 400 total, with overflow normalization)
   ↓
7. Derived Stats Calculation (AP, SP, HP, Mana, etc.)
```

**Detailed Pipeline Steps:**

**Step 1: Base Attributes**
- Player's manually distributed attribute points
- Stored in `mortal_character_attributes` table
- No modifications applied yet

**Step 2: Gear Modifiers**
- Add/subtract attributes from equipped items
- Process all equipment slots (weapon, armor, accessories)
- Sum all gear bonuses per stat

**Step 3: Rune Modifiers**
- Add attributes from socketed runes
- Process all rune sockets in equipped gear
- Sum all rune bonuses per stat

**Step 4: Buff/Aura Modifiers**
- Add/subtract attributes from active buffs/auras
- Process all active auras on the player
- Sum all buff bonuses per stat (can be negative for debuffs)

**Step 5: Individual Stat Clamping**
```
For each stat (STR, AGI, STA, INT, SPI):
    FinalStat = min(150, BaseStat + GearBonus + RuneBonus + BuffBonus)
```

**Step 6: Total Attribute Clamping**
```
Total = Sum of all FinalStats
If Total > 400:
    Apply Attribute Overflow Normalization Algorithm
```

**Step 7: Derived Stats Calculation**
- Calculate AP, SP, HP, Mana using final clamped attributes
- Use formulas from sections 3.1 and 3.2
- These derived stats are used in combat calculations

### 2.2.4 Pipeline Example

**Example: Complete Stat Calculation**
```
Step 1: Base Attributes
  STR = 80, AGI = 60, STA = 100, INT = 50, SPI = 40
  Total = 330

Step 2: Gear Modifiers
  +20 STR (from weapon)
  +15 AGI (from boots)
  +30 STA (from chest)
  +10 INT (from helm)
  +5 SPI (from ring)
  
  STR = 80 + 20 = 100
  AGI = 60 + 15 = 75
  STA = 100 + 30 = 130
  INT = 50 + 10 = 60
  SPI = 40 + 5 = 45
  Total = 410

Step 3: Rune Modifiers
  +10 STR (from rune)
  +5 AGI (from rune)
  
  STR = 100 + 10 = 110
  AGI = 75 + 5 = 80
  Total = 420

Step 4: Buff Modifiers
  +20 STR (from strength buff)
  -5 STA (from debuff)
  
  STR = 110 + 20 = 130
  STA = 130 - 5 = 125
  Total = 420

Step 5: Individual Stat Clamping
  STR = min(150, 130) = 130
  AGI = min(150, 80) = 80
  STA = min(150, 125) = 125
  INT = min(150, 60) = 60
  SPI = min(150, 45) = 45
  Total = 440

Step 6: Total Attribute Clamping (Overflow Normalization)
  Scale Factor = 400 / 440 = 0.9091
  STR = round(130 * 0.9091) = 118
  AGI = round(80 * 0.9091) = 73
  STA = round(125 * 0.9091) = 114
  INT = round(60 * 0.9091) = 55
  SPI = round(45 * 0.9091) = 41
  New Total = 401 (adjust: -1 from highest stat)
  STR = 117
  Final Total = 400 ✓

Step 7: Derived Stats Calculation
  AP_melee = (2.0 * 117) + (0.5 * 73) + WeaponSkillBonus
  HP = 50 + (114 * 10) = 1190
  Mana = 100 + (55 * 10) = 650
```

### 2.2.5 Pipeline Implementation Notes

**When to Recalculate:**
- On player login
- When equipment changes
- When runes are socketed/removed
- When buffs/auras are applied/removed
- On attribute point distribution

**Performance Considerations:**
- Cache final stats after calculation
- Only recalculate when inputs change
- Batch multiple changes into single recalculation

**Validation:**
- After each step, validate stat ranges
- Log warnings if stats exceed expected ranges
- Ensure total never exceeds 400 after normalization

---

## 3. Derived Stats (Mortal Combat Model)

All “classic” derived combat stats exist as **formulas** based on primary attributes + skills, not as raw ratings on items.

### 3.1 Health, Mana & Resource

**Health**

```text
HP = 50 + (Stamina * 10)
```

- With STA cap 150 → Max HP ≈ 1,550 from STA + baseline.
- Additional HP can come from:
  - Runes,
  - Stronghold auras,
  - Shrine buffs.

**Mana**

```text
Mana = 100 + (Intellect * 10)
```

Or optionally:

```text
Mana = 50 + (Intellect * 8) + (Spirit * 2)
```

**Stamina** and **Mana regen**:

- Regen formulas can be simplified vs vanilla WoW, heavily influenced by SPI.
- Stronger regen while resting or near Shrines, weaker in combat.

### 3.1.1 Mana Regeneration Formula

Mana regeneration is calculated per second and varies based on state (combat, rest, near shrine):

```
ManaRegenPerSecond = (BaseRegen + SpiritBonus + ShrineBonus) * StateModifier
```

**Base Regeneration:**
```
BaseRegen = 2.0 mana per second
```

**Spirit Bonus:**
```
SpiritBonus = Spirit * 0.1
// 1 point of Spirit = 0.1 mana/second
```

**Shrine Bonus:**
```
If NearShrine:
    ShrineBonus = 5.0 mana per second
Else:
    ShrineBonus = 0.0
```

**State Modifier:**
- **Resting (out of combat, not moving)**: 1.5x multiplier
- **Combat**: 0.3x multiplier (70% reduction)
- **Normal (not resting, not in combat)**: 1.0x multiplier

### 3.1.2 Complete Mana Regen Examples

**Example 1: Resting with High Spirit**
```
Spirit = 50
NearShrine = false
State = Resting

BaseRegen = 2.0
SpiritBonus = 50 * 0.1 = 5.0
ShrineBonus = 0.0
StateModifier = 1.5

ManaRegenPerSecond = (2.0 + 5.0 + 0.0) * 1.5 = 10.5 mana/second
```

**Example 2: In Combat with Low Spirit**
```
Spirit = 20
NearShrine = false
State = Combat

BaseRegen = 2.0
SpiritBonus = 20 * 0.1 = 2.0
ShrineBonus = 0.0
StateModifier = 0.3

ManaRegenPerSecond = (2.0 + 2.0 + 0.0) * 0.3 = 1.2 mana/second
```

**Example 3: Near Shrine, Resting**
```
Spirit = 40
NearShrine = true
State = Resting

BaseRegen = 2.0
SpiritBonus = 40 * 0.1 = 4.0
ShrineBonus = 5.0
StateModifier = 1.5

ManaRegenPerSecond = (2.0 + 4.0 + 5.0) * 1.5 = 16.5 mana/second
```

**Example 4: Normal State, High Spirit**
```
Spirit = 100
NearShrine = false
State = Normal

BaseRegen = 2.0
SpiritBonus = 100 * 0.1 = 10.0
ShrineBonus = 0.0
StateModifier = 1.0

ManaRegenPerSecond = (2.0 + 10.0 + 0.0) * 1.0 = 12.0 mana/second
```

### 3.1.3 Design Rationale

**Why Spirit-based?**
- Spirit represents magical attunement and inner balance
- Encourages Spirit investment for spellcasters
- Provides meaningful progression beyond just Intellect

**State Modifiers:**
- **Resting (1.5x)**: Encourages downtime and resource management
- **Combat (0.3x)**: Prevents infinite mana in combat, requires resource management
- **Normal (1.0x)**: Balanced regen for exploration and travel

**Shrine Bonus:**
- Encourages visiting shrines for mana recovery
- Creates strategic locations for spellcasters
- Supports the faction/shrine system

**Regeneration Rates:**
- Base 2.0 mana/sec ensures all players have some regen
- Spirit scaling (0.1 per point) provides meaningful contribution
- At 150 Spirit (max), provides 15 mana/sec base (22.5 resting, 4.5 in combat)
- Shrine bonus (5.0) is significant but requires travel/risk

### 3.2 Attack Power & Spell Power

**Melee Attack Power (AP)**

```text
AP_melee = (2.0 * STR) + (0.5 * AGI) + WeaponSkillBonus
```

**Ranged Attack Power (AP ranged)**

```text
AP_ranged = (2.0 * AGI) + (0.5 * STR) + WeaponSkillBonus
```

**Spell Power (SP)**

```text
SP = (2.0 * INT) + (0.5 * SPI) + MagicSkillBonus
```

Where:

- `WeaponSkillBonus` comes from **weapon mastery skills** (Sword, Axe, Bow, etc.).
- `MagicSkillBonus` comes from **magic school skills** (Fire Lore, Ether Lore, etc.)

### 3.2.1 WeaponSkillBonus Formula

**WeaponSkillBonus** converts weapon mastery skill points to Attack Power bonus:

```
WeaponSkillBonus = WeaponMasterySkill / 5.0
```

Where:
- **WeaponMasterySkill**: Current skill value in the relevant weapon mastery skill (Swords, Axes, Bows, etc.)
- **Scaling**: 1 skill point = 0.2 AP
- **Example**: 100 weapon mastery skill = 20 AP (equivalent to 10 Strength)

**Skill-to-AP Conversion:**
- This scaling ensures weapon mastery provides meaningful AP contribution
- At 100 skill, provides 20 AP (same as 10 STR)
- At 200 skill, provides 40 AP (same as 20 STR)
- Encourages weapon specialization for combat effectiveness

### 3.2.2 MagicSkillBonus Formula

**MagicSkillBonus** converts magic school skill points to Spell Power bonus:

```
MagicSkillBonus = MagicMasterySkill / 5.0
```

Where:
- **MagicMasterySkill**: Current skill value in the relevant magic school skill (Fire Lore, Frost Lore, Arcane Lore, etc.)
- **Scaling**: 1 skill point = 0.2 SP
- **Example**: 100 magic mastery skill = 20 SP (equivalent to 10 Intellect)

**Skill-to-SP Conversion:**
- This scaling ensures magic mastery provides meaningful SP contribution
- At 100 skill, provides 20 SP (same as 10 INT)
- At 200 skill, provides 40 SP (same as 20 INT)
- Encourages magic specialization for spell effectiveness

### 3.2.3 Complete AP/SP Calculation Examples

**Example 1: Melee AP Calculation**
```
Strength = 50
Agility = 30
Weapon Mastery (Swords) = 75

WeaponSkillBonus = 75 / 5.0 = 15.0
AP_melee = (2.0 * 50) + (0.5 * 30) + 15.0
AP_melee = 100 + 15 + 15 = 130 AP
```

**Example 2: Ranged AP Calculation**
```
Agility = 60
Strength = 20
Weapon Mastery (Bows) = 100

WeaponSkillBonus = 100 / 5.0 = 20.0
AP_ranged = (2.0 * 60) + (0.5 * 20) + 20.0
AP_ranged = 120 + 10 + 20 = 150 AP
```

**Example 3: Spell Power Calculation**
```
Intellect = 80
Spirit = 40
Magic Mastery (Fire Lore) = 120

MagicSkillBonus = 120 / 5.0 = 24.0
SP = (2.0 * 80) + (0.5 * 40) + 24.0
SP = 160 + 20 + 24 = 204 SP
```

### 3.2.4 Design Rationale

**Why /5.0 scaling?**
- Provides meaningful contribution: 100 skill = 20 AP/SP (equivalent to 10 stat points)
- Balances skill vs. attribute investment
- Encourages specialization without making skills overpowered
- Consistent with damage bonus scaling (0.1 damage per skill point in damage formula)

**Skill vs. Attribute Trade-off:**
- 1 point of STR/INT = 2.0 AP/SP
- 1 point of weapon/magic skill = 0.2 AP/SP
- Skills require more investment (time/effort) but provide long-term progression
- Attributes provide immediate power but are capped at 150 per stat

These are implemented in **C++** inside `MortalStats` / `MortalCombat` and exposed to scripts as needed.

### 3.3 Crit Chance

We don’t use crit rating on items. Crit is derived from AGI (for physical) and INT (for spells), plus mastery skills and possibly runes.

**Physical Crit Chance**

```text
CritPhysical% = BaseCritPhysical + (AGI / 20.0) + WeaponMasteryCritBonus
```

**Spell Crit Chance**

```text
CritSpell% = BaseCritSpell + (INT / 25.0) + MagicMasteryCritBonus
```

Tuned so that at *realistic* AGI/INT values (not cap), crit is meaningful but not out of control.

### 3.4 Mitigation, Armor & Resistances

We keep:

- **Armor** as the primary physical mitigation.
- **One simplified Elemental Resistance** bucket (or a small set of broad categories).

**Armor**

- Derived directly from gear armor plus any STR-based minor bonuses.
- We can reuse AzerothCore armor formulas under the hood, but:
  - No armor penetration rating on items,
  - Any armor ignore effects are runes or special cases.

**Elemental Resistance**

Instead of full vanilla/WotLK complexity (Fire, Frost, Nature, Shadow, Arcane all separately on gear), Mortal can:

- Use **broad resist** categories:
  - e.g. `Elemental Resist`, `Abyssal Resist`, etc.
- Put them on specific gear & runes as needed for:
  - Fire Resistance skill checks (Molten Core-style),
  - Ether Rifts and anomalies.

All of these are computed in C++ and surfaced via MortalUI as clean numbers, not rating lists on items.

---

## 4. What We Remove / Override from WotLK

These stats should **not appear as item stats** in Mortal gear, and should be stripped or converted on legacy items if reused.

### 4.1 Fully Decommissioned as Item Lines

- Defense Rating
- Resilience Rating
- Hit Rating
- Expertise Rating
- Crit Rating
- Haste Rating
- Armor Penetration Rating
- Block Rating, Parry Rating, Dodge Rating (as item lines)

### 4.2 Replaced by Derived Logic

- **Defense & Resilience**:
  - Baseline defense baked into overall formulas and level scaling.
  - No PvP-only resilience; we rely on:
    - HP, armor, Spirit, and specific runes (e.g., “Bulwark” runes) to soften burst.

- **Hit/Expertise**:
  - Light inherent miss/avoid chance is allowed strictly for huge skill/dynamic-level gaps.
  - Otherwise, accuracy handled via AGI and **weapon mastery skills**, not a rating cap.

- **Crit/Haste**:
  - Crit is derived from AGI/INT and skills.
  - Haste is rare, mostly from:
    - Runes,
    - Temporary buffs,
    - Possibly small global scaling at higher tiers.

---

## 5. Legacy Item Handling

### 5.1 Mortal Gear (New Items)

All **Mortal progression items** (T1–T5, rune-enabled):

- Must only use:
  - STR / AGI / STA / INT / SPI,
  - Armor,
  - Occasional broad resist lines,
  - Rune sockets.

No rating stats are allowed on these items.

### 5.2 Legacy WotLK Items (Optional Use)

If any original WotLK items are kept as drops or curiosities:

- Run a **conversion script** during data prep:

Example mapping (conceptual):

- Defense rating → +STA or +Armor.
- Resilience rating → +STA or +SPI.
- Hit/crit/haste ratings → distributed into primary stats within caps.
- Expertise/armor pen → drop or convert into STR/AGI.

This is an offline tool (or migration SQL) not enforced at runtime; we aim to avoid “hidden best” legacy gear.

---

## 6. Skills, Runes & Secondary Systems

All extra depth and “build fantasy” live here, **not** in more rating stats.

### 6.1 Skills

Custom tables (C++ + DB):

- **Weapon Masteries**
  - Sword, Axe, Mace, Spear, Bow, Staff, etc.
  - Provide:
    - Flat AP bonuses,
    - Small crit bonuses,
    - Maybe minor armor penetration via calculated logic.

- **Armor Masteries**
  - Plate, Mail, Leather, Cloth.
  - Provide:
    - Reduced encumbrance penalties,
    - Small mitigation bonuses.

- **Material Lore**
  - Iron, Steel, Thorium, Etherweave, etc.
  - Controls refining efficiency and crafted quality.

- **Special Skills**
  - Thievery, Ether Attunement, Rifting, etc.

Implementation: **C++ modules** that back `character_mortal_skills` and plug into combat and crafting.

### 6.2 Runes

Runes deliver what class talents used to:

- Offensive abilities: Whirlwind, Mortal Strike, Flame Burst, Volley.
- Utility: Flickerstep, Hunter’s Step, Overchannel.
- Defensive: Brace Counter, Ether Aegis, Shared Burden.

Runes:

- Are items with entries in `mortal_rune_def`.
- Are applied to weapons/armor via Mortal’s rune-socketing system (C++ core with UI via MortalUI).
- Modify:
  - Available spells,
  - Some derived stat behavior,
  - Certain combat calculations (e.g. special crit multipliers, guard counters).

---

## 7. C++ Implementation Notes

### 7.1 Central Modules

Create / extend modules like:

- `src/server/game/Mortal/MortalStats.cpp/h`
  - Attribute clamping,
  - Derived stat calculations (HP, Mana, AP, SP, Crit, etc.).

- `src/server/game/Mortal/MortalSkills.cpp/h`
  - Load & compute weapon/armor/material skills,
  - Provide hooks for combat formulas.

- `src/server/game/Mortal/MortalRunes.cpp/h`
  - Rune equip/unequip,
  - Rune effects injection into combat/magic.

Hook into:

- `Player::UpdateStats()`
- `Player::UpdateArmor()`
- `Player::CalculateMeleeHitChance()` (or equivalent)
- `Player::CalculateSpellDamageDone()` etc.

### 7.2 Lua Role

Going forward, we prefer:

- **C++ for core rules & formulas**,
- **Lua for:**
  - Quest logic.
  - Content scripting (events, Contracts, bosses).
  - Glue between Mortal core systems and content.

Lua should **call into** the C++ Mortal modules when it needs:

- Current derived stats,
- Skill levels,
- Rune lists.

---

## 8. UI / Presentation (MortalUI)

MortalUI should:

- Display the original stat names OR flavored aliases (configurable):
  - Might (STR), Guile (AGI), Vigor (STA), Focus (INT), Resolve (SPI).
- Show derived stats in a **clean panel**:
  - Health, Mana, AP, SP, Crit, Armor, Resist, Encumbrance, etc.
- Avoid exposing rating-style values; everything is based on the the formulas above.

---

## 9. Summary

- We **reuse the five core attributes** for compatibility.
- We enforce **hard caps (150 per stat, 400 total)** via C++.
- We **remove** classic WotLK “rating soup” from items.
- We provide **simple, readable derived stats** for combat.
- Depth and specialization live in **skills + runes + systems**, not obscure item ratings.
- Implementation is **C++-first**, with Lua for content scripting only.

This file should be treated as the **canonical reference** for all future itemization and combat work.  
Any new subsystem should plug into this model rather than reintroducing rating-like mechanics.
