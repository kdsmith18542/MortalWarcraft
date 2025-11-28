# Audit Scripts Verification Report

## Summary
All 7 audit scripts are **aligned with spec requirements** but some have **redundancy with existing C++ implementations**. Recommendations provided for each.

---

## 1. systems_audit_class_race.lua

### Spec Requirements
- ✅ **Classless system** (01-progression.md): "No classes. No XP grind."
- ✅ **Mastery Trees replace talents** (01-progression.md): "Mastery Trees replace talents"
- ✅ **Backgrounds replace racials** (00-overview.md): Backgrounds system

### Current C++ Implementation
- `MortalCharacterCreation.cpp`: Purges default spells on character creation
- `PlayerScript_MortalWeaponSkills`: Sets weapon skills to max (400)
- `PlayerScript_MortalLevel`: Enforces stat caps

### Lua Script Functionality
- Clears talent points on login/update
- Removes racial abilities (safety check)
- Blocks talent UI access

### Conflict Analysis
- ⚠️ **Minor redundancy**: Lua runs on every update to clear talent points
- ✅ **Safety layer**: Good as a backup, but inefficient
- **Recommendation**: Keep as safety check, but consider moving to C++ for performance

### Verdict
✅ **ALIGNED** - No conflicts, but could be optimized

---

## 2. systems_audit_death_ghost.lua

### Spec Requirements
- ✅ **Shrine resurrection** (21-elden-systems.md, 22-healing-and-restoration.md): "Charges are only restored to full when player interacts with a Shrine"
- ✅ **No ghost mode** (03-risk-zones.md): Death mechanics use Shrines

### Current C++ Implementation
- `MortalPerformance::HandlePlayerRepop`: Instant respawn at graveyard, strips gear
- `MortalPerformance::CanCastResurrection`: Blocks resurrection in combat, requires Soul Shard

### Lua Script Functionality
- Replaces Spirit Healer gossip with Shrine resurrection
- Implements shrine resurrection cost (1 gold)
- Teleports to nearest Shrine on death

### Conflict Analysis
- ⚠️ **Partial overlap**: C++ handles repop, Lua handles Spirit Healer interaction
- ✅ **Complementary**: Lua provides UI layer for Shrine system
- **Recommendation**: Keep for Spirit Healer replacement, but ensure C++ handles core death logic

### Verdict
✅ **ALIGNED** - Complementary to C++ implementation

---

## 3. systems_audit_economy_mail.lua

### Spec Requirements
- ✅ **No item mailing** (04-economy.md): "Mail is limited to messages (and optionally gold)—items cannot be mailed"
- ✅ **Regional banking** (04-economy.md): "Each city has its own separate bank storage"
- ✅ **No badge vendors** (04-economy.md): Economy is player-driven

### Current C++ Implementation
- `PlayerScript_MortalMailRestriction`: Blocks item attachments (returns false if item != nullptr)
- `PlayerScript_MortalMailbox`: Blocks item sending
- `AuctionHouseScript_MortalRegionalBanking`: Deposits AH items to regional banks

### Lua Script Functionality
- Additional mail validation (quality checks, restriction list)
- Badge vendor blocking
- Honor to Military Credits conversion

### Conflict Analysis
- ⚠️ **Redundant validation**: C++ already blocks all items, Lua adds extra checks
- ✅ **Badge vendor blocking**: Not in C++, useful addition
- ✅ **Honor conversion**: Not in C++, useful addition
- **Recommendation**: Keep badge vendor and honor conversion, remove redundant mail checks

### Verdict
✅ **ALIGNED** - Some redundancy, but adds useful features

---

## 4. systems_audit_flight_paths.lua

### Spec Requirements
- ✅ **Travel restrictions** (03-risk-zones.md): Red zones have travel restrictions
- ✅ **No instant teleports** (18-lfg-warfront-ui.md): "No automatic teleportation"

### Current C++ Implementation
- `MortalTravelRestrictions`: Blocks portal spells, hearthstones, global chat in Red Zones
- No specific flight path blocking in C++

### Lua Script Functionality
- Blocks flight paths based on `mortal_flight_path_overrides` table
- Blocks flight paths that go through Red zones
- Validates flight path usage

### Conflict Analysis
- ✅ **No conflict**: C++ handles spells/items, Lua handles flight paths
- ✅ **Complementary**: Flight paths are a separate system
- **Recommendation**: Keep - fills gap in C++ implementation

### Verdict
✅ **ALIGNED** - No conflicts, fills implementation gap

---

## 5. systems_audit_loot_ui.lua

### Spec Requirements
- ✅ **FFA looting** (03-risk-zones.md): "Red zones: Always full loot"
- ✅ **Damage-based tapping** (03-risk-zones.md): "Any damage tags the creature"
- ✅ **Corpse chests** (03-risk-zones.md): "Corpse chest spawns"

