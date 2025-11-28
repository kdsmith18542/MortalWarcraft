# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 11-pvp-systems.md  
### Section: PvP Systems, Notoriety, Criminal Logic, Bounties, Anti‑Zerg, Hellgates & Factionless Warfare

---

# 1. Overview

Mortal Warcraft uses a **factionless**, **risk‑based**, **zone‑driven** PvP system inspired by:

- Mortal Online 1 & 2  
- EVE Online security zones  
- Old‑school Ultima Online notoriety  
- Albion Online outlaw mechanics  
- WoW’s polished combat movement  

The goal:  
**PvP that is meaningful, fair, and skill‑rewarding — without forcing hardcore full‑loot on everyone.**

This document defines every PvP component.

---

## Related Specs

For full context on PvP systems, see:

- **`02-combat.md`** — Core combat mechanics, crime system, and PvP flag states referenced throughout
- **`03-risk-zones.md`** — Zone-based PvP rules, loot rules, and risk tiers that define PvP zones
- **`56-negative-titles-and-notoriety-labels.md`** — Notoriety system that tracks PvP behavior and triggers Outlaw state
- **`84-mortal-core-stats-and-combat-model.md`** — Combat stat formulas used in PvP calculations
- **`34-mortal-arena-and-rating.md`** — Arena system and rating mechanics for structured PvP
- **`35-mortal-pvp-vendors-and-rewards.md`** — PvP vendors and reward systems
- **`92-mortal-warfronts-siege-flow.md`** — Warfront and siege systems for large-scale PvP
- **`97-mortal-guild-war-and-alliances.md`** — Guild war mechanics and alliance systems

---

# 2. PvP Zone Framework

There are three risk tiers:

## 2.1 Green Zones — Safe
- No PvP  
- Starting zones + capital roads  
- Tier 1 resources only  
- Guards invincible  
- Intended for casual players and tutorial

## 2.2 Yellow Zones — Criminal Risk
- PvP enabled **only by initiating attacker**  
- Attacker gains **Criminal Flag (15m)**  
- **Loot rules (matches 03-risk-zones.md & 02-combat.md):**
  - Innocent death → **keep** Weapon / Chest / Mount reins / 1 trinket; **drop** all inventory + consumables + non-protected equipped slots.
  - Criminal death → **drop everything** (full loot treatment).
- Tier 2–3 resources  
- Anti‑gank protection active

## 2.3 Red Zones — Full Loot
- PvP always enabled  
- Everyone drops all gear  
- No global chat (“radio silence”)  
- Tier 4–5 resources  
- Highest rewards, highest risk  

---

# 3. Notoriety System (Criminal Status)

Players build **Notoriety** when committing crimes in Yellow/Green border regions.

## 3.1 Gaining Notoriety
Crimes include:
- Attacking innocents in Yellow  
- Killing innocents  
- Stealing from players  
- Caravan robbery  
- Killing guards  
- Helping criminals (healing/cleansing)

## 3.2 Notoriety Levels
| Tier | Name | Color | Effects |
|------|------|--------|--------|
| 0 | Innocent | White | Normal gameplay |
| 1 | Suspect | Yellow | Guards watch you |
| 2 | Criminal | Orange | Drop all on death |
| 3 | Outlaw | Red | Kill‑on‑sight guards, visible to players |
| 4 | Infamous | Skull Icon | Visible on world map |

## 3.3 Decay
Notoriety decays when:
- You remain unflagged  
- You perform courier contracts  
- You complete civic tasks  

Lua:
- `notoriety_handler.lua`

---

# 4. Bounty Board System

Players may place **bounties** on criminals.

## 4.1 How it works
- Visit a Bounty Board (taverns & cities)  
- Select target criminal  
- Post gold bounty  
- Reward added to criminal’s “Bounty Pool”  

## 4.2 Claiming a bounty
To claim a bounty:
- Kill the target  
- Loot the **Bounty Token**  
- Turn it in at the Bounty Board  

## 4.3 Anti‑Abuse Rules
- Cannot set bounties on guild members  
- Criminals cannot claim their own bounty  
- Token binds to killer until turn‑in  

Lua:
- `MortalBountyBoard.cpp/h` (C++ implementation)

---

# 5. Anti‑Zerg Mechanics

Large groups are dangerous but must be controlled to keep PvP fair.

## 5.1 Zerg Detection
If **5+ players** kill a solo/duo:
- All attackers get **Double Notoriety**  
- Victim gets **Anti‑Zerg Protection buff (15m)**  
- Attackers are marked on map for 5 minutes  

## 5.2 Anti‑Zerg Buff
When active:
- +15% movement speed  
- +20% mitigation vs players  
- +25% gathering yield  

