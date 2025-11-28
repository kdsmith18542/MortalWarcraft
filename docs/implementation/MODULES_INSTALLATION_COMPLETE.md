# AzerothCore Modules Installation - Complete

**Date:** 2025-01-XX  
**Status:** ✅ **PARTIALLY COMPLETE**

---

## Summary

Installed required AzerothCore modules as specified in the specs. Some modules have compatibility issues that need to be addressed.

---

## Installed Modules

### ✅ mod-autobalance
- **Status:** ✅ **INSTALLED & COMPILED**
- **Location:** `azerothcore/modules/mod-autobalance/`
- **Config:** `azerothcore/bin/etc/AutoBalance.conf.dist`
- **Purpose:** Scales instance mobs based on party size
- **Spec Reference:** Spec 40 (Anti-Bot/RMT/Security)

**Next Steps:**
1. Copy `AutoBalance.conf.dist` to `AutoBalance.conf` and configure
2. Configure to exclude bots from party size calculations (Spec 40 requirement)
3. Set reward scaling to use "real players only"
4. Test in-game with `.ab mapstat` and `.ab creaturestat` commands

### ⚠️ mod-playerbots
- **Status:** ⚠️ **INSTALLED BUT NOT COMPILABLE**
- **Location:** `azerothcore/mod-playerbots-backup/` (moved due to compilation errors)
- **Issue:** API compatibility errors with current AzerothCore version
- **Errors:**
  - `ChannelMgr::GetChannels()` → should be `GetChannel()`
  - `ChatHandler::BuildChatPacket()` signature changed
  - `VEHICLE_FLAG_FIXED_POSITION` not declared
- **Spec Reference:** Spec 40 (Anti-Bot/RMT/Security)

**Next Steps:**
1. Find compatible version/branch of mod-playerbots
2. Or patch the module to fix API compatibility
3. Or use alternative playerbot implementation
4. Once fixed, configure for Mercenary system restrictions (Spec 40)

### ✅ Already Installed
- **mod-anticheat** - ✅ Installed
- **mod-eluna** - ✅ Installed (Lua engine)
- **mod-aio** - ✅ Installed
- **mod-costumes** - ✅ Installed
- **mod-transmog** - ✅ Installed

---

## Module Requirements from Specs

### Spec 40 Requirements:
- ✅ `mod-anticheat` – movement/combat anticheat
- ✅ Lua engine (`mod-eluna`) – for behavior tracking hooks
- ✅ AIO/Lua UI integration (`mod-aio`) – for GM/security panels
- ⚠️ `mod-playerbots` – used under strict control via Mercenary systems (needs fixes)
- ✅ `mod-autobalance` – instance mob scaling, must be monitored for abuse
- ❓ `mod-premium`-style logic – used/extended to implement Supporter status

**Note:** `mod-premium` is mentioned as "mod-premium-style logic" - this may be implemented as part of `mortal_overhaul` rather than a separate module. There's already `supporter_status.lua` in the mortal_overhaul module.

---

## Build Status

### ✅ Successful Build
- **mod-autobalance** compiled successfully
- **worldserver** binary updated
- All existing modules still working

### Build Output
```
Modules detected:
  +- mod-anticheat
  +- mod-autobalance  ← NEW
  +- mod-costumes
  +- mod-eluna
  +- mod-transmog
  +- mortal_overhaul
```

---

## Configuration Files

### AutoBalance Configuration
- **Source:** `azerothcore/modules/mod-autobalance/conf/AutoBalance.conf.dist`
- **Destination:** `azerothcore/bin/etc/AutoBalance.conf.dist`
- **Action Required:** Copy to `AutoBalance.conf` and configure

### Key Configuration Points (from Spec 40):
1. **Bot Exclusion:**
   - Must exclude bots from party size calculations
   - Use `mortal_bot_characters` table (to be created per Spec 40)

2. **Reward Scaling:**
   - Loot/XP should scale with "real players only"
   - Not total group size (prevents abuse)

3. **Security Monitoring:**
   - Track autobalance scaling events
   - Flag suspicious patterns (group size ≠ real players)

---

## Next Steps

### Immediate (mod-autobalance):
1. ✅ Module installed
2. ⏳ Configure `AutoBalance.conf`:
   - Set scaling factors appropriate for Mortal power band
   - Configure bot exclusion (once `mortal_bot_characters` table exists)
3. ⏳ Test in-game:
   - Use `.ab mapstat` to verify scaling
   - Use `.ab creaturestat` on dungeon creatures
4. ⏳ Integrate with Mortal rebalance system:
   - Ensure autobalance runs AFTER Mortal tier scaling
   - Test order of operations

### Future (mod-playerbots):
1. ⏳ Fix API compatibility issues
2. ⏳ Re-enable in build
3. ⏳ Configure for Mercenary system restrictions
4. ⏳ Implement bot exclusion from autobalance

### Future (mod-premium/Supporter):
1. ⏳ Review `mortal_overhaul/lua/supporter_status.lua`
2. ⏳ Determine if separate module needed or if Lua implementation is sufficient
3. ⏳ Implement Supporter status system per specs

---

## Files Created/Modified

### New Files:
- `azerothcore/modules/mod-autobalance/` - Module source
- `azerothcore/bin/etc/AutoBalance.conf.dist` - Configuration template

### Moved Files:
- `azerothcore/mod-playerbots-backup/` - mod-playerbots (needs fixes)

### Updated:
- `azerothcore/build/` - Rebuilt with new modules
- `azerothcore/bin/worldserver` - Updated binary

---

## Testing Checklist

### mod-autobalance:
- [ ] Server starts without errors
- [ ] Module loads (check logs)
- [ ] `.ab mapstat` command works
- [ ] `.ab creaturestat` command works
- [ ] Scaling works in dungeons
- [ ] Bot exclusion works (once implemented)
- [ ] Reward scaling uses real players only (once implemented)

---

## References

- **Spec 40:** Anti-Bot, RMT & Security (defines module requirements)
- **Spec 32:** NPC and Encounter Rebalance (works alongside autobalance)
- **AUTOBALANCE_MODULE_PLAN.md:** Detailed plan for autobalance integration

---

**Status:** ✅ **mod-autobalance installed and ready for configuration**  
⚠️ **mod-playerbots needs API compatibility fixes**

