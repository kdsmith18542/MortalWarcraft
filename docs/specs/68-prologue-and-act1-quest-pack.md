# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative Implementation  
### File: 68-prologue-and-act1-quest-pack.md  
### Section: Prologue (Shipwreck Cove) & Act I (Port Meridian) Quest Pack

---

## Related Specs

- `62-core-lore-and-campaign-skeleton.md` - Core lore and campaign structure
- `69-faction-intro-chains-ledger-and-shrine.md` - Faction introduction quests that follow Act I
- `03-risk-zones.md` - Risk zones introduced in Act I
- `04-economy.md` - Economy systems introduced in Port Meridian
- `05-crafting.md` - Crafting systems introduced in Act I
- `01-progression.md` - Character progression systems introduced in Prologue
- `22-healing-and-restoration.md` - Shrines and resurrection introduced in Prologue
- `38-social-and-onboarding-systems.md` - Onboarding systems and Expedition Finder

---

## 1. Scope

This document turns the **campaign skeleton** into concrete quest designs for:

- **Prologue: Shipwreck Cove (Survival)**  
- **Act I: Port Meridian (Mainland Hub – Society & Economy)**  

Each quest is specified with:

- `QuestID` (proposed ID range: **10000–10029** for early-game mainline),
- Title,
- Type (MAIN / TUTORIAL / SIDE),
- Narrative summary,
- Objectives (mechanical),
- Prerequisites,
- Rewards (in Mortal terms),
- Implementation notes (DB + Eluna hooks).

IDs are *suggested* – final IDs can be remapped, but the range should stay contiguous and reserved for core onboarding.

---

## 2. Zone Overview

### 2.1 Shipwreck Cove (Prologue Zone)

- **Type:** Phased/isolated starter area (instance ID or phasing state).  
- **Theme:** Wreckage, storms, first exposure to the Fracture (faint anomalies).  
- **Goals:**
  - Teach:
    - Movement, camera,
    - Basic combat (Basic Attack + Brace),
    - Gathering & encumbrance,
    - Workstation crafting,
    - Risk concept (full loot, Shrines, Ether),
    - Raft escape to the mainland.

### 2.2 Port Meridian (Act I Hub)

- **Type:** First major **Green Zone hub** on the mainland.  
- **Location:** Coastal city with:
  - Regional Bank,
  - Market Stalls,
  - Task Board,
  - Shrine,
  - Stable/Mount merchant,
  - Mentor NPC,
  - Inn (Shrine Mark bind location),
  - Initial Faction representatives.

- **Goals:**
  - Teach:
    - Contracts & Task Boards,
    - Player-driven market,
    - Regional banking,
    - Courier missions & encumbrance,
    - Mounts and roads,
    - Basic Mentor/respec system,
    - Early hints about Factions and Frontier/Red Zones.

---

## 3. Prologue Quests — Shipwreck Cove

### 3.1 Q10000 — “Waking in the Wreckage”

- **QuestID:** 10000  
- **Type:** MAIN / TUTORIAL  
- **Giver:** NPC `Survivor Alden` (near player spawn, lying against debris).  
- **Prereqs:** None (auto-accepted on login/spawn).  

**Summary:**  
You wake up on a broken shore after a catastrophic storm. A wounded survivor asks you to help stabilize the immediate area.

**Objectives (Gameplay):**

- Speak to **Survivor Alden** to “wake up” (first click).  
- Loot a **Splintered Crate** nearby for:
  - 1x `Torn Shirt`,
  - 1x `Rusty Knife` (starter weapon),
  - 1x `Soaked Rations` (food).  
- Equip the `Rusty Knife`.

**Rewards:**

- Auto-equip starter gear,
- Small amount of **starting gold** (few copper),
- Set **starting encumbrance baseline** (teaches weight via tooltip).

**Implementation Notes:**

- DB:
  - `quest_template` row for 10000.
  - Starting equipment removed from default race/class; quest provides it instead.
- Eluna:
  - On first login or `OnFirstLogin` hook:
    - Set phase/instance to Shipwreck Cove,
    - Auto-accept Q10000,
    - Spawn Alden nearby.
  - Giver gossip:
    - Simple “You’re alive… good. Now move, we don’t have long.”