Prevents repeated griefing.

---

# 6. PvP Combat Enhancements

## 6.1 Brace Mechanic
Universal spell:
- Off‑GCD  
- 0.75s duration  
- 50% damage reduction  
- 5s cooldown  

Adds skill‑based reaction gameplay.

## 6.2 Hitbox Rewrites
Rebalanced hitboxes for:
- Projectiles  
- Cone abilities  
- Cleaves  

## 6.3 Stagger System
Certain hits apply:
- 0.5s movement slow  
- Mini stun removed (MO2 lesson learned)

---

# 7. Hellgates (Small‑Scale Instanced PvP)

Inspired by Albion Hellgates.

## 7.1 How it works
- Two groups enter from portals in the open world  
- Teleported into same instance  
- PvPvE hybrid:
  - Mobs in center  
  - Boss drops rare mats  
  - Winner takes entire chest  

## 7.2 Combat Rules
- Full loot  
- No respawns  
- Instances close after one fight  

Lua:
- `MortalHellgates.cpp/h` (C++ implementation)

---

# 8. Extraction PvP

Raids drop **Cursed Artifacts** that must be extracted.

## 8.1 Artifact Carrier Rules
- Slowed movement  
- Visible on map  
- Can be ganked  
- If killed → artifact drops in chest  
- Must reach Purification Altar  

Integrates PvE + PvP tension.

---

# 9. Outlaw Ecosystem

Outlaws get unique gameplay loops.

## 9.1 Outlaw Camps
Located in:
- Badlands  
- EPL  
- Blackrock Mountain  

## 9.2 Outlaw Features
- Black market vendor  
- Outlaw quests  
- Criminal crafting  
- Fencing stolen goods  
- “Safe” dueling pits  

## 9.3 Outlaw Progression
Outlaws gain:
- Outlaw titles  
- Outlaw cosmetics  
- Passive bonuses in Red zones  

---

# 10. Group PvP Rules

## 10.1 Fog of War
In Red zones:
- Party dots hidden on minimap  
- No raid icons unless manually set  

## 10.2 Friendly Fire
Enabled in Red zones:
- Encourages coordination  
- Prevents mindless AoE zergs  

## 10.3 Healing Logic
Healing a criminal:
- Flags healer as criminal  
- Promotes accountability  

---

# 11. Loot Rules

## 11.1 Yellow Zones
- Criminal attacking innocent → criminal drops all  
- Innocent defending → no drop  

## 11.2 Red Zones
- Full loot  
- All items go into corpse chest  
- Corpse chest can be trapped/hidden  
- Items with an active **Blessing** (see `37-economy-system-extensions.md`) do not drop but consume a blessing charge and take extra durability loss  

Lua:
- `corpse_chest.lua`

---

# 12. PvP Rewards & Seasons

## 12.1 Seasonal PvP Track
Players earn:
- Titles  
- Cosmetics  
- Profile frames  
- Rare mats  
- Seasonal mounts  

## 12.2 Rating System
Rating based on:
- K/D  
- Time survived in Red zones  
- Hellgate wins  
- Bounty claims  

Stored in:
- `pvp_season_scores.sql`

---

# 13. Integration With Other Systems

PvP interacts directly with:
- Crafting (gear, consumables)
- Caravans (escort & robbery)
- Guild territory  
- Social system (wagers, duels)
- PvE extraction  
- Bounty/justice system  
- Seasonal resets  

PvP is a **core pillar**, not optional.

---

# 14. Implementation Summary

## 14.1 Lua Files
- `notoriety_handler.lua`
- `MortalBountyBoard.cpp/h` (C++ implementation)
- `MortalHellgates.cpp/h` (C++ implementation)
- `corpse_chest.lua`
- `criminal_logic.lua`
- `MortalPvPSeason.cpp/h` (C++ implementation)

## 14.2 SQL Files
- `pvp_kill_log.sql`
- `pvp_season_scores.sql`
- `notoriety_table.sql`
- `bounty_table.sql`

## 14.3 C++ Files
- `PvPHooks.cpp`
- `CriminalFlags.cpp`
- `BraceMechanic.cpp`
- `CombatRewrites.cpp`

---

# 15. Status
PvP is **fully modular**, allowing future expansion into arenas, duels, faction wars, and battleground remixes.

---

# 10. Battleground-to-Warfront Conversion

All WoW 3.3.5a battlegrounds are converted to either **Classic Battlegrounds** (lower-risk PvP) or **Warfronts** (full-loot, territory-impacting battles). This section provides the complete mapping.

## 10.1 Classic Battlegrounds (Lower-Risk PvP)

