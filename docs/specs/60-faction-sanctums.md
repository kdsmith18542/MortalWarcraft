# Project Canvas: Mortal Warcraft Overhaul
### Version 36.0 — Hybrid Technical Design Document  
### File: 60-faction-sanctums.md  
### Section: Faction Sanctums (Order Halls for a Classless World)

---

## 1. Purpose

Create **Faction Sanctums** inspired by WoW’s Order Halls, adapted to Mortal Warcraft’s:

- Classless, skill-based characters,
- Four primary launch factions:
  - **Iron Ledger**,
  - **Order of the Shrine**,
  - **Black Sun Cartel**,
  - **Rangers’ Pact**.

Goals:

- Give players **“home bases”** aligned with playstyle.
- Provide **faction-flavored progression**:
  - Vendors, augments, appearances, contracts, Trials.
- Make Sanctums **social hubs** without replacing cities or Strongholds.

---

## Related Specs

For full context on faction sanctums, see:

- **`51-factions-and-standing-system.md`** — Faction system that sanctums are part of
- **`86-mortal-factions-and-standing.md`** — Core faction and standing system implementation
- **`59-shrine-and-faction-trials.md`** — Faction trials accessed through sanctums
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Contract boards located in sanctums
- **`04-economy.md`** — Economy system for sanctum vendors and banking
- **`09-social-systems.md`** — Social systems that sanctums provide

---

## 2. Concept Overview

### 2.1 What a Sanctum Is

Each faction Sanctum is:

- A **bespoke instanced or semi-instanced interior**:
  - Shared among all players of that faction (or all players with sufficient standing).
- Contains:
  - Faction-specific vendors,
  - Contract boards,
  - Trial access NPCs,
  - Cosmetic / decoration progression.

### 2.2 Access Rules

Access gated by:

- Base: neutral/common hall available at **Neutral** standing.
- Deeper wings and services unlock at:
  - Friendly / Honored / Revered / Exalted.

Can be reached via:

- Portal/transport from cities,
- Or via physical entrance in the world for immersion.

---

## 3. Layout & Features (Per Faction)

### 3.1 Iron Ledger Sanctum

Theme:

- Trade hall, ledgers, vaults, warehouses.

Key features:

- Enhanced banking (extra slots for materials when at high standing),
- Contract boards:
  - Trade routes,
  - Caravan protection,
  - Supply acquisition.
- Vendors:
  - Crafting recipes & augments (encumbrance/logistics-focused),
  - Appearance sets themed as merchant/industrial.
- Utility:
  - Discounted insurance products at higher rep.

### 3.2 Order of the Shrine Sanctum

Theme:

- Chapel / crypt / defensive war room.

Key features:

- Trial access:
  - Many **Bulwark** Trials originate here.
- Shrine defense planning:
  - View current Shrine threat levels (Atlas integration).
- Vendors:
  - Anti-undead augments,
  - Holy-themed appearances.
- Utility:
  - Sanctuary buff for defenses,
  - Faster resurrection near Shrines at high rep.

### 3.3 Black Sun Cartel Sanctum

Theme:

- Hidden speakeasy / undercity den.

Key features:

- Black Market preview & access,
- Smuggler contract boards,
- Fence NPCs:
  - Better rates for stolen goods at higher rep.
- Vendors:
  - Risk/economy augments,
  - Rogue-ish appearances (masks, cloaks, finery).
- Utility:
  - Reduced economic penalties for death (e.g., lower gold tax),
  - Better intel on high-value trade routes.

### 3.4 Rangers’ Pact Sanctum

Theme:

- Ranger lodge / war room for Rifts & wilderness operations.

Key features:

- Rift/Anomaly boards,
- Endless Contracts tied to wilderness,
- Vendors:
  - Movement/vision augments,
  - Exploration gear appearances.
- Utility:
  - Improved tracking of anomalies and Hot Zones,
  - Slightly increased rewards from wilderness contracts at high rep.

---

## 4. Data Model (MySQL)

