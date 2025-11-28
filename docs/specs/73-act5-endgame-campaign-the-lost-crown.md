# Project Canvas: Mortal Warcraft Overhaul  
### Version 36.0 — Narrative & Endgame  
### File: 73-act5-endgame-campaign-the-lost-crown.md  
### Section: Act V — “The Lost Crown” (Endgame Campaign & Raids)

---

## Related Specs

- `74-cursed-artifacts-and-extraction-system.md` - Cursed Artifact system and extraction mechanics central to Act V
- `06-pve.md` - PvE content types including Extraction Raids
- `33-instance-and-battleground-tier-mapping.md` - ICC and dungeon mapping to Mortal tiers
- `08-guilds-sovereignty.md` - Strongholds and territory control referenced in campaign
- `48-zone-invasions-and-cross-faction-pve.md` - Zone invasions and Midnight Horde surges
- `52-season-of-the-frontier.md` - Seasonal content and campaign integration
- `36-mortal-achievements-and-titles-core.md` - Titles and achievements unlocked in Act V
- `19-itemization.md` - Mortal gear tiers and loot tables for raid content
- `32-npc-and-encounter-rebalance.md` - NPC scaling and encounter tuning for ICC/Crown Citadel
- `92-mortal-warfronts-siege-flow.md` - Warfronts referenced in campaign context

---

## 1. Scope

Act V is the **endgame campaign spine** that ties together:

- The **Frontier**, **Strongholds**, and **Zone Invasions** (Act IV),
- The four Powers (Iron Ledger, Shrine, Cartel, Rangers),
- The **Cursed Artifact / Extraction Raid** concept,
- A Mortal-flavored reimagining of WotLK’s northern endgame, especially:
  - Icecrown Citadel (ICC),
  - Frozen Halls dungeons (FoS/PoS/HoR),
  - World bosses and Lost Lands (Emerald Dream fragments, Azshara Crater, etc.).

Goal:

- Provide a **story arc from midgame → true endgame**, not just loose raids.
- Make raids feel like:
  - **Operations** with consequences (extraction, territory, economy),
  - Not “theme park rides.”

Quest IDs: **10300–10379** reserved for Act V.

---

## 2. Narrative Situation

By the time Act V starts:

- Players have:
  - Survived full-loot death (Act II),
  - Chosen/engaged with at least 2 factions (Act III),
  - Participated in Strongholds, Invasions, and one Warfront (Act IV).
- The map shows:
  - A **shifting Frontier line**,  
  - Player-owned Strongholds,  
  - Fallen / reclaimed zones.

The new threat:

- **The Crown of the Hollow King** – a **Cursed Artifact** of immense Ether gravity:
  - Located in the reinterpreted Icecrown region & its Citadel,
  - Responsible for amplifying:
    - Midnight Horde surges,
    - Rifts,
    - Zone collapses.

You are tasked with:

- Locating its imprints (Fragments),
- Assaulting its strongholds (dungeons & raids),
- Extracting it from the world in an open-world extraction sequence.

---

## 3. Structure Overview

Act V has three layers:

1. **Layer A — The Investigation (World & 5-mans)**  
   - FoS/PoS/HoR–style dungeons used as:
     - Lead-ins,
     - Fragment hunts,
     - Lore reveals.

2. **Layer B — The Crown Citadel (Main Raid)**  
   - ICC re-flavored as:
     - The **Crown Citadel**,  
     - Home of the Hollow King and the Crown itself.  
   - Raids produce:
     - Cursed Artifacts (heavy, non-equippable),
     - High-tier Mortal gear,
     - Fragmented Crowns for token economy.

3. **Layer C — The Extraction (Open-World Endgame)**  
   - After a successful kill:
     - The Crown (or large Fragments) must be:
       - Escorted from Citadel outskirts → open-world **Purification Altars**,
       - Protected against player & NPC interference (full loot).

---

## 4. Entry Conditions & Starting Quest

### 4.1 Requirements to Start Act V

