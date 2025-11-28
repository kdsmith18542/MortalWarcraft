# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Combat & Progression Design  
### File: 64-spell-and-ability-library.md  
### Section: Spell & Ability Library for a Classless Mortal World

---

## 1. Goals

Define how **3.3.5a WoW spells and abilities** are:

- **Curated, re-tagged, and repurposed** for a **classless, skill-based**, full-loot sandbox.  
- Split into:
  - **Core universal abilities**,
  - **Learned skills (books/tomes)**,
  - **Runes / Weapon Arts (Elden-style spell-on-gear)**,
  - **Mastery actives & passives**,
  - **Augments & toggles**.

We want:

- Clear, **readable combat** in PvP,
- A toolkit that supports:
  - Martial, caster, hybrid, and support builds,
- No “I brought my retail WoW raid kit into a full-loot gankbox” nonsense.

This document defines the **rules and categories**; it is not a full spell-by-spell listing (Cursor-assisted tables can be generated later based on these rules).

---

## Related Specs

For full context on spell and ability systems, see:

- **`02-combat.md`** — Combat mechanics that use these spells and abilities
- **`75-mortal-gear-and-runes-spec.md`** — Rune system that provides weapon arts and abilities
- **`53-rune-augments-and-gear-build-system.md`** — Augment system that modifies abilities
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that affect spell power and ability effectiveness
- **`01-progression.md`** — Skill system that unlocks learned spells and abilities
- **`55-build-presets-and-loadouts.md`** — Build presets that configure ability loadouts

---

## 2. High-Level Philosophy

1. **Class Fantasy → Build Fantasy**  
   - No “Paladin” or “Mage” classes; instead:
     - You assemble a build from:
       - Weapon runes,
       - Learned spells,
       - Mastery choices,
       - Gear/attributes.

2. **Less Is More in Full Loot**  
   - Big raid/pvp kits with 30+ buttons are:
     - Bad to balance,
     - Bad for readability in full loot.
   - Target:
     - 8–12 meaningful combat buttons per build,
     - Plus utility/potions/flask.

3. **No Hard Immunity Chains**  
   - Immunities, infinite CC loops, and one-shot macros are gutted or removed.
   - Full-loot PvP must feel punishing but not hopeless.

4. **Loot & Learning**  
   - Most “powerful” skills are:
     - Found, crafted, or earned (books, runes, Trials),
     - Not just bought from a trainer.

5. **PvP-First Rules Where Necessary**  
   - Some abilities have:
     - Distinct PvP caps (duration caps, DR, reduced coefficients),
     - Or are **PvE-only** (no effect on players).

---

## 3. Ability Taxonomy

We divide the library into **five main types**:

1. **Core Universal Kit**
2. **Learned Skills (Books & Tomes)**
3. **Runes / Weapon Arts**
4. **Mastery Tree Actives & Passives**
5. **Augments, Toggles & Utilities**

### 3.1 Core Universal Kit

Every character has access to:

- Movement and interaction basics,
- Core defensive timing tools,
- Basic offense with their equipped weapon.

**Baseline abilities (examples):**

- **Basic Attack / Weapon Swing**
  - Single-target auto or semi-auto attack,
  - Scales with weapon + attributes.

- **Brace**
  - As already defined:
    - Off-GCD, 0.75s 50% damage reduction, 5s CD.

- **Block / Parry / Guard Counter Hooks**
  - Implemented via:
    - Use of shield or parry-capable weapon,
    - Successful block/parry → triggers “Opportunity” buff.

- **Interrupt / Bash / Kick**
  - Short cast-interrupt, small lockout.
  - Every build should be able to access **some** form of interrupt:
    - Either via weapon choice, rune, or learned generic skill.

- **Flask Use**
  - Crimson Phial (or variant),
  - 2–3 charges, refills only at Shrines/Inns.

- **Core Utility**
  - Basic bandage use (First Aid),
  - Basic torch/light interaction,
  - Mount cast (if you have reins item).

These are implemented as:

- A small set of **always-available spells**,
- Possibly backed by existing WoW spell entries with flags tying them to all characters.

---

### 3.2 Learned Skills (Books & Tomes)

