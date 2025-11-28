# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative & Systems Integration  
### File: 63-quest-conversion-strategy.md  
### Section: Quest Conversion & Story Integration Strategy

---

## Related Specs

- `68-prologue-and-act1-quest-pack.md` - Campaign quest implementation examples
- `69-faction-intro-chains-ledger-and-shrine.md` - Faction quest examples
- `70-act2-price-of-life-quest-pack.md` - Act II quest examples
- `71-act3-the-four-bargains-quest-pack.md` - Act III quest examples
- `72-act4-strongholds-and-invasions-campaign.md` - Act IV quest examples
- `73-act5-endgame-campaign-the-lost-crown.md` - Act V quest examples
- `76-dynamic-tasks-and-contracts-2-0-spec.md` - Task/Contract system for converted quests
- `01-progression.md` - Progression system (no XP, skill-based)
- `51-factions-and-standing-system.md` - Faction system for quest rewards

---

## 1. Purpose

Define a **systematic method** to adapt original WotLK quests to Mortal Warcraft’s design without rewriting the entire game.

We will:

- **Replace or heavily re-flavor** key “spine” quest chains with Mortal-flavored arcs.
- **Convert most generic quests** into Task/Contract-style content.
- **Leave some light-lore quests intact**, with minor adjustments.
- Integrate everything with:
  - Shipwreck/Hub onboarding,
  - Factions & Sanctums,
  - World Contracts & Task Boards,
  - Rifts, Midnight Horde, Strongholds, and Seasons.

Goal: preserve world density and pacing while making the game feel like **Mortal Warcraft**, not “Vanilla WotLK with mods.”

---

## 2. Core Principles

1. **Rewrite the spine, systemize the filler.**  
   - Big narrative chains → Mortal arcs (Fracture, Factions, Frontier).  
   - Generic sidequests → Contracts/Tasks.  
   - Some light lore can stay, as long as it doesn’t conflict.

2. **XP is dead; reward the economy.**  
   - All converted quests give:
     - Gold,
     - Materials,
     - Faction standing,
     - Tokens/appearances — but not XP.

3. **Quest text must respect the new lore.**  
   - No:
     - “You are the chosen Paladin of the Alliance.”  
   - Yes:
     - “You’re another survivor trying to make a living after the Fracture.”

4. **System-first, narrative-second.**  
   - Any quest we touch should:
     - Introduce or reinforce a system: Shrines, Contracts, Factions, Rifts, Runes, Trials, Strongholds, etc.

---

## 3. Quest Classification Framework

We classify all legacy quests into **four categories**:

### 3.1 Category A — Keystone Narrative Chains (REWRITE / REPLACE)

Definition:

- Zone-spanning arcs,
- Big lore or world-impact quests,
- Dungeon/raid lead-ins,
- Class/faction-defining lines.

Examples (conceptually):

- Wrathgate-style events and their build-up.
- Major Scourge, dragon, or Old God chains.
- Long chains ending in dungeon/raid keys or attunements.

Action:

- **Replace or deeply re-flavor** into Mortal Warcraft arcs that serve:
  - The Fracture lore,
  - Faction politics,
  - Frontier progression (Acts II–V),
  - Lost Lands meta (Emerald Dream, Azshara Crater).

Notes:

- These chains become:
  - Core Campaign Acts,
  - Faction arcs,
  - Late-game campaigns.

---

### 3.2 Category B — Structural Quest Hubs (PARTIAL REWORK + CONTRACTIZATION)

Definition:

- Clusters of 5–15 quests around a village/fort/outpost,
- Mixed “kill X,” “gather Y,” “escort Z” patterns.

Action:

- **At least one quest line per hub** becomes a small Mortal-flavored narrative thread:
  - Tied to:
    - Local Fracture phenomena,
    - Faction influence,
    - Rifts/Invasions, or
    - Regional economy.
- The rest:
  - Are converted to **Task Board posts** or **local Contracts**, using the same mobs & areas.

Example transformation:

- “Kill 10 gnolls” → becomes:
  - Task Board: “Gnoll Cull: Tier-1 – Payment in coin & scraps.”  
