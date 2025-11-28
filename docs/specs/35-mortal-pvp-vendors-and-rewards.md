# Project Canvas: Mortal Warcraft Overhaul
### Version 27.1 — Hybrid Technical Design Document  
### File: 35-mortal-pvp-vendors-and-rewards.md  
### Section: PvP Gear Vendors, Currencies, Achievements & Titles (P1–P6)

---

## 1. Purpose

This spec wires together:

- **Mortal Arena & Rating System** (`34-mortal-arena-and-rating.md`)
- **PvP gear tiers** (P1–P6)
- **Currencies** (Military Credits, PvP Tokens, Warfront rewards)

and defines:

1. How PvP vendors are structured.
2. How items are **gated** by rating / bands / achievements.
3. A first-pass plan for **PvP achievements & titles**.

This is focused on PvP; a global, game-wide Achievement/Title spec can extend this later.

---

## Related Specs

For full context on PvP vendors and rewards, see:

- **`34-mortal-arena-and-rating.md`** — Arena rating system that gates vendor access
- **`11-pvp-systems.md`** — Core PvP systems that generate rewards and currencies
- **`19-itemization.md`** — Itemization philosophy and tier structure for PvP gear
- **`75-mortal-gear-and-runes-spec.md`** — Gear and rune systems for PvP items
- **`36-mortal-achievements-and-titles-core.md`** — Achievement and title system for PvP rewards
- **`04-economy.md`** — Economy system for PvP currencies and vendor transactions
- **`92-mortal-warfronts-siege-flow.md`** — Warfront systems that provide PvP rewards

---

## 2. Currencies & Inputs (Recap / Alignment)

From previous specs:

- **Military Credits**  
  - Honor replacement; earned from:
    - Battlegrounds,
    - Arenas (weekly),
    - Warfront participation,
    - Some PvP world activities.
  - Used mainly for:
    - Siege tech (Honor Overhaul),
    - Some general PvP purchases.

- **PvP Tokens** (Arena/Warfront Tokens)  
  - Weekly arena payout (from rating bands).
  - Warfront victory/participation rewards.
  - Core currency for P1–P6 gear.

Optional, later:

- **Warfront Commendations**  
  - Specific to Warfront queues / victories.
  - Used for stronghold-focused or cosmetic PvP rewards.

For now we assume:

- PvP **armor/weapons** = PvP Tokens (+ modest Military Credit costs).
- Warfront-only siege/stronghold items = Military Credits + optional Warfront Commendations.

---

## 3. Vendor Layout (World & Faction Fantasy)

### 3.1 PvP Hall Locations

Each faction has a **PvP Hall** (or War Room) in their primary capital:

- Alliance:  
  - Stormwind – “Hall of Champions” / Mortalified war room.
- Horde:  
  - Orgrimmar – “Hall of Blood”.

Optional later: neutral underground PvP den in a **red-zone city**.

### 3.2 Vendor Roles

We define PvP vendors by **tier band** and role rather than one giant vendor.

**Suggested vendor types:**

1. **Entry Combatant** – P1 / starter sets
   - Sells:
     - Basic PvP blues (P1).
     - Cheap, low-rating-required set to get people started.

2. **Challenger / Duelist Vendors** – P2–P4
   - Sells:
     - P2/P3/P4 sets & weapons.
   - Requires:
     - Rating bands per piece (e.g. P2 gear requires 1500+, P3 gear 1700+, etc.).
   - May require:
     - Certain **season achievement** (see §7).

3. **Elite / Gladiator Vendor** – P5–P6
   - Sells:
     - Highest-tier PvP gear (P5–P6).
     - High-prestige cosmetics (tabards, mounts, toys).
   - Requires:
     - High rating (e.g. 2100+ / 2300+ in 3v3).
     - Season achievement flags.

4. **Warfront Quartermaster**
   - Sells:
     - Warfront-flavored gear,
     - Siege blueprints for guild strongholds,
     - Cosmetic war banners, tabards, etc.
   - Requires:
     - Warfront Commendations,
     - Possibly Warfront victory achievements.

---

## 4. Data-Driven Gating: Item Requirements

We want item gating to be **data-driven**, not hardcoded in vendor scripts.

### 4.1 Table: mortal_pvp_item_requirements

