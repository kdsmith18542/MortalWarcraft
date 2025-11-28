# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 19-itemization.md  
### Section: Itemization, Tiers, Content Mapping & Reward Rework Plan

---

# 1. Purpose

This document defines **how Mortal Warcraft reuses and rewires WoW 3.3.5a’s itemization**, including:

- Normal / Heroic dungeons
- Classic + TBC + WotLK raids
- World drops & BoEs
- Quest rewards
- Reputation vendors
- PvP rewards (Honor/Arena)
- Emblem/Badge currencies

It provides **systematic rules** so you can:

- Script SQL transforms in bulk
- Know **what has to be reworked**
- Keep Blizzard's art/flavor while aligning power with:
  - Skills
  - Crafting
  - Risk tiers
  - Extraction & caravans
  - Seasons

---

## Related Specs

For full context on itemization systems, see:

- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas and attribute caps that define how items grant power
- **`75-mortal-gear-and-runes-spec.md`** — Gear tiering, rune system, and stat budgets for Mortal items
- **`77-mortal-itemization-t1-t2-starter-sets.md`** — T1/T2 starter gear sets and drop sources
- **`78-mortal-itemization-healer-ranger-mage.md`** — Specialized itemization for healer, ranger, and mage archetypes
- **`79-drop-mapping-t1-t2-gear-and-runes.md`** — Drop tables and loot sources for gear tiers
- **`03-risk-zones.md`** — Risk tiers that affect item drop rates and loot rules
- **`04-economy.md`** — Economy system that determines item value and market dynamics
- **`05-crafting.md`** — Crafting system that produces many items

---

# 2. Mortal Item Tiers (Power & Source Philosophy)

We define **Mortal Tiers (MT)** that map loosely to original progression, but with a different philosophy:

### M-T0 – Scraps & Starter Gear
- Source:
  - Early quests
  - Starter zones
  - Low-level world drops
- Purpose:
  - Get players out of rags
  - Short-lived power
- Implementation:
  - Low attribute budgets
  - Very low durability
  - Easy to replace

### M-T1 – Basic Crafted / Early World Gear
- Source:
  - Early professions (Copper/Iron, basic leather/cloth)
  - Normal dungeons (reframed)
  - Low-risk trade routes
- Purpose:
  - “Baseline” for Yellow zone play
- Implementation:
  - Small attribute packages
  - Normal durability
  - Minimal skill requirements

### M-T2 – Advanced Crafted / Dungeon-Grade
- Source:
  - Refined materials (Steel/Mithril)
  - Normal/heroic 5-man dungeons
  - Early raids (MC, ZG, AQ20)
  - Public dungeon rewards
- Purpose:
  - Entry endgame gear
- Implementation:
  - Requires relevant combat/crafting skills
  - Encumbrance becomes meaningful
  - Some items flagged **“Drops on Death: Yes”** (risk them for power)

### M-T3 – Raid-Grade / High Risk
- Source:
  - 40-man/25-man raid content (BWL, AQ40, Naxx, SSC, TK, etc.)
  - Extraction mechanics (Cursed Artifacts)
  - High-tier public dungeon/hellgate bosses
- Purpose:
  - High-risk builds (Red zones, Warfronts)
- Implementation:
  - Significant attribute budgets but **tempered by encumbrance**
  - Strict skill requirements (weapon/armor mastery, material lore)
  - Partial dependency on crafted components (hybrid crafted+drop model)

### M-T4 – Legendary / Seasonal Prestige
- Source:
  - Legendary questlines
  - Seasonal rewards
  - Mythic rare mobs
  - Guild seasonal rankings
- Purpose:
  - Long-term goals, not mandatory
- Implementation:
  - Mostly **cosmetic or sidegrade power** (no pure +X > everything)
  - Often implemented via:
    - BPOs (Legendary crafting patterns)
    - Visual-only skins
    - Stronghold/guild benefits rather than raw DPS

### M-T5 – Relic / Pinnacle Prestige
- Source:
  - Top seasonal placements
  - Warfront/arena seasonal rewards
  - Signature raid artifacts
- Purpose:
  - Showcase achievement and longevity without hard power creep
- Implementation:
  - Primarily visual upgrades, titles, or unique utility perks
  - Obeys the same attribute caps; meant as prestige/sidegrade, not mandatory power

---

# 3. Vanilla Content → Mortal Tier Mapping (High-Level)

AzerothCore (3.3.5a) includes Vanilla, TBC, WotLK content. We treat them **not as time phases** but as **difficulty & risk bands**.

### 3.1 Normal 5-Man Dungeons

