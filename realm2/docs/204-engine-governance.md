# Realm 2 Engine Governance & Upstream Strategy

**Scope:** Internal policy for managing our fork of AzerothCore and related modules for **Realm 2: Mortal Warcraft: Legacy Journey** (expansion-progressive WotLK server).

**Note:** Realm 1 (Mortal Sandbox) is a complete custom overhaul and follows its own governance. This document applies **only to Realm 2**.

**Goal:**  
Treat AzerothCore as an upstream *engine vendor* while we operate an independent, production-grade fork for Realm 2. We decide when and how to pull from upstream. We do **not** depend on upstream PRs being merged. Realm 2 stays close to AzerothCore with minimal core edits, using modules for custom behavior.

---

## 1. High-Level Principles

1. **We own our engine.**
   - Our Realm 2 fork is the source of truth for this realm.
   - We don't block on upstream decisions or PR review.
2. **Modules first, core edits last.**
   - Whenever possible, behavior lives in `Custom` modules, not core files.
   - Core edits are reserved for:
     - Crashes / exploits,
     - Missing hooks we absolutely need,
     - Low-level engine fixes.
3. **Upstream is a vendor.**
   - We periodically pull *selected* changes from AzerothCore.
   - We may upstream patches opportunistically, but it’s never required.
4. **Stability over novelty.**
   - We pin to a baseline commit and move forward intentionally.
   - We avoid chasing every new change in upstream.

---

## 2. Baseline & Branch Strategy

### 2.1 Baseline Tracking

Maintain:

```text
realm2/docs/CORE-BASELINE.md

- AzerothCore repo URL
- Baseline commit hash
- Date we pinned it
- List of third-party modules (name, repo, commit)
- Realm 2 custom modules (realm2_era_progression, mod_auction_policy_legacy, etc.)
- Local patches summary (1–2 sentences each)
```

Any time we rebase on a newer AC commit:

- Update `CORE-BASELINE.md`.
- Note:
  - Why we updated (security fix, big feature, key bug fix),
  - Any notable conflicts and how we resolved them.
  - Impact on Realm 2 modules and era progression.

### 2.2 Branches

**Fork Repository:** https://github.com/kdsmith18542/MortalWarcraft  
**Strategy:** One branch per realm in the shared fork.

**Realm 2 Branch Structure:**

- `realm2` (or `realm2-legacy-journey`) – current production engine for Realm 2.
- `realm2-develop` – integration branch for new modules and fixes for Realm 2.
- `realm2-upstream-sync` – temporary branch when pulling from AzerothCore upstream to resolve conflicts before merging into `realm2-develop`.

**Workflow:**

1. New work lands on a feature branch off `realm2-develop` (e.g., `realm2-feature-era-update`).
2. Once tested, merge to `realm2-develop`.
3. Periodically, after testing, merge `realm2-develop` → `realm2` (production).

**Upstream Sync Workflow:**

1. Create `realm2-upstream-sync` from `realm2-develop`.
2. Add upstream remote: `git remote add upstream https://github.com/azerothcore/azerothcore-wotlk.git`
3. Fetch and merge/rebase desired upstream commits.
4. Resolve conflicts, test thoroughly.
5. Merge `realm2-upstream-sync` → `realm2-develop` → `realm2`.

**Note:** All realms share the same fork but use separate branches. This allows shared infrastructure while maintaining realm isolation.

---

## 3. **ASAP Upstream Issue Audit**

We must complete a **structured audit** of AzerothCore issues to prioritize internal fixes.

### 3.1 Audit Goals

- Identify all upstream issues that materially affect **Realm 2**:
  - Leveling, dungeons, raids, RDF, BGs, Wintergrasp
  - Era progression systems (level caps, zone gating, item filtering)
  - Auction house and economy stability
  - Instance lockouts and progression integrity
  - Stability, exploits, security
