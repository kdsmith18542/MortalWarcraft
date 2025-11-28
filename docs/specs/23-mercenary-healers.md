# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 23-mercenary-healers.md  
### Section: Mercenary Cleric System (Hireable Healer NPCs for Instances)

---

# 1. Purpose

This document defines the **Mercenary Cleric** system for Mortal Warcraft:

- Hireable healer NPCs that accompany players into:
  - **5-man dungeons**
  - **Public delves (optional)**
  - **Some raids (optional, tightly restricted)**
- Implemented using:
  - Custom creature templates (separate from mod-playerbots)
  - Mortal Lua scripts (contracts, costs, rules)
  - Custom AI scripts for healer behavior
  - Optional AIO/MortalUI front-end

**Note:** This system is separate from mod-playerbots. Mercenaries are custom NPCs spawned as creatures, not AI-controlled player characters. See `29-companion-bond-and-mercenary-system.md` for the unified companion system design.

---

## Related Specs

For full context on mercenary healer systems, see:

- **`29-companion-bond-and-mercenary-system.md`** — Unified companion and mercenary system
- **`22-healing-and-restoration.md`** — Healing and restoration systems that mercenaries use
- **`06-pve.md`** — PvE content (dungeons, delves) where mercenaries are used
- **`04-economy.md`** — Economy system for mercenary hiring costs
- **`23a-merc-healer-archetypes.md`** — Mercenary healer archetypes and specializations
- **`33-instance-and-battleground-tier-mapping.md`** — Instance mapping that determines mercenary availability

---

This gives:

- Small groups / duos a way to run instances without a dedicated Restoration build.
- A gold sink and progression path for PvE-focused players.
- A controlled source of healing that **does not replace** real players in open-world or high-risk Red-zone content.

---

# 2. Design Goals

1. **Accessibility Without Undermining Risk**
   - Help 1–3 player groups run instance content.
   - Do **not** trivialize content or negate the need for human healers.

2. **Contained Scope**
   - Mercenary clerics are primarily:
     - **Instance-bound** (5-man dungeons).
   - Optional later extension to:
     - Some raids (as weak, support-only healers).
     - Yellow-zone delves.

3. **Economy Integration**
   - Hiring a merc is:
     - A **gold sink**.
     - Potentially a **token sink** in future.

4. **Lore & Fantasy**
   - Mercs are in-world NPCs:
     - “Temple-sanctioned clerics.”
     - “Adventurer’s Guild healers.”
   - They reinforce the **Restoration discipline** theme without being full characters.

---

# 3. High-Level Rules

## 3.1 Where They Can Be Used

**Allowed by default:**

- Vanilla and TBC/WotLK **5-man dungeons**:
  - RFC → ICC 5-man.
- Private instances only (party-based).

**Optional (feature-flag based):**

- Public delves (e.g. de-instanced Deadmines) → **disabled at start**.
- Entry-level raids (e.g. MC, Karazhan) → limited to 1 merc per raid, if enabled.

**Forbidden by default:**

- **Red Zones** (open-world full loot).
- **Hellgates**.
- **Warfronts, arenas, and battlegrounds**.
- Any map flagged explicitly as **No Mercs** via `mortal_zone_flags`.

---

## 3.2 How Many per Group

- Base rule:
  - **1 Mercenary Cleric per party**.
- Feature flag:
  - `merc_max_per_party` (default 1, upper cap 2).
- Raid rule (if enabled):
  - At most **1 merc per raid**; they fill a support role only.

---

## 3.3 Cost & Duration

### 3.3.1 Upfront Fee

- Paid in gold (and optionally Mortal token).
- Scales by:
  - **Dungeon tier** (low → mid → high).
  - Party size (optional).
- Example:
  - Tier 1 (RFC / Deadmines): 50–100g.
  - Tier 2 (SM / ZF / BRD): 200–300g.
  - Tier 3+ (high-level dungeons): 500–1000g.

### 3.3.2 Contract Duration

Two possible contract modes (configurable):

1. **Instance-locked contract (default):**
   - Merc remains hired until:
     - The party leaves the instance.
     - The party disbands.
     - The leader manually dismisses the merc.
   - Best for simplicity.

2. **Timed contract (optional):**
   - Merc hired for X minutes real time.
   - Timer persists only while **inside** the instance.