---

### 3.2 Q10001 — “First Blows”

- **QuestID:** 10001  
- **Type:** MAIN / TUTORIAL (Combat)  
- **Giver:** Survivor Alden  
- **Prereqs:** Q10000 complete.  

**Summary:**  
Alden needs you to prove you can still fight. He instructs you to attack a training dummy to get your muscles working.

**Objectives:**

- Use **Basic Attack** on the **Makeshift Dummy** 5 times.  
- Use **Brace** successfully at least once while being hit by a weak, scripted attacker (e.g. a “Crabling” critter).

**Rewards:**

- 1x `Cracked Bracer` (minor armor),
- Unlocks a **tutorial hint** about:
  - Combat skills increasing with use (combat_skills.lua),
  - Brace & Guard Counters.

**Implementation Notes:**

- Eluna:
  - Hook `OnDamage` for dummy to track hits and complete objective.
  - Spawn a low-damage creature that auto-engages player for Brace test.
  - On successful Brace within a small window:
    - Flag objective complete.
- UI:
  - Tutorial popups for:
    - Basic Attack,
    - Brace,
    - First skill gain message.

---

### 3.3 Q10002 — “Wood and Water”

- **QuestID:** 10002  
- **Type:** MAIN / TUTORIAL (Gathering & Encumbrance)  
- **Giver:** Survivor Alden  
- **Prereqs:** Q10001 complete.  

**Summary:**  
You must gather driftwood to build shelter and collect water before the tide rises.

**Objectives:**

- Gather **6x Driftwood** from designated beach objects.  
- Fill **2x Brackish Waterskin** from tide pools.

**Rewards:**

- 1x `Ragged Backpack` (+6 slots, small weight),
- Increases **Gathering skill** slightly.

**Implementation Notes:**

- GameObjects:
  - Place `Driftwood Pile` objects that:
    - On interaction:
      - Give `Driftwood` item,
      - Slightly increase Gathering skill via Eluna hook.
- Encumbrance:
  - Script to briefly show “Encumbered” debuff if player overloads, then educate about weight icons/tooltips.

---

### 3.4 Q10003 — “Edge of Survival”

- **QuestID:** 10003  
- **Type:** MAIN / TUTORIAL (Crafting & Workstations)  
- **Giver:** Survivor Alden  
- **Prereqs:** Q10002 complete.  

**Summary:**  
Alden instructs you to fashion a crude weapon at a salvaged anvil – your first introduction to **workstation-based crafting**.

**Objectives:**

- Interact with the **Makeshift Anvil** workstation.  
- Craft **1x Crude Shiv** using:
  - 1x Driftwood,
  - 1x Rusted Metal Scrap (spawned from beach debris).

**Rewards:**

- 1x `Crude Shiv` (better than Rusty Knife),
- Unlocks **basic Crafting UI hint** and Material Lore concept.

**Implementation Notes:**

- Workstation:
  - Hook `MortalCraftingWorkstation.cpp/h` (C++ implementation) to:
    - Check materials,
    - Present a simple recipe,
    - Create Crude Shiv item.
- Tutorials:
  - Tooltips about:
    - Workstation vs Field crafting,
    - Material Lore (Thorium etc. later).

---

### 3.5 Q10004 — “Signals in the Storm”

- **QuestID:** 10004  
- **Type:** MAIN (Risk & Lore intro)  
- **Giver:** Survivor Alden  
- **Prereqs:** Q10003 complete.  

**Summary:**  
Night approaches. Alden wants you to light a beacon for possible rescue and investigate strange lights farther up the beach – your first hint at Shrines/Ether.

**Objectives:**

- Use a **Torch** to light the **Signal Pyre**.  
- Investigate a **Flickering Shrine Fragment** further up the shore.

**Rewards:**

- 1x `Shrine-Touched Pebble` (flavor trinket, no real power),
- Small **Shrine faction** rep gain.

**Implementation Notes:**

- Flickering Shrine Fragment:
  - GameObject with:
    - Short sequence (visual effect),
    - Lore gossip text about:
      - Spirits, Shrines, Ether,
      - “If you die, you will not be lost… but you will not come back whole.”
