# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative & Systems  
### File: 72-act4-strongholds-and-invasions-campaign.md  
### Section: Act IV — “Breach of the Frontier” (Strongholds & Zone Invasions)

---

## Related Specs

- `08-guilds-sovereignty.md` - Stronghold system and sovereignty mechanics central to Act IV
- `48-zone-invasions-and-cross-faction-pve.md` - Zone invasions and Midnight Horde framework
- `92-mortal-warfronts-siege-flow.md` - Warfront system and siege mechanics
- `24-webportal-mortal-atlas.md` - War Map and territory visualization
- `15-ui-client.md` - In-game UI for Stronghold and Invasion management
- `76-dynamic-tasks-and-contracts-2-0-spec.md` - Contracts and Task Boards referenced in Act IV
- `51-factions-and-standing-system.md` - Faction system and standing mechanics
- `97-mortal-guild-war-and-alliances.md` - Guild relationships and war mechanics
- `98-mortal-siege-prep-contracts.md` - Siege preparation contracts and tasks

---

## 1. Scope

Act IV moves the game from **personal agency** to **territorial agency**:

- Players and guilds **claim, defend, and lose Strongholds**.
- Zones can **fall** into enemy control during invasions.
- Factions (Ledger, Shrine, Cartel, Rangers) compete for:
  - Supply lines,
  - Control points,
  - Strategic terrain.

This act:

- Wraps **Stronghold Sovereignty**, **Zone-wide Invasions**, and **Warfront hooks** into a coherent campaign arc.
- Uses a mix of:
  - Solo-friendly quests (setup, scouting),
  - Small-group content,
  - Optional large-scale events (Warfronts / zone capture).

Quest IDs: **10200–10259** reserved for Act IV.

---

## 2. Systems This Act Assumes Are In Place

Before implementing Act IV, the following should be at least baseline functional (even if not feature-complete):

- **Stronghold System**  
  - Claimable nodes (towers, ruins, mines, forts) with:
    - Ownership flags (by guild),
    - Vulnerability windows,
    - Resource generation.  

- **Territory Control System**  
  - Zone-level state:
    - Controlled by: None / Players / NPC Faction (Horde, Undead, etc.),
    - Effects on:
      - Guard strength,
      - Contract availability,
      - Market conditions.

- **Zone Invasion / Midnight Horde Framework**  
  - Ability to:
    - Spawn waves of invaders in a zone,
    - Flip control after certain objectives are met/fail.

- **Warfronts & Battleground Hooks**  
  - Physical entry portals to instanced Warfronts, with:
    - Control effects on world (e.g., supply buffs, shipments).

- **Atlas/MortalMap Integration**  
  - Map overlays that show:
    - Stronghold ownership,
    - Invasion status,
    - Zone control color.

Act IV’s quests **drive and explain** these systems rather than creating them from scratch.

---

## 3. Narrative Situation

- The **Frontier** is destabilizing.  
- More **Rifts, Hordes, and bandit factions** are pushing into Yellow zones.  
- Factions push the player:
  - Iron Ledger: secure supply lines & resource nodes.  
  - Shrine: prevent Ether corruption and Midnight Hordes.  
  - Cartel: profit off chaos, seize black market positions.  
  - Rangers: keep the Line from collapsing.

Act IV’s title — **“Breach of the Frontier”** — refers both to:

- Enemies pushing **out** of Red zones, and  
- Players pushing **in** to claim footholds.

---

## 4. High-Level Quest Flow

Core spine (mandatory mainline):

1. **Q10200** — “Lines on a Burning Map” (briefing)  
2. **Q10201** — “Survey the Breaches” (scouting)  
3. **Q10202** — “Flags in the Dust” (first Stronghold capture)  
4. **Q10203** — “The Siege Clock” (vulnerability & defense tutorial)  
5. **Q10204** — “When a Zone Falls” (scripted zone invasion outcome)  
6. **Q10205** — “Retake the Roads” (counter-attack)  
7. **Q10206** — “Warfront By Another Name” (hook into Warfront instance)  
8. **Q10207** — “Our First Banner” (Act IV resolution)

Around this spine, you can attach:

- Repeatable Stronghold contracts,
- Invasion events,
- Warfront weekly missions.

---

## 5. Detailed Quest Designs

### 5.1 Q10200 — “Lines on a Burning Map”

