# Project Canvas: Mortal Warcraft Overhaul
### Version 36.0 — Hybrid Technical Design Document  
### File: 57-appearance-codex-and-transmog.md  
### Section: Appearance Codex & Transmog Rules

---

## 1. Purpose

Introduce a **modern, collection-style appearance system** inspired by post-3.3.5 WoW transmog, tuned for Mortal Warcraft’s:

- **Full-loot, high-risk sandbox**,
- **Custom Mortal gear tiers** and re-skinned WotLK appearances,
- **Economy-first** design.

Goals:

- Give players a **long-term cosmetic chase** with strong fantasy identity.
- Preserve the importance of **physical gear** and loot risk.
- Integrate with:
  - Mortal gear progression,
  - Factions, Seasons, Endless Contracts,
  - Black Market & Strongholds,
  - Atlas (web) and MortalUI (in-game).

---

## Related Specs

For full context on appearance and transmog systems, see:

- **`15-ui-client.md`** — UI system that displays appearance codex and transmog panels
- **`24-webportal-mortal-atlas.md`** — Atlas web portal that displays appearance collections
- **`75-mortal-gear-and-runes-spec.md`** — Gear system that appearances are based on
- **`19-itemization.md`** — Itemization tiers that determine appearance unlocks
- **`51-factions-and-standing-system.md`** — Faction system that provides faction-themed appearances
- **`52-season-of-the-frontier.md`** — Seasonal system that provides seasonal appearance rewards
- **`03-risk-zones.md`** — Risk zones that may restrict transmog for PvP readability

---

## 2. Core Principles

1. **Appearance ≠ Item**  
   - Physical items still matter for:
     - Stats, durability, runes, augments, trade.
   - Appearance unlocks are purely **cosmetic skins**.

2. **Unlock by Ownership & Use**  
   - You unlock an appearance by:
     - Equipping and binding a Mortal gear item,
     - Or deliberately “Imprinting”/“Salvaging” it at a Transmog NPC.

3. **Loot Risk Remains**  
   - Losing an item in full-loot:
     - You lose the item (stats, sockets, legacy) but **keep the appearance unlock**.
   - This keeps risk high but prevents permanent fashion loss.

4. **Recognition & Readability**  
   - In **Red Zones**, readability matters for PvP.
   - We preserve options to:
     - Restrict extreme or deceptive transmogs in Red Zones,
     - Force basic silhouette clarity (no disguises).

---

## 3. System Overview

### 3.1 Appearance Codex (Collection)

Each character (or account, configurable later) has:

- An **Appearance Codex** listing:
  - All unlocked armor sets / individual pieces,
  - All unlocked weapon appearances,
  - Mount & pet skins (if applicable later).

Categorization:

- By item slot (head, chest, weapon, etc.),
- By source (dungeon, raid, faction, event, season),
- By Mortal tier (T1, T2, etc.).

### 3.2 Transmog Application

Players can:

- Visit **Transmog NPCs** (e.g., in capitals, Strongholds).
- Use a **MortalUI appearance panel** to:
  - Choose per-slot appearance from unlocked skins,
  - Save “Fashion Presets” separate from Build Presets.

Transmog rules (baseline):

- No transmog into:
  - Invisible gear (unless explicitly cosmetic),
  - Non-gear appearances (e.g., turning into a crate).
- Optional: Limit extreme “visual deception” in Red Zones.

Costs:

- Gold + optional **Appearance Tokens** (sink for economy).
- Higher-tier appearances cost more.

---

## 4. Data Model (MySQL)

### 4.1 Appearance Definitions

We define a table mapping item templates to “appearance codes” and metadata.

