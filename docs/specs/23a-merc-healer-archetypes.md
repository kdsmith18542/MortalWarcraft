# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 23a-merc-healer-archetypes.md  
### Section: Mercenary Healer Archetypes (Disc / Resto Druid / Resto Shaman Inspired)

---

## Related Specs

- `23-mercenary-healers.md` - Core Mercenary Cleric system that these archetypes plug into
- `29-companion-bond-and-mercenary-system.md` - Unified companion system and mercenary implementation
- `22-healing-and-restoration.md` - Healing system and restoration magic that mercs complement
- `33-instance-and-battleground-tier-mapping.md` - Dungeon tier mapping that determines merc spell loadouts
- `84-mortal-core-stats-and-combat-model.md` - Stat system that mercs are tuned to match
- `06-pve.md` - PvE content where merc healers are used
- `04-economy.md` - Economy system for mercenary hiring costs

---

# 1. Purpose

This document defines concrete **mercenary healer archetypes** that use original WoW 3.3.5a spellkits internally (Disc Priest, Resto Druid, Resto Shaman style), but are:

- Exposed **only** as hireable NPCs (Mercenary Clerics).
- Tuned and branded as **Mortal-world factions**, not WoW classes.
- Power-clamped via auras and limited spell loadouts.

These archetypes plug into the core Mercenary Cleric system described in `23-mercenary-healers.md`.

---

# 2. Common Rules for All Merc Healers

## 2.1 General Behavior

- Role: Healer-first support.
- Intelligence level: Smart enough to keep a decent group alive, not to carry reckless play.
- Priorities:
  1. Keep the designated tank above a configurable HP threshold.
  2. Keep other party members alive.
  3. Light DPS only when group is stable.

## 2.2 Tuning Aura (Global Clamp)

Each merc healer has a passive aura applied on spawn:

**Aura: `Mercenary Healer Tuning`**

Effects (initial tuning values, configurable):

- Healing done: **–25%**
- Damage done: **–50%**
- Max mana: **+20%** (to offset reduced raw output and keep them functional over a dungeon run)
- Movement speed: +0–5% (QoL to follow party, optional)
- Critical heal chance: clamped to reasonable range (e.g. 10–15%)

These values are stored in:

- `mortal_feature_flags`:
  - `merc_heal_mult` (default 0.75)
  - `merc_damage_mult` (default 0.5)
  - `merc_mana_mult` (default 1.2)

---

# 3. Archetype 1 – Sanctified Cleric (Disc Priest Style)

## 3.1 Lore & Naming

**Lore Name:** Sanctified Cleric of the Dawn Chapel  
**Internal Template:** `MERC_CLERIC_DISC` (Priest-based bot)

Description:

> A battle-hardened cleric from the Dawn Chapel, specializing in protective wards and direct restorative miracles.

## 3.2 Spell Loadout by Tier

### Tier 1 Dungeons (RFC / Deadmines / Wailing Caverns etc.)

Core spells:

- Power Word: Shield (Rank appropriate) – **limited use**
- Flash Heal
- Renew
- Lesser Heal / Heal (depending on config)
- Dispel Magic (friendly) / Cure Disease

Behavior:

- Keeps PW:Shield on tank when the shield is not active and tank HP < X%.
- Uses Flash Heal on tank or lowest HP party member when < 50–60%.
- Keeps Renew on tank during sustained damage.
- Uses cleanse when target has a relevant debuff and HP situation allows.

### Tier 2 Dungeons (SM / ZF / Uldaman / Maraudon / BRD etc.)

Additions:

- Prayer of Healing (limited radius, on **cooldown** logic only)
- Improved PW:Shield frequency (but still limited)
- Prayer of Mending (optional, low frequency)

Behavior tweaks:

- Uses Prayer of Healing only when:
  - 3+ party members are below 60% HP.
  - Combat script indicates “AoE damage event” (if detectable).
- Keeps Prayer of Mending bouncing on tank if available.

### Tier 3+ Dungeons (Scholo / Strath / LBRS / UBRS / TBC/WotLK 5-mans)

