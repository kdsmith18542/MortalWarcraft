# Realm 2 Design – Expansion‑Progressive WotLK (Vanilla → TBC → Wrath)

**Realm Name (working):** Mortal Warcraft: Legacy Journey  
**Core:** AzerothCore 3.3.5a  
**Realm Type:** PvE‑leaning PvP (normal WotLK ruleset, no full loot)  
**Style:** Expansion‑progressive (Vanilla → TBC → WotLK) using a single 3.3.5a client and final‑patch mechanics.

---

## 0. Purpose & Positioning

Realm 1 (Mortal Warcraft) is a **classless sandbox**, full/partial loot, heavy custom systems.  
Realm 2 is the **comfort realm**:

- Classic class/talent gameplay.
- Expansion‑style progression: **Era I (60) → Era II (70) → Era III (80)**.
- Minimal custom systems, focus on **polish, stability, and longevity**.
- No pay‑to‑win, no wipes plan, no extreme experiments.

This document defines the **high‑level design** and **era rules** so there are no big gaps when implementing.

---

## 1. Core Design Pillars

1. **Progress Through Eras, Not Patches**  
   Players level and progress through:
   - Era I – “Legacy of the Eastern Kingdoms” (Vanilla era, level 60 cap).  
   - Era II – “Burning Skies” (TBC era, level 70 cap).  
   - Era III – “Wrath of the North” (Wrath era, level 80 cap).

2. **Single Client, Final Mechanics**  
   - Always use **3.3.5a talents, spells, and mechanics**.
   - We simulate Vanilla/TBC eras via:
     - Level caps,
     - Zone/instance gating,
     - Item/loot filtering.

3. **Polished, Mostly‑Blizzlike Gameplay**  
   - Dungeons/raids/quests follow original layout & core behavior.
   - Custom content and tuning are **light and respectful**, not complete rewrites.

4. **Player‑Friendly QoL, No P2W**  
   - Reasonable XP/rep/profession rates.
   - Alt‑friendly systems and some account‑wide unlocks.
   - Monetization limited to cosmetics and mild convenience items.

5. **Long‑Term Stability**  
   - No planned wipes.
   - Transparent roadmap for era changes and content unlocks.

---

## 2. Era Structure Overview

Each era defines:

- **Level cap**  
- **Available continents/zones**  
- **Dungeons/raids enabled**  
- **Expansion‑specific systems** (flying, DKs, etc.)  
- **Dungeon Finder behavior**  

### 2.1 Era I – “Legacy of the Eastern Kingdoms” (Vanilla Era)

**Goal:** Play through Azeroth as a level 60 environment with WotLK mechanics.

- **Level Cap:** 60
- **Continents:**
  - Eastern Kingdoms & Kalimdor: **enabled**.
  - Outland: access locked.
  - Northrend: access locked.
- **Travel:**
  - Boats/zeps/portals to Outland/Northrend disabled.
  - Failsafe: server scripts teleport or deny entry if a player glitches in.

- **Dungeons Enabled (examples):**
  - Ragefire, RFC, WC, SFK, BFD, Stocks, Gnomer, SM, RFD, RFK, Mara, Uldaman, ZF, ST, BRD, LBRS/UBRS, Strat, Scholo, Dire Maul, etc.
- **Raids Enabled:**
  - Onyxia, Molten Core, Blackwing Lair, Zul’Gurub, AQ20, AQ40, Naxx40 (optional: can be advanced “final” vanilla tier).

- **Dungeon Finder (Era I Behavior):**
  - **LFG tool ON** for listing and forming groups (no auto‑teleport).
  - Random Dungeon Finder queue **can be disabled or limited** (config option):
    - Option A: Disabled entirely in Era I.
    - Option B: Enabled but **no teleport**, only bonus rewards.

- **Classes/Races:**
  - All WotLK races & classes technically available.
  - **Death Knights disabled** (creation blocked) in Era I.

- **Professions:**
  - All primary professions available.
  - Optional: Restrict Inscription/Jewelcrafting if desired, or just allow from the start for convenience.

- **PvP:**
  - Battlegrounds (WSG, AB, AV, EotS if desired; can delay EotS to Era II).
  - No arena yet (optional: pre‑arena BG focus in Era I).
  - World PvP zones like Silithus objectives optional.

---

### 2.2 Era II – “Burning Skies” (TBC Era)

**Goal:** Open Outland and level 70 progression while still using WotLK class balance.

- **Level Cap:** 70
- **Continents:**
  - Eastern Kingdoms & Kalimdor: enabled (still relevant).
  - Outland: **enabled** (Dark Portal functional).
  - Northrend: still locked.

- **Dungeons Enabled:**
  - All Vanilla dungeons remain available.
  - TBC dungeons: Ramparts, Blood Furnace, Shattered Halls, Slave Pens, Underbog, Steamvault, Mana‑Tombs, Auchenai Crypts, Sethekk Halls, Shadow Lab, Botanica, Mechanar, Arcatraz, Magister’s Terrace, etc.

