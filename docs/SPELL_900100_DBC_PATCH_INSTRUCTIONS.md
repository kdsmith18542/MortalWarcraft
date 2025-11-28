# Spell 900100: Rift Participant Aura - DBC Patching Instructions

## Overview
This document provides step-by-step instructions for adding spell 900100 to Spell.dbc using common DBC editors.

## Prerequisites
- Extracted Spell.dbc file (from MPQ archives or `azerothcore/data/dbc/`)
- DBC Editor (WDBX Editor, DBCUtil, or similar)
- Backup of original Spell.dbc

## Method 1: Using WDBX Editor (Recommended)

### Step 1: Open Spell.dbc
1. Launch WDBX Editor
2. File → Open → Select `Spell.dbc`
3. Wait for file to load (may take a moment for large files)

### Step 2: Add New Row
1. Right-click in the spell list → "Add Row" or press `Insert`
2. Navigate to row ID 900100 (or find an empty row near that ID)
3. If row 900100 already exists, you can either:
   - Overwrite it (if it's unused)
   - Use the next available ID (900101, 900102, etc.)

### Step 3: Configure Spell Fields

#### Basic Information
- **ID:** 900100
- **Name (enUS):** "Rift Participant"
- **Name (enGB):** "Rift Participant"
- **Rank:** "" (empty)
- **Description (enUS):** "Marks you as a participant in a planar rift event."
- **Description (enGB):** "Marks you as a participant in a planar rift event."
- **Tooltip (enUS):** "You are participating in a planar rift event."
- **Tooltip (enGB):** "You are participating in a planar rift event."

#### Spell Attributes
- **Category:** 0
- **Dispel Type:** 0 (None)
- **Mechanic:** 0 (None)
- **Attributes:** `0x00000188` (combines: NOT_SHAPESHIFT + PASSIVE + DO_NOT_DISPLAY)
  - Or set individual flags:
    - SPELL_ATTR0_NOT_SHAPESHIFT: `0x00000008`
    - SPELL_ATTR0_PASSIVE: `0x00000080`
    - SPELL_ATTR0_DO_NOT_DISPLAY: `0x00000100`
- **AttributesEx:** `0x00000020` (SPELL_ATTR1_NO_THREAT)
- **AttributesEx2:** `0x00000004` (SPELL_ATTR2_CAN_TARGET_DEAD)

#### Casting & Duration
- **Cast Time Index:** 1 (Instant)
- **Duration Index:** 21 (Permanent until cancelled)
- **Max Duration:** -1
- **Max Stack:** 1

#### Range
- **Min Range:** 0
- **Max Range:** 0 (Self-targeted)
- **Range Index:** 1 (Self)

#### Effect 1 (Primary Effect)
- **Effect:** 6 (SPELL_EFFECT_APPLY_AURA)
- **EffectAura:** 4 (SPELL_AURA_DUMMY)
- **EffectBasePoints:** 1
- **EffectDieSides:** 0
- **EffectRealPointsPerLevel:** 0
- **EffectBasePoints:** 1
- **EffectMechanic:** 0
- **ImplicitTargetA:** 1 (Self)
- **ImplicitTargetB:** 0
- **EffectRadiusIndex:** 0
- **EffectApplyAuraName:** 4 (SPELL_AURA_DUMMY)
- **EffectAmplitude:** 0
- **EffectMultipleValue:** 0
- **EffectChainTarget:** 0
- **EffectItemType:** 0
- **EffectMiscValue:** 0
- **EffectTriggerSpell:** 0

#### Effect 2 & 3
- Leave as 0 (No effect)

#### Power
- **PowerType:** -1 (No power cost)
- **ManaCost:** 0
- **ManaCostPerLevel:** 0
- **ManaPerSecond:** 0
- **ManaPerSecondPerLevel:** 0
- **ManaCostPercentage:** 0

#### Interrupts
- **InterruptFlags:** 0
- **AuraInterruptFlags:** 0
- **ChannelInterruptFlags:** 0

#### Visuals
- **SpellIconID:** 1 (or appropriate portal/rift icon)
- **ActiveIconID:** 0
- **SpellVisual[0]:** 0
- **SpellVisual[1]:** 0

#### Equipment Requirements
- **EquippedItemClass:** -1 (No requirement)
- **EquippedItemSubClassMask:** 0
- **EquippedItemInventoryTypeMask:** 0

### Step 4: Save
1. File → Save
2. Create backup if prompted
3. Verify the spell entry was saved correctly

### Step 5: Package for Client
1. Place patched `Spell.dbc` in `Data/dbc/` (for loose files)
2. OR create Patch-Z MPQ:
   - Create `patch-Mortal.MPQ` or `patch-Z.MPQ`
   - Add `Spell.dbc` to the MPQ at path `DBFilesClient\Spell.dbc`
   - Place MPQ in client `Data/` directory

## Method 2: Using DBCUtil (Command Line)

If you have DBCUtil or similar command-line tools:

```bash
# Export Spell.dbc to CSV
dbcutil export Spell.dbc Spell.csv

# Edit Spell.csv (add row 900100 with values from spec)

# Import back to DBC
dbcutil import Spell.csv Spell_patched.dbc
```

## Method 3: Programmatic Patching (Launcher Integration)

The launcher's `spell_patcher.rs` can be extended to programmatically add this spell. See `docs/SPELL_900100_DBC_SPEC.json` for structured data format.

## Verification

After patching:

1. **Server-side:** Verify spell loads:
   ```sql
   -- If spell_dbc table exists
   SELECT * FROM spell_dbc WHERE id = 900100;
   ```

2. **Client-side:** Test in-game:
   - Apply spell via console: `.cast 900100`
   - Verify aura appears (though it should be hidden)
   - Verify spell info displays correctly

3. **Integration:** Test with rift system:
   - Join a planar rift event
   - Verify aura is applied automatically
   - Verify aura persists while in rift phase
   - Verify aura is removed on exit

## Troubleshooting

### Spell doesn't appear in game
- Check that Spell.dbc is in correct location (Data/dbc/ or in Patch-Z MPQ)
- Verify client is loading patched DBC (check client logs)
- Ensure spell ID doesn't conflict with existing spells

### Aura visible when it shouldn't be
- Verify SPELL_ATTR0_DO_NOT_DISPLAY flag is set (0x00000100)
- Check that Attributes field includes this flag

### Aura doesn't persist
- Verify Duration Index is 21 (Permanent)
- Check that AuraInterruptFlags is 0
- Verify spell is not being dispelled

## Related Files
- `docs/SPELL_900100_DBC_NOTES.md` - Detailed field reference
- `docs/SPELL_900100_DBC_SPEC.json` - Structured specification
- `src/MortalEldensEve.cpp` - Implementation code (lines 1268-1271)

