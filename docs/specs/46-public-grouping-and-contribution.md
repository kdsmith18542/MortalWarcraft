# Project Canvas: Mortal Warcraft Overhaul
### Version 31.5 — Hybrid Technical Design Document  
### File: 46-public-grouping-and-contribution.md  
### Section: Auto-Grouping, Public Expeditions & Contribution-Based Rewards

---

## 1. Purpose

Define systems that make **group content frictionless** without breaking the sandbox:

- Auto-grouping for **public content** (Rifts, public dungeons, world bosses, some Warfront pre-events).
- Contribution-based rewards so **tanks, healers, and support builds are fairly rewarded**.
- “Expedition Rally” (Rift Instant Adventure–inspired) that **points players to shared objectives** without teleport spam.

These systems must:

- Preserve **travel** and **risk** (no free teleports into endgame).
- Integrate with existing **event templates**, **Planar Rifts**, and **Task Boards**.
- Be optional: players can still run content manually if they prefer.

---

## Related Specs

For full context on public grouping and contribution systems, see:

- **`45-eldens-eve-layer.md`** — Elden's Eve layer and planar rifts that use public grouping
- **`06-pve.md`** — PvE content (public dungeons, world bosses) that uses public grouping
- **`48-zone-invasions-and-cross-faction-pve.md`** — Zone invasions that trigger public grouping
- **`38-social-and-onboarding-systems.md`** — Social systems that complement public grouping
- **`18-lfg-warfront-ui.md`** — LFG UI systems that support public grouping
- **`92-mortal-warfronts-siege-flow.md`** — Warfront system that uses public grouping for mustering

---

## 2. Content Types Eligible for Public Grouping

Public grouping applies to:

1. **Planar Rifts** (File 45)
2. **Public Dungeons / Delves** (File 3.x)
3. **World Bosses** (File 2.x)
4. **Some World Events** (Zombie Horde, Resource Surges, Invasions)
5. **Optional:** Pre-battle “mustering phases” for **Warfronts**

Not used for:

- Standard 5-man instance dungeons,
- Extraction raids (where coordination and secrecy matter),
- Purely social areas (taverns, cities).

---

## 3. Public Grouping UX

### 3.1 Join Public Expedition Prompt

When a player enters the “event radius” of an eligible activity:

- Planar Rift phase,
- Public Dungeon area,
- World Boss radius,

MortalUI shows a small popup:

> “A public expedition is underway here. Join the group?”  
> [Join Expedition] [Stay Solo]

Rules:

- If the player clicks **Join Expedition**:
  - The server finds or creates a **Public Group** for that event.
  - Adds the player to it (respecting group size limits).
- If the player clicks **Stay Solo**:
  - They won’t be prompted again for that specific event instance unless they leave and re-enter after a timeout.

Key points:

- No separate UI window; minimal interruption.
- Group is tied to **event instance** (Rift ID, Public Dungeon instance ID, World Boss session ID).

### 3.2 Public Group Properties

- **Leaderless** in terms of gameplay power:
  - The “leader” concept is purely technical (for the API).
- **Automatic cleanup**:
  - Group disbands shortly after the event ends, or when last participant leaves the area.
- **Invite rules**:
  - Players in a Public Group can still:
    - Invite friends,
    - Merge with another Public Group for the same event (server decided).

---

## 4. Expedition Rally (Action on Demand Without Teleport Spam)

### 4.1 Concept

“Expedition Rally” is inspired by Rift’s Instant Adventure but adapted to Mortal Warcraft’s travel/risk philosophy.

Goal:

- A player in a **tavern or city hub** can ask:

  > “Give me something to do with others.”

without:

- Teleporting them directly to the event,
- Ignoring the world’s geography.

### 4.2 Flow

1. Player interacts with **Expedition Board** or **Innkeeper** in a major hub.
2. They select **“Join an Expedition”**.
3. Server chooses an appropriate expedition:

   - Prioritized:
     - Active Planar Rifts,
     - Public Dungeons with few players,
     - World Events that need more participants,
     - World Boss spawn windows.
   - Filters:
     - Suitable for player’s dynamic level/skill band,
     - Travel-time reasonable from current hub.

4. MortalUI shows:

   - Expedition type (“Public Dungeon: Deadmines Delve”),
   - Target zone & distance,
   - Estimated group size.

5. On **Accept**:

   - Player is:
     - Marked as “Rallying” for that expedition,
     - Given:
       - A **map ping** (MortalMap route),
       - A modest **road speed buff** along major roads,
       - Optional flavorful buff name (“March of the Expedition”).