Examples:
- RFC, Deadmines, Wailing Caverns  
- Scarlet Monastery wings  
- Stratholme, Scholomance  
- Hellfire Ramparts, Slave Pens  
- Utgarde Keep, Nexus, etc.

**Mortal Tier Mapping:**
- Early vanilla normals → M-T0–M-T1
- Mid vanilla/TBC normals → M-T1–M-T2
- WotLK normals → M-T2 (but compressed)

**Rework Plan:**
- Replace many **finished gear drops** with:
  - M-T1–M-T2 gear templates (standardized stats)
  - Crafting mats & BPCs
- Keep a **small number** of iconic items per dungeon (rethemed as BPC sources or rare drops).

---

### 3.2 Heroic 5-Man Dungeons (TBC / WotLK)

Examples:
- Heroic Ramparts, Shattered Halls, Magister’s Terrace  
- WotLK heroics: HoL, HoS, OCC, ToC 5, etc.

**Mortal Tier Mapping:**
- TBC heroics → upper M-T2, low M-T3
- WotLK heroics → M-T3 (but squished to fit cap)

**Rework Plan:**
- Their loot tables should:
    - Drop **mostly BPCs and rare mats** (M-T2/M-T3 crafting inputs).
    - Drop a **few M-T3 finished pieces** but with:
    - Strict skill requirements
    - Noticeable encumbrance
    - Good but not BiS vs crafted M-T3 gear
- Badges/Emblems → removed or converted to:
  - Fragment currencies used for BPC crafting.

---

### 3.3 Raids (Vanilla → WotLK)

#### Early Raids:
- MC, ZG, AQ20, Onyxia
  - Map to: **lower M-T2 / early M-T3**

#### Mid Raids:
- BWL, AQ40, Naxx 40, Karazhan, Gruul, Mag
  - Map to: **M-T3**

#### Advanced Raids:
- SSC, TK, Hyjal, BT, Sunwell
- WotLK: Naxx 25, Ulduar, ToC, ICC (normal/heroic)
  - Map to: **high M-T3** with some M-T4 **recipes & cosmetics**

**Rework Plan (Universal Rules):**

1. **Convert Most “Tier Sets” into BPO/BPC Systems**
   - Rather than dropping the chest directly:
     - Raid drops:
       - A **Set Token** → turned into a **BPC** for the piece.
       - Or recipes that enable crafting the set using rare raid mats.
   - Keeps the fantasy of T1/T2/T6 etc. without making loot RNG the only path.

2. **Limit Direct Epic Armor/Weapon Drops**
   - Keep iconic weapons (Ashkandi, Sulfuras, warglaives, etc.) as:
     - Either:
       - Legendary questlines  
       - Or hybrids: special component + BPO craft
   - Most epics become:
     - High-quality BPCs
     - Cosmetic skins (transmog library)

3. **Integrate Extraction Loop**
   - Cursed Artifacts:
     - Drop in place of (or alongside) classic loot.
     - Required to “unlock” crafting or exchange for BPOs at Purification Altars.

4. **Re-tune Numeric Power**
   - All raid drops must obey:
     - Mortal attribute caps (150 / 400 total)
     - World HP/DMG squish design
   - Gear from ICC heroic shouldn’t **completely trivialize** a Deadmines PvP fight.

---

### 3.4 Quests (Solo / Chains / Attunements)

**Problem:** Vanilla/TBC/WotLK give lots of long-lasting gear through quests that can undercut your crafting/economy.

**Mortal Reframe:**

1. **Solo/Regular Quest Rewards:**
   - Shift from permanent gear → **gold, mats, utility items, basic M-T0/M-T1 gear**.
   - Any gear that *is* given:
     - Underpowered vs crafted equivalents.
     - Lower durability.
     - Low skill requirements (temporary “training” gear).

2. **Epic Questlines (e.g., Onyxia attunement, class quests, legendaries):**
   - Keep fantasy intact, but:
     - Reward **BPOs**, titles, or long-term utility (teleports, stronghold decorations, unique caravan skins).
     - If weapon/armor: make it **tightly integrated** with your Legendary/M-T4 philosophy.

3. **Attunement Rewards:**
   - Mainly:
     - Raid entry passes (Sigils)
     - Small but meaningful convenience perks
     - Not entire raid-ready gear sets.

---

### 3.5 Reputation Vendors

**Original Role:** Provide strong gear sets, enchants, heroic keys.

**Mortal Role:**

- **Gear → Recipes & Utilities**
  - Most rep gear becomes:
    - **Crafting recipes**
    - **Material refinement bonuses**
    - **Caravan route unlocks / cost reductions**
    - **Siege recipes**
