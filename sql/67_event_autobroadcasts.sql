-- ==================================================
-- Mortal Warcraft – Event-Themed Autobroadcasts
-- Spec 83: Event Broadcasts (SQL + Eluna)
-- Target DB: auth.autobroadcast
-- ==================================================

-- Event-themed autobroadcast messages
-- These complement the general autobroadcast pack (68_autobroadcast_pack.sql)

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

