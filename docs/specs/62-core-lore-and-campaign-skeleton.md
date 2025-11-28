# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative & Onboarding Design  
### File: 62-core-lore-and-campaign-skeleton.md  
### Section: Core Lore, Campaign Skeleton & Onboarding Integration

---

## Related Specs

- `68-prologue-and-act1-quest-pack.md` - Prologue and Act I quest implementation
- `69-faction-intro-chains-ledger-and-shrine.md` - Faction introduction quests
- `70-act2-price-of-life-quest-pack.md` - Act II quest implementation
- `71-act3-the-four-bargains-quest-pack.md` - Act III quest implementation
- `72-act4-strongholds-and-invasions-campaign.md` - Act IV quest implementation
- `73-act5-endgame-campaign-the-lost-crown.md` - Act V quest implementation
- `51-factions-and-standing-system.md` - Faction system referenced in lore
- `03-risk-zones.md` - Risk zones and Frontier concept
- `22-healing-and-restoration.md` - Shrines and resurrection mechanics

---

## 1. Goals & Design Principles

This document defines the **core lore pillars**, **campaign structure**, and **onboarding quest flow** for Mortal Warcraft, and shows how they tie into the existing **Shipwreck Cove / Mainland Hub tutorial** and sandbox systems.

We are **not** building a linear, theme-park main story. Instead:

- The campaign is:
  - **Short but strong**: 3–5 Acts + Prologue.
  - **System-first**: every step anchors a mechanic (Shrines, Factions, Contracts, Rifts, Strongholds, etc.).
  - **Non-blocking**: You can enter the sandbox early; the campaign *enhances* access and rewards, not basic play.
- The lore:
  - Justifies **full loot, Shrines, Rifts, Midnight Horde, and Factions**.
  - Gives players a sense that their character is part of a larger, ongoing conflict: *“Frontier after the Fracture.”*

---

## 2. Core Lore Pillars

These are the “rules of the world” that tie all systems together. They should be referenced consistently in quests, flavor text, Atlas, and Trials.

### 2.1 The Fracture

**The Fracture** is the central, recent meta-event that reshaped Azeroth into the Mortal Warcraft sandbox.

- A catastrophic magical event shattered the boundary between:
  - The mortal world,
  - The Ether (realm of memory, echoes, and death),
  - Other planes (Rift realms, Hellgate realities).
- Consequences:
  - **Rifts**: Planar wounds bleed monsters, anomalies, and resources into the world.
  - **Midnight Horde**: The dead don’t sleep; they surge as semi-conscious echoes.
  - **Shrines**: Spirit Healers are now **Fracture anchors** that drag souls back into bodies at a cost.
  - **Lost Lands** (Emerald Dream, Azshara Crater, Development Land): unstable territories where the Fracture is strongest and reality is thin.

In story terms:

- The Fracture ended the old, neat order of nations.
- Local power now belongs to:
  - Guilds,
  - Factions,
  - Whoever can hold land and control Shrines.

### 2.2 Shrines & The Ether

Shrines are no longer just respawn points; they are **contracts with the Ether**.

- When you die:
  - Your soul falls into **The Ether**, a blind, muted realm of echoes.
  - Shrines pull you back into a fragile, living body.
- Every resurrection:
  - Leaves a “scar” on the local reality, attracting Midnight Horde events.
  - Increases the **strain** on nearby Shrines (flavor only, but can be used in events/quests).

This justifies:

- **Hardcore death rules**:
  - Gear drops in full-loot.
  - You resurrect *alive but stripped* at a Shrine (as designed).
- **The Ether rules**:
  - Ghost vision is nerfed (The Ether spec).
- **Order of the Shrine**:
  - A faction devoted to managing the cost of resurrection and protecting Shrines.

### 2.3 The Four Powers (Factions)

The old alliance blocks are fading; four supra-factions dominate the frontier:

1. **Iron Ledger**  
   - Philosophy: Order through debt, contract, and logistics.  
   - Controls: Insurance, caravans, banking tricks, materials markets.  
   - Preferred gameplay: traders, crafters, caravan runners, industrialists.

2. **Order of the Shrine**  
   - Philosophy: Order through sacrifice, discipline, and defense.  
   - Controls: Shrine wards, undead suppression, Trials of faith and grit.  
   - Preferred gameplay: defensive builds, Trials, Shrine defense, Midnight Horde events.

3. **Black Sun Cartel**  
   - Philosophy: Profit from whatever the Fracture brings.  
   - Controls: Smuggling routes, fences, the Black Market, shadow economy.  
   - Preferred gameplay: thieves, smugglers, ambush PvP, black-market play.