These are **general-purpose abilities** not tied to a specific weapon:

- Purchased,
- Found as drops,
- Rewarded from Trials/Factions,
- Or learned from rare books.

Examples:

- Basic self-heals,
- Short-duration buffs or shields,
- Simple offensive spells or shots.

**Acquisition:**

- Items: "Tome of X", "Manual: Y".
- Use item → teaches spell if you meet prerequisites:

## 3.2.1 Complete Ability Unlock System

This section defines the comprehensive system for unlocking abilities in Mortal Warcraft's classless, skill-based progression.

### Ability Unlock Methods

**1. Skill-Based Unlocks:**
- Abilities unlock automatically when skill thresholds are met
- Example: "Fireball" unlocks at Magic Affinity: Fire rank 25
- Example: "Whirlwind" unlocks at Weapon Mastery: Swords rank 50
- Example: "Heal" unlocks at Magic Affinity: Arcane rank 30

**2. Item-Based Unlocks (Books & Tomes):**
- Use item → teaches spell if prerequisites met
- Prerequisites: Skill ranks, attributes, derived level
- Example: "Tome of Fireball" requires Magic Affinity: Fire rank 25, Intellect 50
- Example: "Manual: Whirlwind" requires Weapon Mastery: Swords rank 50, Strength 60

**3. Faction Standing Unlocks:**
- Abilities unlock via faction standing milestones
- Example: "Ledger Merchant" abilities unlock at Ledger standing 1000
- Example: "Shrine Devotee" abilities unlock at Shrine standing 1500
- Example: "Military Campaign" abilities unlock at Military standing 2000

**4. Trial/Challenge Unlocks:**
- Abilities unlock by completing Trials or challenges
- Example: "Shrine Trials" unlock shrine-themed abilities
- Example: "Combat Trials" unlock combat abilities
- Example: "Crafting Trials" unlock crafting abilities

**5. Rune-Based Unlocks:**
- Abilities unlock via Runes (weapon arts)
- Runes provide abilities when equipped
- Example: "Rune: Whirlwind" provides Whirlwind ability when equipped
- Example: "Rune: Fireball" provides Fireball ability when equipped

**6. Mastery Tree Unlocks:**
- Abilities unlock via Mastery tree progression
- Example: "Warlord Mastery" unlocks Warlord-themed abilities
- Example: "Guardian Mastery" unlocks Guardian-themed abilities
- Example: "Explorer Mastery" unlocks Explorer-themed abilities

### Ability Unlock Prerequisites

**Skill Prerequisites:**
- **Combat Abilities:** Require relevant combat skill ranks
  - Weapon abilities: Weapon Mastery rank 25-100
  - Magic abilities: Magic Affinity rank 25-100
  - Defense abilities: Defense rank 25-100
- **Crafting Abilities:** Require relevant crafting skill ranks
  - Blacksmithing abilities: Blacksmithing rank 25-100
  - Alchemy abilities: Alchemy rank 25-100
- **Utility Abilities:** Require relevant utility skill ranks
  - Stealth abilities: Stealth rank 25-100
  - Lockpicking abilities: Lockpicking rank 25-100

**Attribute Prerequisites:**
- **Strength-Based Abilities:** Require Strength 50-150
- **Agility-Based Abilities:** Require Agility 50-150
- **Intellect-Based Abilities:** Require Intellect 50-150
- **Stamina-Based Abilities:** Require Stamina 50-150
- **Spirit-Based Abilities:** Require Spirit 50-150

**Derived Level Prerequisites:**
- **Basic Abilities:** Derived Level 1-5
- **Intermediate Abilities:** Derived Level 6-15
- **Advanced Abilities:** Derived Level 16-25
- **Elite Abilities:** Derived Level 20-25

**Faction Standing Prerequisites:**
- **Basic Faction Abilities:** Standing 500-1000
- **Intermediate Faction Abilities:** Standing 1000-2000
- **Advanced Faction Abilities:** Standing 2000-3000
- **Elite Faction Abilities:** Standing 3000+

### Ability Unlock Progression

**Tier 1 Abilities (Early Game):**
- Unlock at skill rank 1-25
- Basic combat abilities (Basic Attack, Brace, Block)
- Basic utility abilities (Bandage, Torch, Mount)
- No prerequisites beyond skill rank

