# Project Canvas: Mortal Warcraft Overhaul
### Version 32.1 — Hybrid Technical Design Document  
### File: 50-lifeskills-fishing-and-first-aid.md  
### Section: Lifeskills — Fishing & First Aid

---

## 1. Purpose

Define **Fishing** and **First Aid** as lifeskills that:

- Deepen the **survival** and **logistics** layer.
- Integrate with **Deep Crafting**, **Economy**, and **Risk Zoning**.
- Respect the core healing philosophy:
  - No infinite potion spam,
  - **Crimson Phial** remains the primary burst self-heal,
  - **Healer players + Healer Mercs** are still required for serious content.

Fishing = **chill but risky gathering profession** with strong economic and planar ties.  
First Aid = **triage & debuff management**, not replacement group healing.

---

## Related Specs

For full context on lifeskills, see:

- **`22-healing-and-restoration.md`** — Healing system that First Aid complements
- **`05-crafting.md`** — Crafting system that Fishing feeds into (Cooking, Alchemy)
- **`21-elden-systems.md`** — Elden systems (Crimson Phial) that First Aid works alongside
- **`03-risk-zones.md`** — Risk zones that affect Fishing locations and First Aid usage
- **`91-mortal-anomalies-rifts-hellgates.md`** — Anomalies and rifts that Fishing can provide keys for
- **`04-economy.md`** — Economy system for Fishing products and First Aid materials
- **`01-progression.md`** — Skill system that governs Fishing and First Aid progression

---

## 2. Fishing — Design Overview

### 2.1 Role

Fishing is a **gathering lifeskill** that provides:

- **Food components** for Cooking (stat foods, travel foods).
- **Reagents** for Alchemy (oils, tonics, rare catalysts).
- **Special bait & keys** for anomalies, planar rifts, and rare boss triggers.

It should:

- Encourage visiting **dangerous waters** (rivers, coasts, open sea, Red Zones).
- Tie into **Material Lore** and **regional economies**.
- Offer content for solo/chill players without breaking risk or the gold faucet.

### 2.2 Skill Lines

Base skill tree (subject to tuning):

- `Fishing: Coastal`  
  - Lakes / seas near Green/Yellow zones.
- `Fishing: Inland`  
  - Rivers, ponds, underground pools.
- `Fishing: Deep Sea`  
  - Open ocean, high-risk coasts, offshore reefs.
- `Fishing: Planar` (late-game)  
  - Special rifts on water surfaces, Emerald Dream lakes, etc.

Each line:

- Governs **max-tier fish** you can reliably catch.
- Affects **junk vs. quality** ratio.
- Interacts with **Material Lore: Fish**.

### 2.3 Material Lore: Fish

New lore line(s):

- `Lore: Freshwater Fish`
- `Lore: Saltwater Fish`
- `Lore: Abyssal/Planar Fish` (late-game)

Effects:

- Higher Lore:
  - More meat/reagents when cleaning fish,
  - Lower spoilage/rot chance,
  - Unlock certain recipes:
    - High-end oils (weapon/armor buffs),
    - Rare cooking recipes,
    - Special baits for anomalies.

---

## 3. Fishing — Mechanics

### 3.1 Basic Loop

1. Player equips a **Fishing Rod** and has **Bait** (optional but recommended).
2. Targets a water GameObject or fishing node.
3. Uses “Cast Line” ability:
   - Float/bobber spawns at the surface.
4. After a random short delay:
   - A **“Bite Window”** triggers (0.75–1.5s base, modified by skill).
   - Client gets cue:
     - Bobber splash sound,
     - Small visual jiggle.

5. Player presses the **Interact** key within that window:
   - Success:
     - Catch roll based on:
       - Fishing skill,
       - Appropriate skill line (Coastal/Inland/etc.),
       - Zone tier,
       - Bait used.
   - Failure:
     - Junk or small fish.

Implementation:

- Use existing WoW fishing mechanics as base, with:
  - Customized timing,
  - Expanded loot tables,
  - Additional feedback.

### 3.2 Risk vs Reward by Zone Tier

- **Green Zones**:
  - Safe.
  - Mostly:
    - Basic food fish,
    - Low-tier reagents.
- **Yellow Zones**:
  - Increased chance of:
    - **Buff foods** (small combat bonuses),
    - Alchemy-grade fish oils,
    - Rare fish that convert into anomaly baits.
- **Red Zones**:
  - Best tables:
    - High-end buff fish,
    - Abyssal/Planar fish for rare alchemy recipes,
    - Components for runes / advanced crafting.
  - Coastal & Deep Sea nodes:
    - High yield, high risk (full loot, High Seas PvP, boat encounters).