### Current C++ Implementation
- `MortalCombatFlags::GetLootRules`: Returns loot rules based on flag state and zone
- `MortalPerformance::HandlePvPDeath`: Handles PvP death and item dropping
- Zone PvP system handles loot rules

### Lua Script Functionality
- Blocks Need/Greed/DE roll UI
- Overrides grey tapping (level-based) with damage-based tapping
- Validates FFA looting rules

### Conflict Analysis
- ⚠️ **Partial overlap**: C++ handles loot rules, Lua blocks UI rolls
- ✅ **UI blocking**: Useful for client-side enforcement
- ✅ **Tapping override**: Not in C++, useful addition
- **Recommendation**: Keep for UI blocking and tapping override

### Verdict
✅ **ALIGNED** - Complementary, adds UI enforcement

---

## 6. systems_audit_matchmaking.lua

### Spec Requirements
- ✅ **No RDF teleports** (18-lfg-warfront-ui.md): "No automatic teleportation into dungeons"
- ✅ **No BG queues** (18-lfg-warfront-ui.md): "Replacing RDF/BG Finder with non-teleport systems"
- ✅ **No teleports to Red zones** (03-risk-zones.md): Travel restrictions

### Current C++ Implementation
- `SpellScript_MortalMeetingStone`: Blocks Meeting Stone Summon
- `MortalTravelRestrictions`: Blocks portal spells in Red Zones
- No RDF/BG queue blocking in C++

### Lua Script Functionality
- Blocks RDF button (redirects to LFG Panel)
- Blocks BG queue button (redirects to PvP Panel)
- Blocks teleport spells to Red zones
- Blocks teleport items to Red zones

### Conflict Analysis
- ✅ **No conflict**: C++ handles Meeting Stones, Lua handles RDF/BG buttons
- ✅ **Complementary**: UI redirection not in C++
- ⚠️ **Teleport blocking**: May overlap with C++ travel restrictions
- **Recommendation**: Keep for RDF/BG UI redirection, verify teleport blocking doesn't conflict

### Verdict
✅ **ALIGNED** - Complementary, minor potential overlap

---

## 7. systems_audit_progression.lua

### Spec Requirements
- ✅ **No XP** (01-progression.md): "No XP, no quests granting power"
- ✅ **No rested XP** (01-progression.md): Skill-based progression
- ✅ **No combat ratings** (01-progression.md): Custom stat system

### Current C++ Implementation
- `PlayerScript_MortalXP`: Blocks XP gain (OnPlayerGiveXP sets amount to 0)
- `PlayerScript_MortalQuestReward`: Converts quest XP to gold
- `MortalLevelSystem`: Handles skill-based progression

### Lua Script Functionality
- Prevents rested XP accumulation (SetRestBonus(0))
- Validates no rating stats are used
- Disables heirloom XP bonuses

### Conflict Analysis
- ✅ **No conflict**: C++ blocks XP, Lua blocks rested XP
- ✅ **Complementary**: Rested XP blocking not in C++
- ✅ **Safety checks**: Good validation layer
- **Recommendation**: Keep - fills gap in C++ implementation

### Verdict
✅ **ALIGNED** - No conflicts, adds missing functionality

---

## Overall Assessment

### Summary
- ✅ **All scripts align with spec requirements**
- ⚠️ **Some redundancy with C++ implementations** (mail restrictions, loot rules)
- ✅ **Most scripts add complementary functionality** (UI blocking, validation layers)

### Recommendations

1. **Keep all scripts** - They provide safety layers and UI enforcement
2. **Optimize performance-critical ones**:
   - `systems_audit_class_race.lua`: Move talent clearing to C++ (runs on every update)
   - `systems_audit_progression.lua`: Move rested XP blocking to C++ (runs on every update)
3. **Remove redundant checks**:
   - `systems_audit_economy_mail.lua`: Remove item quality checks (C++ already blocks all items)
4. **Verify no double-blocking**:
   - `systems_audit_matchmaking.lua`: Ensure teleport blocking doesn't conflict with C++ travel restrictions

### Priority Actions
1. ✅ **No immediate conflicts** - All scripts are safe to keep
2. ⚠️ **Performance optimization** - Consider migrating update-heavy scripts to C++
3. ✅ **Spec compliance** - All scripts follow spec requirements correctly

---

## Conclusion

**All audit scripts are verified and aligned with spec requirements.** They serve as important safety layers and UI enforcement mechanisms. Some redundancy exists but is acceptable for validation purposes. Performance-critical scripts (those running on every update) should be considered for C++ migration in the future.

