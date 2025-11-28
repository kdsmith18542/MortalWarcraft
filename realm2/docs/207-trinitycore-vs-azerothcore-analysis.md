# TrinityCore vs AzerothCore Analysis for Realm 2

**Date:** 2025-01-23  
**Purpose:** Evaluate whether switching from AzerothCore to TrinityCore would benefit Realm 2

---

## Current State (AzerothCore)

### What We've Built
- **2 Custom Modules:**
  - `realm2_era_progression` - Complete era progression system (140+ files)
  - `mod_auction_policy_legacy` - Auction house policy system
- **12 Core Fixes Completed:**
  - Leash system fixes (#21397, #5116)
  - Spellcaster AI fixes (#20873, #22677)
  - Charge clipping fix (#6232)
  - Quest fixes (#23784, #23783, #23776)
  - Raid/dungeon fixes (#23866, Eregos, #23828, #23831)
  - Loot table fixes (#23780)
- **Core Edits:**
  - `TargetedMovementGenerator.h/cpp` - Leash and spellcaster movement
  - `Creature.cpp` - Leash distance checks
  - `SmartAI.cpp` - Combat pathfinding
  - `SpellEffects.cpp` - Charge pathfinding
  - `SpellInfoCorrections.cpp` - Spell fixes
  - `boss_eregos.cpp` - Planar Anomaly AI
  - `oculus.cpp` - Timestop spell filtering
- **Database:**
  - Fully configured with era progression tables
  - 12 SQL migration files
  - Reference loot templates configured
- **Infrastructure:**
  - Fork set up: `https://github.com/kdsmith18542/MortalWarcraft`
  - Branch strategy: `realm2`, `realm2-develop`, `realm2-upstream-sync`
  - Baseline pinned and documented
  - Governance strategy established

---

## TrinityCore vs AzerothCore Comparison

### Actual Numbers (2025)

| Metric | AzerothCore | TrinityCore | Difference |
|--------|-------------|-------------|------------|
| **Total Commits** | 16,690 | 44,524 | **2.7x more** |
| **3.3.5 Branch Commits** | ~16,690 | 36,231 | **2.2x more** |
| **Stars** | 7.8k | 10.3k | 1.3x more |
| **Forks** | 3.1k | 6.3k | 2x more |
| **Open Issues** | 2,313 | 1,576 | **Fewer issues** |
| **Contributors** | 538 | 550 | Similar |

### Technical Differences

| Aspect | AzerothCore | TrinityCore |
|--------|-------------|-------------|
| **Origin** | Fork of TrinityCore (2014) | Original project (2008) |
| **Architecture** | More modular, module-first | More monolithic, core-first |
| **Module System** | Well-developed module API | Less modular, more core edits |
| **Code Quality** | Good, but some issues we're fixing | Generally considered more accurate |
| **Blizzlike Accuracy** | Good, but has bugs we're fixing | **Significantly more fixes** |
| **Community** | Active, smaller | Very active, larger |
| **Documentation** | Good module docs | Extensive core documentation |
| **Update Frequency** | Regular updates | Regular updates |
| **Fix History** | 16,690 commits | **44,524 commits (2.7x more)** |

### Key Technical Considerations

#### 1. Module System Compatibility
- **AzerothCore:** Our modules use AzerothCore's module API (`ScriptMgr`, `PlayerScript`, `AllMapScript`, etc.)
- **TrinityCore:** Different module system - would require complete rewrite of:
  - `realm2_era_progression` module
  - `mod_auction_policy_legacy` module
- **Impact:** **HIGH** - Complete module rewrite required

#### 2. Core Fix Compatibility
- **AzerothCore:** We've made 12 core fixes
- **TrinityCore:** 
  - Some fixes may already be present
  - Some fixes would need to be re-implemented
  - Code structure is similar but not identical
- **Impact:** **MEDIUM** - Would need to port/re-implement fixes

#### 3. Database Compatibility
- **AzerothCore:** Database structure is mostly compatible
- **TrinityCore:** Database structure is very similar
- **Impact:** **LOW** - SQL migrations should mostly work

#### 4. Script Compatibility
- **AzerothCore:** Scripts use AzerothCore's script system
- **TrinityCore:** Scripts use TrinityCore's script system
- **Impact:** **MEDIUM** - Scripts would need porting

---

## Pros of Switching to TrinityCore

### 1. **Significantly More Fixes** ⚠️ **MAJOR FACTOR**
- **TrinityCore has 2.7x more commits** (44,524 vs 16,690)
- **3.3.5 branch has 2.2x more commits** (36,231 vs ~16,690)
- Many bugs we're fixing may already be fixed in TrinityCore
- **Fewer open issues** (1,576 vs 2,313) suggests better issue resolution
- Better tested by larger community

### 2. **Larger Community**
- More active development
- More contributors
- More bug reports and fixes
- Better long-term support

### 3. **Better Core Quality**
- Generally considered more stable
- Better code organization in some areas
- More comprehensive testing

### 4. **May Have Our Fixes Already**
- Some of the 12 fixes we've made may already be in TrinityCore
- Could save time on re-implementing fixes

### 5. **Better Documentation**
- More extensive core documentation
- Better examples and guides

---

## Cons of Switching to TrinityCore

### 1. **Massive Migration Effort** ⚠️ **CRITICAL**
- **Complete module rewrite required:**
  - `realm2_era_progression` (140+ files) - Complete rewrite
  - `mod_auction_policy_legacy` - Complete rewrite
- **Core fixes need porting:**
  - 12 fixes need to be re-implemented in TrinityCore codebase
  - Code structure differences mean not a simple copy-paste
- **Database migration:**
  - Need to verify all SQL works
  - May need adjustments
- **Configuration:**
  - Different config file formats
  - Need to reconfigure everything
- **Testing:**
  - Complete re-testing of all systems
  - Era progression system needs full validation
- **Estimated Effort:** 2-4 weeks of full-time work

### 2. **Loss of Current Work**
- All current fixes and modules would need to be rebuilt
- Risk of introducing new bugs during migration
- Time investment already made would be partially lost

### 3. **Module System Differences**
- TrinityCore's module system is less developed
- May need to make more core edits instead of modules
- Goes against "modules first" policy

### 4. **Different API**
- Script hooks may be different
- Need to learn new API
- Documentation may not cover our use cases

### 5. **Fork Management**
- Need to set up new fork
- Need to establish new baseline
- Need to rebuild branch strategy

### 6. **Uncertainty**
- Not guaranteed that TrinityCore has all our fixes
- May discover new issues in TrinityCore
- May need to fix different bugs

### 7. **Third-Party Modules**
- Official AzerothCore modules won't work:
  - `mod-eluna` - Different Lua engine
  - `mod-autobalance` - Different API
  - `mod-anticheat` - Different API
  - `mod-costumes`, `mod-transmog` - Different API
- Need to find TrinityCore equivalents or rebuild

---

## Cost-Benefit Analysis

### Migration Cost
- **Time:** 2-4 weeks full-time
- **Risk:** High - could introduce new bugs
- **Opportunity Cost:** Can't work on new features during migration
- **Testing:** Extensive testing required

### Potential Benefits
- **Significantly more fixes:** 2.7x more commits = likely many bugs already fixed
- **Fewer open issues:** 1,576 vs 2,313 suggests better maintenance
- **Larger community:** More support (2x forks, 1.3x stars)
- **Better long-term:** More active development
- **May have our fixes already:** Many of the 12 fixes we've made may already exist

### Current State Assessment
- **AzerothCore is working:** We have a functional system
- **We're fixing issues:** 12 fixes completed, more in progress
- **Modules are working:** Era progression and auction policy are functional
- **We understand the codebase:** Familiar with AzerothCore structure

---

## Recommendation

### **Revised Recommendation: Consider TrinityCore More Seriously** ⚠️

**Updated Assessment:**

**TrinityCore Advantages (More Significant Than Initially Stated):**
1. **2.7x more commits** = likely many bugs already fixed
2. **Fewer open issues** (1,576 vs 2,313) = better maintenance
3. **Larger community** (2x forks, 1.3x stars) = more support
4. **Many of our 12 fixes may already exist** in TrinityCore

**Migration Challenges (Still Valid):**
1. **Too Much Investment Already Made**
   - 2 custom modules (140+ files) - would need complete rewrite
   - 12 core fixes - may already exist, but need to verify
   - Complete infrastructure setup
   - Database configured
   - Fork and branch strategy established

2. **Migration Risk is High**
   - 2-4 weeks of work
   - Risk of introducing new bugs
   - Risk of breaking working systems

3. **Module System Differences**
   - AzerothCore's module system fits our "modules first" policy
   - TrinityCore would require more core edits
   - Our custom modules are well-architected

**Key Question:** Do the benefits of 2.7x more fixes outweigh the 2-4 week migration cost?

### Alternative: Hybrid Approach

If you're concerned about specific issues:

1. **Check if TrinityCore has specific fixes:**
   - Review TrinityCore's issue tracker
   - Check if our fixes are already there
   - Consider cherry-picking specific fixes if they exist

2. **Continue fixing in AzerothCore:**
   - We're making good progress (12 fixes)
   - Continue the current approach
   - Fix issues as we find them

3. **Monitor TrinityCore:**
   - Keep an eye on TrinityCore development
   - Consider switching later if there's a compelling reason
   - Don't switch just because of uncertainty

---

## When to Consider Switching

Consider switching to TrinityCore if:

1. **Critical blocker in AzerothCore:**
   - Unfixable issue that blocks Realm 2
   - TrinityCore has the fix and we can't implement it

2. **Major architectural benefit:**
   - TrinityCore has a feature we absolutely need
   - Can't be implemented in AzerothCore

3. **Community support:**
   - AzerothCore community becomes inactive
   - TrinityCore has significantly better support

4. **After Realm 2 is stable:**
   - If we want to rebuild from scratch later
   - After we've learned from Realm 2 experience

---

## Conclusion

**Revised Recommendation: Investigate TrinityCore Before Deciding**

Given that TrinityCore has **2.7x more commits** and **fewer open issues**, the benefits may be more significant than initially assessed. However, the migration cost (2-4 weeks, high risk) is still substantial.

**Recommended Approach:**

1. **Investigate First** (1-2 days):
   - Check if TrinityCore has fixes for our 12 issues
   - Review TrinityCore's 3.3.5 branch for relevant fixes
   - Check if our custom modules can be ported easily
   - Verify database compatibility

2. **If TrinityCore Has Most Fixes:**
   - Consider migration if >50% of our fixes already exist
   - Migration becomes more cost-effective

3. **If TrinityCore Has Few Fixes:**
   - Stay with AzerothCore
   - Continue fixing issues ourselves
   - The migration cost isn't worth it

**Bottom Line:** The "grass is greener" effect may actually be real here (2.7x more fixes), but we need to verify if those fixes address our specific issues before committing to migration.

**Focus on:**
- Continue fixing issues in AzerothCore
- Improve our modules
- Build Realm 2 features
- Monitor TrinityCore for specific improvements we can cherry-pick

**Revisit this decision if:**
- We hit an unfixable blocker
- TrinityCore has a must-have feature
- AzerothCore community becomes inactive

---

## Questions to Consider

1. **What specific issues are you concerned about?**
   - Are there bugs we can't fix in AzerothCore?
   - Are there features we can't implement?

2. **What's the real problem?**
   - Is it the number of bugs? (We're fixing them)
   - Is it code quality? (We can improve it)
   - Is it community support? (AzerothCore is active)

3. **What's the timeline?**
   - Do we have 2-4 weeks for migration?
   - Can we afford the risk?

4. **What's the goal?**
   - Launch Realm 2? (Stay with AzerothCore)
   - Perfect blizzlike? (Consider TrinityCore later)
   - Learn and experiment? (Either works)

---

**Bottom Line:** Unless there's a specific, unfixable blocker in AzerothCore, the migration cost is too high for the uncertain benefit. Stay with AzerothCore and continue fixing issues.

