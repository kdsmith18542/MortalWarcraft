# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Economy & Content  
### File: 76-dynamic-tasks-and-contracts-2-0-spec.md  
### Section: Dynamic Tasks & Contracts 2.0 (Economy Loops)

---

## 1. Purpose

This spec defines **Dynamic Tasks & Contracts 2.0**, the backbone of:

- Day-to-day **money-generating gameplay**,
- Ongoing **economic health** (faucets vs sinks),
- **Sandbox-style content** that:
  - Supports multiple playstyles,
  - Adapts to world state (invasions, shortages, control),
  - Integrates with Strongholds, Warfronts, and Factions.

It covers:

- Task archetypes and categories,
- Dynamic generation & scaling,
- Reward formulas,
- Faction & regional weighting,
- Implementation details (DB, scripts, UI).

---

## Related Specs

For full context on tasks and contracts, see:

- **`06-pve.md`** — PvE content that task boards provide access to
- **`13-caravans-contracts.md`** — Caravan contracts and courier system
- **`58-world-contracts-and-map-pins.md`** — World contracts and map integration
- **`37-economy-system-extensions.md`** — Economy extensions that task boards support
- **`51-factions-and-standing-system.md`** — Faction system that tags tasks and contracts
- **`01-progression.md`** — Derived level system used for task gating
- **`03-risk-zones.md`** — Risk tiers that affect task generation and rewards

---

## 2. Core Concepts

### 2.1 Terminology

- **Task:**  
  - Short, often solo-friendly objective:
    - Kill X, gather Y, deliver Z.
  - Generated and listed on **Task Boards**.

- **Contract:**  
  - More complex and/or higher-stakes mission:
    - Multi-step,
    - Time-limited,
    - Group-oriented or tied to Strongholds/Warfronts.

- **Board:**  
  - In-world object (Task/Contract Boards):
    - Located in hubs, Greycrag, Strongholds, etc.
    - Shows a filtered view of available tasks.

### 2.2 Design Goals

1. Keep **gold & material faucets** healthy enough that:
   - Players can recover from losses,
   - The economy doesn’t stagnate.

2. Provide **variety**:
   - Combat, gathering, crafting, trade, social, exploration.

3. Make boards feel **alive**:
   - Adjust task generation based on:
     - Region shortages/surpluses,  
     - Invasion status,  
     - Stronghold ownership.

4. Keep it **implementable**:
   - Use template-driven generation,
   - Lightweight “simulation” via DB state, not full-blown AI.

---

## 3. Task & Contract Archetypes

### 3.1 Task Archetypes (Short-Form)

1. **Cull / Exterminate**
   - “Kill 10 [MobType] near [Location].”
   - Scales with zone tier and player level.

2. **Gather / Harvest**
   - “Collect 12 [ResourceNode] in [Area].”
   - Encourages farming of needed mats.

3. **Delivery / Courier**
   - “Carry [Crate] from [A] to [B].”
   - Hook into encumbrance & road speed systems.

4. **Repair / Build**
   - “Bring 10 [Wood/Iron] to [Structure] and repair it.”
   - Often used in Stronghold & Invasion context.

5. **Escort / Defense (Mini)**
   - “Guard [NPC/Caravan] for duration or until destination.”

6. **Investigation / Scout**
   - “Survey 3 locations with [Lens] and report anomalies.”
   - Lightweight exploration content.

7. **Fishing & First Aid Tasks**
   - Fishing:
     - “Catch X fish at Y,” or “Deliver rare fish to inn.”  
   - First Aid:
     - “Bandage wounded NPCs after a skirmish,” or “Collect herbal components.”

8. **Social / Market**
   - “List 3 items on the Market for at least [Price].”
   - “Visit a Stronghold Stall and complete a trade.”

### 3.2 Contract Archetypes (Higher-Stakes)

1. **Caravan Contracts**
   - Multi-zone escort with variable routes and risks.

2. **Stronghold Contracts**
   - Defense, supply, or sieges tied to specific Strongholds.

3. **Invasion Contracts**
   - Focus on Fallen or Contested zones:
     - Kill elites, destroy banners, escort refugees.

4. **Warfront Contracts**
   - Pre/ post Warfront operations:
     - Sabotage, recon, supply runs.

5. **Faction-Specific Contracts**
   - Iron Ledger:
     - Profit-driven trade operations, collateral tasks.  
   - Shrine:
     - Ether cleansing, vigil assistance.  
   - Cartel:
     - Smuggling, black market logistics.  
   - Rangers:
     - Frontier scouting and line defense.

