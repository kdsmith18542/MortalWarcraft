# Mortal Warcraft Overhaul  
## Autobroadcast Message Pack (SQL)

This file contains a **starter pack of AutoBroadcast messages** tuned for Mortal Warcraft’s systems:

- Zone risk (Green / Yellow / Red),
- Shrines & flasks,
- Task Boards (Port Meridian, Greycrag, Shrine, Ranger, Cartel),
- Contracts & caravans,
- Regional banks & markets,
- Strongholds & sovereignty,
- Rifts / anomalies / events,
- Social hubs & Atlas web portal.

> Adjust text, realmid, and timer settings in `worldserver.conf` to fit your server.

---

## Related Specs

- `83-mortal-event-broadcasts.sql-and-eluna.md` - Event-specific broadcasts that extend this pack
- `03-risk-zones.md` - Zone risk (Green / Yellow / Red) messages
- `22-healing-and-restoration.md` - Shrines & flasks messages
- `76-dynamic-tasks-and-contracts-2-0-spec.md` - Task Boards messages
- `13-caravans-contracts.md` - Contracts & caravans messages
- `04-economy.md` - Regional banks & markets messages
- `08-guilds-sovereignty.md` - Strongholds & sovereignty messages
- `91-mortal-anomalies-rifts-hellgates.md` - Rifts / anomalies / events messages
- `24-webportal-mortal-atlas.md` - Atlas web portal messages

---

## 1. Table Reminder

AzerothCore uses the `autobroadcast` table in the **auth** database:

```sql
DESCRIBE autobroadcast;
-- Columns (typical):
--  id (INT, auto-increment)
--  realmid (INT)
--  weight (INT)
--  text (VARCHAR)
```

- `realmid = -1` → all realms.
- `weight` → relative chance of a message being chosen.

---

## 2. Insert Script

You can run this whole block (or parts) in your **auth** database.

