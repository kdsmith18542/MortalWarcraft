# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.3 — Itemization & Content  
### File: 79-drop-mapping-t1-t2-gear-and-runes.md  
### Section: Drop Mapping for T1/T2 Gear Sets & Rune Families

---

## 1. Purpose

This document defines **where** (which dungeons, Contracts, events, and vendors) the **T1/T2 gear sets and Rune families** are obtained.

It connects:

- Concrete sets from:
  - `77-mortal-itemization-t1-t2-starter-sets.md`  
  - `78-mortal-itemization-healer-ranger-mage.md`
- To content categories:
  - Onboarding quests, Task Boards, Contracts 2.0,
  - Public delves & early dungeons,
  - Stronghold & Faction vendors,
  - Early Rifts / Anomalies / Events.

Scope: **T1 (Settler/Apprentice) and T2 (Frontier) only.** Higher tiers (T3–T5) are handled elsewhere.

---

## Related Specs

For full context on drop mapping and loot sources, see:

- **`77-mortal-itemization-t1-t2-starter-sets.md`** — T1/T2 starter sets that these drops provide
- **`78-mortal-itemization-healer-ranger-mage.md`** — Healer, ranger, and mage sets that these drops provide
- **`75-mortal-gear-and-runes-spec.md`** — Core gear and rune system that defines drop tiers
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task boards and contracts that provide gear drops
- **`06-pve.md`** — PvE content (dungeons, delves) that provides gear drops
- **`03-risk-zones.md`** — Risk zones that affect drop rates and loot rules
- **`19-itemization.md`** — Overall itemization philosophy and tier mapping

---

## 2. Content Tier Overview

### 2.1 T1 Content Band — “Settler / Apprentice”

Intended for:

- Characters roughly at **Skill Tier 1–2** (dynamic level ≈ 2–4),
- Operating mainly in:
  - **Green Zones** (Safe),
  - Edges of **early Yellow Zones**.

Primary content sources:

- Shipwreck Cove tutorial completion,
- Port Meridian introductory arcs,
- Early Task Boards & Contracts in Green zones,
- First public delves / low dungeons:
  - *Deadmines* (De-Instanced / layered),
  - *Wailing Caverns* (Entry wing only),
  - Low-level “Public Dungeon” events.

### 2.2 T2 Content Band — “Frontier”

Intended for:

- Characters roughly at **Skill Tier 3–4** (dynamic level ≈ 4–8),
- Operating mainly in:
  - **Yellow Zones** (Skulled),
  - Very early steps into **Red Zones** with groups.

Primary content sources:

- Greycrag & Frontier settlement arcs,
- Yellow-zone Task Boards & Contracts,
- Proper delves / mid dungeons:
  - *Shadowfang Keep*, *Scarlet Monastery* (reworked wings),
  - Open-world dungeon layers in *STV* / *Barrens*,
- Early Stronghold & Warfront-related contracts,
- Early Rift / Anomaly content.

---

## 3. Gear Sets — Drop Mapping

For each archetype, we define:

- **Primary Sources** (main intended path),
- **Secondary Sources** (backup paths, vendors, crafting),
- **Restrictions** (no world drops, or specific faction requirements).

### 3.1 Frontier Bruiser

Sets:

- **T1:** Greycrag Militia (militia-style medium/heavy armor, 1H sword).  
- **T2:** Linebreaker Vanguard (frontier war-gear, 2H axe variant).

#### 3.1.1 Greycrag Militia (T1)

**Primary Sources**

1. **Port Meridian Militia Arc (Questline)**
   - Location: Port Meridian (Mainland hub).
   - Short quest chain:
     - “Call to the Line” → Boots & Gloves,
     - “First Patrol” → Helm,
     - “Hold the Crossing” (public event) → Chest,
     - “Militia Muster” (group event) → Weapon.
   - Guaranteed pieces but spread across tasks and events.

2. **Green-Zone Task Boards**
   - Boards: Port Meridian, nearby villages.
   - Task types:
     - Cull Tasks vs local bandits/wolves,
     - Guard mini-escorts.
   - Reward pool:
     - Militia ring & necklace,
     - Small chance at weapon off the final Task in a chain.

3. **Low Dungeons (Public Delves)**
   - *Deadmines (Lower Layers)*:
     - Militia weapons & chest have small drop chance on named minibosses.

**Secondary Sources**

- **Militia Quartermaster Vendor**
  - Port Meridian barracks.
  - Currency:
    - Militia Service Tokens from Tasks/Events.
  - Can buy:
    - Missing Greycrag Militia pieces (at modest cost),
    - Ensures completion for unlucky players.

**Restrictions**

- Greycrag Militia items **do not drop from random open-world mobs**.
- Focus is on **structured early content** (quests, boards, delves).

---

#### 3.1.2 Linebreaker Vanguard (T2)

