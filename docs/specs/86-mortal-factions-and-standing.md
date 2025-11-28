# Project Canvas: Mortal Warcraft Overhaul  
### File: 86-mortal-factions-and-standing.md  
### Topic: Factions, Standing, and How They Drive the Sandbox (C++-First)

> This document defines Mortal’s **core factions**, their **standing tracks**, and how those values plug into:  
> guards, taxes, banking, markets, shrines, justice, and events.  
>  
> Implementation bias: **C++ modules first**, Lua only for content scripting & quest glue.

---

## 1. Design Goals

1. Replace vanilla WoW’s reputation web with a **unified Mortal Standing Layer** that feels:
   - EVE-like (corporations, standings),
   - RuneScape-like (skilling & reputation payoffs),
   - Fits Mortal’s full-loot, regional economy.

2. Make **Standing matter** to:
   - Guards & law enforcement,
   - Taxes & tariffs,
   - Access to Task Boards & Contracts,
   - Access to recipes, blueprints, and Runes,
   - Insurance & Black Market behavior.

3. Keep the system:
   - **Numerically simple** (0–100 or -100–100),
   - **Centrally managed** in C++ with a DB backing table,
   - **Scriptable** from quests / events without reimplementing logic in Lua.

---

## Related Specs

For full context on faction and standing systems, see:

- **`51-factions-and-standing-system.md`** — Extended faction system and faction roster
- **`59-shrine-and-faction-trials.md`** — Shrine systems and faction trials that affect standing
- **`60-faction-sanctums.md`** — Faction sanctums and headquarters
- **`99-mortal-faction-meta-civic-frontier-cartel-atlas.md`** — Major faction definitions and meta
- **`76-dynamic-tasks-and-contracts-2-0-spec.md`** — Contracts and task boards tagged with factions
- **`04-economy.md`** — Economy system for faction taxes, market fees, and banking
- **`03-risk-zones.md`** — Risk zones where faction standing affects guard behavior

---

## 2. Core Standing Model

### 2.1 Data Model

Table: `mortal_standing`

```sql
CREATE TABLE IF NOT EXISTS mortal_standing (
    guid INT UNSIGNED NOT NULL,          -- character GUID
    faction_id INT NOT NULL,             -- Mortal faction identifier
    standing INT NOT NULL DEFAULT 0,     -- -100 to +100
    PRIMARY KEY (guid, faction_id)
);
```

- **Standing Range:** `-100` (hated) → `0` (neutral) → `+100` (exalted).
- Faction IDs are defined in a C++ enum or config header, and duplicated in a data table.

Table: `mortal_factions`

```sql
CREATE TABLE IF NOT EXISTS mortal_factions (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    type TINYINT NOT NULL,              -- 0=system,1=civic,2=economic,3=religious,4=underworld,5=guild-meta
    description TEXT
);
```

### 2.2 C++ Access API

Create `MortalStanding` module:

```cpp
class MortalStanding
{
public:
    static int32 GetStanding(Player* player, MortalFaction faction);
    static void  AddStanding(Player* player, MortalFaction faction, int32 delta);
    static void  SetStanding(Player* player, MortalFaction faction, int32 value);

    static float GetTaxModifier(Player* player, MortalFaction faction);
    static float GetGuardResponseModifier(Player* player);
    static float GetInsuranceMultiplier(Player* player);
    static float GetMarketFeeModifier(Player* player);

    // Convenience: wrappers for Civic, Cartel, Shrine, etc
};
```

Lua and quest scripts should **only call these C++ APIs** when adjusting standing.

---

## 3. Mortal Faction List (Top-Level)

We define a **small set of foundational factions** that matter sandbox-wide:

1. **Civic Authority (City-States)**
   - Per major city: `CIVIC_STORMWIND`, `CIVIC_IRONFORGE`, etc.
   - Governs: guard behavior, local taxes, safe banking, local policing.

2. **Shrine Orders**
   - Global spiritual factions tied to Shrines across the world.
   - Governs: access to Shrine blessings, flasks/rituals, Warden gear/runes.

**Shrine Order Faction IDs:**
- `SHRINE_ORDER_DAWN` - Order of the Dawn (Light/Protection focused)
- `SHRINE_ORDER_DUSK` - Order of the Dusk (Shadow/Balance focused)
- `SHRINE_ORDER_VEIL` - Order of the Veil (Arcane/Mystery focused)
- `SHRINE_ORDER_ANVIL` - Order of the Anvil (Crafting/Blessing focused, optional)

