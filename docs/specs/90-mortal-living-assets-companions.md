# Project Canvas: Mortal Warcraft Overhaul  
### File: 90-mortal-living-assets-companions.md  
### Topic: Living Assets – Mounts, Pets, Mercenaries & Upkeep

> This document unifies all **non-player “living assets”** into a coherent system:  
> mounts, combat pets, hireable mercenaries, and utility companions.  
>  
> Goals:  
> - Preserve Mortal’s **risk, economy sinks, and identity**.  
> - Reuse WoW 3.3.5a systems (pet happiness, stables, mounts) where possible.  
> - Keep implementation **C++-first** with Lua for behaviors & content.

---

## 1. Design Goals

1. **One mental model** for all living assets:
   - They are **not permanent unlocks**; they require care, risk, or gold.
   - They should be **valuable but expendable**, not cosmetics you ignore.

2. Tie living assets into:
   - **Economy** (upkeep, fodder, stabling, contracts),
   - **Standing** (who will work for you),
   - **Risk** (full loot, death, fleeing).

3. Avoid:
   - Purely “free” endless army of bots following players,
   - Mercs trivializing group content,
   - Confusion between **playerbots** (AI players) and **mercenaries** (bounded service).

---

## 2. Asset Types Overview

We define four canonical living-asset types:

1. **Mounts (Living Transport)**
   - Horse, warsteed, exotic mounts.
   - Already partially designed as **Reins items** with durability and full-loot.

2. **Combat Pets (Personal Beasts & Summons)**
   - Reinterpretation of Hunter pets, Warlock demons, etc.
   - Tied to **Beastmaster / Occultist / Ranger** style builds.

3. **Mercenaries (Hireable NPCs)**
   - Healer/Tank/DPS/Support NPCs.
   - Distinct from `mod-playerbots`:
     - Time-limited, role-limited, contract-based.

4. **Utility Companions**
   - Pack mules, vendor pets, gathering drones, etc.
   - Often non-combat or low-combat; act as **mobile services**.

Implementation: All four share common concepts:

- **Bond Level** (how loyal/effective they are to you).
- **Upkeep / Needs** (feeding, wages, stabling).
- **Risk** (flee, die, be stolen, be looted).

---

## Related Specs

For full context on living assets and companions, see:

- **`29-companion-bond-and-mercenary-system.md`** — Unified companion and mercenary system
- **`07-mounts.md`** — Mount system that is part of living assets
- **`23-mercenary-healers.md`** — Mercenary healer system for instances
- **`28-mounts-living-system-and-mapping.md`** — Mount living system and mapping
- **`04-economy.md`** — Economy system for companion upkeep, wages, and stabling
- **`03-risk-zones.md`** — Risk zones that affect companion loot rules and availability
- **`13-caravans-contracts.md`** — Caravan system that uses pack animals and mounts

---

## 3. Mounts – Final Model

We extend the existing **Living Mounts** design into a full spec.

### 3.1 Core Rules (Recap & Finalization)

1. **No Spellbook Mounts**
   - Mounts are **not** learned spells.
   - You must have a **Reins item** in your bag to mount.

2. **Full Loot**
   - If you die in PvP and drop a corpse chest:
     - The **Reins item is inside the chest**.
   - If your chest is looted, you lose the mount.

3. **Durability & Death**
   - Reins have **durability**.
   - If you’re forcibly dismounted (damage threshold):
     - Reins lose durability.
   - At 0 durability:
     - The mount **dies**; Reins become a “Broken Reins” item (scrappable for some mats).

4. **Feeding & Care (using pet happiness tech)**
   - Reuse Hunter Pet **happiness** as **Mount Condition**:
     - Happy → full speed & control.
     - Unhappy → slower, more skittish, chance to rear/throw rider in panic.
   - Feeding mount-appropriate food and/or stabling them improves Condition.

### 3.2 Stabling & Ownership

- **Stables in cities & frontier hubs**:
  - You can **stable** mounts (Reins bound to stable slot).
  - Stabled mounts:
    - Are safe from full loot (Reins item in stable, not in bag),
    - Slowly recover Condition over time for a small fee.

