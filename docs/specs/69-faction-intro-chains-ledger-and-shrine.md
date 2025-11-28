# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Factions & Narrative  
### File: 69-faction-intro-chains-ledger-and-shrine.md  
### Section: Faction Intro Quest Chains — Iron Ledger & Order of the Shrine

---

## Related Specs

- `62-core-lore-and-campaign-skeleton.md` - Core lore and campaign structure
- `68-prologue-and-act1-quest-pack.md` - Act I quests that precede faction intros
- `51-factions-and-standing-system.md` - Faction system and standing mechanics
- `86-mortal-factions-and-standing.md` - Mortal factions implementation
- `60-faction-sanctums.md` - Faction Sanctums referenced in quests
- `13-caravans-contracts.md` - Caravan and courier contracts for Iron Ledger
- `22-healing-and-restoration.md` - Shrines and resurrection for Order of the Shrine
- `04-economy.md` - Economy systems for Iron Ledger

---

## 1. Scope

This document defines **introductory quest chains** for two core factions:

- **Iron Ledger** — the economic machine, banks, tariffs, caravans.  
- **Order of the Shrine** — custodians of Shrines, Ether, and the cost of resurrection.

Each chain is:

- 5–7 quests long,
- Designed for **early-mid game** (after Act I),
- Tied into:
  - Contracts,
  - Death & Shrines,
  - Economies & travel,
  - Frontier foreshadowing.

Proposed ID range: **10100–10149** reserved for early faction storylines.

---

## 2. Iron Ledger Intro Chain — “The Weight of a Coin”

### 2.1 Overview

- **Theme:**  
  “Nothing in the Frontier is free. Every road, every life, is collateral.”

- **Starting Location:**  
  Port Meridian bank/market district.

- **Primary NPCs:**
  - `Ledger Clerk Brax` — mid-level functionary (already seen in Q10016).
  - `Factor Maelis` — higher-ranking official, remote contact.
  - `Auditor Vorren` — stern inspector who evaluates your worth.

- **Gameplay focus:**
  - Caravans & Courier contracts,
  - Taxes & tariffs,
  - Insurance (Soul Insurance / Gear Insurance concept),
  - First exposure to **Ledger Sanctum**.

---

### IL-1 — Q10100 “Terms and Conditions”

- **QuestID:** 10100  
- **Type:** FACTION INTRO (Iron Ledger)  
- **Giver:** Ledger Clerk Brax (Port Meridian).  
- **Prereqs:**  
  - Q10016 “The Weight of a Promise” completed **or**  
  - Sufficient number of courier Contracts completed.

**Summary:**  
Brax considers you promising and invites you to formally read and sign the Ledger’s basic contract. You’re taught their worldview: everything is an account, including lives and debts.

**Objectives:**

- Read the **Ledger Charter** (use an in-inventory book).  
- Sign the Ledger registry (interact with a ledger object in the bank).

**Rewards:**

- **Iron Ledger Reputation:** small boost, unlock Faction tab.  
- Access to **Iron Ledger Contracts** on the Task Board.  
- Cosmetic: “Registered Courier” note on character sheet (internal only).

**Implementation Notes:**

- The Charter book:
  - Lore text explaining:
    - Loans, tariffs, Soul Insurance seeds.
- Registry interaction:
  - Sets `faction_tag='LEDGER'` alignment flag.

---

### IL-2 — Q10101 “Account in Arrears”

- **QuestID:** 10101  
- **Type:** FACTION (Ledger)  
- **Giver:** Ledger Clerk Brax.  
- **Prereqs:** Q10100.  

**Summary:**  
A local merchant has failed to pay their dues. You are instructed to “encourage” compliance, either peacefully or by seizing collateral.

**Objectives:**

- Speak with **Merchant Haldrin** in the lower market.  
- Choose one of two approaches:
  - **Negotiate payment**:
    - Collect gold from Haldrin and return to Brax.  
  - **Seize collateral**:
    - Take **Haldrin’s Crate** (heavy item) to the bank.

**Rewards:**

- Gold payment (portion of debt),  
- Iron Ledger reputation (more if you seize collateral),  
- Moral choice logged (could slightly affect Shrine or Cartel opinion later).

**Implementation Notes:**

- Branching:
  - Use quest flags or follow-up text, but same quest ID output.
- Encumbrance:
  - Crate is heavy to emphasize “debt has weight.”

---

### IL-3 — Q10102 “Premium Coverage”

- **QuestID:** 10102  
- **Type:** FACTION (Ledger)  
- **Giver:** Factor Maelis (via letter, or present in bank).  
- **Prereqs:** Q10101.  

