# Project Canvas: Mortal Warcraft Overhaul
### Version 27.2 — Hybrid Technical Design Document  
### File: 36-mortal-achievements-and-titles-core.md  
### Section: Global Achievements & Titles (PvE, PvP, Economy, Exploration, Social)

---

## 1. Purpose

Define a **global Achievement & Title framework** for Mortal Warcraft that:

- Reuses and extends AzerothCore’s **Wrath-era achievement system**.
- Integrates:
  - PvP (arenas, Warfronts, BGs) – building on `35-mortal-pvp-vendors-and-rewards.md`.
  - PvE dungeons & raids.
  - Economy & crafting.
  - Exploration & politics (Strongholds, Territories).
  - Hardcore / challenge feats.
- Provides a **single mental model** for:
  - Devs assigning achievements,
  - Players understanding long-term goals,
  - Vendors & systems gating cosmetics by prestige.

This is a **design/meta-spec**. Exact DBC/SQL details can be derived from this by Cursor.

---

## Related Specs

For full context on achievements and titles, see:

- **`35-mortal-pvp-vendors-and-rewards.md`** — PvP achievements and titles referenced throughout
- **`56-negative-titles-and-notoriety-labels.md`** — Negative titles system that integrates with achievements
- **`33-instance-and-battleground-tier-mapping.md`** — Instance and battleground tiers used for PvE achievements
- **`08-guilds-sovereignty.md`** — Stronghold achievements and territory control feats
- **`11-pvp-systems.md`** — PvP systems that generate achievement criteria
- **`06-pve.md`** — PvE content that provides achievement opportunities

---

## 2. Integration with Base WotLK Achievements

AzerothCore already supports:

- `achievement` + `achievement_reward` tables (Wrath-style).
- Title & item rewards from achievements.

We:

1. **Do not remove** base WotLK achievements.
2. **Do** add Mortal achievements in a **high ID range** to avoid collisions, e.g.:

- `MORTAL_ACH_ID_BASE = 500000` (example; confirm exact max in your DB later).
- All Mortal-specific achievements:
  - `id >= MORTAL_ACH_ID_BASE`.

We also:

- Tag Mortal achievements via:
  - Category (e.g. “Mortal – PvP”, “Mortal – Strongholds”).
  - Custom flags in notes/fields if needed.

---

## 3. Achievement Categories

We define top-level **Mortal categories** (overlay on top of existing ones):

1. **Mortal – PvP**
   - Arena ratings, Warfronts, BG milestones (see `35`).
2. **Mortal – Raids & Dungeons**
   - Mortal-tuned instance clears, challenges.
3. **Mortal – Economy & Crafting**
   - Wealth, trading, crafting mastery, market runs.
4. **Mortal – Exploration & Lore**
   - Discovering hidden zones, alpha mobs, Lost Lands.
5. **Mortal – Strongholds & Territory**
   - Claiming, defending, upgrading strongholds.
6. **Mortal – Hardcore & Survival**
   - Deathless runs, hardcore characters, survival milestones.
7. **Mortal – Social & Meta**
   - Community-driven feats (guild size, events), tavern games, etc.

Each category can map to a subcategory in the AC achievement tree for UI grouping.

---

## 4. PvE Achievements (Dungeons & Raids)

### 4.1 Baseline Progression Achievements

For each major **dungeon/raid tier** (see `33-instance-and-battleground-tier-mapping.md`):

- **Normal Clear** achievements:
  - “Conqueror of [Instance]” – defeat all bosses in Mortal-tuned version.
- **Hard/Challenge** achievements:
  - Time trials.
  - No-death runs inside instance.
  - Special mechanic constraints (e.g. “Don’t fall off in Lich King transition”).

Examples:

- **“Conqueror of the Deadmines (Mortal)”**
  - Requirements:
    - Defeat all bosses in Mortal Deadmines (M-T1) on any difficulty.
  - Reward:
    - Achievement points.
    - Potential small cosmetic (toy, tabard) in later patches.

- **“Champion of Icecrown (Normal)”**
  - Requirements:
    - Defeat Lich King in ICC Normal (Mortal tuned).
  - Reward:
    - Achievement only (title handled by heroic/Feats).

- **“Scion of the Frozen Throne”** (Heroic LK)
  - Requirements:
    - Defeat Lich King in ICC Heroic (M-T5).
  - Reward:
    - Title: `\Scion of the Frozen Throne`.
    - Optional mount or cosmetic (Locked behind Feat of Strength if season-limited).

### 4.2 Feats of Strength / One-Time Challenges

Certain achievements flagged as **Feats of Strength**:

- First guild to clear ICC Heroic on each realm.
- First guild to complete a Mortal Warfront raid variant.
- Realm-first stronghold claimed in a given contested zone.

These:

- Have no standard point value.
- Grant permanent prestige (titles, unique cosmetics).

---

## 5. Economy & Crafting Achievements

We incentivize the **regional economy** & deep crafting loop.

### 5.1 Trading / Wealth

Examples:

- **“Road Baron”**
  - Complete X courier contracts between distinct regions.
  - Reward: small gold, achievement.

- **“Tycoon of the North”**
  - Earn X total gold from selling through market stalls.
  - Reward: Title `\the Tycoon` or similar.

- **“Ledger of Legends”**
  - Maintain positive trade volume (buy low, sell high) across Y weeks.
  - Reward: cosmetic ledger toy.

### 5.2 Crafting Mastery

Examples tied to **Material Lore** and crafting:

- **“Master of Iron”**
  - Reach max Lore: Iron and craft N Masterwork Iron items.
- **“Artisan of the Ether”**
  - Craft a Masterwork item using the highest-tier materials (M-T5 range).
  - Reward: Title `\the Artisan`.

- **“Soul of the Forge”**
  - Be the first on the realm to craft a legendary-tier Mortal weapon (if you add such items).
  - Feat of Strength with a unique glow effect or vanity pet.

---

## 6. Exploration & Lore Achievements

The Mortal world has:

- Public dungeons, Lost Lands, reclaimed Beta maps, alpha variants.

Examples:

- **“Cartographer of the Lost Lands”**
  - Discover all subzones in:
    - Emerald Dream (Map 169),
    - Azshara Crater,
    - Development Land (451).
  - Reward: Title `\the Cartographer`.

- **“Hunter of Alphas”**
  - Defeat N different “Alpha” version mobs (your 5% alpha variants).
  - Reward: Pet, cosmetic weapon enchant, or title `\the Alpha-Slayer`.

- **“Delver of the Deep”**
  - Fully explore Y Public Dungeons (Deadmines/WC open variants, etc.).
  - Progress tracked via exploration flags or boss kills.

---

## 7. Strongholds & Territory Achievements

Tie into Stronghold Sovereignty & Guild Politics.

Examples:

- **“Founders of [StrongholdName]”**
  - Guild claims a specific key stronghold for the first time.
  - Grants guild achievement.
  - Reward: decorative banner, tabard variant.

- **“Defenders of the Banner”**
  - Successfully defend a stronghold against X siege attempts during a season.
  - Reward: Title for guild members: `\Defender of [StrongholdName]`.

- **“Lords of War”**
  - Hold control over N strongholds simultaneously for Y vulnerability cycles.
  - Prestige Feat; can be tied to powerful but cosmetic-only guild hall upgrades.

These are especially good for **guild-level achievements** if you choose to implement them.

---

## 8. Hardcore & Survival Achievements

Capitalize on Mortal’s high-risk design.

Examples:

- **“First Breath, Last Breath”**
  - Reach Mortal level 10 (skills threshold) on a Hardcore-flagged character with no deaths.
  - Reward: achievement, small cosmetic.

- **“Mortal Legend”**
  - Reach a certain skill threshold + complete a key raid boss (e.g., Heroic LK) without dying once on that character.
  - Could grant a Feat of Strength and a permanent aura toy.

- **“Naked Return”**
  - Die in a Red Zone, lose gear, and successfully reclaim your corpse chest under enemy pressure (tracked via killfeed/loot logs).
  - Achievement, maybe a small cosmetic or title `\the Undeterred`.

You can later hook these into the **Shrine System** (live respawns) for more nuanced conditions.

---

## 9. Social & Community Achievements

Social stickiness = retention.

Examples:

- **“Tavern Champion”**
  - Win X tavern mini-games (dice/cards) in different inns.
  - Reward: toy deck, title `\the Gambler`.

- **“Mortal Host”**
  - Organize Y guild events (tracked via a simple Guild Event system or GM-flag).
  - Reward: guild leader title, decorative guild hall item.

- **“Voice of the Realm”**
  - Highly active and positively rated player in world chat (if you implement a soft reputation system, this can be future work).

---

## 10. Titles: Naming & Policy

### 10.1 General Rules

- Titles should:
  - Be **readable** and thematic.
  - Not give power—only **prestige**.
  - Be rare enough in high tiers that they feel special.

- Use a **consistent naming style**:
  - `\the [Noun]`
  - `[Adjective] of [Place]`
  - `[Role] of the [Concept]`

Examples:

- PvP:
  - `\Mortal Combatant`, `\Duelist of the Ether`, `\Gladiator of the Shroud`.