---

## 4. Data Model

### 4.1 Task Templates

```sql
CREATE TABLE mortal_task_template (
    id INT PRIMARY KEY AUTO_INCREMENT,
    task_key VARCHAR(64) UNIQUE NOT NULL,        -- 'TASK_CULL_WOLVES_T1'
    category TINYINT NOT NULL,                   -- kill/gather/deliver/etc
    zone_id INT NOT NULL,
    min_zone_tier TINYINT NOT NULL DEFAULT 1,    -- green/yellow/red tier indicator
    max_zone_tier TINYINT NOT NULL DEFAULT 3,
    min_derived_level INT NOT NULL DEFAULT 1,    -- derived level (see 01-progression)
    max_derived_level INT NOT NULL DEFAULT 25,
    base_reward_gold INT NOT NULL,
    base_reward_renown INT NOT NULL,             -- meta progression only (no combat power)
    base_reward_material_value INT NOT NULL,     -- abstract material reward budget
    faction_mask INT NOT NULL DEFAULT 0,         -- which factions benefit
    is_repeatable TINYINT NOT NULL DEFAULT 1,
    weight INT NOT NULL DEFAULT 10               -- selection weight for generator
);
```

> **Derived Level Reminder:** Use `Derived_Level = MIN(25, FLOOR(Total_Primary_Skill_Points / 48))` from `01-progression.md` when evaluating `min_derived_level` / `max_derived_level`.

### 4.2 Contract Templates

```sql
CREATE TABLE mortal_contract_template (
    id INT PRIMARY KEY AUTO_INCREMENT,
    contract_key VARCHAR(64) UNIQUE NOT NULL,    -- 'CONTRACT_CARAVAN_T2'
    type TINYINT NOT NULL,                       -- caravan/stronghold/invasion/warfront/etc
    zone_id INT NOT NULL,
    difficulty INT NOT NULL,                     -- 1-5 scale
    group_size_min INT NOT NULL,
    group_size_max INT NOT NULL,
    duration_sec INT NOT NULL,                   -- soft time expectation
    base_reward_gold INT NOT NULL,
    base_reward_material_value INT NOT NULL,
    base_reward_token_value INT NOT NULL,
    faction_mask INT NOT NULL DEFAULT 0,
    is_repeatable TINYINT NOT NULL DEFAULT 1,
    weight INT NOT NULL DEFAULT 5
);
```

### 4.3 Task/Contract Instances

```sql
CREATE TABLE mortal_task_instance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    template_id INT NOT NULL,
    zone_id INT NOT NULL,
    board_id INT NOT NULL,
    state TINYINT NOT NULL,                      -- 0=available,1=taken,2=completed,3=expired
    assigned_to BIGINT NULL,                     -- player guid
    created_at INT NOT NULL,
    expires_at INT NULL
);
```

```sql
CREATE TABLE mortal_contract_instance (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    template_id INT NOT NULL,
    zone_id INT NOT NULL,
    board_id INT NOT NULL,
    state TINYINT NOT NULL,                      -- 0=available,1=taken,2=completed,3=failed,4=expired
    assigned_to BIGINT NULL,                     -- player or guild
    is_guild_contract TINYINT NOT NULL DEFAULT 0,
    created_at INT NOT NULL,
    expires_at INT NULL
);
```

### 4.4 Regional Demand State

```sql
CREATE TABLE mortal_region_demand_state (
    id INT PRIMARY KEY AUTO_INCREMENT,
    zone_id INT NOT NULL,
    resource_shortage_score FLOAT NOT NULL DEFAULT 0,   -- mats needed
    security_risk_score FLOAT NOT NULL DEFAULT 0,       -- mobs/invasion risk
    trade_flow_score FLOAT NOT NULL DEFAULT 0,          -- caravans & market activity
    population_activity_score FLOAT NOT NULL DEFAULT 0, -- players active recently
    updated_at INT NOT NULL
);
```

This table drives **weighting** for which tasks/contracts spawn.

---

## 5. Dynamic Generation & Scaling

### 5.1 Generation Loop

For each **Board** (e.g., Port Meridian, Greycrag, Stronghold, Fallen Zone):

