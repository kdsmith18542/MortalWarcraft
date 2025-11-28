# GitHub API Investigation Results

**Date:** 2025-01-23  
**Method:** GitHub REST API (faster than browser automation!)

---

## ✅ GitHub API Works Perfectly!

**Tool:** `tools/fetch_github_issue.py`

**Advantages:**
- ✅ **Much faster** than browser automation
- ✅ **Structured data** (JSON)
- ✅ **No rate limits** (or higher limits with token)
- ✅ **Can fetch comments** automatically
- ✅ **Can search issues** by keywords

---

## Issue #16905: Actual Bug Description

### The Real Issue (from GitHub):

**Title:** "[Druid] Spell Berserk : energy consumption in feral form"

**Actual Bug:**
- **NOT** about Berserk consuming energy when cast
- **IS** about energy cost reduction being **TOO MUCH** (75% instead of 50%)
- The issue is with **calculation order** of modifiers

**Current Behavior:**
- Energy costs are reduced by 75% instead of 50%
- Example: Spell that costs 42 energy should cost 21 (50% reduction) but costs even less

**Root Cause (from comment #2):**
> "Seems like the server is doing percentage then flat modifiers to power cost when it should do flat and then percentage"

**Expected Behavior:**
- Berserk should reduce energy costs by exactly 50%
- Calculation order: Apply flat modifiers FIRST, then percentage modifiers

**Evidence:**
- Comment #4 shows screenshots proving the bug exists
- Multiple talents (Ferocity, Shredding Attacks) interact incorrectly with Berserk

---

## Issue #23830: Actual Bug Description

### The Real Issue (from GitHub):

**Title:** "[Culling of Stratholme] Wave spawn positions are fixed"

**Actual Bug:**
- Waves and bosses **always spawn in the same place**
- They should **spawn at randomized positions**

**Current Behavior:**
- Hardcoded positions in `WavesLocations` array
- Same spawns every time

**Expected Behavior:**
- Spawn positions should be **randomized**
- Bosses should appear at different positions (see YouTube links)

**Evidence:**
- YouTube videos showing 2nd boss at different positions
- Issue provides timestamps: https://youtu.be/2p5H5NH8LfE?t=505

---

## Fixes Needed

### For Issue #16905:

**Fix:** Change power cost calculation order in spell system
- Apply **flat modifiers first** (e.g., Ferocity -5 energy)
- Then apply **percentage modifiers** (e.g., Berserk -50%)

**Location:** Likely in `Spell.cpp` or `Unit.cpp` power cost calculation

**Current (Wrong):**
```
cost = base_cost
cost = cost * (1 - 0.50)  // Berserk -50%
cost = cost - 5            // Ferocity -5
// Result: Too much reduction
```

**Should Be:**
```
cost = base_cost
cost = cost - 5            // Ferocity -5 (flat first)
cost = cost * (1 - 0.50)   // Berserk -50% (percentage second)
// Result: Correct 50% reduction
```

### For Issue #23830:

**Fix:** Randomize spawn positions instead of hardcoded

**Location:** `culling_of_stratholme.cpp:191-241` (WavesLocations array)

**Current (Wrong):**
```cpp
// Fixed positions
float WavesLocations[8][4][5] = {
    {NPC_RISEN_ZOMBIE, 2164.698975f, 1255.392944f, ...},
    // ... always same positions
};
```

**Should Be:**
```cpp
// Randomize positions from a pool of possible spawn locations
// Or use database spawns with randomization
```

---

## Tools Created

### 1. GitHub API Tool (`fetch_github_issue.py`)
```bash
# Fetch specific issue
python3 tools/fetch_github_issue.py --issue 16905 --comments

# Search issues
python3 tools/fetch_github_issue.py --search "berserk energy"

# JSON output
python3 tools/fetch_github_issue.py --issue 16905 --json
```

### 2. Browser Automation (for Wowhead)
- Use Cursor's browser tools
- Navigate to Wowhead pages
- Extract tooltip data
- Search comments

### 3. Database/DBC Tools
- SQL queries for spell/creature data
- DBC file reading
- Combined investigation

---

## Comparison: GitHub API vs Browser Automation

| Method | Speed | Reliability | Use Case |
|--------|-------|-------------|----------|
| **GitHub API** | ⚡⚡⚡ Very Fast | ✅✅✅ Very Reliable | Reading issues, comments, searching |
| **Browser Automation** | ⚡⚡ Fast | ✅✅ Reliable | Wowhead pages, dynamic content |
| **Manual Research** | ⚡ Slow | ✅ Reliable | When automation fails |

**Best Approach:** Use GitHub API for issue research, browser automation for Wowhead!

---

## Next Steps

1. **Fix Issue #16905:**
   - Find power cost calculation code
   - Fix modifier order (flat first, then percentage)
   - Test with multiple talents

2. **Fix Issue #23830:**
   - Watch YouTube videos for spawn positions
   - Implement position randomization
   - Or use database spawns with randomization

3. **Update Investigation Tools:**
   - Integrate GitHub API into `investigate_issues.py`
   - Combine with browser automation
   - Create comprehensive reports

---

## Summary

✅ **GitHub API is MUCH faster than browser automation for issues!**

- Fetched both issues in seconds
- Got full descriptions and comments
- Structured JSON data
- No need for browser automation for GitHub

**Use:**
- **GitHub API** for issue research
- **Browser automation** for Wowhead/other sites
- **Database/DBC** for server data

**Best of all worlds!**