- Completion of Act IV mainline Q10207 “Our First Banner”.  
- Character has:
  - Reached high skill threshold (dynamic Level near cap),
  - Participated in at least:
    - One Stronghold defense or siege,
    - One Invasion Contract or Warfront.

### 4.2 Q10300 — “The Crown’s Shadow”

- **QuestID:** 10300  
- **Type:** MAIN (Act V opener)  
- **Giver:** War Map itself (vision), or Shrine Archivist Nyra / Atlas Cartographer Lyenn.  

**Summary:**  
Atlas and Shrine archives identify a pattern: **massive Ether spikes** radiating from the far north. Old records speak of a Crown that commands death itself. The Four Powers convene to decide how to respond.

**Objectives:**

- Interact with War Map and view:
  - Newly revealed **Northern Frontier Map Layer** (Icecrown-as-Frontier).  
- Attend a **Council of Four** meeting:
  - Ledger: sees opportunity and massive risk,  
  - Shrine: sees a sacrilege that must be ended,  
  - Cartel: sees black markets for Cursed Relics,  
  - Rangers: see the land itself dying.

**Rewards:**

- Unlock **Northern Frontier** pins in Atlas/MortalMap.  
- Q10301 and Q10302 investigation quests become available.

---

## 5. Layer A — Investigation & 5-Man Content

We repurpose key WotLK 5-mans as **investigation ops**.

### 5.1 Q10301 — “Fragments in the Frost” (FoS/PoS)

- **QuestID:** 10301  
- **Type:** MAIN (5-man investigation)  
- **Giver:** Faction-aligned NPC in Northern Frontier camp.  

**Summary:**  
Reports suggest that **Crown Fragments** are being moved through underground holds and soulforges. You must lead an expedition to recover the first major Fragment.

**Objectives:**

- Clear **two reworked dungeons** (can be sequential or selectable):  
  - Dungeon A: repurposed FoS equivalent (soulforges, spectral chains),  
  - Dungeon B: repurposed PoS equivalent (supply lines, death wagons).  
- Defeat final boss of Dungeon B and loot:
  - 1x **“Shard of the Hollow Crown”** (group drops 1 or more shards).

**Rewards:**

- Personal:
  - Gold, mid-high-tier Mortal gear drops,  
  - Reputation with your chosen main faction(s).  
- Campaign:
  - Crown Fragment delivered to Shrine or Atlas for analysis,
  - Unlocks Q10302.

**Implementation Notes:**

- Dungeons:
  - HP & damage tuned to Mortal stat caps,
  - Loot tables swapped to Mortal gear progression items and Fragments.

---

### 5.2 Q10302 — “Echoes in the Ice” (HoR-style Story Dungeon)

- **QuestID:** 10302  
- **Type:** MAIN (Story dungeon / gauntlet)  
- **Giver:** Shrine Warden Calren or Rangers Commander.  

**Summary:**  
With the first Fragment analyzed, a **vision-dungeon** is unlocked — a HoR-style gauntlet that shows how the Crown was forged and what it did to the land.

**Objectives:**

- Enter **The Hollow Road** (HoR re-flavored as an Ether-vision gauntlet).  
- Survive:
  - 3 narrative waves reflecting:
    - The Crown’s creation,  
    - Its first use on a city,  
    - The shattering that left Fragments across the Frontier.  
- Reach the end and confront:
  - A **Memory of the Hollow King** (non-loot, lore boss).

**Rewards:**

- Personal:
  - Gold, unique **cosmetic** (e.g., Hollow Echo cloak, no stats).  
- Campaign:
  - Unlocks:
    - Full location of **Crown Citadel** on the map,
    - Act V Layer B: raid missions.

**Implementation Notes:**

- This dungeon:
  - Focuses on story, not loot,
  - Can be tuned lower difficulty so more players see the lore.

---

## 6. Layer B — The Crown Citadel (Raid Tier)

We treat ICC as **The Crown Citadel**, with:

- Wings re-flavored as:
  - **The Ledger of Bones** (plague/necropolis sections),  
  - **The Forgewrought Hall** (constructs & siege),  
  - **The Frozen Choir** (spirits & shrines),  
  - **The King’s Ascent** (final approach).

### 6.1 Q10310 — “Opening the Citadel”

- **QuestID:** 10310  
- **Type:** MAIN (Raid unlock quest)  
- **Giver:** Council Fire or Northern Frontier Commander.  
- **Prereqs:** Q10302.

**Summary:**  
Armed with knowledge from the Hollow Road, factions coordinate a push to breach the **Citadel’s outer defenses**, opening raid access.

**Objectives:**

- Participate in an open-world **pre-raid event** near Citadel gates:
  - Defend siege engines,  
  - Destroy warding crystals,  
  - Hold a forward Shrine anchor.  
- Once event meters filled (server-wide), unlock:
  - Citadel Raid Portal.

**Rewards:**

- Personal:
  - Gold, some pre-raid gear,  
  - Rep with all factions (they all contributed).  
- World:
  - Citadel portal becomes active for a defined season/cycle.

**Implementation Notes:**

- Event can be repeated when Citadel “seals” again in future seasons,
- Good candidate for scheduled world events.

---

### 6.2 Raid Loot Philosophy

- Bosses drop:
  - **Mortal Tier Gear** (using your custom WoW models & Mortal stat tuning),  
  - **Cursed Artifacts** (heavy, non-equippable, extraction items),  
  - **Fragmented Crowns** (token equivalents for endgame vendor economy).

- Some bosses (mid/final) also drop:
  - **Faction-tinged Runes** (Ashes of War style) with unique powers.

---

### 6.3 Q10311 — “Ledger of Bones” (First Raid Wing)

- **QuestID:** 10311  
- **Type:** RAID QUEST (Wing 1)  
- **Giver:** Iron Ledger + Shrine joint emissary at raid entrance.  
- **Prereqs:** Q10310.

**Summary:**  
The first wing houses **bone archives** and ledgers of the dead — souls owing Ether-debts to the Crown. You must clear it and reclaim the first **Major Cursed Artifact**.

**Objectives:**

- Defeat all bosses in Wing 1 (Ledger of Bones).  
- Loot **“Tallystone of the Unpaid”** (Major Cursed Artifact, heavy).  
- Return Tallystone to a **Forward Purification Camp** outside Citadel.

**Rewards:**

- Personal:
  - High-tier Mortal gear from boss tables,  
  - Extra tokens for first full clear.  
- Campaign:
  - Tallystone used to weaken the Crown’s world influence:
    - Slight decrease in global Midnight Horde frequency,  
    - Or lowered Ether surge severity.

**Implementation Notes:**

- Artifact is:
  - Heavy (encumbrance),
  - Cannot be mailed or banked until purified,
  - Must be physically carried out of raid (acts as “Cursed Loot”).

---

### 6.4 Q10312 — “The Forgewrought Hall” (Second Raid Wing)

- **QuestID:** 10312  
- **Type:** RAID QUEST (Wing 2)  
- **Giver:** Rangers + Ledger rep (siege angle).  
- **Prereqs:** Q10311.

**Summary:**  
Wing 2 contains **siege constructs** and forges that produce war engines for the Crown’s forces. Destroy them, and reclaim a second Major Cursed Artifact.

**Objectives:**

- Defeat Wing 2 bosses (Forgewrought Hall).  
- Sabotage **3 Soul Forges** (interact during fights or as side objectives).  
- Loot **“Heart of the Forgewrought”** (Major Cursed Artifact).  
- Extract Heart to Purification Camp.

**Rewards:**

- Personal:
  - High-tier gear,  
  - Chance at unique siege-related Runes.  
- Campaign:
  - Slight reduction in:
    - Invasion siege engine power or frequency, globally.

**Implementation Notes:**