**Naming Rationale:**
- **Dawn**: Represents light, protection, healing - aligned with defensive/healing playstyles
- **Dusk**: Represents shadow, balance, transition - aligned with balanced/versatile builds
- **Veil**: Represents arcane, mystery, knowledge - aligned with magic/spellcasting builds
- **Anvil**: Represents crafting, blessing, industry - optional order for crafters (can be added later)

**Implementation Notes:**
- Each Shrine location can be aligned with one primary Order
- Players can gain standing with multiple Orders simultaneously
- Standing with one Order does not penalize standing with others
- Orders are global (not region-specific) for consistency

3. **Cartel / Black Market Syndicates**
   - Global underworld faction: `CARTEL_SYNDICATE`.
   - Optional sub-factions for regional cartels later.
   - Governs: Black Market access, fences, illicit Contracts, laundering rates.

4. **Frontier Militia / Stronghold League**
   - `FRONTIER_MILITIA`.
   - Governs: access to frontier Contracts, Stronghold defense Contracts, Warfront support.

5. **Atlas Consortium**
   - `ATLAS_CONSORTIUM`.
   - Governs: access to higher-tier Atlas intel, map overlays, advanced scouting Contracts.

6. **Guild Sovereignty (Per-Guild Faction)**
   - Dynamic: each guild has an implicit faction ID and standing vs each player.
   - Governs: taxes on members, use of guild Strongholds, friendly access to controlled territory.

> Note: WoW’s original rep factions become **cosmetic / lore** or are repurposed behind the scenes, but **mechanical decisions** use these Mortal factions.

---

## 4. Standing Effects by Faction

### 4.1 Civic Authority (Cities & Guards)

**Faction IDs:**

- `CIVIC_STORMWIND`, `CIVIC_IRONFORGE`, `CIVIC_DARNASSUS`, etc.
- Future: add for Horde cities as needed or merge by continent.

**Standing Effects:**

1. **Guards**
   - `standing >= +50` (Trusted Citizen):
     - Guards prioritize defending you in local scuffles.
     - Faster guard reaction time when you are attacked.
   - `standing <= -50` (Known Troublemaker):
     - Guards respond more aggressively if you cause trouble.
     - You might be denied certain city services (e.g. some Task Boards).

2. **Taxes & Fees**
   - Base **sales tax** and **Auction House cut** are modified by civic standing:
     - `TaxMultiplier = 1.0 - (standing / 200.0)` clamped to sensible range.
     - Example:
       - +100 standing → -0.5 (i.e. up to 50% discount cap).
       - -100 standing → +0.5 (up to 50% extra tax cap).

3. **Banking**
   - Civic standing may:
     - Unlock extra **regional bank slots**.
     - Reduce fees for safe deposit transactions.
     - Affect your **insurance multiplier** if insurance is civic-backed (see below).

4. **Task Boards**
   - Some civic boards (Militia, Town Warden) may require minimum Civic Standing:
     - “Civic Standing (Stormwind) >= 20 to accept City Guard auxiliary Contracts.”

Implementation: C++ functions called from guard AI, market code, and bank handlers.

---

### 4.2 Shrine Orders

**Faction IDs:**

- `SHRINE_ORDER_DAWN` - Order of the Dawn
- `SHRINE_ORDER_DUSK` - Order of the Dusk
- `SHRINE_ORDER_VEIL` - Order of the Veil
- `SHRINE_ORDER_ANVIL` - Order of the Anvil (optional, for crafting-focused players)

**Order Themes:**
- **Dawn**: Light, protection, healing, defensive magic
- **Dusk**: Shadow, balance, transition, versatile magic
- **Veil**: Arcane, mystery, knowledge, offensive magic
- **Anvil**: Crafting, blessing, industry, material mastery

Core mechanic: **Shrine Favour** is a standing track that unlocks shrine services and rewards.

**Standing Effects:**

1. **Flask & Healing Efficiency**
   - Better Shrine standing:
     - Faster flask recharge at Shrines/Inn,
     - Slightly higher healing from Shrine-based rituals.