- At fixed intervals (e.g., every 15–30 minutes):
  1. Read `mortal_region_demand_state` for its zone.  
  2. Select candidate templates:
     - Zone + tier constraints,  
     - Faction_mask compatibility,  
     - Player-level ranges (for recommended baseline).  
  3. Adjust template **weight** based on demand:
     - High `resource_shortage_score` → more Gather/Caravan tasks.  
     - High `security_risk_score` → more Cull/Invasion tasks.  
     - High `trade_flow_score` → more Delivery/Caravan contracts.  
  4. Spawn new `mortal_task_instance` and `mortal_contract_instance` until:
     - Board is "full" (max slots), or  
     - Hard cap per board.

### 5.1.1 Complete Task Board Generation Algorithm

**Algorithm Overview:**
The task board generation system creates dynamic, context-aware tasks and contracts based on regional demand, player activity, and world state.

**Generation Cycle:**
- Runs every **15-30 minutes** (configurable per board)
- Processes each board independently
- Maintains board capacity (e.g., 10-15 tasks, 3-5 contracts per board)

**Step-by-Step Algorithm:**

```
ALGORITHM: GenerateTaskBoard(boardId, zoneId)
BEGIN
    // Step 1: Read Regional Demand State
    demandState = QueryRegionDemandState(zoneId)
    
    // Step 2: Cleanup Expired Instances
    DELETE FROM mortal_task_instance 
    WHERE board_id = boardId 
    AND (expires_at < NOW() OR state = 3)  // expired or completed
    
    DELETE FROM mortal_contract_instance 
    WHERE board_id = boardId 
    AND (expires_at < NOW() OR state IN (3, 4))  // expired, completed, or failed
    
    // Step 3: Count Current Instances
    currentTasks = COUNT(mortal_task_instance WHERE board_id = boardId AND state = 0)
    currentContracts = COUNT(mortal_contract_instance WHERE board_id = boardId AND state = 0)
    
    // Step 4: Calculate Target Counts
    maxTasks = GetBoardMaxTasks(boardId)  // e.g., 12
    maxContracts = GetBoardMaxContracts(boardId)  // e.g., 5
    
    tasksNeeded = max(0, maxTasks - currentTasks)
    contractsNeeded = max(0, maxContracts - currentContracts)
    
    // Step 5: Select Candidate Templates
    candidateTasks = SELECT * FROM mortal_task_template
    WHERE zone_id = zoneId
    AND is_repeatable = 1
    AND min_zone_tier <= GetZoneRiskTier(zoneId)
    AND max_zone_tier >= GetZoneRiskTier(zoneId)
    
    candidateContracts = SELECT * FROM mortal_contract_template
    WHERE zone_id = zoneId
    AND is_repeatable = 1
    
    // Step 6: Calculate Adjusted Weights
    FOR EACH template IN candidateTasks:
        baseWeight = template.weight
        
        // Adjust weight based on demand state
        adjustedWeight = CalculateTaskWeight(template, demandState, baseWeight)
        
        template.adjustedWeight = adjustedWeight
    
    FOR EACH template IN candidateContracts:
        baseWeight = template.weight
        adjustedWeight = CalculateContractWeight(template, demandState, baseWeight)
        template.adjustedWeight = adjustedWeight
    
    // Step 7: Weighted Random Selection
    WHILE tasksNeeded > 0 AND candidateTasks.size() > 0:
        selectedTemplate = WeightedRandomSelect(candidateTasks)
        
        // Create task instance
        taskInstance = CreateTaskInstance(selectedTemplate, boardId, zoneId)
        INSERT INTO mortal_task_instance (template_id, zone_id, board_id, state, created_at, expires_at)
        VALUES (selectedTemplate.id, zoneId, boardId, 0, NOW(), NOW() + selectedTemplate.duration_sec)
        
        tasksNeeded--
        // Optionally reduce weight after selection to prevent duplicates
        selectedTemplate.adjustedWeight = selectedTemplate.adjustedWeight * 0.5
    
    WHILE contractsNeeded > 0 AND candidateContracts.size() > 0:
        selectedTemplate = WeightedRandomSelect(candidateContracts)
        
        contractInstance = CreateContractInstance(selectedTemplate, boardId, zoneId)
        INSERT INTO mortal_contract_instance (template_id, zone_id, board_id, state, created_at, expires_at)
        VALUES (selectedTemplate.id, zoneId, boardId, 0, NOW(), NOW() + selectedTemplate.duration_sec)
        
        contractsNeeded--
        selectedTemplate.adjustedWeight = selectedTemplate.adjustedWeight * 0.5
    
    RETURN (tasksCreated, contractsCreated)
END
```

**Weight Calculation Functions:**