- **QuestID:** 10200  
- **Type:** MAIN (Act IV opener)  
- **Giver:** Either:
  - `Council Fire` NPC hub (return there), or  
  - New NPC `Cartographer Lyenn` in Port Meridian/Atlas hall.  
- **Prereqs:**  
  - Act III resolution quest Q10160 “Bargains on the Ledger”,  
  - Minimum progression threshold (skill / dynamic level).

**Summary:**  
You’re summoned to a situation room where an **enchanted war map** shows zones flickering between control states. The Four Powers explain: the Frontier is actively being pushed back, and someone must push back **from the player side**.

**Objectives:**

- Interact with **War Map Table** (GameObject).  
- View the map overlay showing:
  - Current Stronghold nodes,
  - Hot zones,
  - Invasion threat levels.  
- Talk to each of:
  - Ledger, Shrine, Cartel, Ranger reps about what they want to do.

**Rewards:**

- Unlock **Stronghold & Invasion tabs** in Atlas/MortalUI.  
- Quest Q10201 “Survey the Breaches” becomes available.

**Implementation Notes:**

- War Map:
  - Uses custom UI panel (Atlas or AIO-based),
  - Pulls data from `territory_control` and `stronghold_state` tables.

---

### 5.2 Q10201 — “Survey the Breaches”

- **QuestID:** 10201  
- **Type:** MAIN (Scouting)  
- **Giver:** Any Council rep or Cartographer Lyenn.  
- **Prereqs:** Q10200.

**Summary:**  
You’re tasked with visiting **three “Breach Zones”** along the Line to collect real data:

- A **collapsed watchtower**,  
- A **burned farmstead**,  
- A **choked pass**.

**Objectives:**

- Travel to each marked location in a Yellow border region.  
- Use **Surveyor’s Lens** item to:
  - Scan invader presence (mob count, type),
  - Tag nearby Strongholdizable locations.  
- Survive minor ambushes.

**Rewards:**

- Gold + materials,  
- Minor rep with Rangers & Shrine,  
- Unlocks:
  - “Candidate Strongholds” visible on map.

**Implementation Notes:**

- Each surveyed point:
  - Calls Lua script to:
    - Set `stronghold_candidate=1` in territory DB,
    - Reveal those nodes for later capture quests.

---

### 5.3 Q10202 — “Flags in the Dust” (First Stronghold Capture)

- **QuestID:** 10202  
- **Type:** MAIN (Stronghold Capture Tutorial)  
- **Giver:** Ranger Captain Thera or Ledger Factor Maelis, depending on your highest faction rep.  
- **Prereqs:** Q10201.

**Summary:**  
You are ordered (or strongly encouraged) to **capture your first Stronghold** — a damaged watchtower on the edge of a Yellow zone.

**Objectives:**

- Travel to **“Broken Spire Watchtower”** Stronghold candidate.  
- Clear **X waves of defenders**:
  - Could be bandits, minor Horde, rival Cartel proxies.  
- Place your **Guild Banner** or **Freelancer Standard** at the Stronghold’s capture point.  
- Defend against **one counter-attack wave**.

**Rewards:**

- If in a Guild:
  - Guild gains ownership of the Stronghold.  
- If solo/not in a Guild:
  - Stronghold becomes **“Freelancer-hired”**, with:
    - Reduced benefits,
    - But some shared regional buff.  
- Player gains:
  - Stronghold standing,
  - Access to Stronghold’s:
    - Bank extension,
    - Local respawn point (Shrine link),
    - Passive trickle of resource.

**Implementation Notes:**

- Stronghold state DB:
  - `stronghold_state` table should record:
    - owner_guild_id,
    - owner_type (guild/freelancer/NPC),
    - vulnerability windows, etc.
- Capture logic:
  - Derived from PvP capture point system (e.g., AB nodes).

---

### 5.4 Q10203 — “The Siege Clock”

- **QuestID:** 10203  
- **Type:** MAIN (Vulnerability & Defense Tutorial)  
- **Giver:** Stronghold Steward NPC at Broken Spire, or message from Council Fire.  
- **Prereqs:** Q10202.

**Summary:**  
You are taught that Strongholds are not permanent. They have **vulnerability windows** where enemy forces can legally attack and flip ownership. You must participate in one scheduled defense.

**Objectives:**

- Review Stronghold’s **Siege Schedule** UI (shows vulnerability timers).  
- Be present during one **Vulnerability Window**.  
- Help defend against a scripted **attack event**:
  - Enemy strength scaled to region and Stronghold tier.  
