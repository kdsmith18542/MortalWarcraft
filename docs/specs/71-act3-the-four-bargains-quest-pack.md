# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative Implementation  
### File: 71-act3-the-four-bargains-quest-pack.md  
### Section: Act III — “The Four Bargains” Quest Pack

---

## Related Specs

- `62-core-lore-and-campaign-skeleton.md` - Core lore and campaign structure
- `70-act2-price-of-life-quest-pack.md` - Act II quests that precede Act III
- `72-act4-strongholds-and-invasions-campaign.md` - Act IV quests that follow Act III
- `51-factions-and-standing-system.md` - Faction system central to Act III
- `86-mortal-factions-and-standing.md` - Mortal factions implementation
- `59-shrine-and-faction-trials.md` - Faction Trials referenced in Act III
- `60-faction-sanctums.md` - Faction Sanctums unlocked in Act III
- `91-mortal-anomalies-rifts-hellgates.md` - Rifts and Hellgates referenced in Act III
- `08-guilds-sovereignty.md` - Strongholds referenced in Act III

---

## 1. Scope

Act III formalizes the **sandbox-aligned factions** and gives the player their first **big, meaningful choices** without hard-locking them:

- **Iron Ledger** – risk, caravans, insurance, markets.
- **Order of the Shrine** – death, Ether, resurrection, defense.
- **Black Sun Cartel** – smuggling, shadow contracts, underworld.
- **Frontier Rangers** – scouting, wildlands defense, strongholds.

Goals:

- Turn “flavor alignment” from Acts I–II into:
  - Concrete Trials,
  - First **faction boons** (small but noticeable),
  - Hooks into midgame loops (Strongholds, Rifts, Warfronts, economy).
- Preserve **freedom**:
  - Players can do more than one faction’s content,
  - But repeated favoring of a faction **tilts perks, access, and title flavor**.

Act III uses QuestIDs **10150–10199** for shared & faction trial entries.

---

## 2. Structure Overview

### 2.1 Entry Point

Act III begins after:

- Act II mainline completed (`Price of Life` chain, Q10030–10038), and
- Player reaches a **soft progression threshold**:
  - Total skill points ≈ 400–500 (dynamic Level ~9–10),
  - Or completion of at least:
    - One regional economy loop (trade run),  
    - One Rift/Hellgate or Public Dungeon run (optional).

Starting quest: **Q10150 “Four Voices at the Fire”**

---

## 3. Shared Act III Setup

### 3.1 Q10150 — “Four Voices at the Fire”

- **QuestID:** 10150  
- **Type:** MAIN (Act III opener)  
- **Giver:** `Greycrag Bailiff` or `Harbor Warden Serra` via letter.  
- **Prereqs:**  
  - Q10037 “Stand on Your Own Two Feet” completed,  
  - Character meets progression threshold.

**Summary:**  
You’re invited to a **council fire** just outside Greycrag, where representatives of the four Powers meet in tense “peace” to discuss the growing Frontier threat and the need for capable agents.

**Objectives:**

- Travel to the **Council Fire** camp near the Bleached Road / Ridge.  
- Listen to short speeches from:
  - **Ledger Factor Maelis**,  
  - **Shrine Warden Calren**,  
  - **Cartel Broker Selias**,  
  - **Ranger Captain Thera**.  
- Speak to each representative once.

**Rewards:**

- Unlock:
  - Four follow-up “trial offer” quests (one per faction),
  - Faction UI tab updates to show **Trial availability**.
- Small gold and XP→gold equivalent.

**Implementation Notes:**

- Scene:
  - Use campfire GameObject + chairs/props,
  - Optionally phase the camp so only players with Q10150 active see it.
- Dialogue:
  - Each faction pitches its philosophy & needs:
    - Ledger: “The Frontier is a balance sheet.”  
    - Shrine: “The dead are stacking faster than candles.”  
    - Cartel: “Where fear grows, so do margins.”  
    - Rangers: “No one else will guard the gaps.”

---

## 4. Faction Trial Offers

After Q10150, the player receives **four parallel “offer” quests**:

- Q10151 — Iron Ledger: “Trial of Collateral”
- Q10152 — Order of the Shrine: “Trial of Vigil”
- Q10153 — Black Sun Cartel: “Trial of Shadow”
- Q10154 — Frontier Rangers: “Trial of the Line”

Players can accept **any or all**. Completing Trials affects **standing and perks**, not hard locks.

---

## 5. Iron Ledger Trial — “Trial of Collateral”

### 5.1 Q10151 — “Ledger Trial: Collateral”

- **QuestID:** 10151  
- **Type:** FACTION TRIAL (Iron Ledger)  
- **Giver:** Factor Maelis at the Council Fire.  
- **Prereqs:** Q10150.

**Summary:**  
Maelis challenges you to prove you understand the Ledger’s principles: **risk must be priced, and collateral must be claimed**. You will accompany and *audit* a caravan deep into Yellow territory, making decisions on the fly.

**Objectives:**

1. Meet **Caravan Lead Doran** at Port Meridian’s outer gate.  
2. Escort the caravan through:
   - The Bleached Road,  
   - Into deeper Yellow segments with higher ambush risk.  
