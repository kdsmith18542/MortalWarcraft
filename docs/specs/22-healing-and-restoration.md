# Project Canvas: Mortal Warcraft Overhaul
### Version 26.1 — Hybrid Technical Design Document  
### File: 22-healing-and-restoration.md  
### Section: Healing, Restoration Magic & Sustain Systems

---

# 1. Purpose

This document defines **how healing works in Mortal Warcraft**, including:

- Baseline, non-magical sustain available to everyone.
- **Restoration (Life) Magic** as a skill-based discipline.
- Healing/sustain via **Runes of Mastery**.
- Healing/sustain via **Professions & Rituals**.
- Special casing for:
  - Open world (Green/Yellow/Red).
  - Dungeons (currently mostly vanilla tuning).
  - Raids & public delves.

This is a gameplay spec; technical hooks are outlined at the end.

---

## Related Specs

For full context on healing and restoration systems, see:

- **`23-mercenary-healers.md`** — Mercenary healer system for instances
- **`50-lifeskills-fishing-and-first-aid.md`** — First Aid lifeskill that complements healing
- **`21-elden-systems.md`** — Crimson Phial system referenced throughout
- **`64-spell-and-ability-library.md`** — Spell and ability library that includes restoration magic
- **`02-combat.md`** — Combat mechanics that healing interacts with
- **`84-mortal-core-stats-and-combat-model.md`** — Stat formulas that affect healing effectiveness
- **`03-risk-zones.md`** — Risk zones that affect healing rules and availability

---

# 2. Healing Philosophy

1. **Everyone can sustain, but not infinitely.**
   - Crimson Phial, food, bandages, rest.
2. **Real in-combat healing is magic and must be learned.**
   - Restoration magic is a **skill line**, not a free class kit.
3. **Healing is constrained by mana, cast time, and risk.**
   - You cannot trivially out-heal focused damage.
4. **Gear and choices matter.**
   - Runes, backgrounds, and professions alter how you heal.
5. **Dungeons (for now) keep mostly vanilla NPC stats.**
   - Systems should initially target vanilla dungeon tuning.
   - Later, dungeons can be rebalanced to Mortal’s stat/damage scheme.

---

# 3. Baseline Non-Magical Healing (Everyone Gets This)

## 3.1 Crimson Phial (Refresher)

As per `21-elden-systems.md`:

- **Crimson Phial**:
  - Base 3 charges, Soulbound, Unique.
  - Heals ~35–45% HP per use (tuned via `flask_heal_percent`).
  - Only refills at Shrines, Inns, and optionally Guild Shrines.
- Purpose:
  - “Big button” survival tool.
  - Limits how many hard engagements you can sustain per expedition.

## 3.2 Food

- **Function**:
  - Out-of-combat HP regeneration over time.
- Rules:
  - Eating applies a **Food Regen** aura:
    - Restores a small % of max HP per second for 20–30 seconds.
  - Any damage or entering combat cancels the buff.
- Scaling:
  - Quality of food depends on **Cooking** and ingredients.
  - High-quality food:
    - Slightly faster regen.
    - May give minor max HP or stamina bonuses for 30–60 minutes.

## 3.3 Bandages

- **Function**:
  - Fast, single-target, out-of-combat heal.
- Rules:
  - 8–10s channel.
  - Interrupts if the target takes damage.
  - Requires **Field Medicine** skill (subskill of Survival / First Aid).
- Scaling:
  - Bandage tiers (Linen, Wool, Silk, etc.) increase:
    - Total healing.
    - But still out-of-combat only.

## 3.4 Campfires

- **Function**:
  - Group sustain + small buff.
- Rules:
  - Created via Survival skill and wood.
  - Players near a campfire:
    - Gain slightly boosted food/bandage effectiveness.
    - Gain small bonuses to stamina regen.
- Use:
  - Encourages parties to **pause, regroup, and plan** between pushes.

---

# 4. Restoration (Life) Magic

## 4.1 Skill Line: `Restoration`

- New skill: `Restoration` (or `Life Magic`).
- Increases by:
  - Casting healing spells in combat.
  - Completing certain healer-flavored tasks or quests.
- Cap matches other primary skills (e.g., 1200).

## 4.2 Learning Spells

Healing spells are **not learned from generic class trainers**.

Instead:

- Spells are taught by **Books** (`spell_learning_system.lua`):
  - Book item → teaches a spell if requirements are met.
- Requirements:
  - `Restoration` skill minimum.
  - Optional **Background** (e.g., `Acolyte`, `Hermit`, `Physicker`).
  - Optional **Reputation** with religious or civic factions.

