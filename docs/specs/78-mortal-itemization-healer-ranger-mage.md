# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.2 — Itemization Detail  
### File: 78-mortal-itemization-healer-ranger-mage.md  
### Section: Concrete T1/T2 Sets — Healer, Ranger, Mage

---

## 1. Scope

This file extends `75-mortal-gear-and-runes-spec.md` and `77-mortal-itemization-t1-t2-starter-sets.md` with **three more concrete archetypes**:

- **Sanctum Warden** — dedicated healer / support.
- **Longroad Ranger** — physical ranged specialist.
- **Spellfire Magus** — pure offensive mage.

For each archetype:

- T1 **Settler / Apprentice** set (Green/early Yellow).
- T2 **Frontier** set (solid Yellow & early delves).
- Example **stat layouts** and **Rune loadouts**.

Numbers follow the same assumptions:

- T1 mini-set (8 slots) ≈ 70–80 attribute points.
- T2 mini-set (8 slots) ≈ 110–120 attribute points.
- Attributes respect global caps (150 per stat, 400 total) and leave room for T3–T5.

Slots used for examples:

- Weapon, Helm, Chest, Legs, Gloves, Boots, Ring, Necklace.

---

## Related Specs

For full context on itemization for healer, ranger, and mage archetypes, see:

- **`75-mortal-gear-and-runes-spec.md`** — Core gear and rune system that these sets implement
- **`77-mortal-itemization-t1-t2-starter-sets.md`** — Starter sets for other archetypes (Bruiser, Arcanist)
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas and attribute caps used in these sets
- **`19-itemization.md`** — Overall itemization philosophy and tier structure
- **`79-drop-mapping-t1-t2-gear-and-runes.md`** — Drop tables and loot sources for these sets
- **`22-healing-and-restoration.md`** — Healing system that Sanctum Warden sets support
- **`01-progression.md`** — Progression system that determines when players use these sets

---

## 2. Archetype C — “Sanctum Warden” (Dedicated Healer)

Role:

- Primary healer / support for dungeons, Warfronts, and raids.
- Focus on **Spirit + Intellect + Stamina**, minimal Str/Agi.
- Light or medium armor, but tuned around staying alive in the backline.

### 2.1 T1 Set — “Shrine Acolyte”

**Theme:**

- Robes and trinkets given by the Shrine to new initiates.
- Visuals: early cloth priest sets, pale whites and blues.

#### 2.1.1 Target Budget (8-piece mini-set)

Target: **~75 points**.

Suggested distribution:

- Weapon (mace+offhand or staff; we’ll use 1H mace here): 16  
- Chest: 12  
- Legs: 10  
- Helm: 8  
- Gloves: 7  
- Boots: 7  
- Ring: 7  
- Necklace: 8  

Total ≈ 75.

#### 2.1.2 Per-Item Stat Layout

**Weapon – “Acolyte’s Blessing Mace”**  
- +6 Intellect  
- +6 Spirit  
- +4 Stamina  

**Helm – “Acolyte’s Circlet”**  
- +3 Intellect  
- +3 Spirit  
- +2 Stamina  

**Chest – “Acolyte’s Vestments”**  
- +5 Intellect  
- +5 Spirit  
- +2 Stamina  

**Legs – “Acolyte’s Legwraps”**  
- +4 Intellect  
- +4 Spirit  
- +2 Stamina  

**Gloves – “Acolyte’s Handwraps”**  
- +3 Intellect  
- +2 Spirit  
- +2 Stamina  

**Boots – “Acolyte’s Sandals”**  
- +3 Intellect  
- +2 Spirit  
- +2 Stamina  

**Ring – “Shrine Prayer Band”**  
- +2 Intellect  
- +3 Spirit  
- +2 Stamina  

**Necklace – “Shrine Rosary”**  
- +3 Intellect  
- +4 Spirit  
- +1 Stamina  

Full 8-piece mini-set:

- Int ≈ +29  
- Spi ≈ +29  
- Sta ≈ +17  