- **Enchants:** Become:
  - Crafting sub-recipes
  - Or “infusion processes” applied at special workstations.

- **Keys / Access:** Become:
  - Tokens for:
    - High-tier public delves
    - Hellgate variants
    - Seasonal events

---

### 3.6 PvP Rewards (Honor / Arena)

**Original:** Full PvP gear sets that often rival raid gear.

**Mortal Plan:**

1. **Remove direct stat-mad PvP gear as a separate parallel progression.**
2. **Honor → Military Credits** (already defined):
   - Main use: Siege blueprints, Warfront support, defensive structures.

3. PvP-specific Rewards:
   - **Cosmetics:**
     - Cloaks, tabards, banners.
     - Mount skins.
   - **Specialized Gear Recipes:**
     - Light, mobile armor sets for roaming.
     - Niche weapons for ganking or defense.
   - These still obey:
     - Attribute caps
     - Encumbrance rules
     - BiS slots usually require some crafting.

---

# 3.7 Heirloom Conversion to Transmog Appearance Unlocks

## 3.7.1 Conversion Strategy

Original WoW 3.3.5a **Heirloom items** are converted to **Transmog Appearance Unlocks** rather than removed, leveraging the existing `mod-transmog` module and supporting Mortal's cosmetic progression system.

**Decision: Convert to Transmog (Not Remove)**

**Rationale:**
- **Better Mission Alignment**: Supports "Modern Retention & Social Systems" pillar (cosmetic progression)
- **Leverages Existing Module**: `mod-transmog` already installed and supports heirlooms
- **Maintains WoW Polish**: Keeps familiar, iconic items
- **Creates Opportunities**: Economy (trading, crafting), progression (collection goals), retention (long-term goals)
- **No Stat Advantages**: Maintains classless progression (heirlooms become cosmetic only)

## 3.7.2 Heirloom Conversion Process

**Conversion Steps:**
1. **Remove All Stat Bonuses**: Remove all stat bonuses from heirloom items
2. **Keep Appearance**: Preserve visual appearance for transmog
3. **Convert to Appearance Unlocks**: Heirloom items unlock appearances in Appearance Codex
4. **Remove XP Bonuses**: Remove all XP bonuses (no XP system in Mortal)
5. **Mark as Cosmetic**: Flag heirlooms as cosmetic-only items

**Heirloom Item Changes:**
- **Quality**: Keep as Heirloom quality (cosmetic marker)
- **Stats**: Remove all stat bonuses (STR, AGI, STA, INT, SPI)
- **XP Bonuses**: Remove all XP bonuses
- **Appearance**: Preserve for transmog system
- **Functionality**: Convert to appearance unlock items

## 3.7.3 Heirloom Distribution

**Starter Heirlooms:**
- New players receive 1-2 heirloom transmog items
- Provides familiar starting appearance
- Creates early cosmetic progression goal

**Heirloom Rewards:**
- Task board rewards
- Faction standing rewards
- Seasonal event rewards
- Crafted items (heirloom recipes)

**Heirloom Trading:**
- Can be traded (economy opportunity)
- Can be sold on market stalls
- Creates economy loop

## 3.7.4 Integration with Transmog System

**mod-transmog Integration:**
- Use `mod-transmog` as base system
- Heirlooms unlock appearances in Appearance Codex (Spec 57)
- Heirlooms can be used as transmog sources
- Appearance Tokens create economy sink

**Appearance Codex Integration:**
- Heirloom items unlock appearances in `mortal_appearances`
- Unlocks tracked in `mortal_appearance_unlocks`
- Active transmog in `mortal_transmog_state`
- Use `mod-transmog` for visual application

**Mortal-Specific Features:**
- Faction-themed heirlooms
- Seasonal heirloom rewards
- Heirloom crafting recipes
- Regional heirloom variants

## 3.7.5 Economy Impact

**Crafting Economy:**
- Heirloom recipes create crafting demand
- Heirloom materials create resource demand
- Supports regional economy (different heirlooms by region)

**Trading Economy:**
- Heirlooms can be traded between players
- Appearance Tokens create economy sink
- Heirloom crafting creates economy loop

**Progression Economy:**
- Heirloom collection creates long-term goals
- Appearance unlocks create progression rewards
- Supports retention (cosmetic progression)

**Implementation:**
- Heirloom conversion in item ETL pipeline
- Integration with `mod-transmog` module
- Appearance Codex integration (Spec 57)
- Database updates for heirloom items

**See**: `/home/keith/wowpack/docs/heirloom-transmog-recommendation.md` for detailed analysis