- “Collect 8 wolf pelts” →:
  - Material contract, possibly linked to Iron Ledger or local tanner.

---

### 3.3 Category C — Generic Filler Quests (CONTRACTS / TASKS ONLY)

Definition:

- Straightforward, low-meaningful quests:
  - Simple kill-collect,
  - One-step deliveries,
  - Minimal story relevance.

Action:

- Entirely absorbed into:
  - **Task Board system**,  
  - **World Contracts** or **Faction contract pools**.

Changes:

- Questgiver either:
  - Becomes a contract broker NPC,  
  - Or is deprecated/hidden in favor of Task Boards.
- Rewards:
  - Converted to:
    - Gold,
    - Materials,
    - Faction tokens (if attached to a specific faction).

---

### 3.4 Category D — Low-Impact Lore Flavor (MINOR TEXT EDITS OR LEAVE)

Definition:

- Short, flavor-driven quests:
  - Local gossip,
  - Tiny personal stories,
  - Non-progression-critical lore.

Action:

- Leave them mostly intact, with:
  - XP → Gold conversion,
  - Any **blatant conflicts** with core lore edited out (e.g., explicit class story language, heavy Alliance/Horde framing).

These are optional "color" and do *not* need to be part of the main sandbox loop.

---

## 3.5 Complete Quest Type-to-Task/Contract Mapping

This section provides a comprehensive mapping of all WoW 3.3.5a quest types to Mortal Warcraft's Task Board and Contract systems.

### Quest Type Conversion Table

| WoW Quest Type | Original Reward | Mortal Conversion | System | Reward Type | Notes |
|----------------|-----------------|-------------------|--------|-------------|-------|
| **Kill Quests** | XP + items | **Task Board: Hunt** | `76-dynamic-tasks-and-contracts-2-0-spec.md` | Gold + materials | "Kill 10 wolves" → "Hunt: Wolf Cull (Tier-1)" |
| **Collect Quests** | XP + items | **Task Board: Gather** | `76-dynamic-tasks-and-contracts-2-0-spec.md` | Gold + materials | "Collect 8 pelts" → "Gather: Pelt Collection" |
| **Escort Quests** | XP + items | **Courier Contract** | `13-caravans-contracts.md` | Gold + collateral | Escort NPCs → Escort caravans/merchants |
| **Delivery Quests** | XP + items | **Courier Contract** | `13-caravans-contracts.md` | Gold + collateral | Item delivery → Package delivery contracts |
| **Talk Quests** | XP + items | **Task Board: Scout** | `76-dynamic-tasks-and-contracts-2-0-spec.md` | Gold + faction standing | "Speak to NPC" → "Scout: Contact [NPC]" |
| **Use Item Quests** | XP + items | **Task Board: Interact** | `76-dynamic-tasks-and-contracts-2-0-spec.md` | Gold + materials | "Use item on target" → "Interact: [Objective]" |
| **Explore Quests** | XP + items | **Task Board: Scout** | `76-dynamic-tasks-and-contracts-2-0-spec.md` | Gold + faction standing | "Discover location" → "Scout: Explore [Area]" |
| **Daily Quests** | Daily XP + items | **Daily Tasks** | `76-dynamic-tasks-and-contracts-2-0-spec.md` | Gold + materials + faction standing | Daily reset, no XP |
| **Quest Chains** | Story + XP | **Campaign Quests** | `68-73-act-quest-packs.md` | Gold + materials + faction standing | Narrative chains, no XP |
| **Dungeon Quests** | XP + dungeon loot | **Public Dungeon Tasks** | `06-pve.md` | Gold + materials + dungeon loot | Public dungeon objectives |
| **Raid Quests** | XP + raid loot | **Extraction Raid Contracts** | `74-cursed-artifacts-and-extraction-system.md` | Gold + materials + artifacts | Raid objectives with extraction |
| **Reputation Quests** | XP + rep | **Faction Contracts** | `51-factions-and-standing-system.md` | Gold + faction standing | Faction-specific tasks |
| **PvP Quests** | XP + honor | **Warfront Contracts** | `92-mortal-warfronts-siege-flow.md` | Military Credits + materials | PvP objectives in warfronts |

