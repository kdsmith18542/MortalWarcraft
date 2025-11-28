# Project Canvas: Mortal Warcraft Overhaul
### Version 33.0 — Hybrid Technical Design Document  
### File: 51-factions-and-standing-system.md  
### Section: World Factions, Standing & Rewards

---

## 1. Purpose

Introduce a **World Factions (Syndicate-style)** system that:

- Gives players **long-term identity and goals** beyond raw gear.
- Creates **distinct economic and gameplay loops** (trade, defense, exploration, black market).
- Provides a **home** for:
  - Unique recipes/runes/augments,
  - Cosmetics, titles, banners,
  - Utility perks (insurance discounts, bank fees, etc.).
- Integrates cleanly with existing systems:
  - **Strongholds & Territory**, **Notoriety**, **Task Boards**, **Contracts**, **Atlas**, **Events**.

Design goals:

- Factions are **horizontal progression**, not raw power creep.
- Choices should be **meaningful** but not permanently punishing:
  - You can shift allegiance, but it has costs.
- Most rewards are:
  - New **options** (build paths, recipes),
  - **Visual identity**,
  - **Economic perks**, not +X% god-modes.

---

## Related Specs

For full context on faction and standing systems, see:

- **`86-mortal-factions-and-standing.md`** — Core faction and standing system implementation
- **`59-shrine-and-faction-trials.md`** — Faction trials and shrine systems that affect standing
- **`60-faction-sanctums.md`** — Faction sanctums and headquarters
- **`99-mortal-faction-meta-civic-frontier-cartel-atlas.md`** — Faction meta and major faction definitions
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Contracts and task boards tagged with factions
- **`04-economy.md`** — Economy system for faction vendors and economic perks
- **`56-negative-titles-and-notoriety-labels.md`** — Negative titles that can affect faction standing

---

## 2. Core Concepts

### 2.1 Faction Overview

Factions are **NPC-aligned organizations** with their own:

- Reputation track (**Standing**),
- Vendors & services,
- Content hooks (task boards, events, contracts),
- Philosophies and conflicts (some are opposed).

A player can:

- **Pledge** to one faction at a time as their **Primary Allegiance**.
- Gain standing passively by doing relevant activities while pledged.
- Run **Contracts** or turn in **Tokens** for extra standing.

### 2.2 Standing

Standing is a per-character numeric value per faction:

- Ranges: `-100,000` (Hated) to `+100,000` (Exalted).
- Broken into **Ranks**, e.g.:

  - Hated
  - Hostile
  - Unfriendly
  - Neutral
  - Friendly
  - Honored
  - Revered
  - Exalted

Standing changes via:

- Activities tagged with that faction.
- Turning in faction tokens / commendations.
- Choices in certain dynamic events (e.g., siding with Cartel vs. Guards).

---

## 3. Faction Roster (Initial Pass)

### 3.1 The Iron Ledger

**Theme**: Crafting Consortium & Trade Cartel (semi-legitimate).

- Focus:
  - Crafting, refining, logistics, trade.
- Likes:
  - Completing Courier Contracts,
  - Running materials to Strongholds,
  - Supplying markets in contested/Red Zones,
  - Participating in crafting events.
- Dislikes:
  - Destroying infrastructure (e.g., sabotaging trade routes),
  - Excessive player killing near trade hubs (possible standing loss).

**Rewards** (examples):

- Unique **crafting blueprints**:
  - Extra augment slots on gear,
  - More efficient refining (less waste).
- **Bank & AH perks**:
  - Reduced AH listing fees regionally,
  - Slightly larger regional bank stash at higher ranks.
- Visual:
  - Merchant cloaks/tabards,
  - Pack animal cosmetics,
  - Ledger-themed banners.

### 3.2 Order of the Shrine

**Theme**: Guardians of Shrines, anti-undead, soul-keepers.

- Focus:
  - Defending Shrines and settlements from invasions,
  - Running **Midnight Horde** and similar events,
  - Cleansing cursed artifacts.