- Extraction:
  - Possibly contested in open world:
    - Enemy factions (NPCs and players) could intercept.

---

### 6.5 Q10313 — “The Frozen Choir” (Third Raid Wing)

- **QuestID:** 10313  
- **Type:** RAID QUEST (Wing 3)  
- **Giver:** Shrine + Cartel emissaries.  
- **Prereqs:** Q10312.

**Summary:**  
Wing 3 is a **cathedral of frozen songs**, where the Crown stores voices and prayers of the dead, twisted for control. You must unbind them.

**Objectives:**

- Defeat Wing 3 bosses (Frozen Choir).  
- Free at least **X “Bound Voices”** by:
  - Activating shrines mid-fight, or  
  - Completing side-mechanics.  
- Loot **“Chorus of the Lost”** (Major Cursed Artifact).  
- Extract Chorus.

**Rewards:**

- Personal:
  - High-tier gear,  
  - Powerful healer/support-oriented Runes.  
- Campaign:
  - Reduces penalties on:
    - Shrine services,
    - Durability damage from death,  
    - Or increases frequency of beneficial shrine buffs.

**Implementation Notes:**

- This wing:
  - Should lean into support/healing mechanics to tie back to Shrine Trials.

---

### 6.6 Q10314 — “The Hollow King” (Final Ascent & Crown)

- **QuestID:** 10314  
- **Type:** RAID QUEST (Final Wing & Boss)  
- **Giver:** All four factions + War Map.  
- **Prereqs:** Q10313.

**Summary:**  
With three Major Artifacts reclaimed, the Crown is weakened enough for a direct assault on the Hollow King and his throne.

**Objectives:**

- Ascend the final wing (King’s Ascent) and defeat the **Hollow King** raid boss.  
- Loot **“The Crown of the Hollow King”** (Primary Cursed Artifact, extremely heavy, unique).  
- Begin **Extraction Protocol** by carrying the Crown out of Citadel to a designated **Purification Altar** in the open world.

**Rewards (immediate raid clear):**

- Player:
  - Top-tier gear,  
  - Significant token drops,  
  - Guarantee of at least one unique Rune per raid group.  
- World:
  - Triggers Layer C: Extraction.

**Implementation Notes:**

- The boss kill:
  - Does **not** immediately “end the season”:
    - The Crown still exists in the world until:
      - Extraction is completed,
      - Or it is lost/fails and returns to Citadel (season reset mechanic).

---

## 7. Layer C — The Extraction

The Extraction is what makes this different from a normal theme-park raid. After Q10314:

### 7.1 Q10320 — “The Weight of a World”

- **QuestID:** 10320  
- **Type:** MAIN (Extraction Phase)  
- **Giver:** Auto-granted to raid participants holding/escorting the Crown.  

**Summary:**  
You must escort the Crown from the Citadel outskirts to the nearest **Purification Altar** — typically in a contested Red/Yellow border area — under threat from:

- NPC invaders trying to reclaim it,
- Other players (full-loot rules apply),
- Time pressure (Ether intensity building over time).

**Objectives:**

- Carry the Crown:
  - Movement speed heavily reduced for the bearer,  
  - Encumbrance enormous.  
- Reach Purification Altar alive.  
- Defend the altar through a **Purification Event**:
  - Several waves of enemies,
  - Multiple phases of ritual channel.

**Outcomes:**

- **Success:**
  - Crown is **purified and shattered**:
    - World Midnight Horde/invasion frequency reduced for the rest of the season,  
    - Frontier line slightly stabilizes,  
    - Special seasonal titles & rewards granted.

- **Failure:**
  - Crown bearer dies and Crown is:
    - Looted by others, OR  
    - Lost (despawns, returns to Citadel after timer).  
  - War Map announces:
    - “The Crown has returned to the Citadel” (soft season loop).

**Rewards:**

- Success:
  - Unique seasonal titles like:
    - “Bearer of the Burden”, “Breaker of the Crown”.  
  - Long duration world buffs (e.g. reduced death penalties, better contract rates in Frontier).  
  - Extra loot/tokens for participants.

