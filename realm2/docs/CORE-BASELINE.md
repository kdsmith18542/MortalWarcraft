# Realm 2 Core Baseline

**Purpose:** Track the current AzerothCore baseline and module versions for Realm 2. This is an **internal tracking document only** - we do not submit PRs to upstream.

**Last Updated:** 2025-01-XX

---

## AzerothCore Baseline

**Upstream Repository:** https://github.com/azerothcore/azerothcore-wotlk.git  
**Our Fork:** https://github.com/kdsmith18542/MortalWarcraft  
**Realm 2 Branch:** `realm2` (or `realm2-legacy-journey`)

**Baseline Commit:** `e740f21680136414140a2a93550f107382a92566`  
**Commit Date:** 2025-11-23 02:24:25 -0300  
**Commit Message:** `fix(Core/Handler): player can reclaim corpse regardless of phase (#23862)`

**Pinned Date:** 2025-01-XX  
**Reason for Pinning:** Initial Realm 2 setup - stable baseline for expansion-progressive server.

**Branch Strategy:** One branch per realm in the fork. Realm 2 uses its own branch for isolation.

---

## Third-Party Modules

### Official AzerothCore Modules

| Module | Repository | Commit | Purpose |
|--------|-----------|--------|---------|
| `mod-eluna` | https://github.com/azerothcore/mod-eluna | `c1066d7a` | ALE (AzerothCore Lua Engine) - Lua scripting |
| `mod-aio` | https://github.com/Rochet2/AIO.git | `087e279c` | Addon communication system |
| `mod-anticheat` | https://github.com/azerothcore/mod-anticheat.git | `09dddce4` | Anti-cheat systems |
| `mod-autobalance` | https://github.com/azerothcore/mod-autobalance.git | `83829373` | Instance scaling/autobalance |
| `mod-costumes` | https://github.com/azerothcore/mod-costumes.git | `1be7b8f9` | Costume system |
| `mod-transmog` | https://github.com/azerothcore/mod-transmog.git | `949cdfb0` | Transmogrification system |

### Realm 2 Custom Modules

| Module | Type | Status | Purpose |
|--------|------|--------|---------|
| `realm2_era_progression` | Custom | ✅ Implemented | Era-based level caps, zone/instance/item gating, DK restrictions |
| `mod_auction_policy_legacy` | Custom | ✅ Implemented | Auction house policy (caps, stack rules, dynamic fees) |

**Planned Modules:**
- `mod_legacy_chat` - World chat restrictions, anti-spam
- `mod_legacy_announcer` - System announcements for era changes, events

---

## Local Patches

**Current Core Patches:** None

*Note: Realm 2 follows "modules first" policy. Core edits are reserved for crashes, exploits, or missing hooks that cannot be implemented in modules.*

---

## Update History

### 2025-01-XX - Initial Baseline
- Pinned to AzerothCore commit `e740f21680136414140a2a93550f107382a92566`
- Added official AzerothCore modules (mod-eluna, mod-aio, mod-anticheat, mod-autobalance, mod-costumes, mod-transmog)
- Implemented custom modules: `realm2_era_progression`, `mod_auction_policy_legacy`
- No core patches applied

---

## Notes

- **Upstream Strategy:** We treat AzerothCore as a vendor. We pull updates selectively when they benefit Realm 2 (security fixes, LFG/RDF/BG/raid fixes, era progression blockers).
- **No PRs to Upstream:** This is a fork for our use. We do not submit PRs to AzerothCore unless it directly benefits us.
- **Module-First Policy:** All custom behavior is implemented in modules. Core edits are exceptions only.
- **Fork & Branch Strategy:** All realms use the same fork (https://github.com/kdsmith18542/MortalWarcraft) with one branch per realm. Realm 2 has its own branch for isolation.

---

## Future Updates

When updating the baseline:

1. **Document the reason:**
   - Security fix
   - Major feature we need
   - Critical bug fix
   - Performance improvement

2. **Note conflicts:**
   - Any merge conflicts encountered
   - How they were resolved
   - Impact on Realm 2 modules

3. **Test thoroughly:**
   - Era progression still works
   - Module systems functional
   - Content integrity maintained
   - No regressions in key systems

4. **Update this file:**
   - New commit hash
   - New date
   - Module version updates
   - Any new patches applied