- **Ownership & Transfer**
  - Reins can be **tradable** or **soulbound** depending on mount tier.
  - High-tier war mounts may require:
    - Frontier Standing,
    - Special Contracts, or
    - Guild Stronghold ownership.

### 3.3 Economy Hooks

- Mount fodder/feed:
  - Cheap, but consumed regularly.
- Stabling fees:
  - Gold sink, scaled with mount quality.
- Mount crafting:
  - Saddle & harness crafted by Leatherworkers/Smiths.

---

## 4. Combat Pets – Beasts & Summoned Allies

Reworking Hunter/Warlock pets into **Mortal beasts/summons**.

### 4.1 Core Concepts

1. **Tamed Beasts**
   - Certain archetypes (Ranger, Beastmaster) can tame animals.
   - Tamed beasts:
     - Have a **Bond Level** with the player.
     - Use a variant of pet happiness → **Loyalty**.

2. **Summoned Entities**
   - Occult/arcane pets (demons, elementals) are **summons**, not living beasts:
     - They cost resources (mana, reagents, or Ether).
     - They don’t persist offline or across long periods.

### 4.2 Bond & Loyalty

Combat beasts have:

- **Loyalty Score** (0–100):
  - 0–20: Disobedient, may refuse commands or flee.
  - 21–60: Normal obedience.
  - 61–100: High obedience, small combat bonuses.

**Loyalty modifiers**:

- **Up**:
  - Feeding,
  - Winning fights,
  - Not letting them die repeatedly.
- **Down**:
  - Starvation (no feed for long periods),
  - Frequent deaths with no healing,
  - Being abandoned in dangerous zones.

If Loyalty falls too low:

- Beast may **flee permanently**.
- Alternatively, may **turn wild** (hostile), creating emergent events.

### 4.3 Death & Risk

- In **full loot** zones:
  - Beasts **die** if not revived by Wardens or pet skills.
  - Revive options:
    - Shrine rituals,
    - Special items (e.g. Beast Heart),
    - Or permanent loss.

- Beast collars or control items:
  - Can be looted if dropped (at GM-configurable rate).

### 4.4 Implementation Notes

- Reuse WoW pet system:
  - Pet happiness → Loyalty,
  - Pet talents/moves → mapped to Runes/passives.
- Heavily restrict:
  - The number of concurrent beasts per player (1 standard).
  - How they behave in instanced content (avoid AFK soloing).

---

## 5. Mercenaries – Contract-Based NPC Helpers

These are **NOT** full `mod-playerbots` clones.

### 5.1 Core Rules

1. **Contract-Based**
   - You hire a merc at specific hubs (taverns, guild halls).
   - Contract defines:
     - **Duration** (time or number of encounters),
     - **Role** (Healer/Tank/DPS/Support),
     - **Wage** (gold per unit).

2. **Role-Locked & Scaled**
   - Mercs have:
     - Role-based skill kits,
     - Power scaled to your **Dynamic Level** (with caps).
   - Designed to **fill gaps**, not replace players.

3. **Risk & Behavior**
   - If you die in a full-loot fight:
     - Merc tries to **flee** with a probability based on:
       - Wages paid up,
       - Your Standing with relevant factions.
   - Mercs do **not** produce loot when killed (no gearing from their corpses).

4. **Content Limits**
   - Mercs are:
     - Allowed in **open world**, public dungeons, basic instanced content.
     - **Disabled or capped** in:
       - Warfronts,
       - Ranked arenas,
       - Certain endgame raids (configurable).

### 5.2 Healer Mercenary Design (Disc/Resto Style)

As previously discussed:

- Based on Disc Priest/Resto Druid/Resto Shaman mechanics:
  - Shields, spot heals, HoTs.
- Limited ability set:
  - Enough to keep a small group afloat, not enough to trivialize mechanics.
- Behavior priorities:
  - Keep you alive first,
  - Then other party members,
  - Avoid standing in obvious AoE.

### 5.3 Economy Hooks