**Summary:**  
Maelis introduces the concept of **Soul Insurance / Gear Insurance**. You must sell an insurance contract to a frontier-bound adventurer.

**Objectives:**

- Receive **Ledger Insurance Contract** item from Maelis.  
- Speak to **Adventurer Rinna** near the city’s Frontier gate.  
- Explain the terms and convince her to:
  - Purchase the insurance (pay fee), or
  - Refuse (you report refusal back).

**Rewards:**

- On **sale**:
  - Gold + reputation,  
  - Unlocks **insurance services** at Ledger NPCs.  
- On **refusal**:
  - Reduced reward,  
  - Leads to a follow-up quest demonstrating the consequences (IL-4).

**Implementation Notes:**

- Insurance Mechanic Hook:
  - This quest should toggle:
    - Access to an `insurance_service.lua`:
      - Where players can insure specific items for partial payout on loss.
  - Rinna is flagged:
    - If she refuses, she later appears as a death event example.

---

### IL-4 — Q10103 “Claim Denied”

- **QuestID:** 10103  
- **Type:** FACTION (Ledger, narrative consequence)  
- **Giver:** Factor Maelis (or Auditor Vorren).  
- **Prereqs:** Q10102 (regardless of branch).  

**Summary:**  
You’re asked to inspect a body brought back from the Frontier — the unlucky Adventurer Rinna if she refused coverage, or a different anonymous corpse if she accepted.

**Objectives:**

- Visit the **Shrine morgue** or Ether-chamber with Maelis/Vorren.  
- Examine the **Corpse Ledger**:
  - Shows their debts, assets, and insured status.  
- Report to Maelis.

**Rewards:**

- Unlock **Ledger/Shrine interplay lore**:
  - How Shrines and the Ledger cooperate in body recovery & asset distribution.
- Iron Ledger reputation,
- Small Shrine reputation.

**Implementation Notes:**

- Optional:
  - Show side-by-side outcomes via gossip:
    - “With insurance vs without.”
- Hooks into:
  - Future Soul Insurance UI (NPC gossip menu).

---

### IL-5 — Q10104 “Caravan at Risk”

- **QuestID:** 10104  
- **Type:** FACTION (Ledger, Group-friendly)  
- **Giver:** Auditor Vorren (Port Meridian).  
- **Prereqs:** Q10103 + character level/skill threshold.  

**Summary:**  
A valuable caravan is heading toward a Yellow-border region. The Ledger hires you as **escort** and **observer**, tracking damage and loss.

**Objectives:**

- Meet the **Caravan Lead** just outside Port Meridian.  
- Escort caravan along a road segment into Yellow zone.  
- Defend it from:
  - Bandit ambushes,
  - Low-level Rift anomalies (scripted waves).  
- Ensure at least **X% cargo** survives to the destination outpost.

**Rewards:**

- Significant Gold + Ledger reputation,  
- Bonus if cargo survives above threshold,  
- Unlock **Ledger Caravan Contracts** (repeatable contracts in world).

**Implementation Notes:**

- Implement using:
  - Escorted cart with HP and cargo value,
  - OnComplete:
    - Update Ledger rep,
    - Possibly unlock more advanced courier roles.
- Good candidate for:
  - Being reused later in **Seasonal Events** related to economy.

---

### IL-6 — Q10105 “Ledger Sanctum: Balance Sheet”

- **QuestID:** 10105  
- **Type:** FACTION (Sanctum Intro)  
- **Giver:** Factor Maelis.  
- **Prereqs:** Q10104, certain Ledger rep threshold.  

**Summary:**  
Maelis invites you into a **hidden Ledger Sanctum**, where true accounts are kept. You are asked to choose a focus: Risk, Trade, or Enforcement.

**Objectives:**

- Travel to the **Iron Ledger Sanctum** (instanced interior, accessed via special door/portal in bank).  
- Speak to:
  - `Risk Assessor Neral` (insurance/markets path),  
  - `Trade Architect Salya` (contracts/trade path),  
  - `Enforcement Agent Korr` (bounty/collection path).  
- Declare your **Ledger focus** (for initial Faction perks).

**Rewards:**

- Small **Sanctum perk**:
  - e.g. minor fee discount on bank services,  
  - Or slightly improved insurance rates,
  - Or better payouts for certain contract types.
- Title seed:
  - Progress toward titles like “Junior Assessor”, “Debt Collector”, etc.

**Implementation Notes:**

- This quest:
  - Forms the **end of the intro chain**,
  - Opens more advanced Faction content and contracts.