4. **Rangers’ Pact**  
   - Philosophy: Survive and master the wild frontier.  
   - Controls: Rifts, anomaly hunts, scouting, Hot Zone discovery.  
   - Preferred gameplay: exploration, outdoor PvE, Rifts, Hellgates, high-risk gathering.

Players are free to:

- Work with multiple factions (up to soft-caps),
- Choose a primary allegiance via Sanctums, Trials, and contract choices.

### 2.4 The Frontier & Lost Lands

The **Frontier** is the new, contested metagame region:

- Red Zones, Lost Lands, and unstable borderlands where:
  - Rifts are common,
  - Strongholds can be established and sieged,
  - Guild sovereignty matters most.

The **Lost Lands** (Emerald Dream, Azshara Crater, Dev Land) are the late-campaign and endgame story stage:

- They are where the Fracture is strongest.
- They justify:
  - High-tier resources,
  - World bosses,
  - Warfronts and Stronghold wars.

---

## 3. Campaign Structure Overview

The campaign is:

- A **Prologue** + **5 Acts**, each designed as ~3–7 quests / scenarios.
- Each Act explicitly introduces or deepens a core system.

### High-Level Flow

- **Prologue: Shipwrecked in the Fracture**  
  - Location: Shipwreck Cove.  
  - Focus: Survival basics, core controls, and first hints of Fracture/Shrines.

- **Act I: First Steps on a Broken Shore**  
  - Location: Mainland Hub + surrounding Green Zone.  
  - Focus: Local economy, Task Boards, first contracts, Regional Bank.

- **Act II: The Price of Life**  
  - Location: Mainland Shrines and nearby Yellow Zone.  
  - Focus: Death & resurrection, Ether rules, first Midnight Horde event.

- **Act III: The Four Bargains**  
  - Location: Pilgrimage to each Faction’s presence.  
  - Focus: Introduction to Factions, Sanctums, and core playstyles.

- **Act IV: Breach of the Frontier**  
  - Location: Border Red Zones and early Rifts/Hellgates.  
  - Focus: Rifts, anomalies, Hellgates, Stronghold seeds, World Contracts.

- **Act V: Siege of the Lost Lands**  
  - Location: Emerald Dream, Azshara Crater, other Lost Lands.  
  - Focus: Warfront-style meta events, Strongholds, endgame narrative beats.

Campaign is **optional but strongly recommended**; each Act unlocks cosmetics, titles, and “soft keys” (faction access, Trial access, Stronghold permissions) rather than base power.

---

## 4. Onboarding: Prologue & Act I Integration

We integrate your existing tutorial into the **Prologue + Act I** of the campaign.

### 4.1 Prologue: Shipwrecked in the Fracture

**Location:** Shipwreck Cove (isolated starter map).  
**Goal:** Teach basic controls, combat, harvesting, crafting, and risk concept.

#### Quest Flow (Example)

1. **Q0: Waking in the Wreck**  
   - Objective:
     - Talk to the Survivor NPC (“Tide-Scarred Veteran”) after waking.
   - Systems:
     - Camera control, movement, basic UI hints.

2. **Q1: Arms from Ruin**  
   - Objective:
     - Loot a broken weapon from debris, attack a training dummy or weak mob.  
   - Systems:
     - Basic combat, Brace, Guard Counter,
     - First skill gain (combat skill + attribute hint).

3. **Q2: Driftwood & Flint**  
   - Objective:
     - Gather driftwood and flint, bring to an improvised **Anvil/Furnace**.
   - Systems:
     - Gathering, weight/encumbrance hint,
     - Crafting at a **world workstation**, not from thin air.

4. **Q3: Edge of Survival**  
   - Objective:
     - Craft a simple weapon (Shiv) and equip it.
   - Systems:
     - Deep Crafting, item quality RNG idea (Shoddy vs Normal vs Masterwork – only as hint).

5. **Q4: First Fracture**  
   - Event:
     - A minor Rift flickers nearby, releasing a couple of weak Ether-touched mobs.
   - Objective:
     - Kill them, then interact with a **Damaged Shrine Fragment**.
   - Systems:
     - Show the Fracture visually,
     - Explain Shrines are broken here, real ones lie inland.

6. **Q5: The Raft to Mainland**  
   - Objective:
     - Repair a raft using collected materials and leave Shipwreck Cove.
   - Reward:
     - Minimal starter gear,
     - Story: “The world is broken, but there is work to be done inland.”

At completion:

- Campaign progression flag: `PROLOGUE_COMPLETE = 1`.
- Player is now eligible for **Act I** in Mainland Hub.

---

### 4.2 Act I: First Steps on a Broken Shore

**Location:** Mainland Hub (Green Zone town) + surrounding countryside.  
**Goal:** Introduce economy, Task Boards, simple contracts, Regional Bank, and basic travel.

#### Key NPCs

- **Harbor Clerk** (Iron Ledger-aligned, but neutral early):  
  Introduces banking, regionality, and basic trade.
