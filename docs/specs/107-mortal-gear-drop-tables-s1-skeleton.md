# Project Canvas: Mortal Warcraft Overhaul  
### File: 107-mortal-gear-drop-tables-s1-skeleton.md  
### Topic: Season 1 Drop Tables – Skeleton Mapping for Key Lanes

> This file gives a **concrete starting skeleton** for per-dungeon / per-event  
> drop tables for several core gear sets: Bruiser, Vanguard, Assassin, Healer.

It is intentionally incomplete and meant as a template for expansion.

---

## 1. Conventions

- **Tier:** T1 or T2.
- **Archetype:** Bruiser, Vanguard, Assassin, Healer.
- **Content Type:** Public Delve / Heroic Delve / Hellgate / Siege / Contract / World Boss / Event.
- **Drop Style:**
  - **Boss Drop:** specific boss loot table.
  - **Chest Drop:** instance completion chest.
  - **Contract Reward:** direct reward from Task Board / Campaign.
  - **Token:** currency used at a vendor to purchase specific set pieces.

---

## 2. Example: Public Delve – “Deadmines (Mortal: Smuggler’s Hold)”

Re-flavored Deadmines public delve with open entrances and mixed PvE/PvP potential.

### Target Sets

- **Bruiser T1 – Street Brawler**
- **Vanguard T1 – Shrine Bulwark**
- **Assassin T1 – Veilrunner (minor chance)**
- **Healer T1 – Sanctum Warden (minor chance)**

### Boss Mapping (Example)

- **Glubtok (Boss 1):**
  - Bruiser:
    - Street Brawler Gloves / Boots (low-mid drop chance).
  - Vanguard:
    - Small chance for Shrine Bulwark Sabatons.
  - Generic:
    - Tokens redeemable for any T1 piece (very low rate).

- **Helix Gearbreaker (Boss 2):**
  - Bruiser:
    - Street Brawler Helm / Waist.
  - Assassin:
    - Veilrunner Grips (low chance).
  - Healer:
    - Sanctum Warden Sandals (very low).

- **Foe Reaper / Sneed-equivalent (Boss 3):**
  - Vanguard:
    - Shrine Bulwark Gauntlets / Legguards.
  - Healer:
    - Sanctum Warden Gloves.
  - Assassin:
    - Veilrunner Shadowbelt (low chance).

- **“Smuggler Captain” (Final Boss):**
  - Bruiser:
    - Street Brawler Chest (higher chance),
    - Street Brawler weapon (brawler mace).
  - Vanguard:
    - Shrine Bulwark Cuirass (low-mid).
  - Healer:
    - Sanctum Warden Robes (low-mid).
  - Assassin:
    - Veilrunner Cowl (low).

### Completion Chest

- On delve completion (all bosses dead / objective met):

  - Guaranteed:
    - 1x **T1 Token** for each player (usable at a city vendor for any T1 starter piece).
  - Chance:
    - One random T1 piece from the sets above.

---

## 3. Example: Hellgate T1 – “Ashen Rift (2–5 Man PvPvE)”

Small Hellgate tuned as an entry-level PvPvE dungeon in a Yellow Zone.

### Target Sets

- **Assassin T1 – Veilrunner (primary)**
- **Bruiser T1 – Street Brawler**
- **Ranger T1 – Pathfinder (future spec)**
- **Healer T1 – Sanctum Warden (support drops)**

### Structure

- Trash → Mini-boss → Final Rift Boss (PvPvE).
- PvP presence: opposing team may be present.

### Drops

- **Mini-boss:**
  - Assassin:
    - Veilrunner Footpads / Shadowbelt (low-mid).
  - Bruiser:
    - Street Brawler Hands/Boots (low).
- **Final Boss:**
  - Assassin:
    - Veilrunner Jerkin / Leggings / Cowl (moderate chance, weighted).
  - Bruiser:
    - Street Brawler Chest / Helm (low-mid).
  - Ranger:
    - Pathfinder early pieces (when defined).
  - Healer:
    - Sanctum Warden Hood (low chance).

- **Hellgate Completion Chest:**
  - Each player:
    - Chance at a Veilrunner set piece (weighted upwards if they queued in as ASSASSIN archetype),
    - Small chance at Bruiser/Healer pieces,
    - Guaranteed small currency (Hellgate Shards) for vendor gear.

---

## 4. Example: Stronghold Siege – “Wintergrasp Adapted”

Wintergrasp reworked as a Mortal Stronghold Siege.

### Target Sets (T2)

- **Vanguard T2 – Iron Covenant (primary)**
- **Healer T2 – Light of the Covenant**
- **Bruiser T2 – Crimson Enforcer (future file)**
- **Battlemage T2 – Arcanum Warmaster (future)**

### Siege Reward Logic (Simplified)

- **Participation Credit:**
  - Based on:
    - Time in zone,
    - Objective activity (captures/defenses),
    - Kills/assists,
    - Role-specific metrics (e.g. damage taken as tank, healing done as healer).

- **Winning Side Rewards:**
  - Increased chance at:
    - One T2 piece relevant to the player’s **declared archetype** (Vanguard/Healer/Bruiser/etc.).
  - Siege Tokens (used at a Siege Quartermaster):
    - X tokens per win,
    - Fewer tokens on loss.

- **Losing Side Rewards:**
  - Smaller token payout,
  - Lower chance at T2 drops, but not zero (to avoid feel-bad “waste of time”).

- **Quartermaster:**
  - Sells:
    - Iron Covenant pieces for Siege Tokens,
    - Light of the Covenant pieces,
    - Some cosmetic siege-flavored gear.

---

## 5. Example: Task Board Contracts – Healing & Bounty

### 5.1 Healing Contracts – T1 Sanctum Warden

- Contracts like:
  - “Triage the Wounded after Midnight Horde,”
  - “Aid the Refugees in [Zone].”

- Reward Structure:
  - Raw gold,
  - Reputation (Civic/Faction),
  - Chance at:
    - Sanctum Warden Sandals / Gloves / Hood (small),
    - Or a **Healer Token** guaranteed after N completions,
      which can be traded for a specific Sanctum Warden piece.

### 5.2 Bounty Contracts – T1/T2 Assassin

- T1:
  - Bounties on regular outlaws:
    - Chances at Veilrunner minor pieces (Gloves/Boots/Belt).
    - Bounty Marks: currency for Veilrunner gear.

- T2:
  - High-value named outlaw bounties:
    - Chance at Night Reaper major pieces (Chest/Legs/Hood).
    - Night Reaper Marks: currency at a Cartel Fence.

---

## 6. How to Extend This

To grow this skeleton into a full loot system:

1. For each **public delve**:
   - Pick 2–3 primary archetypes that fit the theme.
   - Assign:
     - 1–2 set pieces per boss,
     - 1–2 weapon drops,
     - A completion chest profile.

2. For each **Hellgate tier**:
   - Focus on 1–2 archetypes as primaries (e.g. Assassin/Ranger),
   - Use shards/tokens to smooth RNG.

3. For each **Stronghold/Warfront**:
   - Decide primary T2 sets (Vanguard/Healer/etc.),
   - Tune token and drop chances per duration/difficulty.

4. Wire **Campaign & Contracts**:
   - Ensure each archetype has:
     - Early guaranteed T1 pieces,
     - A path to T2 via long-form play (tokens, story arcs).

This file is intentionally light on exact numbers so balance can happen iteratively; it mainly ensures that **the right sets drop in the right places** and that players always have both RNG and deterministic paths to their fantasy gear.
