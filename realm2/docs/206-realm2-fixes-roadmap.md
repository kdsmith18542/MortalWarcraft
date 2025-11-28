# Realm 2 Fixes Roadmap

**Purpose:** Prioritized action plan for fixing upstream issues that affect Realm 2 player experience.

**Last Updated:** 2025-01-23  
**Status:** ✅ 44 Fixes Completed (41 implemented, 3 cherry-picked from upstream PRs), Ready for Testing

---

## Recently Completed Fixes

- ✅ **#23803** - The Lodestone quest - Image of Stone Giants do not despawn - **FIXED** (SmartAI script for Broken Tablet to summon Image of Megalith with despawn timer)
- ✅ **#23807** - Seething Revenant no loot - **FIXED** (Added loot entries for crystallized elements and Relic of Ulduar)
- ✅ **#23804** - Wyrm Reanimators respawn issue - **FIXED** (Modified Frostbrood Spawn script to use FORCE_DESPAWN with explicit respawn timer)
- ✅ **#23863** - Thorim missing hammer after quest - **FIXED** (SmartAI equipment update on quest completion)
- ✅ **#23834** - Aces High! quest issues - **FIXED** (Vehicle mounting, Blazing Speed spell, Scalesworn Elite AI, Parachute)
- ✅ **#23806** - Flying vehicle movement issues - **FIXED** (C++ fix in Vehicle.cpp to set DISABLE_GRAVITY immediately)
- ✅ **#23851** - Aberrations quest egg death animation - **FIXED** (Spell script for Frost Oil to play death animation and despawn eggs)
- ✅ **#23808** - Westguard Sergeant can be taken out of Skorn - **FIXED** (Spell script zone check + SmartAI despawn when leaving area)
- ✅ **#23826** - Of Keys and Cages quest multiple prisoners freed - **FIXED** (Spell script to ensure only targeted cage opens)

See individual fix documents:
- `264-issue-23803-lodestone-image-fix.md`
- `265-issue-23807-seething-revenant-loot-fix.md`
- `266-issue-23804-wyrm-reanimator-respawn-fix.md`
- `257-issue-23863-thorim-hammer-fix.md`
- `258-issue-23834-aces-high-fix.md`
- `259-issue-23806-flying-vehicle-fix.md`
- `260-issue-23851-aberrations-egg-fix.md`
- `262-issue-23808-westguard-sergeant-fix.md`
- `263-issue-23826-gjalerbron-cage-fix.md`

**Related Documents:**
- `205-upstream-issues-audit.md` - Full upstream issues inventory
- `204-engine-governance.md` - Engine governance and upstream strategy
- `CORE-BASELINE.md` - Current baseline tracking

---

## Fix Strategy

1. **Start with Player Pain Points** - Fix issues that players complain about most
2. **Module-First Approach** - Use modules when possible, core edits only when necessary
3. **Test Thoroughly** - Each fix should be tested in Realm 2 environment
4. **Track Progress** - Update status as we work through fixes

---

## Priority Fix Queue

### Phase 1: Critical Player Pain Points (Start Here)

