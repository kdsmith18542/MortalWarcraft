# Project Canvas: Mortal Warcraft Overhaul  
### File: 87-mortal-archetype-grid.md  
### Topic: Archetype Grid – “If You Liked X in WoW, Play Y in Mortal”

> This document defines a **small set of clear archetypes** that map classic WoW class fantasies  
> into Mortal’s **classless, rune-driven** build system.  
>  
> Goal: a WoW player can read this and immediately know *what to aim for* in stats, skills, runes, and content.

---

## 1. Design Principles

1. **Classless under the hood, class-flavored at the surface.**
   - No hard classes; archetypes are **suggested build lanes**.
   - Any character can pivot over time by respeccing attributes & swapping runes.

2. **Use familiar language as on-ramps.**
   - “If you enjoyed Fury Warrior / Arms in WoW, look at the **Linebreaker** archetype.”
   - “If you liked Disc Priest / Resto druid, look at the **Sanctum Warden** archetype.”

3. **Tie archetypes to:**
   - **Stat spreads & caps** (STR/AGI/STA/INT/SPI, max 150 per-stat, 400 total).
   - **Weapon/armor skills** and key Mortal skills.
   - **Rune families** (ability kits).
   - **Factions / Standing** (who they naturally align with).
   - **Content loops** (what they actually do moment-to-moment).

4. **Implementation bias:**  
   - Archetypes are **docs + presets**, not new core systems.
   - MortalUI can show **build templates / suggestions** using this grid.
   - No new C++; this document consumes existing systems.

---

## Related Specs

For full context on archetypes, see:

- **`75-mortal-gear-and-runes-spec.md`** — Gear and rune system that archetypes use
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas and attribute caps that archetypes follow
- **`55-build-presets-and-loadouts.md`** — Build presets that can save archetype configurations
- **`77-mortal-itemization-t1-t2-starter-sets.md`** — Starter sets for archetypes
- **`78-mortal-itemization-healer-ranger-mage.md`** — Itemization for specific archetypes
- **`51-factions-and-standing-system.md`** — Faction system that archetypes align with
- **`01-progression.md`** — Progression system that archetypes use

---

## 2. Archetype Overview Table

High-level mapping (for players skimming the wiki):

| Mortal Archetype      | WoW Fantasy Analog                             | Primary Role(s)                  |
|-----------------------|-----------------------------------------------|----------------------------------|
| Linebreaker Vanguard  | Fury/Arms Warrior, Ret Paladin, DK Bruiser    | Frontline bruiser / brawler     |
| Sanctum Warden        | Disc Priest, Resto Druid, Holy Paladin        | Support healer / shrine anchor  |
| Spellfire Magus       | Fire Mage, Destruction Warlock, Elemental     | High-risk ranged caster         |
| Ether Ranger          | Hunter (MM/BM), Survival, Rogue hybrid        | Ranged skirmisher / scout       |
| Cartel Broker         | Goblin rogue/merchant, subtlety spec          | Economic PvP / black marketeer  |
| Frontier Marshal      | Prot Warrior/Paladin, Blood DK (control tank) | Control tank / siege specialist |
| Atlas Pathfinder      | Explorer, loremaster, profession main         | Scout, mapper, anomaly hunter   |
| Riftbound Occultist   | Shadow Priest, Demo lock, arcane hybrid       | Risk wizard / anomaly specialist|

Each archetype below describes:

- Stat focus (example distribution).
- Core skills & gear choices.
- Rune family suggestions.
- Faction/standing synergy.
- Core content loop (solo, group, guild).

---

## 3. Linebreaker Vanguard – “The Frontline Bruiser”

**Fantasy:**  
If you liked **Fury/Arms Warrior** or **Ret Paladin** – charging in, brawling, living in melee.

### 3.1 Stat Profile (Example)

- STR: 130–150
- AGI: 80–100
- STA: 120–140
- INT: 40–60
- SPI: 40–60  
*(Respecting 150 per-stat and 400 total cap; these are examples, not enforced presets.)*

### 3.2 Skills & Gear

- Weapon Skills:  
  - Sword, Axe, Mace, Polearm → high priority.
- Armor Skills:
  - Plate / Heavy Mail, Shield if going more control.
- Material Lore:
  - Iron/Steel/Thorium Lore for better heavy gear.

### 3.3 Rune Families (Examples)

- **Offense:**
  - Whirlwind, Mortal Strike, Cleaving Blow.
- **Defense:**
  - Brace, Guard Counter, Bulwark runes.
- **Utility:**
  - Gap closers, short sprints, war shouts.

### 3.4 Faction Synergy

- Civic Standing: Often positive (defender archetype).
- Frontier Militia: Natural fit – strong in Stronghold defense/Warfronts.
- Atlas: Secondary – some value scouting, but not primary.

### 3.5 Content Loop

- Solo:
  - Task Boards that involve **bodyguard**, **guard caravan**, **hold the line** style Contracts.
  - Public dungeons as the tip of the spear in small groups.
- Group:
  - Warfronts as frontline bruiser.
  - Cursed Raids as on-foot escort/peel for artifact carriers.