- Likes:
  - Participating in Shrine defense events,
  - Killing undead/abomination mobs in marked zones,
  - Returning “Cursed Relics” to Shrines.
- Dislikes:
  - Desecrating Shrines,
  - Using certain Dark Market services (optional tie).

**Rewards**:

- Defensive **runes and augments**:
  - Improved Brace/Guard Counter,
  - Slight toughness boosts in vicinity of Shrines.
- **Respawn perks**:
  - Lower Shrine res penalty, slight durability protection (within limits).
- Visual:
  - Paladin/cleric-themed cosmetics,
  - Shrine banners, halos, glowing eyes (cosmetic only).

### 3.3 Black Sun Cartel

**Theme**: Smugglers, fences, and black market brokers.

- Focus:
  - Smuggling, stolen goods, Red Zone trade, Black Market.
- Likes:
  - Completing illicit **Smuggler Contracts**,
  - Selling to Black Market (Darkmoon-style) vendors,
  - Running contraband between regions, especially through Red Zones.
- Dislikes:
  - Turning in Cartel NPCs to Guards,
  - Overuse of Guard support against criminals.

**Rewards**:

- Access to **Black Market** vendors with:
  - Unique cosmetics,
  - Risky but rewarding consumables,
  - Occasionally “hot” items at a discount.
- Economy perks:
  - Better payout for stolen goods,
  - Reduced Notoriety penalties on certain criminal activities (tuned).
- Visual:
  - Masks, hoods, tattoos, outlaw dyes,
  - Cartel-brand saddle skins.

### 3.4 Rangers’ Pact

**Theme**: Scouts, explorers, Rift delvers, Hellgate runners.

- Focus:
  - Exploration, anomalies, Rifts, Hellgates, zone intel.
- Likes:
  - Closing Rifts,
  - Completing Hellgates,
  - Discovering and reporting anomalies,
  - Mapping Hot Zones and bringing back intel.
- Dislikes:
  - Ignoring calls for help at major invasions (optional),
  - Abandoning expedition contracts.

**Rewards**:

- **Exploration augments**:
  - Slight bonuses to movement, detection, survival in wilderness.
- Map perks:
  - Better info on the War Board / MortalMap (earlier warnings, more detail).
- Visual:
  - Ranger cloaks, helms, backpacks, compass-themed trinkets.

> NOTE: These 4 are the **launch set**. More factions (e.g., a Guild Council, Planar Scholars, etc.) can be added later as content expansions.

---

## 4. Standing Gain & Loss

### 4.1 Pledging

Players choose a **Primary Faction** at:

- Embassy NPCs in capitals,
- Stronghold Faction Halls.

Rules:

- Only one active **Primary** at a time.
- Switching faction:
  - Has a cooldown (e.g., 7 days),
  - May cause **partial standing decay** with old faction(s).

### 4.2 Tagged Activities

Every world/system event can optionally be tagged with faction credit:

- Courier Contract:
  - Might reward **Iron Ledger** and a bit of **Rangers’ Pact**.
- Shrine Defense:
  - Big reward to **Order of the Shrine**,
  - Minor to others if assisting.
- Hellgates:
  - Heavy **Rangers’ Pact** standing.
- Black Market sales:
  - Strong **Black Sun Cartel** standing, potential loss with Shrine/Guards (if configured).

Mechanics:

- When a tagged activity completes:
  - All participants get standing gains proportional to their contribution.
  - **Primary Faction** gets a **bonus multiplier** (e.g., +50%).

### 4.3 Tokens & Commendations

Some content drops:

- **Faction Medallions / Commendations**:
  - Bound to a specific faction,
  - Turned in at faction vendors for standing bursts,
  - Tradable or non-tradable depending on design.

This lets:

- Traders and PvEers farm & sell commendations to more focused players (if tradable).
- Provide a “catch-up” path in new content.

### 4.4 Negative Standing

Some actions reduce standing:

- Assisting enemies of a faction:
  - e.g., turning in Shrine Relics to Cartel fences.
- Failing critical events:
  - Letting a Shrine fall during defense (small penalty).
- Killing certain protected NPCs.

