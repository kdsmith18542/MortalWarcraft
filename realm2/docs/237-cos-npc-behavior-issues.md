# Culling of Stratholme NPC Behavior Issues

**Date:** 2025-01-23  
**Status:** Investigation Started

---

## Issues Summary

Three related issues about NPCs not performing expected RP behavior:

1. **#15621** - Brandon Eiredeck's crowd of Agitated Stratholme Citizens are not very agitated
2. **#15620** - Patricia O'Reilly's crowd of Agitated Stratholme Citizens are not very agitated
3. **#15623** - Stephanie Sindree is not being harassed

---

## Issue Details

### #15621 - Brandon Eiredeck
**Problem:** Crowd of Agitated Stratholme Citizens in front of Brandon Eiredeck are standing still, saying nothing.

**Expected:** 
- Citizens should be chastising Eiredeck for bringing the plagued grain to Stratholme
- Eiredeck should be cowering and saying he is only a delivery man

### #15620 - Patricia O'Reilly
**Problem:** Crowd of Agitated Stratholme Citizens in front of Patricia O'Reilly are standing still, saying nothing.

**Expected:**
- Citizens should be demanding to see Magistrate Barthilas
- O'Reilly should be half-heartedly trying to keep them from him
- O'Reilly should tell the player not to bother Barthilas when they enter the building

### #15623 - Stephanie Sindree
**Problem:** Stephanie Sindree is eyeing down an Agitated Stratholme Citizen, but nothing happens.

**Expected:**
- Citizen should be claiming her food poisoned him and his family
- Sindree should be denying the claims

---

## Next Steps

1. **Find NPC IDs** for:
   - Brandon Eiredeck
   - Patricia O'Reilly
   - Stephanie Sindree
   - Agitated Stratholme Citizen (may be NPC_CITY_MAN variants)

2. **Create SmartAI scripts** for:
   - Periodic dialogue between NPCs
   - Emotes (cowering, pointing, etc.)
   - Text entries in creature_text table

3. **Implement gossip** for Patricia O'Reilly to warn players about Barthilas

---

**Last Updated:** 2025-01-23