- Guild:
  - Stronghold assault & defense anchor.
  - Leading pushes in Red Zone fights.

---

## 4. Sanctum Warden – “Shrine Healer & Support”

**Fantasy:**  
If you liked **Disc Priest**, **Resto Druid**, **Resto Shaman** – keeping people alive while playing around positioning & buffs.

### 4.1 Stat Profile (Example)

- STR: 30–60
- AGI: 40–70
- STA: 100–130
- INT: 110–140
- SPI: 110–140

### 4.2 Skills & Gear

- Weapon Skills:
  - Staff, Mace, possibly Dagger.
- Armor Skills:
  - Leather/Cloth; some go light Mail if they accept encumbrance.
- Material Lore:
  - Cloth/Leather / Etherweave.
- Special Skills:
  - Healing Arts (if implemented),
  - Ether Attunement,
  - Shrine Lore.

### 4.3 Rune Families

- **Heals/Support:**
  - Mend Flesh, Ward of Dawn, Shared Burden.
  - Cleansing Auras, HoTs, and small shields.
- **Utility:**
  - Short-range blinks, sanctuary circles, anti-corruption flares.

### 4.4 Faction Synergy

- Shrine Orders: Primary – Warden gear and Contracts.
- Civic: Generally positive if they participate in city defense.
- Frontier: Some Wardens specialize in frontier triage.

### 4.5 Content Loop

- Solo:
  - Low-risk Contracts near Shrines or caravan duty.
  - Rifting support with small groups.
- Group:
  - Dungeon/Delve healer.
  - Red Zone roaming as backline support.
- Guild:
  - Anchoring big fights around Shrines and Strongholds.
  - Key role in Cursed Raid extractions (keeping carriers alive).

---

## 5. Spellfire Magus – “High-Risk Ranged Caster”

**Fantasy:**  
If you liked **Fire Mage**, **Destro Warlock**, **Elemental Shaman** – explosive damage, positioning-dependent survival.

### 5.1 Stat Profile (Example)

- STR: 20–40
- AGI: 60–80
- STA: 80–110
- INT: 140–150
- SPI: 80–100

### 5.2 Skills & Gear

- Weapon Skills:
  - Staff, Wand, Dagger.
- Armor Skills:
  - Cloth; light Leather if carefully tuned with encumbrance.
- Material Lore:
  - Etherweave,
  - Fire/Ice/Abyssal Lore for certain runes.

### 5.3 Rune Families

- **Offense:**
  - Firebolt, Flame Burst, Meteoric Shower.
  - Ether Spear, Arcane Lance.
- **Utility:**
  - Flickerstep, Ether Shield, slow/CCs.

### 5.4 Faction Synergy

- Shrine Orders: Offensive shrines.
- Atlas: Explorer-magus hybrid for anomaly clearing.
- Cartel: Some go “black mage” and do dirty work for Cartel.

### 5.5 Content Loop

- Solo:
  - High-reward Contracts that require burst damage (elite targets, anomaly clearing).
- Group:
  - AoE/cleave in public dungeons.
  - Burst in Warfronts and Red Zone skirmishes.
- Guild:
  - Siege support (anti-clump tools).
  - “Glass cannon” roles in tactical groups.

---

## 6. Ether Ranger – “Skirmisher & Scout”

**Fantasy:**  
If you liked **Hunter** (MM/BM/Survival) or hybrid rogue/ranger fantasy.

### 6.1 Stat Profile (Example)

- STR: 60–80
- AGI: 120–150
- STA: 90–110
- INT: 60–80
- SPI: 40–70

### 6.2 Skills & Gear

- Weapon Skills:
  - Bow/Crossbow/Gun, Spear, Shortblade.
- Armor Skills:
  - Leather, light Mail if STR and encumbrance support it.
- Material Lore:
  - Leather & Wood Lore (bows, shafts).
- Special Skills:
  - Tracking, Stealth, Companion mastery.

### 6.3 Rune Families

- **Offense:**
  - Volley, Piercing Arrow, Trueshot.
- **Utility:**
  - Hunter’s Step (mobility),
  - Traps, camouflage, tracking.

### 6.4 Faction Synergy

- Frontier Militia: Natural scouts and skirmishers.
- Atlas Consortium: Great synergy with mapping and anomaly detection.
- Shrines: Some spiritual Ranger paths.

### 6.5 Content Loop

- Solo:
  - Scouting Contracts, courier missions, anomaly scanning.
  - Hunting high-tier beasts for crafting mats.
- Group:
  - Pick-off and zone control in Red Zones.
  - Pulling and adds control in delves.
- Guild:
  - Intel gathering for sieges and Warfronts.
  - Flanker and harasser in big fights.

---

## 7. Cartel Broker – “Economic PvP / Black Marketeer”

**Fantasy:**  
If you liked the **goblin auctioneer rogue** fantasy; less about meters, more about manipulation and profit.

### 7.1 Stat Profile (Example)

- STR: 40–60
- AGI: 80–100
- STA: 80–100
- INT: 100–130
- SPI: 70–90

### 7.2 Skills & Gear