**Primary Sources**

1. **Greycrag Frontier Contracts**
   - Board: Greycrag Stronghold.
   - Contracts:
     - Stronghold defense,
     - Caravan guard into Yellow zones,
     - Elite Cull missions near frontier lines.
   - Rewards:
     - Each completed contract roll can yield:
       - Linebreaker gloves/boots/helm/ring.

2. **Yellow-Zone Public Dungeons**
   - Examples:
     - *Shadowfang Keep (Open or layered)*,
     - *Scarlet Monastery: Graveyard & Armory,* tuned as frontier delves.
   - Drop mappings:
     - Helm/Chest from final bosses,
     - Legs/Gloves/Boots from mid-bosses,
     - 2H War-Axes from specific elite encounters.

3. **Early Warfront Skirmish Rewards**
   - Warfront variant: **Arathi Skirmishes** (small-scale, not full Warfront).
   - Participation tokens:
     - Turned in at Warfront Quartermaster for Linebreaker Rings/Necklaces.

**Secondary Sources**

- **Frontier Smith Crafting**
  - Recipe source:
    - T2 smithing blueprints drop in Yellow-zone delves and Contracts.
  - Crafted Linebreaker pieces:
    - Require frontier materials (e.g., Hardened Iron, Leather, Flux),
    - Stat-equivalent to dropped versions.

**Restrictions**

- Linebreaker Vanguard is **frontier-tied**:
  - No drops in pure Green zones,
  - No pure vendor set: always requires some Contracts or delves.

---

### 3.2 Waywatcher Arcanist (Hybrid Caster/Scout)

Sets:

- **T1:** Port Meridian Adept.  
- **T2:** Waywatcher’s Pact.

#### 3.2.1 Port Meridian Adept (T1)

**Primary Sources**

1. **Academy Initiation Arc**
   - Quest arc from Arcane Academy in Port Meridian:
     - “Spark of the Mainland” → Boots/Gloves,
     - “Lessons in Ether” → Helm,
     - “First Field Exam” (open-world Ether anomaly event) → Chest/Legs,
     - Final exam instance (mini-scenario) → Staff.
   - Guarantees full set if completed.

2. **Green-Zone Task Boards (Academy Branch)**
   - Board: Academy Wing.
   - Tasks:
     - Investigation/Scout tasks using lenses,
     - Small Ether rift closures.
   - Rewards:
     - Adept rings and necklaces.

**Secondary Sources**

- **Academy Vendor**
  - Sells Adept accessories and off-hand items for:
    - Academy Seals (earned via Tasks/Quests).

---

#### 3.2.2 Waywatcher’s Pact (T2)

**Primary Sources**

1. **Ranger–Arcanist Joint Contracts**
   - Boards: Ranger outposts near Yellow-zone treelines.
   - Contracts:
     - “Ether Trail Hunts” (track anomalies),
     - “Skyline Survey” (scout high cliffs / towers),
     - “Rift Sniper Support” (assist in Rifts at range).
   - Rewards:
     - Waywatcher’s hood/gloves/boots,
     - Chance at Waywatcher’s staff.

2. **Yellow-Zone Rifts / Anomalies**
   - Rifts in Duskwood, Barrens, and other contested zones:
     - Rare rewards include Waywatcher chest/legs and rune fragments.

3. **Public Dungeons with Ether Focus**
   - Reworked zones:
     - Parts of *Maraudon* or *Zul’Farrak* acting as Ether-infested delves.
   - Boss drops:
     - Higher-chance for Waywatcher’s rings/necklaces.

**Secondary Sources**

- **Ranger–Academy Joint Vendor**
  - Requires combined rep:
    - Rangers + Academy.
  - Stocks:
    - Specific missing pieces,
    - Cosmetic recolors of Waywatcher gear (for prestige only).

---

### 3.3 Sanctum Warden (Dedicated Healer)

Sets:

- **T1:** Shrine Acolyte.  
- **T2:** Sanctum Warden’s Regalia.

#### 3.3.1 Shrine Acolyte (T1)

**Primary Sources**

1. **Shrine Initiation Arc**
   - Questline starting at first major Shrine:
     - “A Light in the Wreckage” → Ring,
     - “Hands of the Faithful” → Gloves,
     - “Tending the Fallen” (post-battle event) → Boots,
     - “Acolyte’s Oath” (ritual scenario) → Chest/Helm,
     - “Pilgrim’s First Vigil” → Mace.
   - Provides close to a full set.

2. **First Aid & Healing Tasks**
   - Board: Shrine and field infirmaries.
   - Tasks:
     - Bandage wounded NPCs after skirmishes,
     - Deliver herbs/medical supplies.
   - Rewards:
     - Pants/Necklace,
     - Additional rings.

**Secondary Sources**

