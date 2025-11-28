# C++ vs Lua vs Database: Where Each System Lives

**Understanding the Three-Layer Architecture**

---

## The Mortal Architecture

```
┌─────────────────────────────────────┐
│  Lua / UI Layer                     │
│  - Client UI events                 │
│  - Quest dialogs                    │
│  - Chat commands                    │
│  - Animation/visual feedback        │
└─────────────────────────────────────┘
                 ▲
                 │ Network Messages
                 │
┌─────────────────────────────────────┐
│  C++ / Server Core (AzerothCore)   │
│  - Game logic                       │
│  - Combat calculation               │
│  - Spell casting                    │
│  - Database I/O                     │
│  - Player/Creature updates          │
└─────────────────────────────────────┘
                 ▲
                 │ SQL Queries
                 │
┌─────────────────────────────────────┐
│  Database Layer (MySQL)             │
│  - Player data                      │
│  - Item data                        │
│  - Configuration tables             │
│  - Game state persistence           │
└─────────────────────────────────────┘
```

---

## Where Each System Should Live

### 1. Criminal Flags

**WHERE IT LIVES**:
```
Lua:      ⬜ Display flag icon, show criminal message
C++:      🔴 BROKEN - Should enforce expiry, set flag on attack
Database: ✅ character_criminal_flags table (guid, criminal_until)
```

**CURRENTLY BROKEN**:
```
Player attacks another player in Yellow zone
  ↓ [MISSING] OnPlayerAttack() C++ hook
  ↓ [MISSING] C++ code doesn't set criminal flag
  ↓ [MISSING] C++ doesn't check criminal_until when allowing actions
  ✅ Lua shows flag icon (if flag somehow exists)
  ✅ Database has table (but empty)
```

**SHOULD WORK**:
```
Player attacks another player in Yellow zone
  ↓ C++ OnPlayerAttack() hook
  ✅ C++ SetCriminalFlag(player, duration=900)
  ✅ Database INSERT criminal_until timestamp
  ✅ Lua displays icon to other players
  ↓ After 15 minutes
  ✅ C++ WorldScript checks criminal_until < now()
  ✅ C++ ClearCriminalFlag(player)
  ✅ Database DELETE or UPDATE row
  ✅ Lua removes icon
```

---

### 2. Notoriety Decay

**WHERE IT LIVES**:
```
Lua:      ⬜ Display notoriety level, show decay message
C++:      🔴 MISSING - Should decay over time with zone multipliers
Database: ✅ character_notoriety table (guid, notoriety, last_updated)
```

**CURRENTLY BROKEN**:
```
Player kills another player in Red zone
  ✅ Lua awards "notorious" status (if implemented)
  ✅ Database has row but notoriety never changes
  [MISSING] C++ WorldScript timer to decay notoriety
  [MISSING] C++ zone lookup to apply multipliers
  [MISSING] C++ database update to apply decay
```

**SHOULD WORK**:
```
Player kills another player in Red zone
  ✅ C++ OnPlayerPVPKill() increments notoriety
  ✅ Database UPDATE character_notoriety SET notoriety = notoriety + 1
  
  [Every 10 minutes]
  ✅ C++ WorldScript timer runs
  ✅ C++ queries all players with notoriety > 0
  ✅ C++ GetZoneRiskConfig() gets zone type
  ✅ C++ applies zone multiplier (Red = -1/hour, Green = -10/hour)
  ✅ Database UPDATE character_notoriety SET notoriety = notoriety - X
  ✅ Lua refreshes display
```

---

### 3. Buy Orders

**WHERE IT LIVES**:
```
Lua:      ✅ Displays buy order list from NPC
C++:      🟡 Half-done - Fulfillment works, generation missing
Database: ✅ mortal_buy_orders table (complete schema)
```

**CURRENTLY HALF-BROKEN**:
```
Player finds NPC with buy orders
  [MISSING] C++ GenerateBuyOrders() to create new orders
  [MISSING] C++ WorldScript to schedule regeneration
  ✅ Database has old/stale orders (if any exist)
  ✅ Lua displays stale orders from NPC

Player fulfills an order
  ✅ C++ FulfillOrder() receives order ID and quantity
  ✅ Database UPDATE mortal_buy_orders SET quantity_fulfilled = ...
  ✅ C++ gives gold to player
  ✅ Database INSERT into mortal_buy_order_log
  ✅ Lua shows confirmation message
```