**Tier 2 Abilities (Mid Game):**
- Unlock at skill rank 26-50
- Intermediate combat abilities (Fireball, Whirlwind, Heal)
- Intermediate utility abilities (Stealth, Lockpicking)
- Require skill rank + attributes (50+)

**Tier 3 Abilities (Late Game):**
- Unlock at skill rank 51-75
- Advanced combat abilities (Chain Lightning, Shield Bash, Greater Heal)
- Advanced utility abilities (Advanced Stealth, Advanced Lockpicking)
- Require skill rank + attributes (75+) + derived level (10+)

**Tier 4 Abilities (End Game):**
- Unlock at skill rank 76-100
- Elite combat abilities (Meteor, Devastate, Mass Heal)
- Elite utility abilities (Master Stealth, Master Lockpicking)
- Require skill rank + attributes (100+) + derived level (20+) + faction standing (2000+)

### Ability Unlock Examples

**Combat Ability Unlocks:**

| Ability | Unlock Method | Prerequisites | Tier |
|---------|---------------|---------------|------|
| Fireball | Skill-based | Magic Affinity: Fire rank 25, Intellect 50 | Tier 2 |
| Whirlwind | Item-based (Tome) | Weapon Mastery: Swords rank 50, Strength 60 | Tier 2 |
| Heal | Skill-based | Magic Affinity: Arcane rank 30, Intellect 50 | Tier 2 |
| Chain Lightning | Skill-based | Magic Affinity: Arcane rank 60, Intellect 75, Derived Level 10 | Tier 3 |
| Meteor | Item-based (Rare Tome) | Magic Affinity: Fire rank 90, Intellect 120, Derived Level 20, Faction Standing 2000 | Tier 4 |

**Utility Ability Unlocks:**

| Ability | Unlock Method | Prerequisites | Tier |
|---------|---------------|---------------|------|
| Stealth | Skill-based | Stealth rank 25, Agility 50 | Tier 2 |
| Lockpicking | Skill-based | Lockpicking rank 25, Agility 50 | Tier 2 |
| Advanced Stealth | Skill-based | Stealth rank 60, Agility 75, Derived Level 10 | Tier 3 |
| Master Stealth | Item-based (Rare Manual) | Stealth rank 90, Agility 120, Derived Level 20 | Tier 4 |

**Faction Ability Unlocks:**

| Ability | Unlock Method | Prerequisites | Tier |
|---------|---------------|---------------|------|
| Ledger Merchant Discount | Faction standing | Ledger standing 1000 | Tier 2 |
| Shrine Blessing | Faction standing | Shrine standing 1500 | Tier 2 |
| Military Campaign Bonus | Faction standing | Military standing 2000 | Tier 3 |
| Elite Faction Ability | Faction standing | Faction standing 3000+ | Tier 4 |

### Ability Unlock Tracking

**Unlocked Abilities Database:**
- Track unlocked abilities per character
- Store unlock method, unlock date, prerequisites met
- Query for available abilities based on current skills/attributes

**Ability Availability UI:**
- Show available abilities (unlocked, prerequisites met)
- Show locked abilities (prerequisites not met)
- Show unlock progress (skill rank progress, attribute progress)

**Ability Unlock Notifications:**
- Notify player when ability unlocks
- Show unlock method (skill-based, item-based, faction-based)
- Highlight new abilities in ability library

### Ability Unlock Balance

**No Mandatory Unlocks:**
- Players can achieve power without unlocking all abilities
- Abilities are **sidegrades**, not mandatory power
- Multiple viable builds without full ability library

**Unlock Diversity:**
- Multiple unlock paths for same ability (skill-based OR item-based)
- Players can choose unlock method based on playstyle
- No single "correct" unlock path

**Unlock Pacing:**
- Early abilities unlock quickly (skill rank 1-25)
- Mid-game abilities unlock gradually (skill rank 26-50)
- Late-game abilities unlock slowly (skill rank 51-100)
- End-game abilities unlock very slowly (skill rank 76-100 + requirements)

---
  - Required attributes or skill disciplines,
  - Faction standing, etc.

