# Mortal Warcraft Overhaul  
## Event-Specific Broadcasts (SQL + Eluna)

This file **extends** `82-mortal-autobroadcast-pack.sql.md` with:

1. Extra **autobroadcast rows** focused on *recurring events* (generic hype/reminder lines).
2. **Eluna snippets** for **dynamic, timed event messages** (e.g. “Midnight Horde begins in 5 minutes”).

Use both:

- Autobroadcast = slow, atmospheric reminders that these systems exist.
- Eluna event messages = precise “it’s happening now, move your ass” alerts.

---

## Related Specs

- `82-mortal-autobroadcast-pack.sql.md` - Base autobroadcast pack that this extends
- `48-zone-invasions-and-cross-faction-pve.md` - Midnight Horde events
- `08-guilds-sovereignty.md` - Stronghold Sieges & Territory events
- `92-mortal-warfronts-siege-flow.md` - Warfronts & Battleground Events
- `91-mortal-anomalies-rifts-hellgates.md` - Rifts, Anomalies & Hellgates events
- `42-gm-tools-and-live-events.md` - Event system and GM tools
- `37-economy-system-extensions.md` - Black Market & Rotating Events

---

## 1. Additional Autobroadcast Rows (Event-Themed, Generic)

These go into the **`auth.autobroadcast`** table alongside the previous pack.

> You can paste these directly after the prior `INSERT` block or run them separately.

```sql
-- Mortal Warcraft – Event-Themed Autobroadcasts
-- Target DB: auth.autobroadcast

INSERT INTO autobroadcast (realmid, weight, text) VALUES
-- Midnight Horde (generic hype)
(-1, 2, 'The Midnight Horde does not knock. When the bells toll and the dead rise, every Shrine and Stronghold needs steel.'),
(-1, 2, 'If you hear the bells and the word "Risen" in world chat, that means free loot... or a free grave. Join the Midnight Horde events.'),

-- Shrine Defenses
(-1, 2, 'Shrine defense events reward Sanctum Wardens and guardians generously. Saving pilgrims is good business here.'),
(-1, 2, 'If a Shrine is under attack, defending it can earn you healer gear, Runes, and Shrine Favour. Watch for calls in world chat.'),

-- Stronghold Sieges & Territory
(-1, 2, 'Strongholds do not stay safe forever. Siege windows open on timers—guilds that are ready can flip regions and tax flow.'),
(-1, 2, 'When a Stronghold is under siege, even unaffiliated players can profit by scouting, mercing, or looting the aftermath.'),

-- Warfronts & Battleground Events
(-1, 2, 'Warfronts are physical portals, not queues. When banners go up in their zones, it''s time to fight for bulk resource shipments.'),
(-1, 2, 'Controlling a Warfront feeds your guild''s Stronghold with wood, ore, and prestige. Check Atlas to see who owns what.'),

-- Rifts, Anomalies & Hellgates
(-1, 2, 'Ether Rifts and anomalies spawn mini-dungeons and rare Runes. When the sky tears open, treat it like a call to arms.'),
(-1, 2, 'Hellgates are PvP dungeons with one rule: two groups enter, one walks out rich. Bring only what you can afford to lose.'),

-- Black Market & Rotating Events
(-1, 2, 'The Black Market does not sit still. Watch for rumors about its current Red Zone location if you trade in stolen goods.'),
(-1, 2, 'Rotating events like fishing derbies, arena tournaments, and illicit auctions are announced in-world. Keep an eye on chat.'),

-- Atlas & Live Intel
(-1, 2, 'The Mortal Atlas web portal tracks live events: Horde outbreaks, sieges, Warfront shifts, and Rift activity. Use it.'),
(-1, 2, 'Guilds that coordinate through Strongholds, Contracts, and Atlas events will usually decide who owns the map.');
```

You can adjust `weight` up/down if you want these to appear more or less frequently than the general messages.

---

## 2. Dynamic Event Alerts via Eluna

For **time-specific** announcements (e.g., “Horde begins in 5 minutes”), the AutoBroadcast system is too blunt—it just fires on a fixed interval. For real events, you want your **event scripts** to send messages at the right moments.

Below are example skeletons you can drop into your event scripts.

### 2.1 Midnight Horde Event Announcements

File: `lua_scripts/mortal/events/midnight_horde_announcer.lua`

```lua
-- Midnight Horde Announcer

local function Horde_Broadcast(msg)
    -- Center + chat; adjust to your taste
    SendWorldMessage("|cffff4444[Midnight Horde]|r " .. msg)
end

-- Called by your Horde scheduler 15 min before start
function Horde_Preannounce_15()
    Horde_Broadcast("The dead are restless. In 15 minutes, the Midnight Horde will rise across contested zones.")
end

-- 5 minutes before start
function Horde_Preannounce_5()
    Horde_Broadcast("5 minutes until the Midnight Horde. Shrines and outposts are about to be tested.")
end

-- On event start
function Horde_Start_Announcement()
    Horde_Broadcast("The Midnight Horde has risen! Defend Shrines and settlements or join the slaughter.")
end

-- On event end
function Horde_End_Announcement()
    Horde_Broadcast("The dead fall silent. For now, the Midnight Horde has been pushed back.")
end
```

