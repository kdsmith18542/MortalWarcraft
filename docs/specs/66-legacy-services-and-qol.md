# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Legacy Systems & QoL  
### File: 66-legacy-services-and-qol.md  
### Section: Legacy Services, Travel, Respec & QoL in a Mortal Sandbox

---

## 1. Purpose

Define how core **WotLK “service” systems** (hearthstones, summoning, portals, flight, barbershop, respec, etc.) are:

- **Kept, removed, or redesigned** to fit Mortal Warcraft’s:
  - Full-loot, regional-economy sandbox,
  - Travel & logistics focus,
  - Risk zoning (Green/Yellow/Red),
  - Social & faction-driven gameplay.

We want:

- Enough convenience to maintain **player retention and social play**,  
- But not so much that we **invalidate caravans, Strongholds, Shrines, or the regional economy**.  

---

## Related Specs

For full context on legacy services and QoL systems, see:

- **`13-caravans-contracts.md`** — Caravan system that travel restrictions support
- **`08-guilds-sovereignty.md`** — Stronghold system that travel restrictions support
- **`59-shrine-and-faction-trials.md`** — Shrine system where Shrine Marks bind
- **`04-economy.md`** — Economy system that travel costs feed into
- **`03-risk-zones.md`** — Risk zones that affect travel restrictions
- **`01-progression.md`** — Progression system for respec costs and rules
- **`64-spell-and-ability-library.md`** — Spell library that includes teleport abilities

---

## 2. Travel & Teleportation

### 2.1 Hearthstone → “Shrine Mark”

Original:

- Hearthstone → free recall to a single Inn, 30–60 min CD.

Mortal version:

- **Shrine Mark (Recast Hearthstone):**
  - Bound to a **Shrine or Inn** (not any random location).
  - **Cooldown:** significantly longer than original (e.g. 90–120 minutes).
  - **Restrictions:**
    - Cannot be used:
      - While in combat,  
      - While carrying certain “heavy” Cursed Artifacts,
      - Inside some instanced content (Hellgates, Trials).
  - **Lore:**
    - Uses Shrine/Ether tether to “snap” you back to a safe anchor.

Design intent:

- Keep “go home” utility,
- Avoid trivializing:
  - Caravans,
  - Frontier travel,
  - Stronghold logistics.

### 2.2 Portals & Mage Teleports

Original:

- Capital portals, mage portals and teleports for fast continent travel.

Mortal version:

- **City Portals (Static):**
  - Restricted to:
    - Major green/yellow hubs (not Red zones),
    - Used mainly to:
      - Move between **core capital regions**.
  - **Cost:**
    - Gold and/or special reagents,
    - Higher cost when carrying significant cargo (heavy bags).
  - **No portals directly into:**
    - Red Zones,
    - Strongholds,
    - Warfronts,
    - Lost Lands.

- **Mage Portals/Teleports:**
  - Retained as **rare abilities** (Runes or Learned Skills),
  - Added costs:
    - Reagents,
    - Focused cooldowns,
    - Possibly **debuffs** after use (e.g. “Ether-Sick”: reduced resistances for a short period).

Design intent:

- Portals as **strategic tools**, not “spam to everywhere”.

### 2.3 Summoning Stones & Group Summon

Original:

- Meeting stones and warlock summons can teleport party members to dungeons/raids.

Mortal version:

- **Summoning Stones (Recast as Ritual Obelisks):**
  - Present near some dungeon/raid entrances,
  - Require:
    - Local materials or reagents,
    - A small group channel time.
  - **Restriction:**
    - Only summon players within the same region (no cross-continent abuse),
    - Cannot summon into Red Zones from Green Zones (must be physically near frontier).

- **Cartel Rituals (Premium Smuggler Summons):**
  - Black Sun Cartel:
    - Offers expensive “shadow summons”:
      - E.g. from a Cartel hub to a nearby contraband route.
  - High cost, limited use, traceable (Notoriety hooks possible).

Design intent:

- Keep grouping convenience,
- But not undermine **logistics, travel risk, or regionality**.

### 2.4 Flight Paths & Mount Flight

Original:

- Extensive flight path network & flying mounts.

Mortal version:

- **Flight Paths:**
  - Restrict or remove in:
    - Red Zones,
    - Lost Lands,
    - Stronghold-contested territories.
  - In Green/Yellow:
    - Retain as:
      - Medium-cost fast travel between safe hubs,
      - Potentially vulnerable to events (e.g. Midnight Horde can “ground” flights temporarily).

