# Culling of Stratholme NPC Behavior Fixes - Complete

**Date:** 2025-01-23  
**Status:** ✅ Complete - Ready for Testing

---

## Summary

Fixed three related issues (#15621, #15620, #15623) where NPCs in Culling of Stratholme were standing still without dialogue or emotes.

---

## NPC IDs Found

1. **Brandon Eiredeck** - 31023
2. **Patricia O'Reilly** - 31028
3. **Stephanie Sindree** - 31019
4. **Magistrate Barthilas** - 30994
5. **Agitated Stratholme Citizen** - 31126
6. **Agitated Stratholme Resident** - 31127

**Source:** ScriptDevAI backup file + Wowhead search

---

## Implementation

### 1. NPC IDs Added to Header
- Added all 6 NPC IDs to `culling_of_stratholme.h` enum Creatures

### 2. SmartAI Scripts Created
- **Brandon Eiredeck (31023):**
  - Periodic cower emote (every 20-40s)
  - Periodic dialogue: "Please, I'm just a delivery man!"

- **Agitated Citizens near Brandon (31126, 31127):**
  - Random emotes (Talk/Exclamation/Question) every 15-30s
  - Periodic dialogue chastising Eiredeck every 20-35s

- **Patricia O'Reilly (31028):**
  - Periodic dialogue: "Please, stay back! Magistrate Barthilas is busy!"
  - Wave emote every 30-45s
  - Gossip menu to warn players about Barthilas

- **Agitated Citizens near Patricia (31126, 31127):**
  - Periodic dialogue demanding to see Barthilas every 30-50s

- **Stephanie Sindree (31019):**
  - Periodic dialogue: "That's not true! My food is perfectly safe!"
  - Exclamation emote every 25-45s

- **Agitated Citizen near Stephanie (31126, 31127):**
  - Periodic dialogue: "Your food poisoned me and my family!" every 25-45s

### 3. Creature Text Entries
Added dialogue for:
- Brandon Eiredeck (1 line)
- Agitated Citizens/Residents (3 groups: Eiredeck, Barthilas, Sindree)
- Patricia O'Reilly (2 lines)
- Stephanie Sindree (1 line)

### 4. Gossip Implementation
- Added gossip menu (10000) for Patricia O'Reilly
- Gossip text warns players not to bother Magistrate Barthilas
- Linked gossip menu to creature_template

---

## Files Modified

1. **`culling_of_stratholme.h`**
   - Added 6 NPC IDs to `enum Creatures`

2. **`2025_01_23_09_fix_cos_npc_behavior.sql`**
   - SmartAI scripts for all NPCs
   - Creature_text entries for all dialogue
   - Gossip menu and text for Patricia O'Reilly

---

## Testing Checklist

- [ ] Verify Brandon Eiredeck cowers and responds to citizens
- [ ] Verify Agitated Citizens near Brandon chastise him
- [ ] Verify Patricia O'Reilly tries to keep citizens away
- [ ] Verify Agitated Citizens near Patricia demand to see Barthilas
- [ ] Verify Patricia O'Reilly gossip warns about Barthilas
- [ ] Verify Stephanie Sindree denies food poisoning claims
- [ ] Verify Agitated Citizen near Stephanie claims food poisoning
- [ ] Verify timing feels natural (not too frequent/rare)
- [ ] Verify emotes play correctly
- [ ] Verify text displays correctly

---

## Notes

- SmartAI scripts use randomized timers (15-50s) to make dialogue feel natural
- Agitated Citizens use different GroupID text entries (0, 1, 2) based on which NPC they're near
- Gossip menu for Patricia O'Reilly uses menu ID 10000 (may need adjustment if conflicts exist)

---

**Last Updated:** 2025-01-23

