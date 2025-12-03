# AzerothCore Upstream Sync Guide

## Overview

This document provides guidance on syncing with the upstream AzerothCore repository while preserving the Mortal Warcraft custom development and Era Progression features.

## Upstream Repository

**Upstream URL**: https://github.com/azerothcore/azerothcore-wotlk

The upstream remote has been added to this repository:
```bash
git remote add upstream https://github.com/azerothcore/azerothcore-wotlk.git
```

## Syncing Strategy

### Before Syncing

1. **Backup your database** - Always backup your database before major updates
2. **Document custom changes** - Ensure all custom modifications are documented
3. **Test environment** - Perform upstream sync in a test environment first
4. **Review upstream changes** - Check the upstream changelog for breaking changes

### Recommended Sync Process

```bash
# 1. Fetch upstream changes
git fetch upstream master

# 2. Review what's coming
git log HEAD..upstream/master --oneline

# 3. Create a sync branch
git checkout -b sync-upstream-$(date +%Y%m%d)

# 4. Carefully merge or cherry-pick changes
# Option A: Full merge (risky for custom forks)
git merge upstream/master

# Option B: Selective cherry-pick (recommended)
git cherry-pick <commit-hash>

# 5. Test thoroughly
# - Build the server
# - Run database migrations
# - Test custom Mortal Warcraft features
# - Test Era Progression features

# 6. If successful, merge to main branches
git checkout mortal-overhaul
git merge sync-upstream-$(date +%Y%m%d)
```

### Areas to Watch

When syncing with upstream, pay special attention to:

1. **Core Combat Systems** - May affect Mortal Warcraft custom combat mechanics
2. **Database Schema Changes** - Ensure compatibility with custom tables
3. **Spell System Changes** - Could impact custom skills and abilities
4. **Loot/Drop Systems** - May affect procedural crafting and quality systems
5. **Faction System** - Could impact custom faction mechanics

## Known Upstream Issues

The following critical issues have been identified in the upstream AzerothCore repository. These should be monitored and fixed when syncing:

### 1. DBC Loading Crash (Issue #22522) - CRITICAL
**Priority**: Critical (Server-Breaking)
**Status**: Open
**Impact**: Server crashes on startup if certain DBCs are loaded from file
**Workaround**: Use database tables for affected DBCs
**Link**: https://github.com/azerothcore/azerothcore-wotlk/issues/22522

### 2. Guilds Disappearing After Restart (Issue #23021)
**Priority**: High
**Status**: Open
**Impact**: Guilds created during session disappear after server restart
**Workaround**: Unknown - may be related to concurrent writes
**Link**: https://github.com/azerothcore/azerothcore-wotlk/issues/23021

### 3. PVP Control Abilities Refreshing Bug (Issue #22015)
**Priority**: High (PVP Balance)
**Status**: Open
**Impact**: Control abilities like Sap can be spammed to refresh duration
**Workaround**: Monitor for exploits, manual GM intervention
**Link**: https://github.com/azerothcore/azerothcore-wotlk/issues/22015

### 4. Eye of the Storm Death Bug (Issue #21657)
**Priority**: Medium (Battleground)
**Status**: Confirmed
**Impact**: Players with immunity (BoP, Divine Shield) fall to bottom when jumping
**Workaround**: Don't jump off edges with immunity active
**Link**: https://github.com/azerothcore/azerothcore-wotlk/issues/21657

### 5. SAI Event 61 (SMART_EVENT_LINK) Not Working (Issue #20927)
**Priority**: Medium (Affects Many NPCs)
**Status**: Open
**Impact**: Linked SAI events don't execute properly
**Workaround**: Use alternative scripting methods or C++ scripts
**Link**: https://github.com/azerothcore/azerothcore-wotlk/issues/20927

## Additional Critical Issues to Monitor

- **Issue #15915**: Resilience behavior with crit-proc talents (PVP)
- **Issue #9400**: Blade of Eternal Darkness proc doesn't crit
- **Issue #2330**: Profession learning command bugs
- **Issue #19562**: Druid Flight Form excessive threat generation
- **Issue #20730**: Surveyor Candress spell damage/frequency issues

## Testing Checklist After Sync

- [ ] Server compiles without errors
- [ ] Server starts without crashes
- [ ] Database migrations apply successfully
- [ ] Mortal Warcraft custom module loads
- [ ] Custom skills system works
- [ ] Procedural crafting functions
- [ ] Faction system operates correctly
- [ ] Era progression features intact
- [ ] PVP systems functional
- [ ] Instance/dungeon spawns working
- [ ] Custom UI elements display

## Rollback Procedure

If sync causes issues:

```bash
# 1. Stop the server
# 2. Restore database backup
# 3. Revert code changes
git reset --hard HEAD@{1}

# 4. Restart with previous stable version
```

## Best Practices

1. **Never sync directly to production** - Always test first
2. **Keep detailed logs** of what was synced and when
3. **Document any conflicts** and how they were resolved
4. **Maintain a changelog** specific to your fork
5. **Communicate with players** about downtime and changes
6. **Keep backups** for at least 2-3 sync cycles

## Support

For issues specific to:
- **Upstream AzerothCore**: https://github.com/azerothcore/azerothcore-wotlk/issues
- **Mortal Warcraft Custom**: Internal documentation/team
- **This Repository**: GitHub Issues

## Last Updated

December 3, 2025 - Initial documentation created
