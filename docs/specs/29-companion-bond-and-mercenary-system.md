# Project Canvas: Mortal Warcraft Overhaul
### Version 26.5 — Hybrid Technical Design Document  
### File: 29-companion-bond-and-mercenary-system.md  
### Section: Companion Bond, Pets, Mercenaries & Healer NPCs

---

## 0. Do We Need to Change Previous Specs?

**No major rewrites needed.** This spec is **additive** and clarifies the separation between:

- **mod-playerbots** → ambient/world population, rival parties, sandbox PvP.
- **Mortal Merc System** → hireable NPC companions (tank/healer/DPS), dungeon healer fill, bond/hunger.

You should only adjust earlier docs in these minor ways:

1. In the main overhaul roadmap (Phase 3 where it said:  
   > “Mercs: Configure mod-playerbots to only spawn when hired via Gossip Menu.”  
   Replace with:  
   > “Mercs: Implement Mortal Merc System (custom creatures + contracts) separate from mod-playerbots.”

2. Anywhere that implied “mercs *are* playerbots,” update to say:
   - Playerbots = **independent AI players**.
   - Mercs = **contracted NPCs** using this system.

Gear, mounts, launcher, Atlas specs do **not** need changes; they just consume this system as a dependency.

---

## Related Specs

For full context on companion and mercenary systems, see:

- **`23-mercenary-healers.md`** — Mercenary healer system for instances
- **`23a-merc-healer-archetypes.md`** — Mercenary healer archetypes
- **`07-mounts.md`** — Mount system that shares bond/hunger mechanics
- **`90-mortal-living-assets-companions.md`** — Living assets system that includes companions
- **`28-mounts-living-system-and-mapping.md`** — Mount living system referenced
- **`04-economy.md`** — Economy system for mercenary wages and companion upkeep
- **`06-pve.md`** — PvE content where companions and mercenaries are used

---

## 1. Purpose

Define a unified **Companion System** for Mortal Warcraft that covers:

- **Combat Pets** (tamed beasts, undead, constructs).
- **Mercenaries / Hireable NPCs** (tank/healer/DPS).
- **Healer Mercs for Dungeons** (small-group support).
- Integrated with:
  - **Companion Bond & Hunger** (light upkeep, meaningful bonuses).
  - **Living Mounts** (already covered in `28-mounts-living-system-and-mapping.md`).
  - **Economy & gold sinks** (merc wages, food, contracts).

Design goals:

- Make companions **feel alive** without becoming a tedious chore.
- Avoid leaning on **mod-playerbots** for merc mechanics.
- Keep performance / control predictable.

---

## 2. Conceptual Overview

### 2.1 Companion Types

We define four primary "companion" types for this system:

1. **Pet**
   - Hunter/warlock-style controllable combat creatures (or Mortal equivalents).
   - Uses existing pet mechanics + extended bond/hunger.

2. **Mercenary**
   - Hireable NPC combatant:
     - Tank / Healer / Melee DPS / Ranged DPS archetypes.
   - Spawns as a creature following the player, using custom AI.

3. **Mount**
   - Already defined as **Living Mount**:
     - Reins items.
     - Full loot + durability.
   - Here, we only unify **Bond/Hunger** aspects.

4. **Vanity Companion (Non-Combat Pet)**
   - Original WoW vanity pets converted to Mortal companion system.
   - **Cosmetic only** (no combat power).
   - **Minor utility** (light source, small inventory, etc.).
   - Can be traded (economy opportunity).
   - Require upkeep (food, etc.) = economy sink.

All four share:

- **Hunger [0–100]**
- **Bond [0–100]**
- Derived **Mood** (Neglected / Content / Devoted).

### 2.1.1 Vanity Companion Conversion

**Original WoW Vanity Pets → Mortal Companions:**

Original WoW had many non-combat vanity pets. These are converted to Mortal's companion system:

**Conversion Strategy:**
- Vanity pets become "Companions" (non-combat)
- Cosmetic only (no combat power)
- Minor utility (light source, small inventory, etc.)
- Can be traded (economy)
- Require upkeep (food, etc.) = economy sink

**Functionality:**
- **Cosmetic Only**: No combat abilities
- **Minor Utility**: 
  - Light source (torch/glow effect)
  - Small inventory (1-2 slots)
  - Minor buffs (cosmetic only)
- **Trading**: Can be traded between players (economy)
- **Upkeep**: Require food/consumables (economy sink)

**Acquisition:**
- Crafted items (heirloom recipes, etc.)
- Task board rewards
- Rare drops
- Faction rewards
- Seasonal events
- Supports multiple content loops

**Economy Integration:**
- Heirloom items can be crafted/traded
- Appearance Tokens create economy sink
- Heirloom crafting creates economy loop
- Supports regional economy (different heirlooms by region)

---

## 3. Data Model

### 3.1 Core Companion Table

```sql
CREATE TABLE mortal_companions (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  owner_guid        INT NOT NULL,        -- player GUID
  companion_guid    BIGINT NOT NULL,     -- pet/merc/mount identifier (see type)
  companion_type    TINYINT NOT NULL,    -- 0=pet,1=merc,2=mount
  hunger            TINYINT NOT NULL DEFAULT 100,  -- 0-100
  bond              TINYINT NOT NULL DEFAULT 0,    -- 0-100
  last_update       INT NOT NULL,        -- Unix timestamp
  INDEX idx_owner_type (owner_guid, companion_type)
);
```

**companion_guid meaning:**

- For **Pet**:
  - Creature/pet GUID.
- For **Merc**:
  - Creature GUID.
- For **Mount**:
  - Item instance GUID (from `item_instance`).

### 3.2 Merc Templates & Contracts

**Mercenary templates** (what kind of mercs exist):

```sql
CREATE TABLE mortal_merc_templates (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  name              VARCHAR(64) NOT NULL,
  role              VARCHAR(16) NOT NULL,   -- 'tank','healer','melee_dps','ranged_dps'
  base_gear_tier    VARCHAR(8) NOT NULL,    -- e.g. 'M-T2','M-T3'
  creature_entry    INT NOT NULL,           -- creature_template entry
  base_wage         INT NOT NULL,           -- gold per contract or per hour
  max_bond_bonus    TINYINT NOT NULL DEFAULT 10, -- max % performance bonus at bond=100
  notes             VARCHAR(255) NULL
);
```

**Mercenary contracts** (player-specific hires):

```sql
CREATE TABLE mortal_merc_contracts (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  owner_guid        INT NOT NULL,
  merc_template_id  INT NOT NULL,
  merc_creature_guid BIGINT NULL,   -- spawned merc creature GUID, if active
  start_time        INT NOT NULL,   -- Unix timestamp
  end_time          INT NOT NULL,   -- contract expiry
  active            TINYINT NOT NULL DEFAULT 0,
  last_paid_time    INT NOT NULL,
  daily_wage        INT NOT NULL,
  notes             VARCHAR(255) NULL,
  INDEX idx_owner_active (owner_guid, active)
);
```

---

## 4. Complete Pet-to-Companion Conversion Mapping

This section provides a comprehensive mapping of all WoW 3.3.5a pets to Mortal Warcraft's Companion system.

### 4.1 Pet Conversion Rules

**All Pets Convert to Companions:**
- Original pet spells → Companion items/contracts
- Pet visuals preserved (same model/display ID)
- Pet abilities converted to Mortal companion abilities
- Pet acquisition converted to Mortal progression

**Conversion Process:**
1. Original pet spell → Companion item/contract
2. Pet visual → Preserved in companion
3. Pet abilities → Converted to Mortal companion abilities
4. Pet acquisition → Converted to Mortal progression (skill-based)

### 4.2 Pet Type Conversion

| WoW Pet Type | Original Function | Mortal Conversion | Companion Type | Notes |
|--------------|-------------------|-------------------|----------------|-------|
| **Hunter Pets** | Combat pets | Combat Companions | Pet | Tamed beasts, bond/hunger system |
| **Warlock Pets** | Combat pets | Combat Companions | Pet | Demons/undead, bond/hunger system |
| **Vanity Pets** | Non-combat pets | Cosmetic Companions | Pet | Cosmetic only, no combat |
| **Mage Elementals** | Combat pets | Combat Companions | Pet | Elemental companions |
| **Death Knight Ghouls** | Combat pets | Combat Companions | Pet | Undead companions |

### 4.3 Combat Pet Conversion

**Hunter Pets:**
- **Original:** Tamed beasts, loyalty system
- **Mortal:** Combat companions with bond/hunger
- **Acquisition:** Taming skill (replaces Hunter class requirement)
- **Abilities:** Preserved, but skill-based unlock

**Warlock Pets:**
- **Original:** Summoned demons, soul shard system
- **Mortal:** Combat companions with bond/hunger
- **Acquisition:** Summoning skill (replaces Warlock class requirement)
- **Abilities:** Preserved, but skill-based unlock

**Death Knight Ghouls:**
- **Original:** Raised undead, rune system
- **Mortal:** Combat companions with bond/hunger
- **Acquisition:** Necromancy skill (replaces Death Knight class requirement)
- **Abilities:** Preserved, but skill-based unlock

### 4.4 Vanity Pet Conversion

**Vanity Pets (Non-Combat):**
- **Original:** Cosmetic pets, no combat function
- **Mortal:** Cosmetic companions, no combat
- **Acquisition:** Preserved (vendor, quest, achievement, rare drop)
- **Abilities:** None (cosmetic only)
- **Bond/Hunger:** Optional (cosmetic pets don't require upkeep)

**Vanity Pet Examples:**
- **Vendor Pets:** Preserved (same vendors, regional access)
- **Quest Pets:** Preserved (task/contract rewards)
- **Achievement Pets:** Preserved (Mortal achievement system)
- **Rare Drop Pets:** Preserved (same drop rates)

### 4.5 Pet Acquisition Conversion

**Original Acquisition → Mortal Acquisition:**

| Original Method | Mortal Conversion | Notes |
|----------------|-------------------|-------|
| Taming (Hunter) | Taming skill | Skill-based, no class requirement |
| Summoning (Warlock) | Summoning skill | Skill-based, no class requirement |
| Raising (Death Knight) | Necromancy skill | Skill-based, no class requirement |
| Vendor purchase | Regional vendor purchase | Requires faction standing |
| Quest reward | Task/Contract reward | No XP, gold/material rewards |
| Achievement reward | Achievement reward | Mortal achievement system |
| Rare drop | Rare drop (same) | Preserved, but drops companion item |
| Reputation reward | Faction standing reward | Faction standing system |

### 4.6 Pet Skill Requirements

**Taming Skill:**
- **Basic Pets:** Taming skill rank 1-25
- **Advanced Pets:** Taming skill rank 50-75
- **Elite Pets:** Taming skill rank 100

**Summoning Skill:**
- **Basic Demons:** Summoning skill rank 1-25
- **Advanced Demons:** Summoning skill rank 50-75
- **Elite Demons:** Summoning skill rank 100

**Necromancy Skill:**
- **Basic Undead:** Necromancy skill rank 1-25
- **Advanced Undead:** Necromancy skill rank 50-75
- **Elite Undead:** Necromancy skill rank 100

### 4.7 Pet-to-Companion Examples

#### Classic Hunter Pets

| Original Pet | Original Spell | Mortal Companion | Companion Type | Acquisition |
|--------------|----------------|-------------------|-----------------|--------------|
| Wolf | Tame Beast | Companion: Wolf | Pet | Taming skill rank 1 |
| Bear | Tame Beast | Companion: Bear | Pet | Taming skill rank 10 |
| Cat | Tame Beast | Companion: Cat | Pet | Taming skill rank 15 |
| Boar | Tame Beast | Companion: Boar | Pet | Taming skill rank 20 |
| Raptor | Tame Beast | Companion: Raptor | Pet | Taming skill rank 25 |

#### Classic Warlock Pets

| Original Pet | Original Spell | Mortal Companion | Companion Type | Acquisition |
|--------------|----------------|-------------------|-----------------|--------------|
| Imp | Summon Imp | Companion: Imp | Pet | Summoning skill rank 1 |
| Voidwalker | Summon Voidwalker | Companion: Voidwalker | Pet | Summoning skill rank 10 |
| Succubus | Summon Succubus | Companion: Succubus | Pet | Summoning skill rank 20 |
| Felhunter | Summon Felhunter | Companion: Felhunter | Pet | Summoning skill rank 30 |
| Infernal | Summon Infernal | Companion: Infernal | Pet | Summoning skill rank 50 |

#### Vanity Pets

| Original Pet | Original Item | Mortal Companion | Companion Type | Acquisition |
|--------------|--------------|-------------------|-----------------|--------------|
| Mechanical Squirrel | Item 11825 | Companion: Mechanical Squirrel | Pet (Cosmetic) | Vendor (Engineering) |
| Worg Pup | Item 34535 | Companion: Worg Pup | Pet (Cosmetic) | Quest reward |
| Lil' K.T. | Item 49646 | Companion: Lil' K.T. | Pet (Cosmetic) | Achievement reward |

### 4.8 Companion Item System

**Companion Items:**
- **Combat Companions:** Companion items (similar to Reins)
- **Cosmetic Companions:** Companion items (no combat)
- **Durability:** Combat companions have durability (like mounts)
- **Full Loot:** Combat companions drop on death (like mounts)

**Companion Item Structure:**
- Item entry (e.g., 73001 for Wolf Companion)
- Display ID (preserved from original pet)
- Use effect (summons companion)
- Durability (combat companions only)
- Bond/Hunger tracking (via `mortal_companions` table)

---

## 5. Companion Bond & Hunger

### 5.1 Shared Values

For all companions:

- **Hunger [0–100]**
  - Decays slowly during **active use**:
    - Pet in combat.
    - Merc following/engaged.
    - Mount being ridden.
- **Bond [0–100]**
  - Increases slowly when:
    - You fight with them.
    - You keep them well-fed.
    - You complete content (dungeons, contracts) with them alive.
  - Decreases slowly when:
    - You repeatedly neglect them (Hunger stays low for long).
    - They die frequently in short periods.

### 4.2 Mood Tiers

Mood tiers are derived from Hunger & Bond:

- **Neglected**
  - Hunger < 30 **or** Bond < 20.
- **Content**
  - Hunger 30–80 and Bond 20–70.
- **Devoted**
  - Hunger > 80 and Bond > 70.

You can refine thresholds later; this is a starting point.

---

## 5. Effects by Companion Type

### 5.1 Pets

Apply modifiers to pet stats/behavior:

- **Neglected**
  - Damage: **–10%**
  - Max HP: **–5%**
  - Obedience: small chance to delay or skip commanded abilities.

- **Content**
  - No modifier.

- **Devoted**
  - Damage: **+8–10%**
  - Max HP: **+5%**
  - Faster GCD reaction for script-driven abilities.

Existing hunter pet happiness functions can be reused as the underlying store for **pets**, with a translation layer to/from `mortal_companions` if desired.

### 5.2 Mercenaries

For mercs, Mood affects:

- Performance.
- Contract satisfaction.

- **Neglected**
  - Damage/Healing: **–10%**
  - Defense: **–5%**
  - After N minutes in Neglected state:
    - Merc may **refuse orders** or **leave** when contract ends.
    - Warning message to player.

- **Content**
  - No modifier.

- **Devoted**
  - Damage/Healing: **+5–8%**
  - Defense: **+5%**
  - Wage discount at renewal: e.g. –10%.
  - Flavor barks (protective lines when you’re low HP).

### 5.3 Mounts

Tie into Living Mounts:

- **Neglected**
  - Speed: **–5–10%** from tier baseline.
  - Durability loss on forced dismount: **+25–50%**.
  - Small chance to “spook” (short slow / stumble).

- **Content**
  - Normal tier speed/durability.

- **Devoted**
  - Speed: **+5%** (but capped globally).
  - Durability loss: **–25%**.
  - Reduced slowdown in rough terrain.

---

## 6. Feeding & Upkeep

### 6.1 Item Categories

Create simple feed items:

- **Pet Feed** (e.g. `Mortal Pet Ration`)
- **Mount Feed** (e.g. `Mortal Mount Oats`, `Mortal War Ration`)
- **Merc Upkeep**:
  - Mostly **gold wages**, optionally flavored with “Ration” items.

Each feed item:

- Restores **Hunger +X** (e.g. +40).
- Grants **Bond +1–3** (soft-capped over time).

### 6.2 Decay Rates (Initial Values)

- Hunger decays by ~**10 points per hour** of active use.
- Bond:
  - Gains ~**1 point per 15–30 minutes** of positive activity.
  - Loses ~**1 point per hour** of “starving use” or repeated death.

These numbers are easy to expose in config so you can tune based on actual playtests.

---

## 7. Healer Mercenaries for Dungeons

### 7.1 Role

Healer mercs fill the gap for:

- Small groups (2–3 players) wanting to run **normal/heroic dungeons**.
- Casual players in off-hours.

They are **not**:

- A replacement for real healers in high-tier raids.
- Allowed in top-tier Mortal content beyond a configured threshold.

### 7.2 Access Flow

1. Group talks to a **Dungeon Broker NPC** in a hub.
2. UI shows available merc templates:
   - “Mortal Field Medic (Healer, M-T2)”
   - “Mortal Veteran Templar (Healer, M-T3)”
3. Player pays:
   - Upfront fee (gold) for one dungeon.
   - Or a timed contract (e.g., 2 hours dungeon time).
4. On dungeon entry:
   - Merc spawns and joins the group as a creature with custom AI.
   - Bound to group leader or contract owner.

### 7.3 Restrictions

- **1 merc per group** (configurable).
- Allowed in:
  - Normal dungeons.
  - Heroic dungeons.
  - Maybe early raids (training/easy modes).
- Not allowed in:
  - High-end raids flagged as “M-T4+” content.
  - Warfront instances, Hellgates, high-stakes PvP environments.

### 7.4 Healer AI Behavior

Disc-priest/resto-shaman-style hybrid:

- Prioritizes:
  - Tank → lowest HP ally → emergency heals.
- Avoids:
  - Pulling threat by spamming big heals early.
  - Standing in obviously flagged “danger zones” (scripted mechanics).
- Handles:
  - Basic dispels, cleanses where appropriate.
  - Simple HoT/Shield upkeep.

This AI lives in:

- `scripts/mortal/mercs/merc_healer.cpp` or `merc_healer.lua`.

---

## 8. Separation from mod-playerbots

### 8.1 Playerbots Role

mod-playerbots should be configured to:

- Populate:
  - Cities, roads, inns → ambient life.
  - Public dungeons and Red zones → rival parties.
  - Large-scale PvP → extra bodies, if desired.

They are always treated as **independent AI-controlled players**, not companions.

### 8.2 Interactions with Merc System

- Mercs are **never** implemented as playerbots.
- You may, optionally:
  - Use playerbots as “rival mercenary companies” in world events.
  - But they should not be spawned as personal hirelings following a specific player.

This keeps:

- Performance manageable.
- Behavior predictable.
- Economy & balance easier to tune.

---

## 9. Hooks & Pseudocode

### 9.1 Shared Companion Updates (Pseudo C++/Lua Mix)

**OnLogin / OnSummon / OnMount:**

- Load `mortal_companions` row (or create default if missing).
- Apply Mood-based auras:
  - e.g., `SPELL_COMPANION_DEVOTED_BUFF`, `SPELL_COMPANION_NEGLECTED_DEBUFF`.

**Periodic Update (every 60s):**

- If companion is active:
  - `hunger = max(0, hunger - HUNGER_DECAY_RATE * dt)`
  - If `hunger < 30`:
    - Possibly reduce Bond slightly over longer periods.

**OnFeed (item use):**

```lua
function OnFeedCompanion(player, companion, feedItem)
  local comp = GetCompanionState(player, companion)
  comp.hunger = min(100, comp.hunger + feedValue)
  comp.bond = min(100, comp.bond + bondGain)
  SaveCompanionState(comp)
  ApplyMoodAuras(player, companion, comp)
end
```

**OnCompanionDeath:**

- If death is frequent in short time windows:
  - Decay Bond (small).

**OnContractEnd (Merc):**

- If Bond is low + Hunger was often neglected:
  - Merc leaves with a flavor line.
- If Bond is high:
  - Offer renewal discount.

---

## 10. File & Placement

Place this spec in your repo as:

- `docs/29-companion-bond-and-mercenary-system.md`

It depends on:

- `28-mounts-living-system-and-mapping.md` for mount integration.
- Existing hunter pet/pet happiness systems for pets (to be extended).
- No changes needed to:
  - Gear specs (`26`, `27`).
  - Launcher (`25`).
  - Atlas (`24`).

---

## 11. Status

This is now the **authoritative design** for:

- Unified Companion Bond & Hunger.
- Dedicated Mercenary framework (separate from mod-playerbots).
- Healer merc integration with dungeons.
- Mood-based bonuses/penalties for pets, mercs, and mounts.

From here, you can point Cursor at:

- This doc,
- Your DB schema,
- And existing Eluna/C++ hook locations,

and have it scaffold:

- DB migrations,
- C++/Lua scripts,
- And the in-game UI feedback for companions.
