# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.4 — Content Lane Bundle  
### File: 80-content-lane-frontier-bruiser-quest-and-loot-bundle.md  
### Lane: Frontier Bruiser (Greycrag Militia → Linebreaker Vanguard)

---

## 1. Purpose

This document is a **Cursor-ready implementation bundle** for a single, highly-used content lane:

> **Frontier Bruiser** — melee frontline character path  
> T1: **Greycrag Militia**  
> T2: **Linebreaker Vanguard**

It includes:

- Concrete **quest chains** (T1 Port Meridian Militia Arc, T2 Greycrag Frontier Contracts).
- Where and how **T1/T2 items and Runes** drop or are rewarded.
- **SQL stubs** for quests, items, loot templates, vendors.
- **Eluna script skeletons** for events and Contracts.
- A testing checklist so you can verify the lane end-to-end.

Use this as the **pattern** for building out other lanes (healer, ranger, mage, etc.).

---

## Related Specs

For full context on content lanes and quest bundles, see:

- **`77-mortal-itemization-t1-t2-starter-sets.md`** — Starter sets that this lane provides
- **`87-mortal-archetype-grid.md`** — Archetype grid that defines Frontier Bruiser archetype
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Task boards and contracts used in this lane
- **`03-risk-zones.md`** — Risk zones that this lane navigates
- **`01-progression.md`** — Progression system that this lane supports
- **`51-factions-and-standing-system.md`** — Faction standing that this lane affects
- **`88-mortal-progression-era-map.md`** — Progression eras that this lane fits into

---

## 2. World Anchors & NPCs

### 2.1 Locations

- **Port Meridian Barracks** (Green Zone hub)
  - Militia training grounds.
  - Hosts:
    - Militia Commander NPC,
    - Militia Quartermaster,  
    - Militia Task Board.

- **Greycrag Stronghold** (Yellow Zone frontier hub)
  - Forward base near contested border.
  - Hosts:
    - Linebreaker Captain NPC,
    - Frontier Smith (crafting vendor),
    - Frontier Contract Board,
    - Stronghold Quartermaster.

### 2.2 Key NPCs (Conceptual)

> You will assign actual `entry` IDs according to your DB conventions.

- **NPC: Captain Arlen Stonefist**  
  - Location: Port Meridian Barracks.  
  - Role: T1 Militia quest giver.

- **NPC: Sergeant Lysa Hawktide**  
  - Location: Barracks training yard / gate.  
  - Role: T1 follow-up quests, patrol lead.

- **NPC: Militia Quartermaster Bram**  
  - Location: Barracks armory.  
  - Role: Vendor for Greycrag Militia gear.

- **NPC: Captain Jorik Linebreaker**  
  - Location: Greycrag Stronghold command tent.  
  - Role: T2 Linebreaker quest & contract giver.

- **NPC: Ironhand Thora (Frontier Smith)**  
  - Location: Greycrag forge.  
  - Role: T2 crafting recipes vendor for Linebreaker gear.

- **NPC: Stronghold Quartermaster Rurik**  
  - Location: Greycrag inner courtyard.  
  - Role: Token & Warfront reward vendor (Linebreaker accessories).

---

## 3. T1 Quest Chain — Port Meridian Militia Arc

Goal:  
By the end of this arc, a player who leans into melee frontline play will:

- Understand **Brace + melee basics**,
- Be introduced to **Green-zone Tasks**,
- Earn most of the **Greycrag Militia** set & a basic combat Rune.

### 3.1 Quest Overview

1. **Q1 – “Call to the Line”**  
   - Type: Intro, speaks-to NPCs, training.  
   - Rewards: Militia boots & gloves.

2. **Q2 – “First Patrol”**  
   - Type: Kill & investigate along nearby road.  
   - Rewards: Militia helm + Militia ring.

3. **Q3 – “Hold the Crossing”**  
   - Type: Small event, defend a bridge vs waves (triggered via Eluna).  
   - Rewards: Militia chest piece.

4. **Q4 – “Militia Muster”**  
   - Type: 3-player mini-scenario instance or phased event.  
   - Rewards: **Greycrag Militia Blade** + basic combat Rune (Cleaving Strike).

### 3.2 Example Quest Template IDs