### 4.2.1 Example Sources

- Temple vendors in Green/Yellow cities.
- Rare drops from:
  - Undead-themed dungeons (healing tomes as “holy knowledge”).
  - Religious cult events.
- Crafted tomes by Scribes (using inks + special components).

---

## 4.3 Core Spell Line (Example)

This is a starter lineup (tuning numbers are placeholders):

1. **Minor Mend**
   - Type: Single-target direct heal.
   - Cast time: 2.0s.
   - Cooldown: None.
   - Cost: Moderate mana.
   - Scaling: Low with `Restoration` and Intellect.
   - Purpose: Bread-and-butter small heal.

2. **Rejuvenating Prayer**
   - Type: Single-target HoT (heal-over-time).
   - Duration: 10s, ticks every 2s.
   - Cast time: 1.5s.
   - Cooldown: 5s.
   - Cost: Efficient mana.
   - Purpose: Sustain for tanks/frontliners between burst windows.

3. **Circle of Mending**
   - Type: Small-radius AoE heal.
   - Cast time: 2.5s.
   - Cooldown: 20–30s.
   - Cost: High mana.
   - Purpose: Group sustain during PvE/PvP skirmishes.

4. **Aegis of Renewal**
   - Type: Small absorb shield.
   - Cast time: 1.5s.
   - Cooldown: 15s.
   - Cost: Moderate mana.
   - Purpose: Pre-emptive mitigation for Guard Counter play, or for carrying loot.

5. **Rite of Restoration**
   - Type: Long ritual / out-of-combat group heal.
   - Cast time: 8–10s.
   - Cooldown: 5 minutes.
   - Requirements: At least 2–3 players channeling together (ritual).
   - Purpose: “Mini reset” in the field, but expensive and risky (channel time).

Each spell:

- Has **rankless scaling** (no rank spam).
- Power scales from:
  - `Restoration` skill.
  - Intellect.
  - Possibly specific **Mastery passives** for healers.

---

## 4.4 Limiters & Anti-Spam Mechanics

To prevent “infinite WoW healer” scenarios:

- Lower overall HP pools (due to your stat squish).
- High mana cost on strong spells.
- Strong penalties for overhealing:
  - Possibly a minor “Exhaustion” debuff if too much mana spent in a short window.
- Aggro considerations:
  - Healing generates threat; in public dungeons, panic-healing can get you focused.

---

# 5. Healing Runes (Runes of Mastery)

## 5.1 Concept

Some Runes of Mastery provide **healing or sustain effects**.

These:

- Are **bound to weapons/shields**.
- Grant spells only while the weapon is equipped.
- Are lost with the weapon in full loot scenarios.

## 5.2 Example Healing/Sustain Runes

1. **Rune of Second Wind**
   - Effect: Active melee ability with cooldown.
   - On hit:
     - Heals the wielder for a percentage of damage dealt.
   - Requirements:
     - `Blades` or `Axes` skill threshold.
   - Use Case:
     - Duelists and frontliners who want self-sustain.

2. **Rune of Guardian Ward**
   - Effect: Places a small damage absorb on target ally within melee range.
   - Requirements:
     - `Shield Mastery` skill.
   - Use Case:
     - Off-tanks / bodyguards in caravans.

3. **Rune of Vital Surge**
   - Effect: Long-cooldown emergency self-heal + small movement buff.
   - Use Case:
     - Roamers and explorers who frequently operate alone.

4. **Rune of Leeching Shot**
   - Effect: Ranged attack that lifesteals a portion of damage.
   - Requirements:
     - `Archery` skill.
   - Use Case:
     - Kiting archer builds with sustain but no real Restoration spells.

## 5.3 Balance Considerations

- Runes should be:
  - Weaker than dedicated Restoration spam, but:
  - More reliable for solo builds.
- Extremely potent healing runes should be:
  - Very rare.
  - Exposed to full-loot risk in Red zones.

---

# 6. Professions & Ritual Healing

## 6.1 Alchemy

- **Tonics**:
  - Low burst healing or regen over 15–20s.
  - Share a cooldown with standard potions.
  - Stack with food/bandages but **not** Crimson Phial.
- **Cleanses**:
  - Cure poison, disease, or bleed.
  - Enable survival against environments (plague zones, poison swamps).

## 6.2 Cooking

- **Hearty Meals**:
  - Longer duration food:
    - Boosts max HP slightly.
    - Improves out-of-combat regen.