- Classify issues by:
  - Severity: `Crash/Exploit`, `Blocker`, `Major`, `Minor`, `Cosmetic`.
  - Impact: `Era Progression`, `Content`, `Economy`, `Stability`, `Irrelevant`.
- Build an **internal issue backlog** independent of GitHub, focused on Realm 2's needs.

### 3.2 Audit Process (ASAP)

1. **Seed the board:**
   - Go through AzerothCore's:
     - Open issues,
     - "Server-breaking" / crash-labeled items,
     - Known exploit / economy-related issues,
     - Key LFG/RDF/BG/Wintergrasp/Instance bug reports (critical for Realm 2),
     - Leveling/quest progression issues,
     - Raid/dungeon lockout bugs.
2. **Mirror into internal tracker:**
   - For each relevant issue, create an internal ticket:
     - Title: short summary.
     - Description: link/ID to original AC issue, notes.
     - Tags: `severity`, `realm impact`, `area` (e.g. “LFG”, “Pathfinding”, “Economy”).
3. **Prioritize:**
   - Top priority:
     - Crashes,
     - Exploits (dupes, infinite loot/chest bugs, lockout bypass, etc.),
     - Anything that can destroy the economy or realm progression.
   - Next:
     - Progression blockers in key raid/quest content.
     - Era progression issues (level caps, zone gating, item filtering).
     - RDF/LFG system bugs that affect group finding.
   - Later:
     - Cosmetic / minor blizzlike correctness issues.

4. **Outcome:**
   - A living internal backlog of “AC engine issues we own”.
   - A sorted list of what we fix **before** launch vs. post-launch.

This audit is **time-sensitive** and should be started as soon as possible.

---

## 4. Module vs Core Policy

### 4.1 Modules (Preferred)

New behavior **must** be implemented in modules when possible. Realm 2 modules:

**Implemented:**
- `realm2_era_progression` – Era-based level caps, zone/instance/item gating, DK restrictions
- `mod_auction_policy_legacy` – Auction house policy (caps, stack rules, dynamic fees)

**Planned (from design docs):**
- `mod_legacy_chat` – World chat restrictions, anti-spam
- `mod_legacy_announcer` – System announcements for era changes, events

**Official AzerothCore Modules (in use):**
- `mod-eluna` (ALE) – Lua scripting engine
- `mod-aio` – Addon communication
- `mod-anticheat` – Anti-cheat systems
- `mod-autobalance` – Instance scaling
- `mod-costumes` – Costume system
- `mod-transmog` – Transmogrification

**Module Discovery:**
- CMake auto-discovers modules from `modules/` directory
- Config files auto-loaded from `modules/mod_name/config/`
- Script loaders registered via `AC_ADD_SCRIPT_LOADER` macro

Benefits:

- Easier to test and toggle per realm.
- Easier to carry forward when syncing with upstream.
- Clear separation between “engine” and “game design”.

### 4.2 Core Changes (Exceptions)

We edit core files only when:

- Fixing **crashes, security issues, or serious exploits**.
- Adding **missing hooks** that multiple modules need.
- Resolving structural issues that can’t be bandaid-fixed in scripts.

For any core edit:

- Document it in `realm2/docs/CORE-BASELINE.md` or a separate `CORE-PATCHES.md` file.
- Keep patches as small and surgical as possible.
- Avoid entangling patches with Realm 2-specific logic (prefer modules).
- Test that era progression and module systems still work after core changes.

---

## 5. Pulling from Upstream

We **do not** chase every change from AzerothCore. Instead:

### 5.1 Triggers for Upstream Sync

We consider pulling new AC changes when:

