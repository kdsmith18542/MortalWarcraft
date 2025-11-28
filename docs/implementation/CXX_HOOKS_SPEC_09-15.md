# C++ Hooks Required for Specs 09-15

**Date:** 2025-01-XX  
**Status:** 📋 **Documentation for C++ Implementation**

---

## Overview

Several features from specs 09-15 require C++ hooks for full functionality. This document details what needs to be implemented in C++.

---

## Spec 09: Social Systems

### Enhanced Emotes
**Required Hooks:**
- `PlayerScript_EnhancedEmotes.cpp`
  - `/sitchair` - Sit in chair gameobject
  - `/sleepground` - Lay down animation
  - `/leanwall` - Lean against wall
  - `/drinkbusy` - Drinking animation with busy state

**Implementation Notes:**
- Hook into chat command system
- Apply appropriate animations/emotes
- Set player state (busy, sitting, etc.)

### Inspect Extensions
**Required Hooks:**
- `PlayerScript_InspectExtensions.cpp`
  - Display titles in inspect window
  - Display badges (Regional trader, Arena champion, etc.)
  - Display PvP season score
  - Display guild influence
  - Display character bio

**Implementation Notes:**
- Extend `SMSG_INSPECT_RESULTS` packet
- Add custom data fields
- Query from `mortal_character_titles`, `mortal_character_bio`, etc.

---

## Spec 11: PvP Systems

### Hitbox Rewrites
**Required Hooks:**
- `CombatRewrites.cpp`
  - Rebalance hitboxes for projectiles
  - Rebalance hitboxes for cone abilities
  - Rebalance hitboxes for cleaves

**Implementation Notes:**
- Modify spell/ability hit detection
- Adjust collision detection
- May require DBC modifications

### Stagger System
**Required Hooks:**
- `CombatRewrites.cpp`
  - Apply 0.5s movement slow on certain hits
  - Remove mini stun (MO2 lesson learned)

**Implementation Notes:**
- Hook into damage calculation
- Apply movement speed debuff
- Ensure no stun effects

### Fog of War (Red Zones)
**Required Hooks:**
- `FogOfWar.cpp`
  - Hide party dots on minimap in Red zones
  - Hide raid icons unless manually set
  - Reduce visibility

**Implementation Notes:**
- Modify minimap data packets
- Filter party/raid member visibility
- Adjust draw distance in Red zones

---

## Spec 12: World Simulation

### Weather System Stat Modifications
**Required Hooks:**
- `WeatherHooks.cpp`
  - Apply movement speed modifiers
  - Apply visibility modifiers
  - Apply damage modifiers (fire, lightning, etc.)

**Implementation Notes:**
- Hook into movement speed calculation
  - Hook into visibility/draw distance
  - Hook into damage calculation

### Day/Night Cycle Spawn Modifications
**Required Hooks:**
- `DayNightHooks.cpp`
  - Modify spawn weights based on time
  - Apply creature damage modifiers (wolves +10% at night)
  - Spawn special creatures (fireflies, spectral variants)

**Implementation Notes:**
- Hook into spawn system
- Modify creature stats dynamically
- Trigger special spawns

### Alpha Variant Visual Effects
**Required Hooks:**
- `CreatureVisuals.cpp`
  - Apply visual effects to alpha variants (red glow, larger size)
  - Apply visual effects to mythic variants (golden glow, particles)

**Implementation Notes:**
- Modify creature model scale
- Apply particle effects
- Apply aura visuals

---

## Spec 13: Caravans & Contracts

### Caravan Movement Physics
**Required Hooks:**
- `CaravanHooks.cpp`
  - Damped physics (slow acceleration, slow turning, heavy braking)
  - Terrain slope detection
  - Building collision detection
  - Apply movement speed modifiers

**Implementation Notes:**
- Hook into player movement when caravan active
- Modify movement speed, turn rate, acceleration
- Check terrain and building collisions

### Ambush Spawn Logic
**Required Hooks:**
- `AmbushLogic.cpp`
  - Spawn bandit AI mobs
  - Trigger ambush based on caravan position
  - Apply ambush AI behavior

**Implementation Notes:**
- Hook into creature spawn system
- Custom AI for ambush bandits
- Trigger based on caravan proximity

---

## Spec 14: Admin Tools

### AIO Integration
**Required Hooks:**
- `AIOHooks.cpp`
  - Send data to client via AIO
  - Receive commands from client
  - Render server-side UI

**Implementation Notes:**
- Integrate with AzerothCore IO system
- Custom packet handling
- UI rendering on client

---

## Spec 15: UI/Client

### All Client-Side Addons
**Required Work:**
- Mortal_Stats Addon (Lua client-side)
- Mortal_Tooltips Addon (Lua client-side)
- Crime Status Display (Lua client-side)
- Encumbrance Display (Lua client-side)
- Risk Zone Banner (Lua client-side)
- All wrapped addons configuration

**Implementation Notes:**
- Requires WoW 3.3.5a addon development
- Lua client-side scripting
- UI frame creation
- Event handling

### DBC Modifications
**Required Work:**
- TalentTab.dbc - Universal Mastery Trees
- Item.dbc - Remove level reqs, add skill reqs
- Spell.dbc - Brace mechanic, Hunger debuffs, etc.

**Implementation Notes:**
- Requires DBC editing tools
- Client-side patches
- Launcher integration for patching

---

## Priority Implementation Order

### High Priority (Core Gameplay):
1. Fog of War (Spec 11)
2. Caravan Movement Physics (Spec 13)
3. Weather System Modifiers (Spec 12)
4. Day/Night Cycle Spawns (Spec 12)

### Medium Priority (Quality of Life):
5. Inspect Extensions (Spec 09)
6. Enhanced Emotes (Spec 09)
7. Alpha Variant Visuals (Spec 12)
8. Ambush Spawn Logic (Spec 13)

### Low Priority (Polish):
9. Hitbox Rewrites (Spec 11)
10. Stagger System (Spec 11)
11. AIO Integration (Spec 14)
12. Client-Side Addons (Spec 15)
13. DBC Modifications (Spec 15)

---

## Implementation Notes

- All C++ hooks should integrate with existing `MortalOverhaul` module
- Use `ScriptMgr` for event registration
- Follow AzerothCore coding standards
- Test thoroughly before deployment
- Document all hooks in code comments

---

**Status:** 📋 **Documentation complete - Ready for C++ implementation**

