# Project Canvas: Mortal Warcraft Overhaul  
### File: 103-mortal-gear-vanguard-bulwark-set-t1-t2.md  
### Topic: Vanguard Tank Set – T1/T2 Itemization (“Bulwark of the Shrine” / “Iron Covenant”)

> This file defines concrete T1/T2 item blueprints for the **Vanguard** archetype:  
> a shield-based frontline tank focused on shrine holding, choke-point control, and siege defence.

This should align with:

- Stat model: STR/STA + minor Spirit (for sustain),
- Armor: Heavy (plate primary, some tanky mail variants),
- Weapons: 1H mace/sword/axe + shield (core fantasy).

We assume **6-piece sets** for T1 & T2:

- Helm, Chest, Legs, Gloves, Boots, Shield  
- 1H weapon is themed and recommended, but not formally a set piece (to keep flexibility).

---

## Related Specs

For full context on Vanguard gear sets, see:

- **`75-mortal-gear-and-runes-spec.md`** — Core gear and rune system that these sets implement
- **`77-mortal-itemization-t1-t2-starter-sets.md`** — Starter sets for other archetypes
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas and attribute caps used in these sets
- **`21-elden-systems.md`** — Elden systems (Brace, Guard Counter) that these sets enhance
- **`02-combat.md`** — Combat mechanics that Vanguard archetype uses
- **`79-drop-mapping-t1-t2-gear-and-runes.md`** — Drop tables and loot sources for these sets
- **`87-mortal-archetype-grid.md`** — Archetype grid that defines Vanguard archetype

---

## 1. T1 Set – “Shrine Bulwark”

**Fantasy:**  
Entry-level tank kit for shrine guardians, early Hellgates, low-tier delves, and public dungeon frontline.

**Power Band:**  
- Roughly equivalent to “pre-raid” gear in classic/WotLK terms,  
- Intended to be your **first real tank kit** once you commit to the Vanguard archetype.

### 1.1 Set Summary

- **Set Name:** Shrine Bulwark
- **Slots:** Head, Chest, Legs, Hands, Feet, Shield
- **Armor Type:** Plate (shield = shield)
- **Weight Tag:** HEAVY
- **Primary Stats:** Stamina > Strength, minor Spirit
- **Secondary:** Block Value, Armor, small Dodge/Parry
- **Rune Slots:** 1 generic defensive rune slot on chest & legs, 1 shield rune slot.

### 1.2 Set Bonuses

- **2-piece:**  
  +X Armor, +Y Block Value (flat).

- **4-piece – “Shrine Guard”**  
  Successfully using **Brace** to reduce damage triggers *Shrine Guard* for 3s:  
  - You and allies within 8 yards take **3–5% reduced damage**.  
  (Internal CD: 10s.)

- **6-piece – “Bulwark’s Temper”**  
  Landing a **Guard Counter** (successful block → melee hit within the window) grants:  
  - +10% Threat generation,  
  - +5% damage dealt,  
  for 6s. (Internal CD: 15s.)

> NOTE: numbers are placeholders; tune per internal balance pass.

---

## 1.3 Item Blueprints

Stat values are relative; implementors should convert into actual 3.3.5a item stats consistent with the Mortal attribute model.

### (T1) Shrine Bulwark Greathelm

- **Slot:** Head  
- **Armor Type:** Plate  
- **Tag:** VANGUARD, HEAVY  
- **Flavor:** “The helm worn by the first shrine wardens who held the line when all others fled.”  

**Suggested Stats:**

- +Stamina (high)
- +Strength (medium)
- +Spirit (small)
- +Armor (above baseline for item level)
- +Block Value (small)
- +Hit or Defense rating compatible with Mortal stat model

**Special:**

- Slight bonus to **threat generation** or **Brace duration** (cosmetic magnitude).

---

### (T1) Shrine Bulwark Cuirass

- **Slot:** Chest  
- **Armor Type:** Plate  
- **Tag:** VANGUARD, HEAVY  

**Stats:**

- +High Stamina
- +Medium Strength
- +Armor (high)
- +Block Value
- +Small Dodge or Parry

**Sockets / Runes:**

- 1x **Defensive Rune Slot** (CHEST):
  - Recommended runes:
    - Rune of Bastion (AoE DR),
    - Rune of Vigil (intercept).

---

### (T1) Shrine Bulwark Legguards

- **Slot:** Legs  
- **Armor Type:** Plate  

**Stats:**

- +High Stamina
- +Medium Strength
- +Armor
- +Block Value
- +Minor Movement Speed in combat (optional small value)

**Sockets / Runes:**

- 1x **Defensive Rune Slot** (LEGS)

---

### (T1) Shrine Bulwark Gauntlets

- **Slot:** Hands  
- **Armor Type:** Plate  

**Stats:**

- +Medium Stamina
- +Medium Strength
- +Armor
- +Block Value (small)
- +Hit or Expertise (to help early threat)

---

### (T1) Shrine Bulwark Sabatons

- **Slot:** Feet  
- **Armor Type:** Plate  

**Stats:**

- +Medium Stamina
- +Strength (small)
- +Armor
- +Minor Movement Speed out of combat or while in Defensive stance (theme).

---

### (T1) Shrine Bulwark Ward

- **Slot:** Shield  
- **Type:** Shield – Heavy  

**Stats:**

