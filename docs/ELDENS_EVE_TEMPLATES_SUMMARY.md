# Elden's Eve Layer - Template Definitions Summary

## Overview
This document summarizes all template definitions created for the Elden's Eve Layer system (Spec 45).

## Created Files

### 1. SQL Templates
- **`sql/121_planar_tear_world_scar_gameobjects.sql`**
  - Planar Tear GameObject (180000)
  - World Scar GameObject (180001)

- **`sql/122_eldens_eve_spell_item_templates.sql`**
  - Arcane Eye Trinket Item (900200)

### 2. DBC Documentation
- **`docs/SPELL_900100_DBC_NOTES.md`**
  - Detailed field-by-field reference for Spell 900100
  - Complete DBC structure documentation

- **`docs/SPELL_900100_DBC_SPEC.json`**
  - Structured JSON specification for automated patching
  - Can be used by DBC patching tools or scripts

- **`docs/SPELL_900100_DBC_PATCH_INSTRUCTIONS.md`**
  - Step-by-step guide for manual DBC patching
  - Instructions for WDBX Editor, DBCUtil, and programmatic methods

### 3. Launcher Integration
- **`launcher/src/spell_patcher.rs`** (Updated)
  - Added spell 900100 to marker file
  - References documentation files

## Template Definitions

### Spell 900100: Rift Participant Aura
**Status:** Documentation complete, requires DBC patching

**Purpose:** Passive marker aura applied to players in planar rift events

**Key Properties:**
- Hidden from UI (SPELL_ATTR0_DO_NOT_DISPLAY)
- Passive aura (SPELL_ATTR0_PASSIVE)
- Permanent duration until cancelled
- Cannot be dispelled
- Effect: SPELL_AURA_DUMMY (marker only)

**Implementation:**
- Applied automatically in `MortalEldensEve.cpp::Rifts::JoinRift`
- Removed in `LeaveRift`, `CompleteRift`, and `FailRift`

**Next Steps:**
1. Use `docs/SPELL_900100_DBC_PATCH_INSTRUCTIONS.md` to patch Spell.dbc
2. Or use `docs/SPELL_900100_DBC_SPEC.json` for automated patching
3. Package patched DBC in Patch-Z MPQ or place in `Data/dbc/`

---

### Item 900200: Arcane Eye Trinket
**Status:** SQL template created, requires displayId assignment

**Purpose:** Trinket that allows players to detect planar anomalies

**Key Properties:**
- Class: 4 (ITEM_CLASS_CONSUMABLE)
- InventoryType: 12 (INVTYPE_TRINKET)
- Quality: 3 (RARE/Blue)
- Buy Price: 5 gold
- Required Level: 1
- Item Level: 60

**Implementation:**
- Checked in `MortalEldensEve.cpp::Anomalies::CanDetectAnomaly`
- Alternative: Explorer mastery (25+ points) also enables detection

**Next Steps:**
1. Run `sql/122_eldens_eve_spell_item_templates.sql`
2. Set displayId to appropriate trinket model:
   ```sql
   UPDATE item_template SET displayid = [chosen_id] WHERE entry = 900200;
   ```
3. Query existing trinkets for reference:
   ```sql
   SELECT entry, displayid, name FROM item_template 
   WHERE InventoryType = 12 LIMIT 10;
   ```

---

### GameObject 180000: Planar Tear
**Status:** SQL template created

**Purpose:** Visual representation of active planar rift

**Key Properties:**
- Type: 10 (GO_TYPE_GENERIC - interactable)
- DisplayId: 181402 (Naxxramas portal visual)
- Size: 1.5x scale
- Script: `GameObjectScript_MortalRifts`

**Implementation:**
- Spawned in `MortalEldensEve.cpp::Rifts::SpawnRiftGameObject`
- Called from `StartRift`

**Next Steps:**
1. Run `sql/121_planar_tear_world_scar_gameobjects.sql`
2. Verify GameObject template loads correctly
3. Test spawning in-game

---

### GameObject 180001: World Scar
**Status:** SQL template created, may need displayId adjustment

**Purpose:** Permanent visual mark showing where a rift event occurred

**Key Properties:**
- Type: 3 (GO_TYPE_TRAP - non-interactable visual)
- DisplayId: 0 (may need adjustment - see alternatives in SQL)
- Size: 2.0x scale
- Respawn: 7 days

**Implementation:**
- Spawned in `MortalEldensEve.cpp::Rifts::CompleteRift` and `FailRift`

**Next Steps:**
1. Run `sql/121_planar_tear_world_scar_gameobjects.sql`
2. If displayId 0 doesn't render, uncomment and use alternative:
   - 327 (generic ground effect)
   - 1287 (Heigan eruption effect)
   - 181356 (Sapphiron birth effect)
3. Test spawning in-game

---

## Implementation Checklist

### Completed ✅
- [x] SQL templates for all GameObjects
- [x] SQL template for Arcane Eye trinket
- [x] DBC documentation for Spell 900100
- [x] JSON specification for automated patching
- [x] Step-by-step patching instructions
- [x] Launcher integration (marker file updated)
- [x] Code integration (C++ implementation complete)

### Pending ⏳
- [ ] Patch Spell.dbc with spell 900100 (use provided documentation)
- [ ] Set displayId for Arcane Eye trinket (900200)
- [ ] Verify displayId for World Scar (180001) - may need adjustment
- [ ] Test all templates in-game
- [ ] Package patched DBC in Patch-Z MPQ (if using MPQ method)

---

## Quick Reference

**Spell ID:** 900100  
**Item ID:** 900200  
**GameObject IDs:** 180000, 180001

**Documentation:**
- DBC Notes: `docs/SPELL_900100_DBC_NOTES.md`
- JSON Spec: `docs/SPELL_900100_DBC_SPEC.json`
- Patch Guide: `docs/SPELL_900100_DBC_PATCH_INSTRUCTIONS.md`

**SQL Files:**
- GameObjects: `sql/121_planar_tear_world_scar_gameobjects.sql`
- Item: `sql/122_eldens_eve_spell_item_templates.sql`

**Code Integration:**
- C++: `src/MortalEldensEve.cpp`
- Launcher: `launcher/src/spell_patcher.rs`

