# Project Canvas: Mortal Warcraft Overhaul  
### Version 26.1 — Hybrid Technical Design Document  
### File: 00-overview.md  
### Target Core: AzerothCore 3.3.5a  
### Document Type: High-Level Overview  

---

# 1. Vision Statement

**Mortal Warcraft** is a complete overhaul of AzerothCore 3.3.5a, transforming the WotLK-era world into a classless, skill-based sandbox MMO inspired by:

- **Mortal Online 1 & 2** — Full-loot PvP, territorial control, deep crafting, player-driven risk  
- **World of Warcraft** — World polish, combat smoothness, iconic zones, accessibility  
- **EVE Online** — Regional markets, logistics, sovereignty, risk-vs-reward economics  
- **Runescape** — Skill-based character progression, open training, economic loop longevity  

The goal is not to “mod WoW,” but to use AzerothCore as a **stable foundation** for a **new MMO** with fresh systems layered on top.

---

# 2. High-Level Game Identity

## 2.1 Core Pillars
1. **Classless, Skill-Driven Character Progression**  
   - No classes.  
   - No XP grind.  
   - Over 1,200 skill points determine a derived combat level (1–25).

2. **Risk-Based World With Meaningful Consequences**  
   - Green (Safe), Yellow (Mid-Risk), Red (Full Loot).  
   - Crime, Outlaw state, Bounties, Reputation consequences.  
   - Player-driven justice, not faction-driven.

3. **Player-Driven Economy**  
   - Regional banking (Stormwind ≠ Ironforge ≠ Orgrimmar).  
   - No mailing items.  
   - Trade runs, hauling, piracy, caravans.  
   - Blueprint Originals/Copies, deep crafting, meaningful durability.

4. **Emergent Gameplay Through World Systems**  
   - Territory sovereignty.  
   - Public dungeons.  
   - Extraction raids.  
   - World events (Invasions, Midnight Horde).  
   - Stronghold building and seasonal warfare.

5. **Modern Retention & Social Systems**  
   - Solo-friendly delves.  
   - Social taverns & mini-games.  
   - Guild halls & housing.  
   - Practice PvP modes for casual players.  
   - Cosmetic progression and titles.

---

# 3. Core Inspirations Summary

## 3.1 Mortal Online (MO1/MO2)
- Full-loot PvP  
- Crafting depth  
- Player dominance of the world  
- Risk economy based on item loss  

**Borrowed:**  
- Risk zones  
- Full-loot Red zones  
- Mounted itemization (mounts as objects)  
- Material Lore and skill-based crafting  
- Player-driven politics  

**Improved:**  
- Real justice system (Outlaw state, Bounty Pots)  
- Mid-risk zones (Yellow) that aren’t punishing  
- Content variety (safe PvE, delves, raids)  
- Stronger onboarding and UI clarity  
- Reduced travel pain

---

## 3.2 World of Warcraft (WotLK Era)
- Stable networked combat  
- Polished zones and dungeons  
- Familiar controls  
- High-quality UI foundation  

**Borrowed:**  
- The world & assets  
- Combat feel  
- Dungeon layouts (repurposed)  

**Transformed:**  
- NPCs, dungeons, raids are now open or public  
- Gear is consumable (decays, loses durability)  
- Class system replaced entirely  
- Crafting replaces progression  
- Risk zones override all default PvP rules  

---

## 3.3 EVE Online
- Regional markets  
- Sovereignty & wars  
- Logistics gameplay  
- Physical items  
- Full-loot PvP survival  

**Borrowed:**  
- Regional economy  
- Hauling, piracy, escorts  
- Guild taxation and sovereignty  
- Blueprints (BPO/BPC)  

**Adapted:**  
- Trade runs integrated into WoW’s world  
- Resource scarcity by zone  
- Cargo weight & encumbrance  
- Player-operated caravans  

---

## 3.4 Runescape (Old School)
- Skill-based character progression  
- Open-ended training  
- Gear as economic sinks  
- Simplicity with depth  

**Borrowed:**  
- Skill trees  
- Action-based training  
- Professional interdependence (Smiths + Alchemists + LW)  
- Sandbox quest/task boards  
- Item variation (normal vs masterwork vs degraded)

---

# 4. Core Identity in One Sentence

**“A classless, skill-based sandbox MMO that blends Mortal Online’s danger, EVE’s economy, Runescape’s progression, and WoW’s polish — built within AzerothCore.”**

---

# 5. High-Level Feature Map

This section lists every major pillar that the rest of the spec will detail.