---

# 3.8 Set Bonus Redesign

## 3.7.1 Philosophy

**Original WoW Set Bonuses:**
- Class-specific set bonuses (e.g., "2-piece: +5% crit", "4-piece: special ability")
- Required wearing multiple pieces from same set
- Often mandatory for optimal performance

**Mortal Set Bonus Philosophy:**
- **No class-specific bonuses** (classless system)
- **Rune-based synergies** instead of set bonuses
- **Augment synergies** for gear sets
- **Faction-themed sets** with thematic bonuses
- **Build-focused sets** (Warlord, Guardian, Explorer)

## 3.7.2 Set Bonus Replacement: Rune Synergies

**Rune Synergies Replace Set Bonuses:**
- Instead of "2-piece set bonus", players get **Rune synergies**
- Runes from same "family" or "theme" provide bonuses when equipped together
- Example: "Warlord Runes" (3+ equipped) → +5% damage, +10% threat generation

**Rune Synergy Types:**
- **Combat Synergies:** Multiple combat runes from same family
- **Defensive Synergies:** Multiple defensive runes from same family
- **Utility Synergies:** Multiple utility runes from same family
- **Faction Synergies:** Multiple faction-themed runes

## 3.7.3 Augment-Based Set Bonuses

**Augment Sets:**
- Players can equip **Augment Cards** that provide set-like bonuses
- Example: "3x Offense Augments" → +3% crit chance
- Example: "5x Defense Augments" → +5% damage reduction

**Augment Set Bonuses:**
- **Offense Sets:** 2-piece (+2% damage), 4-piece (+5% crit), 6-piece (+10% attack power)
- **Defense Sets:** 2-piece (+2% armor), 4-piece (+5% block chance), 6-piece (+10% health)
- **Utility Sets:** 2-piece (+5% movement speed), 4-piece (+10% resource regen), 6-piece (+15% skill gain)

## 3.7.4 Faction-Themed Sets

**Faction Sets:**
- Gear sets themed around Mortal factions (Ledger, Shrine, etc.)
- **Faction Standing Requirements:** Higher standing = better set bonuses
- **Faction-Themed Bonuses:**
  - Ledger sets: Economic bonuses (gold find, vendor discounts)
  - Shrine sets: Spiritual bonuses (respawn cooldown, shrine bonuses)
  - Military sets: Combat bonuses (damage, defense)

**Faction Set Examples:**
- **Ledger Merchant Set (3-piece):** +10% gold from tasks, +5% vendor discount
- **Shrine Devotee Set (3-piece):** -20% respawn cooldown, +10% shrine blessing duration
- **Military Campaign Set (3-piece):** +5% damage, +10% threat generation

## 3.7.5 Build-Focused Sets

**Build Sets:**
- Sets designed for specific build archetypes (Warlord, Guardian, Explorer)
- **Warlord Sets:** Offense-focused bonuses
- **Guardian Sets:** Defense-focused bonuses
- **Explorer Sets:** Utility-focused bonuses

**Build Set Examples:**
- **Warlord Set (4-piece):** +10% damage, +5% crit chance, +10% attack power
- **Guardian Set (4-piece):** +10% armor, +5% block chance, +10% health
- **Explorer Set (4-piece):** +10% movement speed, +5% resource regen, +10% skill gain

## 3.7.6 Set Bonus Implementation

**No Traditional Set Bonuses:**
- Original WoW set bonuses are **removed**
- Replaced with Rune synergies and Augment sets
- Players mix and match gear freely (no forced set wearing)

**Synergy Tracking:**
- System tracks equipped Runes and Augments
- Bonuses apply automatically when thresholds met
- No UI requirement to "activate" set bonuses

**Set Bonus Balance:**
- All bonuses respect attribute caps (150 per stat, 400 total)
- Bonuses are **sidegrades**, not mandatory power
- Players can achieve similar power without sets

## 3.7.7 Set Bonus Conversion Strategy

**Original Set Bonuses → Mortal Conversion:**

| Original Set Bonus | Mortal Conversion | Notes |
|-------------------|-------------------|-------|
| Class-specific bonuses | Rune synergies | No class requirement |
| Stat bonuses (+crit, +haste) | Augment sets | Stat bonuses via augments |
| Ability bonuses (special procs) | Rune abilities | Abilities via runes |
| Set piece requirements | Synergy thresholds | Flexible piece counts |

**Conversion Rules:**
1. Remove all class-specific set bonuses
2. Convert stat bonuses to Augment set bonuses
3. Convert ability bonuses to Rune abilities
4. Create faction-themed sets for Mortal factions
5. Create build-focused sets for Warlord/Guardian/Explorer