- No actual death mechanic yet – just foreshadowing.

---

### 3.6 Q10005 — “The Broken Raft”

- **QuestID:** 10005  
- **Type:** MAIN (Exit to Mainland)  
- **Giver:** Survivor Alden  
- **Prereqs:** Q10004 complete.  

**Summary:**  
Alden has found remains of a lifeboat. You must repair it and shove off toward a distant light on the horizon: Port Meridian.

**Objectives:**

- Collect:
  - 4x `Sturdy Plank` (new driftwood objects),
  - 2x `Tar Lump` from barrels,
  - 1x `Torn Sailcloth` from wreckage.  
- Interact with the **Damaged Raft** to trigger repair & departure.

**Rewards:**

- Transition to **Port Meridian** (Act I),
- Q10006 (below) available as an optional side quest before leaving.

**Implementation Notes:**

- On completing the raft interaction:
  - Use Eluna to:
    - Play short fade/cutscene,
    - Teleport player to Port Meridian dock area,
    - Clear Shipwreck Cove phasing flag.

---

### 3.7 Q10006 — “What the Tide Brought In” (Optional)

- **QuestID:** 10006  
- **Type:** SIDE (Loot, Encumbrance practice)  
- **Giver:** Survivor Alden or a `Nervous Deckhand` NPC.  
- **Prereqs:** Q10002 complete (available before leaving).  

**Summary:**  
You’re asked to salvage one last crate from a dangerous part of the shore. It’s heavier than it looks.

**Objectives:**

- Retrieve **1x Waterlogged Supply Crate** from a marked location.  
- Return it to the questgiver.

**Rewards:**

- Random low-value crafting materials,
- Small gold amount.

**Implementation Notes:**

- Crate item:
  - Heavy item that pushes player near **encumbrance limit**.
  - The quest teaches:
    - Slower movement when overloaded,
    - Importance of bag space & weight.

---

## 4. Act I Quests — Port Meridian (Mainland Hub)

Port Meridian is the player’s first **societal anchor**. Many quests here are **tutorial-mainline hybrids**, introducing persistent systems.

### 4.1 Q10010 — “Harbor of the Broken World”

- **QuestID:** 10010  
- **Type:** MAIN (Arrival Intro)  
- **Giver:** NPC `Harbor Warden Serra` (at landing dock).  
- **Prereqs:** Complete Q10005 (arrival from Cove).  

**Summary:**  
The Harbor Warden greets you, checks your papers (metaphorically), and sends you to get settled.

**Objectives:**

- Speak to **Harbor Warden Serra**.  
- Follow her to:
  - The **Innkeeper** to set your **Shrine Mark** (bind).  
  - The **local Shrine** (optional ping on minimap).

**Rewards:**

- 1x `Port Meridian Map Fragment` (consumable that reveals hub map),
- Small gold.

**Implementation Notes:**

- On completion:
  - Hearthstone is converted to **Shrine Mark** bound to Meridian Inn/Shrine.
- Tutorial popup:
  - Explains:
    - Shrines, respawn rules,
    - Full-loot nature in Yellow/Red zones (teased, not yet felt).

---

### 4.2 Q10011 — “Work for the Willing”

- **QuestID:** 10011  
- **Type:** MAIN / TUTORIAL (Task Board)  
- **Giver:** Harbor Warden Serra → sends player to **Task Board**.  
- **Prereqs:** Q10010.  

**Summary:**  
Serra tells you that in this city, work is found at the board. You must pick and complete a basic Contract.

**Objectives:**

- Interact with the **Port Meridian Task Board**.  
- Accept one of:
  - `Contract: Rat Cleanup`,
  - `Contract: Crate Counting`,
  - or `Contract: Shoreline Patrol`.  
- Complete the chosen Contract.

**Rewards:**

- Contract payout (gold + minor material),
- Unlock **World Contract UI** & tutorial.

**Implementation Notes:**

- Task Board:
  - Mortal contract system UI entry point.
- Contracts:
  - Implement as:
    - Separate “Contract quests” with their own IDs (outside 100xx mainline),
    - Or dynamic contract templates via `MortalTaskBoard.cpp/h` (C++ implementation).