- **Quartermaster**:  
  Explains Task Boards and contracts.
- **Shrine Acolyte** (Order of the Shrine):  
  Teases the cost of resurrection.

#### Quest Chain (Example)

1. **A1.1 — Welcome to the Hub**  
   - Objective:
     - Talk to Harbor Clerk, visit: Bank, Market stalls, Task Board.
   - Systems:
     - Regional Bank concept,
     - Stall/market overview,
     - Task Board UI unlock.

2. **A1.2 — The First Contract**  
   - Objective:
     - Accept a **simple local contract** from the Task Board (e.g., clear wolves or gather herbs near town).
   - Systems:
     - World Contract basics (non-rotating tutorial version),
     - Contract progress tracker.

3. **A1.3 — Pay, Not XP**  
   - Objective:
     - Turn in the contract, receive **gold + minor materials**.
   - Systems:
     - Reinforce that **XP is not the progression**; skills, materials, and contracts are.

4. **A1.4 — Ledger of the Living**  
   - Objective:
     - Deposit part of your payment in the Regional Bank.
   - Systems:
     - Explain that wealth is **regional**, not magically mailed,
     - Atlas later can show your holdings.

5. **A1.5 — A Whisper of Death**  
   - Objective:
     - Optional: speak with the Shrine Acolyte who warns:
       - “When you die, you’ll wake at a Shrine… but your steel will stay where you fell.”
   - Systems:
     - Soft-intro to **full-loot** and Shrine mechanics,
     - No forced death yet.

Act I completion reward:

- Title: **“Cove Survivor”** (cosmetic).
- Access unlock:
  - **Mentor System** in the Hub (free respecs until ~200 skill points, as previously designed).
  - Permanent unlock of Task Board access.

---

## 5. Act II: The Price of Life

**Theme:** Teach death, Ether, and the cost of resurrection in a controlled way.  
**Location:** Nearby Shrines, cemetery, early Yellow Zone.

#### Key beats:

- The player **dies on purpose** in a scripted scenario (or highly likely).
- They wake at a fully functional Shrine.
- They experience Ether blindness (The Ether: nerfed ghost) at least once.

#### Example Flow

1. **A2.1 — The Midnight Omen**  
   - A small scripted Midnight Horde “echo” hits a rural cemetery.
   - Objective:
     - Help Shrine Acolytes defend; likely loss if underprepared.

2. **A2.2 — First Real Death**  
   - In the chaos, the player is **expected to die**:
     - On death, we:
       - Trigger custom resurrection messaging at the nearest Shrine,
       - Remove gear to corpse chest as per core rules.
   - Objective:
     - “Return to your corpse and reclaim what you can.”

3. **A2.3 — The Ether’s Toll**  
   - Optional follow-up:
     - A short “vision” inside the Ether (limited ghost movement, no scouting).
   - Flavor:
     - A spectral NPC explains the cost of cheating true death.

4. **A2.4 — Shrines and Sacrifice**  
   - Objective:
     - Bring materials to help repair/strengthen the Shrine (simple contribution quest).
   - Systems:
     - Encourage players to “pay back” the world for resurrections (lore justification for Shrine-related events and contributions).

Act II completion:

- Unlocks:
  - Access to **basic Order of the Shrine Trial** (Tier 1),
  - Small standing bump with the Shrine faction,
  - Ether-related cosmetic (e.g., minor visual aura when near Shrines – optional).

---

## 6. Act III: The Four Bargains (Factions)

**Theme:** Introduce all four factions and let players **taste** their playstyles.

**Location:** Pilgrimage from the Hub to four faction representatives or outposts.

#### Structure

- Hub quest: “The world doesn’t run on heroism; it runs on deals. Go hear what each Power offers.”
- Player receives a “Faction Invitation Ledger” tracking visits.

#### Per-Faction Quick Encounter

1. **Iron Ledger**  
   - Location: Trade office / small warehouse.
   - Mini-contract:
     - Complete a **micro caravan** or supply-run.
   - Reward:
     - Small standing + access to **basic Ledger contracts**.

2. **Order of the Shrine**  
   - Location: Hilltop Shrine barracks.
   - Mini-trial:
     - Defend a small Shrine from a scripted, mild undead wave.
   - Reward:
     - Standing + access to **Basic Bulwark Trial**.

3. **Black Sun Cartel**  
   - Location: Seedy back-alley or hidden den.
   - Mini-job:
     - Smuggle contraband through a checkpoint, or steal an item from an NPC house (teaches Thievery risk).
   - Reward:
     - Standing + access to low-level **smuggler contracts** and fences.

4. **Rangers’ Pact**  
   - Location: Frontier lodge.
   - Mini-hunt:
     - Track and close a baby Rift or anomaly guided by a Ranger.
   - Reward:
     - Standing + access to **Rift/Anomaly contracts**.