- Weapon Skills:
  - Daggers, Pistols (if added), Light weapons.
- Armor Skills:
  - Leather/Cloth.
- Material Lore:
  - Trade goods, metals, rare materials.
- Special Skills:
  - Thievery, Lockpicking, Smuggling.

### 7.3 Rune Families

- **Utility / Trickery:**
  - Vanish, smoke bombs, movement tech.
- **Combat:**
  - Backstab / ambush-type runes.
- **Economic:**
  - Potential runes that boost fence rates or inventory tricks (design space).

### 7.4 Faction Synergy

- Cartel Syndicate: Primary.
- Civic: Often negative correlation at high Cartel levels.
- Atlas: Secondary, for intel on trade routes.

### 7.5 Content Loop

- Solo:
  - Running trade routes,
  - Smuggling Contracts,
  - Thief-style gameplay in cities.
- Group:
  - Support in small-scale ganks (intel, control).
- Guild:
  - Managing guild economy, Black Market operations, fencing loot.

---

## 8. Frontier Marshal – “Control Tank / Siege Specialist”

**Fantasy:**  
If you liked **Prot Warrior/Paladin**, **Blood DK** – control, presence, defense-focused.

### 8.1 Stat Profile (Example)

- STR: 110–140
- AGI: 80–100
- STA: 130–150
- INT: 40–60
- SPI: 40–60

### 8.2 Skills & Gear

- Weapon Skills:
  - Sword/Mace + Shield, Polearm/2H variants.
- Armor Skills:
  - Plate/Heavy Mail.
- Material Lore:
  - Heavy metals and siege-related materials.

### 8.3 Rune Families

- **Defense/Control:**
  - Guard stance, taunts, stuns, suppressing fire.
- **Utility:**
  - Rallying cries, siege auras.
- **Offense:**
  - Modest DPS runes to maintain threat presence.

### 8.4 Faction Synergy

- Frontier Militia: Primary.
- Civic: Often positive via city defense.
- Shrine: Secondary (guardian aspects).

### 8.5 Content Loop

- Solo:
  - Harder solo Contracts; can tank heavy content.
- Group:
  - Anchor in delves, public dungeons, Warfronts.
- Guild:
  - Stronghold commander, siege engine operator.

---

## 9. Atlas Pathfinder – “Explorer, Mapper, Anomaly Hunter”

**Fantasy:**  
If you enjoy exploration, professions, and discovery over pure combat.

### 9.1 Stat Profile (Example)

- STR: 50–70
- AGI: 90–110
- STA: 90–110
- INT: 100–130
- SPI: 70–90

### 9.2 Skills & Gear

- Weapon Skills:
  - Light weapons for self-defense.
- Armor Skills:
  - Leather/Cloth, tuned to keep them mobile.
- Material Lore:
  - Broad coverage on gathering skills.
- Special Skills:
  - Anomaly Scanning, Rifting, Cartography.

### 9.3 Rune Families

- Mobility, stealth-lite, survival & information gathering.

### 9.4 Faction Synergy

- Atlas Consortium: Primary.
- Frontier, Shrine: Secondary depending on path.

### 9.5 Content Loop

- Solo:
  - Mapping, anomaly hunting, trade route scouting.
- Group:
  - Support: intel, pathing, safe routes.
- Guild:
  - Strategic planning: where to siege, where to harvest, where to avoid.

---

## 10. Riftbound Occultist – “Risk Wizard / Anomaly Specialist”

**Fantasy:**  
If you liked **Shadow Priest**, **Demo Warlock**, arcane “edge of madness” casters.

### 10.1 Stat Profile (Example)

- STR: 20–40
- AGI: 60–80
- STA: 80–100
- INT: 140–150
- SPI: 90–120

### 10.2 Skills & Gear

- Weapon Skills:
  - Staff, Dagger, Tome (if added).
- Armor Skills:
  - Cloth; very light armor.
- Special Skills:
  - Ether Attunement, Rifting, Void Lore.

### 10.3 Rune Families

- **Offense:**
  - Void bolts, curses, DoTs.
- **Utility:**
  - Reality-bending runes with risk (HP cost, corruption building).
- **Anomaly:**
  - Enhanced rewards from Rifts, more dangerous anomalies.

### 10.4 Faction Synergy

- Shrine Orders: Some orders will love / some hate them.
- Atlas: Strong synergy with anomaly gameplay.
- Cartel: Occult contracts and black rituals.

### 10.5 Content Loop

- Solo:
  - Dangerous anomaly delving.
- Group:
  - Niche DPS/support with corruption gimmicks.
- Guild:
  - Specialist in Rift/Hellgate content.

---

## 11. Implementation & MortalUI Hooks

- **Docs only**: No new C++ for archetypes.
- MortalUI can:
  - Provide preset **“Suggested Builds”** where:
    - Stat sliders are pre-filled.
    - Recommended skills & rune families are highlighted.
  - Offer an “If you liked X in WoW” onboarding panel in the tutorial hub.

This grid is a **player-facing translation layer**, explaining how to live in Mortal using instincts from WoW, while still preserving a truly classless, skill-driven backend.
