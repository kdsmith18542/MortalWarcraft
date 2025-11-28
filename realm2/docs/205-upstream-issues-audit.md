# Realm 2 Upstream Issues Audit

**Purpose:** Track and prioritize AzerothCore upstream issues that affect Realm 2 (Mortal Warcraft: Legacy Journey).

**Last Updated:** 2025-01-23  
**Status:** 🔄 In Progress - Initial Population

**AzerothCore Issues:** https://github.com/azerothcore/azerothcore-wotlk/issues

---

## Audit Process

1. **Review AzerothCore Issues** - Search and categorize by:
   - Severity: `Crash/Exploit`, `Blocker`, `Major`, `Minor`, `Cosmetic`
   - Impact: `Era Progression`, `Content`, `Economy`, `Stability`, `Irrelevant`
   - Area: `LFG/RDF`, `BGs`, `Raids`, `Dungeons`, `Quests`, `Auction House`, `Instance Lockouts`, etc.

2. **Prioritize** - Sort by:
   - **P0 (Critical - Fix Before Launch):**
     - Crashes
     - Exploits (dupes, infinite loot, lockout bypass)
     - Economy-destroying bugs
   - **P1 (High - Fix Soon):**
     - Progression blockers (raids, quests)
     - Era progression issues
     - RDF/LFG system bugs
   - **P2 (Medium - Fix Post-Launch):**
     - Content bugs (non-blocking)
     - Minor blizzlike correctness
   - **P3 (Low - Nice to Have):**
     - Cosmetic issues
     - Minor polish

3. **Track Status** - For each issue:
   - `Not Started` - Identified but not addressed
   - `In Progress` - Being worked on
   - `Fixed` - Resolved in our fork
   - `Upstream Fixed` - Fixed in upstream, need to pull
   - `Won't Fix` - Not relevant to Realm 2

---

## Critical Issues (P0 - Fix Before Launch)

| ID | Title | Severity | Impact | Area | Status | Notes |
|----|-------|----------|--------|------|--------|-------|
| - | *No critical crashes/exploits found in initial audit* | - | - | - | - | Continue monitoring for new issues |

---

## Player Pain Points (High Engagement - Players Hate These Most)

**Note:** These issues have high comment counts and/or the "Players-feedback" label, indicating they significantly frustrate players. Prioritize these even if not strictly blockers.