> Adjust IDs to fit your DB range.

- Q1: `70001` – Call to the Line  
- Q2: `70002` – First Patrol  
- Q3: `70003` – Hold the Crossing  
- Q4: `70004` – Militia Muster

### 3.3 Quest Flow Details

#### Q1 – Call to the Line (ID: 70001)

- Giver: Captain Arlen Stonefist.  
- Objectives:
  - Speak to Sergeant Lysa Hawktide in the yard.
  - Perform basic Brace training on a dummy (custom spell/use object).
- On completion:
  - Unlocks Q2.
  - Rewards:
    - `Militia Marching Boots` (T1 boots),
    - `Militia Grips` (T1 gloves),
    - Small gold.

**Quest Template Stub (SQL)**

```sql
INSERT INTO quest_template (ID, Method, QuestLevel, MinLevel, QuestType,
    ZoneOrSort, Type, RequiredRaces, RequiredClasses, RequiredSkillId,
    RequiredSkillPoints, RequiredFactionId1, RequiredFactionValue1,
    Title, Details, Objectives, OfferRewardText, RequestItemsText, EndText,
    RewardItem1, RewardAmount1,
    RewardItem2, RewardAmount2,
    RewardMoney)
VALUES
(70001, 2, 1, 1, 0,
  1, 0, 0, 0, 0,
  0, 0, 0,
  'Call to the Line',
  'Captain Stonefist has called for all able recruits to report for militia training...',
  'Speak to Sergeant Hawktide and complete basic training.',
  'You''ve shown enough grit to stand in the line, recruit.',
  '', '',
  900010, 1,   -- Militia Marching Boots
  900011, 1,   -- Militia Grips
  500);        -- small gold
```

> Note: text is placeholder; adapt tone to Mortal style later.

---

#### Q2 – First Patrol (ID: 70002)

- Giver: Sergeant Lysa Hawktide.  
- Objectives:
  - Kill 8 `Highway Bandit` in a nearby area.
  - Interact with 3 “Disturbed Ground” objects (investigation).
- Completion:
  - Rewards:
    - `Militia Iron Coif` (helm),
    - `Iron-Signed Band` (ring),
    - XP/gold.

---

#### Q3 – Hold the Crossing (ID: 70003)

- Giver: Sergeant Lysa Hawktide, after Q2.  
- Objectives:
  - Travel to a bridge outside Port Meridian.
  - Talk to an NPC to **start an event**:
    - 3 waves of bandits spawn via Eluna script.
    - Player must survive & kill them.
- Completion:
  - Rewards:
    - `Militia Chain Hauberk` (chest).

**Event Hook (Eluna Skeleton)**

```lua
-- scripts/mortal/port_meridian/hold_the_crossing.lua
local EVENT_NPC_ENTRY = 60001   -- bridge defender NPC
local WAVE_CREATURE_ENTRY = 60100

local function StartHoldTheCrossing(event, player, unit)
    -- Spawn waves, track completion
    -- On success, credit quest 70003
end

RegisterCreatureGossipEvent(EVENT_NPC_ENTRY, 1, StartHoldTheCrossing)
```

---

#### Q4 – Militia Muster (ID: 70004)

- Giver: Captain Stonefist after Q3.  
- Type:  
  - Small instanced or phased scenario with up to 3 players:
    - Defend a choke point,
    - Use Brace & melee skills,
    - Kill a minor named boss.
- Completion:
  - Rewards:
    - `Greycrag Militia Blade` (T1 1H sword),
    - **Rune of Cleaving Strike** (T1 combat Rune, as an item).

Optional stretch goal:

- If the group completes scenario without any player death:
  - Extra reward: small Militia Service Token.

---

### 3.4 Militia Quartermaster Vendor (T1 Backfill)

- NPC: Militia Quartermaster Bram.  
- Sells:
  - All Greycrag Militia set pieces at modest cost in **Militia Tokens** + gold.
- Token source:
  - Militia Tasks (simple kill/deliver quests),
  - Completion of Q3/Q4 events.

**Vendor Stub (SQL)**