Additions:

- Stronger ranks of core spells.
- Better-cadenced usage of Prayer of Mending + PW:Shield.
- Optional: One long-CD “big heal” (e.g., Greater Heal) for emergencies.

Still **no**:

- Power Infusion
- Hot-swap DPS rotations
- Excessive cooldown chaining

---

# 4. Archetype 2 – Grove Warden (Resto Druid Style)

## 4.1 Lore & Naming

**Lore Name:** Grove Warden of the Emerald Order  
**Internal Template:** `MERC_DRUID_RESTO` (Druid-based bot)

Description:

> A wandering healer from the hidden groves, calling on nature’s cycles to mend wounds and sustain life.

## 4.2 Spell Loadout by Tier

### Tier 1 Dungeons

Core spells:

- Rejuvenation
- Regrowth
- Healing Touch (as backup big heal)
- Remove Curse / Abolish Poison (if relevant to region)

Behavior:

- Keeps Rejuvenation on tank.
- Uses Regrowth on targets dipping below ~60–70%.
- Uses Healing Touch rarely, only when target is in danger (<40–45%).

### Tier 2 Dungeons

Additions:

- Lifebloom (if enabled) – maintained primarily on tank.
- Nature’s Swiftness + Healing Touch (emergency combo).
- Slightly increased use of Regrowth on multiple targets.

Behavior tweaks:

- Maintains Lifebloom stack on tank when available and mana permits.
- Uses Nature’s Swiftness + Healing Touch only in near-death cases.

### Tier 3+ Dungeons

Additions:

- Wild Growth (if allowed) – used sparingly:
  - Only when 3+ party members below 70%.
  - On an internal cooldown to avoid spam.
- Improved HoT management (Lifebloom+Rejuv+Regrowth layering on tank).

Still **no**:

- Full DPS rotation (e.g., Wrath spam).
- Heavy form-shifting DPS behavior.

---

# 5. Archetype 3 – Stormcaller Shaman (Resto Shaman Style)

## 5.1 Lore & Naming

**Lore Name:** Stormcaller of the Tempest Lodge  
**Internal Template:** `MERC_SHAMAN_RESTO` (Shaman-based bot)

Description:

> A storm-priest who calls the elements to wash away wounds and strengthen the group.

## 5.2 Spell Loadout by Tier

### Tier 1 Dungeons

Core spells:

- Healing Wave
- Lesser Healing Wave (fast but less efficient)
- Earth Shield (if enabled for tank)
- Cure Poison / Cure Disease (region-based)
- One basic totem set:
  - Healing Stream Totem
  - Stoneskin Totem or similar defensive totem

Behavior:

- Maintains Earth Shield on tank if allowed.
- Uses Healing Wave on consistent damage.
- Uses Lesser Healing Wave when tank dips below ~40–50%.
- Drops Healing Stream Totem early in the fight.

### Tier 2 Dungeons

Additions:

- Chain Heal – **limited usage**:
  - Only when 3+ targets below 60% HP.
- Mana Spring Totem (optional, if you want to support mana economy a bit).
- Tremor Totem in fear-heavy dungeons.

Behavior tweaks:

- Uses Chain Heal as primary group heal when AoE damage is detected.
- Rotates between Healing Wave and Chain Heal depending on number of wounded allies.

### Tier 3+ Dungeons

Additions:

- Improved totem rotations (e.g., swapping to Fire Resist Totem in specific encounters).
- Stronger ranks of Chain Heal and Healing Wave.

Still **no**:

- Heavy DPS (Lightning Bolt/Chain Lightning) unless:
  - Group is completely stable for an extended period.

---

# 6. Hiring Options & UI Presentation

From the player’s perspective, in the Mercenary Broker UI (AIO or gossip):

- **Sanctified Cleric** (Dawn Chapel)
  - Tagline: “Protective wards and direct heals. Best for dangerous boss spikes.”
- **Grove Warden** (Emerald Order)
  - Tagline: “Nature-based healing over time. Best for consistent damage and experienced groups.”
