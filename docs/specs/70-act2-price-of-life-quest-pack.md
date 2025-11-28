# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative Implementation  
### File: 70-act2-price-of-life-quest-pack.md  
### Section: Act II — “Price of Life” Quest Pack

---

## Related Specs

- `62-core-lore-and-campaign-skeleton.md` - Core lore and campaign structure
- `68-prologue-and-act1-quest-pack.md` - Act I quests that precede Act II
- `71-act3-the-four-bargains-quest-pack.md` - Act III quests that follow Act II
- `03-risk-zones.md` - Risk zones and full-loot mechanics central to Act II
- `22-healing-and-restoration.md` - Shrines and resurrection mechanics
- `11-pvp-systems.md` - Notoriety and bounty systems introduced in Act II
- `56-negative-titles-and-notoriety-labels.md` - Notoriety system
- `13-caravans-contracts.md` - Caravan and courier contracts
- `04-economy.md` - Economy systems including insurance

---

## 1. Scope

Act II is the first **“real stakes”** chapter of the Mortal Warcraft campaign.

It is designed to:

- Force the player to **experience the full death flow**:
  - Live respawn at Shrine,
  - Gear dropping to corpse chest,
  - Need to recover items or re-equip.
- Connect:
  - Port Meridian → first **Yellow Border Hamlet** → edge of **Frontier (Red Zone)**.
- Tie in:
  - **Shrine** mechanics and faction (Order of the Shrine),
  - **Iron Ledger** (Insurance if unlocked),
  - **Contracts & caravans**,
  - Early signals of:
    - Notoriety,
    - Bounty systems,
    - Midnight Horde / Ether buildup.

This document provides a concrete quest chain for Act II using QuestIDs **10030–10039**.

---

## 2. Setting

### 2.1 Location Overview

- **Port Meridian** — remains the player’s Green-zone hub.
- **Greycrag Hamlet** (working name):
  - A small **Yellow Zone border settlement**:
    - Located 1–2 road segments beyond Port Meridian.
    - Has:
      - Small inn & minor Shrine outpost,
      - Minimal bank access (Ledger branch office),
      - Few vendors,
      - Task Board with local contracts.

- **The Bleached Road**:
  - The main road between Port Meridian ↔ Greycrag.
  - Flanked by:
    - Bandit camps,
    - Ether-scarred spots,
    - Occasional minor Rift anomalies.

- **The First Frontier Ridge**:
  - A ridge/cliff area just beyond Greycrag where the **Red Zone** begins.
  - For Act II, players **do not yet fully enter** the Red Zone, but see it.

---

## 3. Quest Flow Overview

Act II mainline quests:

1. **Q10030** — “A Road Marked in Chalk”  
2. **Q10031** — “Hamlet on the Edge”  
3. **Q10032** — “Work of the Living”  
4. **Q10033** — “The Warning Bell”  
5. **Q10034** — “The Line We Crossed” *(scripted actual death)*  
6. **Q10035** — “Price of Returning” *(recover your body/gear)*  
7. **Q10036** — “Debts of Flesh and Coin” *(Ledger/Shrine repercussions)*  
8. **Q10037** — “Stand on Your Own Two Feet” *(re-equipping & choice)*  
9. **Q10038** — “Shapes in the Red” *(foreshadow full Frontier)* — optional epilogue.

---

## 4. Detailed Quest Designs

### 4.1 Q10030 — “A Road Marked in Chalk”

- **QuestID:** 10030  
- **Type:** MAIN (Transition to Yellow Zone)  
- **Giver:** Harbor Warden Serra or Frontier Scout at Port Meridian gate.  
- **Prereqs:**  
  - Completion of core Act I chain (e.g., Q10017 “Rumors of the Frontier”),  
  - Suggested minimum skill threshold (dynamic level ~3–4).

**Summary:**  
You are asked to escort a **Shrine Acolyte courier** and a **Ledger junior clerk** from Port Meridian to Greycrag Hamlet. This is your first *formal* crossing into Yellow-risk territory.

**Objectives:**

- Meet **Acolyte Seris** and **Ledger Clerk Brax’s apprentice** at the Port Meridian gate.  
- Travel with them along the Bleached Road toward Greycrag.  
- Use chalk to mark:
  - 3 **Waystones** along the road (interact with stone markers).