3. During the journey, make 2–3 **branching decisions**:
   - Pay local “road tax” to bandits vs fight,  
   - Dump low-value cargo to lighten load vs accept slower travel,  
   - Accept or decline a side deal from a Cartel-aligned NPC.

**Completion Conditions (Pick One Path):**

- Caravan reaches destination with **≥80% cargo** intact, or  
- Caravan reaches destination with **≤50% cargo**, but:
  - High-profit crates preserved,  
  - Ledger “profit” actually improved, or  
- Caravan is partially lost, but:
  - You recover key **Ledger Ledger** (records) and return to Maelis.

**Rewards:**

- Iron Ledger Reputation:  
  - High if profit-focused, moderate if safety-focused.  
- Ledger Trial Perk (pick one of 2 small perks, once Trial complete):  
  - **“Preferential Rates”** – slightly reduced **bank & insurance fees**, OR  
  - **“Freight Intuition”** – minor passive bonus to cargo value recovery or contract payouts.

**Implementation Notes:**

- Escort event:
  - Use cart NPC with HP + “cargo value” variable in script.
- Decisions:
  - Handled via gossip with NPCs mid-journey, storing flags on player.
- This Trial:
  - Feeds into economy loops, Warfront supply logic later.

---

## 6. Shrine Trial — “Trial of Vigil”

### 6.1 Q10152 — “Shrine Trial: Vigil”

- **QuestID:** 10152  
- **Type:** FACTION TRIAL (Shrine)  
- **Giver:** Warden Calren at Council Fire.  
- **Prereqs:** Q10150.

**Summary:**  
Calren tasks you with holding a **night-long Vigil** at a small roadside Shrine outpost, defending it against waves of Ether-twisted attackers without letting the Shrine’s core be breached.

**Objectives:**

- Travel to **Vigil Shrine** – a small altar along a secondary Yellow road.  
- Initiate the **Vigil** (use Shrine focus object).  
- Survive **3 escalating waves** of attackers:
  - Wave 1: Restless Dead, weak.  
  - Wave 2: Ether-touched beasts, mid-tier.  
  - Wave 3: Mixed, including a mini-elite.  
- Prevent the **Shrine Heart** from being destroyed.
- Optional:
  - Revive 1–2 fallen **NPC defenders** using limited Rituals (click-to-assist).

**Success Conditions:**

- Shrine Heart HP > 0 at the end of the event.  
- If the player dies:
  - They respawn at Vigil Shrine and can continue,
  - But repeated deaths might reduce bonus rewards.

**Rewards:**

- Shrine Reputation (scaling with success – fewer deaths, higher).  
- Shrine Trial Perk (choose 1 of 2):  
  - **“Vigilant Spirit”** – slight reduction in durability loss on repair, OR  
  - **“Shrine’s Grace”** – marginally reduced Shrine service costs or small heal on respawn.

**Implementation Notes:**

- Event script:
  - Uses `zombie_horde_event.lua` style logic with tuned wave size.
- Visuals:
  - Heavy Ether visual effects, faint whispers, to emphasize lore.
- Co-op friendly:
  - Multiple players can help defend; Trial credit handled per player.

---

## 7. Cartel Trial — “Trial of Shadow”

### 7.1 Q10153 — “Cartel Trial: Shadow”

- **QuestID:** 10153  
- **Type:** FACTION TRIAL (Black Sun Cartel)  
- **Giver:** Broker Selias at Council Fire.  
- **Prereqs:** Q10150.

**Summary:**  
Selias offers you a “simple” job: **smuggle contraband** past Frontier patrols without being caught. You must choose between stealth, bribery, and underhanded tricks.

**Objectives:**

1. Meet Selias’s agent **“Whisper”** in a back alley of Greycrag.  
2. Receive **Contraband Crate** (heavy, illegal item) with:
   - Strong warning: if guards detect you, you’ll earn **Notoriety**.  
3. Deliver the crate to a **Cartel Drop Point** in a **Yellow zone hamlet** on a different road.

**Encounter Mechanics:**

- Patrols:
  - Ledger guards, Rangers, or Shrine scouts may inspect passersby.  
- Detection:
  - If carrying Contraband Crate and get too close / fail stealth:
    - You risk:
      - Fines,
      - Notoriety gains,
      - Potential open combat.

**Possible Approaches:**

- **Stealth Route:**  
  - Use side paths, stealth potions, timing to avoid patrols.  
- **Bribery Route:**  
  - Pay off one patrol leader via special dialogue option.  
- **Violent Route:**  
  - Kill or distract a patrol, gaining Notoriety.

**Rewards:**

- Cartel Reputation (highest with stealth/cleverness, still some if violent).  
- Cartel Trial Perk (pick one):  
  - **“Smuggler’s Guile”** – small bonus to profit from shadow contracts & black market sales, OR  
  - **“Quiet Footsteps”** – very minor movement/stealth benefit when encumbered by contraband.

**Implementation Notes:**

- Patrol AI:
  - Uses basic aggro + gossip check (Ask to inspect packs).
