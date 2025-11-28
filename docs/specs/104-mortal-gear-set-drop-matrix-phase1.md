# Project Canvas: Mortal Warcraft Overhaul  
### File: 104-mortal-gear-set-drop-matrix-phase1.md  
### Topic: Phase 1 Gear Set Drop Mapping – Archetypes vs Content Lanes

> This file gives a **high-level mapping** of where each core T1/T2 archetype set  
> (Bruiser, Vanguard, Assassin, Ranger, Mage, Battlemage, Healer, Occultist)  
> comes from in Phase 1 of Mortal Warcraft.

It is a **design guide**, not the final per-item SQL.  
Detailed itemization lives in the corresponding gear spec files.

---

## Related Specs

For full context on gear set drop mapping, see:

- **`77-mortal-itemization-t1-t2-starter-sets.md`** — Starter sets that this matrix maps
- **`78-mortal-itemization-healer-ranger-mage.md`** — Healer, ranger, and mage sets in this matrix
- **`79-drop-mapping-t1-t2-gear-and-runes.md`** — Detailed drop mapping for T1/T2 gear
- **`103-mortal-gear-vanguard-bulwark-set-t1-t2.md`** — Vanguard set that appears in this matrix
- **`75-mortal-gear-and-runes-spec.md`** — Core gear and rune system that defines these sets
- **`06-pve.md`** — PvE content (delves, world bosses) that provides gear drops
- **`92-mortal-warfronts-siege-flow.md`** — Warfronts that provide gear rewards

---

## 1. Content Lanes (Phase 1)

We’ll use the following lanes as our main sources:

1. **Green & Yellow Zone Contracts**
   - Early Task Boards, simple Contracts.
2. **Public Delves (Normal)**
   - Open-world or lightly instanced dungeons.
3. **Hellgates (T1/T2)**
   - Small-group PvPvE instances with boss in middle.
4. **Heroic Delves / Advanced Public Dungeons**
   - Harder versions, tuned for coordinated groups.
5. **World Bosses & Invasions**
   - Outdoor bosses (Azuregos, Kazzak, Dragons, invasion captains).
6. **Warfronts / Battleground-Style Warzones**
   - AB/WSG-style physical-entry Warfronts.
7. **Stronghold Sieges**
   - Wintergrasp-based and future siege maps.
8. **Campaign / Shrine Milestones**
   - Story arcs tied to your custom campaign.
9. **Special Events / Black Market**
   - Midnight Horde, rotating Darkmoon/Black Market, Cartel-flavored stuff.

Each set gets a **primary lane** and 1–2 **secondary lanes** for variety.

---

## 2. Archetype Overview

Archetypes (S1 core):

1. **Bruiser** – melee brawler.
2. **Vanguard** – tank / shield wall.
3. **Assassin** – stealth burst killer.
4. **Ranger** – ranged physical.
5. **Mage** – direct-damage caster.
6. **Battlemage** – melee/caster hybrid.
7. **Healer** – cleric/resto-style support.
8. **Occultist** – DoT / curses / debuffs.

---

## 3. T1/T2 Drop Matrix

### Legend

- **P** = Primary lane (most of the set comes from here),
- **S** = Secondary lane (some pieces / alternatives),
- **C** = Campaign reward / guaranteed acquisition path.

---

### 3.1 Bruiser – “Street Brawler” / “Crimson Enforcer” (example names)

- **Role:** frontline DPS / off-tank brawler.

#### Bruiser T1 (Street Brawler)

- **P:** Public Delves (Normal) in early “bandit” and “arena” style zones.
- **S:** Green/Yellow Contract chains (Thugs, pit fights).
- **C:** One guaranteed starter weapon via early Task Board.

#### Bruiser T2 (Crimson Enforcer)

- **P:** Heroic Delves (bandit fortresses, elite brawler arenas).
- **S:** Warfront rewards (AB-style stronghold disputes).
- **C:** Optional Campaign branch where you become a sanctioned enforcer for a city/frontier.

---

### 3.2 Vanguard – “Shrine Bulwark” / “Iron Covenant”

(see `103-mortal-gear-vanguard-bulwark-set-t1-t2.md`)

#### Vanguard T1 – Shrine Bulwark

- **P:** Public Delves (Normal) with shrine/fort themes:
  - E.g. reworked Deadmines/WC-style delves that include shrine defence objectives.
- **S:** Shrine defence Contracts on Task Boards.
- **C:** Campaign: first Shrine arc grants 1–2 guaranteed Bulwark pieces.

#### Vanguard T2 – Iron Covenant

- **P:** Stronghold Siege defender rewards:
  - Participating and performing as tank/frontliner.
- **S:** Heroic Delves & world boss tank loot tables.
- **C:** Campaign milestone where you swear an “Iron Covenant” to defend a key fortress.

---

### 3.3 Assassin – “Veilrunner” / “Night Reaper”

#### Assassin T1 – Veilrunner