- **Flying Mounts:**
  - Disabled in Red Zones and Lost Lands (as previously specced),
  - In safe zones:
    - Allowed for convenience, but:
      - Mounts still obey hunger/durability rules,
      - Some economically important routes remain ground-only.

Design intent:

- Use flight for **safe hub-to-hub travel**,
- Keep **frontier travel meaningful and risky**.

---

## 3. Character Customization & Identity

### 3.1 Barbershop & Visual Customization

Original:

- Barbershops change hair, some minor features for gold.

Mortal version:

- **Barbershop:**
  - Retained as:
    - Purely cosmetic appearance service,
    - Costs gold, possibly minor Cartel or Ledger flavor involvement.
  - No gameplay effect.

Optional extension:

- Allow:
  - **Tattoo/scar layers** tied to:
    - Weapon Legacy milestones,
    - Faction standing,
    - Shrine Trials.
  - Mechanically:
    - Just additional appearance flags toggled at barbershop after unlock.

### 3.2 Race, Backgrounds & Racial Passives

Original:

- Racial abilities with gameplay impact.

Mortal version (we already defined):

- **Backgrounds instead of racials**, granting:
  - Starting skills,
  - Minor flavor perks (e.g. slightly better prices in certain regions, small starting proficiencies),  
  - No hard “this race is strict meta pick” scenarios.

Barbershop:

- Does **not** change background; it only modifies visual appearance.

---

## 4. Respec, Loadouts & Dual Spec

### 4.1 Early Mentor Respec

Already specced:

- **Mentor NPCs** in Green Zones:
  - Offer **free or very cheap respecs** up to:
    - ~200 total skill points (approx Level 4 by dynamic level),
  - Teaching builds:
    - How to experiment without penalty.

### 4.2 Mid/Late Game Respec Costs

Instead of WoW’s **dual spec system**:

- We use:
  - **Loadout Slots** + **Respec Services**.

#### Loadouts:

- Characters have:
  - A limited number of saved build configurations:
    - e.g. 2 default, more purchasable with gold or as rewards.
  - Each loadout stores:
    - Attribute distribution,
    - Skill/spell selection,
    - Mastery choices,
    - Preferred hotbars.

#### Respec Rules:

- **Full Respec:**
  - Reset attributes, skills, Mastery points.
  - Cost:
    - Scales with:
      - Total skill points,
      - Character wealth,
      - Optional Faction standing discounts.
  - Performed at:
    - Mentor-type NPCs in major hubs,
    - Some Faction Sanctums (with faction-specific flavor & price modifiers).

- **Partial Respec:**
  - Change Mastery tree only,
  - Or swap a limited set of skills/runes.
  - Lower cost and shorter cooldown.

- **Convenience Shop Item:**
  - As designed:
    - **Respec Tokens** exist as monetized convenience,
    - But core respec remains doable with in-game gold & effort.

Design intent:

- Enable experimentation and role shifting,
- Keep choices meaningful (respec is not zero-cost spam),
- Avoid “free mid-fight spec swap” abuse.

---

## 5. Mail, Banks & Auction House

These systems are already heavily modified, but we summarize them here from a **services/QoL angle**.

### 5.1 Mail

Original:

- Universal, instant/near-instant delivery anywhere,
- Often used as extra bank or pseudo-teleport for items.

Mortal version:

- **Mail for letters & light items only:**
  - Gold and light documents (contracts, notes) allowed,
  - **No heavy materials or gear** via standard mail.
- For physical items:
  - Use:
    - Regional Banks,
    - Courier Contracts,
    - Caravans.

Design intent:

- Preserve communication & small-scale logistics,
- Prevent mail from bypassing the **regional economy & travel risk**.

### 5.2 Banks

Already specced:

- **Regional Banking:**
  - Stormwind bank != Ironforge bank,
  - Items stored are bound to that city’s bank,
  - Atlas & UI can show holdings per region.

QoL:

- Allow players to:
  - Pay a **transfer fee** via:
    - Courier Contracts (NPC or player-run),
    - Faction services:
      - Ledger: premium secure transfers,
      - Cartel: risky but cheaper shadow moves.

### 5.3 Auction House → Market Stalls & Contracts

Previously specced:

- Auction House is:
  - Replaced by:
    - **Physical Market Stalls** (player vendors),
    - **Regional price visibility** (Atlas, MortalMap),
    - EVE-like market network:
      - Global visibility of listings,
      - Location-bound pickup.

QoL additions:

- Atlas/Market UI:
  - Allow:
    - Search & filter by region,
    - “Create contract” button to hire others to move items.
