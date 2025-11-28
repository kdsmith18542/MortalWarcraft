# SQL Migration Notes - Spec Updates (24-31)

## Summary

This document tracks SQL changes needed to align with the new spec documents (24-31).

## Changes Made

### 1. New Migration File Created

**`65_mortal_core_registry_tables.sql`**
- Creates the new tables from spec 30:
  - `mortal_gear_visuals` - Maps Mortal gear to WotLK visual sources
  - `mortal_mount_visuals` - Defines Living Mount tiers and properties
  - `mortal_companions` - Tracks Bond & Hunger for pets/mercs/mounts
  - `mortal_merc_templates` - Defines available mercenary archetypes
  - `mortal_merc_contracts` - Tracks active mercenary contracts

**Run this file first** before updating mercenary broker scripts.

### 2. Updated Files

**`29_mercenary_broker.sql`**
- **Changed mercenary creature entries** from `91001-91003` to `600001-600003`
  - Per spec 31: Mercenaries should use range 600000-609999
  - Broker NPC (91000) remains unchanged (it's not a mercenary)
- **Added inserts** into `mortal_merc_templates` table
- **Added notes** about ID range changes

**Important:** If you have existing Lua scripts or other code referencing creature entries `91001-91003`, you must update them to use `600001-600003`.

## ID Range Reference (from spec 31)

- **Items:**
  - 700000-709999: PvE gear (M-T1 to M-T5)
  - 710000-719999: PvP gear (P1 to P6)
  - 720000-729999: Mount Reins (M-M1 to M-M4)
  - 730000-734999: Companion Feed & Upkeep Items
  - 735000-739999: Contracts, Tokens & Licenses

- **Creatures:**
  - 600000-609999: Mercenaries & Hirelings
  - 610000-619999: Stronghold / Siege NPCs
  - 620000-629999: Event Mobs / Special Systems

- **Spells:**
  - 900000-909999: Combat / systemic spells
  - 910000-914999: Companion & Merc utility spells

- **Skills:**
  - 8000-8099: Armor Mastery Skills (8000=Plate, 8001=Mail, 8002=Leather, 8003=Cloth)
  - 8100-8199: Weapon / Combat Mastery
  - 8200-8299: Riding Masteries
  - 8300-8399: Material Lore Skills

## Migration Order

1. Run `65_mortal_core_registry_tables.sql` to create new tables
2. Run `29_mercenary_broker.sql` (updated) to create mercenary templates
3. Update any Lua scripts that reference old creature entries (91001-91003 → 600001-600003)

## Notes

- Item IDs 90001-90004 used in tutorial system and other files are **not** armor mastery skills - they're fine as-is
- The broker NPC (91000) remains unchanged - it's not a mercenary creature
- All new tables follow the naming convention from spec 30