---

## 3. Order of the Shrine Intro Chain — “The Weight of a Soul”

### 3.1 Overview

- **Theme:**  
  “Life is borrowed. Death is a ledger entry in Ether.”

- **Starting Location:**  
  Port Meridian Shrine, or after first **scripted death** (Act II tie-in later).

- **Primary NPCs:**
  - `Acolyte Seris` — approachable guide/priest.
  - `Warden Calren` — stern, battle-scarred Shrinemaster.
  - `Archivist Nyra` — records Ether imprints and past lives.

- **Gameplay focus:**
  - Introducing new death/respawn rules,
  - Ether & Shrines,
  - Ghost/Ether lore,
  - Shrine fragments & Midnight Horde foreshadowing.

---

### SH-1 — Q10120 “A Candle in the Dark”

- **QuestID:** 10120  
- **Type:** FACTION INTRO (Shrine)  
- **Giver:** Acolyte Seris (Port Meridian Shrine).  
- **Prereqs:**  
  - Q10010 (arrival), or  
  - Player has died at least once in any context.

**Summary:**  
Seris notices that your Ether is “loud” — you are newly tied to this Shrine. She asks you to light a candle for the lost and sit in contemplation.

**Objectives:**

- Light a **Memorial Candle** at the Shrine altar.  
- Use `/kneel` or similar emote in a marked spot for 10 seconds.

**Rewards:**

- Small Shrine reputation,  
- Flavor item: `Wax-Dipped Charm` (simple neck appearance).

**Implementation Notes:**

- Simple but atmospheric,
- Teaches that Shrines are more than respawn machines.

---

### SH-2 — Q10121 “Echoes in the Ether”

- **QuestID:** 10121  
- **Type:** FACTION (Shrine, Ether tutorial)  
- **Giver:** Acolyte Seris.  
- **Prereqs:** Q10120.  

**Summary:**  
Seris guides you through hearing the “echoes” of those who died too far from Shrines. You must locate spots where Ether is disturbed.

**Objectives:**

- Visit **3 Ether Echo points** around Port Meridian:
  - A drowned sailor’s cove,  
  - A ruined watchtower,  
  - The outskirts where bandits killed a caravan.  
- Use a **Shrine Attunement Crystal** to “listen” at each point.

**Rewards:**

- Shrine reputation,  
- Unlocks **Ether Echos** as:
  - Occasional world lore elements (ambient whispers, hints).

**Implementation Notes:**

- Each Echo point:
  - Plays a short whisper sequence or text line when crystal is used.
- Sets up:
  - The idea of Ether “pollution” that fuels Midnight Horde, Rifts.

---

### SH-3 — Q10122 “The Price of Returning”

- **QuestID:** 10122  
- **Type:** FACTION (Shrine, death mechanic intro)  
- **Giver:** Warden Calren.  
- **Prereqs:** Q10121, OR the player has died at least once.  

**Summary:**  
Calren explains plainly: resurrection has a cost. He asks you to **simulate** a death ritual using an Ether dummy to demonstrate gear loss and live-respawn.

**Objectives:**

- Interact with an **Ether Effigy** in Shrine’s side chamber.  
- Witness a **vision**:
  - Player avatar “dies” and respawns at Shrine with 0 gear.  
- Collect your **shunted gear** from a training corpse chest (safe, no actual loss).

**Rewards:**

- Deeper understanding of:
  - Live respawn (no ghost mode),
  - Gear dropping on death,
  - Need to reclaim gear or rely on banks.
- Shrine reputation.

**Implementation Notes:**

- Implementation can be:
  - Short scripted scene using phasing/auras,
  - No real loss, but mimic the **AL Shrine System** flow.

---

### SH-4 — Q10123 “Holding the Line”

- **QuestID:** 10123  
- **Type:** FACTION (Shrine, combat support)  
- **Giver:** Warden Calren.  
- **Prereqs:** Q10122, minimum combat skill threshold.  

**Summary:**  
Shrine is short-handed. Calren asks you to assist in clearing **restless spirits** near Meridian’s graveyard; a small taste of Midnight Horde logic.

**Objectives:**

- Kill **8 Restless Dead** in the graveyard area.  
- Seal **2 Weak Grave Rifts** using the Attunement Crystal.

**Rewards:**

- Shrine reputation,  
- Chance for **Shrine-aligned Rune fragment** drop,  
- Unlocks:
  - Special Shrine Contracts on Task Board (Rift defense, Horde culls).

**Implementation Notes:**

- Mobs:
  - Slightly tuned above normal, but not deadly.