- **Shrine Quartermaster**
  - Currency: Shrine Favour (rep + tokens).
  - Sells:
    - Missing Acolyte pieces,
    - Basic healing Runes (T1).

---

#### 3.3.2 Sanctum Warden’s Regalia (T2)

**Primary Sources**

1. **Shrine Defense & Vigil Events**
   - Zone events:
     - Shrine siege defenses,
     - Ether cleansing rituals (group events).
   - Rewards:
     - Sanctum chest/legs/helm, small chance per event.

2. **Dungeon Healer Achievements**
   - Completing:
     - Public dungeons and early instances (e.g., reworked SM wings, Uldaman segments)
     - With no NPC deaths or low player deaths.
   - Reward pool:
     - Gloves/boots/rings/necklaces for Sanctum set.

3. **Shrine Contracts**
   - Holy-focused Contracts from Shrine Board:
     - Escort relic caravans,
     - Protect pilgrim processions in Yellow zones.
   - Higher chance of Sanctum weapons and accessories.

**Secondary Sources**

- **High Shrine Vendor**
  - Requires:
    - High Shrine reputation rank.
  - Sells:
    - Select Sanctum Warden pieces,  
    - Higher-tier healing Runes (Vital Current, Ether Aegis) for tokens.

---

### 3.4 Longroad Ranger (Ranged Physical DPS)

Sets:

- **T1:** Greenway Scout.  
- **T2:** Longroad Ranger’s Harness.

#### 3.4.1 Greenway Scout (T1)

**Primary Sources**

1. **Ranger Patrol Arc**
   - Questline in Greenway borderlands:
     - Patrol, tracking, and ambush quests.
   - Rewards:
     - Core armor pieces and bow.

2. **Green-Zone Ranger Tasks**
   - Board: Ranger outpost.
   - Tasks:
     - Scout tasks, wolf/bandit culls,
     - Basic courier runs along roads.
   - Rewards:
     - Rings, necklaces, and occasional boots/gloves.

**Secondary Sources**

- **Ranger Outpost Vendor**
  - Currency: Ranger Marks.
  - Sells:
    - Missing Greenway Scout pieces,
    - Mobility and vision Runes (Keen Eye, Hunter’s Step).

---

#### 3.4.2 Longroad Ranger’s Harness (T2)

**Primary Sources**

1. **Yellow Road Caravan Contracts**
   - Boards: Greycrag & Ranger outposts.
   - Contracts:
     - Escort caravans through Yellow zones,
     - Hunt down road bandit camps,
     - Secure ambush sites.
   - Rewards:
     - Longroad chest/legs/helm/gloves,  
     - Longroad bows.

2. **Road Boss Events**
   - Special world bosses that roam major roads:
     - Highwaymen captains, mounted raiders.
   - Drops:
     - Boots, rings, and necklaces of Longroad set,
     - High chance for Ranger-themed Runes (Trapline, Marked Prey).

3. **Small-Scale Warfront Skirmishes**
   - Ranged participation gets extra weight for:
     - Longroad accessories and Rune fragments.

**Secondary Sources**

- **Ranger Master Vendor**
  - Gated by:
    - Mid-level Ranger reputation.
  - Sells:
    - Some Longroad pieces & advanced Ranger Runes.

---

### 3.5 Spellfire Magus (Pure Mage)

Sets:

- **T1:** Sparkweaver Apprentice.  
- **T2:** Spellfire Magus Regalia.

#### 3.5.1 Sparkweaver Apprentice (T1)

**Primary Sources**

1. **Sparkweaver Academy Arc**
   - Parallel to Adept path but pure-offense focused:
     - Training & safety violation quests,
     - Ether overload incidents.
   - Rewards:
     - Core armor pieces plus staff.

2. **Green-Zone Anomaly Cleanup Tasks**
   - Boards: Academy, Port Meridian.
   - Tasks:
     - Close unstable Ether spots,
     - Test prototype spells in controlled areas.
   - Rewards:
     - Rings/necklaces,
     - Basic offensive Runes (Firebolt, Ember Shield).

**Secondary Sources**

- **Academy Offensive Specialist Vendor**
  - Currency: Spark Tokens (earned via anomaly tasks).
  - Sells:
    - Missing Sparkweaver pieces,
    - Entry-level nuke runes.

---

#### 3.5.2 Spellfire Magus Regalia (T2)

**Primary Sources**

1. **Yellow-Zone Destructive Contracts**
   - Boards: Academy & Cartel-linked outposts.
   - Contracts:
     - “Spellfire Trials” (stress-test spells against elite mobs),
     - “Annihilation Tasks” (high-damage requirements).
   - Rewards:
     - Spellfire armor/trinkets and staff.

2. **Rift-Collapse Events**
   - Large-scale Ether Rift closures:
     - Group events in Yellow/early Red zones.
   - Boss & chest drops:
     - Spellfire items,
     - High-powered offensive Runes (Flame Burst, Overchannel).

