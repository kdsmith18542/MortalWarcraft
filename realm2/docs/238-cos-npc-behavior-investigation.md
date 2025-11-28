# Culling of Stratholme NPC Behavior Issues - Investigation

**Date:** 2025-01-23  
**Status:** Investigation - Need NPC IDs

---

## Issues

1. **#15621** - Brandon Eiredeck's crowd not agitated
2. **#15620** - Patricia O'Reilly's crowd not agitated  
3. **#15623** - Stephanie Sindree not being harassed

---

## Expected Behavior

### #15621 - Brandon Eiredeck
- **Citizens:** Chastising Eiredeck for bringing plagued grain
- **Eiredeck:** Cowering, saying he is only a delivery man

### #15620 - Patricia O'Reilly
- **Citizens:** Demanding to see Magistrate Barthilas
- **O'Reilly:** Half-heartedly trying to keep them away
- **O'Reilly:** Tells player not to bother Barthilas when entering building

### #15623 - Stephanie Sindree
- **Citizen:** Claiming her food poisoned him and his family
- **Sindree:** Denying the claims

---

## Investigation Needed

1. **Find NPC Entry IDs:**
   - Brandon Eiredeck
   - Patricia O'Reilly
   - Stephanie Sindree
   - Agitated Stratholme Citizen (may be NPC_CITY_MAN variants: 28167, 28169, 31126, 31127)

2. **Find Spawn Locations:**
   - Where these NPCs spawn in the instance
   - Which citizens are near each NPC

3. **Create SmartAI Scripts:**
   - Periodic dialogue between NPCs and citizens
   - Emotes (cowering, pointing, etc.)
   - Text entries in creature_text table

4. **Gossip for Patricia O'Reilly:**
   - Add gossip option to warn players about Barthilas

---

## Next Steps

1. Search database for NPC names/IDs
2. Check Wowhead for NPC IDs
3. Create SmartAI scripts once IDs are found
4. Add creature_text entries for dialogue
5. Test in-game

---

**Last Updated:** 2025-01-23