---

# 4. Systematic Rework: Practical SQL/Content Plan

To keep workload sane, we define **bulk transformation rules**.

## 4.1 Step 1 – Loot Table Nuke

You already planned:

- `loot_table_nuke.sql`  
  → wipe or heavily trim `creature_loot_template`, `gameobject_loot_template`, and instance-specific tables.

Then, you **re-seed** via:

- `mortal_loot_world.sql`
- `mortal_loot_dungeon.sql`
- `mortal_loot_raid.sql`
- `mortal_loot_pvp.sql`

Each new table uses **Mortal Tier templates**.

---

## 4.2 Step 2 – Item Template Normalization

Create helper tables:

### `mortal_item_tier_map`
- `item_template` (INT)
- `mortal_tier` (TINYINT) – 0 to 4
- `source_category` (ENUM: world, dungeon, raid, quest, rep, pvp)

Populate using rules:

- Low-level world drops → M-T0/M-T1.
- Dungeon blues/epics → M-T2.
- Raid epics → M-T3.
- Legendary/orange → M-T4.

Then:

1. Use SQL scripts to:
   - Normalize attributes based on `mortal_tier`.
   - Strip rating stats.
   - Inject Mortal’s attribute patterns.

2. Optional:
   - Store “pre-Mortal” stat lines in a backup table `mortal_item_backup`.

---

## 4.3 Step 3 – Quest Reward Pass

Add:

### `mortal_quest_rework`
- `quest_id`
- `old_reward_item`
- `new_reward_type` (ENUM: gold, mats, recipe, token, mortal_item)
- `new_reward_ref` (item_template or recipe_id)
- `notes`

Then run a quest reward migration that:

- Converts most “reward blues/purples” to:
  - M-T0/M-T1 transitional gear  
  - Mats  
  - Recipes  
  - Tokens.

Keep **iconic quest rewards**, but ensure:

- They fit Mortal Tier rules.
- They don’t break crafting/economy.

---

## 4.4 Step 4 – Rep Vendor Pass

Create mapping:

### `mortal_rep_vendor_map`
- `vendor_entry`
- `item_template`
- `replacement_type` (recipe, cosmetic, utility, removed)
- `replacement_ref` (new item or recipe)

Then:

- Replace their gear with:
  - Recipes for the same **themed sets**, no direct gear.
  - Cosmetics that fit their faction identity.

---

## 4.5 Step 5 – PvP Reward Pass

Map old honor/arena rewards:

### `mortal_pvp_reward_map`
- `old_item_template`
- `reward_type` (cosmetic, recipe, mount_skin, title)
- `reward_ref`

Keep PvP as:

- Horizontal progression
- Cosmetic prestige
- Access to specialized, situational gear—*not* a completely separate power track.

---

# 5. Coverage: What “Needs Rework”

### Must be touched (high impact):

- **All dungeon & raid loot tables** (normal & heroic)
- **All raid sets (T1–T10)** and equivalent
- **All heroic/badge gear**
- **All major quest reward blues/purples**
- **All reputation gear & enchants**
- **All PvP gear (Honor, Arena)**

### Lower priority / Can often be left mostly intact:

- Low-level green world drops (if normalized by tier script).
- Low-impact white vendor gear (already weak).
- RP / cosmetic-only items (tabards, toys).

---

# 6. Integration with Crafting & Economy

Everything above is in service of:

- **Crafted gear = primary progression.**
- **Drops = enablers** (mats, BPO/BPC, recipes, artifacts, cosmetics).
- **Risk** (Red zones, Warfronts, Hellgates) = better material/reward *opportunities*, not just ilvl inflation.

---

# 7. Implementation Order (Recommended)

1. Implement `mortal_material_properties`, crafting slice (see `10-crafting-economy.md`).
2. Implement `mortal_item_tier_map` and basic SQL stat normalization.
3. Nuke & re-seed loot tables starting with:
   - One test dungeon
   - One test raid
4. Run **quest reward pass** on:
   - Early leveling zones  
   - A couple of iconic chains.
5. Rep vendor & PvP reward passes.
6. Gradually expand coverage until:
   - No content source is still using “raw vanilla” itemization philosophy.

---

# 8. Status

This file is the **authoritative plan for itemization in Mortal Warcraft**:

- It tells you **what needs reworked** (all endgame loot systems).
- It defines **how** to reframe their rewards (tiers, recipes, BPO/BPC, mats).
- It can be used to author SQL scripts that systematically transform 3.3.5a’s itemization into Mortal’s.