```sql
-- Mortal Warcraft – Autobroadcast Pack
-- Target DB: auth.autobroadcast

-- Clean old generic messages (optional, be careful)
-- DELETE FROM autobroadcast;

INSERT INTO autobroadcast (realmid, weight, text) VALUES
-- 1. Welcome / General
(-1, 3, 'Welcome to Mortal Warcraft. Read /rules, respect the shrines, and remember: death has teeth here.'),
(-1, 2, 'New here? Finish the Shipwreck Cove tutorial, then head to Port Meridian to choose your path.'),

-- 2. Zone Risk & PvP Rules
(-1, 3, 'Green Zones are safe. Yellow Zones flag criminals and drop gear on criminal death. Red Zones are full-loot FFA. Travel prepared.'),
(-1, 2, 'Criminals who kill innocents in Yellow Zones risk dropping all their gear. Innocents keep theirs. Choose your targets wisely.'),
(-1, 2, 'Red Zones have no mercy. Death means dropping everything. Always ask yourself: can I afford to lose what I''m wearing?'),

-- 3. Shrines, Flasks & Death
(-1, 3, 'Shrines are your lifeline. Respawn happens at the nearest Shrine with no ghost scouting—protect and remember them.'),
(-1, 2, 'Your healing flasks recharge at Shrines and Inns, not from vendors. Plan your expeditions around safe refuel points.'),
(-1, 2, 'Repairing gear slowly destroys it. Permanent decay is real. Master crafters are the only way to stay battle-ready.'),

-- 4. Task Boards & Contracts – Port Meridian / Green Zones
(-1, 3, 'Check the Task Boards in Port Meridian for easy starting gold, starter gear, and basic Runes.'),
(-1, 2, 'Port Meridian hosts multiple Boards: Militia Tasks, Academy Assignments, Cartel Contracts, and Shrine errands. Find your lane.'),
(-1, 2, 'If you feel lost, grab a Task from a nearby Board. They are designed to teach you systems and fund your first gear upgrades.'),

-- 5. Task Boards & Contracts – Frontier / Greycrag
(-1, 3, 'Greycrag Stronghold is the frontier hub. Frontier Contracts there unlock Linebreaker gear and serious income.'),
(-1, 2, 'Caravan Contracts from Greycrag pay well but run through Yellow and Red roads. Bring friends or hire mercenaries.'),
(-1, 2, 'Frontier Contracts often reward Linebreaker Vanguard gear. Bruisers looking for progression should make Greycrag home.'),

-- 6. Professions, Crafting & Economy
(-1, 3, 'Repair, decay, and full-loot mean crafters matter. Find a blacksmith, alchemist, or leatherworker and become regulars.'),
(-1, 2, 'Regional banks mean Stormwind is not Ironforge. Moving goods between cities is risky, but that''s where profits live.'),
(-1, 2, 'Some of the best gear and Runes are crafted. Look for profession ads in taverns, world chat, and on the Atlas web portal.'),
(-1, 2, 'Material Lore matters. Without it, you waste high-tier ore and herbs. Invest in Lore if you want real crafting power.'),

-- 7. Markets & Trade
(-1, 3, 'The Auction House shows listings from all cities, but items stay in their regional banks. Trade runs are where fortunes are made.'),
(-1, 2, 'Market stalls and Cartel Contracts can turn you into a tycoon without swinging a sword. The economy is a valid endgame.'),
(-1, 2, 'If markets look empty, it''s an opportunity, not a bug. Find a need, fill it, and the coin will follow.'),

-- 8. Rifts, Anomalies & Events
(-1, 3, 'Rifts and Ether anomalies hide rare Runes and materials. If the sky looks wrong, go investigate—with backup.'),
(-1, 2, 'Zone events like Midnight Horde and Shrine defenses can flip control of an area and shower participants with rewards.'),
(-1, 2, 'Anomaly Scanning is a high-risk, high-reward path. The Arcane Eye can reveal dungeons and treasures no one else sees.'),

-- 9. Strongholds, Sovereignty & Guilds
(-1, 3, 'Strongholds generate resources and local banking for their owners. Guilds that hold land shape the map.'),
(-1, 2, 'Guild Wars and Alliances are the backbone of Mortal politics. Talk to your guild about where you want to plant your banner.'),
(-1, 2, 'Attacking a Stronghold broadcasts alerts to its owners. Don''t assume you''re unseen when siege engines start rolling.'),

-- 10. Grouping & Social Play
(-1, 3, 'Mortal is harsher solo. Use /world and taverns to find groups for public dungeons, Contracts, and caravan runs.'),
(-1, 2, 'Healers, scouts, and crafters are just as valuable as frontliners. Build a mixed group and your odds of survival skyrocket.'),
(-1, 2, 'Taverns aren''t just scenery. Use them as meetups, gamble in pits, trade services, or simply hire help for your next run.'),

-- 11. Taskboard Locations & Hints
(-1, 3, 'Not sure where to start? Port Meridian has Task Boards for Militia, Academy, Shrine, Ranger, and Cartel playstyles.'),
(-1, 2, 'Greycrag''s Frontier Board focuses on Contracts into Yellow and Red zones. High risk, high payout, higher body count.'),
(-1, 2, 'Shrine Boards specialize in healing, protection, and support Contracts—perfect for Sanctum Wardens and support mains.'),

-- 12. Safety, New Players & Mentoring
(-1, 3, 'New players should spend time in Green Zones learning Brace, flasks, and basic Contracts before stepping into Yellow.'),
(-1, 2, 'Mentors can respec you freely while your skills are low. Don''t fear experimenting early—that''s the best time.'),
(-1, 2, 'If you''re frustrated, step back to safer content. Task Boards and Green Zones exist so you can recover after losses.'),

-- 13. Atlas Web Portal & External Tools
(-1, 3, 'Use the Mortal Atlas web portal to track territory control, hotspots, markets, and killfeeds outside the game.'),
(-1, 2, 'The Atlas can show you which regions are on fire and which are quiet. Plan your routes using intel, not guesswork.'),
(-1, 2, 'Guilds that coordinate through the Atlas, Strongholds, and Contracts will rule the frontier. Start planning early.'),

-- 14. Rules, Support & Exploits
(-1, 3, 'Report bugs and exploits instead of abusing them. Abusing exploits in a sandbox world ruins the story for everyone.'),
(-1, 2, 'Harassment, real-world threats, and out-of-bounds griefing are not part of the sandbox. Read /rules and respect the lines.'),
(-1, 2, 'Need help? Use the support channels listed in /rules or on the Atlas. Staff titles: [ARCHON], [GM-SENTINEL], [WARDEN].'),

-- 15. Flavor & Atmosphere
(-1, 2, 'In Mortal Warcraft, every sword, coin, and horse has a story. Losing them is part of the world; making new ones is the fun.'),
(-1, 2, 'Not all power comes from levels. Reputation, economy, politics, and information can matter more than your gear.'),
(-1, 2, 'Trust carefully, travel cleverly, and remember: the world is shared, but your choices are yours alone.');
```

---

## 3. Worldserver Config Example

In `worldserver.conf`:

```ini
AutoBroadcast.On = 1
AutoBroadcast.Center = 0         # 0 = chat only, 2 = chat + center
AutoBroadcast.Timer = 600000     # 10 minutes (in ms)
```

You can tighten or loosen the interval depending on how “chatty” you want the server to feel.

---

## 4. Notes

- Yes, including **Task Board references** and **area hints** is a good idea:
  - It gently pushes players toward your custom systems without walls of tutorial text.
  - If you later move a Board, just search/replace the relevant lines.
- You can clone this pack and:
  - Create a separate **event-only** autobroadcast list (Holydays, Midnight Horde announcements),
  - Or add realm-specific flavor using `realmid` instead of `-1`.

Drop this file into your specs folder and hand it to Cursor/the team as `82-mortal-autobroadcast-pack.sql.md` to keep it in sync with the rest of your design docs.  