```sql
INSERT INTO npc_vendor (entry, item, maxcount, incrtime, ExtendedCost)
VALUES
(61001, 900010, 0, 0, 1001),  -- Boots, cost: ExtendedCost 1001 (Militia Token bundle)
(61001, 900011, 0, 0, 1001),
(61001, 900012, 0, 0, 1001),
(61001, 900013, 0, 0, 1001),
(61001, 900014, 0, 0, 1001),
(61001, 900015, 0, 0, 1001),
(61001, 900016, 0, 0, 1001),
(61001, 910010, 0, 0, 1002);  -- Rune item
```

> ExtendedCost IDs reference your own `item_extended_cost` rows, which should include Militia Tokens & gold.

---

## 4. T2 Progression — Greycrag Frontier & Linebreaker Vanguard

Once players have some Green-zone experience and partial T1 gear, they naturally flow into **Greycrag Stronghold** and T2 content.

### 4.1 T2 Quest Overview

1. **Q5 – “To the Greycrag”**  
   - Travel/intro quest from Port Meridian → Greycrag Stronghold.  
   - Rewards: small gold, unlocks Greycrag systems.

2. **Q6 – “Lines in the Dust”**  
   - Frontier scouting & first skirmishes.  
   - Rewards: Linebreaker boots & gloves.

3. **Q7 – “Break Their Charge”**  
   - Defend Greycrag vs raid or invasion event waves.  
   - Rewards: Linebreaker helm & pants.

4. **Q8 – “Linebreaker’s Oath”**  
   - Small multi-stage contract-like quest:
     - Escort supply caravan,
     - Kill elite in Yellow zone,
     - Return to Captain Jorik.
   - Rewards:
     - `Linebreaker War-Axe` (2H),
     - Linebreaker Necklace or Ring,
     - Rune of Mortal Strike.

### 4.2 Frontier Contract Board (Repeatable)

- After Q5 completes:
  - Player sees **Frontier Contract Board** in Greycrag:
    - Caravans,
    - Bandit culls,
    - Siege prep tasks.
- Each Contract has a chance to drop/currency to buy:
  - Additional Linebreaker pieces,
  - Higher-tier Runes (Brace Counter, Iron Advance).

---

## 5. Item & Rune IDs (Example Mapping)

> You can adjust IDs, but try to keep them grouped for sanity.

### 5.1 T1 Greycrag Militia Items

- 900010 – Militia Marching Boots  
- 900011 – Militia Grips  
- 900012 – Militia Iron Coif  
- 900013 – Militia Chain Hauberk  
- 900014 – Militia Chain Leggings  
- 900015 – Greycrag Oath Pendant  
- 900016 – Iron-Signed Band  
- 900017 – Greycrag Militia Blade  

### 5.2 T2 Linebreaker Vanguard Items

- 900100 – Linebreaker Tread Boots  
- 900101 – Linebreaker Crusher Gauntlets  
- 900102 – Linebreaker War-Visor  
- 900103 – Linebreaker Bulwark Cuirass  
- 900104 – Linebreaker March Greaves  
- 900105 – Vanguard Signet  
- 900106 – Vanguard Iron Torque  
- 900107 – Linebreaker War-Axe  

### 5.3 Rune Items (Weapon & Mobility/Guard)

- 910010 – Rune of Cleaving Strike (T1, basic Combat)  
- 910011 – Rune of Mortal Strike (T2, Combat)  
- 910012 – Rune of Brace Counter (T2, Guard)  
- 910013 – Rune of Iron Advance (T2, Mobility/Guard)  

**Rune Definition Stubs**

```sql
INSERT INTO mortal_rune_def (rune_key, item_entry, category, spell_id,
                             allowed_slot_mask, max_rank, is_consumable)
VALUES
('RUNE_CLEAVING_STRIKE', 910010, 1, 50010, 1, 1, 1),
('RUNE_MORTAL_STRIKE',   910011, 1, 50011, 1, 1, 1),
('RUNE_BRACE_COUNTER',   910012, 3, 50012, 3, 1, 1), -- Guard; e.g. weapon+chest mask
('RUNE_IRON_ADVANCE',    910013, 4, 50013, 4, 1, 1); -- Mobility; e.g. boots-only mask
```

---

## 6. Loot Templates & Contract Rewards

### 6.1 Dungeon Drops

Example: **Shadowfang Keep (Frontier Delve)**

