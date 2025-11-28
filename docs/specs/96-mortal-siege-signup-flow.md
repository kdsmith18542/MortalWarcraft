# Project Canvas: Mortal Warcraft Overhaul  
### File: 96-mortal-siege-signup-flow.md  
### Topic: Stronghold Siege Signup & Join Flow (Player-Facing UX)

> This document defines **how players discover, sign up for, and join Stronghold Sieges**,  
> with a focus on:  
> - Reusing / adapting Wintergrasp’s existing portal/join flow,  
> - Fitting the Mortal fantasy (guild wars, full-loot risk, atlas intel),  
> - Making the experience clear even to new players.

---

## 1. Goals & Constraints

### 1.1 Goals

1. Make sieges feel **epic and intentional**, not confusing or “hidden tech”.
2. Preserve the **sandbox war fantasy**:
   - Guilds declare war and defend/attack fortresses,
   - Neutral players can spectate or support indirectly.
3. Reuse as much of the **existing Wintergrasp tech** as possible:
   - Zone battle state,
   - Fort + walls + vehicles,
   - Portals / teleports into the zone.

### 1.2 Constraints

- Client is still **WotLK 3.3.5a**:
  - No custom hardcoded UI; everything must be:
    - NPC gossip menus,
    - Map markers,
    - Lua-based addons (MortalUI),
    - System messages, raid warnings, etc.
- Stronghold Siege is not a random queue:
  - No LFG-style anonymous matchmaking,
  - It is a **guild-driven war event**.

---

## 2. Siege Lifecycle (Player View)

For players, every Siege passes through four visible stages:

1. **Announced / Scheduled** (war drums in the distance)
2. **Signup / Rally** (join attackers or defenders)
3. **Lock-in & Deployment** (teams formed, move to siege staging)
4. **Active Siege Battle** (Wintergrasp-style battle + full loot)

We tie each stage to:

- **NPCs** (Heralds, War Quartermasters, Stronghold Steward),
- **MortalUI** (world map overlay, war calendar),
- **Atlas Web** (schedule, who's attacking, estimated forces).

---

## Related Specs

For full context on siege signup and flow, see:

- **`92-mortal-warfronts-siege-flow.md`** — Siege flow system that signup supports
- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege adaptation that signup integrates with
- **`08-guilds-sovereignty.md`** — Stronghold system that sieges target
- **`97-mortal-guild-war-and-alliances.md`** — Guild war mechanics that enable sieges
- **`24-webportal-mortal-atlas.md`** — Atlas web portal that displays siege schedules
- **`18-lfg-warfront-ui.md`** — UI systems that support siege signup
- **`98-mortal-siege-prep-contracts.md`** — Siege preparation contracts that precede signup

---

## 3. Stage 1 – Announced / Scheduled

### 3.1 Trigger

- A guild successfully **challenges** a Stronghold (via Stronghold Steward / war declaration).
- `MortalSiegeController` sets:
  - Siege start time,
  - Attacker/defender guild IDs,
  - Siege map (Wintergrasp, later others).

### 3.2 In-Game Notifications

1. **Global Broadcast**
   - Example:
     - `The war drums thunder! Guild <Iron Covenant> has challenged the Stronghold of Wintergrasp, held by <Ashen Vanguard>. Siege begins in 45 minutes.`

2. **Zone Messages**
   - Players in nearby regions see:
     - `Wintergrasp Fortress will come under siege soon. Civilians are advised to evacuate.`

3. **Herald NPCs**
   - New NPC: **“Herald of War”** in major cities (Stormwind, Orgrimmar equivalents) and key hubs.
   - Gossip text:
     - `"I bear grim tidings. A siege has been declared upon the Stronghold of Wintergrasp."`
   - Options:
     - `[View Siege Details]` → opens a MortaUI frame or printed text with:
       - Attacker vs defender guilds,
       - Start time,
       - Eligibility hint (guild membership, level/skill, Standing).

### 3.3 Atlas Web Portal

On Atlas (“Warfronts & Sieges” section):

- List of upcoming sieges with:
  - Stronghold name, map,
  - Attacker/defender guild crests,
  - Countdown timer,
  - Expected rewards (resource shipments, Standing, Military Credits),
  - Link to “How to Participate” wiki page.

---

## 4. Stage 2 – Signup / Rally

### 4.1 Eligibility Rules

A player is **eligible** to sign up if:

- They belong to:
  - The **attacker guild** or one of its declared allies, **or**
  - The **defender guild** or one of its declared allies.
- Optional future: designated **mercenary slots** (for neutral guilds).

### 4.2 Siege Signup NPCs

We introduce **Siege Marshals**:

- Location:
  - In major cities (near War Quartermasters),
  - At Stronghold-adjacent hubs,
  - Near Warfront portals (where applicable).

- Gossip template:

  - If player is eligible defender:
    - `"The Stronghold of Wintergrasp is under threat. Will you stand with your brothers and sisters?"`
    - Options:
      - `[Join the Defence]` (sign up as defender),
      - `[Tell me more about the siege]` (explain risk, full loot, etc).

  - If player is eligible attacker:
    - `"Our banners are raised against Wintergrasp. Will you march with your guild?"`
    - Options:
      - `[Join the Assault]`,
      - `[Tell me more about the siege]`.

  - If ineligible (neutral):
    - `"This war is not for you, traveler. Only sworn guilds of the conflict may join this siege."`
    - Later: add mercenary option.

### 4.3 Signup Result

When a player clicks **Join**:

- Server-side:
  - `MortalSiegeController::RegisterParticipant(playerGuid, side);`
  - Marks them as:
    - Signed up for attacker or defender side,
    - Visible in siege rosters (for admin tools & Atlas, anonymized if desired).

- Client-facing feedback:
  - Chat message:
    - `You have pledged to defend the Stronghold of Wintergrasp. Report to the War Camp when called.`
  - MortalUI:
    - Adds an entry to a “War Commitments” panel:
      - Shows the siege, side, countdown.

### 4.4 War Camp & Rally Points

Before the siege:

- War camp areas near:
  - City gates,
  - Stronghold outskirts.

Design:

- War camps are safe-ish set-up zones:
  - Vendors (ammo, food, flasks),
  - Repair NPCs,
  - Class/role advisors (lore + build tips).
- Players who signed up are encouraged via broadcast:
  - `Defenders of Wintergrasp, rally at the War Camp in [Zone]!`

Implementation:

- MortalUI map pins & minimap markers for **“War Camp – Wintergrasp Siege”**.

---

## 5. Stage 3 – Lock-In & Deployment

### 5.1 Lock-In Time

At T-minus X minutes (e.g. 5–10 minutes before battle start):

- Siege moves into **LOCK-IN** state.

Rules:

- New signups may:
  - Be disallowed, or
  - Allowed until the last minute but flagged as “late join” (configurable).
- Signed-up players who are **AFK/offline**:
  - May be dropped from the active roster (no penalty for Season 1).

### 5.2 Teleport / Portal Activation

Reusing Wintergrasp’s portal logic:

- **Siege Portals** become active in:
  - Major cities (portal room or war quarter),
  - War camp near the Stronghold.

- Only players who:
  - Are signed up and on the correct side,
  - Meet minimum skill-based level / Standing,
  can click and be transported to the **siege staging area** inside the Wintergrasp map.

Gossip on Siege Marshal updated:

- `"The time has come. The siege is about to begin."`
- Options:
  - `[Enter the Siege Staging Grounds]` (if eligible),
  - `[I am not ready yet]`.

### 5.3 Staging Area

In Wintergrasp map:

- Each side spawns in their **own staging area**:
  - Attackers: encampment outside fortress walls,
  - Defenders: inner courtyard or inner war camp.

- Staging rules:
  - Full loot is active **only after the battle starts**,
  - Players can adjust gear, talk, plan,
  - MortaUI can show:
    - Team count,
    - Vehicles available,
    - Countdown timer.

---

## 6. Stage 4 – Active Siege Battle

### 6.1 Battle Start

At T = 0:

- Wintergrasp battle state → ACTIVE,
- `MortalSiegeController` marks:
  - Zone as Red-Zone full-loot,
  - Siege-specific Shrine respawn rules active.

Broadcasts:

- Global:
  - `The Siege of Wintergrasp has begun!`
- To participants:
  - `Walls will not hold without steel and will. Fight!`

### 6.2 Mid-Siege Feedback

- MortalUI siege overlay:
  - Relative strength (approx player counts),
  - Objectives captured/destroyed,
  - Remaining time,
  - Simple guidance like ‘Outer Wall Breached’ or ‘Inner Keep Under Siege’.

- Atlas (near-real-time):
  - Killfeed flagged with `[SIEGE]`,
  - Map overlay: Stronghold icon flashing during active siege.

### 6.3 Battle End & Extraction

On Wintergrasp battle end:

- System decides winner (attacker/defender).
- `MortalSiegeController::OnSiegeEnded(...)`:
  - Flips Stronghold owner if applicable,
  - Triggers resource shipments & Standing rewards,
  - Broadcasts:
    - `The Stronghold of Wintergrasp has fallen to <NewOwnerGuild>.`
- Participants:
  - Either:
    - Get phased out via portal,
    - Or remain in a “cleanup” phase for a few minutes to reclaim bodies and loot.

---

## 7. Off-Roles & Non-Participants

### 7.1 Spectators

To keep things clean:

- Non-participants:
  - Cannot enter the active siege zone via portals,
  - Might observe from certain world vantage points (future nice-to-have).

Later feature:
- “War Reporters” or Atlas-affiliated scouts with special permits.

### 7.2 Indirect Participation

Even during a siege, other players can:

- Run **supply Contracts**:
  - Deliver siege materials to the Stronghold before or during siege.
- Perform **distraction tasks**:
  - Attack enemy supply lines elsewhere (future expansion).

These are out-of-scope for first implementation but fit the fantasy and can be tied into Task Boards later.

---

## 8. MortalUI & Atlas Details

### 8.1 MortalUI

Add a **“War” tab**:

- Shows:
  - Upcoming sieges with countdowns,
  - Your role (attacker/defender/none),
  - Quick button: “Set Waypoint to War Camp”.

Pop-up notifications:

- When a siege you’re signed up for is:
  - 15 minutes from start,
  - 5 minutes from start (with “Enter Staging” hint if you’re in a city).

### 8.2 Atlas Web

On the “Warfronts & Sieges” page:

- Card for each siege:
  - Stronghold, attacking/defending guilds,
  - Start time in multiple time zones,
  - Last known sign-up numbers (rounded to protect intel),
  - Basic risk description:
    - “Full loot, Red Zone, recommended skill level X+.”

Wiki integration:

- `/wiki/guilds-strongholds-warfronts/sieges/how-to-join`:
  - Step-by-step version of this doc.

---

## 9. Integration With Existing Wintergrasp Flow

We reuse:

- Wintergrasp’s:
  - Zone,
  - Fort layout,
  - Vehicles and workshops,
  - Battle state machine.

We replace/customize:

- Queue/join:
  - No automatic BG queue; instead, **Siege Marshals** and portals managed by `MortalSiegeController`.
- Rewards:
  - Honor/marks removed; Mortal rewards via Standing/Military Credits.
- Access:
  - Post-battle control still matters (owner gets buff/resource, etc.),
  - But now tied to **Stronghold ownership** instead of faction.

---

## 10. Summary

This flow ensures:

- Players discover sieges through:
  - Global announcements,
  - Herald NPCs,
  - MortalUI & Atlas.

- Signing up is:
  - Done via **physical NPCs (Siege Marshals)**,
  - Tightly tied to guild membership & alliances.

- Joining the battle feels:
  - Organized (War Camps, staging areas),
  - Dangerous (full-loot rules clearly communicated),
  - Connected to the wider realm (Atlas, broadcasts, Stronghold ownership).

All this builds on Wintergrasp’s existing tech while making it feel **100% like a Mortal Warcraft war event** instead of a generic BG.