---

### 4.3 Q10012 — “A Bag of Opportunities”

- **QuestID:** 10012  
- **Type:** MAIN / TUTORIAL (Market & Stalls)  
- **Giver:** NPC `Quartermaster Rhela` near market.  
- **Prereqs:** Q10011.  

**Summary:**  
Rhela suggests you’ll get nowhere without more space. She sends you to buy a proper pack from the player stalls or a fallback NPC vendor.

**Objectives:**

- Purchase **1x Simple Pack** (or better) from:
  - Any **Market Stall** vendor in Port Meridian,
  - Or the fallback Ledger-aligned NPC `Licensed Outfitter`.

**Rewards:**

- Equip Simple Pack (+10–12 slots),
- Gain **small Iron Ledger standing**.

**Implementation Notes:**

- Ledger tie-in:
  - If bought from Ledger stall:
    - Slightly better price or higher standing.
- UI:
  - Highlight Market stalls with map pin or minimap icon.

---

### 4.4 Q10013 — “The First Deposit”

- **QuestID:** 10013  
- **Type:** MAIN / TUTORIAL (Regional Bank)  
- **Giver:** Quartermaster Rhela or `Banker Tolan`.  
- **Prereqs:** Q10012.  

**Summary:**  
You are told to protect your valuables by depositing them in the regional bank, and warned that Meridian’s vault is not the same as any other city.

**Objectives:**

- Visit **Port Meridian Bank**.  
- Deposit:
  - At least **20 units of weight** worth of goods (any items) into your **Regional Bank**.

**Rewards:**

- Unlock **Bank map pin** in Atlas/MortalMap,
- Minor Ledger standing.

**Implementation Notes:**

- Bank interaction:
  - After first deposit, show:
    - Tutorial about **Regional Banking** (city != city),
    - Tooltip that indicates where items physically are.

---

### 4.5 Q10014 — “Horse Sense”

- **QuestID:** 10014  
- **Type:** MAIN / TUTORIAL (Mounts as Items)  
- **Giver:** NPC `Stablemaster Corin` near stables.  
- **Prereqs:** Q10013.  

**Summary:**  
Corin explains that mounts are **living assets**, not spells. You must buy your first **Horse Reins**.

**Objectives:**

- Purchase **1x Reins of the Plow Horse** from Corin (or a player vendor).  
- Place it in your bags.  
- Use the Reins to summon your horse outside the city gate.

**Rewards:**

- Mount usage unlocked,
- Tutorial unlock on:
  - Mount durability,
  - Hunger/maintenance,
  - Full-loot mount drop on death.

**Implementation Notes:**

- living_mounts.lua:
  - Already designed to:
    - Consume Reins durability when dismounted by force,
    - Drop Reins in corpse chest on PvP death.
- This quest:
  - Introduces those concepts early in a **Green Zone** with low risk.

---

### 4.6 Q10015 — “Mentor’s Wisdom”

- **QuestID:** 10015  
- **Type:** MAIN / TUTORIAL (Respec & Build Safety)  
- **Giver:** NPC `Mentor Elira` in a quiet part of Port Meridian.  
- **Prereqs:** Q10013 (or Q10014).  

**Summary:**  
Elira explains that in a broken world, you must adapt. She offers to show you how to reallocate your attributes and skills freely while you are still “young.”

**Objectives:**

- Speak to **Mentor Elira**.  
- Open the **Respec/Loadout UI** at least once.  
- (Optional) Perform a respec while total skill points < 200.

**Rewards:**

- Unlock **2nd Loadout Slot**,
- Minor Shrine & Ledger standing (she’s loosely neutral).

**Implementation Notes:**

- Early respec:
  - Free or extremely cheap below 200SP threshold.
- On completion:
  - UI hint about:
    - Later respecs costing more,
    - Respec Tokens as convenience, but not mandatory.

---

### 4.7 Q10016 — “The Weight of a Promise”

- **QuestID:** 10016  
- **Type:** MAIN / TUTORIAL (Courier & Encumbrance)  
- **Giver:** NPC `Ledger Clerk Brax` near bank/market.  
- **Prereqs:** Q10013.  

