# Project Canvas: Mortal Warcraft Overhaul
### Version 26.9 — Hybrid Technical Design Document  
### File: 33-instance-and-battleground-tier-mapping.md  
### Section: Instance & Battleground Tier Mapping (PvE & Warfront Layout)

---

## 1. Purpose

This doc answers two questions:

1. **Which dungeons and raids get which Mortal tiers** (for stat scaling & loot).
2. **How battlegrounds fit into Mortal’s Warfront vision** (which are “true Warfronts” vs lighter PvP).

It sits on top of:

- `32-npc-and-encounter-rebalance.md`  
  (tier system, scaling tables, ICC strategy)
- Gear tier specs (`26`, `27`)  
  (M-T1 .. M-T5, P1 .. P6)
- War/PvP systems in the main overhaul doc  
  (Warfronts, full loot in certain instances, guild shipments, etc.)

This file is **mapping/coordination**, not code.

---

## Related Specs

For full context on instance and battleground systems, see:

- **`32-npc-and-encounter-rebalance.md`** — NPC tier system and encounter rebalancing referenced throughout
- **`19-itemization.md`** — Itemization tiers (M-T1 through M-T5) used in instance mapping
- **`06-pve.md`** — PvE content system that uses these instance tiers
- **`92-mortal-warfronts-siege-flow.md`** — Warfront system that uses battleground mapping
- **`34-mortal-arena-and-rating.md`** — Arena system that uses battleground infrastructure
- **`11-pvp-systems.md`** — PvP systems that operate in battlegrounds

---

## 2. Mortal PvE Tier Bands (Quick Recap)

We assume the following **Mortal PvE tiers** for instanced content:

- **M-T1** – Early dungeons, intro group content.
- **M-T2** – Mid-game dungeons, early raids.
- **M-T3** – Heroic dungeons, TBC 25-man raids, entry WotLK raids.
- **M-T4** – Mid/late WotLK raids.
- **M-T5** – Mortal endgame pinnacle content (ICC Heroic, hardest modes).

World bosses use their own **WORLD_x** tier codes (see `32`), but we also hint which M-T* band their loot belongs to.

---

## 3. Dungeon Tier Mapping (High Level)

### 3.1 Early / Classic Dungeons – M-T1

These are **first-group experiences** after Shipwreck Cove + early zones. They should be tuned to be lethal but fair for new Mortal builds.

**M-T1 Target:**

- Trash: `TRASH_T1`
- Bosses: `BOSS_T1`
- Loot: M-T1 gear, early blueprints, basic crafting reagents.

**Instances (examples; can be extended):**

- Ragefire Chasm
- Wailing Caverns
- The Deadmines
- Shadowfang Keep
- Blackfathom Deeps
- Stormwind Stockade
- Razorfen Kraul
- Scarlet Monastery (all wings)
- Razorfen Downs
- Uldaman

For these, you’ll typically:

- Map trash → `TRASH_T1`
- Map bosses → `BOSS_T1`
- Use loot tier hint = `M-T1` in `mortal_creature_tiers`.

---

### 3.2 Mid-Game Classic / TBC Dungeons – M-T2

These represent **progressed characters** with M-T1 gear and expanded skills.

**M-T2 Target:**

- Trash: `TRASH_T2`
- Bosses: `BOSS_T2`
- Loot: M-T2 gear, more advanced blueprints, higher-tier mats.

**Instances (core examples):**

Classic mid–late:

- Zul’Farrak
- Maraudon
- Sunken Temple
- Blackrock Depths
- Lower & Upper Blackrock Spire
- Scholomance
- Stratholme

TBC 5-mans (normal):

- Hellfire Ramparts / Blood Furnace / Shattered Halls
- Slave Pens / Underbog / Steamvault
- Mana-Tombs / Auchenai Crypts / Sethekk Halls / Shadow Labyrinth
- Old Hillsbrad / Black Morass
- Mechanar / Botanica / Arcatraz
- Magister’s Terrace (Normal)

Mapping approach:

- Trash → `TRASH_T2`
- Bosses → `BOSS_T2`
- Loot hint: `M-T2`.

---

### 3.3 Heroic Dungeons / WotLK 5-mans – M-T3

These are the **heart of Mortal’s mid–late progression loop**.

**M-T3 Target:**

- Trash: `TRASH_T3`
- Bosses: `BOSS_T3`
- Loot: M-T3 gear, rare blueprints, key crafting inputs.