- In-game:
  - Add a **“Market Ledger”** UI item that:
    - Summarizes personal buy/sell orders,
    - Can be inspected in any major hub.

---

## 6. LFG, RDF, RBG & Social Tools

We already decided:

- No **teleporting RDF/RBG** that trivializes travel & risk,
- We **do** want some tooling for social play & grouping.

### 6.1 Group Finder (Non-Teleporting)

Design:

- A **“Bulletin Board” / Group Finder** UI:
  - Accessible at:
    - Inns,
    - Capital cities,
    - Atlas (web portal).
  - Features:
    - LFM listings for dungeons/raids/Warfronts/Hellgates,
    - Filters by:
      - Role (Damage / Support / Tank / Utility),
      - Risk tier,
      - Activity type.

Rules:

- Does **not** teleport:
  - Players still must:
    - Travel or be summoned via Ritual Obelisks / Cartel rituals.
- Integrates with:
  - Discord Killfeed/alerts (optional),
  - Guild & friend lists.

### 6.2 Battleground Queues

We redesigned:

- **Warfronts** as:
  - Physical-entry battlefields,
  - With dedicated open times/windows.

Queue rules:

- Players:
  - Physically travel to Warfront entry point,
  - Sign up at the portal/war camp,
  - Enter when match is ready.
- No global instant pop that teleports you from anywhere.

---

## 7. Minor Legacy Systems

### 7.1 Calendar & Events

Original:

- In-game calendar for raids/events/holidays.

Mortal version:

- Keep **Calendar UI** but:
  - Hook it to:
    - Frontier Scheduler (from 65-endgame-rhythm-and-lockouts),
    - Seasonal events,
    - Warfront windows,
    - Stronghold vulnerability windows.

Players can:

- Create personal/guild events as usual.

### 7.2 Achievements

Already specced:

- Achievements are:
  - Largely redefined to:
    - Reflect Mortal systems (Rifts, Frontier, Strongholds, Factions),
    - Provide titles & cosmetics, not raw power.

Legacy achievements:

- Kept as:
  - Cosmetic/legacy trackers where they don’t clash.

### 7.3 Glyphs, Inscription & Old Talent Dependencies

Original:

- Glyph system modifies spells,
- Some systems depend on “you are this class.”

Mortal version:

- **Glyphs → Runes/Augments:**
  - Glyph effects:
    - Folded into:
      - Rune variants,
      - Augment slots,
      - Mastery passives.
- Inscription:
  - Profession becomes:
    - A key producer of:
      - Runes,
      - Appearance sigils,
      - Contract scrolls,
      - Frontier permits (lore-appropriate items).

---

## 8. Design Rules Summary

To keep all legacy QoL in line with Mortal:

1. **No service may completely bypass:**
   - Regional banking,
   - Travel risk in Red/Frontier zones,
   - Full-loot nature of combat.

2. **Every convenience has a cost and/or restriction:**
   - Shrines cost risk (full-loot),
   - Summons require reagents and local presence,
   - Portals avoid Red Zones and can’t directly move heavy cargo “for free”.

3. **Social & identity services stay generous:**
   - Barbershop, calendar, guild tools:
     - Mostly kept and possibly improved.

4. **Experimentation is supported, not trivialized:**
   - Respecs are:
     - Cheap early,
     - Reasonable but not free later,
     - Supported by loadouts & Mentor/Faction services.

---

## 9. Implementation Checklist

1. **Disable / Restrict Teleports & RDF/RBG:**
   - Turn off or repurpose:
     - Random Dungeon Finder,
     - Random Battleground teleport queues,
     - Old “teleport to instance” helpers.

2. **Implement Shrines & Travel Rules:**
   - Update Hearthstone to Shrine Mark behavior,
   - Enforce flight/flying restrictions by zone.

3. **Rewire Mail & Bank Behavior:**
   - Block heavy items from standard mail,
   - Confirm Regional Bank separation & Courier contract paths.

4. **Add Group Finder / Bulletin UI (Non-Teleporting):**
   - In MortalUI as:
     - “Frontier Bulletin” panel.

5. **Wire Legacy UI to Frontier Scheduler:**
   - Calendar integration,
   - Atlas & MortalUI event readout.

6. **Convert Glyphs/Inscription to Rune/Augment Outputs:**
   - Using rules from Spell/Ability Library (64-spell-and-ability-library.md).

This spec should be used whenever you encounter a **legacy WoW convenience feature** and need to decide whether it belongs in Mortal Warcraft, and if so, in what altered form.