- Notoriety:
  - Hook into existing Notoriety/Bounty Board systems:
    - If caught & fight: minor Notoriety + possible bounty.

---

## 8. Ranger Trial — “Trial of the Line”

### 8.1 Q10154 — “Ranger Trial: The Line”

- **QuestID:** 10154  
- **Type:** FACTION TRIAL (Frontier Rangers)  
- **Giver:** Ranger Captain Thera at Council Fire.  
- **Prereqs:** Q10150.

**Summary:**  
Thera asks you to help hold the **first line** between Yellow and Red zones, tracking incursions and dealing with a small **Frontier breach**.

**Objectives:**

1. Report to **Ranger Forward Camp** near the Frontier Ridge.  
2. Use a **Ranger’s Beacon** to mark three:
   - Frontier incursion points where Red mobs have strayed into Yellow.  
3. Defeat:
   - Several small packs of Frontier creatures,  
   - One **mini-elite “Stray Anomaly”** or corrupted beast.  
4. Place **Ranger Totems** at two points to solidify the line temporarily.

**Rewards:**

- Ranger Reputation,  
- Ranger Trial Perk (choose one):  
  - **“Road Watcher”** – small bonus to movement speed on roads, OR  
  - **“Frontier Sense”** – slight awareness radius increase for ambush/bandit detection.

**Implementation Notes:**

- This Trial:
  - Reinforces the concept of **the Line**:  
    - Yellow is contested but salvageable,  
    - Red is chaos.
- Beacon & Totem:
  - Use simple item-use on ground, spawn visible markers & area effects.

---

## 9. Act III Resolution Quest

### 9.1 Q10160 — “Bargains on the Ledger”

- **QuestID:** 10160  
- **Type:** MAIN (Act III wrap-up)  
- **Giver:** Automatically granted after completing **any 2 Trials** minimum.  
- **Prereqs:**  
  - Q10150,  
  - At least two of Q10151–Q10154 completed.

**Summary:**  
You’re summoned back to the **Council Fire**. The four representatives acknowledge your contributions and warn you that, going forward, **every action will tip the scales further**.

**Objectives:**

- Return to the Council Fire.  
- Speak with each representative again:
  - They react differently depending on:
    - Which Trials you completed,  
    - How you behaved within them (profit vs safety, stealth vs violence, etc.).  
- Accept the status of **“Free Agent of the Frontier”**.

**Rewards:**

- Global passive flag:
  - Allows you to accept **midgame Faction Contracts**, Trials, and Missions across the Frontier.  
- Mild universal buff:
  - e.g. “Frontier Familiarity” – small resistance to environmental penalties or slightly reduced penalties in Yellow zones.
- Progress toward global titles like:
  - “Frontier Initiate”, “Agent of the Four”.

**Implementation Notes:**

- No hard lock:
  - You can continue to deepen with all, but:
    - Some perks may **conflict** later (high-end specializations).
- This quest:
  - Serves as the **gateway into full midgame**:
    - Strongholds,
    - Warfront-related tasks,
    - Deeper Rifts/Hellgates.

---

## 10. System Hooks & Dependencies

### 10.1 Required Systems in Place

Before implementing Act III fully, make sure:

- **Notoriety & Bounty Board** are at least minimally functional:
  - Cartel Trial interacts with them.
- **Road Speed & Encumbrance** systems are active:
  - Ledger, Ranger, Cartel Trials use roads & loads.
- **Shrine & Death Mechanics** are stable:
  - Shrine Trial depends on live-respawn and defense events.
- **Task Boards & Contracts** are functioning:
  - Rewards & follow-ups reference Contracts.

### 10.2 Atlas & MortalUI Integration

- Add Act III elements to Atlas/MortalUI:
  - **Council Fire map pin**,
  - Faction panels showing:
    - Current standing,
    - Trial complete status,
    - Selected perks.
- Optionally:
  - Show recommended Trial order or difficulty.

---

## 11. Implementation Checklist

1. **Quest Templates:**
   - Add Q10150, Q10151–Q10154, Q10160 to `quest_template` with appropriate flags.  

2. **Council Fire Camp:**
   - Place NPCs & fire,
   - Phase logic for Q10150 & Q10160.

3. **Faction Trials:**
   - Ledger:
     - Caravan escort + decision logic,  
     - Profit/cargo tracking.  
   - Shrine:
     - Vigil wave event + Shrine Heart HP tracking.  
   - Cartel:
     - Contraband Crate, patrol detection, Notoriety hooks.  
   - Rangers:
     - Frontier incursion tracking, Beacon/Totem placement.

4. **Perks:**
   - Implement small, passive **faction perks**:
     - Keep them modest but noticeable,
     - Store selections on player as aura/spell/DB flag.

5. **Dialogue Variants:**
   - Reuse IL & Shrine intro chains:
     - If player already progressed far in one faction,  
     - NPC tone changes during and after Trials.

---

Act III turns your world from “tutorial + first death” into **“you are now a named piece on the board.”**  

From here, the natural follow-ups are:

- Stronghold Sovereignty arcs,  
- Warfront/Zone Invasion arcs,  
- And midgame economic warfare (markets, Ledger vs Cartel games).  