```sql
CREATE TABLE IF NOT EXISTS mortal_appearances (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL UNIQUE,   -- 'APP_MORTAL_T1_SWORD_01'
  name            VARCHAR(128) NOT NULL,
  description     TEXT NULL,
  item_entry      INT NOT NULL,                  -- base item_template.entry providing this look
  slot_id         TINYINT NOT NULL,              -- equipment slot
  category        VARCHAR(32) NOT NULL,          -- 'ARMOR','WEAPON','MOUNT','PET'
  source_type     VARCHAR(32) NOT NULL,          -- 'DUNGEON','RAID','FACTION','EVENT','SEASON','CRAFTED'
  source_tag      VARCHAR(64) NULL,              -- e.g. 'ICC_10N', 'IRON_LEDGER'
  rarity          VARCHAR(16) NOT NULL DEFAULT 'COMMON',  -- cosmetic rarity
  flags           INT NOT NULL DEFAULT 0,
  is_active       TINYINT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.2 Character Appearance Unlocks

```sql
CREATE TABLE IF NOT EXISTS mortal_appearance_unlocks (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,                  -- character guid
  appearance_id   INT NOT NULL,
  unlocked_ts     INT NOT NULL,
  unlock_source   VARCHAR(32) NOT NULL,          -- 'EQUIP','SALVAGE','REWARD','PURCHASE'
  UNIQUE KEY uniq_guid_appearance (guid, appearance_id),
  CONSTRAINT fk_mortal_appearance_unlocks_app
    FOREIGN KEY (appearance_id) REFERENCES mortal_appearances(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.3 Active Transmog State

```sql
CREATE TABLE IF NOT EXISTS mortal_transmog_state (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guid            INT NOT NULL,                  -- character guid
  slot_id         TINYINT NOT NULL,              -- equipment slot
  appearance_id   INT NULL,                      -- NULL = no transmog
  last_update_ts  INT NOT NULL,
  UNIQUE KEY uniq_guid_slot (guid, slot_id),
  CONSTRAINT fk_mortal_transmog_state_app
    FOREIGN KEY (appearance_id) REFERENCES mortal_appearances(id)
    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

## 5. Unlock Rules

### 5.1 Automatic Unlock: Equip & Bind

When a player:

- Equips an item tagged as a Mortal gear variant **and**
- Binds it (soulbound or via use),

Then:

- If associated `mortal_appearances` row exists, grant unlock in `mortal_appearance_unlocks`.

Optional: For non-Mortal baseline WotLK items:

- Either:
  - Map them to the same appearances (if allowed),
  - Or only Mortal variants unlock Codex entries to keep the chase more focused.

### 5.2 Imprinting / Salvage Unlock

At a **Transmog Imprinter NPC**:

- Player can:
  - “Sacrifice” an item for guaranteed appearance unlock.
  - The item is **destroyed**.
- Use case:
  - Found a cool drop you can’t currently equip,
  - Want to bank its look for later.

Optional cost:

- Gold and/or special reagent to prevent trivial mass-farming.

### 5.3 Reward & Purchase Unlocks

Appearances can also be unlocked via:

- Faction vendors (e.g., faction-specific armor/mount styles),
- Seasonal rewards,
- Endless Contracts,
- Black Market events.

These:

- Directly insert a row into `mortal_appearance_unlocks`.

---

## 6. Rules by Zone & Risk

### 6.1 Green & Yellow Zones

- Full transmog flexibility:
  - Any unlocked appearance can be used, subject to base armor type consistency if desired (cloth→cloth, etc.).
- Great place for:
  - RP, fashion events, social hubs.

### 6.2 Red Zones

To keep **combat readability**:

- Option A (strict):
  - Limit transmog to:
    - Same armor class & silhouette category.
    - No “costume”-type appearances.
- Option B (medium):
  - Allow all appearances, but:
    - Maintain clear nameplates and title overlays,
    - Prevent true disguises (no turning into NPC uniforms, etc.).
- Option C (hybrid):
  - Special “Battle-Ready” transmog sets that are visually distinct but less confusing.

Recommended v1:

- Enforce same armor class + weapon family (sword looks like sword, not staff),
- Forbid a small set of ultra-confusing appearances in Red zones via `flags`.

---

## 7. Economy & Collection Hooks

### 7.1 Appearance Tokens & Fees

- Transmog application consumes:
  - Gold fee,
  - Optional **Appearance Token**:
    - Crafted via Salvage system,
    - Or earned via Factions / Seasons.
- This creates a:
  - Gold + material sink,
  - Predictable demand for certain Salvage outputs.

### 7.2 Collection Achievements & Titles

- Titles for collection progress:
  - Unlock X appearances from a certain source:
    - “Archivist of Iron” (Ledger styles),
    - “Vanity of the Cartel” (Cartel glam).
- Seasonal cosmetic chase:
  - Appearances that are **first introduced** via season, but:
    - Later appear as ultra-rare drops or faction rewards to avoid true FOMO.

---

## 8. UI & UX (MortalUI + Atlas)

### 8.1 In-Game (MortalUI)

- **Appearance Tab**:
  - Per-slot filters,
  - Preview pane with rotation/zoom,
  - Visual tags:
    - Source icon (dungeon, faction, season),
    - Locked / unlocked state.
- **Apply Flow**:
  - Select slot → choose appearance → show cost → confirm.
  - Clear button to revert to base look.

### 8.2 Atlas Integration

- Web **Appearance Codex**:
  - View unlocked appearances (if authenticated),
  - Browse full catalog with “how to obtain” hints.
- Social features (later):
  - Showcase favorite outfits on character profile.
  - Possibly link build presets to fashion presets (“Red Zone Raider look”).

---

## 8.3 Heirloom Integration & mod-transmog Module

### 8.3.1 Heirloom Conversion to Appearance Unlocks

Original WoW 3.3.5a **Heirloom items** are converted to **Transmog Appearance Unlocks** rather than removed, leveraging the existing `mod-transmog` module.

**Conversion Strategy:**
- Heirloom items unlock appearances in Appearance Codex
- Remove all stat bonuses (maintains classless progression)
- Preserve visual appearance for transmog
- Convert to cosmetic-only items

**Integration with mod-transmog:**
- Use `mod-transmog` as base transmog system
- Heirlooms unlock appearances in `mortal_appearances`
- Heirlooms can be used as transmog sources
- Appearance Tokens create economy sink

**Heirloom Distribution:**
- Starter heirlooms for new players
- Faction-themed heirlooms
- Seasonal heirloom rewards
- Crafted heirloom items

**See**: `19-itemization.md` section 3.7 for detailed heirloom conversion strategy

### 8.3.2 mod-transmog Module Integration

**Module Features Used:**
- **Collection System**: `UseCollectionSystem = 1` (Legion-style appearance collection)
- **Heirloom Support**: `AllowHeirloom = 1` (already enabled)
- **Token Cost**: Can require Appearance Tokens
- **Preset System**: Save transmog sets
- **Ignore Requirements**: `IgnoreReqClass = 1` (classless system)

**Configuration:**
```ini
Transmogrification.UseCollectionSystem = 1
Transmogrification.AllowHeirloom = 1
Transmogrification.IgnoreReqClass = 1
Transmogrification.IgnoreReqLevel = 1
Transmogrification.AllowMixedArmorTypes = 1
Transmogrification.RequireToken = 1
Transmogrification.TokenEntry = [Appearance Token Item ID]
```

**Integration Points:**
- `mod-transmog` handles visual transmog application
- Mortal's Appearance Codex tracks unlocks
- Mortal's Appearance Codex provides collection UI
- Mortal-specific features (faction unlocks, seasonal rewards)

---

## 9. Implementation Checklist

1. **DB**
   - Create `mortal_appearances`, `mortal_appearance_unlocks`, `mortal_transmog_state`.
   - Seed appearances for:
     - Mortal T1/T2 gear sets,
     - **Heirloom appearances** (converted from original heirlooms),
     - Select iconic WotLK models to start.

2. **Server**
   - Hook:
     - On item bind → auto-unlock appearance (if applicable).
     - NPC Imprinting → destroy item & unlock appearance.
   - Apply transmog at:
     - Login,
     - Gear change,
     - Transmog change.

3. **UI**
   - MortalUI Appearance panel.
   - Simple Transmog NPC gossip to open the panel.

4. **Integration**
   - Factions, Seasons, Endless:
     - Add appearance unlocks to their reward tables.
   - Atlas:
     - Add endpoints:
       - `GET /api/appearance/catalog`
       - `GET /api/appearance/unlocks`.

5. **Balancing**
   - Decide per-zone ruleset for Red Zones.
   - Tune gold/token costs.

---

This system gives you a WoW-retail-grade fashion meta while keeping Mortal Warcraft’s harsh loot rules and economy intact, making “looking cool” a persistent pursuit without undermining gear risk.