Classic Battlegrounds maintain the original WoW battleground experience with Mortal's risk-based loot rules. These are **opt-in** PvP experiences with reduced risk compared to open-world PvP.

### Warsong Gulch
- **Original:** 10v10 Capture the Flag
- **Mortal Type:** Classic Battleground
- **Loot Rules:** Yellow Zone rules (partial loot)
- **Risk Tier:** Mid-Risk (Yellow)
- **Rewards:** Honor-equivalent currency, M-T1/M-T2 gear
- **Notes:** Fast-paced CTF, good for casual PvP practice

### Eye of the Storm
- **Original:** 15v15 Capture and Hold
- **Mortal Type:** Classic Battleground
- **Loot Rules:** Yellow Zone rules (partial loot)
- **Risk Tier:** Mid-Risk (Yellow)
- **Rewards:** Honor-equivalent currency, M-T2 gear
- **Notes:** Multi-objective control map

### Strand of the Ancients
- **Original:** 15v15 Siege Assault
- **Mortal Type:** Classic Battleground
- **Loot Rules:** Yellow Zone rules (partial loot)
- **Risk Tier:** Mid-Risk (Yellow)
- **Rewards:** Honor-equivalent currency, M-T3 gear
- **Notes:** Attack/defend siege mechanics

## 10.2 Warfronts (Full-Loot, Territory-Impact)

Warfronts are large-scale, full-loot battlegrounds that impact realm territory and economy. These use Red Zone loot rules and provide significant rewards.

### Alterac Valley
- **Original:** 40v40 Large-Scale Battle
- **Mortal Type:** Warfront
- **Loot Rules:** Red Zone rules (full loot)
- **Risk Tier:** High-Risk (Red)
- **Rewards:** Military Credits, M-T3/M-T4 gear, Stronghold resources
- **Territory Impact:** Winning side's Strongholds receive resource shipments
- **Notes:** Large-scale territory control, siege mechanics

### Isle of Conquest
- **Original:** 40v40 Siege Warfare
- **Mortal Type:** Warfront
- **Loot Rules:** Red Zone rules (full loot)
- **Risk Tier:** High-Risk (Red)
- **Rewards:** Military Credits, M-T3/M-T4 gear, Stronghold resources
- **Territory Impact:** Winning side's Strongholds receive resource shipments
- **Notes:** Siege warfare with vehicles and objectives

### Arathi Basin (Warfront Conversion)
- **Original:** 15v15 Resource Control
- **Mortal Type:** Warfront (converted from Classic BG)
- **Loot Rules:** Red Zone rules (full loot)
- **Risk Tier:** High-Risk (Red)
- **Rewards:** Military Credits, M-T2/M-T3 gear, Stronghold resources
- **Territory Impact:** Winning side's Strongholds receive resource shipments
- **Notes:** Converted to warfront for territory impact

## 10.3 World PvP Zones

### Wintergrasp
- **Original:** World PvP Zone
- **Mortal Type:** World PvP Siege Zone
- **Loot Rules:** Red Zone rules (full loot)
- **Risk Tier:** High-Risk (Red)
- **Rewards:** Military Credits, M-T4 gear, Stronghold resources
- **Territory Impact:** Direct Stronghold siege mechanics
- **Notes:** See `95-wintergrasp-to-mortal-siege-adaptation.md` for full details

## 10.4 Conversion Summary

| Battleground | Original Type | Mortal Type | Loot Rules | Risk Tier | Territory Impact |
|--------------|--------------|-------------|------------|-----------|------------------|
| Warsong Gulch | 10v10 | Classic BG | Yellow (partial) | Mid-Risk | None |
| Eye of the Storm | 15v15 | Classic BG | Yellow (partial) | Mid-Risk | None |
| Strand of the Ancients | 15v15 | Classic BG | Yellow (partial) | Mid-Risk | None |
| Arathi Basin | 15v15 | **Warfront** | Red (full) | High-Risk | **Yes** |
| Alterac Valley | 40v40 | Warfront | Red (full) | High-Risk | **Yes** |
| Isle of Conquest | 40v40 | Warfront | Red (full) | High-Risk | **Yes** |
| Wintergrasp | World PvP | World PvP | Red (full) | High-Risk | **Yes** |

## 10.5 Implementation Notes

**Classic Battlegrounds:**
- Maintain original gameplay mechanics
- Use Yellow Zone loot rules (partial loot on death)
- No territory impact
- Good for casual PvP practice

**Warfronts:**
- Full-loot PvP (Red Zone rules)
- Territory and economic impact
- Scheduled battle windows (see `92-mortal-warfronts-siege-flow.md`)
- Entry via world portals (no remote queuing)
- Stronghold resource rewards for winning side