- Up-front hiring cost + per-Contract wage:
  - Money sink.
- Standing:
  - Some mercenaries available only at certain Standing thresholds (Civic, Frontier).

---

## 6. Utility Companions – Vendors, Pack Mules & Eco-Bots

Non-combat or low-combat entities:

### 6.1 Types

1. **Squire / Pack Mule**
   - Extra inventory slots.
   - May reduce **encumbrance** by carrying heavy items.
   - Can be **attacked in Red Zones**:
     - If killed, their pack chest drops (lootable).

2. **Vendor Companions**
   - E.g. Squire Pet from Supporter status:
     - Repair & basic vendor.
   - Cannot be summoned in certain high-risk areas (configurable).

3. **Eco-Bots / Civilian Bots**
   - Sandbox economy helpers:
     - Buy low-tier goods from players at fixed prices.
   - Represent **NPC demand** to smooth out markets.

### 6.2 Upkeep

- Feed (for animals),
- Maintenance costs (for bots),
- Small service cooldowns to avoid constant spam.

---

## 7. Shared Upkeep & Need System (Optional Unified Model)

To avoid four totally separate mini-systems, we can define a **common “Need Meter”**:

- Mounts → Condition (feed, stable).
- Combat Pets → Loyalty (feed, fight success).
- Mercs → Morale (wages, survival).
- Utility Companions → Maintenance (feed or repair).

Common ideas:

- Each asset has **Needs** from 0–100.
- Above 60: full effectiveness.
- 30–60: minor penalties.
- 0–30: severe penalties or risk of fleeing/dying.

This can be implemented as:

- One C++ helper:
  - `MortalLivingAsset::AdjustNeed(assetId, delta)`.
- Scripted per-type effects in Lua (how each responds to low Need).

---

## 8. Integration with Other Systems

### 8.1 Standing

- Certain NPC types require minimum Standing:
  - High-end war mounts → Frontier or Civic Standing.
  - Elite mercs → Frontier/Civic combination.
  - Occult pets/beasts → Shrine or Atlas standings.

### 8.2 Economy & Tasks

- Task Boards may offer:
  - Companion-related Contracts (protect caravan mule, escort warbeast, recover stolen mount).
- Companion upkeep:
  - Constant low-level gold sink.
- Crafting:
  - Specialized gear for mounts/pets (saddles, barding, collars) feed into professions.

### 8.3 Atlas

- Atlas could display:
  - Regions with high companion losses (dangerous routes).
  - Market data for fodder/feed and companion gear.

---

## 9. Implementation Plan

1. **Mounts**
   - Finalize Reins item templates.
   - Implement Condition using pet happiness backend.
   - Add stabling NPCs and DB tables for stabled mounts.

2. **Combat Pets**
   - Rewire Hunter/Warlock pet systems into:
     - Beastmaster/Ranger/Occultist styles.
   - Implement Loyalty system.
   - Hook beast death/flee logic to full-loot and risk rules.

3. **Mercenaries**
   - Build separate **Merc Manager** C++ module:
     - Contract creation,
     - Role templates,
     - Wages and duration.
   - Integrate with gossip menus in taverns/guild halls.

4. **Utility Companions**
   - Implement Pack Mule and Vendor Squire as templates.
   - Add simple needs/upkeep and kill/loot rules in Red Zones.

5. **Shared Needs (if adopted)**
   - Create unified Need meter & helper functions.
   - Incrementally migrate mounts/pets/mercs/companions onto it.

---

## 10. Summary

This “Living Assets” system pass:

- Unifies **mounts**, **pets**, **mercs**, and **utility companions** under one conceptual umbrella.
- Respects:
  - Mortal’s full loot and risk structure,
  - Economy needs (gold sinks, crafting hooks),
  - Standing/factions (who trusts you enough to work with you).
- Reuses:
  - WoW’s existing **pet, mount, and stable tech** wherever possible,
  - With C++ modules doing the heavy lifting and Lua used for flavor/content.

It should be used as the reference whenever adding or modifying any system involving NPCs that “belong” to a player but are not players themselves.
