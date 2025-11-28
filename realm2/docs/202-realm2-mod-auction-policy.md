# Realm 2 – Legacy Journey
## Module Spec: `mod_auction_policy_legacy`

**Realm:** Mortal Warcraft: Legacy Journey (expansion-progressive, Classic+ style)  
**Core:** AzerothCore 3.3.5a  
**Goal:** Enforce a **player-friendly** Auction House policy that:
- Prevents bot/spam abuse.
- Keeps the AH readable and performant.
- Still lets regular farmers comfortably sell mats and crafted goods.

This is a softer, more “retail-like” policy than Realm 1’s.

---

## 1. Design Overview

### 1.1 Philosophy

- The Auction House is a **primary economy tool** on this realm.
- Limits should:
  - Be mostly invisible to normal players.
  - Only squeeze extreme spam/automation.
- Focus on:
  - Reasonable per-character caps.
  - Smart commodity stack rules.
  - Soft daily scaling instead of hard walls.

### 1.2 High-Level Rules

- **Per-character auction cap:** 100 active auctions.
- **Per-account cap:** 200 active auctions (across all characters on the realm).
- **Commodity stack rules (for mats):**
  - Allowed stack sizes: **5, 10, 20**.
  - Up to **10 single stacks per item** per character.
- **Soft daily limits:**
  - After N posts/cancels per day, **deposit/cancel fees scale up** instead of hard blocking.
- Works alongside existing AHBot (if used) and basic worldconfig rates.

---

## 2. Data & Config

### 2.1 Config File: `mod_auction_policy_legacy.conf`

Example keys:

```ini
[LegacyAuctionPolicy]
Enable = 1

# Caps
MaxAuctionsPerCharacter = 100
MaxAuctionsPerAccount   = 200

# Commodity behavior
CommodityMinStack       = 5
CommodityAllowedStacks  = 5,10,20
MaxSingleStacksPerItem  = 10

# Daily soft limits
DailyBasePostLimit      = 60    # After this, deposits scale up
DailyBaseCancelLimit    = 40    # After this, cancel fees scale up

PostDepositScaleStep    = 1.25  # Each 20 posts above base multiplies by 1.25
CancelFeeScaleStep      = 1.5   # Each 20 cancels above base multiplies by 1.5

# Maximum total daily posts/cancels (safety upper bound)
MaxDailyPosts           = 200
MaxDailyCancels         = 150

# Logging
LogPolicyViolations     = 1
```

### 2.2 DB Table: `legacy_auction_usage`

Same shape as Realm 1 but separate, for clarity:

```sql
CREATE TABLE IF NOT EXISTS legacy_auction_usage (
    guid INT UNSIGNED NOT NULL PRIMARY KEY,
    last_reset_date DATE NOT NULL,
    auctions_posted INT UNSIGNED NOT NULL DEFAULT 0,
    auctions_cancelled INT UNSIGNED NOT NULL DEFAULT 0
);
```

### 2.3 DB Table: `legacy_commodity_items`

```sql
CREATE TABLE IF NOT EXISTS legacy_commodity_items (
    entry INT UNSIGNED NOT NULL PRIMARY KEY,
    comment VARCHAR(100) DEFAULT ''
);
```

Populate with:
- Standard raw mats (herbs, ore, cloth, leather, dust/essences, fish, generic trade goods).
- Keep the list **slightly broader** than Realm 1 to cover more common mats.

---

## 3. Hooks & Behavior

### 3.1 Auction Creation Hook

On attempting to post an auction:

1. **Check caps:**
   - Count active auctions by `guid` (character).
     - If `>= MaxAuctionsPerCharacter` → reject with friendly message:
       - “You have reached the maximum number of active auctions on this character.”
   - Optionally count per-account (`MaxAuctionsPerAccount`).

2. **Commodity stack rules:**
   - If `item.entry` in `legacy_commodity_items`:
     - If stack size not in `CommodityAllowedStacks` AND not `1`:
       - Reject: “This item must be posted in stacks of 5, 10, or 20 on this realm.”
     - If stack size == 1:
       - Count existing single-stack auctions of this item for this character.
       - If `>= MaxSingleStacksPerItem` → reject:
         - “You already have the maximum number of single-stack auctions for this item.”

3. **Update `legacy_auction_usage`:**
   - Lazy-reset on date change.
   - Increment `auctions_posted`.

4. **Compute deposit multiplier:**
   - `extra_posts = max(0, auctions_posted - DailyBasePostLimit)`
   - `post_blocks = extra_posts // 20`
   - `deposit_multiplier = PostDepositScaleStep ** post_blocks`
   - Final deposit = base_deposit × `deposit_multiplier`.

5. **Daily hard ceiling:**
   - If `auctions_posted >= MaxDailyPosts`:
     - Reject further postings for the day with a clear message.

### 3.2 Auction Cancel Hook

On cancel:

1. Load/update `legacy_auction_usage`.
2. Increment `auctions_cancelled`.
3. `extra_cancels = max(0, auctions_cancelled - DailyBaseCancelLimit)`
4. `cancel_blocks = extra_cancels // 20`
5. `fee_multiplier = CancelFeeScaleStep ** cancel_blocks`
6. Apply an extra gold fee (or increased deposit non-refund) based on `fee_multiplier`.
7. If `auctions_cancelled >= MaxDailyCancels`:
   - Optionally block further cancels for the day or keep scaling fees steep.

### 3.3 Daily Reset

Same pattern as Realm 1:

- On first interaction that day, if `last_reset_date < TODAY`:
  - Reset counters to 0,
  - Set `last_reset_date = TODAY`.

No additional scheduler required.

---

## 4. Interaction with WorldConfig & AHBot

### 4.1 WorldConfig

Keep global settings player-friendly:

- `Rate.Auction.Time` = 1.0 (or slightly reduced to keep tables clean).
- `Rate.Auction.Deposit` = 1.0 (module handles scaling beyond base).
- `Rate.Auction.Cut` = 1.0–1.2 (mild gold sink, not punishing).

### 4.2 AHBot (Optional)

- Configure AHBot to:
  - Maintain baseline stock for common mats and some gear.
  - Use **sensible stack sizes** (5/10/20) to match player rules.
- The module does **not** touch bot postings; it only governs player auctions.

---

## 5. Player Experience & Communication

To avoid “why can’t I post this?” confusion:

- AH NPC gossip or help text explaining:
  - Per-character auction caps.
  - Preferred stack sizes for mats.
  - That heavy AH usage increases deposit/cancel costs.
- Website/wiki section:
  - “Auction House Rules” with examples:
    - “If you farm 200 ore, it’s best to post 10×20 or 20×10 stacks.”
    - “You can still post some single stacks for niche buyers, but spamming 100 singles is discouraged.”

This ensures:
- Casual players rarely hit limits.
- Dedicated traders understand the system and can work within it.

---

## 6. Implementation Notes

- Place module in `src/server/scripts/Custom/mod_auction_policy_legacy`.
- Use separate config and tables from Realm 1 to avoid cross-realm confusion.
- Keep all texts configurable so you can localize or adjust voice later.

---

## 7. Summary

`mod_auction_policy_legacy` gives you:

- A **clean, performant AH** that doesn’t get spammed to death.
- Enough freedom that **gatherers and crafters can still play “auction goblin”**.
- A clear distinction between:
  - Realm 1’s harsh, logistics-first approach.
  - Realm 2’s gentle, Classic+ comfort-first approach.