2. **Blessings & Curses**
   - High standing unlocks:
     - Unique Shrine blessings (buffs),
     - Access to Shrine-focused Runes (e.g. Shared Burden, Ether Aegis).
   - Very low standing:
     - Increased Ether corruption risk,
     - Possible penalties when using Shrine services (higher fee, weaker effect).

3. **Warden Gear & Task Boards**
   - Certain **Sanctum Warden** Contracts and gear require minimum Shrine standing:
     - E.g. `Shrine Standing >= 40` to unlock T2 Warden gear blueprint.

Implementation: C++ checks in Shrine interaction handlers and reward scripts; Lua quests call `AddStanding(player, SHRINE_ORDER_X, delta)`.

---

### 4.3 Cartel / Black Market Syndicates

**Faction ID:**

- `CARTEL_SYNDICATE` (with possible regional subfactions later).

**Standing Effects:**

1. **Black Market Access**
   - Minimum standing required to:
     - See high-tier illicit listings.
     - Fence stolen goods at good rates.

2. **Fence Rates & Laundering**
   - Standing modifies the payout for stolen or illicit items:
     - `Payout = BaseValue * (1.0 + standing / 200.0)`
   - Negative standing → lowball offers or outright refusal.

3. **Illegal Contracts**
   - Some Contracts (assassinations, smuggling, contraband hauling) require:
     - Minimum Cartel Standing to accept.
   - Higher standing increases **Contract density** and **payout multipliers**.

4. **Guard & Civic Interaction**
   - High Cartel standing might **penalize Civic standing** if certain thresholds are reached:
     - Cross-faction negative coupling:
       - e.g. Each time you increase Cartel Standing via certain actions, Civic Standing can be nudged down.

Implementation: C++ market & Contract handlers apply modifiers based on Cartel standing. Any time a “Fence” NPC is used, `MortalStanding::GetStanding` is consulted.

---

### 4.4 Frontier Militia / Stronghold League

**Faction ID:**

- `FRONTIER_MILITIA`.

**Standing Effects:**

1. **Stronghold Contracts**
   - Defense and counter-raid Contracts require minimum standing.
   - Better standing → more access to **siege tech**, resource shipments, and unique gear.

2. **Warfront & Siege Rewards**
   - Bonus payouts for Warfront participation and Stronghold defense if:
     - `Standing >= threshold`.

3. **Local Defense Priority**
   - In frontier hubs, Militia-aligned guards may:
     - Favor you in chaotic fights (healing, CC on enemies).

Implementation: C++ event reward handlers read standing and adjust payouts.

---

### 4.5 Atlas Consortium

**Faction ID:**

- `ATLAS_CONSORTIUM`.

**Standing Effects:**

1. **Intel Quality**
   - Higher standing unlocks:
     - Better, more granular heatmaps.
     - Access to near-live killfeed details (gear value, guild tags).
     - Access to anomaly/Rift spawn predictions.

2. **Explorer Contracts**
   - Map-making, surveying, anomaly scanning Contracts require minimum Atlas standing.
   - Higher standing boosts payouts and unlocks unique explorer gear/Runes.

Implementation: Atlas web API server reads consortium standing to determine API response detail; in-game Explorer Task Boards check it for contract offering.

---

### 4.6 Guild Sovereignty (Per-Guild Standing)

Each guild has:

- An implicit **faction** representing its relationship to each character:
  - `GUILD_STANDING_NEUTRAL = 0`
  - `GUILD_STANDING_MEMBER = +50`
  - `GUILD_STANDING_ALLY = +25`
  - `GUILD_STANDING_ENEMY = -50`

Standing effects:

1. **Territory Access**
   - If a guild controls a Stronghold or zone, its standing vs you:
     - Determines whether guards/NPCs around that Stronghold treat you as:
       - Friendly, neutral, or hostile.
     - Determines whether you can:
       - Use crafting stations,
       - Use local banks or markets in that Stronghold.

2. **Taxes**
   - Guilds can apply a tax rate on:
     - Loot,
     - Contracts run in their territory,
     - Or members’ incomes.
   - Member and ally players pay less tax vs neutrals operating inside their borders.

3. **War Status**
   - Guild Wars toggle whether:
     - You’re considered a valid target anywhere without Notoriety gain.
   - Standing can be adjusted automatically based on war/peace/alliance status.

