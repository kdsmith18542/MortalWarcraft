# Specs 31-85: Reality Check

**Date:** 2025-01-XX  
**Finding:** Many specs marked as "complete" only have SQL tables, not actual C++ implementations

---

## Summary

**Total Specs 31-85:** 55 specs

### Breakdown

- **SQL Only (no code):** ~20 specs
  - These have database tables but no C++ or Lua implementations
  - Marked as "complete" but functionality is missing
  
- **No Implementation:** 14 specs
  - Completely unstarted
  
- **Has Actual Code:** ~21 specs
  - Real C++ implementations exist

---

## Specs with Only SQL (No Code)

These specs are marked "complete" but only have database tables:

1. **32-npc-and-encounter-rebalance** - SQL table only
2. **35-mortal-pvp-vendors-and-rewards** - SQL table only
3. **38-social-and-onboarding-systems** - SQL table only
4. **40-anti-bot-rmt-and-security** - SQL table only
5. **42-gm-tools-and-live-events** - SQL tables only
6. **45-eldens-eve-layer** - SQL table only
7. **47-mentoring-and-build-loadouts** - SQL table only
8. **50-lifeskills-fishing-and-first-aid** - SQL table only
9. **51-factions-and-standing-system** - SQL table only
10. **52-season-of-the-frontier** - SQL table only
11. **53-rune-augments-and-gear-build-system** - SQL table only
12. **54-endless-contracts-defense-and-survival** - SQL table only
13. **55-build-presets-and-loadouts** - SQL table only
14. **56-negative-titles-and-notoriety-labels** - SQL table only
15. **57-appearance-codex-and-transmog** - SQL table only
16. **58-world-contracts-and-map-pins** - SQL table only
17. **59-shrine-and-faction-trials** - SQL table only
18. **61-weapon-legacy-and-history** - SQL table only
19. **63-quest-conversion-strategy** - SQL table only

**Issue:** Having a SQL table doesn't mean the feature works. These need C++ implementations.

---

## Specs with NO Implementation

1. **36-mortal-achievements-and-titles-core** - Design doc only
2. **62-core-lore-and-campaign-skeleton** - Design doc only
3. **64-spell-and-ability-library** - Not started
4. **65-endgame-rhythm-and-lockouts** - Not started
5. **66-legacy-services-and-qol** - Not started
6. **71-act3-the-four-bargains-quest-pack** - Not started
7. **73-act5-endgame-campaign-the-lost-crown** - Not started
8. **74-cursed-artifacts-and-extraction-system** - Not started
9. **77-mortal-itemization-t1-t2-starter-sets** - Design doc only
10. **78-mortal-itemization-healer-ranger-mage** - Not started
11. **79-drop-mapping-t1-t2-gear-and-runes** - Not started
12. **80-content-lane-frontier-bruiser-quest-and-loot-bundle** - Not started
13. **81-archon-and-staff-chat-tags-eluna-spec** - Not started
14. **82-mortal-autobroadcast-pack.sql** - Not started

---

## Specs with Actual C++ Code

These have real implementations:

1. **31-mortal-core-registry** - Partial (mentions only)
2. **33-instance-and-battleground-tier-mapping** - Has C++ files
3. **34-mortal-arena-and-rating** - Has C++ files
4. **37-economy-system-extensions** - Has C++ files
5. **39-navigation-and-wayfinding** - Has C++ files
6. **41-telemetry-and-balancing** - Has C++ files
7. **43-long-term-progression-and-seasons** - Mentions only
8. **44-accessibility-and-ux-guidelines** - Mentions only
9. **46-public-grouping-and-contribution** - Has C++ files
10. **48-zone-invasions-and-cross-faction-pve** - Has C++ files
11. **49-webportal-wiki-spec** - Has webportal code
12. **60-faction-sanctums** - Has C++ files
13. **67-conversion-automation-plan** - Has C++ files
14. **68-prologue-and-act1-quest-pack** - Has C++ files
15. **69-faction-intro-chains-ledger-and-shrine** - Has Lua files
16. **70-act2-price-of-life-quest-pack** - Has C++ files
17. **72-act4-strongholds-and-invasions-campaign** - Has C++ files
18. **75-mortal-gear-and-runes-spec** - Has C++ files
19. **76-dynamic-tasks-and-contracts-2-0-spec** - Has C++ files
20. **83-mortal-event-broadcasts.sql-and-eluna** - Has C++ files

---

## Key Finding

**The verification script is too lenient.** It marks specs as "complete" if they have SQL tables, even if there's no actual functionality implemented.

**Reality:**
- ~20 specs have SQL tables but no code
- 14 specs have nothing at all
- Only ~21 specs have actual C++ implementations

**Recommendation:** Update verification script to require C++ code for "complete" status, not just SQL tables.