```
FUNCTION: CalculateTaskWeight(template, demandState, baseWeight)
BEGIN
    adjustedWeight = baseWeight
    
    // Category-based demand modifiers
    IF template.category == GATHER:
        // Resource shortage increases gather task weight
        modifier = 1.0 + (demandState.resource_shortage_score / 10.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.category == CULL:
        // Security risk increases cull task weight
        modifier = 1.0 + (demandState.security_risk_score / 10.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.category == DELIVERY:
        // Trade flow increases delivery task weight
        modifier = 1.0 + (demandState.trade_flow_score / 10.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.category == CARAVAN:
        // Both resource shortage and trade flow affect caravans
        modifier = 1.0 + ((demandState.resource_shortage_score + demandState.trade_flow_score) / 20.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.category == INVASION:
        // Security risk and population activity affect invasions
        modifier = 1.0 + ((demandState.security_risk_score + demandState.population_activity_score) / 20.0)
        adjustedWeight = adjustedWeight * modifier
    
    // Population activity bonus (all tasks)
    IF demandState.population_activity_score > 5.0:
        activityBonus = 1.0 + (demandState.population_activity_score / 20.0)
        adjustedWeight = adjustedWeight * activityBonus
    
    // Ensure minimum weight
    adjustedWeight = max(1.0, adjustedWeight)
    
    RETURN adjustedWeight
END

FUNCTION: CalculateContractWeight(template, demandState, baseWeight)
BEGIN
    adjustedWeight = baseWeight
    
    // Contract type-based modifiers
    IF template.type == CARAVAN:
        modifier = 1.0 + ((demandState.resource_shortage_score + demandState.trade_flow_score) / 20.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.type == STRONGHOLD:
        modifier = 1.0 + (demandState.security_risk_score / 10.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.type == INVASION:
        modifier = 1.0 + ((demandState.security_risk_score + demandState.population_activity_score) / 20.0)
        adjustedWeight = adjustedWeight * modifier
    
    ELSE IF template.type == WARFRONT:
        modifier = 1.0 + (demandState.population_activity_score / 10.0)
        adjustedWeight = adjustedWeight * modifier
    
    // Population activity bonus
    IF demandState.population_activity_score > 5.0:
        activityBonus = 1.0 + (demandState.population_activity_score / 20.0)
        adjustedWeight = adjustedWeight * activityBonus
    
    adjustedWeight = max(1.0, adjustedWeight)
    
    RETURN adjustedWeight
END
```

**Weighted Random Selection:**

```
FUNCTION: WeightedRandomSelect(templates)
BEGIN
    totalWeight = SUM(template.adjustedWeight FOR template IN templates)
    randomValue = RANDOM(0.0, totalWeight)
    
    cumulativeWeight = 0.0
    FOR EACH template IN templates:
        cumulativeWeight += template.adjustedWeight
        IF randomValue <= cumulativeWeight:
            RETURN template
    
    // Fallback (should not reach here)
    RETURN templates[0]
END
```

**Player Filtering (When Viewing Board):**

```
FUNCTION: FilterTasksForPlayer(boardId, player)
BEGIN
    playerLevel = CalculateDerivedLevel(player)  // skills / 48
    playerZone = GetPlayerZone(player)
    
    // Get available tasks for this player
    availableTasks = SELECT ti.*, tt.*
    FROM mortal_task_instance ti
    JOIN mortal_task_template tt ON ti.template_id = tt.id
    WHERE ti.board_id = boardId
    AND ti.state = 0  // available
    AND ti.zone_id = playerZone
    AND playerLevel >= tt.min_derived_level
    AND playerLevel <= tt.max_derived_level
    AND GetZoneRiskTier(playerZone) >= tt.min_zone_tier
    AND GetZoneRiskTier(playerZone) <= tt.max_zone_tier
    
    // Calculate effective rewards for each task
    FOR EACH task IN availableTasks:
        task.effectiveReward = CalculateEffectiveReward(task, player)
    
    // Sort by difficulty or reward (player preference)
    SORT availableTasks BY effectiveReward DESC
    
    RETURN availableTasks
END
```

**Demand State Update Algorithm:**