### Detailed Conversion Examples

#### Kill Quests → Task Board: Hunt

**Original Quest:**
- "Kill 10 Defias Bandits" (Westfall)
- Reward: 500 XP + 50 silver + item

**Mortal Conversion:**
- **Task Board Entry:** "Hunt: Defias Bandit Cull (Tier-1)"
- **Location:** Port Meridian Task Board
- **Objective:** Kill 10 Defias Bandits
- **Reward:** 2 gold + 10-15 leather scraps + Iron Ledger standing
- **Risk Tier:** Yellow Zone (mid-risk)
- **No XP:** Progression via skill gains from combat

#### Collect Quests → Task Board: Gather

**Original Quest:**
- "Collect 8 Wolf Pelts" (Elwynn Forest)
- Reward: 300 XP + 30 silver + item

**Mortal Conversion:**
- **Task Board Entry:** "Gather: Wolf Pelt Collection"
- **Location:** Port Meridian Task Board
- **Objective:** Collect 8 Wolf Pelts (from wolves)
- **Reward:** 1.5 gold + 5-8 leather scraps + crafting materials
- **Risk Tier:** Green Zone (safe)
- **No XP:** Progression via gathering skill gains

#### Escort Quests → Courier Contracts

**Original Quest:**
- "Escort Merchant to Darkshire" (Duskwood)
- Reward: 800 XP + 80 silver + item

**Mortal Conversion:**
- **Contract Type:** Escort Contract
- **Location:** Port Meridian Contract Board
- **Objective:** Escort merchant caravan to Darkshire
- **Reward:** 5 gold + collateral (risk-based) + faction standing
- **Risk Tier:** Yellow Zone (mid-risk, criminal flagging)
- **Mechanics:** Caravan system with PvP risk (see `13-caravans-contracts.md`)

#### Delivery Quests → Courier Contracts

**Original Quest:**
- "Deliver Package to Stormwind" (Various)
- Reward: 400 XP + 40 silver + item

**Mortal Conversion:**
- **Contract Type:** Courier Contract
- **Location:** Regional Contract Board
- **Objective:** Deliver package from Point A to Point B
- **Reward:** 3 gold + collateral (risk-based) + faction standing
- **Risk Tier:** Varies by route (Green/Yellow/Red)
- **Mechanics:** Physical item transport with PvP risk

#### Daily Quests → Daily Tasks

**Original Quest:**
- "Daily: Kill 20 Scourge" (Northrend)
- Reward: Daily XP + daily currency + item

**Mortal Conversion:**
- **Task Type:** Daily Task
- **Location:** Task Board (daily reset)
- **Objective:** Kill 20 Scourge
- **Reward:** 10 gold + materials + faction standing + daily token
- **Risk Tier:** Varies by zone
- **Mechanics:** Daily reset, no XP, contributes to seasonal progression

#### Quest Chains → Campaign Quests

**Original Quest Chain:**
- "Wrathgate Chain" (Dragonblight)
- Reward: Story progression + XP + items

**Mortal Conversion:**
- **Quest Type:** Campaign Quest (Act IV/V)
- **Location:** Campaign NPCs
- **Objective:** Multi-stage narrative chain
- **Reward:** Gold + materials + faction standing + campaign progression
- **Risk Tier:** Varies by stage
- **Mechanics:** Narrative-driven, no XP, ties to Mortal lore

### Conversion Rules Summary

**Universal Changes:**
1. **No XP Rewards:** All quests converted to gold/material/faction rewards
2. **Skill-Based Progression:** Players gain skill points from activities, not XP
3. **Risk-Based Rewards:** Rewards scale with zone risk tier (Green < Yellow < Red)
4. **Faction Integration:** Most tasks/contracts provide faction standing
5. **Lore Alignment:** Quest text updated to respect Mortal Warcraft lore

**System-Specific Conversions:**
- **Task Board:** Generic kill/collect/explore quests
- **Contracts:** Escort, delivery, and high-value objectives
- **Campaign:** Narrative chains and story-driven content
- **Faction Contracts:** Reputation-focused tasks
- **Warfront Contracts:** PvP objectives in warfronts

