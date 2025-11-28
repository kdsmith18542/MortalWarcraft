# Mortal Warcraft Gap Analysis & Planning Tracker

## Purpose
This document tracks identified gaps, missing information, and planning needs discovered during systematic spec review.

## Review Process
1. Review each spec for:
   - Missing implementation details
   - Unresolved dependencies
   - Incomplete sections (TBD, TODO, placeholder text)
   - Missing data structures/tables
   - Missing formulas or calculations
   - Missing integration points
   - Planning gaps or ambiguities

2. Categorize gaps by:
   - **Critical**: Blocks implementation
   - **High**: Significant impact on design/implementation
   - **Medium**: Needs clarification but workable
   - **Low**: Nice-to-have improvements

3. Track resolution status:
   - **Open**: Gap identified, not yet addressed
   - **In Progress**: Being worked on
   - **Resolved**: Gap addressed
   - **Deferred**: Intentionally left for later

---

## Gap Categories

### 1. Implementation Gaps
Missing technical details needed for implementation

### 2. Design Gaps
Unclear or incomplete design decisions

### 3. Integration Gaps
Missing connections between systems

### 4. Data Model Gaps
Missing tables, fields, or data structures

### 5. Formula/Calculation Gaps
Missing or incomplete mathematical formulas

### 6. Planning Gaps
Areas requiring further planning or decision-making

---

## Identified Gaps

### Critical Gaps (Block Implementation)

#### 1. Missing Hit/Miss Formula (02-combat.md)
- **Location**: `02-combat.md` Section 3.2
- **Issue**: Hit/Miss calculation is described but no actual formula provided
- **Current State**: "Derived from: Player's derived level (1–25), Weapon Mastery skill, Target's Defense. Goal: Level 1 can hit Level 25 with reduced chance, but never '0%'."
- **Gap**: No mathematical formula for hit chance calculation
- **Impact**: Cannot implement combat hit/miss logic
- **Priority**: Critical
- **Status**: Open
- **Recommendation**: Define formula like: `HitChance = BaseHit + (WeaponMastery / 10) - (TargetDefense / 10) + (LevelDiff * 2)`, clamped to [5%, 95%]

#### 2. Incomplete Attribute Clamping Logic (84-mortal-core-stats-and-combat-model.md)
- **Location**: `84-mortal-core-stats-and-combat-model.md` Section 2.1
- **Issue**: Code shows `if (total > 400)` but doesn't specify how to normalize
- **Current State**: Comment says "Optional: normalize down proportionally or apply custom logic. For now, clamp extra from the highest stat(s)."
- **Gap**: No defined algorithm for handling total attribute overflow
- **Impact**: Inconsistent behavior when players exceed 400 total attributes
- **Priority**: Critical
- **Status**: Open
- **Recommendation**: Define proportional reduction algorithm or priority-based clamping

#### 3. Missing Mana Regen Formula (84-mortal-core-stats-and-combat-model.md)
- **Location**: `84-mortal-core-stats-and-combat-model.md` Section 3.1
- **Issue**: States "Regen formulas can be simplified vs vanilla WoW, heavily influenced by SPI" but no formula provided
- **Gap**: No mathematical formula for mana regeneration
- **Impact**: Cannot implement mana regeneration system
- **Priority**: Critical
- **Status**: Open
- **Recommendation**: Define formula like: `ManaRegen = BaseRegen + (SPI * 0.5) + ShrineBonus`, with combat/rest modifiers

#### 4. Missing WeaponSkillBonus and MagicSkillBonus Formulas (84-mortal-core-stats-and-combat-model.md)
- **Location**: `84-mortal-core-stats-and-combat-model.md` Section 3.2
- **Issue**: Formulas reference `WeaponSkillBonus` and `MagicSkillBonus` but don't define how to calculate them
- **Gap**: No conversion from skill points to bonus values
- **Impact**: Cannot calculate AP/SP correctly
- **Priority**: Critical
- **Status**: Open
- **Recommendation**: Define skill-to-bonus conversion, e.g., `WeaponSkillBonus = WeaponMasterySkill / 10` or similar scaling

