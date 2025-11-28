# MortalUI Addon Integration Testing Script

## Overview

This script provides comprehensive testing capabilities for the MortalUI addon integration on AzerothCore servers. It simulates data feeds and tests all addon functionality by sending addon messages to players.

## Location

The test script is located at: `azerothcore/bin/lua_scripts/mortal_addon_integration_test.lua`

## Features Tested

### Data Feeds
- **Weight & Hunger Updates**: Tests existing WEIGHT, MAX_WEIGHT, and HUNGER data feeds
- **Bounty Updates**: Simulates active bounties with targets, rewards, and time remaining
- **Stronghold Updates**: Tests stronghold vulnerability, defense levels, and attacking forces
- **Rift Updates**: Simulates dimensional rifts with stability, location, and remaining time

### Addon Functionality
- **Map Pins**: Tests custom map overlays for territory control, world bosses, caravans, etc.
- **Zone Types**: Tests risk zone banners (green/yellow/red zones)
- **Crime Status**: Tests notoriety levels and wanted status
- **Tooltip Injection**: Tests enhanced item tooltips
- **Nameplates**: Tests custom nameplate displays
- **Stats Overlay**: Tests character statistics display
- **Encumbrance Display**: Tests weight/bag management UI

## Usage

### Loading the Script

The script loads automatically when placed in the `lua_scripts/` directory and the server is restarted, or can be loaded manually via:

```bash
.lua dofile("lua_scripts/mortal_addon_integration_test.lua")
```

### Running Tests

#### Run All Tests on All Online Players
```lua
TestAllAddons()
```

#### Run Specific Tests on Individual Players
```lua
TestWeightAndHunger("PlayerName")
TestBountyUpdate("PlayerName")
TestStrongholdUpdate("PlayerName")
TestRiftUpdate("PlayerName")
```

### Configuration

Edit the `TEST_CONFIG` table in the script to customize:

```lua
local TEST_CONFIG = {
    ENABLE_LOGGING = true,           -- Enable/disable console logging
    TEST_PLAYER_NAME = nil,          -- Set to specific player name, or nil for all online
    DELAY_BETWEEN_TESTS = 1000,      -- Delay between tests in milliseconds
}
```

## Test Data Formats

### MORTAL_DATA Messages
- `WEIGHT:value` - Current weight in lbs
- `MAX_WEIGHT:value` - Maximum weight capacity
- `HUNGER:value` - Hunger percentage (0-100)
- `BOUNTY:id:target:reward:timeLeft:zone` - Bounty information
- `STRONGHOLD:id:name:vulnerability:defense:attackers` - Stronghold status
- `RIFT:id:zone:x:y:stability:timeLeft:creatures` - Rift information

### MORTAL_PACKET Messages
- `MAP_PINS:data` - Pipe-separated list of pin data (type:mapId:x:y:data)
- `ZONE_TYPE:type:rules:consequences` - Zone risk level and rules
- `CRIME_STATUS:notoriety:wantedStatus:bounty:crimes` - Player crime status
- `TOOLTIP:itemId:enhancement:description` - Enhanced tooltip data
- `NAMEPLATE:unitId:status:threatLevel` - Nameplate enhancements
- `STATS:health:experience:mana:stamina` - Character stats
- `ENCUMBRANCE:current:max:status` - Weight/encumbrance status

## Expected Results

When tests run successfully, players should see:

1. **UI Updates**: MortalUI elements updating with test data
2. **Visual Feedback**: Risk zone banners, map pins, stat displays
3. **Chat Messages**: Test completion confirmation
4. **Console Logs**: Server-side test execution logs

## Troubleshooting

### No UI Updates
- Ensure MortalUI addon is installed and enabled
- Check that addon message prefixes are registered
- Verify player is online and in-game

### Script Not Loading
- Confirm script is in `azerothcore/bin/lua_scripts/`
- Check server logs for Lua errors
- Ensure Eluna is enabled in worldserver.conf

### Test Player Not Found
- Verify player name spelling and capitalization
- Ensure player is online
- Check database connection for player queries

## Integration with Real Systems

This test script simulates data that should eventually come from:

- **Server Systems**: Weight/hunger calculations, zone monitoring
- **Database Queries**: Bounty tables, stronghold status, rift spawns
- **Event Handlers**: Real-time updates from game events
- **Player Actions**: Inventory changes, zone transitions, combat events

## Future Enhancements

- Automated verification of addon responses
- Performance testing with multiple players
- Integration with actual server data sources
- Web-based test result reporting
- Scheduled automated testing