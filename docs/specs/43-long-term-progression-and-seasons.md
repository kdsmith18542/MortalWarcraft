# Project Canvas: Mortal Warcraft Overhaul
### Version 30.0 — Hybrid Technical Design Document  
### File: 43-long-term-progression-and-seasons.md  
### Section: Long-Term Progression, Cadence & World Resets

---

## 1. Purpose

Define how Mortal Warcraft:

- Evolves over **years**, not weeks.
- Adds new **power, gear, and content** without invalidating early investments.
- Keeps:
  - Strongholds, territories, and economies from hardlocking forever.
  - Multiple playstyles (PvE, PvP, trade, crafting) relevant over time.

This spec focuses on:

1. Power progression philosophy (gear, skills, Mastery trees, runes).
2. Content cadence (dungeons, raids, Warfronts, public dungeons).
3. Seasons/events & soft resets (territory, economy shocks, new mats).
4. Long-term goals & prestige (titles, cosmetics, account-wide progression).

---

## Related Specs

For full context on long-term progression and seasons, see:

- **`52-season-of-the-frontier.md`** — Seasonal challenge system and Season Renown
- **`01-progression.md`** — Core progression system and skill caps that long-term progression builds on
- **`84-mortal-core-stats-and-combat-model.md`** — Stat caps and formulas that remain stable
- **`75-mortal-gear-and-runes-spec.md`** — Gear tiers and rune system that expand horizontally
- **`36-mortal-achievements-and-titles-core.md`** — Achievement and title system for long-term goals
- **`08-guilds-sovereignty.md`** — Stronghold system that provides long-term territory goals
- **`19-itemization.md`** — Itemization tiers that expand over time

---

## 2. Power Progression Philosophy

### 2.1 Core Principles

1. **Horizontal > Vertical**
   - New content should add **sidegrades and options**, not endless +ilvl.
2. **Soft Caps & Diminishing Returns**
   - Attribute caps (150 per stat, 400 sum) and Mortal skill caps are stable.
3. **Gear as Expression**
   - Weapon runes, Masterwork/Flawed items, and set bonuses express playstyle instead of pure stat inflation.
4. **Old Content Remains Viable**
   - Older dungeons/raids should:
     - Feed into crafting (mats, blueprints),
     - Remain relevant via events, task rotations, and cosmetic drops.

### 2.2 Gear Tier Ladder (Mortal Warcraft)

We define **gear tiers** independent of original WoW ilvl:

- **T1–T2**: Early game, green/yellow zones, basic dungeons.
- **T3–T4**: Midgame, deeper dungeons, first raids, red zones.
- **T5**: Endgame—high-risk zones, Warfronts, extraction raids, stronghold-level content.
- **T6+ (Mythic/Relic)**: Long-term chase items; extremely rare or time-limited.

Each new major cycle (e.g., yearly) can:

- Introduce **one additional “band”**:
  - Either a new T5 variant or a T6 subcategory (e.g., “Relic T5.5”),
  - Without obsoleting all prior tiers.

### 2.3 Mastery Trees & Runes

- Mastery trees (Warlord / Guardian / Explorer) and Elden-style Runes:
  - Updated in **balance passes** rather than wholesale reworks.
- New runes:
  - Introduced periodically as:
    - Rare drops from new content,
    - Craftable from new mats,
    - Event rewards.
- Design rule:
  - New runes should open **new patterns** (combos, counters), not just “+10% more damage”.

---

## 3. Content Cadence & Lifecycle

### 3.1 Cadence Levels

We define three cadence levels:

1. **Minor (Monthly)**
   - Task Board re-weights,
   - Hot Zone rotations,
   - Small rune tweaks,
   - Micro events (short invasions, weekend bonuses).

2. **Major (Quarterly)** — “Chapters”
   - New:
     - Public dungeon variant or mini-zone,
     - Warfront or Warfront rule change,
     - 1–2 new blueprints or mats.
   - Modest new gear band (e.g., T4.5 sidegrades),
   - Targeted Mastery tree updates.

