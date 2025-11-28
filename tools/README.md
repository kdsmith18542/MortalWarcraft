# Tools Directory

This directory contains various tools for working with the WoW server emulator.

---

## Research & Investigation Tools

### `find_dbc_ids.py`
**Purpose:** Find IDs for creatures, items, and gameobjects from DBC files, database, and reference scripts.

**Usage:**
```bash
# Search for NPC by name (searches DBC, database, and reference scripts)
python3 find_dbc_ids.py --type creature --name "Brandon"

# Search for NPC by ID in reference scripts
python3 find_dbc_ids.py --npc-id 31023

# Search gameobject by name
python3 find_dbc_ids.py --type gameobject --name "Crate" --db-name realm2_world

# Skip reference scripts (DBC/database only)
python3 find_dbc_ids.py --type creature --name "Brandon" --no-reference
```

**Features:**
- Searches DBC files (CreatureDisplayInfo.dbc, etc.)
- Searches database (creature_template, gameobject_template)
- **NEW:** Searches reference scripts (TrinityCore, CMaNGOS) for NPC IDs
- Supports multiple data sources with fallback

---

### `investigate_issues.py`
**Purpose:** Investigate specific AzerothCore issues using multiple data sources.

**Usage:**
```bash
# Investigate issue #16905 (Druid Berserk)
python3 investigate_issues.py --issue 16905 --db-name realm2_world

# Investigate issue #23830 (Culling of Stratholme)
python3 investigate_issues.py --issue 23830 --db-name realm2_world
```

**Features:**
- DBC file analysis (Spell.dbc, etc.)
- Database queries (spell_template, creature spawns)
- Online source links (Wowhead)
- **NEW:** Reference script searches for NPC IDs and dungeon scripts

---

## GitHub API Tools

### `fetch_github_issue.py`
**Purpose:** Fetch detailed information for a specific GitHub issue.

**Usage:**
```bash
python3 fetch_github_issue.py --issue 16905
```

---

### `list_github_issues.py`
**Purpose:** List multiple GitHub issues with filtering.

**Usage:**
```bash
# List open issues
python3 list_github_issues.py --state open

# List issues with specific labels
python3 list_github_issues.py --labels "bug,quest"
```

---

### `fetch_github_prs.py`
**Purpose:** Fetch pull request details, including files changed and patches.

**Usage:**
```bash
# Fetch specific PR
python3 fetch_github_prs.py --pr 23848

# List open PRs
python3 fetch_github_prs.py --state open
```

---

## Reference Scripts

**Location:** `tools/reference/`

**Contents:**
- **TrinityCore Scripts** (`trinitycore-scripts/`) - AzerothCore-compatible C++ scripts
- **CMaNGOS WotLK** (`cmangos-wotlk/`) - ScriptDevAI scripts with complete NPC definitions

**Usage:**
- These are automatically searched by `find_dbc_ids.py` and `investigate_issues.py`
- Use for finding NPC IDs, script patterns, and event sequences
- Reference only - do not integrate into build

**Updating:**
```bash
cd tools/reference/trinitycore-scripts && git pull
cd tools/reference/cmangos-wotlk && git pull
```

---

## Verification Tools

### `verify_fixes.py`
**Purpose:** Verify our fixes against reference script sources (TrinityCore, CMaNGOS).

**Usage:**
```bash
# Verify specific fix
python3 verify_fixes.py --fix 15629

# Verify all Culling of Stratholme fixes
python3 verify_fixes.py --all

# List all verifiable fixes
python3 verify_fixes.py --list
```

**Features:**
- Compares NPC IDs in our code against reference scripts
- Verifies NPC IDs match between our code and references
- Identifies NPCs in references but not in our code
- Identifies NPCs in our code but not in references

**Example Output:**
```
✅ Matches: 41 NPC IDs found in both our code and references
⚠️  Our Only: 4 NPC IDs in our code but not in references
📋 Reference Only: 25 NPC IDs in references but not in our code
```

---

## Other Tools

### `mwdbquery.py`
Database query tool (legacy).

### `investigate_wowhead_browser.py`
Wowhead research using browser automation (placeholder).

---

## Notes

- Most tools support database connection via command-line arguments
- Reference scripts are automatically searched when available
- Tools fall back gracefully if reference scripts are missing
- Use `--no-reference` flag to skip reference script searches if needed

---

**Last Updated:** 2025-01-23