**Summary:**  
Brax hires you to move a **sealed crate** to a nearby outpost just outside Port Meridian on the road, teaching you about encumbrance and the value of roads.

**Objectives:**

- Accept **Ledger Crate** (heavy quest item) from Brax.  
- Deliver it to **Outpost Scribe Lysa** at the roadside watchtower.  
- Return to Brax to report success.

**Rewards:**

- Gold (starter courier rate),
- Slight Ledger standing,
- Increased **Travel skill**.

**Implementation Notes:**

- Crate:
  - Heavy enough to be felt, but:
    - Road Speed buff (road_speed_system.lua) is highlighted.
- On Quest complete:
  - Introduce that:
    - Courier Contracts exist as a persistent system,
    - You can take similar jobs from the Task Board later.

---

### 4.8 Q10017 — “Rumors of the Frontier”

- **QuestID:** 10017  
- **Type:** MAIN (Foreshadow Yellow/Red Zones)  
- **Giver:** Harbor Warden Serra or a **Frontier Scout NPC**.  
- **Prereqs:** Q10011 complete (player familiar with city).  

**Summary:**  
You’re sent to talk to various locals to hear three different perspectives on the **Frontier**.

**Objectives:**

- Speak with:
  - **Frontier Scout** at the northern gate (Yellow Zone perspective),  
  - **Shrine Acolyte** near the Shrine (warning about death & Ether),  
  - **Black Sun Fixer** in the shadows of the docks (Cartel-flavored perspective).  

**Rewards:**

- Unlock **map markers** for:
  - Nearby Yellow Zone border,
  - First Red Zone hint (not enabled as destination yet).
- Gain small standing with the Faction you respond most favorably to in dialogue choices.

**Implementation Notes:**

- Each NPC:
  - Delivers short lore drops about:
    - Criminal flags,
    - Full loot,
    - Notoriety & bounties.
- Dialogue choices:
  - Can be used as **first Faction-alignment hint** (non-binding but tracked).

---

### 4.9 Q10018 — “Echoes at the Edge” (Optional Group Intro)

- **QuestID:** 10018  
- **Type:** SIDE / GROUP (First Rift)  
- **Giver:** Frontier Scout or Shrine Acolyte.  
- **Prereqs:** Q10017 recommended, but not required.  

**Summary:**  
You’re asked to investigate a **minor Rift anomaly** at the edge of the safe roads, with a recommendation to bring allies.

**Objectives:**

- Travel to a marked location just outside Port Meridian.  
- Defeat **3x Rift-Touched Beasts**.  
- Close the **Minor Rift** (interact with Rift object while it pulses).

**Rewards:**

- Small amount of:
  - Rune dust / arcane reagents,
  - Faction standing (Shrine + Rangers),
- Unlocks:
  - Future Rift contracts & mid-game Rift chains.

**Implementation Notes:**

- Low difficulty:
  - Tuned for early groups or strong solo players.
- This quest:
  - Bridges from **safe hub** into lightly contested outskirts.

---

## 5. Quest Flow Summary

### Prologue (Shipwreck Cove):

1. **Q10000 Waking in the Wreckage**  
2. **Q10001 First Blows**  
3. **Q10002 Wood and Water**  
4. **Q10003 Edge of Survival**  
5. **Q10004 Signals in the Storm**  
6. **Q10005 The Broken Raft**  
7. **Q10006 What the Tide Brought In** (optional)

### Act I (Port Meridian):

1. **Q10010 Harbor of the Broken World**  
2. **Q10011 Work for the Willing**  
3. **Q10012 A Bag of Opportunities**  
4. **Q10013 The First Deposit**  
5. **Q10014 Horse Sense**  
6. **Q10015 Mentor’s Wisdom**  
7. **Q10016 The Weight of a Promise**  
8. **Q10017 Rumors of the Frontier**  
9. **Q10018 Echoes at the Edge** (optional)

Together, these quests:

- Onboard players into:
  - Combat, harvesting, crafting, risk,
  - Contracts, markets, banks, mounts, respec,
- Set up:
  - Faction flavor,
  - Frontier & Rift foreshadowing,
  - Future Act II (“Price of Life”) death-focused chain.
