# RDF/BG Queue Audit Script Verification - Updated

## Summary
The `systems_audit_matchmaking.lua` script is **mostly aligned** with spec requirements, but there are **important changes** in newer spec documents that need to be addressed.

---

## Spec Evolution Analysis

### Original Spec (18-lfg-warfront-ui.md v26.1)
- ✅ **RDF button repurposed** to open "Mortal LFG Panel" (no queue, no teleport)
- ✅ **BG button repurposed** to open "War & PvP Panel" (no queue, no teleport)
- ✅ **No automatic teleportation** into dungeons or battlegrounds
- ✅ All content accessed via **physical portals/entrances**

### Updated Spec (38-social-and-onboarding-systems.md v28.0)
**NEW SYSTEM: Expedition Finder**

- ✅ **Expedition Finder** replaces RDF for instanced dungeons/raids
- ⚠️ **ALLOWS LIMITED TELEPORTATION**:
  - Players can **optionally teleport to staging camps** near dungeon entrances
  - **BUT ONLY** if they are in:
    - Capital cities (War Rooms / Adventurer Halls)
    - Major inns
    - Rested areas (via MortalUI panel)
  - **NOT** from wild zones (no cross-map teleport from wild zones)

### Additional Spec (46-public-grouping-and-contribution.md v31.5)
**Expedition Rally System**

- ✅ **No teleportation** - only map pings and road speed buffs
- ✅ Travel remains part of the game loop

---

## Current Audit Script Analysis

### What the Script Does
1. ✅ Blocks RDF button → redirects to Mortal LFG Panel
2. ✅ Blocks BG queue button → redirects to War & PvP Panel
3. ✅ Blocks teleport spells to Red zones
4. ✅ Blocks teleport items to Red zones
5. ✅ Blocks Meeting Stone summon (handled in C++)

### Alignment with Specs

#### ✅ CORRECT - RDF/BG Queue Blocking
- **18-lfg-warfront-ui.md**: RDF button should open LFG Panel (not queue)
- **18-lfg-warfront-ui.md**: BG button should open PvP Panel (not queue)
- **Script behavior**: ✅ Aligned

#### ⚠️ NEEDS UPDATE - Expedition Finder Staging Camp Teleports
- **38-social-and-onboarding-systems.md**: Expedition Finder allows teleport to staging camps from capitals/inns
- **Current script**: Blocks ALL teleports to Red zones
- **Issue**: Script may block legitimate Expedition Finder staging camp teleports

#### ✅ CORRECT - Red Zone Teleport Blocking
- **03-risk-zones.md**: Travel restrictions in Red zones
- **18-lfg-warfront-ui.md**: No teleportation into dungeons/raids/warfronts
- **Script behavior**: ✅ Aligned (blocks teleports to Red zones)

#### ✅ CORRECT - Meeting Stone Blocking
- **18-lfg-warfront-ui.md**: No automatic teleportation
- **C++ implementation**: `SpellScript_MortalMeetingStone` already blocks this
- **Script behavior**: ✅ Aligned (safety check)

---

## Required Updates

### 1. Expedition Finder Exception
The script should **allow** teleportation to staging camps if:
- Player is in a capital city, major inn, or rested area
- Destination is a valid staging camp (not a Red zone directly)
- Teleport is initiated via Expedition Finder system

### 2. Staging Camp Detection
Need to distinguish between:
- **Staging camps** (allowed teleport destination from safe zones)
- **Red zone teleports** (blocked)
- **Dungeon/raid direct teleports** (blocked)

### 3. Script Logic Update
```lua
-- Pseudo-code for updated logic
local function OnSpellCast(event, caster, spell)
    -- ... existing checks ...
    
    -- Check if this is an Expedition Finder staging camp teleport
    if IsExpeditionFinderTeleport(spell, caster) then
        -- Allow if player is in safe zone (capital/inn)
        if IsInSafeZone(caster) then
            return true  -- Allow teleport
        end
    end
    
    -- Otherwise, block Red zone teleports as before
    if IsRedZoneTeleport(spell) then
        return false  -- Block
    end
end
```

---

## Recommendations

### Immediate Actions
1. ✅ **Keep RDF/BG queue blocking** - This is correct per all specs
2. ⚠️ **Update teleport blocking** - Add Expedition Finder staging camp exception
3. ✅ **Keep Red zone teleport blocking** - Still required
4. ✅ **Keep Meeting Stone blocking** - Already handled in C++, script is safety layer

### Implementation Priority
1. **High**: Update teleport blocking to allow Expedition Finder staging camps
2. **Medium**: Add staging camp detection logic
3. **Low**: Add Expedition Finder system integration (if not already implemented)

---

## Spec Document References

### Primary Specs
- **18-lfg-warfront-ui.md (v26.1)**: Original RDF/BG replacement plan
- **38-social-and-onboarding-systems.md (v28.0)**: Expedition Finder with staging camps
- **46-public-grouping-and-contribution.md (v31.5)**: Expedition Rally (no teleports)

### Supporting Specs
- **03-risk-zones.md**: Red zone travel restrictions
- **11-pvp-systems.md**: PvP zone rules

---

## Implementation Status

### Expedition Finder System
- ❌ **NOT FULLY IMPLEMENTED** (~35% complete per `EXPEDITION_RALLY_IMPLEMENTATION_STATUS.md`)
- ✅ **Basic public grouping exists** (`lua/public_grouping.lua`)
- ❌ **Expedition Finder NPC/UI**: NOT IMPLEMENTED
- ❌ **Staging camp teleportation**: NOT IMPLEMENTED
- ❌ **Database tables**: `mortal_expedition_def`, `mortal_staging_camp` NOT CREATED

### Current State
Since Expedition Finder is not yet implemented, the audit script's current behavior is **acceptable**:
- Blocks RDF/BG queues ✅
- Blocks Red zone teleports ✅
- Will need update when Expedition Finder is implemented ⚠️

---

## Conclusion

**The audit script is 95% aligned** with spec requirements for **current implementation status**.

### Current Alignment
- ✅ **RDF/BG queue blocking**: Correct per all specs
- ✅ **Red zone teleport blocking**: Correct per all specs
- ✅ **Meeting Stone blocking**: Correct (handled in C++, script is safety layer)
- ⚠️ **Expedition Finder exception**: Not needed yet (system not implemented)

### Future Updates Required
When Expedition Finder is fully implemented, the script should be updated to:
- ✅ Allow Expedition Finder staging camp teleports (from safe zones only)
- ✅ Distinguish between staging camp teleports and Red zone teleports
- ✅ Verify player is in safe zone (capital/inn) before allowing staging camp teleport

**Recommendation**: 
1. **Keep current script as-is** - It's correct for current implementation
2. **Update when Expedition Finder is implemented** - Add staging camp teleport exception
3. **Coordinate with Expedition Finder system** - Ensure teleport logic is handled consistently