Then, from your **scheduler** (C++ or Lua), call these at appropriate times (using timers, world timers, or a custom event manager).

---

### 2.2 Shrine Defense Alerts

File: `lua_scripts/mortal/events/shrine_defense_announcer.lua`

```lua
local function Shrine_Broadcast(zoneName, shrineName, msg)
    local prefix = string.format("|cff88ccff[Shrine Defense]|r [%s - %s] ", zoneName, shrineName)
    SendWorldMessage(prefix .. msg)
end

function Shrine_Under_Attack(zoneName, shrineName)
    Shrine_Broadcast(zoneName, shrineName, "is under attack! Sanctum Wardens and defenders are needed immediately.")
end

function Shrine_Saved(zoneName, shrineName)
    Shrine_Broadcast(zoneName, shrineName, "has been saved. Healers and defenders earn Shrine Favour and gratitude.")
end

function Shrine_Fallen(zoneName, shrineName)
    Shrine_Broadcast(zoneName, shrineName, "has fallen. Expect undead, chaos, and opportunity in the area.")
end
```

Your shrine AI/event script calls these based on HP thresholds, event phases, etc.

---

### 2.3 Stronghold Siege & Warfront Announcements

File: `lua_scripts/mortal/events/siege_and_warfront_announcer.lua`

```lua
local function Siege_Broadcast(strongholdName, msg)
    local prefix = string.format("|cffff9900[Siege]|r [%s] ", strongholdName)
    SendWorldMessage(prefix .. msg)
end

local function Warfront_Broadcast(warfrontName, msg)
    local prefix = string.format("|cffcc33ff[Warfront]|r [%s] ", warfrontName)
    SendWorldMessage(prefix .. msg)
end

-- Stronghold examples
function Siege_Preannounce(strongholdName, minutes)
    Siege_Broadcast(strongholdName, string.format("will be vulnerable in %d minutes. Prepare your siege or defense.", minutes))
end

function Siege_Start(strongholdName)
    Siege_Broadcast(strongholdName, "is now under siege! Attackers and defenders, your banners have been called.")
end

function Siege_End(strongholdName, winnerGuildName)
    Siege_Broadcast(strongholdName, string.format("siege has ended. Control rests with <%s>.", winnerGuildName or "Unknown"))
end

-- Warfront examples
function Warfront_Preannounce(warfrontName, minutes)
    Warfront_Broadcast(warfrontName, string.format("will open in %d minutes. Rally at its entry portals if you want in.", minutes))
end

function Warfront_Start(warfrontName)
    Warfront_Broadcast(warfrontName, "is now active! Capturing objectives contributes to your guild''s resource shipments.")
end

function Warfront_End(warfrontName, winnerFactionOrGuild)
    Warfront_Broadcast(warfrontName, string.format("has ended. Control goes to %s.", winnerFactionOrGuild or "the victors"))
end
```

Wire these into your C++ or Lua event controllers that know when siege windows open, Warfront match starts/ends, etc.

---

### 2.4 Rifts, Anomalies & Hellgates

File: `lua_scripts/mortal/events/rift_and_hellgate_announcer.lua`

```lua
local function Rift_Broadcast(zoneName, msg)
    local prefix = string.format("|cff66ffff[Rift]|r [%s] ", zoneName)
    SendWorldMessage(prefix .. msg)
end

local function Hellgate_Broadcast(zoneName, msg)
    local prefix = string.format("|cffff6666[Hellgate]|r [%s] ", zoneName)
    SendWorldMessage(prefix .. msg)
end

function Rift_Spawned(zoneName)
    Rift_Broadcast(zoneName, "a new Ether Rift has opened. Explorers and raiders, this is your chance.")
end

function Rift_Closing(zoneName)
    Rift_Broadcast(zoneName, "the Rift is destabilizing and will collapse soon. Last chance for loot and glory.")
end

function Rift_Closed(zoneName)
    Rift_Broadcast(zoneName, "the Rift has collapsed. The local Ether storms will fade over time.")
end

function Hellgate_Opened(zoneName)
    Hellgate_Broadcast(zoneName, "a Hellgate has opened. Two groups may enter; only one will leave with the prize.")
end

function Hellgate_Closed(zoneName)
    Hellgate_Broadcast(zoneName, "the Hellgate has sealed. Risk and reward have moved elsewhere.")
end
```

---

## 3. Suggested Usage Pattern

- **AutoBroadcast (auth.autobroadcast)**  
  - Low-frequency, **atmospheric** reminders:
    - There *are* Midnight Horde events.
    - Shrines matter.
    - Strongholds can be sieged.
    - Rifts, Hellgates, Black Market exist.
  - They keep new/casual players aware of systems even if they log in off-peak.

- **Eluna Event Announcements**  
  - **Timely calls to action**:
    - “In 15 minutes, X happens.”
    - “Now under siege.”
    - “Rift opened in [Zone].”
  - Tied directly to your scheduler and event controllers.

Together, you get:

- The “living world” vibe (random broadcasts that talk about systems), and
- Real-time signals that tell active players when to log alt, move guild, or converge on content.

Drop this file next to the previous one and wire the Lua snippets into your event scripts as you implement Midnight Horde, Shrine defenses, sieges, Warfronts, and Rifts.  