```
ALGORITHM: UpdateRegionDemandState(zoneId)
BEGIN
    currentState = QueryRegionDemandState(zoneId)
    
    // Resource Shortage Score (0-10)
    // Based on: material prices, player activity, recent gathering
    recentGathering = COUNT(recent_gathering_events WHERE zone_id = zoneId AND time > NOW() - 1 hour)
    materialPrices = QueryAverageMaterialPrices(zoneId)
    expectedGathering = GetExpectedGatheringRate(zoneId)
    
    resourceShortage = CalculateResourceShortage(recentGathering, expectedGathering, materialPrices)
    currentState.resource_shortage_score = CLAMP(0, 10, resourceShortage)
    
    // Security Risk Score (0-10)
    // Based on: recent PvP activity, mob spawns, invasion status
    recentPvP = COUNT(recent_pvp_events WHERE zone_id = zoneId AND time > NOW() - 1 hour)
    mobDensity = QueryMobDensity(zoneId)
    invasionActive = CheckInvasionStatus(zoneId)
    
    securityRisk = CalculateSecurityRisk(recentPvP, mobDensity, invasionActive)
    currentState.security_risk_score = CLAMP(0, 10, securityRisk)
    
    // Trade Flow Score (0-10)
    // Based on: caravan activity, market transactions, delivery tasks
    recentCaravans = COUNT(recent_caravan_events WHERE zone_id = zoneId AND time > NOW() - 1 hour)
    marketTransactions = COUNT(recent_market_transactions WHERE zone_id = zoneId AND time > NOW() - 1 hour)
    
    tradeFlow = CalculateTradeFlow(recentCaravans, marketTransactions)
    currentState.trade_flow_score = CLAMP(0, 10, tradeFlow)
    
    // Population Activity Score (0-10)
    // Based on: active players in zone, recent task completions
    activePlayers = COUNT(players WHERE zone_id = zoneId AND last_seen > NOW() - 30 minutes)
    recentCompletions = COUNT(recent_task_completions WHERE zone_id = zoneId AND time > NOW() - 1 hour)
    
    populationActivity = CalculatePopulationActivity(activePlayers, recentCompletions)
    currentState.population_activity_score = CLAMP(0, 10, populationActivity)
    
    // Update timestamp
    currentState.updated_at = NOW()
    
    UPDATE mortal_region_demand_state SET
        resource_shortage_score = currentState.resource_shortage_score,
        security_risk_score = currentState.security_risk_score,
        trade_flow_score = currentState.trade_flow_score,
        population_activity_score = currentState.population_activity_score,
        updated_at = currentState.updated_at
    WHERE zone_id = zoneId
    
    RETURN currentState
END
```

**Helper Functions:**

```
FUNCTION: CalculateResourceShortage(recentGathering, expectedGathering, materialPrices)
BEGIN
    gatheringRatio = recentGathering / max(1, expectedGathering)
    priceMultiplier = materialPrices / GetBaselineMaterialPrices()
    
    // Low gathering + high prices = high shortage
    shortage = (1.0 - gatheringRatio) * priceMultiplier * 5.0
    RETURN CLAMP(0, 10, shortage)
END

FUNCTION: CalculateSecurityRisk(recentPvP, mobDensity, invasionActive)
BEGIN
    pvPRisk = min(5.0, recentPvP / 10.0)  // 0-5 from PvP
    mobRisk = min(3.0, mobDensity / 100.0)  // 0-3 from mobs
    invasionRisk = invasionActive ? 2.0 : 0.0  // 0-2 from invasions
    
    totalRisk = pvPRisk + mobRisk + invasionRisk
    RETURN CLAMP(0, 10, totalRisk)
END

FUNCTION: CalculateTradeFlow(recentCaravans, marketTransactions)
BEGIN
    caravanFlow = min(5.0, recentCaravans / 5.0)  // 0-5 from caravans
    marketFlow = min(5.0, marketTransactions / 20.0)  // 0-5 from markets
    
    totalFlow = caravanFlow + marketFlow
    RETURN CLAMP(0, 10, totalFlow)
END

FUNCTION: CalculatePopulationActivity(activePlayers, recentCompletions)
BEGIN
    playerActivity = min(5.0, activePlayers / 10.0)  // 0-5 from players
    completionActivity = min(5.0, recentCompletions / 10.0)  // 0-5 from completions
    
    totalActivity = playerActivity + completionActivity
    RETURN CLAMP(0, 10, totalActivity)
END
```

### 5.1.2 Algorithm Execution Flow

**Initialization:**
1. Server startup: Load all task/contract templates into memory
2. Initialize demand state for all zones (default values: 0.0 for all scores)
3. Start generation timer (15-30 minute intervals)

**Generation Cycle:**
1. **Update Demand State** (runs every 5-10 minutes, independent of generation)
   - Calculate resource shortage, security risk, trade flow, population activity
   - Update `mortal_region_demand_state` table

2. **Generate Tasks/Contracts** (runs every 15-30 minutes per board)
   - Cleanup expired instances
   - Calculate needed instances
   - Select and spawn new instances