```sql
CREATE TABLE IF NOT EXISTS mortal_pvp_item_requirements (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  item_entry          INT NOT NULL,      -- item_template.entry (PvP piece)
  rating_band_code    VARCHAR(16) NULL,  -- 'P1'..'P6' (optional)
  min_rating          INT NULL,          -- absolute rating floor (e.g. 1800)
  bracket_mask        TINYINT NOT NULL DEFAULT 7,  -- 1=2s,2=3s,4=5s; 7=any
  min_season_id       INT NULL,          -- optional: season-specific pieces
  require_achievement INT NULL,          -- achievement id (if any)
  cost_tokens         INT NOT NULL DEFAULT 0,  -- PvP Tokens
  cost_credits        INT NOT NULL DEFAULT 0,  -- Military Credits
  cost_commendations  INT NOT NULL DEFAULT 0,  -- Warfront Commendations
  notes               VARCHAR(255) NULL,
  UNIQUE KEY uk_item (item_entry)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Interpretation:

- A piece might have:
  - `rating_band_code = 'P3'`, `min_rating = 1700`, `bracket_mask = 2` (3v3 only).
  - `cost_tokens = 1200`, `cost_credits = 400`.

Gossip/vendor scripts then:

1. Look up `mortal_pvp_item_requirements` for each item.
2. Check if the player:
   - Has enough rating **and** rating band.
   - Meets bracket restriction (e.g. 3v3 rating).
   - Has required achievement (if set).
   - Has enough currency.
3. Show:
   - Item as available, or:
   - Greyed out with explanation (via MortalUI).

### 4.2 Currency Hooks

Currencies are likely stored in:

- A `mortal_currencies` or similar per-character table:

```sql
CREATE TABLE IF NOT EXISTS mortal_currencies (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  guid          INT NOT NULL,      -- characters.guid
  currency_code VARCHAR(32) NOT NULL,  -- 'PVP_TOKEN','MILITARY_CREDIT','WARFRONT_COMM'
  amount        INT NOT NULL DEFAULT 0,
  UNIQUE KEY uk_guid_currency (guid, currency_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

The vendor script just checks/updates this table.

---

## 5. Vendor Implementation Pattern

### 5.1 C++ / Script Flow

For each PvP vendor NPC:

1. On `OnGossipHello`:
   - Show a simple menu:
     - “Browse PvP Gear”
     - “Browse Cosmetics”
     - “Learn about PvP ratings”
   - Optionally show player’s:
     - Current best rating,
     - Current PvP Tokens & Military Credits.

2. On “Browse PvP Gear”:
   - Call a helper:
     - `BuildMortalPvpVendorList(player, npc)`:
       - Query all items assigned to this vendor (via `npc_vendor` table).
       - For each item:
         - Look up `mortal_pvp_item_requirements`.
         - Determine `availability_state` + reason.

3. The vendor window:
   - Items that **fail requirements**:
     - Marked as “Unavailable” (grey, cannot buy).
   - MortalUI addon:
     - Enhances tooltip:
       - Shows:  
         - Required rating / band.  
         - Rating the player currently has.  
         - Required achievement, if any.

### 5.2 UI Hooks (MortalUI)

In the MortalUI addon:

- Hook:
  - Vendor item tooltips.
- For each vendor item:
  - Request from server (via custom opcode or gossip string):
    - Requirement summary (precomputed).
  - Show lines like:
    - `Requires: Rating 1700+ in 3v3 (You: 1624)`
    - `Requires: Achievement: "Duelist of Season 1"`
    - `Cost: 1200 PvP Tokens, 400 Military Credits`

This avoids the player guessing “why is this red”.

---

## 6. Achievements & Titles (PvP-Focused Pass)

AzerothCore already supports **Achievements & Titles** (Wrath-era). We piggyback on that:

### 6.1 Approach

- Add **Mortal-specific achievements** in a high ID range.
- Hook them into:
  - Arena ratings,
  - Warfront victories,
  - Seasonal accomplishments.
- Use existing achievement reward plumbing to:
  - Award **titles** and **cosmetic items**.

### 6.2 PvP Achievement Categories

We define a few key groups:

1. **Arena Rating Achievements**
   - For each season, per bracket:
     - Hit rating 1500, 1700, 1900, 2100, 2300 in **3v3** (primary).
     - Smaller set for 2v2 (e.g. up to 1900).

2. **Season Standing Achievements**
   - End-of-season ranking:
     - Top X% in 3v3.
     - Top Y teams per region.
   - Used for:
     - Highest prestige titles (Gladiator-like).

3. **Warfront Achievements**
   - X victories in Warfront A/B.
   - Winning with specific stronghold contributions.
   - Holding control for N windows.

4. **BG / Participation Achievements**
   - Basic completion / participation achievements for classic BGs.

### 6.3 Titles Examples (PvP)

Examples (placeholder names you can change later):

- **“Mortal Combatant”** – 1500+ in any bracket.
- **“Duelist of the Ether”** – 1800+ in 3v3.
- **“Warlord of the Red Sea”** – High standing in a Warfront-heavy season.
- **“Gladiator of the Shroud”** – Top X% / top Y teams 3v3.

Most titles would be:

- Tied to achievements that:
  - Check season rating + final standings.
  - Are rewarded on season end by a script.

### 6.4 Integration with Vendors

The `require_achievement` column in `mortal_pvp_item_requirements` lets you do things like:

- P5/P6 cosmetic-only items:
  - Require:
    - `require_achievement = <GladiatorAchievementId>`
- Elite transmogs or tabards:
  - Only buyable if player:
    - Currently has those achievements / titles.

This gives lasting prestige beyond the raw stat gear.

---

## 7. Minimal Achievement/Title DB Notes

Exact schema depends on AzerothCore’s achievement implementation, but conceptually:

- Add Mortal achievements in:
  - `achievement_dbc` / `achievement_reward` tables (or their AC equivalents).
- Use:
  - A seasonal script that:
    - At end of season:
      - Evaluates team rankings.
      - Grants achievements and therefore titles/items.

We do **not** rewrite the entire Achievement system here; we just:

- Reserve a high ID range for Mortal PvP achievements.
- Define their usage pattern (rating thresholds, seasonal rankings, Warfront milestones).

A future global spec can extend this to:

- PvE raids (e.g., first Mortal ICC clears).
- Economy (e.g., first player to found a Stronghold in zone X).
- Exploration (e.g., mapping the Lost Lands).

---

## 8. Status

This spec defines:

- How **PvP vendors** are structured and gated (rating bands, achievements, currencies).
- A data-driven table (`mortal_pvp_item_requirements`) that Cursor can use for scripting.
- Preliminary **PvP achievements & titles**:
  - Arena rating-based,
  - Seasonal standing-based,
  - Warfront-based.
- How titles & achievements can also gate **high-prestige cosmetics** in PvP vendors.

You now have a clear target for:

- Implementing vendors & UI in C++/Lua + MortalUI.
- Designing first-season achievements/titles without clashing with base WotLK content.
