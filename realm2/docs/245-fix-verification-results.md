# Fix Verification Results

**Date:** 2025-01-23  
**Tool:** `tools/verify_fixes.py`

---

## Summary

Verified all Culling of Stratholme fixes against reference scripts (TrinityCore and CMaNGOS).

**Overall Results:**
- ✅ **41 NPC IDs** matched between our code and reference scripts
- ✅ **7/7 Crate RP Event NPCs** verified
- ✅ **5/6 NPC Behavior Fix NPCs** verified
- ⚠️ **1 NPC** (Brandon Eiredeck) not in reference scripts but present in our code

---

## Crate RP Events (#15629)

**Status:** ✅ **All Verified**

| NPC ID | Name | TrinityCore | CMaNGOS | Our Code | Our SQL |
|--------|------|-------------|---------|----------|---------|
| 27903 | Roger Owens | ✅ | ✅ | ✅ | ✅ |
| 27877 | Sergeant Morigan | ✅ | ✅ | ✅ | ✅ |
| 27885 | Jena Anderson | ✅ | ✅ | ✅ | ✅ |
| 27891 | Malcolm Moore | ✅ | ✅ | ✅ | ✅ |
| 27892 | Scruffy | ✅ | - | ✅ | ✅ |
| 27907 | Bartleby Battson | ✅ | ✅ | ✅ | ✅ |
| 27913 | Lordaeron Crier | ✅ | ✅ | ✅ | ✅ |

**Conclusion:** All NPC IDs are correct and match reference implementations.

---

## NPC Behavior Fixes (#15621, #15620, #15623)

**Status:** ✅ **5/6 Verified, 1 Not in References**

| NPC ID | Name | TrinityCore | CMaNGOS | Our Code | Our SQL | Status |
|--------|------|-------------|---------|----------|---------|--------|
| 31023 | Brandon Eiredeck | ❌ | ❌ | ✅ | ✅ | ⚠️ Not in references |
| 31028 | Patricia O'Reilly | - | ✅ | ✅ | ✅ | ✅ Verified |
| 31019 | Stephanie Sindree | - | ✅ | ✅ | ✅ | ✅ Verified |
| 30994 | Magistrate Barthilas | - | ✅ | ✅ | - | ✅ Verified |
| 31126 | Agitated Stratholme Citizen | - | ✅ | ✅ | ✅ | ✅ Verified |
| 31127 | Agitated Stratholme Resident | - | ✅ | ✅ | ✅ | ✅ Verified |

**Note on Brandon Eiredeck (31023):**
- Not found in TrinityCore or CMaNGOS reference scripts
- Present in our code and SQL files
- May be:
  - A newer NPC not in the reference scripts we have
  - Defined elsewhere (database spawns, not script definitions)
  - Correct but simply not scripted in reference implementations
- **Action:** Verify NPC ID 31023 exists in database and matches expected behavior

---

## Additional Findings

### NPC Name Variations

Reference scripts use slightly different naming conventions:

| Our Name | TrinityCore Name | CMaNGOS Name |
|----------|------------------|--------------|
| NPC_SALRAMM | NPC_SALRAMM | NPC_SALRAMM_THE_FLESHCRAFTER |
| NPC_EPOCH | - | NPC_LORD_EPOCH |
| NPC_MAL_GANIS | - | NPC_MALGANIS |
| NPC_KNIGHT_ESCORT | - | NPC_LORDAERON_FOOTMAN |
| NPC_PRIEST_ESCORT | - | NPC_HIGH_ELF_MAGE_PRIEST |
| NPC_CITY_MAN | - | NPC_STRATHOLME_CITIZEN |
| NPC_CITY_MAN2 | - | NPC_STRATHOLME_RESIDENT |
| NPC_AGITATED_STRATHOLME_CITIZEN | - | NPC_AGIATED_STRATHOLME_CITIZEN |

**Note:** These are just naming differences - the NPC IDs match correctly.

---

## Recommendations

1. ✅ **Crate RP Events** - All verified, no changes needed
2. ✅ **NPC Behavior Fixes** - 5/6 verified, Brandon Eiredeck needs database verification
3. 📋 **Consider adding** - Any NPCs found in reference scripts but not in our code (if needed for completeness)

---

## Usage

```bash
# Verify specific fix
python3 tools/verify_fixes.py --fix 15629

# Verify all Culling of Stratholme fixes
python3 tools/verify_fixes.py --all

# List all verifiable fixes
python3 tools/verify_fixes.py --list
```

---

**Last Updated:** 2025-01-23