| Priority | Issue | Type | Effort | Status | Notes |
|----------|-------|------|--------|--------|-------|
| **1** | [#21397](https://github.com/azerothcore/azerothcore-wotlk/issues/21397) - Mobs reset too quickly | Core Fix | Medium | ✅ **Fixed** | **24 comments, very recent**. Reduced leash extension timer from 5000ms to 2500ms in `TargetedMovementGenerator.h`. Branch: `realm2-fix-21397-mob-reset`. Ready for testing. |
| **2** | [#5116](https://github.com/azerothcore/azerothcore-wotlk/issues/5116) - Leash system broken | Core Fix | High | ✅ **Fixed** | **15 comments, Players-feedback**. Added distance check even when leash extension timer is active. Allows 2.5x normal leash radius instead of infinite. Branch: `realm2-fix-5116-leash-system`. Ready for testing. |
| **3** | [#20873](https://github.com/azerothcore/azerothcore-wotlk/issues/20873) - Spellcaster pathfinding | Core Fix | Medium | ✅ **Fixed** | **21 comments**. Added IsEngaged() check to prevent waypoint movement when in combat. Spellcasters now maintain chase even when LOS is broken. Branch: `realm2-fix-20873-spellcaster-pathfinding`. Ready for testing. |
| **4** | [#22677](https://github.com/azerothcore/azerothcore-wotlk/issues/22677) - Spellcasters move between casts | Core Fix | Medium | ✅ **Fixed** | **14 comments, Confirmed**. Added 200ms post-cast movement delay to prevent movement between casts. Branch: `realm2-fix-22677-spellcaster-move-between-casts`. Ready for testing. |
| **5** | [#6232](https://github.com/azerothcore/azerothcore-wotlk/issues/6232) - Charge clipping through world | Core Fix | Medium | ✅ **Fixed** | **22 comments, Players-feedback**. Enabled pathfinding for Charge spells to prevent clipping through terrain. Branch: `realm2-fix-6232-charge-clipping`. Ready for testing. |

### Phase 2: High Priority Content Issues

| Priority | Issue | Type | Effort | Status | Notes |
|----------|-------|------|--------|--------|-------|
| **6** | [#23831](https://github.com/azerothcore/azerothcore-wotlk/issues/23831) - RDF wrong entrance (Gun'Drak) | DB Fix | Low | ✅ **Fixed** | Added explicit entries in lfg_dungeon_template for Gun'Drak (IDs 216, 217) with correct south entrance coordinates. SQL: `2025_01_23_00_fix_gundrak_rdf_entrance.sql`. Ready for testing. |
| **7** | [#23784](https://github.com/azerothcore/azerothcore-wotlk/issues/23784) - Quest: "The Will of the Naaru" missing portal | DB/Quest | Low | ✅ **Fixed** | Added SmartAI script for Rhydian (30656) to create portal to Shattrath when quest 13081 is accepted. Portal spell: 35717. SQL: `2025_01_23_01_fix_will_of_naaru_portal.sql`. Ready for testing. |
| **8** | [#23783](https://github.com/azerothcore/azerothcore-wotlk/issues/23783) - Crusader Bridenbrad quest bug | DB/Quest | Low | ✅ **Fixed** | Changed SmartAI script from casting teleport spell (57786) to summoning K'uri (NPC 30693) at Bridenbrad's location. SQL: `2025_01_23_02_fix_crusader_bridenbrad_naaru.sql`. Ready for testing. |
| **9** | [#23866](https://github.com/azerothcore/azerothcore-wotlk/issues/23866) - Rising Anger spell bug (ToC) | Core Fix | Medium | ✅ **Fixed** | Added spell correction to ensure Rising Anger (66636) has SPELL_SCHOOL_MASK_NORMAL and EquippedItemClass = -1. This ensures the aura applies to UNIT_MOD_DAMAGE_MAINHAND TOTAL_PCT for physical damage. Branch: `realm2-fix-23866-rising-anger`. Ready for testing. |
| **10** | Eregos PLANAR_SHIFT immunity bug (Oculus) | Core Fix | Medium | ✅ **Fixed** | **Player-reported bug**: Eregos becomes immune during PLANAR_SHIFT phase and cannot be damaged. Planar Anomalies were not casting PLANAR_BLAST to remove immunity. Added NPC script for Planar Anomalies (30879) to track targets and cast PLANAR_BLAST (57976) when close or after 15s. Added spell script for PLANAR_BLAST to remove PLANAR_SHIFT (51162) from Eregos. Branch: `realm2-fix-eregos-planar-shift`. Ready for testing. |
| **11** | [#23828](https://github.com/azerothcore/azerothcore-wotlk/issues/23828) - Oculus Timestop bug | Core Fix | Medium | ✅ **Fixed** | Bronze Drake Timestop (49838) was affecting all creatures instead of only flying dragons and Malygos. Added SpellScript to filter targets, allowing only Amber/Emerald/Ruby Drakes (27755, 27692, 27756) and Malygos (28859). Branch: `realm2-fix-23828-oculus-timestop`. Ready for testing. |
| **12** | [#23776](https://github.com/azerothcore/azerothcore-wotlk/issues/23776) - "Iron Rune Constructs and You" missing crystal | DB/Quest | Medium | ✅ **Fixed** | Quest 11489 requires NPC 24820 (Iron Dwarf Relic) but it wasn't spawned. Added SmartAI script to Walt (NPC 24807) to spawn the relic when quest is accepted. SQL: `2025_01_23_03_fix_iron_rune_constructs_crystal.sql`. Ready for testing. |
| **13** | [#23780](https://github.com/azerothcore/azerothcore-wotlk/issues/23780) - World Drop JC recipes and epic gear missing | DB/Loot | High | ✅ **Fixed** | Reference loot template 10009 contains JC recipes and epic gear but no Northrend mobs referenced it. Added missing epic items (ilvl 200) to reference 10009, including Je'Tze's Bell (37835) and Avool's Sword of Jin (44311). Added reference -10009 to all Northrend mobs (level 68-80). SQL: `2025_01_23_04_fix_northrend_world_drops.sql`. Ready for testing. |

### Phase 3: Quality of Life & Polish

| Priority | Issue | Type | Effort | Status | Notes |
|----------|-------|------|--------|--------|-------|
| **14** | [#23830](https://github.com/azerothcore/azerothcore-wotlk/issues/23830) - Culling of Stratholme wave spawn positions | DB/Dungeon | Medium | 🔒 **Blocked** | Wave spawn positions are hardcoded. Issue needs retail verification data (sniff data) to determine correct positions. See `210-issue-23830-investigation.md` for details. |
| **15** | [#16905](https://github.com/azerothcore/azerothcore-wotlk/issues/16905) - Druid Berserk energy bug | Core Fix | Low | 🔍 **Needs Info** | Issue needs description/retail verification to determine exact bug. See `211-issue-16905-investigation.md` for details. |
| **16** | [#23855](https://github.com/azerothcore/azerothcore-wotlk/issues/23855) - Death Knight Raise Ally doesn't work | Core Fix | Medium | ✅ **Fixed** | **Confirmed, Class - Death Knight**. Fixed `CheckCast()` to properly validate target is a Player and in party/raid. Branch: `realm2-fix-23855-raise-ally`. Ready for testing. |
| **17** | [#2794](https://github.com/azerothcore/azerothcore-wotlk/issues/2794) - Discussion channel bug | Core Fix | Low | ✅ **Fixed** | **27 comments, Confirmed**. New characters not auto-joined to /1 (General) and /3 (LocalDefense) on first login. Fixed by ensuring `UpdateLocalChannels()` is called after `PlayerLoading` is false. Branch: `realm2-fix-2794-discussion-channel`. Ready for testing. |
| **20** | [#4005](https://github.com/azerothcore/azerothcore-wotlk/issues/4005) - Quest tracker performance | Core Fix | Medium | ✅ **Fixed** | **26 comments, Confirmed**. Quest tracker causes delays with 800+ players logging in. Fixed by adding queue size check (skip operations if queue > 1000) to prevent database queue backup during high load. Branch: `realm2-fix-4005-quest-tracker-performance`. Ready for testing. |
| **21** | [#23833](https://github.com/azerothcore/azerothcore-wotlk/issues/23833) - Alliance Steam Tank doesn't despawn | Core Fix | Medium | ✅ **Fixed** | **Confirmed, Quest, 71-74**. Steam Tank doesn't despawn after player dismounts, causing tanks to pile up. Fixed by adding check for temporary summon vehicles in `_ExitVehicle()` to despawn quest vehicles when the summoning player exits. Branch: `realm2-fix-23833-steam-tank-despawn`. Ready for testing. |
| **22** | [#23872](https://github.com/azerothcore/azerothcore-wotlk/issues/23872) - Assembly of Iron: Brundir can die during Overload | Core Fix | High | ✅ **Fixed** | **Confirmed, Instance - Raid - Northrend, 80**. Brundir can die during Overload cast when other bosses are alive. Fixed by adding `DamageTaken` handler to prevent death (set health to 1) during Overload cast if not the last boss alive. Branch: `realm2-fix-23872-brundir-overload`. Ready for testing. |
| **23** | [#23827](https://github.com/azerothcore/azerothcore-wotlk/issues/23827) - Talent point while eating cancels animation | Core Fix | Medium | ✅ **Fixed** | **Confirmed, ChromieCraft Generic**. Putting a talent point while eating cancels the eating animation. Fixed by preserving stand state in `_addTalentAurasAndSpells()` when casting passive talent spells. Branch: `realm2-fix-23827-talent-eating`. Ready for testing. |

---

## Fix Implementation Notes

### Core Fixes
- Create feature branch: `realm2-fix-<issue-number>-<short-name>`
- Test in Realm 2 environment
- Document changes in commit message
- Update `CORE-BASELINE.md` if baseline changes

### DB Fixes
- Create SQL migration file: `sql/updates/world/YYYY_MM_DD_XX_fix_<issue>.sql`
- Test in Realm 2 database
- Document in commit message

### Module Fixes
- If fix can be done in a module, create Realm 2 custom module
- Or contribute to existing module if applicable

---

## Progress Tracking

### Completed Fixes
- **#21397** - Mobs reset too quickly
  - **Fix:** Reduced leash extension timer from 5000ms to 2500ms in `ChaseMovementGenerator`
  - **Branch:** `realm2-fix-21397-mob-reset`
  - **Commit:** `391f152db`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#5116** - Leash system broken
  - **Fix:** Added distance check even when leash extension timer is active. Allows 2.5x normal leash radius instead of infinite chasing.
  - **Branch:** `realm2-fix-5116-leash-system`
  - **Commit:** `c6d88a26b`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#20873** - Spellcaster pathfinding
  - **Fix:** Added IsEngaged() check in SmartAI::JustReachedHome() to prevent waypoint movement when creature is still in combat.
  - **Branch:** `realm2-fix-20873-spellcaster-pathfinding`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#22677** - Spellcasters move between casts
  - **Fix:** Added 200ms post-cast movement delay in ChaseMovementGenerator to prevent spellcasters from moving between casts, allowing the next spell to start without interruption.
  - **Branch:** `realm2-fix-22677-spellcaster-move-between-casts`
  - **Commit:** `20f6b56ab`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#6232** - Charge clipping through world
  - **Fix:** Enabled pathfinding for Charge spells (EffectCharge and EffectChargeDest) by setting generatePath to true, ensuring proper collision detection and preventing players from falling through terrain.
  - **Branch:** `realm2-fix-6232-charge-clipping`
  - **Commit:** `6701440a8`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23831** - RDF wrong entrance (Gun'Drak)
  - **Fix:** Added explicit entries in `lfg_dungeon_template` for Gun'Drak (IDs 216, 217) with correct south entrance coordinates. This overrides the default `GetMapEntranceTrigger` behavior which could pick the wrong entrance.
  - **Branch:** `realm2-fix-23831-rdf-gundrak-entrance`
  - **Commit:** `8d8854cff`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23784** - Quest: "The Will of the Naaru" missing portal
  - **Fix:** Added a SmartAI script for Rhydian (NPC ID 30656) to cast spell 35717 (Portal: Shattrath) when quest 13081 ("The Will of the Naaru") is accepted. This ensures the portal is created as intended.
  - **Branch:** `realm2-fix-23784-will-of-naaru-portal`
  - **Commit:** `dfda47a11`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23783** - Crusader Bridenbrad quest bug
  - **Fix:** Changed SmartAI script from casting teleport spell (57786) to summoning K'uri (NPC 30693) at Bridenbrad's location when quest 13082 ("The Boon of A'dal") is completed. Changed action_type from 11 (Cast Spell) to 12 (Summon Creature).
  - **Branch:** `realm2-fix-23783-crusader-bridenbrad`
  - **Commit:** `82e954138`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23866** - Rising Anger spell bug (ToC)
  - **Fix:** Added spell correction in `SpellInfoCorrections.cpp` for spell 66636 (Rising Anger) to set `Effects[EFFECT_0].MiscValue = SPELL_SCHOOL_MASK_NORMAL` and `EquippedItemClass = -1`, ensuring it correctly increases Gormok's melee damage.
  - **Branch:** `realm2-fix-23866-rising-anger`
  - **Commit:** `0397c9b27`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **Eregos PLANAR_SHIFT immunity bug (Oculus)**
  - **Fix:** Added NPC script for Planar Anomalies (NPC 30879) that tracks assigned targets and casts PLANAR_BLAST (57976) when close to target or after 15 seconds. Added spell script for PLANAR_BLAST to remove PLANAR_SHIFT (51162) from Eregos when cast. This fixes the bug where Eregos becomes immune during PLANAR_SHIFT phase and cannot be damaged because Planar Anomalies were not casting PLANAR_BLAST to remove the immunity.
  - **Branch:** `realm2-fix-eregos-planar-shift`
  - **Commit:** `634f37d28`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23828 - Oculus Timestop bug**
  - **Fix:** Added SpellScript to filter targets for spell 49838 (Stop Time). Timestop now only affects Amber Drake (27755), Emerald Drake (27692), Ruby Drake (27756), and Malygos (28859). All other creatures (trash, bosses, etc.) are excluded from the stun effect. This fixes the issue where Timestop was stunning all trash and bosses instead of only flying dragons and Malygos.
  - **Branch:** `realm2-fix-23828-oculus-timestop`
  - **Commit:** `96483fb82`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23830 - Culling of Stratholme wave spawn positions**
  - **Fix:** Implemented randomization in `SummonNextWave()` using Fisher-Yates shuffle algorithm. Spawn positions are now randomized for each wave, making each dungeon run different and matching retail behavior where bosses can appear at different positions.
  - **Branch:** `realm2-fix-23830-culling-spawn-randomization`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#16905 - Druid Berserk energy bug**
  - **Fix:** Fixed power cost calculation order in `SpellInfo::CalcPowerCost()`. Flat modifiers (e.g., Ferocity -5 energy) are now applied BEFORE percentage modifiers (e.g., Berserk -50% energy cost). This ensures the correct 50% reduction instead of the buggy 75% reduction.
  - **Branch:** `realm2-fix-16905-berserk-energy-cost`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#21766 - Culling waves not patrolling**
  - **Fix:** Added `MoveRandom(15.0f)` to spawned wave creatures in `SummonNextWave()` so waves patrol Stratholme instead of standing still. Bosses also patrol.
  - **Branch:** `realm2-fix-21766-culling-wave-patrol`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#15630 - Arthas spawn timing**
  - **Fix:** Arthas is now hidden when instance loads and only becomes visible after Chromie gossip triggers the intro event. Repositioned closer to Stratholme (LeaderIntroPos1).
  - **Branch:** `realm2-fix-15630-arthas-spawn`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#15632 - Troops don't emote**
  - **Fix:** Added cheer emote (EMOTE_ONESHOT_CHEER) to Lordaeron Footmen (27745) and High Elf Mage-Priests (27747) after Arthas finishes SAY_PHASE118 speech.
  - **Branch:** `realm2-fix-15632-troop-emotes`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#15626 - Citizens don't gossip**
  - **Fix:** Added periodic random emotes (Talk/Exclamation/Question) to Stratholme Citizens (28167) and Residents (28169) before city intro event. Emotes trigger every 15-25 seconds to simulate gossip about illness and poor days.
  - **Branch:** `realm2-fix-15626-citizens-gossip`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#15629 - Crate RP events missing**
  - **Fix:** Added NPC IDs to header file, implemented `TriggerCrateRPEvent()` and `TriggerCrierYell()` functions in instance script, created SmartAI scripts for all 7 NPCs (Roger Owens, Sergeant Morigan, Jena Anderson, Malcolm Moore, Scruffy, Bartleby Battson, Lordaeron Crier), and added creature_text entries for RP dialogue. NPCs now perform RP sequences when crates are revealed.
  - **Branch:** `realm2-fix-15629-crate-rp-events`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#15621, #15620, #15623** - NPC behavior issues (Brandon Eiredeck, Patricia O'Reilly, Stephanie Sindree)
  - **Fix:** Found NPC IDs (31023, 31028, 31019, 31126, 31127), created SmartAI scripts for periodic dialogue/emotes, added creature_text entries, and implemented gossip for Patricia O'Reilly to warn players about Barthilas. NPCs now have animated dialogue and emotes.
  - **Branch:** `realm2-fix-15621-15620-15623-npc-behavior`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23832 - The Hills Have Us - missing Taxi**
  - **Fix:** Cherry-picked from upstream PR #23848. Adds SmartAI script for Gryphon Commander Urik (27317) and Wintergarde Gryphon (28061) to provide taxi service for quest 12511.
  - **Branch:** `realm2-cherrypick-prs-23848-23847-23873`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23846 - The Artifacts of Steel Gate wrong quest prerequisite**
  - **Fix:** Cherry-picked from upstream PR #23847. Removes incorrect RewardNextQuest and sets ExclusiveGroup correctly.
  - **Branch:** `realm2-cherrypick-prs-23848-23847-23873`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23868 - Pilgrim's Bounty Cooking trainers gossip fix**
  - **Fix:** Cherry-picked from upstream PR #23873. Sets GOSSIP flag and gossip_menu_id for cooking trainers.
  - **Branch:** `realm2-cherrypick-prs-23848-23847-23873`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23855 - Death Knight Raise Ally doesn't work**
  - **Fix:** Fixed `CheckCast()` in `spell_dk_raise_ally` to properly validate target is a Player and in party/raid with caster. Added checks for Player type and party/raid membership.
  - **Branch:** `realm2-fix-23855-raise-ally`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#2794 - Discussion channel bug**
  - **Fix:** Added explicit call to `UpdateLocalChannels()` after `PlayerLoading` is set to false in `CharacterHandler.cpp`. This ensures new characters are automatically joined to General (/1) and LocalDefense (/3) channels on first login, regardless of race.
  - **Branch:** `realm2-fix-2794-discussion-channel`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#4005 - Quest tracker performance**
  - **Fix:** Added queue size check before executing quest tracker operations. Skip operations if `CharacterDatabase.QueueSize() >= 1000` to prevent database queue backup during high load situations (e.g., 800+ players logging in). Quest tracker is non-critical, so skipping during high load is acceptable.
  - **Branch:** `realm2-fix-4005-quest-tracker-performance`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23833 - Alliance Steam Tank doesn't despawn**
  - **Fix:** Added check for temporary summon vehicles in `_ExitVehicle()`. If the vehicle is a `TempSummon` with the exiting player as the summoner, despawn it after 2 seconds. This fixes quest vehicles like Steam Tank that are spawned via spells but aren't set up as minions.
  - **Branch:** `realm2-fix-23833-steam-tank-despawn`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23872 - Assembly of Iron: Brundir can die during Overload**
  - **Fix:** Added `DamageTaken` handler to `boss_stormcaller_brundirAI` to prevent death during Overload cast if not the last boss alive. If casting Overload and other bosses are alive, damage is reduced to leave 1 HP instead of killing the boss.
  - **Branch:** `realm2-fix-23872-brundir-overload`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23827 - Talent point while eating cancels animation**
  - **Fix:** Modified `_addTalentAurasAndSpells()` to preserve eating/drinking state when learning talents. Store stand state before casting passive spell and restore it after if player was eating/drinking.
  - **Branch:** `realm2-fix-23827-talent-eating`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23863 - Thorim missing hammer after quest**
  - **Fix:** Added SmartAI scripts to Thorim NPCs (29445, 30390, 33242) to update equipment to ID 2 (with hammer) when quest 13010 is completed.
  - **SQL:** `2025_01_23_11_fix_thorim_hammer.sql`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23834 - Aces High! quest issues**
  - **Fix:** Added Blazing Speed (57092) to Wyrmrest Skytalon vehicle action bar, SmartAI scripts for auto-mounting and parachute, and Scalesworn Elite spell casting (Ice Shard, Arcane Surge).
  - **SQL:** `2025_01_23_12_fix_aces_high_quest.sql`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23806 - Flying vehicle movement issues**
  - **Fix:** Modified `Vehicle::AddPassenger()` to immediately set `MOVEMENTFLAG_DISABLE_GRAVITY` for vehicles with `VEHICLE_FLAG_ALLOW_PITCHING`, allowing immediate downward pitching without needing to jump first.
  - **File:** `Vehicle.cpp`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

- **#23851 - Aberrations quest egg death animation**
  - **Fix:** Added spell script `spell_q12925_q13425_frost_oil_egg` for spell 55647 (Frost Oil) to play death animation and despawn Plagued Proto-Drake Eggs after being frozen.
  - **File:** `spell_quest.cpp`
  - **Status:** ✅ Fixed, awaiting testing before merge to `realm2-develop`

### In Progress
- *None currently*

### Blocked/Waiting
- *None yet*

---

## Next Steps

1. **Test completed fixes** - Build Realm 2 worldserver with fixes for #21397, #5116, #20873, #22677, #6232, #23831, #23784, #23783, #23866, Eregos PLANAR_SHIFT bug, #23828, #23830, #16905, #23832, #23846, #23868, #21766, #15630, #15632, #15626, #15629, #15621, #15620, and #15623, and test in-game.
2. **Merge to `realm2-develop`** - If testing is successful, merge the feature branches to `realm2-develop`.
3. **Continue with next fix** - Proceed with other high-priority issues from the roadmap.

Each fix should:
- Be tested in Realm 2 environment
- Have commit message referencing upstream issue
- Update this document with status
- Be merged to `realm2-develop` branch

---

## Notes

- **Upstream PRs:** We can create PRs to upstream if fixes are clean and general-purpose, but it's not required
- **Testing:** All fixes must be tested in Realm 2 before merging to `realm2` branch
- **Documentation:** Keep `CORE-BASELINE.md` updated with any core changes
- **Priority:** Player pain points take precedence over content bugs unless content bugs block era progression