3. **Player Interaction** (on-demand when player views board)
   - Filter available tasks by player level/zone
   - Calculate effective rewards
   - Display sorted list

**Cleanup:**
- Expired tasks/contracts removed on next generation cycle
- Completed instances archived after 24 hours
- Failed contracts removed immediately or after 1 hour

### 5.2 Scaling to Player Level & Group

When player interacts with Board:

- Filter tasks by:
  - Zone tier,  
  - Player dynamic level (`Character_Level` = skills / 50),  
  - Optional party size (for contracts).

Reward values adjust via formula:

```text
EffectiveReward = BaseReward * DifficultyMultiplier * RiskMultiplier * RegionModifier
```

Where:

- **DifficultyMultiplier**
  - Derived from task's difficulty vs player level,
  - Slight boost for taking on harder tasks.

- **RiskMultiplier**
  - Higher in:
    - Yellow/Red zones,
    - During invasions,
    - On roads prone to ambush.

- **RegionModifier**
  - From `mortal_region_demand_state`:
    - If resource_shortage_high -> +X% to Gather/Caravan rewards,
    - If security_risk_high -> +X% to Cull/Invasion rewards.

### 5.2 Reward Scaling Formulas

Reward values are calculated using the following formula:

```
EffectiveReward = BaseReward * DifficultyMultiplier * RiskMultiplier * RegionModifier
```

### 5.2.1 Baseline Reward Values (G_safe)

**G_safe** represents the baseline gold reward for a level-appropriate task in a **Green (safe) zone**:

| Task Type | G_safe (Base Gold) | Base Material Value | Notes |
|-----------|-------------------|---------------------|-------|
| **Kill Task** | 5-10 gold | 2-5 gold equivalent | Varies by target tier |
| **Gather Task** | 3-8 gold | 5-10 gold equivalent | Materials are primary reward |
| **Caravan Task** | 15-25 gold | 0 gold | High risk, high reward |
| **Cull Task** | 8-12 gold | 3-6 gold equivalent | Population control |
| **Delivery Task** | 4-7 gold | 1-3 gold equivalent | Low risk, low reward |
| **Invasion Task** | 12-20 gold | 5-8 gold equivalent | Event-based, time-limited |

**Default G_safe Values by Derived Level:**
- **Level 1-5**: 3-5 gold (G_safe = 4 gold average)
- **Level 6-10**: 5-8 gold (G_safe = 6.5 gold average)
- **Level 11-15**: 8-12 gold (G_safe = 10 gold average)
- **Level 16-20**: 12-18 gold (G_safe = 15 gold average)
- **Level 21-25**: 18-25 gold (G_safe = 21 gold average)

### 5.2.2 Difficulty Multiplier

Rewards scale based on task difficulty relative to player level:

```
LevelDiff = TaskDifficulty - PlayerDerivedLevel
DifficultyMultiplier = 1.0 + (LevelDiff * 0.1)
```

**Constraints:**
- Minimum: 0.5 (50% reward for tasks 5+ levels below player)
- Maximum: 2.0 (200% reward for tasks 10+ levels above player)

**Examples:**
- **Level 10 player, Level 10 task**: `1.0 + (0 * 0.1) = 1.0` (100% reward)
- **Level 10 player, Level 12 task**: `1.0 + (2 * 0.1) = 1.2` (120% reward)
- **Level 10 player, Level 15 task**: `1.0 + (5 * 0.1) = 1.5` (150% reward)
- **Level 10 player, Level 5 task**: `1.0 + (-5 * 0.1) = 0.5` (50% reward, minimum)

### 5.2.3 Risk Multiplier

Rewards scale based on zone risk tier:

| Risk Tier | Risk Multiplier | Description |
|-----------|----------------|-------------|
| **Green** | 1.0 | Safe zone baseline |
| **Yellow** | 1.2 | Mid-risk, 20% bonus |
| **Red** | 1.5 | Full-loot risk, 50% bonus |
| **Invasion Active** | +0.3 | Additional bonus during invasions (stacks with zone multiplier) |

**Formula:**
```
RiskMultiplier = BaseRiskMultiplier + InvasionBonus
```

Where:
- **BaseRiskMultiplier**: 1.0 (Green), 1.2 (Yellow), 1.5 (Red)
- **InvasionBonus**: 0.3 if invasion is active in zone, else 0.0

