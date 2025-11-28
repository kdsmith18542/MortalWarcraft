# Realm 1 – Mortal Warcraft
## Module Spec: `mod_auction_policy_mortal`

**Realm:** Mortal Warcraft (Sandbox, risk-zoned, regional economy)  
**Core:** AzerothCore 3.3.5a  
**Goal:** Enforce a *harsh but readable* Auction House policy that:
- Prevents spam / bot flooding.
- Keeps the AH as a **secondary** economy tool (primary = stalls, direct trade, contracts, smuggling).
- Protects performance and keeps listings manageable.

This module complements:
- Regional banks & markets.
- Player stalls / Stronghold markets.
- Courier / contract systems.

---

## 1. Design Overview

### 1.1 Philosophy

- AH is **not** the main economic engine; it’s a convenience layer.
- Strict but fair limits are acceptable because:
  - Mortal emphasizes **risk, logistics, and face-to-face trading**.
  - Players have **alternative ways** to sell (stalls, contracts, guild markets).
- Focus on:
  - Anti-spam.
  - Anti-bot.
  - Preserving readability.

### 1.2 High-Level Rules

- **Per-character auction cap:** ~30–40 auctions.
- **Per-account cap:** Optional, e.g. 80 total across all characters on the realm.
- **Commodity stack rules (harsh):**
  - Allowed stack sizes for flagged commodities: **10, 20** (no 1–5 spam).
  - Very limited number of 1-stack auctions per item (e.g. max 3).
- **Deposit & cancel scaling:** Aggressive ramp for heavy users.
- **Integration with regional markets:** Neutral/faction AH may be physically relocated to regional trade hubs.

---

## 2. Data & Config

### 2.1 Config File: `mod_auction_policy_mortal.conf`

Example keys:

```ini
[MortalAuctionPolicy]
Enable = 1

# Caps
MaxAuctionsPerCharacter = 40
MaxAuctionsPerAccount   = 80

# Commodity behavior
CommodityMinStack       = 10
CommodityAllowedStacks  = 10,20
MaxSingleStacksPerItem  = 3

# Daily soft limits
DailyBasePostLimit      = 40    # After this, deposits scale up
DailyBaseCancelLimit    = 20    # After this, cancel fees scale up

PostDepositScaleStep    = 1.5   # Each 10 posts above base multiplies by 1.5
CancelFeeScaleStep      = 2.0   # Each 10 cancels above base multiplies by 2.0

# Logging
LogPolicyViolations     = 1
```

### 2.2 DB Table: `mortal_auction_usage`

Tracks per-character daily usage for scaling:

```sql
CREATE TABLE IF NOT EXISTS mortal_auction_usage (
    guid INT UNSIGNED NOT NULL PRIMARY KEY,
    last_reset_date DATE NOT NULL,
    auctions_posted INT UNSIGNED NOT NULL DEFAULT 0,
    auctions_cancelled INT UNSIGNED NOT NULL DEFAULT 0
);
```

### 2.3 DB Table: `mortal_commodity_items`

Used to mark commodities subject to stack rules:

```sql
CREATE TABLE IF NOT EXISTS mortal_commodity_items (
    entry INT UNSIGNED NOT NULL PRIMARY KEY,
    comment VARCHAR(100) DEFAULT ''
);
```

Populate with:
- Raw mats (ore, bars, herbs, cloth, leather, dust, essences, fish, generic trade goods).
- Optionally: food, potions, flasks.

---

## 3. Hooks & Behavior

### 3.1 Auction Creation Hook

Hook in `AuctionHouseMgr` / AH gossip handler:

**On player posting auction:**

1. **Check caps:**
   - Count active auctions for `guid` from `auctionhouse` table.
   - If `>= MaxAuctionsPerCharacter` → reject with system message.
   - Optionally: count across account → enforce `MaxAuctionsPerAccount`.

2. **Check commodity stack rules:**
   - If `item.entry` is in `mortal_commodity_items`:
     - Enforce `CommodityAllowedStacks`.
     - If stack size == 1:
       - Count existing 1-stack auctions of this `entry` by this `guid`.
       - If `>= MaxSingleStacksPerItem` → reject.

3. **Update `mortal_auction_usage`:**
   - If `last_reset_date < TODAY`, reset counters.
   - Increment `auctions_posted`.

4. **Compute deposit multiplier:**
   - Compute `extra_posts = max(0, auctions_posted - DailyBasePostLimit)`.
   - `post_block = extra_posts // 10` (integer division).
   - `deposit_multiplier = PostDepositScaleStep ** post_block`.
   - Final deposit = base_deposit × deposit_multiplier.

5. **If any rejection occurs:**
   - Send custom error text, e.g.:
     - “You have reached the auction cap for this character.”
     - “Commodity stacks must be 10 or 20 on this realm.”
   - Optionally log if `LogPolicyViolations = 1`.

### 3.2 Auction Cancel Hook

**On cancel:**

1. Load/update `mortal_auction_usage`.
2. Increment `auctions_cancelled`.
3. Compute extra cancels and apply optional penalty:
   - e.g. charge an additional flat gold fee once above `DailyBaseCancelLimit`.
4. Optionally deny cancels beyond a hard upper limit (`MaxDailyCancels` if configured).

### 3.3 Daily Reset

On first access per day (or in a scheduled server task):

- If `last_reset_date < TODAY`:
  - Set `auctions_posted = 0`,
  - `auctions_cancelled = 0`,
  - `last_reset_date = TODAY`.

No need for a manual cron; lazy reset on use is fine.

---

## 4. Integration with Mortal Economy

### 4.1 Regional Banks & Markets

- Combine `mod_auction_policy_mortal` with:
  - Cross-faction AH OFF (or limited).
  - Regional bank rules.
  - Player stalls / Stronghold vendors.

The AH then:
- Acts as a **local listing board** with friction.
- Encourages **courier contracts** and **face-to-face trade** for bulk deals.

### 4.2 Communication & UX

- Add clear text to:
  - AH NPC gossip: “This market is strictly regulated. Commodities must be posted in large stacks; small spam stacks are not allowed.”
  - New-player guides on the website/wiki.

- Optionally add:
  - Command `/ahstatus` to show:
    - Active auctions count,
    - Daily posts/cancels.

---

## 5. Non-Goals

- No per-item dynamic pricing or taxation (handled elsewhere if needed).
- No AHBot configuration here (that’s a separate module).
- No attempt to emulate retail AH behaviors; this is Mortal-specific, intentionally strict.

---

## 6. Implementation Notes

- Keep the module:
  - Self-contained (`src/server/scripts/Custom/mod_auction_policy_mortal`).
  - Controlled entirely by its `.conf` + the two tables.
- Use readable, configurable error messages to avoid confusing players.