---

## 4. Zone Priority & Pass Strategy

We do **passes** rather than random edits.

### 4.1 Phase 1 Zones (High Priority)

1. **Shipwreck Cove & Mainland Hub**
   - Already covered by:
     - Onboarding / Prologue / Act I spec.
   - These are **100% custom**; old quests are mostly disabled.

2. **Starter & Early Green Zones**
   - First 1–2 zones players visit after Hub.
   - Focus:
     - Convert hubs to Contracts/Tasks,
     - Introduce early Fracture/Faction hints.

3. **Key Frontier Zones (early Red/Yellow borders)**
   - Where we introduce:
     - World Contracts,
     - Hellgates,
     - Stronghold seeds.

4. **Core Endgame Regions**
   - Northrend-style areas,
   - Lost Lands zones (Emerald Dream, Azshara Crater),
   - Any region re-used for Warfronts, world bosses, etc.

In these zones:

- We aggressively:
  - Rework Category A,
  - Partial rewrite Category B,
  - Contractize C,
  - Light edit D if needed.

---

### 4.2 Phase 2 Zones (Medium Priority)

- Mid-level outdoor zones not in the core Frontier.
- Action:
  - Primarily **contractization passes** (convert B/C into Tasks/Contracts),
  - Only a few A-level chains kept and re-themed.

---

### 4.3 Phase 3 Zones (Low Priority)

- Legacy or less-trafficked areas.
- Action:
  - Minimal changes beyond:
    - XP → Gold,
    - Preventing direct conflict with new lore.

---

## 5. Conversion Mechanics (Technical)

### 5.1 Reward Conversion

All original quests:

- **Disable XP rewards**.
- Convert rewards to:

1. **Gold**
   - Scaled by:
     - Travel/time cost,
     - Zone risk tier.

2. **Materials**
   - Ore, leather, cloth, alchemical stuff.
   - Tuned to:
     - Support crafting/decay loop,
     - Not flood the market.

3. **Faction Standing**
   - Attach specific tasks/contracts to:
     - Iron Ledger, Shrine, Cartel, Rangers,
     - Neutral local sub-factions when appropriate.

4. **Tokens / Appearance Unlock Hooks (for special chains)**
   - Category A/B chain conclusions may grant:
     - Appearance Tokens,
     - Specific appearance unlocks,
     - Trial access tokens.

### 5.2 Quest Giver & Board Mapping

Add a mapping layer:

- `legacy_quest_id -> conversion_type`:
  - `STORY_REWRITE`, `HUB_NARRATIVE`, `CONTRACT_LOCAL`, `CONTRACT_BOARD`, `FLAVOR`.

Implementation idea:

```sql
CREATE TABLE IF NOT EXISTS mortal_quest_conversion_map (
  quest_id        INT PRIMARY KEY,
  conversion_type VARCHAR(32) NOT NULL,  -- 'STORY_REWRITE','CONTRACT_BOARD','CONTRACT_LOCAL','FLAVOR'
  faction_tag     VARCHAR(64) NULL,     -- optional faction association
  contract_template_id INT NULL,        -- link into world contract/task templates if used
  notes           TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Use this table in an Eluna/C++ helper to:

- Decide:
  - Whether original quest is:
    - Disabled,
    - Replaced with a new script,
    - Re-exposed via Task Board / Contract UI.

---

### 5.3 From Quest to Contract

For Category B/C quests:

1. **Create a Contract template** in the World Contract or Task Board system:
   - Set objective (kill X, collect Y, escort Z),
   - Set zone, coordinates, risk tier.

2. **Retire or rebind the original quest**:
   - Either:
     - Hide the original quest from the NPC,
     - Or change NPC gossip to:
       - “Work’s on the Board now. Check there.”

3. **Reward tuning**:
   - Remove item rewards that conflict with Mortal gear tier progression,
   - Focus on gold + mats + tokens.

---

## 6. Integrating with Campaign & Factions

### 6.1 Campaign Acts vs Legacy Chains

- **Prologue + Acts I–II**:
  - Almost fully custom; old starter chains disabled or heavily gutted.
- **Acts III–V**:
  - Use re-flavored Category A chains as narrative bones:
    - Replace Scourge/old storyline with Fracture / Faction / Frontier meta,
    - Where appropriate, keep set pieces (big fights, special phasing) but change text and rewards.

### 6.2 Faction Hooks

For Category B/C hubs:

- Attach them to Factions:

  - Iron Ledger:
    - Hub contracts about supply lines, tax collection, caravan escorts.

  - Order of the Shrine:
    - Hubs that defend cemeteries, Shrines, Midnight Horde events.

  - Black Sun Cartel:
    - Crime-infested zones with smuggling, theft, and black market tasks.

  - Rangers’ Pact:
    - Wild zones, Rift hotspots, anomaly hunting.

This ensures even “simple” tasks still support:

- Faction progression,
- Seasonal milestones,
- Overall Mortal economy.

---

## 7. Example Conversions

### 7.1 Generic Kill Quest → Task Board Hunt

Original pattern:

> “Go kill 10 wolves in the forest and come back for XP + a green item.”

Converted:

- Quest removed or hidden.
- Task Board entry added:
  - “WOLF CULL: The Ledger is paying per pelt. Cull wolves at coordinates X,Y. Bring back 10 pelts.”
- Reward:
  - Gold + wolf pelts + minor Ledger standing.

### 7.2 Zone Hub Story → Local Mortal Arc

Original hub:

- A village plagued by undead, with 7–9 quests escalating the situation.

Converted:

- 1–2 of those quests become:
  - A small Mortal-style arc:
    - Explains this undead surge as a **Midnight Horde echo tied to a damaged Shrine**.
    - Possibly ends with:
      - Mini Shrine event,
      - Small Shrine faction standing,
      - Ether-related flavor.

- Remaining 5–7 quests:
  - Turned into:
    - Defense contracts (kill X undead),
    - Shrine stabilization contracts (gather materials),
    - Low-tier Endless-style defense tasks.

---

## 8. Process for Implementation

### Step 1 — Build Conversion Map

1. Dump all quest IDs + basic info.
2. For each zone, go through quest clusters:
   - Classify each quest into A/B/C/D.
3. Populate `mortal_quest_conversion_map` with:
   - `conversion_type`,
   - `faction_tag` where relevant.

### Step 2 — Implement Global Reward Overrides

- Hook quest completion:
  - Override XP → gold/material/faction rewards based on map entry.

### Step 3 — Replace Keystone Chains

- For Category A:
  - Write new scripts/Eluna quest flows,
  - Replace or repurpose existing NPCs and waypoints,
  - Align them with Campaign Acts & Faction arcs.

### Step 4 — Contractize B/C Quests

- Generate world/task contract templates based on:
  - Legacy objectives,
  - Zones and mobs.
- Link them to:
  - Task Boards,
  - Faction contract lists,
  - World Contracts system.

### Step 5 — Lore-Sanity Pass

- For Category D:
  - Quick scan text for direct conflicts with:
    - Fracture lore,
    - Faction reality,
    - Non-XP-based progression.
  - Fix egregious lines; otherwise leave.

---

## 9. Design Checkpoints

To keep directionally correct:

1. **After Phase 1 (Starter + Hub zones):**
   - Onboarding should:
     - Feel fully Mortal,
     - Never mention XP/levels as progression,
     - Introduce Factions, Shrines, Contracts cleanly.

2. **After Frontier Zones pass:**
   - Red Zones should:
     - Be full of Contracts (Hunts, Rifts, Caravans, Hellgates),
     - Have coherent local Fracture/Faction stories,
     - Properly feed Strongholds and Seasons.

3. **After Endgame/Northrend/Lost Lands pass:**
   - Late game:
     - Feels like one big Frontier campaign,
     - With Warfronts, Trials, Stronghold meta,
     - And strong narrative justification for repeatable systems.

---

This strategy lets you **keep the good bones of WotLK** (world layout, density, pacing) while gradually turning its quest layer into a Mortal Warcraft–native mix of:

- Campaign Acts,
- Faction arcs,
- Contracts, Tasks, and Events,

without getting stuck in a full rewrite of thousands of quests.