- Failure:
  - Consolation tokens,  
  - Narrative consequences: increased invasion pressure.

**Implementation Notes:**

- This sequence:
  - Can be triggered per raid kill,  
  - But only **one active Crown** per realm at a time.
- Atlas/MortalMap:
  - Shows Crown position while carried (“Crown Carrier” map icon).

---

## 8. Optional Side Arcs — Lost Lands & World Bosses

To avoid everything being north-centric, Act V includes optional side arcs:

### 8.1 Q10330 — “Dreams of the Broken Bough” (Emerald Dream Fragment Zone)

- **Use:** Emerald Dream map remixed as **high-tier gathering & Ether rift zone**.  
- Quest arc:
  - Investigate a **massive Ether bloom** in Dreamlands,  
  - Fight world bosses that dropped fragments used to:
    - Add modifiers to Crown Citadel or Extraction difficulty/reward.

### 8.2 Q10340 — “Storm over Azshara Crater” (Guild War Zone)

- **Use:** Azshara Crater as a **permanent guild war zone**.  
- Quest arc:
  - Tie into Warfronts,  
  - Use matches to influence:
    - Resource flow to Northern campaigns,  
    - Or apply buffs/debuffs to raids/invasions.

### 8.3 Q10350 — “The Outside Raid” (World Boss Tour)

- Hook:
  - Azuregos, Kazzak, Dragons, Doomwalker – all recontextualized as:
    - **Crown Shard guardians**,  
    - Dropping:
      - Fragments that affect:
        - Invasion rates,  
        - Raid affixes,  
        - Extraction events.

---

## 9. Titles & Achievements

Act V should unlock some of the most prestigious titles:

- **Campaign Titles:**
  - “Free Agent of the Frontier” (Act III) → upgraded to:
    - “Banner-Bearer”,  
    - “Lineholder”,  
    - “Breaker of the First Breach”,  
    - “Crownbreaker”.

- **Extraction Titles:**
  - “Crown Bearer” (carried Crown at least once),  
  - “Purifier of the North” (participated in successful extraction),  
  - “Hollow’s Bane” (killing blow or key mechanic success on Hollow King).

- **Stronghold/War Titles:**
  - “Marshal of Spires”,  
  - “Warden of the Line”,  
  - “Siegewright”.

Tie into:

- `achievements & titles` spec you already have, using:
  - Flags on kill events,
  - Zone control events,
  - Extraction completions.

---

## 10. Implementation Checklist

1. **Zone & Dungeon Rework:**
   - Northern Frontier layout based on Icecrown.  
   - Re-theme FoS/PoS/HoR, ICC to Hollow King and Crown motifs.  

2. **Raid & Loot Tables:**
   - Update all relevant `creature_loot_template`, `item_template` references to Mortal gear, Runes, and Cursed Artifacts.

3. **Cursed Artifact System:**
   - DB + scripts for:
     - Major Cursed Artifacts (from raid wings),  
     - The Crown itself,  
     - Encumbrance, non-bankability, extraction events.

4. **Extraction Flow:**
   - Scripts for:
     - Crown carrier debuff & icon,  
     - World announcements,  
     - Purification Altar event.

5. **Atlas/MortalUI:**
   - Northern map layer for:
     - Citadel,  
     - Active Crown / Fragments,  
     - Invasion intensity overlays.

6. **Seasonality Hooks (optional but recommended):**
   - Ability to:
     - Reset Citadel state,  
     - Cycle periods of increased invasion activity,  
     - Mark seasons in achievements/titles.

---

Act V turns endgame from “just farm raids” into a **living seasonal operation**:

- Raids feed Cursed Artifacts,  
- Artifacts trigger Extraction,  
- Extraction success/failure reshapes:
  - The Frontier,  
  - Invasion pressure,  
  - The economy & Shrines—  
all while giving your sandbox MMO a clear, replayable climax.  