Sanctums are mostly a **map/content design** problem, but we track:

### 4.1 Sanctum Unlock Levels

```sql
CREATE TABLE IF NOT EXISTS mortal_faction_sanctums (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  faction_code    VARCHAR(64) NOT NULL,          -- 'IRON_LEDGER','ORDER_SHRINE',etc.
  tier            INT NOT NULL,                  -- 1..N
  standing_min    INT NOT NULL,                  -- minimum standing to unlock
  map_id          INT NOT NULL,
  entrance_go_id  INT NULL,                      -- optional gameobject entry for portal/door
  flags           INT NOT NULL DEFAULT 0,
  UNIQUE KEY uniq_faction_tier (faction_code, tier)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.2 Player Sanctum State (Optional)

If needed for per-player features (decorations, etc.):

```sql
CREATE TABLE IF NOT EXISTS mortal_faction_sanctum_state (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,
  faction_code    VARCHAR(64) NOT NULL,
  unlocked_tier   INT NOT NULL DEFAULT 0,
  decor_json      JSON NULL,                     -- personalized deco if used
  last_update_ts  INT NOT NULL,
  UNIQUE KEY uniq_guid_faction (guid, faction_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 5. Sanctum Services & Systems Integration

### 5.1 Vendors & Augments

Sanctums house **faction vendors** that:

- Sell:
  - Faction-specific augments,
  - Recipes,
  - Appearance unlock tokens,
  - Faction-themed mounts/pets.

Integration:

- Uses existing Faction Standing system for cost & availability.

### 5.2 Contract Boards

Each Sanctum has a board or NPC for:

- Faction-specific World Contracts (see World Contracts spec),
- Higher-tier Endless Contracts,
- Special “Operations”:
  - Multi-step missions for lore and rewards.

### 5.3 Trials

Faction Sanctums are main access points for:

- Faction Trials (see Trials spec),
- Show Trial tiers in UI,
- Give some Trials Sanctum-only access for narrative weight.

---

## 6. Social & Cosmetic Progression

### 6.1 Faction Ranks & Visuals

As players rise in standing:

- Sanctum NPCs and environment evolve:
  - More banners, better equipment visible in the hall,
  - NPCs recognize the player’s rank in greetings.
- Player unlocks:
  - Faction tabards and cloaks,
  - Faction titles (already covered in Titles spec),
  - Unique emotes / stances (cosmetic only).

### 6.2 Group Use

Sanctums are:

- Shared spaces:
  - You see other players there,
  - Good place to form groups for faction content.

---

## 7. UI & UX

### 7.1 Sanctum Overview Panel

From within Sanctum or Faction UI:

- Shows:
  - Current faction standing,
  - Unlocked Sanctum tier,
  - Available vendors & services,
  - Active faction contracts & Trials.

### 7.2 Atlas Integration

- Atlas web portal:
  - Faction dashboard:
    - Current faction rep & unlocked perks,
    - Sanctum overview pages:
      - Lore,
      - Unlockable cosmetics,
      - Featured contracts & Trials.

---

## 8. Implementation Checklist

1. **Level Design**
   - Build 1 Sanctum layout per faction.
   - Place NPCs, vendors, boards, Trial entrances.

2. **DB**
   - Create `mortal_faction_sanctums` (+ optional `mortal_faction_sanctum_state`).
   - Configure standing thresholds & map IDs.

3. **Server**
   - Enforce standing requirements to:
     - Access Sanctum,
     - Use services.
   - Hook Sanctum services into:
     - Faction vendors,
     - Contract system,
     - Trials.

4. **UI**
   - Faction Sanctum panel (MortalUI),
   - NPC gossip for entrance/exit,
   - Atlas pages.

5. **Balancing**
   - Ensure Sanctum perks are:
     - Flavorful and convenient,
     - Not mandatory power spikes over other playstyles.

---

Faction Sanctums give your players strong identity anchors like Order Halls, without tying them to rigid classes, and they naturally plug into your existing Faction + Contract + Trial ecosystem.