- **Specialty Foods**:
  - Zone-themed recipes with:
    - Frost resistance, poison resistance, etc.

## 6.3 Rituals (Group Rest Systems)

- Designed as **multi-player, high-commitment healing tools**.

Example: `Rite of Renewal`

- Requires:
  - 3+ players.
  - Special reagent (e.g., Sacred Candle).
- Effect:
  - Full HP/Mana restore.
  - Removes non-curse debuffs.
  - Applies “Ritual Exhaustion” debuff:
    - Prevents another Rite for 30–60 minutes.
- Use:
  - Prepares a group for a major push (boss, risky caravan run).

---

# 7. Zone Rules: Healing in Green / Yellow / Red

## 7.1 Green Zones (Safe)

- **Full access** to:
  - Inn rest.
  - Shrines.
  - Food, bandages, and rituals.
- Purpose:
  - Allow players to fully reset and prepare.

## 7.2 Yellow Zones (Criminal/Skulled)

- Out-of-combat healing works as normal:
  - Food, bandages, tonics.
- Shrines may be:
  - More spread out.
  - Guarded or “contested” during events.
- Risk:
  - Healing in the open can expose you to ambush.

## 7.3 Red Zones (Full Loot, High Risk)

- No flying and limited portals (as already defined).
- Healing rules remain the same mechanically, but:
  - **Shrines are rare and risky** (players may camp them).
  - Rest rituals and campfires are vulnerable to PvP.
- Optional tuning:
  - Slightly lower heal amounts from food/bandages to emphasize flask + Restoration.

---

# 8. Dungeons & Raids (Note on Tuning)

You noted: **for now, dungeons remain “vanilla” in layout & NPC level/stat baselines**.

This has implications:

- Early-game and mid-game dungeons will:
  - Be more forgiving initially with our healing model (vanilla mobs do modest damage).
- Later, as you re-itemize and re-stat the world:
  - You can gradually adjust dungeon mob damage and health to:
    - Assume:
      - Crimson Phial exists.
      - Restoration spells exist but are limited.
      - Players rely more on skillful play and Guard Counters.

### Transitional Recommendation

- For early implementation:
  - Keep healing numbers conservative (do **not** over-buff heal spells).
  - Let dungeon testing drive:
    - Increases to Restoration power.
    - Adjustments to Phial heal percentage.
- As itemization & mob damage squish are finalized:
  - Revisit:
    - Dungeon boss damage.
    - Add telegraphed attacks that interact with Brace/Guard Counter.

---

# 9. Technical Implementation Summary

## 9.1 Database

New/Updated Tables:

- `mortal_crimson_phial`  
  (if not already implemented from `21-elden-systems`).
- `mortal_restoration_spells`
  - `spell_id`
  - `required_restoration_skill`
  - `required_background_id` (nullable)
  - `required_reputation_id` (nullable)
  - `tuning_params` (JSON/text for future use)
- `mortal_healing_feature_flags`
  - Used or combined with global `mortal_feature_flags`.

Quest/loot entries for:

- Restoration spellbooks.
- Profession recipes for tonics/foods.

---

## 9.2 C++ & Lua

C++:

- `MortalFlask.cpp`:
  - Flask cast handling.
- `MortalHealing.cpp` (new):
  - Hooks for Restoration scaling.
  - Optional:
    - Threat modifiers for heals.
- `MortalGuardCounter.cpp`:
  - (Already specced in `21-elden-systems`) integrates with heal timing if desired.

Lua:

- `MortalFlask.cpp/h (if implemented)` (C++ implementation)
- `MortalSpellLearning.cpp/h` (C++ implementation)
  - Registers spellbooks and checks requirements.
- `MortalFirstAid.cpp/h` (C++ implementation)
  - Alchemy/Cooking/Ritual integration.
- `zone_healing_rules.lua`
  - Optional special cases for certain zones/events.

MortalUI:

- Optional AIO integration:
  - `ui_restoration_panel.lua`:
    - Shows Restoration skill, known spells, and hints for where to learn more.
  - Tooltips for spellbooks and items with clear requirements.

---

# 10. Status

This file is the **authoritative design for healing and restoration** in Mortal Warcraft:

- Everyone gets **limited, tactical sustain** (Phial, food, bandages, campfires).
- True in-combat healing is **Restoration magic**, learned via books and gated by skills.
- Extra sustain comes from **Runes** and **Professions/Rituals**.
- Dungeons can remain mostly vanilla-tuned at first, with this healing model gradually informing future rebalancing.