- There is a **security advisory**, RCE fix, or major exploit fix.
- There are significant **LFG/RDF/BG/raid fixes** (critical for Realm 2's group content).
- There are **era progression blockers** fixed (leveling, quests, instances).
- There are performance improvements that directly benefit our use case.
- There are **auction house fixes** (affects `mod_auction_policy_legacy`).

### 5.2 Sync Procedure

1. Create / update `realm2-upstream-sync` branch from `realm2-develop`.
2. Add upstream remote if needed: `git remote add upstream https://github.com/azerothcore/azerothcore-wotlk.git`
3. Fetch upstream: `git fetch upstream`
4. Merge or rebase the desired AC commit(s) into `realm2-upstream-sync`.
5. Resolve conflicts there.
6. Run:
   - Core compilation,
   - Automated tests (if any),
   - Basic smoke tests on a staging realm.
   - Era progression tests (Realm 2 specific).
7. Once stable, merge `realm2-upstream-sync` → `realm2-develop`, then eventually → `realm2`.

---

## 6. Testing & Hardening

### 6.1 Categories to Test

- **Stability & Crashes**
  - Basic uptime soak tests.
  - Intentional stress: many instances, many players, bots.
- **Economy & Exploits**
  - Chest loot patterns,
  - Mail/AH/trade edge cases,
  - Instance reset behavior and lockouts.
- **Content Integrity**
  - Key dungeons/raids for Realm 2:
    - Entry requirements, lockouts, boss kill flags, end-chests.
    - Era gating (Vanilla → TBC → WotLK progression).
  - Critical leveling paths and quest chains.
  - Era progression mechanics (level caps, zone access, item filtering).

### 6.2 Regression Discipline

- Any time we fix an upstream-class issue (crash, exploit), we add:
  - A test case (if possible), or
  - A short checklist for QA, so we don’t regress later.

---

## 7. Licensing & Contributions (Internal Note)

- We **credit** AzerothCore as our upstream project.
- We **are not obligated** to upstream our changes or open-source our fork.
- We may upstream:
  - Small, clean patches (crash fixes, hooks) when convenient.
  - This is optional and done only if it benefits us.

All team members should:

- Understand that **our fork (https://github.com/kdsmith18542/MortalWarcraft) is our engine**; AzerothCore is a base, not a master.
- Route all engine changes through this governance approach, not ad-hoc edits.
- Use branch-per-realm strategy: Realm 2 work goes on `realm2` branch, Realm 1 on its own branch.

---

## 8. Module Development Standards

### 8.1 Module Structure

All Realm 2 modules should follow this structure:

```
modules/module_name/
├── CMakeLists.txt          # Build configuration
├── src/                    # C++ source files
│   ├── ModuleLoader.cpp    # Script registration
│   └── ...
├── sql/                    # Database migrations
│   └── 01_create_tables.sql
├── config/                 # Configuration files
│   └── module_name.conf.dist
└── README.md               # Module documentation
```

### 8.2 Naming Conventions

- **Realm 2-specific modules:** `realm2_*` (e.g., `realm2_era_progression`)
- **Shared/legacy modules:** `mod_*` (e.g., `mod_auction_policy_legacy`)
- **Official AzerothCore modules:** Keep original names (e.g., `mod-eluna`)

### 8.3 Database Management

- Module SQL files go in `modules/module_name/sql/`
- Use numbered prefixes for ordering: `01_create_tables.sql`, `02_migrations.sql`
- Test migrations on staging before production
- Document any shared vs realm-specific database usage

### 8.4 Configuration

- Config files in `modules/module_name/config/module_name.conf.dist`
- CMake auto-discovers and registers config files
- Use `sConfigMgr` to load settings in module code
- Provide sensible defaults for all settings

---

## 9. Summary

- Realm 2 owns a long-lived fork built on AzerothCore, independent from Realm 1.
- We design and implement **modules first**, core edits only when necessary.
- We run an **ASAP audit of AzerothCore's issues** focused on Realm 2's needs (era progression, content, economy).
- We pull from upstream only when it clearly benefits Realm 2, and on our schedule.
- All Realm 2 work happens on the `realm2` branch in the shared fork (https://github.com/kdsmith18542/MortalWarcraft).