**Examples:**
- **Green zone**: 1.0 (no bonus)
- **Yellow zone**: 1.2 (20% bonus)
- **Red zone**: 1.5 (50% bonus)
- **Yellow zone + Invasion**: 1.2 + 0.3 = 1.5 (50% total bonus)

### 5.2.4 Region Modifier

Rewards scale based on regional demand state:

```
RegionModifier = 1.0 + (DemandScore * 0.05)
```

Where:
- **DemandScore**: 0-10 (from `mortal_region_demand_state` table)
- **Resource Shortage**: Increases Gather/Caravan task rewards
- **Security Risk**: Increases Cull/Invasion task rewards

**Modifier Ranges:**
- **No Demand (0)**: 1.0 (100% reward)
- **Low Demand (1-3)**: 1.05-1.15 (5-15% bonus)
- **Medium Demand (4-6)**: 1.2-1.3 (20-30% bonus)
- **High Demand (7-10)**: 1.35-1.5 (35-50% bonus)

**Task-Specific Modifiers:**
- **Gather Tasks**: Use `resource_shortage_score`
- **Caravan Tasks**: Use `resource_shortage_score`
- **Cull Tasks**: Use `security_risk_score`
- **Invasion Tasks**: Use `security_risk_score`
- **Other Tasks**: Use average of both scores

### 5.2.5 Complete Reward Calculation Examples

**Example 1: Level 10 Kill Task in Yellow Zone**
```
G_safe = 6.5 gold (level 6-10 baseline)
TaskDifficulty = 10
PlayerLevel = 10
ZoneRisk = Yellow
InvasionActive = false
DemandScore = 3 (medium security risk)

DifficultyMultiplier = 1.0 + (10 - 10) * 0.1 = 1.0
RiskMultiplier = 1.2 + 0.0 = 1.2
RegionModifier = 1.0 + (3 * 0.05) = 1.15

FinalGold = round(6.5 * 1.0 * 1.2 * 1.15) = round(8.97) = 9 gold
```

**Example 2: Level 15 Gather Task in Red Zone (Hard)**
```
G_safe = 10 gold (level 11-15 baseline)
TaskDifficulty = 18
PlayerLevel = 15
ZoneRisk = Red
InvasionActive = true
DemandScore = 8 (high resource shortage)

DifficultyMultiplier = min(2.0, 1.0 + (18 - 15) * 0.1) = 1.3
RiskMultiplier = 1.5 + 0.3 = 1.8
RegionModifier = 1.0 + (8 * 0.05) = 1.4

FinalGold = round(10 * 1.3 * 1.8 * 1.4) = round(32.76) = 33 gold
```

**Example 3: Level 5 Delivery Task in Green Zone (Easy)**
```
G_safe = 4 gold (level 1-5 baseline)
TaskDifficulty = 3
PlayerLevel = 5
ZoneRisk = Green
InvasionActive = false
DemandScore = 1 (low demand)

DifficultyMultiplier = max(0.5, 1.0 + (3 - 5) * 0.1) = 0.8
RiskMultiplier = 1.0 + 0.0 = 1.0
RegionModifier = 1.0 + (1 * 0.05) = 1.05

FinalGold = round(4 * 0.8 * 1.0 * 1.05) = round(3.36) = 3 gold
```

### 5.2.6 Material Reward Scaling

Material rewards use the same multipliers but have separate base values:

```
MaterialReward = BaseMaterialValue * DifficultyMultiplier * RiskMultiplier * RegionModifier
```

**Base Material Values:**
- Typically 50-150% of G_safe value
- Varies by material type and rarity
- Higher for rare materials, lower for common materials

---

## 6. Rewards & Economy

### 6.1 Reward Composition

Each Task/Contract reward is a **bundle**:

- Gold (pure currency),
- Materials (chosen from region-appropriate lists),
- Reputation (with one or more factions),
- Chance at:
  - Rune fragments,
  - Mortal gear (for higher difficulty),
  - Tokens (Military Credits, etc. for Warfront/Strongholds).

### 6.2 Faucets vs Sinks

To avoid runaway inflation:

- **Faucets:**
  - Gold & mats from tasks/contracts,
  - Limited by:
    - Daily/weekly soft caps (diminishing returns),  
    - Time to complete.

- **Sinks:**
  - Repair/decay costs,
  - Shrine tithes,
  - Insurance premiums,
  - Rune socketing & removal costs,
  - Stronghold upkeep & upgrades.

### 6.3 Example Reward Formula (Gold)

For a level-appropriate Kill Task in Yellow zone:

```text
BaseGold = task_template.base_reward_gold   (e.g., 8 gold)
DifficultyMultiplier = 1.0 + (TaskDifficulty - PlayerTier) * 0.1
RiskMultiplier = 1.2 (Yellow) or 1.5 (Red)
RegionModifier = 1.0 + (security_risk_score * 0.05)

FinalGold = round(BaseGold * DifficultyMultiplier * RiskMultiplier * RegionModifier)
```

Contracts scale similarly, but with higher BaseGold and base_reward_material_value.

---

## 7. Faction & Ownership Integration

### 7.1 Faction Mask Usage

- Each template has `faction_mask` bits:
  - 1 = Iron Ledger,  
  - 2 = Shrine,  
  - 4 = Cartel,  
  - 8 = Rangers, etc.

Boards use combination:

- **Port Meridian**:
  - Mixed tasks, all factions.  
- **Greycrag**:
  - More Ranger/Shrine oriented.  
- **Stronghold Boards**:
  - Weighted by owning guild’s prime faction alignment:
    - e.g., a Ledger-heavy guild Stronghold spawns more trade/Caravan contracts.

### 7.2 Stronghold Ownership Effects

- Stronghold owner guild:
  - Gets access to **Guild Contracts**:
    - Multi-step missions that pay into Stronghold chest.  
- If zone is Fallen or Controlled by NPC invasion:
  - Certain contracts are disabled, others enhanced:
    - Regular “delivery” tasks replaced with refugee/invasion tasks.

---

## 8. UI & UX

### 8.1 In-Game Boards (MortalUI)

- Board shows:
  - A list of available Tasks & Contracts,
  - Icons indicating:
    - Category (sword, pickaxe, caravan, shield),
    - Zone risk (Green/Yellow/Red),
    - Faction flavor (Ledger/Shrine/Cartel/Rangers icon).

- Interaction:
  - Player selects a Task:
    - Sees detailed tooltip with:
      - Objectives,
      - Estimated difficulty & time,
      - Reward breakdown.  
  - Accept / Abandon with clear feedback.

### 8.2 Atlas Integration

- Web portal:
  - Aggregated data:
    - Active Invasion/Stronghold Contracts,
    - Region demand state,
    - Popular boards and categories.

- Useful for:
  - Economic players choosing where to move,
  - Guilds planning caravans or Stronghold pushes.

---

## 9. Special Cases: Fishing & First Aid

### 9.1 Fishing Task Loop

- Daily/weekly tasks per region:
  - “Catch 20 [FishType] from [Lake/River].”
  - “Deliver rare fish to [Innkeeper] for feast.”

- Reward:
  - Good gold/time ratio,
  - Cooking mats, minor faction rep,
  - Chance at cosmetic items (pets, hats, etc).

### 9.2 First Aid & Medical Support

- Tasks:
  - “Bandage 10 Wounded Soldiers in [Camp] after invasion event.”  
  - “Collect herbs for field medics.”

- Reward:
  - Strong support for non-primary-combat players,
  - Shrine/Ranger rep, First Aid skill, small gold/mats.

These ensure “side professions” are economically relevant.

---

## 10. Implementation Checklist

1. **DB Schema:**
   - Create `mortal_task_template`, `mortal_contract_template`,  
   - `mortal_task_instance`, `mortal_contract_instance`,  
   - `mortal_region_demand_state`.

2. **Board Scripts:**
   - `MortalTaskBoard.cpp/h` (C++ implementation):
     - Read region demand,
     - Generate & refresh tasks.  
   - `contract_board_system.lua`:
     - Similar, with group/faction logic.

3. **Region Demand Updater:**
   - `region_demand_controller.lua`:
     - Periodically updates:
       - `resource_shortage_score` from materials in circulation,  
       - `security_risk_score` from mob kills, invasions, guard deaths,  
       - `trade_flow_score` from caravans completed,  
       - `population_activity_score` from players online & active in region.

4. **Reward Handlers:**
   - Functions to compute final gold, materials, rep from base values and multipliers.

5. **UI:**
   - MortalUI board panels & tooltips,
   - Atlas dashboards for economy watchers.

6. **Balancing:**
   - Start conservative on gold,
   - Monitor:
     - Gold inflow/outflow,
     - Material surpluses/shortages,
     - Task popularity by category/zone.

---

Tasks & Contracts 2.0 are the **“blood flow”** of Mortal Warcraft’s economy:

- Always something meaningful to do,  
- Clear money-making and material routes,  
- And a soft “AI-like” sense of world demand, without heavy computation.  