This gives respectable mana/regen and survivability for early-group healing.

#### 2.1.3 T1 Healer Rune Loadout

1. **Rune of Minor Mend (Support/Heal)**  
   - Weapon-only.  
   - Grants a basic single-target heal with moderate cast time.

2. **Rune of Steadfast Prayer (Support)**  
   - Necklace.  
   - Short buff: increases Spirit for X seconds, improving regen & heals slightly.

3. **Rune of Sanctuary Step (Mobility/Guard)**  
   - Boots.  
   - Small speed boost + minor damage reduction for a short duration (kite tool).

Slotting:

- Mace: 1 Rune slot (Minor Mend).  
- Boots: 1 Rune slot (Sanctuary Step).  
- Necklace: 1 Rune slot (Steadfast Prayer).

---

### 2.2 T2 Set — “Sanctum Warden’s Regalia”

**Theme:**

- Dedicated field medic and Ether-watcher, entrusted with defending shrines in the Frontier.
- Visuals: more ornate priest sets, halos, soft glows.

#### 2.2.1 Target Budget (8-piece mini-set)

Target: **~110–120 points**.

Distribution:

- Weapon (staff this time): 22  
- Chest: 18  
- Legs: 16  
- Helm: 12  
- Gloves: 10  
- Boots: 10  
- Ring: 8  
- Necklace: 8  

Total ≈ 104 (tune upwards slightly if needed).

#### 2.2.2 Per-Item Stat Layout

**Weapon – “Sanctum Warden’s Staff”**  
- +10 Intellect  
- +8 Spirit  
- +4 Stamina  

**Helm – “Sanctum Warden’s Halo”**  
- +5 Intellect  
- +5 Spirit  
- +2 Stamina  

**Chest – “Sanctum Warden’s Robes”**  
- +7 Intellect  
- +7 Spirit  
- +4 Stamina  

**Legs – “Sanctum Warden’s Pants”**  
- +6 Intellect  
- +6 Spirit  
- +4 Stamina  

**Gloves – “Sanctum Warden’s Handguards”**  
- +4 Intellect  
- +4 Spirit  
- +2 Stamina  

**Boots – “Sanctum Warden’s Slippers”**  
- +4 Intellect  
- +4 Spirit  
- +2 Stamina  

**Ring – “Halo-bound Band”**  
- +3 Intellect  
- +3 Spirit  
- +2 Stamina  

**Necklace – “Shrine Guardian’s Locket”**  
- +4 Intellect  
- +4 Spirit  

Full 8-piece mini-set:

- Int ≈ +43  
- Spi ≈ +41  
- Sta ≈ +20  

This is a clear jump from T1 in throughput and regen.

#### 2.2.3 T2 Healer Rune Loadout

1. **Rune of Vital Current (Support/Heal)**  
   - Weapon-only.  
   - Medium-CD instant heal that scales strongly with Spirit, excellent emergency button.

2. **Rune of Ether Aegis (Guard/Support)**  
   - Chest or Helm.  
   - When you cast a heal on a target under X% HP:
     - Also grants them a small shield.

3. **Rune of Valiant Ward (Guard)**  
   - Boots or Ring.  
   - Short-duration buff reducing damage on yourself while channeling/casting.

4. **Rune of Shared Burden (Support)**  
   - Ring or Necklace.  
   - On overheal, a portion is redirected to a nearby ally.

Slotting:

- Staff: 2 Rune slots (Vital Current + optional smaller heal or utility).  
- Chest/Helm: 1 Rune slot (Ether Aegis).  
- Boots/Ring: 1 Rune slot (Valiant Ward or Shared Burden).

---

## 3. Archetype D — “Longroad Ranger” (Ranged Physical DPS)

Role:

- Mobile ranged physical damage (bows/guns), excellent at kiting, scouting, and picking targets.
- Focus on **Agility + Stamina**, with sprinkles of Int/Spi for utility.
- Medium armor; works well with mobility and vision Runes.