**SHOULD WORK**:
```
[Every 8 hours]
  ✅ C++ WorldScript timer runs
  ✅ C++ GenerateBuyOrders() loads NPC regions
  ✅ C++ selects 3-5 random materials per NPC
  ✅ C++ calculates prices from vendor baseline
  ✅ C++ applies hot zone multipliers
  ✅ Database DELETE old orders, INSERT new ones
  ✅ Lua refreshes display

Player talks to NPC
  ✅ C++ CreatureScript gossip hook
  ✅ C++ GetBuyOrders() retrieves current orders
  ✅ C++ builds gossip menu with items/prices
  ✅ Lua displays formatted list
```

---

### 4. Public Groups

**WHERE IT LIVES**:
```
Lua:      ✅ UI to create requests, list groups, apply
C++:      🟡 Half-done - Request system works, creation missing
Database: ✅ mortal_public_group_requests table (assumed)
```

**CURRENTLY HALF-BROKEN**:
```
Player creates group request for dungeon
  ✅ Lua sends create request to server
  ✅ C++ CreateGroupRequest() inserts database row
  ✅ Database has request record
  ✅ Lua displays request in group finder

Another player applies
  ✅ C++ ApplyToGroupRequest() inserts application row
  ✅ Database tracks application
  ✅ Lua shows applicant list to leader

Leader accepts applicants
  ✅ C++ ProcessApplication() updates status
  ✅ Database marks application as ACCEPTED
  [MISSING] C++ StartPublicGroup() doesn't create Group object
  [MISSING] C++ doesn't assign group to actual Group class
  ✅ Lua shows "group ready" but group doesn't actually form
```

**SHOULD WORK**:
```
Leader clicks "Start Group"
  ✅ Lua sends start_group command
  ✅ C++ StartPublicGroup(requestId) is called
  ✅ C++ creates new Group() object
  ✅ C++ calls group->Create(leader)
  ✅ C++ loops through accepted applicants
  ✅ C++ group->AddMember(applicant) for each
  ✅ Database UPDATE request SET status = IN_PROGRESS
  ✅ Lua shows "group formed" message
  ✅ Players appear in actual group
```

---

### 5. Build Presets

**WHERE IT LIVES**:
```
Lua:      ✅ UI to create/select presets
C++:      🟢 Almost complete - Location check missing
Database: ✅ mortal_build_presets table
```

**CURRENTLY MOSTLY WORKING**:
```
Player creates preset
  ✅ Lua sends preset data to server
  ✅ C++ CreatePreset() validates attributes/masteries
  ✅ C++ ValidatePreset() checks caps
  ✅ Database INSERT preset record
  ✅ Lua confirms save

Player swaps to preset in combat zone (PROBLEM!)
  ✅ Lua sends activate_preset command
  ✅ C++ ActivatePreset() is called
  ⚠️ C++ CanApplyPreset() checks IsInCombat()
  [MISSING] C++ CanApplyPreset() doesn't check zone type
  ✅ C++ ApplyPresetAttributes() applies new stats
  [BUG] Player gains power in combat zone
```

**SHOULD WORK**:
```
Player swaps to preset in safe zone
  ✅ Lua sends activate_preset command
  ✅ C++ ActivatePreset() is called
  ✅ C++ CanApplyPreset() checks IsInCombat() → OK
  ✅ C++ CanApplyPreset() checks zone_pvp_config.pvp_type == 0 → OK
  ✅ C++ ApplyPresetAttributes() applies new stats
  ✅ Lua shows success message

Player tries to swap in Red zone
  ✅ Lua sends activate_preset command
  ✅ C++ CanApplyPreset() checks IsInCombat() → OK
  ❌ C++ CanApplyPreset() checks zone_pvp_config.pvp_type == 0 → FAIL
  ✅ C++ returns false, doesn't apply preset
  ✅ Lua shows error "Can only swap in safe zones"
```

---

### 6. Blessed Items

