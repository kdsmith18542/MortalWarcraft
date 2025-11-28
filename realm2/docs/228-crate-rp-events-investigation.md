# Crate RP Events Investigation - Issue #15629

**Date:** 2025-01-23  
**Status:** Investigation Needed

---

## Issue Summary

When crates are revealed using the Arcane Disruptor, no RP events occur. Each crate should trigger a specific NPC reaction:

1. **Crate 1** (closest to entrance): Roger Owens - goes to inn, discovers crate, runs to find guard
2. **Crate 2**: Sergeant Morigan - inspects crate next to Perelli, discovers plague, leaves to alert Arthas
3. **Crate 3**: Jena Anderson - asks to borrow grain from Martha Goslin, discovers plague, leaves to find guard
4. **Crate 4**: Malcolm Moore + Scruffy (dog) - approaches from side of house, dog smells crate, Malcolm tells Scruffy to stay, walks to eastern guard tower
5. **Crate 5**: Bartleby Battson - loads crates back into cart, observes plague, complains, goes to inn for guard
6. **After all 5**: Lordaeron Crier at eastern guard tower yells for all guards to come to Stratholme

---

## Current Implementation

The crate reveal system uses:
- `npc_crate_helper` creature script attached to each crate
- Detects `SPELL_ARCANE_DISRUPTION` (49590)
- Calls `instance->SetData(DATA_CRATE_COUNT, 0)` to increment counter
- Transforms `GO_SUSPICIOUS_CRATE` (190094) to `GO_PLAGUED_CRATE` (190095)

**Problem:** The system doesn't track which specific crate was revealed, only the total count.

---

## Required Changes

### 1. Identify Crate Number
Need to determine which crate (1-5) was revealed. Options:
- Use crate position/coordinates to identify
- Add a data field to `npc_crate_helper` to store crate number
- Use creature GUID mapping
- Check distance/position relative to known landmarks

### 2. Find NPC IDs
Need to find NPC entry IDs for:
- Roger Owens
- Sergeant Morigan
- Jena Anderson
- Malcolm Moore
- Scruffy (dog)
- Bartleby Battson
- Lordaeron Crier

### 3. Create NPC Scripts
For each NPC, create SmartAI scripts or C++ scripts to:
- Detect when their crate is revealed (via instance data or event)
- Perform their specific RP sequence (movement, emotes, text)
- Despawn or move to destination after RP

### 4. Modify Crate System
Update `npc_crate_helper` to:
- Identify which crate number it represents
- Pass crate number to instance script
- Instance script triggers appropriate NPC event

---

## Implementation Approach

### Option A: Position-Based Crate Identification
- Store crate positions in array
- When crate is revealed, check position against array to determine crate number
- Pros: No database changes needed
- Cons: Requires exact position matching

### Option B: Data Field in Instance Script
- Add crate number tracking to instance script
- Each `npc_crate_helper` has a data field indicating its crate number
- Pros: Clean, explicit
- Cons: Requires database or script changes

### Option C: SmartAI Event System
- Use SmartAI `SMART_EVENT_ACTION_DONE` or custom event
- Instance script broadcasts crate reveal event with crate number
- NPCs listen for their specific crate number
- Pros: Flexible, database-driven
- Cons: More complex setup

---

## Next Steps

1. **Find NPC IDs** - Search database or Wowhead for the 7 NPCs
2. **Identify Crate Positions** - Map crate positions to crate numbers
3. **Choose Implementation** - Decide on crate identification method
4. **Create NPC Scripts** - SmartAI or C++ scripts for each NPC
5. **Test RP Sequences** - Verify each NPC performs correct actions

---

**Last Updated:** 2025-01-23