We keep **losses mild** to avoid punishing experimentation, except for really egregious anti-faction behavior.

---

## 5. Standing Ranks & Rewards

### 5.1 Rank Thresholds (Example)

Per faction:

- Hated:        < -50,000
- Hostile:      -50,000 to -10,000
- Unfriendly:   -10,000 to 0
- Neutral:      0 to 9,999
- Friendly:     10,000 to 29,999
- Honored:      30,000 to 59,999
- Revered:      60,000 to 89,999
- Exalted:      90,000+

Tunable per faction.

### 5.2 Reward Types

Each rank unlocks:

- **Vendor tiers**:
  - More recipes, runes, augments, cosmetics.
- **Utility perks**:
  - Reduced fees, better payouts, small bonuses in certain contexts.
- **Visuals**:
  - Titles, cloaks, banners, tabards, emotes.

No raw “+X% to all damage” style perks.

### 5.3 Example Reward Ladder (Iron Ledger)

- Neutral:
  - Basic trade contracts, simple banking perks.
- Friendly:
  - Recipes: improved pack bags, basic refining aids.
- Honored:
  - Access to trade-optimized pack animals,
  - Slight AH listing fee reduction (capped).
- Revered:
  - Augments that reduce encumbrance, small bonuses to caravan survivability.
- Exalted:
  - Cosmetic merchant gear,
  - Stronghold trading post cosmetic upgrades,
  - Maybe a custom caravan skin for Atlas.

---

## 6. Data Model (MySQL)

### 6.1 Faction Definition