**WHERE IT LIVES**:
```
Lua:      ✅ UI to bless items, show blessed status
C++:      🟡 Mostly done - Binding not enforced
Database: ✅ mortal_blessed_items table
```

**CURRENTLY PARTIALLY WORKING**:
```
Player uses blessing item on another item
  ✅ Lua sends bless command
  ✅ C++ ItemScript_MortalBlessedItems::OnUse() is called
  ✅ C++ BlessItem() inserts blessing record
  ✅ Database INSERT mortal_blessed_items
  ✅ Lua shows blessing icon
  [MISSING] C++ doesn't bind item to player
  [BUG] Player can trade blessed item

Player dies in Red zone with blessed item
  ✅ Lua sends death event
  ✅ C++ PlayerScript_MortalBlessedItems::OnPlayerDeath() checks zone
  ✅ C++ IsItemBlessed(item) queries database
  ✅ C++ ConsumeBlessingCharge() deducts charge
  ✅ Item is protected from drop
  ✅ Lua shows "item protected" message
```

**SHOULD WORK**:
```
Player blesses item
  ✅ C++ BlessItem() inserts blessing
  ✅ C++ item->SetBinding(true) marks soulbound
  ✅ Database marks item as blessed
  ❌ Player can no longer trade it
  ✅ Icon shows blessed status

Player dies in Red zone
  ✅ C++ checks if item blessed
  ✅ Consumes charge, item protected
  ✅ On next death with no charges, item drops
```

---

### 7. Caravan System

**WHERE IT LIVES**:
```
Lua:      ✅ Quest UI, caravan pickup, contract completion
C++:      🟡 Math defined, integration missing
Database: ✅ mortal_caravan_upgrades, wagon_stats tables
```

**CURRENTLY BROKEN**:
```
Player accepts caravan contract
  ✅ Lua marks contract as "in progress"
  ✅ Lua spawns caravan NPC
  [MISSING] C++ doesn't use MortalCaravanMovement calculations
  [MISSING] C++ creature moves at default speed
  ✅ Lua shows caravan moving (at wrong speed)
  [MISSING] Cargo doesn't affect speed
  [MISSING] Terrain doesn't affect speed
  [MISSING] Health doesn't affect speed
  
Player reaches destination
  ✅ Lua detects destination trigger
  ✅ Lua marks contract complete
  ✅ C++ awards gold reward
```

**SHOULD WORK**:
```
Caravan spawns
  ✅ C++ spawns MortalCaravan creature
  ✅ C++ loads cargo weight from items
  ✅ C++ loads upgrades from database

Every game tick
  ✅ C++ samples terrain under caravan
  ✅ C++ GetTerrainModifier(terrain)
  ✅ C++ checks if on road (GetRoadBonus)
  ✅ C++ CalculateHealthModifier(currentHealth/maxHealth)
  ✅ C++ CalculateCargoPenalty(weight/capacity)
  ✅ C++ CalculateCaravanSpeed(base * modifiers)
  ✅ C++ SetSpeed(MOVE_RUN, calculatedSpeed)
  ✅ Creature moves at correct speed

Player deals damage to caravan
  [OPTIONAL] C++ reduces health
  ✅ Next tick recalculates speed (slower if damaged)

Caravan reaches destination
  ✅ C++ triggers complete handler
  ✅ C++ awards contract rewards
```

---

### 8. Healing Zone Restrictions

**WHERE IT LIVES**:
```
Lua:      ⬜ Could show message "Healing not permitted here"
C++:      🔴 COMPLETELY MISSING
Database: 🔴 COMPLETELY MISSING
```

**CURRENTLY MISSING ENTIRELY**:
```
Player casts healing spell in combat zone
  ✅ Lua shows spell cast animation
  ✅ C++ processes spell like normal
  [MISSING] No check for zone healing restrictions
  ✅ Healing works everywhere
  [BUG] Supposed healing-denied zones don't deny healing
```

**IF IMPLEMENTED**:
```
Player casts healing spell in combat zone
  ✅ Lua sends spell cast
  ✅ C++ SpellScript_HealingZoneRestriction hook
  ✅ C++ checks zone_healing_config table (if exists)
  ✅ C++ zone has allow_healing = false
  ❌ C++ returns SPELL_FAILED_CUSTOM_ERROR
  ✅ Lua shows error: "Healing is not permitted in this zone"
```