3. **Public Dungeons with Arcane Themes**
   - Reworked:
     - Upper segments of Uldaman, or arcane-themed wings elsewhere.
   - Drops:
     - Mix of Spellfire gear and Mage rune fragments.

**Secondary Sources**

- **Spellfire Cartel Vendor**
  - Requires:
    - Mid-tier Cartel reputation,
    - Ether shards as currency.
  - Sells:
    - Select Spellfire items and risky Runes (Overchannel).

---

## 4. Rune Families — Acquisition Mapping

This section abstracts away from specific sets and focuses on **Rune families** and their primary content hooks.

### 4.1 T1 Rune Families

- **Basic Combat Runes**  
  - Examples: Rune of Cleaving Strike, Rune of Arcane Bolt, Firebolt.  
  - Sources:
    - Early Academy/Militia/Ranger questlines,
    - Green-Zone Task Boards,
    - Low public delves.

- **Basic Guard Runes**  
  - Examples: Guarded Brace, Ember Shield.  
  - Sources:
    - Shipwreck Cove tutorial follow-ups,
    - Shrine/Ranger intro events,
    - Vendor unlocks at Reputation Rank 1–2.

- **Basic Support/Healing Runes**  
  - Examples: Minor Mend, Focusing Chant.  
  - Sources:
    - Shrine initiation,
    - First Aid tasks,
    - Low Shrine vendors.

- **Basic Mobility Runes**  
  - Examples: Ether Step, Hunter’s Step, Flickerstep.  
  - Sources:
    - Ranger/Academy quest arcs,
    - Racial/background mini-stories,
    - Early Contract rewards.

- **Basic Utility/Economy Runes**  
  - Examples: Cartel Ledger-lite variants.  
  - Sources:
    - Ledger/Cartel micro-contracts,
    - Port Meridian market quests.

### 4.2 T2 Rune Families

- **Intermediate Combat Runes**  
  - Examples: Mortal Strike, Flame Burst, Volley, Starfall Volley.  
  - Sources:
    - Yellow-zone delves and Contracts,
    - Public dungeons boss drops,
    - Stronghold/Warfront participation crates.

- **Intermediate Guard/Brace Runes**  
  - Examples: Brace Counter, Ether Aegis.  
  - Sources:
    - Shrine defense events,
    - Stronghold defense Contracts,
    - High-shrine vendors (token-based).

- **Intermediate Support/Healing Runes**  
  - Examples: Vital Current, Shared Burden.  
  - Sources:
    - High-quality healing achievements in dungeons,
    - Shrine Contracts,
    - Special healer-only Contracts.

- **Intermediate Mobility/Control Runes**  
  - Examples: Windbound Step, Trapline, Icebind.  
  - Sources:
    - Rifts/Anomalies,
    - Ranger/Academy field tests,
    - Road boss events.

- **Intermediate Utility/Economy Runes**  
  - Examples: Insightful Pact, Marked Prey, advanced Cartel Ledger.  
  - Sources:
    - Cartel/Ledger Contracts,  
    - Trade-focused Stronghold tasks,
    - Market events.

---

## 5. Implementation Notes

### 5.1 Loot Tables & Vendors

- Map each set/rune to:
  - Specific `creature_loot_template` and `gameobject_loot_template` entries,
  - Specific `npc_vendor` rows keyed by:
    - Faction rep rank,
    - Currency items (tokens, Ether shards, etc.).

- Use **low world-drop rates** for:
  - Generic non-set items,
  - Very low chance at rune fragments,
  - But **do not put full T1/T2 sets on purely random mobs**.

### 5.2 Contracts & Tasks Rewards

- Update `mortal_task_template` and `mortal_contract_template`:
  - Add reward tags referencing:
    - Set families (`SET_GREYCRAG_MILITIA`, `SET_SANCTUM_WARDEN`, etc),
    - Rune families (`RUNE_FAMILY_COMBAT_T2`, etc).

- Reward resolver script:
  - Rolls from family pools:
    - Ensures even distribution,
    - Avoids duplicates where possible (weight toward missing slots).

### 5.3 Progression Flow

- A new character should be able to:
  - Finish tutorial → obtain scuffed T0 gear.
  - Run Port Meridian/Green-zone content for:
    - One T1 set of their preferred style (Bruiser/Healer/Ranger/Mage/Hybrid).
  - Then naturally gravitate into:
    - Greycrag/Ranger/Shrine/Academy/Cartel networks,
    - T2 sets via Contracts, delves, and events.

---

This mapping ensures every T1/T2 set and Rune family:

- Has **clear, thematic content sources**,
- Reinforces **faction identity** (Shrine, Rangers, Academy, Cartel, Ledger),
- And keeps gear/rune progression tied tightly to your **sandbox loops** instead of random drops.  
