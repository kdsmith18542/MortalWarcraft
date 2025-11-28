# Executive Summary: C++ Module Gap Analysis

**Date**: November 24, 2025  
**Prepared for**: Mortal Warcraft Development Team  
**Scope**: 10 major game systems across AzerothCore C++ modules

---

## Quick Assessment

| System | Status | Risk Level | Impact |
|--------|--------|-----------|--------|
| Criminal Flags | 🟡 70% - Headers/DB exist, logic missing | MEDIUM | Bounty system non-functional |
| Bounty System | 🔴 20% - Schema only, no decay/logic | HIGH | Players stay wanted forever |
| Notoriety Decay | 🔴 0% - Completely missing | HIGH | Economy imbalance (criminals unchecked) |
| Healing Zones | 🔴 0% - Never implemented | LOW | Design question |
| Blessed Items | 🟡 60% - Framework exists, enforcement gaps | LOW | Items can still be stolen |
| Public Grouping | 🟡 70% - Request system works, creation missing | MEDIUM | Groups won't actually form |
| Build Presets | 🟢 90% - One location check missing | LOW | Minor validation gap |
| Buy Orders | 🟡 50% - Fulfillment works, generation missing | MEDIUM | Orders must be manually created |
| Dynamic Ecosystem | 🔴 0% - Completely missing | LOW | World doesn't feel alive (lower priority) |
| Caravan System | 🟡 40% - Physics defined, not integrated | MEDIUM | Caravans don't actually move differently |

---

## By The Numbers

- **Total C++ Modules**: 25+ custom files in `/src/`
- **Stub/Incomplete Headers**: 8 (80% of high-impact systems)
- **Database Tables Defined**: 40+ (well-structured)
- **Fully Implemented**: 3 systems (Achievements, Titles, Skills core)
- **Performance-Critical Gaps**: 3 major (notoriety decay, spawn scheduler, buy order generation)

---

## Impact Assessment

### **CRITICAL** (Game-Breaking if Missing)
1. **Criminal Flag System** - Without this, PvP zones are just open-world deathmatch
   - Currently: 70% done (headers + DB exist, no expiry logic)
   - Impact: Criminal players never lose flag, game feels broken
   - Effort to fix: ~5 hours

2. **Notoriety Decay** - Without this, killed players stay wanted forever
   - Currently: 0% done (schema exists, no decay timer)
   - Impact: Creates impossible revenge scenarios, breaks bounty economy
   - Effort to fix: ~4 hours

### **HIGH** (Gameplay Loop Broken)
3. **Buy Order Generation** - Without this, economy is static
   - Currently: 50% done (fulfillment works, generation stubbed)
   - Impact: Players craft for non-existent NPCs, economy doesn't self-balance
   - Effort to fix: ~6 hours

4. **Public Group Formation** - Without this, group finder is window dressing
   - Currently: 70% done (request system works, group creation missing)
   - Impact: Group requests hang forever, no actual groups form
   - Effort to fix: ~4 hours

### **MEDIUM** (Progression Incomplete)
5. **Caravan System** - Without full integration, caravans are slow quests
   - Currently: 40% done (physics calculated but not applied)
   - Impact: Caravans don't respond to terrain/cargo, content feels static
   - Effort to fix: ~8 hours

6. **Bounty System** - Without decay, bounties accumulate forever
   - Currently: 20% done (schema only, no active logic)
   - Impact: High-notoriety players become pariahs permanently
   - Effort to fix: ~3 hours (after notoriety decay done)

### **LOW** (Polish/Optional)
7. **Healing Zone Restrictions** - System doesn't exist, may not be intended
   - Currently: 0% done (no code, no schema)
   - Impact: Zones don't have distinct feels
   - Effort to fix: ~5 hours (if needed)

8. **Dynamic Ecosystem** - Spawn system works fine without it
   - Currently: 0% done (complex feature)
   - Impact: World doesn't respond to activity dynamically
   - Effort to fix: 16+ hours

---

## The Core Problem

**Pattern Observed**: The Mortal codebase uses a "declaration-first" architecture where:

1. ✅ **Excellent database schema** is designed first (all tables exist)
2. ✅ **Good API headers** are declared in `.h` files
3. ❌ **Implementation is missing** - `.cpp` files are stubbed or hooks are never called
4. ❌ **Integration points don't exist** - No WorldScript timers, no PlayerScript hooks

**Example**: Criminal Flags
```cpp
// Header (declared)
class MortalOverhaul {
    bool IsCriminalFlagged(Player* player);  // ✅ Declared
    void SetCriminalFlag(Player* player, uint32 durationSeconds);  // ✅ Declared
};

// Database (exists)
CREATE TABLE character_criminal_flags (guid INT, criminal_until INT);  // ✅ Table exists

// But in ScriptMgr.cpp
class PlayerScript_MortalPvP : public PlayerScript {
    // ❌ OnPlayerAttack() method doesn't exist - never calls SetCriminalFlag()
    // ❌ No WorldScript to clean expired flags
};
```