- PvE:
  - `\the Riftwalker`, `\Scion of the Frozen Throne`.
- Economy:
  - `\the Tycoon`, `\Merchant of Storms`.
- Strongholds:
  - `\Warden of [StrongholdName]`, `\Lord of the Red Tower`.

### 10.2 Technical Mapping

Each title is provided via:

- An **achievement reward** that:
  - Grants the title (using AC’s title system).
- High-prestige titles:
  - Achievements flagged as **season-bound** or **Feat of Strength**.

---

## 11. Complete Achievement Implementation

This section provides comprehensive implementation details for the Mortal Warcraft achievement system.

### 11.1 Database Schema

**Achievement Tables:**
- `achievement` - Base achievement definitions (AzerothCore standard)
- `achievement_reward` - Achievement rewards (titles, items)
- `character_achievement` - Character achievement progress
- `character_achievement_progress` - Achievement criteria progress

**Mortal Achievement Extensions:**
- `mortal_achievement_categories` - Mortal-specific achievement categories
- `mortal_achievement_criteria` - Mortal-specific achievement criteria
- `mortal_achievement_rewards` - Mortal-specific achievement rewards

### 11.2 Achievement ID Ranges

**ID Range Allocation:**
- **Base WotLK Achievements:** 1-50000 (preserved)
- **Mortal Achievements:** 500000+ (custom range)
- **Mortal PvP Achievements:** 500000-509999
- **Mortal PvE Achievements:** 510000-519999
- **Mortal Economy Achievements:** 520000-529999
- **Mortal Exploration Achievements:** 530000-539999
- **Mortal Stronghold Achievements:** 540000-549999
- **Mortal Hardcore Achievements:** 550000-559999
- **Mortal Social Achievements:** 560000-569999

### 11.3 Achievement Criteria Types

**Standard Criteria (AzerothCore):**
- Kill creature
- Complete quest
- Complete dungeon
- Complete raid
- Win battleground
- Win arena

**Mortal-Specific Criteria:**
- Complete task/contract
- Complete courier contract
- Craft masterwork item
- Reach faction standing
- Claim stronghold
- Defend stronghold
- Complete extraction raid
- Purify cursed artifact
- Win warfront
- Complete seasonal challenge

### 11.4 Achievement Tracking

**Progress Tracking:**
- Track achievement progress in real-time
- Update progress on criteria completion
- Award achievement when all criteria met
- Grant rewards (titles, items, cosmetics)

**Progress Persistence:**
- Store progress in `character_achievement_progress`
- Persist across server restarts
- Track seasonal progress separately

### 11.5 Achievement Rewards

**Reward Types:**
- **Titles:** Achievement-based titles (e.g., "the Tycoon")
- **Items:** Cosmetic items, toys, tabards
- **Mounts:** Rare mount rewards (Feats of Strength)
- **Cosmetics:** Visual effects, auras, toys
- **Achievement Points:** Point values for leaderboards

**Reward Distribution:**
- Automatic reward on achievement completion
- Mail delivery for item rewards
- Title selection UI for title rewards
- Cosmetic unlock for cosmetic rewards

### 11.6 Achievement Categories

**Category Structure:**
- **Mortal – PvP:** Arena, Warfront, BG achievements
- **Mortal – PvE:** Dungeon, Raid, World Boss achievements
- **Mortal – Economy:** Trading, Crafting, Market achievements
- **Mortal – Exploration:** Zone, Lore, Discovery achievements
- **Mortal – Strongholds:** Territory, Siege, Guild achievements
- **Mortal – Hardcore:** Survival, Deathless, Challenge achievements
- **Mortal – Social:** Community, Tavern, Event achievements

### 11.7 Achievement UI

**Achievement Panel:**
- Display all achievements by category
- Show progress for in-progress achievements
- Highlight completed achievements
- Filter by category, completion status

**Achievement Details:**
- Show achievement description
- Show criteria requirements
- Show progress for each criterion
- Show rewards (titles, items, cosmetics)

**Achievement Notifications:**
- Notify on achievement completion
- Show reward notifications
- Display achievement progress updates

### 11.8 Achievement Examples

**PvP Achievement Example:**
- **Achievement ID:** 500001
- **Name:** "Mortal Combatant"
- **Category:** Mortal – PvP
- **Criteria:** Win 100 arena matches
- **Reward:** Title "the Mortal Combatant"
- **Points:** 10

**PvE Achievement Example:**
- **Achievement ID:** 510001
- **Name:** "Conqueror of Icecrown"
- **Category:** Mortal – PvE
- **Criteria:** Defeat Lich King in ICC (Mortal tuned)
- **Reward:** Title "Scion of the Frozen Throne"
- **Points:** 25