| ID | Title | Severity | Impact | Area | Status | Notes |
|----|-------|----------|--------|------|--------|-------|
| [#21397](https://github.com/azerothcore/azerothcore-wotlk/issues/21397) | Mobs reset on their own (leash issue) | Major | Content | Combat/AI | Not Started | **24 comments, very recent (Feb 2025)**. Mobs reset too quickly even when being attacked. Makes combat frustrating, especially for hunters/ranged. Active discussion with multiple players reporting same issue. |
| [#5116](https://github.com/azerothcore/azerothcore-wotlk/issues/5116) | Creatures leash system not blizzlike | Major | Content | Combat/AI | Not Started | **15 comments, Players-feedback label, Confirmed**. Makes caves unplayable - mobs chase for 40+ seconds without hitting. Timer-based system broken, purely distance-based. Major frustration for players. |
| [#20873](https://github.com/azerothcore/azerothcore-wotlk/issues/20873) | Spellcasters pathfinding issue during combat | Major | Content | Combat/AI | Not Started | **21 comments, recent (Dec 2024)**. Spellcasters keep patrolling instead of chasing when LOS is broken. Makes ranged classes trivial to cheese. Multiple players confirm issue. |
| [#6232](https://github.com/azerothcore/azerothcore-wotlk/issues/6232) | Warrior/Druid Charge clipping through world | Major | Content | Class/Spells | Not Started | **22 comments, Players-feedback label**. Players fall through terrain when using Charge, causing death. Multiple reports from different zones. Very frustrating for Warriors/Druids. |
| [#22677](https://github.com/azerothcore/azerothcore-wotlk/issues/22677) | [Enemy NPC] List of casters with broken SmartAI, moving between casts | Major | Content | Combat/AI | Not Started | **14 comments, Players-feedback label, Confirmed**. Spellcasters move between casts instead of standing still. Breaks immersion and makes combat feel wrong. |
| [#16905](https://github.com/azerothcore/azerothcore-wotlk/issues/16905) | [Druid] Spell Berserk: energy consumption in feral form | Major | Content | Class/Spells | Not Started | **12 comments, Players-feedback label, Confirmed**. Druid Berserk spell energy consumption bug. Affects class balance and player experience. |
| [#2794](https://github.com/azerothcore/azerothcore-wotlk/issues/2794) | [BUG] discussion channel | Major | Content | Chat/Communication | Not Started | **27 comments, Confirmed**. Discussion channel bug affecting player communication. High engagement indicates widespread frustration. |
| [#4005](https://github.com/azerothcore/azerothcore-wotlk/issues/4005) | enable 'Quests.EnableQuestTracker' option, game delay | Major | Stability | Performance | Not Started | **26 comments**. Quest tracker causes game delay/performance issues. Affects player experience when enabled. |
| [#1688](https://github.com/azerothcore/azerothcore-wotlk/issues/1688) | [EVENT] Operation Gnomeregan (Completely Missing) | Blocker | Content | World Events | Not Started | **24 comments, Confirmed**. Major world event completely missing. Affects immersion and content availability. |

---

## High Priority Issues (P1 - Fix Soon)

| ID | Title | Severity | Impact | Area | Status | Notes |
|----|-------|----------|--------|------|--------|-------|
| [mod-ah-bot#126](https://github.com/azerothcore/mod-ah-bot/issues/126) | Auction House Bot doesn't restock to max limit | Major | Economy | Auction House | Not Started | Bot doesn't restock until server restart/reload. Affects economy stability. May not apply if not using AH bot. |
| [#23784](https://github.com/azerothcore/azerothcore-wotlk/issues/23784) | [Quest][Icecrown] "The Will of the Naaru" lacks portal to Shattrath | Blocker | Content | Quests | Not Started | Quest progression blocker in Icecrown (WotLK content). Affects era progression. |
| [#23783](https://github.com/azerothcore/azerothcore-wotlk/issues/23783) | Crusader Bridenbrad doesn't summon Naaru at end of quest | Blocker | Content | Quests | Not Started | Quest completion blocker. Affects quest chain progression. |
| [#23776](https://github.com/azerothcore/azerothcore-wotlk/issues/23776) | [Quest] "Iron Rune Constructs and You" missing crystal | Blocker | Content | Quests | Not Started | Quest item missing, prevents completion. Progression blocker. |
| [#23780](https://github.com/azerothcore/azerothcore-wotlk/issues/23780) | [Northrend] World Drop JC recipes and epic gear missing | Major | Content | Loot/Drops | Not Started | Affects WotLK era progression. Missing recipes/gear from mobs impacts player progression. |
| *Wintergrasp/VoA* | Wintergrasp: Unable to zone into Vault of Archavon | Blocker | Content | BGs/Raids | Not Started | Players get "unable to zone in while encounter in progress" error. Affects WotLK endgame content. Workaround: disable Wintergrasp or adjust timers. |
| [mod-autobalance#176](https://github.com/azerothcore/mod-autobalance/issues/176) | AutoBalance: NPCs scale up incorrectly in dungeons | Major | Content | Dungeons | Not Started | NPCs scale up even when SkipLowerLevels should prevent it. Affects dungeon difficulty. Only if using mod-autobalance. |
| *Community Reports* | Heroic Dungeon: Level requirement errors | Major | Content | Heroic Dungeons | Not Started | Players report incorrect level requirement errors when entering heroics (e.g., level 80 told needs level 59). May be config issue in dungeon_access_template. |
| [mod-autobalance#79](https://github.com/azerothcore/mod-autobalance/issues/79) | AutoBalance: TBC raids impossible with small groups | Major | Content | Raids | Not Started | Some TBC raid encounters (e.g., Kalecgos in Sunwell) remain impossible even with autobalance. Mechanics require multiple groups. Only if using mod-autobalance. |
| [#23866](https://github.com/azerothcore/azerothcore-wotlk/issues/23866) | Bug: Rising Anger (Spell 66636) Does Not Increase Gormok's Melee Damage | Major | Content | Raids | Not Started | Trial of the Crusader boss mechanic broken. Rising Anger aura applies but doesn't increase damage. Affects raid difficulty. |
| [#23828](https://github.com/azerothcore/azerothcore-wotlk/issues/23828) | [Oculus] Bronze Drake Timestop affects everything | Major | Content | Raids/Dungeons | Not Started | Bronze Drake Timestop stuns all trash and bosses instead of only flying dragons and Malygos. Affects Oculus dungeon/raid mechanics. |
| [#23830](https://github.com/azerothcore/azerothcore-wotlk/issues/23830) | [Culling of Stratholme] Wave spawn positions are fixed | Major | Content | Dungeons | Not Started | Wave spawn positions are incorrect in Culling of Stratholme. Affects dungeon flow. Needs sniff data. |

---

## Medium Priority Issues (P2 - Fix Post-Launch)

| ID | Title | Severity | Impact | Area | Status | Notes |
|----|-------|----------|--------|------|--------|-------|
| [#17800](https://github.com/azerothcore/azerothcore-wotlk/issues/17800) | Mage T4 Set Bonus: Arcane Power permanent cooldown | Major | Content | Class/Spells | Not Started | Using Presence of Mind with T4 4-set causes bug. Affects class balance but not progression. |
| [#1659](https://github.com/azerothcore/azerothcore-wotlk/issues/1659) | Missing class skills in skill panel (except DK) | Minor | Content | UI | Not Started | Skills missing from 'K' panel. UI issue, doesn't block gameplay. |
| [#2687](https://github.com/azerothcore/azerothcore-wotlk/issues/2687) | `.learn all my class` command missing spells | Minor | Content | GM Commands | Not Started | GM command doesn't teach all spells. Admin tool issue, not player-facing. |
| [#23786](https://github.com/azerothcore/azerothcore-wotlk/issues/23786) | Quest item for "Slim Pickings" can be looted at any time | Minor | Content | Quests | Not Started | Quest item lootable without restrictions. Minor exploit, doesn't break progression. |
| [#23785](https://github.com/azerothcore/azerothcore-wotlk/issues/23785) | [Icecrown] Father Kamaros doesn't stop to fight | Minor | Content | Quests | Not Started | NPC behavior issue during quest. May affect quest flow but not blocker. |
| [#23782](https://github.com/azerothcore/azerothcore-wotlk/issues/23782) | Onslaught Gryphon Riders patrol underwater/through walls | Minor | Content | NPCs | Not Started | NPC pathfinding issue. Cosmetic/immersion problem. |
| [#23779](https://github.com/azerothcore/azerothcore-wotlk/issues/23779) | [Quest][Storm Peaks] "Everfrost Chip" low drop rate | Minor | Content | Quests | Not Started | Quest item drop rate issue. May slow progression but not blocker. |
| [#23777](https://github.com/azerothcore/azerothcore-wotlk/issues/23777) | [Quest] Missing completion RP for "I'm Stuck in this Damned Cage" | Minor | Content | Quests | Not Started | Missing roleplay elements. Immersion issue, doesn't affect gameplay. |
| [#23831](https://github.com/azerothcore/azerothcore-wotlk/issues/23831) | [Gun'Drak] RDF spawns you at the wrong entrance | Major | Content | LFG/RDF | Not Started | RDF teleports players to wrong entrance (west instead of east). Affects dungeon flow. Needs sniff data. |
| *Community Reports* | LFG/RDF: Expansion requirement errors | Minor | Content | LFG/RDF | Not Started | Players report "lack required expansion" errors. Often module-related (Individual Progression). Verify if core issue exists. |
| *Community Reports* | BG: Flag interaction failures with playerbots | Minor | Content | BGs | Not Started | Flag interaction issues in BGs when using playerbots. Module compatibility issue, not core. Only if using playerbots. |
| *Community Reports* | Raids: Auto-disbanding issues | Minor | Stability | Raids | Not Started | Reports of raids disbanding unexpectedly. May be related to instance stability or zone lag. Verify if core issue. |
| *Community Reports* | Heroic Dungeons: Playerbot integration issues | Minor | Content | Heroic Dungeons | Not Started | Playerbots have issues entering heroic dungeons/raids (e.g., TOGC Heroic). Module issue, not core. Only if using playerbots. |
| *Community Reports* | Raids: Aura application causing lag | Minor | Stability | Raids | Not Started | Applying auras to all raid members causes server lag and visual errors. May affect custom raid buff implementations. |

---

## Low Priority Issues (P3 - Nice to Have)

| ID | Title | Severity | Impact | Area | Status | Notes |
|----|-------|----------|--------|------|--------|-------|
| [Keira3#2845](https://github.com/azerothcore/Keira3/issues/2845) | Quest editing interface improvements | Cosmetic | Content | Admin Tools | Not Started | Keira3 (admin tool) UI improvement request. Not game server issue. |
| [#12097](https://github.com/azerothcore/azerothcore-wotlk/issues/12097) | Installation failure: SQL import error (duplicate column) | Blocker | Stability | Installation | Not Started | Installation issue. May already be fixed in current baseline. Verify during setup. |
| [#23774](https://github.com/azerothcore/azerothcore-wotlk/issues/23774) | Feature: Search for accounts with deleted characters | Cosmetic | Content | Admin Tools | Not Started | Feature request for admin tools. Nice to have, not critical. |

---

## Search Queries for AzerothCore Issues

Use these GitHub search queries to find relevant issues:

### Critical Searches
- [Crash/Server-breaking issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+label%3Acrash)
- [Exploit issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+label%3Aexploit)
- [Economy-related issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+economy+OR+auction+OR+duplicate+OR+dupe)

### Realm 2 Critical Areas
- [LFG/RDF issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+LFG+OR+RDF+OR+random+dungeon)
- [Battleground issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+BG+OR+battleground)
- [Instance lockout issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+lockout+OR+instance+reset)
- [Raid progression issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+raid+OR+boss+kill)
- [Quest progression issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+quest+OR+leveling)

### General Searches
- [All open issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen)
- [Recently updated issues](https://github.com/azerothcore/azerothcore-wotlk/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)

---

## Notes

- **Audit Started:** 2025-01-23
- **Last Review:** 2025-01-23
- **Next Review:** Weekly or as needed
- **Issues Found:** 36 total (0 P0, 9 Player Pain Points, 12 P1, 13 P2, 3 P3)
- **Note:** Initial audit complete. LFG/RDF, BG, Heroic Dungeons, and Raids reviewed. Most are module-related; core Wintergrasp/VoA issue identified.
- **Player Pain Points:** Added section for high-engagement issues that players complain about most. These should be prioritized for player satisfaction even if not strictly blockers. Top issues: mob leash/reset behavior (#21397, #5116), spellcaster pathfinding (#20873, #22677), Charge clipping (#6232).
- **Module-Related Issues:** Some issues are specific to modules (mod-autobalance, playerbots, Individual Progression). Realm 2 uses mod-autobalance, so those issues are relevant.
- **Heroic/Raid Issues:** Heroic dungeon level requirement errors and raid stability issues need verification. Most other issues are module-related.

---

## How to Use This Document

1. **When reviewing AzerothCore issues:**
   - Add relevant issues to the appropriate priority table
   - Include GitHub issue number, title, and link
   - Classify by severity and impact
   - Add notes about why it matters for Realm 2

2. **When fixing issues:**
   - Update status to "In Progress" or "Fixed"
   - Add notes about the fix (module vs core, commit hash, etc.)

3. **When upstream fixes issues:**
   - Mark as "Upstream Fixed"
   - Note which commit/PR fixed it
   - Plan to pull the fix in next upstream sync

4. **Regular maintenance:**
   - Review new issues weekly
   - Update priorities as needed
   - Remove resolved issues or move to archive