### 3.3 Perishable Goods

To keep economy healthy:

- Raw fish **can rot** if not processed within a time window.
- States:
  - Fresh → Edible → Stale → Rotten.
- Rotten fish:
  - Limited use (e.g., bait for specific nasty mobs),
  - Otherwise near worthless.

Processing:

- Cooking / Smoking / Salting recipes convert fish into:
  - Long-lasting food,
  - Long-lasting reagents.
- This creates:
  - **Time pressure** for logistics,
  - Trade opportunities (hauling fresh fish to crafting hubs).

### 3.4 Integration with Other Systems

- **Cooking**:
  - Travel foods (stamina regen, out-of-combat HP regen),
  - Combat stat foods (within strict buff budgets).
- **Alchemy**:
  - Fish oils:
    - Minor weapon/armor coatings,
    - No stacking with powerful buffs,
    - Possibly anti-corruption/pollution resistances.
- **Anomalies / Planar Rifts**:
  - Rare fish → processed into **Arcane Baits** that:
    - Increase chance of anomalies near water,
    - Unlock micro-dungeons in watery zones.
- **Strongholds & Housing (future)**:
  - Decorative items (Mounted Fish), trophies.

---

## 4. Fishing — Data & SQL (Skeleton)

### 4.1 Skill Definitions (world DB / custom skills)

Example entries (pseudo-structure):

- `SKILL_FISHING_COASTAL`  
- `SKILL_FISHING_INLAND`  
- `SKILL_FISHING_DEEPSEA`  
- `SKILL_FISHING_PLANAR`

Plus `SKILL_LORE_FISH_FRESH`, `SKILL_LORE_FISH_SALT`, etc.

### 4.2 Loot Tables

Define custom fishing loot tables per:

- `map_id`, `zone_id`, `water_type`, `risk_tier`.

Pseudo-SQL:

```sql
CREATE TABLE IF NOT EXISTS mortal_fishing_loot (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  map_id          INT NOT NULL,
  zone_id         INT NOT NULL,
  water_type      VARCHAR(16) NOT NULL, -- 'coastal','inland','deep','planar'
  risk_tier       INT NOT NULL,         -- 1..5 aligned with Green/Yellow/Red mapping
  item_entry      INT NOT NULL,
  min_count       INT NOT NULL DEFAULT 1,
  max_count       INT NOT NULL DEFAULT 1,
  base_chance     FLOAT NOT NULL,       -- 0..100
  skill_req       INT NOT NULL DEFAULT 0,
  lore_req        INT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Server logic:

- On successful “Bite”:
  - Query table by map/zone/water_type/risk_tier.
  - Apply skill and lore modifiers to `base_chance` and junk chance.

---

## 5. First Aid — Design Overview

### 5.1 Role

First Aid is **field medicine** focused on:

- Treating **bleeds, wounds, and poisons**.
- Providing **slow, resource-based healing** mostly out-of-combat.
- Offering **emergency triage** in combat at a cost.

First Aid:

- Does **not** replace Healer roles or Cleric Mercs in serious content.
- Reinforces the survival/harshness identity while giving players tools to avoid spiraling.

### 5.2 Skill Lines

Suggested:

- `Field Medicine`  
  - General bandaging, out-of-combat HoTs.
- `Trauma Care`  
  - Combat dressings, fracture/slow debuff management.
- `Toxicology`  
  - Antidotes, disease/poison cures.

---

## 6. First Aid — Mechanics

### 6.1 Basic Bandaging

**Ability: Simple Bandage**

- Use:
  - **Out of combat only**,
  - Requires `Bandage` item.
- Effect:
  - Restores X% HP over 10–15 seconds.
  - Breaks on damage.
- Scaling:
  - `Field Medicine` skill increases:
    - Total HP restored,
    - Slightly reduces channel time.

Purpose:

- Primary way to **recover HP between fights** without burning Crimson Phial charges.
- Consumes resources (cloth + reagents), feeding economy.

### 6.2 Combat Dressings

**Ability: Combat Dressing**

- Use:
  - Cast in combat,
  - Requires special `Combat Dressing` consumable.
- Effect:
  - Immediately removes or massively reduces **Bleed** effects (DoTs tagged as “wound”),
  - Small instant heal (tunable, low).
- Constraints:
  - Short but non-trivial cast time (you’re vulnerable),
  - Significant cooldown per target,
  - Dressing item is **consumed**.

Purpose:

- Triage tool against heavy physical DoTs or specific bleed-focused enemies.
- Adds tactical choices in boss/elite fights.

### 6.3 Fracture / Movement Debuff Care

**Ability: Splint / Stabilize**

- Use:
  - Out of combat or with long cast in combat.
- Effect:
  - Removes or downgrades:
    - “Limping” debuff,
    - Movement speed penalties from falls or heavy hits.
- Cost:
  - `Splint Kits` (crafted),
  - Possibly uses wood + cloth.

Purpose:

- Prevents “soft-lock” frustration after bad falls or heavy hits.
- Reward for groups that bring a First Aid-capable player.

### 6.4 Antidotes, Disinfectants & Cleanses

**Ability: Antidote / Disinfect**

- Use:
  - Targets self or ally,
  - Consumes `Antidote` or `Disinfectant` item.
- Effect:
  - Clears or reduces:
    - Tagged **Poison** or **Disease** debuffs.
- Scaling:
  - `Toxicology` determines:
    - Which debuffs can be cured,
    - Success chance versus high-tier effects.

Purpose:

- Gives non-magic characters and healer-light groups **some tools** against poison-heavy zones and enemies.
- Still inferior to specialized healer spells in uptime/throughput.

---

## 7. First Aid — Data & Items

### 7.1 Bandages & Kits

Define new item families:

- `ITEM_BANDAGE_T1`, `ITEM_BANDAGE_T2`, ...
- `ITEM_COMBAT_DRESSING_T1`, ...
- `ITEM_SPLINT_KIT_T1`, ...
- `ITEM_ANTIDOTE_T1`, `ITEM_ANTIDOTE_T2`, ...

Crafted via:

- Cloth,
- Herbs,
- Fish oils / alchemical reagents (for higher tiers).

### 7.2 Crafting Integration

Recipes:

- Some via:
  - Trainers / First Aid manuals,
  - Task Board rewards,
  - Rare drops from medical-themed events (plague outbreaks, etc.).
- Some gated behind:
  - `Field Medicine`/`Trauma Care`/`Toxicology` skill thresholds.

---

## 8. Healing Budget & Constraints

To avoid breaking the healing economy:

- **Crimson Phial**:
  - Remains the **strongest instant self-heal** per action,
  - Hard-limited by charges + refill rules.

- **First Aid**:
  - Out-of-combat:
    - Very efficient over time, but slow and item-gated.
  - In combat:
    - Small, expensive, and risky.
    - Positioned as **emergency triage**, not spam throughput.

- **Healer Players & Mercs**:
  - Still required for:
    - High-end dungeons,
    - Raids,
    - Large-scale PvP where healing throughput matters.

Levers for tuning:

- Healing amounts,
- Cooldowns,
- Cast times,
- Bandage/kit material cost,
- Drop/craft rate for materials.

---

## 9. Integration & Hooks

### 9.1 Systems That Touch Fishing

- **Deep Crafting & Decay**:
  - Fish as decaying materials that must be processed.
- **Economy**:
  - Fish and fish-derived reagents as trade goods.
- **Events**:
  - Fishing tournaments,
  - Rare anomaly baits,
  - Zone events in coastal/river areas.
- **Strongholds / Housing**:
  - Fishing trophies and decorations.

### 9.2 Systems That Touch First Aid

- **Combat Design**:
  - Bleeds, fractures, poisons/diseases tagged so First Aid can interact.
- **Dungeon/Raid Design**:
  - Encounters that reward groups who bring First Aid specialists.
- **Mercenaries**:
  - Some Merc templates could have minor First Aid capabilities (but not full healers).
- **Task Boards**:
  - Medical supply delivery tasks (bandages, antidotes) for reputation/gold.

---

## 10. Implementation Checklist

1. Define skill IDs for:
   - Fishing skill lines,
   - Fish Lore,
   - First Aid skill lines.
2. Add **Fishing mechanics**:
   - Cast, bite window, simple minigame feedback,
   - `mortal_fishing_loot` table and loot logic,
   - Perishable fish state & processing recipes.
3. Add **First Aid mechanics**:
   - Bandage and kit items,
   - Simple Bandage, Combat Dressing, Splint, Antidote abilities,
   - Skill scaling hooks.
4. Integrate into **Deep Crafting**:
   - Recipes for fish processing and medical consumables.
5. Tune initial **healing budgets**:
   - Ensure First Aid supports survival but doesn’t obsolete Phials or healers.
6. Add basic **content hooks**:
   - Fishing-spot spawners per risk tier,
   - Bleed/poison-heavy mobs that highlight First Aid’s value.