**Rewards:**

- Gold + basic materials (travel supplies).  
- Small reputation gains:
  - Shrine,
  - Ledger,
  - Rangers (if they appear along the road).

**Implementation Notes:**

- Escort:
  - NPCs move with you but cannot initiate combat; you are primary protector.
- Waystones:
  - Each activation:
    - Could add optional **respawn/fast-retravel anchor** later,
    - For now, just markers & map pins.

---

### 4.2 Q10031 — “Hamlet on the Edge”

- **QuestID:** 10031  
- **Type:** MAIN (Arrival at Greycrag)  
- **Giver:** Auto-complete trigger on reaching Greycrag + NPC `Greycrag Bailiff`.  
- **Prereqs:** Q10030.  

**Summary:**  
You arrive at Greycrag Hamlet, a small settlement under growing pressure from bandits and Ether anomalies.

**Objectives:**

- Speak with **Greycrag Bailiff** (local leader).  
- Visit:
  - The **local Shrine Outpost**,
  - The **Ledger sub-branch**,
  - The **Hamlet Task Board**.

**Rewards:**

- Unlock Greycrag as:
  - A **bindable Shrine Mark** location,
  - A **regional bank branch** (Greycrag-only).  
- Small local reputation.

**Implementation Notes:**

- This quest:
  - Acts mostly as orientation.
- On completion:
  - Enable local Contracts,
  - Add Greycrag pins to Atlas / MortalMap.

---

### 4.3 Q10032 — “Work of the Living”

- **QuestID:** 10032  
- **Type:** MAIN / TUTORIAL (Local Contracts)  
- **Giver:** Greycrag Bailiff or Task Board.  
- **Prereqs:** Q10031.  

**Summary:**  
You must help stabilize Greycrag by completing **one of three local Contracts**. This shows that Yellow zones are economically vital, not just dangerous.

**Objectives:**

- Pick and complete **1 of 3 Local Contracts**:
  - “Cull the Night Wolves” — small extermination contract.  
  - “Patch the Palisade” — gathering wood + short defense event.  
  - “Escort the Tithes” — short mini-courier from farmstead to Greycrag.

**Rewards:**

- Contract reward (gold, materials),  
- Local Greycrag standing,  
- Small general rep with relevant faction:
  - Rangers (wolves),  
  - Ledger (tithes),  
  - Shrine (palisade defense if undead appear).

**Implementation Notes:**

- These Contracts:
  - Use the same task board system as Port Meridian, but:
    - Slightly higher risk,  
    - Better rewards.

---

### 4.4 Q10033 — “The Warning Bell”

- **QuestID:** 10033  
- **Type:** MAIN (Foreshadowing Event)  
- **Giver:** Greycrag Bailiff or Shrine Outpost Warden.  
- **Prereqs:** Q10032.  

**Summary:**  
After you help with local tasks, the **Warning Bell** sounds — scouts have seen a strange movement near the Frontier ridge. You are asked to accompany a patrol to investigate.

**Objectives:**

- Join **Shrine Warden Calren** or a local **Ranger Captain** at Greycrag gate.  
- Travel to a **ridge overlook** near the Red Zone border.  
- Observe:
  - A **short scripted event**:
    - Pulsing Ether fissure,
    - Shadowy silhouettes in distant Red zone,
    - Possibly a small bandit group watching.

**Rewards:**

- Quest XP equivalent → gold,  
- Lore item: `Ridge-etched Chalk` (flavor, may be used in later puzzles),  
- Reputation with Rangers & Shrine.

**Implementation Notes:**

- No combat yet — this is tension-building.
- Script:
  - Use camera/screen shake, distant VFX for Red zone anomalies.

---

### 4.5 Q10034 — “The Line We Crossed”

- **QuestID:** 10034  
- **Type:** MAIN (Scripted first “real” death)  
- **Giver:** Automatically from Calren/Ranger Captain after Q10033.  
- **Prereqs:** Q10033.  

**Summary:**  
On the way back from the ridge, an **ambush** is triggered — bandits or Ether-twisted creatures strike. This is tuned to be **overwhelming** for a solo early-game player, with intent to kill them at least once.

**Objectives:**