**Economy Achievement Example:**
- **Achievement ID:** 520001
- **Name:** "Road Baron"
- **Category:** Mortal – Economy
- **Criteria:** Complete 50 courier contracts
- **Reward:** Title "the Road Baron"
- **Points:** 15

**Stronghold Achievement Example:**
- **Achievement ID:** 540001
- **Name:** "Founders of [StrongholdName]"
- **Category:** Mortal – Strongholds
- **Criteria:** Claim stronghold for first time
- **Reward:** Guild banner, tabard variant
- **Points:** 20 (guild achievement)

### 11.9 Feats of Strength

**Feat of Strength Rules:**
- One-time achievements (cannot be repeated)
- No achievement points (prestige only)
- Unique rewards (titles, cosmetics, mounts)
- Season-bound (some feats are seasonal)

**Feat of Strength Examples:**
- First guild to clear ICC Heroic
- First guild to claim stronghold in zone
- First player to craft legendary item
- Season 1 top arena rating
- Season 1 top warfront guild

### 11.10 Seasonal Achievements

**Seasonal Achievement Rules:**
- Achievements tied to specific seasons
- Reset or become Feats of Strength after season
- Seasonal leaderboards and rankings
- Seasonal rewards (cosmetics, titles, mounts)

**Seasonal Achievement Examples:**
- Season 1: Top 10 arena players
- Season 1: Top 10 warfront guilds
- Season 1: Top 10 crafters
- Season 1: Top 10 explorers

### 11.11 Achievement Integration

**Integration Points:**
- **Combat System:** Track combat achievements (kills, damage, etc.)
- **Economy System:** Track economy achievements (trading, crafting, etc.)
- **Guild System:** Track guild achievements (strongholds, sieges, etc.)
- **PvP System:** Track PvP achievements (arena, warfront, BG, etc.)
- **PvE System:** Track PvE achievements (dungeons, raids, world bosses, etc.)

**Event Hooks:**
- OnKillCreature → Update kill achievements
- OnCompleteQuest → Update quest achievements
- OnCompleteDungeon → Update dungeon achievements
- OnCompleteRaid → Update raid achievements
- OnWinBattleground → Update BG achievements
- OnWinArena → Update arena achievements
- OnCompleteTask → Update task achievements
- OnCompleteContract → Update contract achievements
- OnCraftItem → Update crafting achievements
- OnClaimStronghold → Update stronghold achievements

### 11.12 Achievement Balance

**Achievement Point Values:**
- **Basic Achievements:** 5-10 points
- **Intermediate Achievements:** 10-25 points
- **Advanced Achievements:** 25-50 points
- **Elite Achievements:** 50-100 points
- **Feats of Strength:** 0 points (prestige only)

**Achievement Rarity:**
- **Common Achievements:** 50%+ of players can achieve
- **Uncommon Achievements:** 25-50% of players can achieve
- **Rare Achievements:** 10-25% of players can achieve
- **Epic Achievements:** 1-10% of players can achieve
- **Legendary Achievements:** <1% of players can achieve

### 11.13 Achievement Testing

**Testing Checklist:**
- Verify achievement criteria tracking
- Verify achievement completion
- Verify reward distribution
- Verify title assignment
- Verify cosmetic unlocks
- Verify seasonal achievements
- Verify Feats of Strength
- Verify achievement UI

---

## 12. Implementation Notes

### 11.1 ID Planning

- Reserve a **Mortal achievement ID range**:  
  - Example: `500000–509999` for initial pass.
- Within that:
  - Allocate subranges per category:
    - 5000xx → PvP
    - 5010xx → Raids
    - 5020xx → Dungeons
    - 5030xx → Economy
    - 5040xx → Exploration
    - 5050xx → Strongholds
    - 5060xx → Hardcore

Add a note at top of this file when a range is used.

### 11.2 Cursor Flow

- Cursor can:
  - Read this doc,
  - Generate initial `INSERT` statements for `achievement` and `achievement_reward`,
  - Generate skeleton C++/script code to:
    - Award achievements on triggers (boss kills, PvP rating thresholds, etc.).
    - Handle season end logic for rankings.

---

## 12. Status

This spec:

- Gives a **global blueprint** for Mortal-specific Achievements & Titles.
- Ties them coherently into:
  - PvP (using `34` & `35`),
  - PvE raid/dungeon tiers (`32` & `33`),
  - Economy, crafting, exploration, strongholds, hardcore systems.
- Leaves exact IDs and full lists of achievements to be filled incrementally as systems are implemented.

You now have a high-level map for how **every major Mortal feature** can grant long-term, prestige-driven goals without inflating power beyond your gear & stat systems.