Implementation uses:

- `mortal_merc_contracts` with timestamps and map binding.

---

## 3.4 Risk & Death

- If the merc dies:
  - They respawn with the party at **instance entry** or **boss reset**.
  - No additional fee for that run (as long as contract is active).
- If the party wipes:
  - Standard dungeon reset rules apply.
  - Merc respawns with the group.

---

# 4. Behavior & AI

## 4.1 Role: Healer-Focused Support

Mercenary clerics use a **minimal spell kit**:

- Single-target direct heal (Minor Mend equivalent).
- Single-target HoT (Rejuvenating Prayer equivalent).
- Small AoE heal with long cooldown (Circle of Mending equivalent).
- Emergency big heal with long cooldown.
- Basic cleanse (poison/disease/curse depending on variant).

They:

- Prioritize:
  1. Tank (highest threat target).
  2. Party members below % HP threshold.
  3. Self.

- Position:
  - Stay near party center, behind tank when possible.
  - Move out of obvious AoE zones (if detectible through events).

- DPS:
  - Only light DPS when:
    - Group HP is stable above threshold.
    - No serious damage events in progress.

---

## 4.2 Interaction with Mortal Systems

- **Crimson Phial**:
  - Mercs have **their own limited flask charges**.
  - They use it to avoid dying; they do not share with player resources.
- **Restoration Skill**:
  - Mercs have an internal `Restoration` level appropriate for dungeon tier.
  - Affects:
    - Spell strength.
    - Mana capacity.
- **Guard Counter**:
  - Optional extension:
    - Tank mercs (future) could use Guard Counter; cleric mercs generally do not.

---

# 5. Front-End: Hiring UX & AIO Panels

## 5.1 Mercenary Broker NPC

**Location:**

- Major cities (e.g., Stormwind Cathedral, Orgrimmar Cleft of Shadow equivalent).
- Dungeon hubs (e.g., near instance portals).

**Gossip Options:**

1. “Hire a Cleric Mercenary.”
2. “Learn about Mercenaries.”
3. “Dismiss my current Mercenary.”

Selecting “Hire” opens **AIO panel** if available; otherwise a simple gossip submenu.

---

## 5.2 AIO Hiring Panel (Optional)

AIO server script: `merc_ui.lua`  
MortalUI client script: `aio/merc_ui.lua`

Panel displays:

- Mercenary types (for now, only **Cleric**):
  - Name, short description.
  - Role: Healer.
  - Recommended for: 3–4 player groups.
- Dungeon tier selector (if near multiple instance levels).
- Price breakdown:
  - Upfront fee in gold.
  - Optional token or reputation discounts.

Buttons:

- “Hire Now” → triggers server RPC.
- “Back” / “Cancel”.

---

# 6. Data Model

## 6.1 Tables

### `mortal_merc_contracts`

**Note:** This table structure has been updated in `30-db-migrations-mortal-core.md`. The current structure is:

- `id` (PK, INT AUTO_INCREMENT)
- `owner_guid` (INT, FK → `characters.guid`)
- `merc_template_id` (INT, FK → `mortal_merc_templates.id`)
- `merc_creature_guid` (BIGINT) – spawned creature GUID if active
- `start_time` (INT) – Unix timestamp
- `end_time` (INT) – Unix timestamp
- `active` (TINYINT)
- `last_paid_time` (INT)
- `daily_wage` (INT)
- `notes` (VARCHAR(255))

### `mortal_merc_templates`

Defines available mercenary archetypes:

- `id` (PK)
- `name` (VARCHAR) – e.g. "Mortal Field Medic"
- `role` (VARCHAR) – 'tank','healer','melee_dps','ranged_dps'
- `base_gear_tier` (VARCHAR) – e.g. 'M-T2','M-T3'
- `creature_entry` (INT) – creature_template.entry
- `base_wage` (INT) – gold cost baseline
- `max_bond_bonus` (TINYINT) – max % performance bonus at bond=100

**See `30-db-migrations-mortal-core.md` for full table definitions.**

---

# 7. Technical Implementation

## 7.1 Custom Creature System

Mercenaries are implemented as **custom creatures** (not mod-playerbots). They use:

- `mortal_merc_templates` table to define available merc archetypes
- Custom creature templates in `creature_template` (reserved range: 600000-609999 per `31-mortal-core-registry.md`)
- Custom AI scripts for healer behavior

### 7.1.1 Healer Merc Template

- Create a **creature template** entry:
  - Base stats appropriate for dungeon tier (M-T2/M-T3 gear tier).
  - Spells:
    - Map to Mortal's Restoration spells.
  - AI:
    - Healing priority logic (tank → lowest HP → self).
    - Minimal offensive rotation.
    - Position awareness (stay behind tank, avoid AoE).

### 7.1.2 Spawning & Binding

When hiring:

1. Lua/C++ script:
   - Queries `mortal_merc_templates` for available healer mercs.
   - Spawns a creature from the template at party leader location.
   - Sets creature to follow party leader and join group.
   - Links creature GUID to `mortal_merc_contracts.merc_creature_guid`.
2. Store the creature GUID and link to `mortal_merc_contracts.contract_id`.
3. Limit:
   - One such merc per party by checking existing contracts.

When contract ends or dungeon is left:

- Despawn the creature.
- Mark contract as inactive.

**See `29-companion-bond-and-mercenary-system.md` for full mercenary system design including Bond & Hunger mechanics.**

---

## 7.2 Lua Control Layer: `merc_healer_system.lua`

Responsibilities:

- Gossip handler for Mercenary Broker NPC.
- Contract management:
  - Creation, extension (if timed), and termination.
- Enforcement:
  - Zone/instance restrictions.
  - Maximum active mercs per party.
- Player feedback messages.

Pseudocode example (simplified):

```lua
local MERC_TYPE_CLERIC = "cleric"

function MercenaryBroker_OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        MortalMercs.TryHireCleric(player)
    elseif intid == 2 then
        MortalMercs.DismissMerc(player)
    end
end
```

`MortalMercs.TryHireCleric(player)`:

- Checks:
  - Player is party leader.
  - No existing active merc for party.
  - Map is a valid instance or hub.
  - Player has enough gold.
- If all good:
  - Deduct gold.
  - Create contract row.
  - Spawn mercenary creature from template.
  - Add to party.

---

## 7.3 Configuration Flags

Add entries to `mortal_feature_flags`:

- `merc_enabled` (bool)
- `merc_cleric_enabled` (bool)
- `merc_max_per_party` (int)
- `merc_allowed_in_raids` (bool)
- `merc_allowed_in_delves` (bool)
- `merc_instance_only` (bool, default true)
- `merc_fee_multiplier` (float, for global economic tuning)

---

# 8. Balance & Abuse Prevention

## 8.1 Over-Reliance

To avoid mercs completely replacing human healers:

- Keep merc potency at:
  - ~70–80% of an optimally built human Restoration specialist.
- Do not give mercs advanced:
  - Crowd control.
  - High mobility.
  - Full dispel coverage.
- They should:
  - Keep players from wiping to basic mistakes.
  - Not carry bad groups through high-end content.

## 8.2 PvP Exploits

Mercs are **hard-disabled** in:

- Open-world PvP hotspots (Red zones).
- Hellgates.
- Warfronts.
- Arenas and battlegrounds.

This ensures:

- PvP remains:
  - Player-skill and build dependent.
  - Not bot-propped.

---

# 9. Extension Points

Future expansions of this system could include:

- **Tank Mercenaries**:
  - For very small groups wanting to “DPS + healer + tank merc” comps.
- **Damage Mercenaries**:
  - Simple ranged DPS for PvE-only groups.
- **Guild Contracts**:
  - Guilds can pay a weekly fee for a small pool of on-call mercs.

Each new type would extend:

- `mortal_merc_templates` (add new template rows)
- Custom creature templates and AI scripts
- AIO UI panel options

---

# 10. Status

This file is the **authoritative spec** for Mercenary Cleric / healer NPCs in Mortal Warcraft:

- They are:
  - Hireable via Broker NPCs.
  - Implemented as custom creatures (not mod-playerbots).
  - Constrained to instanced, PvE-focused content.
- They:
  - Provide supportive healing for small parties.
  - Do not replace Restoration-specialist players in high-end or PvP content.
- This design will be iterated after:
  - Core Restoration magic is implemented.
  - Initial dungeon balance tests with and without merc support are completed.