- Survive the ambush **as long as possible**.  
- Objective text explicitly says:
  - “Fight or flee; if you fall, the Shrine will find you.”  
- There is **no win condition** in the normal sense.

**Outcome:**

- Player is **very likely killed**:
  - Their gear is dropped into a corpse chest per full-loot rules.  
- They then **respawn at the nearest Shrine** (Greycrag Shrine Outpost).

**Rewards:**

- Completion is granted **on death or escape**:
  - If they somehow survive and reach Greycrag:
    - Quest completes with alternate text.  
- No immediate material reward — the “reward” is the next step of the chain.

**Implementation Notes:**

- This is where AL Shrine System is truly exercised:
  - No ghost phase, live respawn,
  - Map pins disappear for group in Red/Yellow as per design.
- Difficulty:
  - Enough damage to kill normal players,
  - But not a one-shot; they *experience* the fight first.

---

### 4.6 Q10035 — “Price of Returning”

- **QuestID:** 10035  
- **Type:** MAIN (Recover Your Body / Gear)  
- **Giver:** Shrine Outpost Warden or Acolyte Seris at Greycrag Shrine.  
- **Prereqs:** Q10034 completed (player has died or escaped).  

**Summary:**  
At the Shrine, Warden Calren (or local Warden) bluntly explains: your body and gear lie where you fell. You must go retrieve them, or accept the loss.

**Objectives:**

- Talk to **Shrine Warden** to get a vision of your corpse location.  
- Travel back to your **corpse chest** on the Bleached Road.  
- Loot your chest and retrieve at least **X%** of your gear.

**Rewards:**

- Restoration of original gear (if retrieved),  
- Shrine reputation,  
- Optional small material compensation if some gear was lost (configurable).

**Implementation Notes:**

- If player insured gear via Ledger earlier:
  - IL chain / Insurance system can:
    - Inject extra mail gold payout here if items are missing.
- If corpse was looted by another player (in a true multiplayer scenario):
  - Quest still completes:
    - With Warden explaining:
      - “The world took its share. The Shrine returns what it can.”

---

### 4.7 Q10036 — “Debts of Flesh and Coin”

- **QuestID:** 10036  
- **Type:** MAIN (Shrine + Ledger aftermath)  
- **Giver:** Warden Calren (Shrine) + Ledger Clerk Brax via messenger.  
- **Prereqs:** Q10035.  

**Summary:**  
You are summoned to a **joint meeting** between Shrine and Ledger representatives at Greycrag. They lay out your “account” after your first real death.

**Objectives:**

- Attend a **Shrine–Ledger debrief** meeting in Greycrag.  
- Listen to:
  - Shrine view:
    - “Your Ether screamed; we answered.”  
  - Ledger view:
    - “We incurred costs to recover your remains and transfer notice.”  
- Choose one of two responses:
  - “I accept the cost and will be more careful” → Shrine leaning.  
  - “I see, this is a risk I can leverage” → Ledger leaning.

**Rewards:**

- Reputation shift:
  - Slightly more Shrine or Ledger rep depending on choice.  
- Title progress:
  - Toward future titles like “Measured Survivor”, “Calculated Risk-taker”.  
- Optionally:
  - Small **fee or tax** is applied:
    - e.g., minor durability loss, or a “Shrine tithe” in gold.

**Implementation Notes:**

- This scene:
  - Solidifies tone of the game:
    - Death is serious, but not strictly punitive; it’s part of an economy.

---

### 4.8 Q10037 — “Stand on Your Own Two Feet”

- **QuestID:** 10037  
- **Type:** MAIN (Re-equipping & Player Agency)  
- **Giver:** Greycrag Bailiff or Mentor Elira (if she travels).  
- **Prereqs:** Q10036.  

**Summary:**  
You are encouraged to **rebuild** after the loss. You can either craft, buy, or earn replacement gear.

**Objectives:**

- Acquire **3 key gear pieces** via **any combination** of:
  - Crafting at Greycrag workstations,  
  - Buying from Market stalls,  
  - Completing 1–2 local Contracts.  
- Equip all 3 pieces.

**Rewards:**

- Solid baseline gear appropriate to early Yellow zones,  
- Reputation with:
  - Ledger (if you trade/buy),
  - Crafting professions (if you craft),
  - Task Board faction (if you contract).