**Instances:**

TBC Heroics:

- H-Ramps, H-BF, H-SH
- H-Slave Pens, H-Underbog, H-Steamvault
- H-Mana-Tombs, H-Auchenai, H-Sethekk, H-Shadow Labyrinth
- H-Old Hillsbrad, H-Black Morass
- H-Mechanar, H-Botanica, H-Arcatraz
- H-Magister’s Terrace

WotLK 5-mans (Normal/Heroic baseline):

- Utgarde Keep / Pinnacle
- Nexus / Oculus
- Azjol-Nerub / Ahn’Kahet
- Drak’Tharon Keep
- Violet Hold
- Gundrak
- Halls of Stone / Lightning

ICC 5-mans (FoS / PoS / HoR) are treated in 3.4/3.5 as “bridge into M-T4”.

---

### 3.4 ICC 5-mans – Bridge to M-T4

These three should sit slightly above normal heroic dungeons because of their narrative & difficulty:

- **The Forge of Souls (FoS)**
- **The Pit of Saron (PoS)**
- **The Halls of Reflection (HoR)**

**Suggestion:**

- Trash: `TRASH_T3` but tuned near upper bounds.
- Bosses: `BOSS_T3_PLUS` (define code if needed, e.g. `hp_scale` and `damage_scale` slightly higher).
- Loot: upper M-T3 / early M-T4 gear.

HoR in particular can be given:

- Slightly more punishing scaling.
- Extra Mortal hooks (durability hits on wipe, cursed fragments from the final boss).

---

## 4. Raid Tier Mapping

### 4.1 Classic & TBC Raids – M-T2 / M-T3

These raids become **Mortal mid-game / early endgame**:

**M-T2 / M-T3 target:**

- Early raids M-T2.5-ish.
- Later TBC raids M-T3.

**Raids:**

Classic:

- Zul’Gurub
- Ruins of Ahn’Qiraj
- Molten Core
- Blackwing Lair
- Temple of Ahn’Qiraj

TBC:

- Karazhan
- Gruul’s Lair
- Magtheridon’s Lair
- Serpentshrine Cavern
- The Eye (Tempest Keep)
- Hyjal Summit
- Black Temple
- Sunwell Plateau

Mapping idea:

- Early classic raids (ZG, AQ20, MC) → `BOSS_T2` (loot ~M-T2).
- Later classic/TBC 25-man → `BOSS_T3` (loot ~M-T3).
- If you want Sunwell as a “bridge” mini-tier before WotLK, give it a special code like `RAID_SWP` with stronger multipliers and loot hint ~early M-T4.

---

### 4.2 Early WotLK Raids – Start WotLK Arc (M-T3)

These are the **entry WotLK raids** and should land around late M-T3:

- Naxxramas (10/25)
- The Eye of Eternity (Malygos)
- Obsidian Sanctum
- Vault of Archavon (if active for your design)

Mapping suggestion:

- Naxx → `RAID_NAXX_N` (normal) & `RAID_NAXX_H` (if you treat 25-man as “heroic”).
- EoE, OS, VoA → similar scheme (`RAID_EOE`, `RAID_OS`, etc.)

Loot:

- Primary loot tier ~M-T3, with a few teaser pieces valid into early M-T4.

---

### 4.3 Ulduar / ToC – M-T4 Core Raids

Ulduar and Trial of the Crusader are your **M-T4 backbone raids**:

- **Ulduar**
  - Normal: `RAID_ULD_N` → M-T4.
  - Hard modes: `RAID_ULD_H` → upper M-T4 / early M-T5.

- **Trial of the Crusader**
  - ToC normal: `RAID_TOC_N` → M-T4.
  - ToGC (heroic): `RAID_TOC_H` → M-T4+ bridging into M-T5.

Loot:

- Normal modes drop M-T4.
- Hard/heroics drop high M-T4 / low M-T5 items.

---

### 4.4 ICC / LK – M-T4 / M-T5 (as in Spec 32)

From `32-npc-and-encounter-rebalance.md`:

- **ICC Normal**
  - `RAID_ICC_N` → tuned for M-T4.
  - Story / widely accessible endgame.

- **ICC Heroic**
  - `RAID_ICC_H` → tuned for M-T5.
  - Mortal pinnacle raid, possible extraction/cursed loot hooks.

Loot:

- ICC-N: M-T4.
- ICC-H: definitive M-T5.