---

## Summary: Where Implementation is Missing

| System | Database | C++ Core | Integration Hooks | Lua UI |
|--------|----------|----------|-------------------|--------|
| Criminal Flags | ✅ | ❌ | ❌ | ⚠️ |
| Notoriety Decay | ✅ | ❌ | ❌ | ✅ |
| Buy Orders | ✅ | ⚠️ | ❌ | ✅ |
| Public Groups | ✅ | ⚠️ | ❌ | ✅ |
| Build Presets | ✅ | ⚠️ | ✅ | ✅ |
| Blessed Items | ✅ | ⚠️ | ⚠️ | ✅ |
| Caravans | ✅ | ⚠️ | ❌ | ✅ |
| Healing Zones | ❌ | ❌ | ❌ | ⚠️ |

**Legend**:
- ✅ = Complete
- ⚠️ = Partial/problematic
- ❌ = Missing

---

## The Missing Pieces Checklist

### C++ Missing (The Core Work)
- [ ] SetCriminalFlag() / ClearCriminalFlag() implementations
- [ ] OnPlayerAttack() hook for criminal flag setting
- [ ] NotorietyDecay timer (WorldScript)
- [ ] Notoriety increment on PvP kill
- [ ] BuyOrderGeneration implementation
- [ ] Group::Create() integration for public groups
- [ ] Caravan::UpdateSpeed() to use movement formulas
- [ ] HealingZoneRestriction SpellScript (if needed)

### Integration Hooks (The Glue Work)
- [ ] WorldScript for criminal flag cleanup
- [ ] WorldScript for notoriety decay
- [ ] WorldScript for buy order regeneration
- [ ] PlayerScript for PvP kill tracking
- [ ] PlayerScript for death handling
- [ ] CreatureScript for caravan movement
- [ ] SpellScript for healing restrictions

### Database (The Schema)
- [ ] zone_healing_config table (if healing zones needed)
- [ ] ecosystem_spawning table (if spawn scheduler needed)

---

## Implementation Dependency Map

```
criminal_flag_cleanup (WorldScript)
    └── Depends on: SetCriminalFlag() C++ function

notoriety_decay (WorldScript)
    └── Depends on: Notoriety decay formula, zone multipliers

buy_order_gen (WorldScript)
    └── Depends on: GenerateBuyOrders() C++ function

bounty_on_kill (PlayerScript)
    └── Depends on: notoriety_decay, OnPlayerPVPKill() hook

public_group_creation
    └── Depends on: Group::Create() integration

caravan_movement
    └── Depends on: MortalCaravanMovement calculations being called

healing_zone_restriction
    └── Depends on: zone_healing_config table, SpellScript hook
```

---

## Testing Checklist by Layer

### Database Layer
```
[ ] character_criminal_flags: Can INSERT/UPDATE/DELETE
[ ] character_notoriety: Can UPDATE with decay values
[ ] mortal_buy_orders: Can INSERT new orders
[ ] zone_pvp_config: Can query for zone type
[ ] zone_healing_config: Exists (if healing zones needed)
```

### C++ Layer
```
[ ] SetCriminalFlag() compiles and executes
[ ] NotorietyDecay timer runs without errors
[ ] BuyOrderGeneration produces sensible data
[ ] Group::Create() is called for public groups
[ ] Caravan speed reflects cargo/terrain
[ ] HealingSpells are restricted in combat zones
```

### Integration Layer
```
[ ] OnPlayerAttack() triggers when it should
[ ] OnPlayerPVPKill() increments notoriety
[ ] OnPlayerDeath() checks blessed items
[ ] WorldScript timers tick without crashes
[ ] Lua UI receives updates when database changes
```

### Lua/UI Layer
```
[ ] Criminal flag icon displays when set
[ ] Notoriety level shows in character info
[ ] Buy order list refreshes when orders change
[ ] Group forms when confirmed
[ ] Caravan moves at different speeds
[ ] Healing restrictions show error message
```