**Examples of reinterpretation:**

- Old “Lesser Heal”, “Heal”, “Greater Heal”:
  - Collapsed into **one scalable “Channel Heal” family**, maybe with variants:
    - `Mortal_Heal_Short` (fast, small),
    - `Mortal_Heal_Long` (slow, big).
- Old “Power Word: Shield”:
  - Becomes a **Learned Skill** only accessible if:
    - You meet Spiritual/Intellect thresholds,
    - Or unlock via Shrine Trials.

**Rank Handling:**

- All multi-rank spells are:
  - Collapsed into **a single rank** which scales with:
    - Attributes,
    - Skill proficiencies,
    - Possibly gear tier.

Implementation:

- Keep one Spell ID per functional ability,
- Remove older ranks from trainers,
- Map books/tomes to these unified IDs.

---

### 3.3 Runes / Weapon Arts

These are **Elden Ring-style Ashes of War**:

- They are **items** (Runes) applied to weapons or armor,
- Grant **one active ability or strong passive modifier**,
- If you lose the item (full loot), you lose that ability (but keep appearance unlock if we want).

**Rune rules:**

- Each weapon has:
  - One primary Rune slot (Weapon Art),
  - Optional secondary slot for a smaller effect (later).
- Each Rune:
  - Is tied to a **category**:
    - Martial, Arcane, Spiritual, Primal, Support, Utility.

**Examples of WoW spells turned into Runes:**

- `Whirlwind`:
  - Rune of Whirling Steel: Sword/Axe 2H only.
- `Mortal Strike`:
  - Rune of Mortal Strike: physical weapon family,
  - Adds high-damage, anti-healing strike.
- `Blink`:
  - Rune of Flickering Step: staves/wands or light weapons only, short-range teleport.
- `Earth Shock / Flame Shock`:
  - Rune of Earthshock: triggered melee shock with debuff.

**Balance constraints:**

- High-impact mobility (Blink/Charge):
  - Tied to Runes with clear weapon category,
  - PvP max range and CD tuned conservative.
- Runes can be:
  - Crafted (high-end professions),
  - Dropped in Rifts, Hellgates, Trials,
  - Or tied to specific Factions.

---

### 3.4 Mastery Tree Actives & Passives

**Mastery Trees: Warlord / Guardian / Explorer**

Each tree provides:

- A small number of **signature actives**,
- A suite of **passive modifiers**.

Examples:

- **Warlord**
  - Actives:
    - Rallying Cry: short group buff (HP & resilience).
    - War Banner: temporary area buff for allies, slight debuff for enemies.
  - Passives:
    - Increased Weapon Art effectiveness,
    - Slight bonuses to physical damage & crit under specific conditions.

- **Guardian**
  - Actives:
    - Bulwark Stance: temporary mitigation/taunt-like effect.
    - Aegis: short, moderate group shield.
  - Passives:
    - Brace/Guard Counter enhancements,
    - Increased block value / resistances.

- **Explorer**
  - Actives:
    - Pathfinder’s Step: short sprint / mobility skill.
    - Scout’s Mark: mark a target for increased reward/vision.
  - Passives:
    - Enhanced movement speed out of combat,
    - Better resource gain from exploration/contracts.

Implementation:

- Many Mastery tree abilities can reuse existing WoW spells with:
  - New descriptions & tuned effects,
  - Bound to Mastery point investments instead of classes.

---

### 3.5 Augments, Toggles & Utilities

These are:

- **Smaller spell effects** and buffs,
- Often tied to:
  - Enchants,
  - Gems,
  - Alchemical effects,
  - Profession perks.

Rather than leaving WotLK’s whole enchant/gem zoo, we:

- Convert many buff spells into:
  - **Augment Auras** (small, always-on passive),
  - Or **short-duration toggles** that cost flask charges, reagents, or have real opportunity cost.

Examples:

- Old “Blessing of Kings”, “Mark of the Wild”:
  - Become generic **“Frontier Blessing”** or “Wild Aspect” auras:
    - Slight stat smoothing,
    - Not stacking with each other,
    - Provided by consumables or trials, not class.

---

## 4. Healing & Support Design

We want healing to feel:

- Meaningful in PvE and group content,
- Limited and risky in open-world full-loot PvP.

### 4.1 Healing Archetypes

We borrow playstyle from:

- **Disc Priest** (shields + damage → healing),
- **Resto Druid** (HoTs & mobility),
- **Resto Shaman** (totems & burst),
- But **without** needing four separate classes.

Instead, we define **healing “lines”**:

1. **Aegis Line** (Shields & Mitigation)
   - Core: shield-type spells, mitigation cooldowns.
   - Source:
     - Shrine Trials,
     - Guardian Mastery,
     - Certain Faction reputations.

2. **Renewal Line** (HoTs & Regrowth)
   - Core: heal-over-time spells, regen buffs.
   - Source:
     - Rangers’ Pact,
     - Alchemical/Primal runes,
     - Trials focused on attrition.

3. **Surge Line** (Bursts & Totems)
   - Core: short-duration totems, strong but costly bursts.
   - Source:
     - Iron Ledger or Cartel contracts (bought/smuggled rituals),
     - Specific Runes.

### 4.2 Healer Mercs

We’ve specced:

- Dedicated **Healer Mercenaries** independent of playerbots.

In ability terms:

- Merc kits are:
  - Curated from the same healing lines,
  - Hard-capped in output,
  - Built around:
    - Moderate AoE heal,
    - Single-target support,
    - One or two defensive CDs.

---

### 4.3 Healing in PvP

To keep fights lethal:

- Healing spells:
  - Have **reduced coefficients in PvP**, or
  - Are **limited by Flask/charge systems** (no infinite sustain).
- Anti-healing mechanics:
  - Some Weapon Runes provide Mortal Strike–style healing reduction.
- Group fights:
  - Encouraged to be about:
    - Positioning,
    - Timing,
    - Focus fire,
  - Not indefinite stalemates.

---

## 5. Crowd Control, Mobility & Burst Rules

Full-loot PvP needs **strict CC rules**.

### 5.1 CC Categories

We define three main CC categories:

1. **Soft CC**
   - Slows, minor snares, disarms, brief silences.
   - Very common, longer durations ok.

2. **Hard CC**
   - Stuns, incapacitates, long silences, fears, polymorphs.
   - Strict caps and DR in PvP.

3. **Control-Ultimates / “Stop Buttons”**
   - Big AoE disorients, mass fears, long incapacitates.
   - Mostly **removed** or restricted to PvE.

### 5.2 Hard Rules

- No **chainable hard CC** that keeps a single target locked for > ~6–8 seconds without clear counterplay.
- Many of the more abusive CC spells:
  - Are disabled in PvP,
  - Or heavily shortened (and flagged “PvE-extended”).

- Example conversions:
  - `Polymorph`:
    - PvP:
      - Short duration (e.g. 4s max),
      - Heavy DR on repeated casts.
    - PvE:
      - Longer, as normal.
  - `Fear`:
    - Heavily reduced duration,
    - Possibly replaced with “Panic” (short disorient) in PvP.
  - `Stuns`:
    - No more than X seconds in PvP,
    - DR across all stun sources.

---

### 5.3 Mobility & Gap-Closers

- Mobility abilities (Charge, Blink, Sprint, Dash) are:

  - Mostly **Weapon Runes** or Mastery perks,
  - Limited to:
    - Reasonable cooldowns,
    - Clear telegraph.

- No:
  - Stacking multiple long-range gap closers into infinite hyper-mobility.
- PvP tuning:
  - Charge range capped,
  - Blink limited to line-of-sight and maybe no vertical cheese.

---

### 5.4 Burst Damage

- Extremely front-loaded burst combos from original WotLK:
  - Are tuned down via:
    - Global damage coefficients,
    - Longer CDs,
    - Or splitting effects into multiple smaller hits (more room for reaction).

- Goal:
  - A good ambush kills you in 2–5 GCDs if you’re unprepared,
  - Not in 0.3 seconds through full flask + Brace uptime.

---

## 6. Resources & Scaling

### 6.1 Resource Model

We keep the **Mana** concept and genericize physical resource use:

- **Mana**
  - Used by:
    - Magical, spiritual, and some support abilities.
  - Scales with:
    - Intellect,
    - Certain Mastery and Faction perks.