- **Raids Enabled:**
  - Entry Tier: Karazhan, Gruul’s Lair, Magtheridon.
  - Mid Tier: SSC, TK.
  - Final Tier: Hyjal, Black Temple, Sunwell.
  - Content can open in TBC‑like phases (Karazhan first, Sunwell last) or more compressed schedule.

- **Dungeon Finder:**
  - Era II default:
    - LFG and RDF allowed for TBC dungeons, but realm decides:
      - Either maintain “no teleport” identity, **or**
      - Enable full teleport for convenience (config flag).
  - Heroic modes for TBC dungeons available, tuned appropriately.

- **Classes/Races:**
  - All WotLK races/classes still available.
  - **Death Knights still disabled** for new characters (optional rule: DKs can only be created when Era III begins).
  - Draenei/Blood Elf racials & starting zones are naturally accessible (WotLK client baseline).

- **Professions & Systems:**
  - **Flying mounts allowed** in Outland (after appropriate training).
  - TBC reputations, heroic keys, and attunements can be kept mostly blizzlike, with mild QoL (reduced rep grind, etc.).

- **PvP:**
  - Arenas enabled (2v2, 3v3, 5v5) with TBC season flavor.
  - TBC BGs (Eye of the Storm) enabled if not already.
  - Outland world PvP objectives (Halaa, etc.) can be implemented as in original.

---

### 2.3 Era III – “Wrath of the North” (WotLK Era)

**Goal:** Full WotLK environment with level 80 progression and Northrend content.

- **Level Cap:** 80
- **Continents:**
  - Eastern Kingdoms, Kalimdor, Outland: still relevant.
  - Northrend: **enabled** (boats/zeps and portals active).

- **Dungeons Enabled:**
  - All Vanilla and TBC dungeons remain available.
  - WotLK dungeons: Nexus, UK, UP, AN, OK, DTK, CoT:Strat, Gundrak, HoS, HoL, Oculus, ToC5, FoS/PoS/HoR, etc.

- **Raids Enabled (Phased):**
  - Phase W1: Naxxramas (25/10), OS, EoE.
  - Phase W2: Ulduar (hard modes relevant).
  - Phase W3: ToC/TotGC + Onyxia update.
  - Phase W4: ICC (with wing unlock or full release) + RS.

- **Dungeon Finder:**
  - Full Random Dungeon Finder behavior **allowed by default**:
    - Auto‑grouping + teleport to instances.
  - If the realm wants a more “classic” feel, can keep “no teleport” identity and only use RDF as a reward system.

- **Classes/Races:**
  - **Death Knight creation enabled**, optionally gated:
    - Requires an existing level 70+ character on the account.

- **Professions & Systems:**
  - Northrend professions, Inscription fully active.
  - Dual spec, barbershop, and all WotLK QoL systems active.

- **PvP:**
  - Standard WotLK BGs.
  - Arenas with Wrath seasons.
  - Wintergrasp active and tuned.

---

## 3. Gating & Implementation Details

### 3.1 Era Selector (Realm‑Wide, Not Per‑Character)

Realm 2 uses **realm‑wide eras**, not per‑character progression:

- Server configuration variable: `CurrentEra` with allowed values: **1, 2, 3**.
- At startup and/or on era change:
  - Apply level cap.
  - Apply zone/instance gating.
  - Enable/disable systems (DK creation, flying, Northrend travel).

This can be implemented as:

- **C++ module** that:
  - Exposes `GetCurrentEra()` / `SetCurrentEra()` helper.
  - Hooks into:
    - Player login,
    - Zone change,
    - Instance enter,
    - Level up,
    - Travel spells, vehicles, transports.

### 3.2 Level Cap Enforcement

- On XP gain:
  - If player level >= `EraLevelCap[CurrentEra]` → clamp XP.
- On login:
  - If player level > current cap (because cap was lowered, unlikely) → clamp to cap and refund XP as currency or ignore.

Level caps:

- Era 1: 60
- Era 2: 70
- Era 3: 80

### 3.3 Zone & Travel Gating

- Hook `OnPlayerEnterWorld` and `OnUpdateZone`:
  - If a player enters Outland while `CurrentEra == 1`, teleport them back to a capital city with a flavor message.
  - If they try to use boats/zeps/portals forbidden in the current era, deny or redirect.
- For Northrend, same logic until `CurrentEra >= 3`.

### 3.4 Instance Gating

Create a custom table `custom_instance_era`:

```sql
CREATE TABLE IF NOT EXISTS custom_instance_era (
    map_id INT PRIMARY KEY,
    required_era TINYINT NOT NULL DEFAULT 1
);
```

- Populate with:
  - Vanilla instances → required_era = 1
  - TBC instances → required_era = 2
  - WotLK instances → required_era = 3

C++ hook on instance join:

- Check `CurrentEra >= required_era`:
  - If not, deny entry and send a message.

### 3.5 Item & Loot Gating (Minimal Version)

To avoid massive DB work, use a **lightweight gating strategy**:

- Add a custom table `custom_item_era`:

```sql
CREATE TABLE IF NOT EXISTS custom_item_era (
    entry INT PRIMARY KEY,
    required_era TINYINT NOT NULL DEFAULT 1
);
```

- Only explicitly tag **out‑of‑era items** that cause problems:
  - Example:
    - Outland/WotLK gear that might appear from generic loot tables in Era I.
- C++ loot hook:
  - When generating loot, if `CurrentEra < required_era`:
    - Replace item with gold/token/alternate item,
    - Or drop nothing.

This avoids having to tag **all items** and lets you fix only offenders.

---

## 4. Systems & QoL (All Eras)

These systems are **not era‑specific**, but their strength/availability may grow over time.

### 4.1 Rates & Grinds

- **XP:** x1–x2 (configurable; keep grounded).
- **Gold:** mildly increased to ease repairs/consumables.
- **Reputation:** x1.5–x2 to reduce time sink without trivializing it.
- **Professions:** x1.5–x2 to make them less painful on alts.

### 4.2 Alt Friendliness

- **Account bonuses:**
  - After your first character hits the level cap of an era, subsequent characters can:
    - Optionally buy a mild XP buff item from an in‑game vendor.
- **Account‑wide unlocks (where feasible):**
  - Mounts/pets/titles may be claimable by alts (within technical limits).

### 4.3 Grouping & Population Tools

- **Basic LFG/RDF** as per era rules (Section 2).
- **Bots/autobalance support** (optional but recommended):
  - Enable NPCBots/Playerbots and/or Autobalance to make low‑population dungeons/raids viable.
  - These should be configured more conservatively than Realm 1, focusing on “fill the gaps” rather than replacing players.

### 4.4 UI & Addon Policy

- Curated addon pack via the shared launcher:
  - Minimal UI QoL: better nameplates, map, bags, action bars.
  - No addons that automate gameplay or provide unfair PvP advantages.

---

## 5. Monetization & Ethics

Realm 2 follows a **no pay‑to‑win** policy:

- **Allowed:**
  - Cosmetics: mounts, pets, transmogs (lore‑friendly, not immersion‑breaking).
  - Mild convenience: character rename, faction change, server transfer, maybe XP potions or extra bank slots.
- **Not allowed:**
  - Direct sale of gear with stats.
  - Direct sale of gold or endgame power.
  - Anything that bypasses the expansion progression structure.

Supporter perks can be similar to Realm 1, but toned down to fit a more traditional WotLK vibe.

---

## 6. Shared Infrastructure with Realm 1

- **Accounts**: same account system, separate character pools per realm.
- **Launcher (Rust/Tauri):**
  - Two profiles/channels:
    - Realm 1 (Sandbox) patch set.
    - Realm 2 (Legacy Journey) patch set.
- **Atlas Web Portal:**
  - Realm drop‑down in the UI.
  - For Realm 2:
    - Armory (characters/gear),
    - Raid progression,
    - PvP ladders,
    - Scheduling/announcements.

---

## 7. Roadmap Sketch (High-Level)

This realm uses much more **existing content**, so the roadmap is lighter:

1. **Phase 0 – Technical Setup**
   - Spin up second AzerothCore world/auth DB pair.
   - Wire launcher & Atlas to recognize Realm 2.
   - Implement `CurrentEra` config and basic gating hooks.

2. **Era I Launch**
   - Level 60 cap.
   - Vanilla dungeons/raids enabled and tested.
   - Outland/Northrend access locked.
   - Item/loot sanity checks for obvious out‑of‑era items.

3. **Era II Transition**
   - Raise cap to 70.
   - Unlock Outland access and TBC dungeons/raids in stages.
   - Check flying training, attunements, and reputations.
   - Optional event to “celebrate” the opening of the Dark Portal.

4. **Era III Transition**
   - Raise cap to 80.
   - Unlock Northrend and WotLK dungeons/raids in phases.
   - Decide final RDF behavior.
   - Enable DK creation for accounts with 70+ characters.

5. **Post‑Era Support**
   - Seasonal events.
   - Cosmetic reward rotations.
   - Optional “Classic+” style dungeon/raid tweaks or new content, slow and careful.

---

## 8. Non‑Goals (To Avoid Scope Creep)

- No attempt to emulate **authentic 1.12 or 2.4.3 talents/spell behavior**.
- No massive alternate itemization pass for every era – only targeted fixes.
- No sandbox/full‑loot features (those remain exclusive to Realm 1).
- No seasonal wipes.

---

This design keeps Realm 2 relatively **simple to implement** (most content is already there), while covering all key gaps:

- Era rules ✅  
- Level caps ✅  
- Travel/zone gating ✅  
- Instance and loot gating ✅  
- DK/flying/RDF behavior per era ✅  
- Monetization & QoL stance ✅  
- Roadmap ✅  

Further docs (if needed) can drill into: per‑era tuning notes, LFD behavior options, and a small “Classic+” feature list once the base realm is stable.