### 3.1 T1 Set — “Greenway Scout”

**Theme:**

- Basic scout gear issued to Rangers patrolling Green/Yellow borders.
- Visuals: leather archer sets, simple cloaks.

#### 3.1.1 Target Budget (8-piece mini-set)

Target: **~75 points**.

Distribution:

- Weapon (bow): 18  
- Chest: 12  
- Legs: 10  
- Helm: 8  
- Gloves: 7  
- Boots: 7  
- Ring: 6  
- Necklace: 7  

Total ≈ 75.

#### 3.1.2 Per-Item Stat Layout

**Weapon – “Greenway Scout’s Bow”**  
- +8 Agility  
- +4 Stamina  
- +2 Intellect  
- +2 Spirit  

**Helm – “Greenway Leather Hood”**  
- +4 Agility  
- +2 Stamina  

**Chest – “Greenway Scout’s Jerkin”**  
- +5 Agility  
- +3 Stamina  
- +2 Intellect  

**Legs – “Greenway Leggings”**  
- +5 Agility  
- +3 Stamina  

**Gloves – “Greenway Grips”**  
- +3 Agility  
- +2 Stamina  

**Boots – “Greenway Boots”**  
- +3 Agility  
- +2 Stamina  

**Ring – “Pathfinder’s Band”**  
- +2 Agility  
- +2 Stamina  
- +2 Intellect  

**Necklace – “Greenway Whistle Charm”**  
- +3 Agility  
- +2 Stamina  
- +2 Intellect  

Full 8-piece mini-set:

- Agi ≈ +33  
- Sta ≈ +18  
- Int ≈ +6  
- Spi ≈ +2  

Solid early-game ranged kit; agility-focused with enough Sta to not explode instantly.

#### 3.1.3 T1 Ranger Rune Loadout

1. **Rune of Piercing Shot (Combat)**  
   - Weapon-only.  
   - Straight-line skillshot arrow that pierces multiple enemies with small damage falloff.

2. **Rune of Hunter’s Step (Mobility)**  
   - Boots.  
   - Short sprint + slow-fall effect for repositioning.

3. **Rune of Keen Eye (Utility)**  
   - Helm or Necklace.  
   - Increases vision range and highlights enemies that recently damaged you.

Slotting:

- Bow: 1 Rune slot (Piercing Shot).  
- Boots: 1 Rune slot (Hunter’s Step).  
- Helm or Necklace: 1 Rune slot (Keen Eye).

---

### 3.2 T2 Set — “Longroad Ranger’s Harness”

**Theme:**

- Serious long-range hunter gear for patrolling Red approaches and open-frontier warfare.
- Visuals: higher-quality leather mail mixes with hooded cloaks.

#### 3.2.1 Target Budget (8-piece mini-set)

Target: **~110–120 points**.

Distribution:

- Weapon (bow): 24  
- Chest: 18  
- Legs: 16  
- Helm: 12  
- Gloves: 10  
- Boots: 10  
- Ring: 6  
- Necklace: 8  

Total ≈ 104 (tune upward if needed).

#### 3.2.2 Per-Item Stat Layout

**Weapon – “Longroad Ranger’s Bow”**  
- +14 Agility  
- +6 Stamina  
- +4 Intellect  

**Helm – “Longroad Ranger’s Hood”**  
- +6 Agility  
- +4 Stamina  

**Chest – “Longroad Ranger’s Harness”**  
- +8 Agility  
- +6 Stamina  
- +2 Intellect  

**Legs – “Longroad Ranger’s Chaps”**  
- +8 Agility  
- +6 Stamina  

**Gloves – “Longroad Ranger’s Bracers”**  
- +5 Agility  
- +3 Stamina  
- +2 Intellect  

**Boots – “Longroad Ranger’s Treads”**  
- +5 Agility  
- +3 Stamina  
- +2 Intellect  

**Ring – “Longroad Mark”**  
- +3 Agility  
- +3 Stamina  