- Boss: `Commander Springvale` (reworked entry ID).  
- Add:

```sql
INSERT INTO creature_loot_template (entry, item, ChanceOrQuestChance, groupid, mincount, maxcount)
VALUES
(20010, 900102, 12.0, 1, 1, 1), -- Linebreaker War-Visor
(20010, 900104, 10.0, 1, 1, 1), -- Linebreaker March Greaves
(20010, 910011, 5.0,  2, 1, 1); -- Rune of Mortal Strike
```

- Boss: `Baron Silverlaine`
  - Chance to drop:
    - 900103 (Chest),
    - 900107 (War-Axe).

### 6.2 Frontier Contract Rewards

In `mortal_contract_template`, set reward family tags (pseudocode):

- `reward_set_family = 'SET_LINEBREAKER_VANGUARD'`
- `reward_rune_family = 'RUNE_FAMILY_BRUISER_T2'`

Then, in Eluna reward resolver:

```lua
local function RewardLinebreakerItem(player)
    -- Look up which Linebreaker pieces they lack
    -- Roll from that pool
end

local function OnContractCompleted(event, player, contractId)
    if IsFrontierContract(contractId) then
        RewardLinebreakerItem(player)
        MaybeGrantRune(player, 'RUNE_FAMILY_BRUISER_T2')
    end
end
```

---

## 7. Eluna Script Skeletons

### 7.1 Militia Muster Scenario

File: `scripts/mortal/port_meridian/militia_muster.lua`

```lua
local INSTANCE_MAP_ID = 800  -- custom scenario map
local FINAL_BOSS_ENTRY = 65001
local QUEST_ID = 70004

local function OnInstanceBossDeath(event, creature, killer)
    local players = creature:GetPlayersInRange(100)
    for _, plr in ipairs(players) do
        if plr:HasQuest(QUEST_ID) then
            plr:CompleteQuest(QUEST_ID)
        end
    end
end

RegisterCreatureEvent(FINAL_BOSS_ENTRY, 4, OnInstanceBossDeath)
```

### 7.2 Greycrag Defense Event

File: `scripts/mortal/greycrag/defense_event.lua`

```lua
local EVENT_TRIGGER_ENTRY = 62001
local QUEST_ID = 70007  -- e.g. 'Break Their Charge'

local function OnStartDefense(event, player, unit)
    -- spawn waves, track state
    -- on success: CompleteQuest(QUEST_ID) for all participants
end

RegisterCreatureGossipEvent(EVENT_TRIGGER_ENTRY, 1, OnStartDefense)
```

---

## 8. Testing Checklist

1. **Quest Flow**
   - Create new character → reach Port Meridian.
   - Verify Q1–Q4 sequences appear correctly.
   - Complete Q4 → ensure you receive:
     - Greycrag Militia Blade,
     - Rune of Cleaving Strike.

2. **Vendor Access**
   - After Q2/Q3, confirm Militia Quartermaster offers missing Militia pieces.
   - Check ExtendedCost uses correct Token items.

3. **Rune Functionality**
   - Socket Rune of Cleaving Strike into Militia Blade.
   - Confirm ability appears and works as intended.
   - Confirm losing weapon in PvP removes access to ability.

4. **Transition to T2**
   - Complete “To the Greycrag” and Q6–Q8.
   - Participate in a Frontier Contract; verify:
     - Linebreaker drops or rewards,
     - Rune of Mortal Strike can be obtained.

5. **Dungeon Drops**
   - Run Shadowfang Keep variant:
     - Check boss loot tables for Linebreaker gear and rune.

6. **Economy Sanity**
   - Verify gold rewards from quests and Contracts stay within planned faucet targets.
   - Confirm repair/decay + shrine donations act as sinks.

---

This bundle gives you a **fully wired lane**:

- The most likely core melee archetype has:
  - A clear, lore-consistent progression from T1 → T2,
  - Quests, dungeons, Contracts, and vendors all hooked together,
  - Gear and Rune upgrades that feel natural within your sandbox economy and full-loot rules.

Use it as the template for building:

- Shrine + Sanctum Warden lane,
- Ranger + Longroad lane,
- Spellfire Magus offensive lane,
- And future T3–T5 expansions.  