---

## 5. Battleground & Warfront Mapping

We’ll split PvP instances into two categories:

1. **Classic Battlegrounds** – lighter, progression-friendly PvP.
2. **Warfronts** – high-risk, Mortal-flavored instanced PvP with full loot and stronghold shipments.

### 5.1 Classic Battlegrounds (Lower-Risk PvP)

Recommended to **maintain lighter rules** so players can always “just PvP” without full-loot stress.

Bg list:

- Warsong Gulch (WSG)
- Arathi Basin (AB)
- Eye of the Storm (EotS)
- Alterac Valley (AV, see below)
- Possibly Strand of the Ancients (SotA) for siege-flavor only.

Core rules:

- **No full loot** inside classic BGs.
- Normal Mortal death penalties (durability, bindings) → *softened* inside these:
  - Or use reduced durability loss.
- Rewards:
  - Honor → “Military Credits” (as per your Honor Overhaul).
  - PvP tokens / fragments for P1–P3 PvP gear.
- Access:
  - Portal-based or queue-based depending on how far you push the “no queues” philosophy.  
    (Spec already suggests portals for Warfront-style; you can be more forgiving here.)

You can later choose to “upgrade” one of these to a Warfront if testing shows the playerbase wants it.

---

### 5.2 Warfronts (High-Risk Battlegrounds)

These are explicitly referenced in your main design:

- **Arathi Basin Warfront**
- **Alterac Valley Warfront**
- Possibly:
  - Isle of Conquest.
  - Wintergrasp-like siege instance.

Core Warfront rules:

- **Access:**
  - Physical entry portals in the world (no cross-realm-style queue).
- **Risk:**
  - Full loot **enabled inside the instance**.
  - Death → corpse chest mechanics apply (Mortal core rules).
- **Reward:**
  - Victory yields **Guild Resource Shipments**:
    - Massive Wood/Iron/Stone/Essence injections into **Stronghold chests**.
  - Personal rewards: high-tier mats, PvP gear fragments, Warfront-only blueprints.
- **Tier mapping:**
  - Warfront NPCs follow their own tier codes, e.g.:
    - `WARFRONT_AB_T3` → HP/dmg scaling roughly ~M-T3 for NPC guards/siege.
    - `WARFRONT_AV_T4` → higher tier, near M-T4 difficulty.

You can implement Warfronts by:

- Using existing BG maps as **new instance entries** with their own:
  - Warfront scripts.
  - NPC templates.
  - Mortal rules (full loot, shipments, timers).

Classic BG versions can co-exist as lighter PvP options.

---

### 5.3 Arena / Fighting Pits

From your main spec:

- Gurubashi Arena / Ring of Trials → **Wager pits**:
  - Gold betting, 1v1 / small-team fights.
  - Full loot configurable:
    - Either keep them non-full-loot but wager-based,
    - Or treat them as high-risk side content with full loot but clear warning.

These are **not** in the Warfront tier system, but they are PvP instances that need consistent rules:

- Clear UI messaging:
  - “You are entering a Wager Pit: you may lose X and gain Y.”
- Rewards in line with risk, but not overshadowing Warfront/raid rewards.

---

## 6. How to Use This Doc

- For **PvE**:
  - Use this mapping when populating:
    - `mortal_creature_tier_map` (by creature_entry per instance).
    - `mortal_creature_tiers` (hp/dmg scales + loot hints).
  - Use `loot_tier_hint` to align each instance’s drops with M-T1..M-T5 gear specs.

- For **PvP**:
  - Decide for each BG:
    - Classic low-risk vs Warfront high-risk.
  - Create separate:
    - Tier codes for Warfront NPCs.
    - Rule configs (full loot on/off, shipment rewards, etc.).

This keeps **all instanced combat content** (PvE and PvP) aligned under a single Mortal progression vision while still letting OG players recognize their favorite places.

---

## 7. Status

This doc does **not** list every single dungeon/raid in the game, but:

- It gives **canonical tier bands** for:
  - Early/mid/heroic dungeons.
  - Classic/TBC/WotLK raids.
  - ICC & LK (tying into Spec 32).
- It defines **how battlegrounds split** into:
  - Classic BGs (lighter PvP),
  - Warfronts (Mortal high-risk PvP with stronghold integration).

You can refine & expand the per-instance mapping over time, but this is now the **baseline map** for Cursor and for your content team to follow.