**Necklace – “Arrowflight Pendant”**  
- +4 Agility  
- +2 Stamina  
- +2 Intellect  

Full 8-piece mini-set:

- Agi ≈ +53  
- Sta ≈ +33  
- Int ≈ +10  

Capable Yellow-zone ranger gear with clear agility emphasis.

#### 3.2.3 T2 Ranger Rune Loadout

1. **Rune of Volley (Combat)**  
   - Weapon-only.  
   - Short-channel cone or area volley; punishes clumps.

2. **Rune of Trapline (Control)**  
   - Boots or Gloves.  
   - Grants deployable snare or slow trap with cooldown.

3. **Rune of Long Sight (Utility)**  
   - Helm.  
   - Improves detection radius for stealthed enemies and adds minor ranged crit chance.

4. **Rune of Marked Prey (Combat/Utility)**  
   - Ring or Necklace.  
   - Marks a target, increasing your damage to it and giving you a faint HUD indicator through terrain.

Slotting:

- Bow: 2 Rune slots (Piercing Shot/Volley + Marked Prey).  
- Boots/Gloves: 1 Rune slot (Trapline).  
- Helm: 1 Rune slot (Long Sight).

---

## 4. Archetype E — “Spellfire Magus” (Pure Mage)

Role:

- Glass-cannon offensive caster, minimal defenses, massive burst or AoE.
- Focus on **Intellect + Spirit**, minimal Sta, very low Str/Agi.
- Cloth armor; heavily gridlocked into positioning.

### 4.1 T1 Set — “Sparkweaver Apprentice”

**Theme:**

- Raw magical talent, barely controlled; academy-supplied gear.
- Visuals: colorful but simple mage robes.

#### 4.1.1 Target Budget (8-piece mini-set)

Target: **~75 points**.

Distribution:

- Weapon (staff): 20  
- Chest: 14  
- Legs: 10  
- Helm: 8  
- Gloves: 7  
- Boots: 6  
- Ring: 5  
- Necklace: 5  

Total ≈ 75.

#### 4.1.2 Per-Item Stat Layout

**Weapon – “Sparkweaver’s Training Staff”**  
- +10 Intellect  
- +6 Spirit  
- +2 Stamina  
- +2 Agility  

**Helm – “Sparkweaver’s Circlet”**  
- +5 Intellect  
- +3 Spirit  

**Chest – “Sparkweaver’s Vestments”**  
- +7 Intellect  
- +3 Spirit  
- +2 Stamina  

**Legs – “Sparkweaver’s Pants”**  
- +5 Intellect  
- +3 Spirit  
- +2 Stamina  

**Gloves – “Sparkweaver’s Gloves”**  
- +4 Intellect  
- +2 Spirit  

**Boots – “Sparkweaver’s Boots”**  
- +3 Intellect  
- +2 Spirit  
- +1 Stamina  

**Ring – “Crackling Focus Band”**  
- +3 Intellect  
- +1 Spirit  
- +1 Stamina  

**Necklace – “Arc Node Pendant”**  
- +3 Intellect  
- +2 Spirit  

Full 8-piece mini-set:

- Int ≈ +40  
- Spi ≈ +22  
- Sta ≈ +6  

This is a very offensively skewed early set.

#### 4.1.3 T1 Mage Rune Loadout

1. **Rune of Firebolt (Combat)**  
   - Weapon-only.  
   - Fast cast, small direct damage nuke; bread-and-butter.

2. **Rune of Ember Shield (Guard)**  
   - Chest.  
   - Small temporary absorb that also deals a tiny amount of damage to melee attackers.

3. **Rune of Flickerstep (Mobility)**  
   - Boots.  
   - Short-range instant blink, longer cooldown than advanced versions.

Slotting:

- Staff: 1 Rune slot (Firebolt).  
- Chest: 1 Rune slot (Ember Shield).  
- Boots: 1 Rune slot (Flickerstep).

---

### 4.2 T2 Set — “Spellfire Magus Regalia”

**Theme:**