- Grave Rifts:
  - Miniature, low-tier Rift objects.

---

### SH-5 — Q10124 “Names in the Book”

- **QuestID:** 10124  
- **Type:** FACTION (Shrine, archive intro)  
- **Giver:** Archivist Nyra (inside Shrine archives).  
- **Prereqs:** Q10123.  

**Summary:**  
Nyra reveals that every player who dies has their Ether imprint recorded. You must look up a few records and see how their choices shaped their fates.

**Objectives:**

- Examine **3 Ether Records**:
  - “The Brave Fool” (died in Red Zone, uninsured, no bank deposits),  
  - “The Careful Coward” (always banked & insured, low risk, slow gains),  
  - “The Measured Risk-Taker” (mixed approach).  
- Talk to Nyra about which path resonates with you.

**Rewards:**

- Shrine rep,  
- Minor permanent **flavor-only “Ethos flag”**:
  - Could be referenced in future dialogue or tiny events.

**Implementation Notes:**

- This quest:
  - Frames risk/reward philosophies,
  - Showcases intended player archetypes.

---

### SH-6 — Q10125 “Shrine Sanctum: The Quiet Hall”

- **QuestID:** 10125  
- **Type:** FACTION (Sanctum Intro)  
- **Giver:** Warden Calren or Archivist Nyra.  
- **Prereqs:** Q10124, Shrine rep threshold.  

**Summary:**  
You are invited to the **Shrine Sanctum**, a deeper hall where only those who accept the cost of the Frontier may tread.

**Objectives:**

- Enter the **Shrine Sanctum** via hidden door/ritual in the Shrine.  
- Speak with:
  - `Keeper Arel`,  
  - `Watcher Lyss`,  
  - `Mortarch Devran`.  
- Choose a **Shrine discipline focus**:
  - **Aegis** (shields/mitigation),  
  - **Renewal** (HoTs/regen),  
  - **Surge** (totems/burst).

**Rewards:**

- Unlock:
  - Initial Shrine **Trial access** (role-specific Trial path),  
  - Small passive Shrine perk (e.g. slightly reduced durability damage on repair, or cheaper Shrine services).
- Progress toward titles like:
  - “Initiate of Ash,” “Bound to the Shrine,” etc.

**Implementation Notes:**

- Mirrors Ledger Sanctum quest structure,
- Ties into healing & support archetypes from `64-spell-and-ability-library.md`.

---

## 4. Flow & Interplay

### 4.1 When Players See These Chains

- Iron Ledger chain:
  - Naturally follows after:
    - Courier work in Port Meridian (Q10016),  
    - First interactions with market & bank.
- Shrine chain:
  - Naturally follows after:
    - First Shrine visit,
    - Or first **actual death** in Yellow/Red zones (Act II event).

### 4.2 Cross-Faction Tension

- Iron Ledger and Shrine:
  - Collaborate (insurance & body recovery),
  - But may have:
    - Subtle philosophical conflicts (profit vs mercy).

Examples:

- If player heavily favors hard collection methods in IL-2:
  - Some Shrine NPCs might have slightly more critical lines later.
- If player always picks “compassionate” Shrine responses:
  - Ledger might see them as “soft,” slightly reducing certain perk choices.

This does **not** lock players into one faction only, but influences:

- Dialogue tones,
- Minor prices/perks,
- Personal title flavor.

---

## 5. Implementation Checklist

1. **Reserve ID ranges:**
   - 10100–10109 for Iron Ledger intro.
   - 10120–10129 for Shrine intro.

2. **Create Faction records:**
   - Ensure Iron Ledger & Order of the Shrine are:
     - Faction entries in DB,
     - Used in reputation tables.

3. **Implement Sanctum maps/interiors:**
   - Ledger Sanctum (bank backroom / hidden hall).
   - Shrine Sanctum (inner chamber behind Shrine).

4. **Wire Contracts & Insurance hooks:**
   - Connect IL-2 / IL-3 to:
     - Soul/Gear insurance system.
   - Connect SH-3 / SH-4 to:
     - Shrine defense contracts & Midnight Horde logic.

5. **Create basic Trials hooks:**
   - SH-6 & IL-6:
     - Should unlock simple, initial Trials later sourced from separate Trial specs.

---

These two chains give players **early narrative anchors** for:

- The **money faction** (Iron Ledger) and its obsession with risk & collateral,  
- The **death faction** (Order of the Shrine) and its stewardship over the cost of resurrection,

while smoothly hooking into your existing systems: Contracts, Insurance, Shrines, Rifts, Trials, and Seasons.