### High Priority Gaps (Significant Design Impact)

#### 5. Missing Material Multiplier Formula (02-combat.md)
- **Location**: `02-combat.md` Section 3.1
- **Issue**: Damage formula includes `MaterialMultiplier` but no definition provided
- **Gap**: No specification of how material quality affects damage
- **Impact**: Crafted weapon damage scaling unclear
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define material tier multipliers (e.g., Tier 1 = 1.0, Tier 2 = 1.1, Tier 3 = 1.2, etc.)

#### 6. Missing Outlaw Threshold Value (02-combat.md)
- **Location**: `02-combat.md` Section 7.1
- **Issue**: States `Notoriety >= OUTLAW_THRESHOLD (configurable)` but no default value
- **Gap**: No baseline threshold for outlaw state
- **Impact**: Cannot implement outlaw system without arbitrary value
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define default threshold (e.g., 50 or 100 notoriety points) with tuning notes

#### 7. Missing Bounty Pot Calculation Details (02-combat.md)
- **Location**: `02-combat.md` Section 8.1
- **Issue**: States "% of victim's repair bill cost added to Outlaw's bounty pot" but percentage not specified
- **Gap**: No percentage value for bounty accumulation
- **Impact**: Bounty system economics unclear
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define percentage (e.g., 25% or 50% of repair cost) with economic balance notes

#### 8. Incomplete Shrine Order Naming (86-mortal-factions-and-standing.md)
- **Location**: `86-mortal-factions-and-standing.md` Section 110
- **Issue**: Shrine faction names marked as "TBD" (name TBD)
- **Gap**: Faction naming not finalized
- **Impact**: Implementation blocked on naming decisions
- **Priority**: High
- **Status**: Open
- **Recommendation**: Finalize faction names or provide placeholder naming convention

### Medium Priority Gaps (Need Clarification)

#### 9. Placeholder UI Components (17-implementation-roadmap.md)
- **Location**: `17-implementation-roadmap.md` Section 5
- **Issue**: Multiple UI components marked as "placeholder" (hunger_display, encumbrance_display)
- **Gap**: UI design not finalized for core systems
- **Impact**: UI implementation may need rework
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define UI mockups or wireframes for hunger/encumbrance displays

#### 10. Placeholder Contract Data (20-aio-ui-basics.md)
- **Location**: `20-aio-ui-basics.md` Multiple sections
- **Issue**: TODO comments for "replace with real DB query" and placeholder contract examples
- **Gap**: Contract data structure and queries not fully specified
- **Impact**: AIO UI implementation incomplete
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define contract data schema and query patterns

#### 11. Placeholder NPC Entry IDs (20-aio-ui-basics.md)
- **Location**: `20-aio-ui-basics.md` Line 422
- **Issue**: `CONTRACTS_NPC_ENTRY = 123456 -- TODO: your NPC entry id`
- **Gap**: NPC entry IDs not assigned from registry
- **Impact**: Implementation blocked on ID assignment
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Assign IDs from `31-mortal-core-registry.md` and update spec

#### 12. Placeholder Gear Stats (103-mortal-gear-vanguard-bulwark-set-t1-t2.md)
- **Location**: `103-mortal-gear-vanguard-bulwark-set-t1-t2.md` Line 70
- **Issue**: "NOTE: numbers are placeholders; tune per internal balance pass"
- **Gap**: Gear stat values need final tuning
- **Impact**: Gear balance requires playtesting
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Mark for balance pass after initial implementation

### Low Priority Gaps (Nice-to-Have)

#### 13. Placeholder Quest Text (80-content-lane-frontier-bruiser-quest-and-loot-bundle.md)
- **Location**: `80-content-lane-frontier-bruiser-quest-and-loot-bundle.md` Line 166
- **Issue**: "Note: text is placeholder; adapt tone to Mortal style later"
- **Gap**: Quest flavor text needs final polish
- **Impact**: Content polish, not blocking
- **Priority**: Low
- **Status**: Open
- **Recommendation**: Schedule for content polish pass

