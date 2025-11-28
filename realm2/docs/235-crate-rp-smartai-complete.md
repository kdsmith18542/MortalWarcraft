# Crate RP Events - SmartAI Scripts Complete

**Date:** 2025-01-23  
**Status:** SmartAI Scripts Created

---

## ✅ Completed

### SmartAI Scripts Created

All SmartAI scripts have been created for the crate RP events:

1. **Roger Owens (27903)** - Crate 1
   - Listens for ACTION_CRATE_REVEALED (event 72, param1=100)
   - Moves to inn → Emote → Text → Move to guard → Despawn

2. **Sergeant Morigan (27877)** - Crate 2
   - Listens for ACTION_CRATE_REVEALED
   - Emote (inspect) → Text (plague discovery) → Move to Stratholme → Despawn

3. **Jena Anderson (27885)** - Crate 3
   - Listens for ACTION_CRATE_REVEALED
   - Text (ask for grain) → Emote → Text (plague discovery) → Move to guard → Despawn

4. **Malcolm Moore (27891)** - Crate 4
   - Listens for ACTION_CRATE_REVEALED
   - Move to crate → Text to Scruffy → Move to guard tower → Despawn

5. **Scruffy (27892)** - Crate 4 (Dog)
   - Listens for ACTION_CRATE_REVEALED
   - Emote (smell/work)

6. **Bartleby Battson (27907)** - Crate 5
   - Listens for ACTION_CRATE_REVEALED
   - Emote (work) → Text (observe plague) → Text (complain) → Move to inn → Despawn

7. **Lordaeron Crier (27913)** - After all 5 crates
   - Listens for ACTION_CRATE_REVEALED
   - Yell text

---

## ⚠️ Remaining Work

### 1. Creature Text Entries

Need to add/verify `creature_text` entries for:
- **Roger Owens (27903)**: Line 0 - "What's this? The grain is tainted!"
- **Sergeant Morigan (27877)**: Line 6 - "This grain is plagued! I must alert Prince Arthas!"
- **Jena Anderson (27885)**: 
  - Line 4 - "Martha, could I borrow some grain?"
  - Line 5 - "Oh no! This grain is tainted!"
- **Malcolm Moore (27891)**: Line 0 - "Scruffy, stay! I'll check this out."
- **Bartleby Battson (27907)**: Line 4 - "This grain shipment is plagued!"
- **Lordaeron Crier (27913)**: Line 0 - "All guards! Report to Stratholme immediately! The grain is plagued!"

### 2. Coordinate Verification

All coordinates in the SmartAI scripts are approximate and need verification:
- Inn location: ~1810, 1285, 140
- Guard locations: ~1800, 1290, 140 and ~1950, 1350, 140
- Stratholme direction: ~1900, 1300, 140
- Crate positions: Need to verify actual crate locations

### 3. Emote IDs

Verify emote IDs:
- Emote 1 = Wave
- Emote 35 = Work
- Emote 69 = Use Standing

---

## SmartAI Script Structure

### Event Type
- **72** = SMART_EVENT_ACTION_DONE
- **event_param1 = 100** = ACTION_CRATE_REVEALED

### Action Types Used
- **1** = SMART_ACTION_TALK (creature_text)
- **5** = SMART_ACTION_PLAY_EMOTE
- **41** = SMART_ACTION_DESPAWN
- **52** = SMART_EVENT_TEXT_OVER (linked event)
- **61** = SMART_EVENT_LINK (chain actions)
- **69** = SMART_ACTION_MOVE_TO_POS

---

## Testing Checklist

- [ ] Verify NPC spawn positions
- [ ] Verify crate positions and identification
- [ ] Test each NPC's RP sequence
- [ ] Verify text entries display correctly
- [ ] Verify emotes play correctly
- [ ] Verify movement paths
- [ ] Verify despawn timing
- [ ] Test Lordaeron Crier yell after all 5 crates

---

**Last Updated:** 2025-01-23

