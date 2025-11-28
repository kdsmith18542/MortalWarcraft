# Inspect Extensions Integration Guide

## Overview
The Inspect Extensions feature from spec 09 Social Systems has been implemented as a C++ module that extends the character inspection functionality to show additional player information including titles, badges, PvP season scores, and guild influence.

## Implementation Files
- `azerothcore/modules/mortal_overhaul/src/InspectExtensions.cpp`
- `azerothcore/modules/mortal_overhaul/src/InspectExtensions.h`

## Core Integration Required

To activate the Inspect Extensions, the core AzerothCore `MiscHandler.cpp` file must be modified to call the extension function.

### Required Modification

In `azerothcore/src/server/game/Handlers/MiscHandler.cpp`, locate the `HandleInspectOpcode` function and add the following call after the existing inspect processing:

```cpp
// After this line in HandleInspectOpcode:
player->BuildEnchantmentsInfoData(&data);
SendPacket(&data);

// Add this line:
extern void SendMortalInspectExtensions(Player* inspector, Player* target);
SendMortalInspectExtensions(_player, player);
```

### Full Context
The modification should be made around line 1016 in MiscHandler.cpp, right after:
```cpp
player->BuildEnchantmentsInfoData(&data);
SendPacket(&data);
```

Add:
```cpp
// Send extended Mortal Warcraft inspect information
extern void SendMortalInspectExtensions(Player* inspector, Player* target);
SendMortalInspectExtensions(_player, player);
```

## Features Implemented

### Titles Display
- Shows the player's active title
- Lists all earned titles available for display

### Badges System
- PvP Veteran badge (100+ kills)
- Bounty Hunter badge (10+ bounty claims)
- Max Level badge (level 80+)

### PvP Season Score
- Displays current season rating from MortalPvPSeason system

### Guild Influence
- Basic guild influence calculation (placeholder for future expansion)

## Packet Structure

The system sends a custom packet `SMSG_INSPECT_EXTENDED_INFO` with the following data:
- Player GUID
- Active title ID
- PvP season score
- Guild influence value
- List of earned title IDs
- List of badge IDs

## Client-Side Requirements

The client-side UI will need to be modified to display this additional information in the inspect window. This would typically involve:
1. Extending the inspect frame to show additional panels
2. Adding title/badge display components
3. Formatting the PvP season score and guild influence displays

## Future Enhancements

- Expand guild influence calculation to include actual guild metrics
- Add more badge types based on achievements and activities
- Implement client-side UI components for displaying the extended information
- Add configuration options for which information to display