- Ensure Stronghold Heart / Banner HP > 0.

**Rewards:**

- Stronghold reputation,  
- Small boost to owner guild’s standing,  
- Unlock daily/weekly **Stronghold Contracts**:
  - Guard duty,
  - Resource hauling,
  - Supply raid.

**Implementation Notes:**

- This is the *player tutorial* for the “clock” that governs:
  - When other guilds can contest your holdings,
  - When NPC invasions can strike forts.

---

### 5.5 Q10204 — “When a Zone Falls”

- **QuestID:** 10204  
- **Type:** MAIN (Scripted Zone Invasion Outcome)  
- **Giver:** War Map Table (auto-event) or Council Fire NPC.  
- **Prereqs:** Q10203.

**Summary:**  
To show consequences, the system **forces** (via script) a neighboring zone to “fall” to an invading faction (e.g., Midnight Horde, cultists, or rival NPC faction). Players witness the change and help evacuate refugees.

**Objectives:**

- Travel to **Fallen Zone** border (e.g., a Yellow zone node now flagged as “Invasion”).

- Perform 2–3 emergency tasks:
  - Escort **refugee NPCs** back to safe zones,  
  - Destroy **supply caches** to deny them to invaders,  
  - Collect **invasion samples** for Shrine/Atlas analysis.

**Rewards:**

- Reputation with your highest-aligned faction(s),  
- New **Zone State** visible in Atlas:
  - “Fallen: Under [Faction] Control” with:
    - Higher mob difficulty,
    - Reduced Contract availability,
    - Improved rewards for counter-attacks.

**Implementation Notes:**

- Mechanically:
  - Use the same system you will use for real emergent invasions later,
  - But with a scripted, guaranteed example in Act IV.

---

### 5.6 Q10205 — “Retake the Roads”

- **QuestID:** 10205  
- **Type:** MAIN (Counter-Attack & Participation)  
- **Giver:** Ranger Captain Thera or Iron Ledger military rep.  
- **Prereqs:** Q10204.

**Summary:**  
You join a **multi-stage counter-attack** to re-open vital roads in the Fallen Zone, without necessarily retaking full zone control yet.

**Objectives:**

- Participate in 3 operations (these can be tackled in any order):  
  1. **Clear the Pass:**  
     - Kill a certain number of invaders blocking a canyon or bridge.  
  2. **Secure a Relay Shrine:**  
     - Help Shrine defenders reclaim a minor Shrine outpost.  
  3. **Rebuild a Supply Waystation:**  
     - Gather materials and defend workers.

**Rewards:**

- Zone state updated to: **“Contested, Roads Open”**  
  - Travel & basic contracts restored,  
  - Invasion presence remains in hinterlands.  
- Access to:
  - **Invasion Contracts** (repeatables that pay well to fight in the Fallen Zone).  

**Implementation Notes:**

- This quest:
  - Teaches that “partial wins” matter:
    - You may not own the zone, but you can restore some functionality.

---

### 5.7 Q10206 — “Warfront by Another Name”

- **QuestID:** 10206  
- **Type:** MAIN (Warfront Intro)  
- **Giver:** Council Fire or Warfront Commander NPC.  
- **Prereqs:** Q10205.

**Summary:**  
You’re told that some conflicts are too large for open-world skirmishes. The “Warfront” is a **set-piece battle** in a mirrored copy of the Fallen Zone, where factions clash for the right to control **strategic objectives** (bridges, keeps, shrines).

**Objectives:**

- Enter a Warfront instance via **physical portal** in the contested zone.  
- Complete **one Warfront match** by:
  - Holding objectives,  
  - Destroying enemy siege engines,  
  - Capturing or defending a central keep.

**Rewards:**

- Personal rewards:
  - Gold, materials, **Military Credits**,  
  - Reputation with whichever faction sponsored your side.  
- World effect (if your side wins, at server scale):
  - Zone state might flip to:
    - “Player-aligned Control” for a period,  
    - Or grant:
      - Buffs,
      - Stronghold vulnerability changes,
      - Resource shipments to owned Strongholds.

**Implementation Notes:**

- Warfront matches:
  - Can be scheduled events or on-demand if enough players queue at portal.
- Important:  
  - Entry is **physical**; no random teleport LFG.

---

### 5.8 Q10207 — “Our First Banner”

