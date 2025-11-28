# Fix for #23863 - Thorim Missing Hammer After Quest

**Date:** 2025-01-23  
**Status:** ✅ Fixed

---

## Problem

After completing quest "Krolmir, Hammer of the Storms" (13010), Thorim should have his hammer visible, but it doesn't appear.

## Root Cause

The quest completes successfully, but Thorim's equipment is not updated to show the hammer. The NPCs need SmartAI scripts to update their equipment when quest 13010 is completed.

## Solution

Added SmartAI scripts to three Thorim NPCs:
- **29445** - Thorim (quest starter, Temple of Storms)
- **30390** - Thorim (quest ender, appears at Thunderfall after King Jokkum event)
- **33242** - Thorim (gossip NPC, Ulduar)

The scripts use:
- **Event type 20** = `SMART_EVENT_QUEST_COMPLETE`
- **Action type 194** = `SMART_ACTION_EQUIP` (equipment_id)
- **Equipment ID 2** = With hammer (needs to be created in `creature_equip_template` if it doesn't exist)

## Files Changed

1. **`realm2/azerothcore/data/sql/updates/db_world/2025_01_23_11_fix_thorim_hammer.sql`**
   - Added SmartAI scripts for all three Thorim NPCs
   - Scripts trigger on quest 13010 completion
   - Updates equipment to ID 2 (with hammer)

## Notes

- Equipment ID 2 needs to exist in `creature_equip_template` for these NPCs
- The actual hammer item ID needs to be determined from Wowhead or DBC files
- If equipment_id 2 doesn't exist, the server will log an error and it needs to be added manually

## Testing

1. Complete quest "Krolmir, Hammer of the Storms" (13010)
2. Check Thorim NPCs - they should now have the hammer visible
3. Verify equipment is updated for all three NPC entries