3. **Epochal (Yearly+)** — “Seasons/Eras”
   - Big updates:
     - New region or Lost Land variant,
     - New extraction raid or world boss set,
     - One additional gear tier band (e.g., Relic).
   - Soft resets in:
     - Territory control,
     - Some stronghold benefits,
     - Long-term events that reshape routes/resources.

### 3.2 Chapter Model (Quarterly)

Each Chapter has:

- A theme (e.g., “The Plague Coast”, “War for the Dream”, “Iron Tide”).
- A featured activity loop:
  - E.g., gathering/crafting focus, Warfront focus, public dungeon, etc.
- Temporary:
  - Chapter Tasks,
  - Chapter-specific events,
  - Chapter-limited cosmetics and titles.

Chapter rewards:

- Are **not strictly stronger** than all existing gear:
  - They often use:
    - Unique Rune slots,
    - Special on-hit effects,
    - Synergies with certain Mastery tree nodes.

---

## 4. Seasons, Eras & Soft Resets

### 4.1 Season/Era Concept

We treat 6–12 month spans as **Eras**, each with:

- A major narrative arc,
- Big content addition(s),
- Structural changes to:
  - Resources,
  - Territory dynamics,
  - Risk/reward in some regions.

### 4.2 Territory & Stronghold Resets

We avoid hard wipes but allow **soft reshuffles**:

**Mechanisms:**

1. **Environmental Events**
   - Plagues, magical storms, or invasions can:
     - Temporarily shut down certain strongholds,
     - Create new ones,
     - Move high-tier resources.

2. **Decay of Influence**
   - Stronghold-specific perks decay if:
     - Guild fails to maintain upkeep,
     - Or fails periodic defense checks during Era events.

3. **Era Transitions**
   - At the end of an Era:
     - Certain legacy stronghold bonuses can:
       - Convert into **titles/cosmetics**,
       - Lose some direct mechanical advantage.
     - New strongholds or siege rules are introduced.

Goal: long-lived guilds retain **prestige & recognition**, but **not eternal mechanical dominance**.

### 4.3 Economic Shocks

Eras can introduce **new mats / conversions**, e.g.:

- A new T5 reagent that:
  - Upgrades older T4 gear into a new sidegrade variant.
- New smelting/refining recipes:
  - Transform previously common mats into progress-critical resources.

This keeps prior content and mats relevant even as new Eras arrive.

---

## 5. Long-Term Goals & Prestige

### 5.1 Titles & Achievements

We tie long-term prestige to:

- **Era Titles**
  - “Defender of the Iron Tide”
  - “First Flame of the Dream”
- **Stronghold Legacy Titles**
  - For guilds and players part of:
    - Long-time stronghold owners,
    - First capture groups,
    - Last defenders in major sieges.

Titles are:

- Account-wide (where appropriate),
- Irrevocable (even if mechanical perks decay),
- Visible as social clout, not raw power.

### 5.2 Account-Wide Collections

Safe, non-power systems for long-term goals:

- **Rune Library**
  - Once you discover a Rune blueprint, it is recorded account-wide.
  - Still requires crafting or physical items to use, but you don’t “forget” the design.

- **Appearance & Mount Skins**
  - Cosmetic unlocks from:
    - Raids, events, Eras, Warfronts.
  - Persist across Seasons/Eras.

### 5.3 Era “Trophy Cases”

Each Era can feature:

- Seasonal statues, banners, or structures in capitals:
  - Display names of top guilds,
  - Top Warfront victors,
  - Economic leaders (top traders, crafters).

This provides a visible, in-world record of who shaped each Era.

---

## 6. Character Progression Over Time

### 6.1 Skill & Attribute Caps

- Mortal skill caps and attribute caps are **stable across Eras**.
- We avoid raising caps to prevent:
  - A mandatory grind reset every Era,
  - Infinite stat creep.