- Fully realized combat mage, weaving destructive magic into warfronts and raids.
- Visuals: higher-level mage sets with fiery or arcane glowing accents.

#### 4.2.1 Target Budget (8-piece mini-set)

Target: **~110–120 points**.

Distribution:

- Weapon (staff): 24  
- Chest: 18  
- Legs: 16  
- Helm: 12  
- Gloves: 10  
- Boots: 10  
- Ring: 6  
- Necklace: 8  

Total ≈ 104.

#### 4.2.2 Per-Item Stat Layout

**Weapon – “Spellfire Magus Staff”**  
- +14 Intellect  
- +8 Spirit  
- +2 Stamina  

**Helm – “Spellfire Magus Hood”**  
- +7 Intellect  
- +5 Spirit  

**Chest – “Spellfire Magus Robes”**  
- +9 Intellect  
- +7 Spirit  
- +2 Stamina  

**Legs – “Spellfire Magus Legwraps”**  
- +8 Intellect  
- +6 Spirit  
- +2 Stamina  

**Gloves – “Spellfire Magus Handwraps”**  
- +5 Intellect  
- +4 Spirit  

**Boots – “Spellfire Magus Sandals”**  
- +5 Intellect  
- +3 Spirit  
- +2 Stamina  

**Ring – “Spellfire Focus Loop”**  
- +4 Intellect  
- +2 Spirit  

**Necklace – “Kindled Arc Node”**  
- +5 Intellect  
- +3 Spirit  

Full 8-piece mini-set:

- Int ≈ +57  
- Spi ≈ +38  
- Sta ≈ +6  

Big jump in offensive throughput and mana regen, still fragile on purpose.

#### 4.2.3 T2 Mage Rune Loadout

1. **Rune of Flame Burst (Combat)**  
   - Weapon-only.  
   - Short-cast AoE or chained fire spell with moderate cooldown.

2. **Rune of Icebind (Control)**  
   - Gloves or Chest.  
   - Single-target root or heavy slow, short range.

3. **Rune of Shimmer Veil (Guard/Mobility)**  
   - Boots.  
   - Short-duration spell that:
     - Reduces incoming damage while moving,  
     - Slightly increases movement speed.

4. **Rune of Overchannel (Utility/Risk)**  
   - Ring or Necklace.  
   - Temporarily boosts spell damage at the cost of increased self-damage from Ether backlash.

Slotting:

- Staff: 2 Rune slots (Firebolt/Flame Burst or Flame Burst + another nuke).  
- Gloves/Chest: 1 Rune slot (Icebind).  
- Boots: 1 Rune slot (Shimmer Veil).  
- Ring/Necklace: 1 Rune slot (Overchannel).

---

## 5. Next Steps & Usage

With these archetypes, you now have:

- **5 total concrete builds** (Bruiser, Hybrid Arcanist, Healer, Ranger, Mage),
- Each with:
  - T1 & T2 partial sets,
  - Stat lines that respect your caps,
  - Rune suggestions that fit the combat fantasy.

How to use this:

1. Have Cursor:
   - Generate the actual **SQL migrations** for each item and Rune,
   - Fill in `item_template`, `mortal_item_meta`, `mortal_rune_slots`, `mortal_rune_def`.

2. Map visuals:
   - Assign real `Displayid` values from 3.3.5a sets,
   - Keep a simple spreadsheet: `item_entry → displayid → mortal_tier → archetype`.

3. Hook to content:
   - Decide which early quests/dungeons/Contracts drop:
     - Acolyte/Sanctum sets for Shrine-aligned content,  
     - Greenway/Longroad for Ranger/Frontier Contracts,  
     - Sparkweaver/Spellfire for Academy/Cartel/Rift content.

4. Iterate:
   - Track average stats of players using these sets,
   - Adjust a few points up/down before rolling T3–T5.

These examples give your team enough **grounded, numeric patterns** to mass-produce gear and Rune tables that feel consistent with the Mortal design, rather than ad-hoc item spam.  