- **QuestID:** 10207  
- **Type:** MAIN (Act IV resolution)  
- **Giver:** Council Fire or local Commander.  
- **Prereqs:**  
  - Completion of Q10206,  
  - Player’s realm has at least one **player-owned Stronghold** + at least one **zone moved from Fallen → Contested / Controlled** in simulation.

**Summary:**  
You return to the War Map to see the first **permanent changes** etched on the board: a Stronghold under your (or your guild’s) banner, and a previously Fallen Zone now contested or partially reclaimed.

**Objectives:**

- Interact with War Map again and see:
  - Your Stronghold’s icon highlighted,  
  - One previously Fallen Zone now marked as:
    - “Stabilizing” or “Player-Aligned Control”.  
- Speak with your **preferred faction rep** about what this means:
  - Ledger: trade lines are reopening, profits ahead, but more risk.  
  - Shrine: fewer restless dead, but the Hordes will adapt.  
  - Cartel: opportunities for smuggling & black markets.  
  - Rangers: one line stabilized, many more to go.

**Rewards:**

- Unlock:
  - Full access to:
    - Stronghold Contracts (daily/weekly),  
    - Invasion Contracts,  
    - Warfront rotations.  
- Progress toward macro titles such as:
  - “Banner-Bearer”, “Lineholder”, “Breaker of the First Breach”.  
- A small, permanent account-wide cosmetic:
  - e.g., a **“First Banner Tabard”** or a **campfire toy**.

**Implementation Notes:**

- Act IV’s narrative completion does **not** end Stronghold/Invasion play:
  - It just establishes:
    - “From now on, this is how the world lives.”

---

## 6. Repeatable Content Hooks

Act IV should create *ongoing* loops, not just one-time story beats.

### 6.1 Stronghold Contracts

Types (implemented as Contracts / Tasks tied to Strongholds):

- **Garrison Patrol:**  
  - Kill X enemies near Stronghold, prevent siege buildup.  
- **Supply Run:**  
  - Move resources from city → Stronghold or vice versa.  
- **Siege Drill:**  
  - Practice with siege engines; minor rewards, training.

Rewards:

- Gold, materials, small Stronghold rep,  
- Chance at Stronghold cosmetic props (banners, braziers).

### 6.2 Invasion Contracts

- **Horde Breaker:**  
  - Kill invasion elites, destroy banners.  
- **Refugee Escort:**  
  - Guard NPCs fleeing Fallen zones.  
- **Ether Cleanser:**  
  - Use Shrine Devices on corrupted ground.

Rewards:

- Higher payouts than normal contracts,  
- Increased Shrine and Ranger standing,  
- Chance at unique invasion-themed Runes or skins.

### 6.3 Warfront Weeklies

- “Win 1 Warfront”, “Participate in 3”, “Capture 5 objectives”, etc.  
- Rewards:
  - **Military Credits** → Siege blueprints & consumables for Strongholds.  
  - Warfront titles & cosmetics.

---

## 7. Atlas & MortalUI Integration

- War Map:
  - Visualization of:
    - Zone control,
    - Stronghold ownership,
    - Active/future invasions,
    - Warfront status.
- Filters:
  - Show:
    - “My Guild Strongholds”,  
    - “Fallen Zones only”,  
    - “Hot Zones (bonus rewards)”.

- In-game UI:
  - MortalUI panels to:
    - See Stronghold schedule (vulnerability windows),  
    - Browse available Stronghold/Warfront/Invasion Contracts.

---

## 8. Implementation Checklist

1. **DB Schema:**
   - `territory_control` for zones,  
   - `stronghold_state` for individual Strongholds,  
   - `invasion_state` for ongoing invasions.

2. **Core Scripts:**
   - `stronghold_capture.lua`  
   - `stronghold_siege_clock.lua`  
   - `zone_invasion_controller.lua`  
   - `warfront_portal.lua`

3. **Quest Templates:**
   - Q10200–Q10207 in `quest_template` with appropriate flags & texts.

4. **Events:**
   - At least one test zone where:
     - Invasion → Fall → Counter-attack → Warfront → Partial control is fully runnable in dev.

5. **UI:**
   - War Map integrated into Atlas (web) + MortalUI (in-game).

---

Act IV is the moment where Mortal Warcraft fully becomes a **living strategic sandbox**:

- Players don’t just do content;  
- They **shape the map**, hold forts, lose them, and fight to retake them—  
  all while your economy, Shrines, Cartels, and Rangers react on top.  