```sql
CREATE TABLE IF NOT EXISTS mortal_factions (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(32) NOT NULL UNIQUE,  -- e.g. 'IRON_LEDGER'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NOT NULL,
  icon            VARCHAR(128) NULL,
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 6.2 Faction Standing Per Character

```sql
CREATE TABLE IF NOT EXISTS mortal_faction_standing (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,         -- character guid
  faction_id      INT NOT NULL,
  standing        INT NOT NULL DEFAULT 0,
  last_update     INT NOT NULL DEFAULT 0,
  INDEX idx_char_faction (guid, faction_id),
  CONSTRAINT fk_mortal_faction_standing_faction
    FOREIGN KEY (faction_id) REFERENCES mortal_factions(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 6.3 Faction Rewards (Vendor Unlocks)

```sql
CREATE TABLE IF NOT EXISTS mortal_faction_rewards (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  faction_id      INT NOT NULL,
  rank_required   VARCHAR(32) NOT NULL,    -- 'FRIENDLY','HONORED', etc.
  reward_type     VARCHAR(32) NOT NULL,    -- 'ITEM','RECIPE','AURA','TITLE','EMOTE'
  reward_ref      VARCHAR(64) NOT NULL,    -- item entry, spell id, title id, etc.
  cost_gold       INT NOT NULL DEFAULT 0,
  cost_token_id   INT NULL,                -- optional specific token
  cost_token_amt  INT NULL,
  flags           INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_mortal_faction_rewards_faction
    FOREIGN KEY (faction_id) REFERENCES mortal_factions(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 6.4 Faction Activity Tags (Optional)

For more dynamic mapping, a table for “what gives standing”:

```sql
CREATE TABLE IF NOT EXISTS mortal_faction_activity_tags (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  activity_code   VARCHAR(64) NOT NULL,  -- e.g. 'CONTRACT_COURIER_T1', 'EVENT_SHRINE_DEFENSE'
  faction_id      INT NOT NULL,
  standing_delta  INT NOT NULL,         -- base amount
  flags           INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_mortal_faction_activity_tags_faction
    FOREIGN KEY (faction_id) REFERENCES mortal_factions(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Server scripts for events/contracts would just reference `activity_code`.

---

## 7. Integration Points

### 7.1 Strongholds & Territory

- Stronghold owners can be **favored** by certain factions:
  - Iron Ledger may reward guilds who maintain stable trade hubs.
  - Order of the Shrine may reward guilds who hold Shrines and defend zones.

Possible hooks:

- Strongholds tagged as “Faction-aligned”:
  - Extra cosmetic upgrades from that faction,
  - Discounted faction services within that Stronghold.

### 7.2 Notoriety & Bounty Systems

- Black Sun Cartel:
  - Gains from some criminal activities (smuggling, fencing stolen goods).
  - May conflict with Order of the Shrine / Guards.
- High Notoriety:
  - May block access to certain factions (e.g., Shrine faction refusing wanted criminals),
  - Or give different dialogue/options.

Balance:

- Keep faction vs Notoriety interplay **interesting but not hard-locking** players out of huge parts of the game.

### 7.3 Task Boards & Contracts

- Each faction should:
  - Have a weight in relevant **Task Board** entries.
  - Provide **Faction Contracts**:
    - e.g., Iron Ledger cargo hauling,
    - Shrine patrol/cleansing,
    - Cartel smuggling,
    - Rangers’ scouting/hellgate missions.

These are natural daily/weekly fodder and good tie-ins to the “Season of the Frontier” track.

### 7.4 Atlas (Web Portal) Integration

Atlas should be able to:

- Show **faction overviews** and lore.
- Show per-character standing (if authenticated & linked).
- Eventually feature:
  - Faction leaderboards,
  - Guild-to-faction alignment stats,
  - Faction event feeds (“Shrine Defense succeeded in Duskwood”).

---

## 8. UI & UX

### 8.1 In-Game UI

- **Faction Panel**:
  - List of known factions, rank, progress bars.
  - Highlighted **Primary Faction**.
  - Button to view **Rewards** for each rank.
- **Pledge UI**:
  - At Embassies / faction halls:
    - Shows consequences of switching (cooldown, decay).
- **Context Hints**:
  - When you complete a faction-tagged activity:
    - Floating text: “+X [Faction] Standing”.
  - MortalUI tooltip overlays:
    - Show relevant faction for tasks/events.

### 8.2 Atlas UI

- Web pages per faction:
  - Lore, ranks, rewards (publicly visible).
- Player dashboard:
  - If authenticated and linked: shows current standing per faction.
- Optional:
  - Seasonal leaderboard widgets per faction.

---

## 9. Tuning & Safety Rails

To keep things from getting degenerate:

- **Standing Caps per Day**:
  - Soft daily caps on standing gains from repetitive activities to avoid bots exploiting a single loop.
- **Switching Penalties**:
  - Graceful but real:
    - Cooldown on changings primaries,
    - Partial decay with old factions to avoid “flavor-of-the-month hopping.”
- **Reward Safeguards**:
  - No direct +% damage/healing global auras.
  - Utility perks are:
    - Localized (e.g., near Shrines, in caravans),
    - Capped to avoid big economic imbalances.

---

## 10. Implementation Checklist

1. **DB & Definitions**
   - Add `mortal_factions`, `mortal_faction_standing`, `mortal_faction_rewards`,
     and optionally `mortal_faction_activity_tags`.
   - Seed initial 4 factions (Iron Ledger, Order of the Shrine, Black Sun Cartel, Rangers’ Pact).
2. **Server Logic**
   - Implement standing get/set APIs in core (C++) + Lua bindings.
   - Add pledge / primary faction selection logic.
   - Wire events/contracts/activities to grant standing via activity tags.
3. **NPCs & Vendors**
   - Place faction Embassy NPCs in capitals.
   - Add vendor templates using `mortal_faction_rewards` gating by rank.
4. **Activities**
   - Tag key systems:
     - Courier Contracts,
     - Shrine defenses,
     - Rifts/Hellgates/anomalies,
     - Smuggling / Black Market sales.
5. **UI**
   - MortalUI: Faction panel, pledge UI, standing gain popups.
   - Basic vendor dialogue updates for factions at different standings.
6. **Atlas**
   - Add factions to Atlas DB.
   - Build faction pages and player standing display (once character linking is wired).
7. **Balancing Pass**
   - Tune standing gain rates, caps, and reward unlock thresholds.
   - Ensure rewards are enticing but not mandatory for baseline viability.