6. On arrival in event radius:

   - Auto **Join Public Expedition** prompt fires as usual.

No teleportation; travel remains part of the game loop.

---

## 5. Contribution-Based Reward Model

### 5.1 Goals

- Reward **participation and role fulfillment** rather than tag-sniping.
- Make **tanks, healers, and control** economically viable.
- Avoid overly complex or opaque systems; players should have rough intuition.

### 5.2 Contribution Buckets

For an eligible event, track per-player:

1. **Damage Contribution**
   - Total effective damage dealt to:
     - Event mobs,
     - Objectives (wardstones, siege adds, etc.).
2. **Healing Contribution**
   - Effective healing done to:
     - Player characters (including overheal-capped),
     - Friendly NPCs with “protected” flags.
3. **Guard / Mitigation Contribution**
   - Time spent:
     - Holding aggro on designated bosses/elites,
     - Using Brace/Guard counters effectively (count successful Guard Counters).
4. **Utility & Control**
   - Successful crowd control on event mobs:
     - Measured as time under CC debuffs,
     - Interrupts on marked abilities,
     - Dispels of key debuffs from allies.

Internally, each bucket accumulates a normalized score (0–100).

### 5.3 Total Contribution Score

For each player:

```text
TotalScore = wD * DamageScore
           + wH * HealingScore
           + wT * GuardScore
           + wU * UtilityScore
```

Where:

- `wD`, `wH`, `wT`, `wU` depend on the event type:

  - Planar Rift: balanced (e.g., 0.30 / 0.30 / 0.25 / 0.15)
  - Public Dungeon: more weight on damage/guards
  - World Boss: weight more on tanks/healers/control.

Normalize TotalScore to 0–100 per event.

### 5.4 Reward Scaling

For event-level rewards:

- Base payout (per event) defined in existing event templates:
  - Gold,
  - Tokens,
  - Mats,
  - Chance at rare items/runes.

For each player:

```text
RewardMultiplier = 0.25 + 0.75 * (TotalScore / 100)
```

- Minimum meaningful participation threshold:
  - If TotalScore < 10:
    - RewardMultiplier might be clamped lower (e.g., 0.1 or no rare roll).

This ensures:

- Bare minimum presence still yields some reward (0.25x),
- High contribution roughly triples effective rewards (up to 1.0x baseline).

### 5.5 Implementation Notes

- Contributions can be tracked in memory per event instance; DB writes only summary metrics if needed for telemetry.
- Use simple structures:

  - `mortal_event_contrib` (optional):

    ```sql
    CREATE TABLE IF NOT EXISTS mortal_event_contrib (
      id              INT AUTO_INCREMENT PRIMARY KEY,
      event_active_id INT NOT NULL,
      player_guid     INT NOT NULL,
      damage_score    FLOAT NOT NULL,
      healing_score   FLOAT NOT NULL,
      guard_score     FLOAT NOT NULL,
      utility_score   FLOAT NOT NULL,
      total_score     FLOAT NOT NULL,
      rewards_json    TEXT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ```

---

## 6. Social Considerations & Anti-Abuse

- AFK leechers:
  - TotalScore below a small threshold yields:
    - Reduced or no rare rewards.
- Griefers:
  - Intentional “gaming” (e.g., healing their own damage constantly) can be mitigated via:
    - Effective healing caps,
    - Only counting healing/CC on **valid event targets**.
- Tank/support viability:
  - Validate in testing that:
    - A main tank or full healer, played properly, hits comparable TotalScore to DPS in most fights.

---

## 7. Integration Points

1. **Planar Rifts**
   - Auto group + contribution scoring per Rift.
2. **Public Dungeons / Delves**
   - Shared groups for large complexes, contribution scoring on major bosses or overall run.
3. **World Bosses & Horde Events**
   - Public grouping is almost mandatory; contributions drive token/mat payouts.
4. **Expedition Rally**
   - Uses existing event templates to pick targets.
   - Integrates with navigation (MortalMap route, road buffs).

---

## 8. Implementation Checklist

1. Implement **Public Expedition** group type and join prompt logic.
2. Implement **Expedition Rally** selection logic and hub UI.
3. Add **contribution counters** to event runtime:
   - Damage, healing, guard, utility.
4. Implement **reward scaling** by TotalScore.
5. Add **telemetry** to measure:
   - Participation rates,
   - Reward distributions,
   - AFK/leech prevalence.