**Implementation Notes:**

- This quest:
  - Is intentionally flexible, so players:
    - Choose their preferred playstyle (trade, crafts, missions).
- It marks:
  - The psychological “I’m back on my feet” moment.

---

### 4.9 Q10038 — “Shapes in the Red” (Optional Epilogue)

- **QuestID:** 10038  
- **Type:** SIDE / EPILOGUE (Frontier Foreshadow)  
- **Giver:** Frontier Scout at Greycrag Ridge.  
- **Prereqs:** Q10037, certain combat skill threshold.  

**Summary:**  
A Frontier Scout invites you to look **one more time** out over the Red Zone, now as someone who knows what death feels like.

**Objectives:**

- Meet the Scout at the ridge overlook.  
- Use a **Spyglass** to survey:
  - Red Zone landscape,
  - Horde encampments,
  - Moving Strongholds,
  - Distant Rifts.  
- (Optional) Kill **a single low-tier Frontier creature** that strays over the line (scripted, safe-ish).

**Rewards:**

- Small Frontier-aligned standing (Rangers, Shrine, or Cartel depending on dialogue choices).  
- Lore item: `Scout’s Glass` (toy/appearance).  
- Unlocks:
  - Eligibility for **later Act III hooks** into Strongholds, Warfronts, and deeper Frontier content.

**Implementation Notes:**

- This quest:
  - Does not actually push player into full Red Zone yet,
  - But emotionally sets up that:
    - The true game lies beyond the line,
    - You now know what it costs to go there.

---

## 5. Integration Notes

### 5.1 With Existing Specs

- **Shrine System & Death Rules:**
  - Q10034–10036 should strictly follow:
    - `AL. Shrine System (Live Respawn)` spec,
    - Gear drop & corpse chest logic.

- **Insurance & Ledger:**
  - Q10102–10103 (Iron Ledger chain) and **IL-Insurance system** should:
    - Integrate with Q10035:
      - If insured, partial payouts or item replacement triggered.

- **Contracts & Economy:**
  - Q10032 & Q10037:
    - Use existing `MortalTaskBoard.cpp/h` (C++ implementation) and economy specs,
    - Ensure rewards are tuned so:
      - Post-death recovery feels possible, not grindy.

- **Rifts & Midnight Horde:**
  - Ambush in Q10034 and graveyard/echo work from Shrine chain:
    - Should reuse:
      - `zombie_horde_event.lua`,
      - `dynamic_mob_ai.lua`,
      - Ether anomaly visuals.

### 5.2 Difficulty & Tuning

- **Q10034 Ambush**:
  - Should be:
    - Deadly for most players, but:
      - Survivable by outliers (excellent players, groups, or those with mercs).
  - Script logic:
    - If player survives and makes it back:
      - Still counts as “you’ve seen the edge of death,”  
      - Q10035 adapts text (Shrine explains “next time, your Ether will call us”).

- **Corpse Retrieval in Q10035**:
  - Early game:
    - Mob density around corpse location should be reduced after death,
    - To make retrieval feasible solo.

---

## 6. Implementation Checklist

1. **Add Q10030–Q10038 to quest_template** with proper flags.  
2. **Create Greycrag Hamlet:**
   - Inn, small Shrine, bank NPC, market stalls, Task Board, Bailiff.  
3. **Script Bleached Road escorts & ambush event:**
   - Waystones, patrol path, ambush triggers, death handling.  
4. **Wire Shrine Outpost behavior:**
   - Respawn at Greycrag after death during Q10034,  
   - Corpse chest location tracking for Q10035.  
5. **Connect to Ledger/Shrine chains:**
   - Optional dialogue variations if:
     - Player has completed `The Weight of a Coin` or `The Weight of a Soul`.  
6. **Expose to Atlas & MortalUI:**
   - Greycrag pins, Bleached Road route, “First Death” milestone tracking.

---

This Act II pack transforms the **abstract death/shrine design** into an *emotional, playable arc* where the player:

- Crosses into danger,  
- Is almost certainly killed at least once,  
- Learns to retrieve their own gear,  
- Experiences the *social and economic* side of dying,  
- And comes out with a clear sense of “I can handle this world… if I’m smart.”  