### 6.2 Mastery Tree Evolution

Per Era, we may:

- Add:
  - 1–3 new nodes per tree,
  - Or a new branch with synergies for new gear/runes.
- Rebalance:
  - Overperforming/underperforming nodes.

We never:

- Force full resets of the tree without:
  - Free respec periods,
  - Good communication and rationale.

### 6.3 Soft Respec Windows

At the start of major Chapters or Eras:

- We can grant:
  - 1–2 **full Mastery respec tokens** per character,
  - Or limited-time free respec from Mentor NPCs.

This encourages experimentation with new content.

---

## 7. Gear Lifecycle & Upgrades

### 7.1 Upgrade Paths Instead of Obsolescence

Instead of “new tier makes old junk,” we provide:

1. **Upgrade Runes/Materials**
   - Use new reagents to:
     - Upgrade a T4 “Ironblade of the Wolf” into:
       - “Ironblade of the Wolf, Tempered” (T4.5),
       - Keeping core identity but adding minor new perks.

2. **Specialization Routes**
   - Same base weapon can:
     - Be upgraded into multiple variants:
       - High-crit glass cannon,
       - Tankier attrition variant,
       - Utility-oriented version (extra Guard Counter stun, etc.).

### 7.2 Legacy Gear as Component

Older high-tier gear may:

- Be used as **components** in crafting new relics:
  - “Sacrifice a T5 item + new Era relic mat → T6 Relic.”
- Keeps old drops valuable even when a new Era introduces fresh Best-in-Slot options.

---

## 8. Seasonal/Chapter Communication & Tools

### 8.1 In-Game Communication

- Use Mortal Codex (File 38) and Event system (File 42) to:
  - Introduce new Era/Chapter with:
    - Codex entries (“Era of the Iron Tide”),
    - Intro quests,
    - Capital city announcements.

### 8.2 Atlas & External Communication

- Mortal Atlas:
  - Hosts Era/Chapter pages with:
    - New features explained,
    - Reward previews,
    - Roadmaps and dev blogs.

---

## 9. Interaction with Telemetry & Security

### 9.1 Telemetry-Driven Adjustments

Using telemetry (File 41), during each Chapter/Era:

- Monitor:
  - What content is underused/overused,
  - Where wealth concentrates,
  - How new mats affect the market.
- Decide:
  - Which activities to buff/nerf or feature next Chapter,
  - Whether a new Era should:
    - Add sinks,
    - Introduce new currencies,
    - Reshuffle stronghold bonuses.

### 9.2 Security Considerations

Big content/gear changes may:

- Temporarily spike:
  - Gold/mat farming,
  - RMT attempts.

Security baseline (File 40) should:

- Watch for new RMT patterns around new hot items,
- Flag suspicious hoarding/funneling of new Era mats.

---

## 10. Implementation Summary

To realize this long-term progression plan:

1. **Define gear tiers & bands** (T1–T5, with optional T6/Relic) in:
   - Item templates and Mortal-specific gear schema.
2. **Plan cadence**
   - Schedule Minor, Major (Chapter), and Era updates on a calendar.
3. **Integrate upgrade paths**
   - Recipes and blueprints that:
     - Upgrade existing items,
     - Use new mats.
4. **Define Era events**
   - High-level scripts using Event Templates (File 42) to:
     - Trigger environmental changes,
     - Reshuffle stronghold/region importance.
5. **Create prestige systems**
   - Titles, cosmetics, banners, statues for each Era.
6. **Connect to telemetry & security**
   - Use data (File 41) to guide what each new Chapter/Era focuses on.
   - Ensure new reward sources have appropriate sinks and monitoring.

This framework ensures Mortal Warcraft can **grow and evolve for years**, adding depth and opportunity without turning into an endless vertical gear treadmill or allowing permanent monopolies to ossify the world.