#### 14. Placeholder Vendor Names (35-mortal-pvp-vendors-and-rewards.md)
- **Location**: `35-mortal-pvp-vendors-and-rewards.md` Line 275
- **Issue**: "Examples (placeholder names you can change later)"
- **Gap**: Vendor naming needs finalization
- **Impact**: Content polish, not blocking
- **Priority**: Low
- **Status**: Open
- **Recommendation**: Schedule for content polish pass

#### 15. Placeholder Healing Spell Tuning (22-healing-and-restoration.md)
- **Location**: `22-healing-and-restoration.md` Line 145
- **Issue**: "This is a starter lineup (tuning numbers are placeholders)"
- **Gap**: Healing spell values need balance tuning
- **Impact**: Balance tuning required post-implementation
- **Priority**: Low
- **Status**: Open
- **Recommendation**: Mark for balance pass after initial implementation

### Integration Gaps

#### 16. Missing Integration Between Combat Formulas and Gear System
- **Location**: Multiple files
- **Issue**: How gear stats integrate with base formulas not fully specified
- **Gap**: Need clear specification of gear stat application order
- **Impact**: Potential inconsistencies in stat calculation
- **Priority**: High
- **Status**: Open
- **Recommendation**: Document stat calculation pipeline: Base → Gear → Runes → Buffs → Clamp

#### 17. Missing Skill Gain Rate Specifications
- **Location**: `01-progression.md`
- **Issue**: Skills increase through usage but no rates specified
- **Gap**: No skill gain formulas or rates defined
- **Impact**: Cannot implement skill progression system
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define skill gain rates per action type (e.g., 1 point per 100 hits, diminishing returns)

### Data Model Gaps

#### 18. Missing Regional Bank Schema Details
- **Location**: `04-economy.md` Section 2.3
- **Issue**: References `character_regional_bank.sql` but schema not fully detailed
- **Gap**: Table structure not specified in detail
- **Impact**: Database implementation unclear
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define full schema with indexes, foreign keys, and constraints

#### 19. Missing Market Stall Schema Details
- **Location**: `04-economy.md` Section 3.4
- **Issue**: References `schema_market_stalls.sql` but schema not fully detailed
- **Gap**: Table structure not specified
- **Impact**: Database implementation unclear
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define full schema for stalls, inventory, and rental system

### Planning Gaps

#### 20. Missing Balance Tuning Framework
- **Location**: Multiple files
- **Issue**: Many values marked as "tune per balance pass" but no framework defined
- **Gap**: No systematic approach to balance tuning
- **Impact**: Ad-hoc balancing may lead to inconsistencies
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Create balance tuning framework document with target metrics and testing procedures

#### 21. Missing Encumbrance Calculation Formula
- **Location**: Multiple files (10-crafting-economy.md, 74-cursed-artifacts-and-extraction-system.md, etc.)
- **Issue**: Encumbrance system referenced extensively but no calculation formula provided
- **Gap**: No formula for how weight affects movement speed, stamina regen, dodge, or carrying capacity
- **Impact**: Cannot implement encumbrance system
- **Priority**: Critical
- **Status**: Open
- **Recommendation**: Define encumbrance formula like: `Encumbrance% = (CurrentWeight / MaxCarryCapacity) * 100`, with speed/stamina penalties based on thresholds

#### 22. Missing Skill Gain Rate Formulas (01-progression.md)
- **Location**: `01-progression.md` Section 7.1
- **Issue**: States "Each skill has a chance to increase on relevant actions" but no rates or formulas provided
- **Gap**: No skill gain rates, chance calculations, or diminishing returns formulas
- **Impact**: Cannot implement skill progression system
- **Priority**: Critical
- **Status**: Open
- **Recommendation**: Define skill gain rates per action type with diminishing returns (e.g., base chance decreases as skill increases)

