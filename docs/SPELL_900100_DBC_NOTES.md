# Spell 900100: Rift Participant Aura - DBC Configuration Notes

## Overview
This spell is a passive marker aura applied to players participating in planar rift events. It marks the player as a rift participant and may provide access to rift-specific content.

## DBC File: Spell.dbc

### Required Fields

**Row ID:** 900100

**Field Values:**
- **ID:** 900100
- **Name (enUS):** "Rift Participant"
- **Name (enGB):** "Rift Participant"
- **Rank:** ""
- **Description (enUS):** "Marks you as a participant in a planar rift event."
- **Description (enGB):** "Marks you as a participant in a planar rift event."
- **Tooltip (enUS):** "You are participating in a planar rift event."
- **Tooltip (enGB):** "You are participating in a planar rift event."

### Spell Attributes

**Category:** 0 (No category)
**Dispel Type:** 0 (None - cannot be dispelled)
**Mechanic:** 0 (None)

**Attributes (Field 4):**
- `0x00000008` - SPELL_ATTR0_NOT_SHAPESHIFT
- `0x00000080` - SPELL_ATTR0_PASSIVE (Passive aura)
- `0x00000100` - SPELL_ATTR0_DO_NOT_DISPLAY (Hidden from UI)

**AttributesEx (Field 5):**
- `0x00000020` - SPELL_ATTR1_NO_THREAT (Does not generate threat)

**AttributesEx2 (Field 6):**
- `0x00000004` - SPELL_ATTR2_CAN_TARGET_DEAD (Can be applied to dead targets)

### Casting Information

- **Cast Time:** 0 (Instant)
- **Recovery Time:** 0
- **Category Recovery Time:** 0
- **Start Recovery Time:** 0
- **Start Recovery Category:** 0

### Duration

- **Duration Index:** 21 (Permanent until cancelled)
- **Max Duration:** -1 (Permanent)
- **Max Stack:** 1

### Range

- **Min Range:** 0
- **Max Range:** 0 (Self-targeted)

### Effects

**Effect 1:**
- **Effect:** 6 (SPELL_EFFECT_APPLY_AURA)
- **EffectAura:** 4 (SPELL_AURA_DUMMY) - Marker aura
- **EffectBasePoints:** 1
- **EffectDieSides:** 0
- **EffectRealPointsPerLevel:** 0
- **EffectBasePoints:** 1
- **EffectMechanic:** 0
- **EffectImplicitTargetA:** 1 (Self)
- **EffectImplicitTargetB:** 0
- **EffectRadiusIndex:** 0
- **EffectApplyAuraName:** 4 (SPELL_AURA_DUMMY)
- **EffectAmplitude:** 0
- **EffectMultipleValue:** 0
- **EffectChainTarget:** 0
- **EffectItemType:** 0
- **EffectMiscValue:** 0
- **EffectTriggerSpell:** 0

**Effect 2:** None (0)
**Effect 3:** None (0)

### Visuals

- **SpellIconID:** 1 (or appropriate icon - suggest using a portal/rift icon)
- **ActiveIconID:** 0
- **SpellVisual[0]:** 0 (or appropriate visual)
- **SpellVisual[1]:** 0

### Power

- **PowerType:** -1 (No power cost)
- **ManaCost:** 0
- **ManaCostPerLevel:** 0
- **ManaPerSecond:** 0
- **ManaPerSecondPerLevel:** 0
- **ManaCostPercentage:** 0

### Interrupts

- **InterruptFlags:** 0 (Cannot be interrupted)
- **AuraInterruptFlags:** 0 (No aura interrupts)
- **ChannelInterruptFlags:** 0

### Other Fields

- **EquippedItemClass:** -1 (No item requirement)
- **EquippedItemSubClassMask:** 0
- **EquippedItemInventoryTypeMask:** 0
- **Totem[0]:** 0
- **Totem[1]:** 0
- **Reagent[0-7]:** 0 (No reagents)
- **ReagentCount[0-7]:** 0
- **RequiredCasterAuraSpell:** 0
- **ExcludeCasterAuraSpell:** 0
- **RequiredTargetAuraSpell:** 0
- **ExcludeTargetAuraSpell:** 0

## Implementation Notes

1. This spell is applied automatically when a player joins a rift event (see `MortalEldensEve.cpp::Rifts::JoinRift`)
2. The spell is removed when the player leaves the rift or the rift completes/fails
3. The spell serves as a marker to identify rift participants for reward distribution
4. The spell is passive and hidden from the UI to avoid clutter
5. The spell cannot be dispelled to prevent abuse

## Testing

After adding to Spell.dbc:
1. Verify spell loads correctly: `SELECT * FROM dbc_spell WHERE id = 900100;`
2. Test aura application in-game
3. Verify aura is hidden from UI
4. Verify aura persists while in rift phase
5. Verify aura is removed on rift exit