Implementation: C++ guild & Stronghold modules maintain these values, separate from `mortal_standing` but conceptually similar.

---

## 5. Standing Sources & Sinks

Standing must be **earned and lost** in clear, predictable ways.

### 5.1 Common Gain Sources

- Completing Contracts from specific Task Boards:
  - Civic boards → Civic Standing up.
  - Shrine boards → Shrine Favour up.
  - Cartel contracts → Cartel Standing up (Civic maybe down).
  - Atlas tasks → Atlas Standing up.
  - Frontier defense/offense → Frontier Standing up.

- Participating in events:
  - Defending Shrines → Shrine Standing up.
  - Defending Strongholds → Frontier / Guild standing up.
  - Warfront victories → Frontier Standing up.

- Donations / tithes:
  - Donating gold/materials at Shrines or civic offices can give small standing gains with caps/time limits.

### 5.2 Common Loss Sources

- Crimes & criminal actions:
  - Killing innocents in Yellow Zones:
    - Civic Standing down,
    - Possibly Shrine Favour down (if in holy areas).
  - Smuggling / Black Market work:
    - Cartel up, Civic down.

- Dereliction:
  - Failing certain time-bound defensive Contracts might:
    - Slightly reduce relevant standing (Civic or Frontier).

- Betrayal actions (future):
  - Breaking certain oaths/contracts might cost standing heavily.

All changes should flow through `MortalStanding::AddStanding` to ensure clamping and cross-coupling logic are applied consistently.

---

## 6. Guard & Law Integration

A central piece: **guards should use standing and Notoriety** together.

C++ guard AI checks:

- Player’s **Notoriety** (short-term criminal flag system).
- Player’s **Civic Standing** (long-term reputation).
- Player’s **Guild Standing** vs territory owner.

Behavior examples:

- High Civic Standing, low Notoriety:
  - Guards respond quickly to assist when attacked.
  - Guards ignore minor infractions.

- Low Civic Standing, high Notoriety:
  - Guards prioritize attacking the player.
  - May treat player as “Kill on Sight” in some cities.

Standing therefore becomes the **long-term axis** complementing Notoriety’s short-term crime status.

---

## 7. Economy & Insurance Integration

Standing also feeds economy systems:

- **Civic Standing**
  - Modifies city taxes, market fees.
  - Influences access to civic insurance / Soul Insurance tiers.

- **Cartel Standing**
  - Modifies Black Market fencing payouts.
  - Alters risk of betrayal in some underworld Contracts (future).

- **Frontier Standing**
  - Influences payout multipliers for frontier Contracts.
  - Determines access to heavy siege tech blueprints.

- **Atlas Standing**
  - Controls access to high-tier intel and anomaly predictions.

All of these are **C++-side multipliers** used when calculating:

- Market fees,
- Contract payouts,
- Insurance payouts,
- Event rewards.

---

## 8. Implementation Plan

1. **Create DB tables**: `mortal_factions`, `mortal_standing`.
2. **Define faction enum** in C++ header (`MortalFaction.h`).
3. **Implement `MortalStanding`**:
   - Load/save standing records,
   - Provide clamped `Get/Set/Add` functions,
   - Provide helper multipliers for:
     - Tax, guard, market, insurance.
4. **Integrate with:**
   - Guard AI (Civic Standing + Notoriety),
   - Markets (tax & fee modifiers),
   - Banks & Insurance,
   - Task Boards & Contract generators,
   - Atlas API (intel tiers),
   - Shrine interactions (blessings & penalties),
   - Cartel/Black Market vendors.
5. **Expose cheap APIs to Lua** for quest scripts:
   - `MortalStanding.Add(player, factionId, delta)`
   - `MortalStanding.Get(player, factionId)`

---

## 9. Summary

This faction & standing layer is the **bridge** between:

- WoW’s familiar world,
- EVE’s standings, sovereignty, and markets,
- Mortal Online’s justice and full-loot risk,
- RuneScape’s skilling and reputational unlocks.

By centralizing standing in **C++ modules** and wiring it into:

- guards,  
- taxes & markets,  
- banks & insurance,  
- Task Boards & Contracts,  
- Shrines & Black Market,  
- guild sovereignty & Atlas,

we ensure all major systems are talking to the same “social & economic backbone” instead of drifting apart as disconnected mini-games.