#### 23. Missing Hunger/Bond Decay Rate Formulas (29-companion-bond-and-mercenary-system.md)
- **Location**: `29-companion-bond-and-mercenary-system.md` Section 6.2
- **Issue**: States "Hunger decays by ~10 points per hour" but no formula for bond decay or exact calculations
- **Gap**: Incomplete decay formulas for companion systems
- **Impact**: Cannot implement companion upkeep system accurately
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define exact decay formulas for hunger and bond with time-based calculations

#### 24. Missing Reward Scaling Formulas (37-economy-system-extensions.md)
- **Location**: `37-economy-system-extensions.md` Section 2.5
- **Issue**: References `G_safe`, `2 * G_safe`, `3-4 * G_safe` but no base value or scaling formula
- **Gap**: No gold-per-hour target values or scaling formulas defined
- **Impact**: Cannot tune task board rewards properly
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define `G_safe` baseline (e.g., 100g/hr) and scaling multipliers with economic balance notes

#### 25. Missing Crafting Success Chance Formula (05-crafting.md)
- **Location**: `05-crafting.md` Section 8
- **Issue**: States crafting can fail but no success chance formula provided
- **Gap**: No formula for calculating crafting success/failure
- **Impact**: Cannot implement crafting failure system
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define success chance formula like: `SuccessChance = (Skill + Lore + WorkstationBonus - Difficulty) / 100`, clamped to [5%, 95%]

#### 26. Missing Quality Score to Tier Mapping (10-crafting-economy.md)
- **Location**: `10-crafting-economy.md` Section 7
- **Issue**: QualityScore formula provided but no mapping to quality tiers (Shoddy, Common, Fine, etc.)
- **Gap**: No thresholds for quality tier determination
- **Impact**: Cannot determine crafted item quality
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define quality tier thresholds (e.g., Shoddy < -20, Common -20 to 0, Fine 0 to 20, etc.)

#### 27. Missing Caravan Movement Speed Formula (13-caravans-contracts.md)
- **Location**: `13-caravans-contracts.md` Section 6
- **Issue**: Describes caravan movement but no speed calculation formula
- **Gap**: No formula for how cargo weight, terrain, and other factors affect caravan speed
- **Impact**: Cannot implement caravan movement system
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define speed formula like: `CaravanSpeed = BaseSpeed * (1 - CargoWeightPenalty) * TerrainModifier`

#### 28. Missing Notoriety Decay Formula (11-pvp-systems.md)
- **Location**: `11-pvp-systems.md` Section 3.3
- **Issue**: States notoriety decays but no formula or rate provided
- **Gap**: No notoriety decay calculation
- **Impact**: Cannot implement notoriety decay system
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define decay formula like: `NotorietyDecay = BaseDecay + (CivicActions * DecayBonus)`, with time-based reduction

#### 29. Missing Mentor Down Scaling Formula (47-mentoring-and-build-loadouts.md)
- **Location**: `47-mentoring-and-build-loadouts.md` Section 2.3
- **Issue**: Describes scaling down but no formula for how stats are reduced
- **Gap**: No formula for calculating scaled-down HP, damage, mitigation
- **Impact**: Cannot implement mentor down system
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define scaling formula like: `ScaledStat = BaseStat * (TargetBandLevel / ActualLevel)`, with minimum thresholds

#### 30. Missing Task Board Generation Algorithm (76-dynamic-tasks-and-contracts-2-0-spec.md)
- **Location**: `76-dynamic-tasks-and-contracts-2-0-spec.md` Section 4
- **Issue**: Task templates defined but no algorithm for generating instances
- **Gap**: No specification of how tasks are selected, weighted, and generated
- **Impact**: Cannot implement dynamic task generation
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define task generation algorithm with weighting, risk tier distribution, and refresh logic

---

## Additional Gap Categories

### Error Handling & Recovery Gaps

#### 31. Missing Crafting Failure Recovery Procedures (05-crafting.md)
- **Location**: `05-crafting.md` Section 8
- **Issue**: Crafting failures described but no recovery/rollback procedures specified
- **Gap**: No specification of what happens to materials on failure, partial refunds, or error handling
- **Impact**: Unclear behavior on crafting failures
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define failure recovery: material loss percentage, partial refunds, error logging