- **Stormcaller Shaman** (Tempest Lodge)
  - Tagline: “Totems and chain heals. Best when the whole group is taking damage.”

Each listing shows:

- Recommended **party size** (e.g., 2–4 players).
- Recommended **dungeon tier** (I/II/III).
- Gold **cost** per tier.

Example cost scaling (base suggestions, overridable by config):

- Tier 1:
  - Cleric: 75g
  - Grove Warden: 75g
  - Stormcaller: 75g
- Tier 2:
  - 250g each
- Tier 3:
  - 600–800g each

Final amounts are controlled in `mortal_merc_templates.base_wage` or `mortal_feature_flags`.

**Note:** This spec references the old mod-playerbots approach. The current implementation uses custom creatures per `29-companion-bond-and-mercenary-system.md`. Merc templates are defined in `mortal_merc_templates` table (see `30-db-migrations-mortal-core.md`).

---

# 7. Integration with Mortal Systems

## 7.1 Restoration Magic (Players vs Mercs)

- Players:
  - Use the **Mortal Restoration** spell line defined in `22-healing-and-restoration.md`.
  - Unlock spells via books and skill thresholds.
- Mercs:
  - Use **legacy class healing spells** internally.
  - Do not expose those spellbooks to players, at least initially.

This preserves:

- The **classless Mortal fantasy** for players.
- The **robust behavior** of proven healer kits for NPC mercs.

## 7.2 Zone & Content Rules

As specified in `23-mercenary-healers.md`:

- Merc healer archetypes are:
  - Allowed in **5-man dungeons** by default.
  - Potentially allowed (later) in some raids and Yellow-zone delves.
  - Disallowed in:
    - Red zones (open-world full loot).
    - Hellgates.
    - Warfronts/BGs/arenas.

## 7.3 Scaling with Mortal Stat Squish

To keep mercs relevant but not dominant as you finalize Mortal’s stat squish:

- Maintain separate tuning profiles per tier:
  - `merc_heal_mult_tier1`
  - `merc_heal_mult_tier2`
  - `merc_heal_mult_tier3`
- Adjust their:
  - Spell ranks
  - Mana pool
  - Aura modifiers

Based on test runs with typical Mortal-geared parties.

---

# 8. Implementation Notes

## 8.1 Mercenary Templates

**Note:** This section needs updating to reflect the custom creature approach. Current implementation:

- Define mercenary templates in `mortal_merc_templates` table:
  - `MERC_CLERIC_DISC` (healer role, M-T2/M-T3 gear tier)
  - `MERC_DRUID_RESTO` (healer role, M-T2/M-T3 gear tier)
  - `MERC_SHAMAN_RESTO` (healer role, M-T2/M-T3 gear tier)
- Each template references a `creature_template.entry` (600000-609999 range per `31-mortal-core-registry.md`)
- Creature templates should have:
  - Appropriate base stats for tier.
  - Restricted spell list per this document.
  - Custom AI script for healer behavior.

## 8.2 Lua/C++ Spawn Hooks

In `merc_healer_system.lua` or C++:

- When player selects archetype:
  - Determine dungeon tier.
  - Look up appropriate merc template from `mortal_merc_templates`.
  - Spawn creature from `creature_template` entry.
  - Apply `Mercenary Healer Tuning` aura and tier-specific modifiers.
  - Create entry in `mortal_merc_contracts`.

**See:** `29-companion-bond-and-mercenary-system.md` for full mercenary system design.

---

# 9. Status

This file is the **authoritative archetype spec** for Mercenary Healers:

- It defines:
  - Three core healer types.
  - Spell loadouts per dungeon tier.
  - Behavioral expectations.
  - Tuning strategy and lore presentation layer.
- It should be used by:
  - Creators of mercenary creature templates.
  - The author of `merc_healer_system.lua` / C++ merc AI scripts.
  - AIO/MortalUI implementers building the Merc Broker panel.

**Note:** This spec needs updating to fully align with the custom creature approach defined in `29-companion-bond-and-mercenary-system.md`.