- **P:** Hellgates (T1) – smaller instances ideal for gankers and small skirmishers.
- **S:** Bounty Hunter Contracts (Task Boards focusing on outlaw hunting).
- **C:** A short campaign arc that introduces you to the bounty system.

#### Assassin T2 – Night Reaper

- **P:** Hellgates (T2) in higher-risk Red Zone entry points.
- **S:** High-value bounty targets (named outlaws, world PvP events).
- **C:** Limited Black Market / Cartel event rotations with cosmetic variants.

---

### 3.4 Ranger – “Pathfinder” / “Stormmarksman”

#### Ranger T1 – Pathfinder

- **P:** Public Delves in wilderness zones (reworked WC/ZF-style areas).
- **S:** Scout & exploration Contracts (Atlas-flavored).
- **C:** Campaign questline involving escorting caravans / guarding trade routes.

#### Ranger T2 – Stormmarksman

- **P:** World Bosses & Invasions (dragons, roaming commanders).
- **S:** Warfronts where ranged pressure is key.
- **C:** Special Atlas Contracts for killing targets at range / from vantage points.

---

### 3.5 Mage – “Spellweaver” / “Starfire Arcanist”

#### Mage T1 – Spellweaver

- **P:** Public Delves with arcane themes (old mage tower zones, libraries).
- **S:** Contracts for magical anomalies / Rifts.
- **C:** Campaign arc where you aid an Atlas/Civic mage enclave.

#### Mage T2 – Starfire Arcanist

- **P:** Heroic Delves & Rifts with high magical density.
- **S:** World bosses that are thematically magic-heavy.
- **C:** Raid-equivalent encounters in early Mortal raid content (e.g. re-flavored Naxx/OS).

---

### 3.6 Battlemage – “Spellforged Raider” / “Arcanum Warmaster”

#### Battlemage T1 – Spellforged Raider

- **P:** Mixed-content Public Delves and Hellgates:
  - Places where both melee and magic are rewarded.
- **S:** Contracts to protect or assault mobile convoys (good hybrid fantasy).
- **C:** Campaign branch where you side with a force that blends steel & spell.

#### Battlemage T2 – Arcanum Warmaster

- **P:** Warfronts & Stronghold sieges:
  - Midline battlemages shining in lane/breach fights.
- **S:** World bosses with mixed damage types.
- **C:** Atlas/Civic hybrid Contracts for leading combat research.

---

### 3.7 Healer – “Sanctum Warden” / “Light of the Covenant”

#### Healer T1 – Sanctum Warden

- **P:** Public Delves with group-healing challenges.
- **S:** Healing-focused Contracts (assist civilians, triage wounded after events).
- **C:** Campaign arc involving defending a sanctuary or infirmary.

#### Healer T2 – Light of the Covenant

- **P:** Stronghold sieges, Warfronts, and high-tier delves where healing throughput matters.
- **S:** World bosses & Midnight Horde events.
- **C:** Campaign milestone where you bind to a greater power / shrine as a guardian.

---

### 3.8 Occultist – “Gravebinder” / “Herald of the Hollow”

#### Occultist T1 – Gravebinder

- **P:** Public Delves and mini-raid encounters involving undead/corruption.
- **S:** Contracts to cleanse or contain curses (Atlas & Civic overlap).
- **C:** Campaign threads that deal with the Midnight Horde and cursed artifacts.

#### Occultist T2 – Herald of the Hollow

- **P:** Midnight Horde world events (The Risen),
- **S:** High-tier Rifts / Hellgates infused with corruption.
- **C:** Black Market / Cartel-cooperative Contracts where you weaponize curses.

---

## 4. Acquisition Philosophy

1. **No set is purely raid-only or siege-only.**
   - Each archetype has at least:
     - One **instanced PvE lane** (Delves/Hellgates/Raids),
     - One **open-world/event lane** (World Boss / Invasion / Task Boards),
     - One **Campaign/guaranteed** path to avoid total RNG screw.

2. **PvP & PvE both feed progression**, but:
   - Some sets lean more PvP (Assassin, Bruiser, Ranger),
   - Others more PvE/support (Healer, Occultist),
   - Hybrids (Vanguard, Battlemage, Mage) live in between.

3. **Content identity is respected**:
   - Frontier Strongholds → Vanguard, Healer, Bruiser.
   - Cartel/Black Market → Assassin, Occultist, some Bruiser/Ranger cosmetics.
   - Atlas/Exploration → Ranger, Mage, Battlemage variants.

---

## 5. Next Steps

- For each archetype, create:
  - A dedicated `10x-mortal-gear-<archetype>-t1-t2.md` itemization file (like the Vanguard one),
  - Per-dungeon / per-event drop tables,
  - Tuning passes so that:
    - T1 sets are reachable by regular players,
    - T2 sets feel aspirational but not mythic-locked.

- Update:
  - Campaign specs to reference these sets by name,
  - Task Board Contract templates to include them as major/final rewards.

This matrix gives Cursor and future designers a clear **“who drops what where”** backbone for Phase 1 itemization.