- +Armor (high)
- +Block Value (medium-high)
- +Stamina (medium-high)
- +Strength (small-medium)
- +Defense/Block rating

**Rune Slot:**

- 1x **Shield Rune Slot**:
  - Example runes:
    - Rune of Shield Bash (stun),
    - Rune of Bulwark (short DR buff after block).

---

### 1.4 Recommended Theme Weapon (Non-set)

#### (T1) Warden’s Oathblade

- **Slot:** 1H Sword (or Mace variant)  
- **Stats:**
  - +Strength
  - +Stamina
  - +Hit/Expertise
  - +Minor threat bonus

- **Optional Proc:**  
  Small chance on hit to grant a short Armor buff (2–3s).

---

## 2. T2 Set – “Iron Covenant”

**Fantasy:**  
A campaign-hardened tank kit designed for Wintergrasp/Stronghold sieges, high-tier delves, and world boss tanking. The covenant between warrior and fortress: you stand, or the line breaks.

**Power Band:**  
- Equivalent to “early raid / high heroic” gear,
- Tightens survivability and control, rewards being focus-targeted by multiple enemies.

---

## 2.1 Set Summary

- **Set Name:** Iron Covenant
- **Slots:** Head, Chest, Legs, Hands, Feet, Shield
- **Armor Type:** Plate
- **Weight Tag:** HEAVY
- **Primary Stats:** Stamina (very high), Strength (medium-high), Spirit (small).
- **Secondary:** Block Value, Block Rating, Armor, some Parry/Dodge.

### 2.2 Set Bonuses

- **2-piece:**  
  +Stamina, +Strength, +Block Value.

- **4-piece – “Iron Resolve”**  
  Taking a **big hit** (e.g. more than 20% of max HP) grants a small **absorb shield** for 4s.  
  (Internal CD: e.g. 20–30s.)

- **6-piece – “Bulwark Stance”**  
  While you are the target of **3 or more enemies** (players or elites), gain:  
  - +10% Armor,  
  - -5% damage dealt,  
  for 8s. (Internal CD: 20s.)

This rewards **actually being the wall** in sieges and delves.

---

## 2.3 Item Blueprints

### (T2) Iron Covenant Greathelm

- **Slot:** Head  
- **Armor Type:** Plate  

**Stats:**

- +Very High Stamina
- +High Strength
- +Armor (above T1)
- +Block Value
- +Block or Parry rating
- +Minor Resists or mitigation vs magic (theme).

---

### (T2) Iron Covenant Breastplate

- **Slot:** Chest  
- **Armor Type:** Plate  

**Stats:**

- +Very High Stamina
- +High Strength
- +Armor (very high)
- +Block Value
- +Block Rating

**Sockets / Runes:**

- 1x **Defensive Rune Slot (CHEST)** – higher tier runes unlocked in later content.

---

### (T2) Iron Covenant Legplates

- **Slot:** Legs  
- **Armor Type:** Plate  

**Stats:**

- +Very High Stamina
- +Strength
- +Armor
- +Dodge/Parry rating

**Rune Slot:**

- 1x Defensive Rune Slot (LEGS)

---

### (T2) Iron Covenant Gauntlets

- **Slot:** Hands  
- **Armor Type:** Plate  

**Stats:**

- +High Stamina
- +Strength
- +Armor
- +Hit/Expertise
- +Block Value (small)

---

### (T2) Iron Covenant Greaves

- **Slot:** Feet  
- **Armor Type:** Plate  

**Stats:**

- +High Stamina
- +Strength (small-medium)
- +Armor
- +Movement (minor bonus when near objectives, e.g. shrines/strongholds).

---

### (T2) Iron Covenant Aegis

- **Slot:** Shield  
- **Type:** Shield  

**Stats:**

- +Very High Armor
- +High Block Value
- +High Stamina
- +Strength
- +Block/Defense rating

**Rune Slot:**

- 1x Shield Rune Slot (Tier 2 shield runes)

**Optional Proc:**  
Small chance on block to grant a short buff: +X% Block Value for Y seconds.

---

### 2.4 Recommended Theme Weapon (Non-set)

#### (T2) Covenant Bulwarkblade

- **Slot:** 1H Sword/Mace  
- **Stats:**
  - +Strength (high)
  - +Stamina (medium)
  - +Hit/Expertise
  - +Minor threat bonus

- **Proc:**  
  On Guard Counter, small chance to:
  - Apply an Armor debuff to the target, **or**
  - Grant you a brief self-buff to damage or mitigation.

---

## 3. Acquisition & Progression (High-Level)

This set plugs into the global **drop mapping**:

- **T1: Shrine Bulwark**
  - Sources:
    - Early/mid **public delves** tuned for tanks,
    - Shrine defence Contracts (Task Boards),
    - Low-tier Hellgates where you queue/enter as “frontline”.
  - Goal:
    - Get new Vanguard players to a reliable defensive baseline quickly.

- **T2: Iron Covenant**
  - Sources:
    - Stronghold siege defender rewards,
    - High-tier delves and world boss tank drops,
    - Campaign milestones where you act as Warden/Defender.

Exact dungeon/Contract/event hooks are defined in the **set drop matrix** document.

---

This file provides enough structure for:
- DBC/item template creation,
- Rune slot and tag definition,
- Art/model selection using repurposed WotLK visuals (e.g. certain ICC/Naxx tank sets) with new Mortal item entries.