## 5.1 Progression
- Skill-based leveling  
- Derived levels (1–25)  
- Attribute pools (150 per stat / 400 total)  
- Mastery Trees  
- Mentor System (free early respecs)

## 5.2 Combat
- Rewritten formulas  
- Brace mechanic  
- Tab-target hybrid  
- Outlaw state  
- Bounty board  
- Friendly fire in Red  

## 5.3 World & Risk Zones
- Green (safe)  
- Yellow (mid-risk)  
- Red (full-loot)  
- Zone-by-zone redesign  
- Travel restrictions  

## 5.4 Economy
- Regional banking  
- Market stalls  
- Courier contracts  
- Trade routes  
- Seasonal resource shifts  

## 5.5 Crafting
- Multi-profession items  
- Material Lore  
- Procedural gear quality  
- Permanent decay  
- Refining stations  
- Blueprint Originals/Copies (BPO/BPC)  

## 5.6 PvE Content
- Safe solo delves  
- Public dungeons  
- Extraction raids  
- World bosses  
- Seasonal invasions  

## 5.7 Mounts & Transport
- Living mounts  
- Durability + death  
- Breeding system  
- Caravans  
- High seas PvP  

## 5.8 Guilds & Sovereignty
- Stronghold ownership  
- Territory control points  
- Siege windows  
- Taxation  
- Guild halls  
- Seasonal resets  

## 5.9 Social & Retention Systems
- Tavern games  
- Wager systems  
- Events  
- Housing (future expansion)  
- Cosmetic progression  

## 5.10 Client & UI
- MortalUI suite  
- Nameplate driver  
- Territory overlays  
- Tooltip injection  
- Launcher (Rust/Tauri)  
- DBC modifications  

## 5.11 Monetization
- Supporter tier (non-P2W)  
- Cosmetic shop  
- Tradable token (bond system)  

## 5.12 Tech Architecture
- C++ core systems  
- Lua gameplay scripts  
- SQL schemas  
- Launcher  
- Admin tooling  

**Scripting guardrails**  
- Default hot-path or security-sensitive work to AzerothCore modules in C++ (combat math, movement hooks, spawn controllers, anti-cheat); keep Lua thin.  
- `*.lua` names in these specs describe the control layer, not a mandate—build in C++ when performance matters and expose minimal Lua bindings only when AIO/UI needs them.  
- Reserve Lua for UI bridges, quest/gossip wrappers, configuration tables, and rapid prototypes; migrate prototypes to C++ once stabilized.  

## 5.13 Development Roadmap
- Phase 1–5  
- Seasonal cadence  
- Expansion framework  

### 5.14 Core Terminology (Shared Across Specs)
- **Derived Level** — `MIN(25, FLOOR(Total_Primary_Skill_Points / 48))`. Communicates general progression only (no XP). All references to "level" should mean this value.
- **Skill Bands** — 5-level groupings (1–5, 6–10, 11–15, 16–20, 21–25) used for Mentor Mode, PvE tuning, and contract eligibility.
- **Season Renown** — Meta-progress earned from challenges/seasonal content. Grants cosmetics, titles, and social rewards; never alters combat stats.
- **Task Boards** — Procedural PvE generators that replace XP quests. Rewards gold, materials, reputation, or renown-compatible currencies.
- **Contracts** — Player-facing mission templates (caravans, stronghold ops, invasions) with explicit min/max derived-level bands and faction tags.
- **Risk Tiers** — Green (safe), Yellow (mid-risk, partial loot), Red (full loot). Any mechanic that mentions zones must anchor to these tiers.

---

# 6. Document Navigation

This is **file 00** of a multi-file spec.  
Each subsequent file dives deeper into a subsystem:

- **01-progression.md** → Skills, leveling, attributes  
- **02-combat.md** → Brace, crime, PvP, formulas  
- **03-risk-zones.md** → Zone rules & consequences  
- **04-economy.md** → Full EVE-style economy spec  
- **…** (see directory list)

Use this file as your anchor for the full vision of the game.

---

# 7. Intended Audience

This document is written for:

- Designers  
- Systems engineers  
- Scripters (Lua/C++)  
- Database devs  
- Addon/UI devs  
- QA testers  
- Project leads  

It is structured to work **inside Cursor** and split easily into smaller development tasks.

---

# 8. Status

**This document is “VISION LOCKED.”**  
All future specs will reference this file.  
Major changes to core identity require version increments (27.0+).

---
```markdown

---

# 🔵 READY FOR NEXT FILE

If this file looks good, I will generate the next one:

# **`01-progression.md`**  
(Character progression, skills, leveling, attributes, Mastery Trees)

Just say **“continue”** and I will produce file #2.