Final step:

- Quest: **“Choose Your First Bargain”** (soft choice):
  - Player declares a **primary focus faction** (can be changed later via effort).
  - Unlocks:
    - First **Sanctum access** for that faction,
    - Faction-specific passive cosmetic buff (visual only).

---

## 7. Act IV: Breach of the Frontier

**Theme:** Teach Red Zones, Rifts/Hellgates, Stronghold seeds, and real World Contracts.

**Location:** A frontier border region leading into Red Zone.

Key systems introduced:

- **Red Zone rules** (full loot PvP).
- **Hellgates** (shared PvP dungeons).
- **Stronghold Sovereignty** (claimable nodes).
- **World Contracts** (from 58-world-contracts-and-map-pins).

Quest beats (high level):

1. Help Rangers and Shrine forces **seal a major Rift** near the border.
2. Run a **high-risk caravan** sponsored by Iron Ledger or Cartel through a Yellow → Red route.
3. Participate in a **Hellgate incursion**:
   - Enter with a small group (playerbots allowed).
   - Even if you lose, you learn rules.
4. Witness or join a **Stronghold claim**:
   - A scripted “first claim” event where guilds start to plant flags on ruins/towers.

Act IV completion:

- Unlocks:
  - Eligibility to **own/participate in Stronghold claims**,
  - Access to **frontier-endless contracts**,
  - Additional World Contracts for Red Zones.

---

## 8. Act V: Siege of the Lost Lands

**Theme:** Soft end-of-campaign “seasonal-capstone” arc that opens Lost Lands and Warfront-style meta.

**Location:** Emerald Dream, Azshara Crater, Development Land (as repurposed).

Focus:

- Massive **zone-wide events**:
  - Rifts, Invasions, Midnight Horde, zone flips.
- **Warfronts**:
  - Physical-entry battlegrounds with full-loot rules.
- **Guild vs Guild** meta:
  - Stronghold sieges,
  - Resource shipments,
  - Faction-driven war contracts.

This Act should:

- Be more **server-wide** than personal:
  - The “campaign” at this stage is largely about:
    - Taking part in big events,
    - Unlocking world features (e.g., new Stronghold slots, global buffs).
- Provide:
  - Prestige titles,
  - High-tier cosmetic appearances,
  - Weapon Legacy and Trial tie-ins.

---

## 9. Quest & Story Design Guidelines

To keep everything consistent with Mortal Warcraft’s tone and systems:

1. **Contract-flavored, not “kill 10 boars” fluff**  
   - Most quests should read like:
     - Jobs, contracts, operations, or vows.
   - NPCs speak in **practical terms**: materials, risk, routes, payments, sacrifices.

2. **Failure-tolerant & death-aware**  
   - Quests must:
     - Expect players to die.
     - Not soft-lock players for failing an encounter once.
   - Many objectives can:
     - Be retried,
     - Progress partially through contributions (e.g., server-side kills in events).

3. **System-first writing**  
   - Every main quest step should:
     - Touch a system: Shrines, Contracts, Factions, Rifts, Trials, Strongholds, etc.
     - Never rely on pure exposition alone.

4. **Multiple valid approaches where feasible**  
   - Example:
     - A Cartel quest might be solvable by:
       - Stealing an item,
       - Buying it on the market,
       - Trading with another player.

5. **Economy consciousness**  
   - Quest rewards:
     - Mostly gold, materials, faction tokens, appearance unlocks.
     - Not heavy raw gear injection that overrides crafting and drops.

---

## 10. Next Steps

Implementation-wise, to start:

1. **Lock in Lore Pillars**
   - Turn The Fracture, Shrines & Ether, Factions, Frontier/Lost Lands into:
     - Short atlas pages,
     - A one-page in-game “Primer” shown on first login.

2. **Detail the Prologue & Act I**  
   - Turn the Prologue and Act I outlines here into a concrete quest script:
     - NPC names, quest IDs, objectives, coordinates,
     - Eluna scripts and DB changes.

3. **Hook Campaign Flags**
   - Add a simple `mortal_campaign_progress` table:
     - `guid`, `stage_code`, `state`, `flags_json`.
   - Use this to:
     - Gate Sanctum access,
     - Gate first Trials,
     - Control some tutorial-only events.

4. **Optionally: Re-flavor Key Legacy Zones**
   - Pick 2–3 iconic WotLK quest hubs and:
     - Replace or wrap their key questlines with Mortal-themed versions,
     - Convert others to repeatable Contracts.

This gives you a coherent **world premise + campaign spine** that plugs straight into your existing systems and onboarding tutorial, without turning Mortal Warcraft into a theme park or derailing the sandbox focus.