- **Stamina / Focus (under the hood)**
  - Many warrior/rogue/hunter-style abilities:
    - Use cooldowns and internal cost logic,
    - But we present them as:
      - “Stamina cost” in tooltip for flavor (backed by rage/energy/focus behind the scenes).

Practical rule:

- Builds naturally align:
  - Martial → lots of cooldown-based physical skills.
  - Caster → depend heavily on mana pool and regen.
  - Hybrid → mix both, but with inherent tradeoffs.

### 6.2 Rank & Level Scaling

All spells:

- Use a **single functional version** that scales through:
  - Attributes (Str/Agi/Int/Spi),
  - Skill proficiencies,
  - Gear tier (Mortal T1–T5).

Dynamic Level (Skills / 50):

- Contributes via:
  - Derived stats (HP, crit chance, etc.),
  - But doesn’t gate learning spells directly.

---

## 7. Mapping Legacy Spells to Mortal Categories

Instead of a full list, we define **rules** to apply when we convert the Spell.dbc:

1. **Class-defining nukes / core attacks**  
   → **Runes or Learned Skills**

   - Examples:
     - Frostbolt, Fireball, Shadow Bolt, Sinister Strike, Heroic Strike, Aimed Shot, etc.
   - We pick:
     - A small subset of each school,
     - Turn them into:
       - Baseline learned spells **or**
       - Weapon Runes with clear identities.

2. **Class buffs & auras**  
   → **Augments / Toggles**

   - Blessings, Marks, Totems, Shouts:
     - Rolled into:
       - Universal “Frontier Blessings”,
       - Faction-flavored auras,
       - Short toggles, not always-on stacking buffs.

3. **CC spells**  
   → **Pruned & PvP-capped**

   - Fears, polymorphs, stuns, etc.:
     - Categorized and tuned as per CC rules,
     - Many removed in PvP context or shortened.

4. **Raid / group CDs and big immunities**  
   → **Removed or Trials-only PvE tools**

   - Divine Shield, Ice Block, Time Warp, etc.:
     - Either disabled entirely,
     - Or converted into:
       - Rare, PvE-oriented Runes or Trial rewards with no PvP effect.

5. **Niche spells & utility**  
   → **Factions & Exploration**

   - Tracking, water walking, underwater breathing, etc.:
     - Become:
       - Explorer Mastery perks,
       - Rangers’ Pact runes,
       - Rare consumables.

---

## 8. Implementation Checklist

1. **Tagging & Tables**
   - Add a custom `mortal_spell_tags` table:
     - `spell_id`, `category`, `subcategory`, `pvp_flags`, `source_type (RUNE/BOOK/MASTERY)`.
   - Use this to:
     - Drive loadout building,
     - Enforce PvP caps.

2. **Rank Pruning**
   - Script to:
     - Disable lower ranks,
     - Map all trainers/books to consolidated spell IDs.

3. **Rune Library Definition**
   - Design initial Rune set:
     - 1–2 offensive, 1 utility, 1 defensive per weapon family.
   - Map to:
     - Drop tables,
     - Crafting outputs,
     - Trial/Faction rewards.

4. **Healer & Support Lines**
   - Select:
     - 3–5 core heal spells,
     - 2–3 shield/mitigation spells,
     - A few totem/HoTs,
   - Assign them across:
     - Learned Skills,
     - Runes,
     - Mastery abilities,
   - Tune PvP coefficients.

5. **CC & Mobility Pass**
   - Tag all CC/mobility spells,
   - Apply:
     - Duration caps,
     - DR rules,
     - PvP disable flags if needed.

6. **UI & Loadout Management**
   - MortalUI:
     - Build Loadout screen:
       - Shows available Learned Skills,
       - Shows Runes installed,
       - Highlights Mastery actives.
   - Enforce:
     - Active ability cap (e.g., 12 combat actives).

---

This document should be used as the **master reference** when you or Cursor run through Spell.dbc / spell_template definitions and mass-tag/convert abilities into Mortal-appropriate categories.

Separate, generated tables (by script) can later list each spell, its new category, and final tuning based on these rules.