**Result**: Criminal flag system is 70% complete but totally inert.

---

## Time to Functional State

### Minimum Viable Product (MvP)
To get the 10 systems to "game-playable" state:
- Criminal flags with expiry: **5 hours**
- Notoriety decay: **4 hours**
- Buy order generation: **6 hours**
- Group creation: **4 hours**
- **Total: ~19 hours = 2-3 dev days**

### Full Implementation
To get all systems to "complete" state (including polish & optimization):
- MvP systems: 19 hours
- Remaining systems (caravans, blessed items, healing zones, etc.): 25 hours
- **Total: ~44 hours = 1 week (full-time)**

### Feature-Complete (All Systems Polished)
Including spawn scheduler and ecosystem:
- Full implementation: 44 hours
- Dynamic ecosystem: 16+ hours
- Edge cases & testing: 20 hours
- **Total: ~80 hours = 2 weeks (full-time)**

---

## Recommended Action Plan

### Phase 1: Foundation (1-2 days)
Get PvP systems working (bounty/criminal flags):
- [ ] Implement criminal flag setter/getter (2h)
- [ ] Add flag cleanup WorldScript (3h)
- [ ] Implement notoriety decay (4h)
- [ ] Add bounty token rewards (3h)

### Phase 2: Economy (1 day)
Get buy orders and grouping working:
- [ ] Implement buy order generation (6h)
- [ ] Implement group creation hook (4h)
- [ ] Add gossip integration for buy orders (3h)

### Phase 3: Polish (1-2 days)
Complete remaining systems:
- [ ] Build preset location validation (1h)
- [ ] Blessed item binding (2h)
- [ ] Caravan vehicle integration (8h)

### Phase 4: Optional
If time and design permits:
- [ ] Healing zone restrictions (5h)
- [ ] Dynamic ecosystem (16h)

---

## Risk Mitigation

### What Goes Wrong If We Don't Fix These

**Immediately (hours after launch)**:
1. Criminal flags don't expire → players get stuck as wanted men
2. Buy orders never regenerate → NPC commerce is broken
3. Groups never form → group finder is broken

**After a few days**:
4. Notoriety spirals → new players killed by overpowered criminals with infinite bounties
5. Caravan system is boring → players avoid commerce tasks
6. No bounty payoff → crime goes unchecked

**After a week**:
7. Economy breaks → gold sinks don't exist (buy orders), deflation/inflation
8. Guilds can't form groups → endgame content requires manual LFG
9. Blessed items still get stolen → soft insurance doesn't work

### Testing Before Launch

Must verify:
- [ ] Criminal flag sets on attack in yellow zone
- [ ] Flag expires correctly (test with database timestamp)
- [ ] Notoriety decays (check database every 10 minutes)
- [ ] Bounty tokens awarded (check player inventory)
- [ ] Buy orders regenerate (check every 8 hours)
- [ ] Groups form from requests (create and verify Group object)
- [ ] Presets can't be used in Red zones (try to swap in contested zone)

---

## Resource Requirements

### Development
- **1 Full-Time C++ Dev**: 2-3 weeks for full implementation
- **Or**: 2 Part-Time Devs: 4-6 weeks
- **Code Review**: 1 Senior Dev for 20 hours (spec compliance, security)
- **QA Testing**: 1 QA for 10 hours (per-system testing)

### Monitoring
- **Server Logs**: Watch for database errors (criminal flag cleanup fails)
- **Telemetry**: Track notoriety distribution (is decay working?)
- **Community Reports**: Monitor for "stuck as criminal" complaints

---

## Conclusion

**The Good**:
- Database design is solid and well-indexed
- API headers are well-structured
- Most of the framework is in place
- Physics/formulas are mathematically sound

**The Bad**:
- 80% of implementation is missing (just the execution part)
- 3 systems are completely non-functional (notoriety, ecosystem, healing zones)
- No integration hooks (WorldScripts, PlayerScripts not connected)

**The Path Forward**:
- **2-3 days** of focused development gets to "playable"
- **1 week** of focused development gets to "feature-complete"
- **2 weeks** of focused development gets to "polished"

**Recommendation**: Implement Phase 1 + Phase 2 (~4 days) before launch, defer Phase 3 + Phase 4 to post-launch patches.

---

## Supporting Documentation

See also:
- **C++_MODULE_ANALYSIS.md**: Deep-dive per-system breakdown
- **C++_IMPLEMENTATION_ACTIONS.md**: Task-by-task implementation guide with code samples