#### 32. Missing Contract Failure Handling (13-caravans-contracts.md)
- **Location**: `13-caravans-contracts.md` Section 2
- **Issue**: Collateral system described but failure scenarios not fully detailed
- **Gap**: No specification of what happens if courier disconnects, server crashes, or contract expires
- **Impact**: Edge cases in contract system not handled
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define failure handling: disconnect recovery, expiration logic, server crash recovery

#### 33. Missing Database Migration Rollback Procedures (30-db-migrations-mortal-core.md)
- **Location**: `30-db-migrations-mortal-core.md`
- **Issue**: Migrations defined but rollback procedures not specified
- **Gap**: No specification of how to rollback failed migrations or downgrade schema
- **Impact**: Cannot safely recover from failed migrations
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define rollback procedures for each migration with downgrade scripts

### Performance & Scalability Gaps

#### 34. Missing Concurrent User Limits (12-world-simulation.md)
- **Location**: `12-world-simulation.md`
- **Issue**: World simulation systems described but no concurrency limits specified
- **Gap**: No specification of max players per zone, spawn rate scaling, or performance thresholds
- **Impact**: Cannot plan for server capacity or optimize performance
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define concurrent user limits per zone, spawn scaling formulas, performance targets

#### 35. Missing Task Board Performance Specifications (76-dynamic-tasks-and-contracts-2-0-spec.md)
- **Location**: `76-dynamic-tasks-and-contracts-2-0-spec.md`
- **Issue**: Task generation described but no performance requirements
- **Gap**: No specification of generation time limits, refresh rates, or database query optimization
- **Impact**: May cause performance issues with many players
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define performance requirements: max generation time, refresh intervals, query optimization

### Security & Validation Gaps

#### 36. Missing Input Validation Specifications (Multiple files)
- **Location**: Multiple system specs
- **Issue**: Systems described but input validation not fully specified
- **Gap**: No specification of validation rules for user inputs (contract amounts, skill points, attribute values)
- **Impact**: Security vulnerabilities and exploit potential
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define input validation rules for all user-facing systems: ranges, types, sanitization

#### 37. Missing Rate Limiting Specifications (40-anti-bot-rmt-and-security.md)
- **Location**: `40-anti-bot-rmt-and-security.md`
- **Issue**: Anti-bot systems described but rate limiting not fully specified
- **Gap**: No specification of rate limits for actions (contracts, trades, skill gains)
- **Impact**: Cannot prevent automated abuse
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define rate limits per action type: contracts/hour, trades/hour, skill checks/second

### Testing & Quality Assurance Gaps

#### 38. Missing Test Coverage Requirements (17-implementation-roadmap.md)
- **Location**: `17-implementation-roadmap.md`
- **Issue**: Implementation milestones defined but test requirements not specified
- **Gap**: No specification of test coverage, test types, or quality gates
- **Impact**: Cannot ensure quality before deployment
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define test coverage requirements: unit tests, integration tests, acceptance criteria per milestone

#### 39. Missing Load Testing Specifications (Multiple files)
- **Location**: Multiple system specs
- **Issue**: Systems described but load testing requirements not specified
- **Gap**: No specification of expected load, stress test scenarios, or performance benchmarks
- **Impact**: Cannot validate system performance under load
- **Priority**: Medium
- **Status**: Open
- **Recommendation**: Define load testing requirements: expected concurrent users, stress test scenarios, performance benchmarks

### Integration & Compatibility Gaps

#### 40. Missing Version Compatibility Specifications (25-launcher-mortal-client.md)
- **Location**: `25-launcher-mortal-client.md`
- **Issue**: Launcher described but version compatibility not fully specified
- **Gap**: No specification of client/server version compatibility, update rollback, or compatibility matrix
- **Impact**: Cannot ensure smooth updates or handle version mismatches
- **Priority**: High
- **Status**: Open
- **Recommendation**: Define version compatibility matrix, update procedures, rollback mechanisms

