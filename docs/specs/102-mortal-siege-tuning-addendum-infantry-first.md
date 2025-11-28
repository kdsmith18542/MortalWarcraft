# Project Canvas: Mortal Warcraft Overhaul  
### File: 102-mortal-siege-tuning-addendum-infantry-first.md  
### Topic: Siege Tuning Addendum – Infantry-First Design, Vehicles as Support

> This addendum refines the **Wintergrasp → Mortal Stronghold Siege** design  
> to explicitly support players who prefer **character vs character combat**  
> over heavy reliance on siege vehicles.

It should be read alongside:

- `95-wintergrasp-to-mortal-siege-adaptation.md`
- `96-mortal-siege-signup-flow.md`
- `98-mortal-siege-prep-contracts.md`

---

## Related Specs

For full context on siege tuning, see:

- **`95-wintergrasp-to-mortal-siege-adaptation.md`** — Siege adaptation that this tuning refines
- **`96-mortal-siege-signup-flow.md`** — Siege signup flow that uses this tuning
- **`98-mortal-siege-prep-contracts.md`** — Siege prep contracts that provide siege supplies
- **`92-mortal-warfronts-siege-flow.md`** — Warfront and siege flow system
- **`02-combat.md`** — Combat mechanics used in infantry combat
- **`11-pvp-systems.md`** — PvP systems that apply to siege combat

---

## 1. Design Principle

**Sieges are about people first, engines second.**

- Siege engines are **force multipliers** and tools:
  - They accelerate wall/gate destruction,
  - They provide mobile cover and heavy damage.
- But:
  - Infantry can still participate meaningfully without touching a vehicle,
  - Sieges can be won or lost based on **player positioning, tactics, and small-unit play**, not just “who got more demolishers.”

---

## 2. Core Rules for Vehicles vs Infantry

### 2.1 Vehicles Cannot Win Alone

Constraints:

1. **Vehicles cannot capture objectives.**
   - Only players (on foot or mounted) can:
     - Capture flags,
     - Channel final Stronghold capture points,
     - Activate inner sanctum runes.

2. **Vehicles are vulnerable without infantry.**
   - Their vision and firing arcs are limited,
   - They are weak vs:
     - Dedicated anti-siege abilities,
     - Player bombs,
     - Flanking squads.

3. **Vehicles are finite.**
   - Limited by:
     - Siege supply stockpiles,
     - Siege Prep Contracts completed,
     - Workshop control.
   - Losing vehicles is economically painful (`98-mortal-siege-prep-contracts.md`).

Result:
- Even if a side has strong vehicle play, they still need:
  - Infantry to push through breaches,
  - Defenders to hold the inner keep,
  - Support roles to keep engines alive.

---

### 2.2 Infantry Have Independent Win Paths

To prevent “no vehicles, no game” situations, we add **infantry-only breach options**:

1. **Bomb Breach System**
   - Players can craft or earn **Siege Bombs** via Contracts.
   - Rules:
     - Bombs can be placed by infantry at designated weak spots on walls/gates.
     - Each bomb contributes significant structural damage.
   - Tuning:
     - A coordinated group of infantry (with enough bombs) can breach:
       - An outer gate section **without** any engines,
       - Given time and risk.

2. **Inside-Job Sabotage**
   - Saboteur-type Contracts allow:
     - Stealthy players to infiltrate and:
       - Open inner gates,
       - Disrupt workshop repairs,
       - Weaken key defenses.
   - Requires:
     - Players to reach inner objectives alive (high risk, high skill).

3. **Objective-Based Weakening**
   - Certain outer towers or shrines:
     - When destroyed/captured by infantry,
     - Apply stacking debuffs to the fortress:
       - Reduced wall HP,
       - Lower guard strength,
       - Slower gate repairs.

The goal is **not** to make engines redundant, but to ensure:
- A guild that is light on engine drivers but heavy on skilled infantry isn’t locked out of success.

---

## 3. Siege Roles for Non-Vehicle Players

To support players who don’t want to drive machines, we define clear, rewarding roles.

### 3.1 Vanguard / Shock Troops

- Focus:
  - Breach fights,
  - Choke points,
  - Flag captures.
- Toolkit:
  - High mobility and burst,
  - Brace/Guard Counter usage,
  - Stuns, knockbacks, and zoning abilities.
- Rewards:
  - High participation credit from:
    - Objective captures,
    - Player kills/assists near objectives.

### 3.2 Anti-Siege Specialists

- Focus:
  - Destroying enemy engines.
- Toolkit:
  - Siege Bombs,
  - Anti-vehicle abilities (snares, armor shreds),
  - High burst vs large targets.
- Rewards:
  - Extra credit for:
    - Engine kills,
    - Damage dealt to vehicles.

### 3.3 Saboteurs / Infiltrators

- Focus:
  - Behind-the-lines disruption.
- Toolkit:
  - Stealth,
  - Doors, levers, and weak spots only interactable by players,
  - Limited-use sabotage items.
- Rewards:
  - Bonus rewards for successful inner sabotage objectives:
    - Opening side gates,
    - Disabling key defenses.

### 3.4 Shrine & Flank Guards

- Focus:
  - Control of respawn shrines,
  - Holding side routes, tunnels, and ladders.
- Toolkit:
  - Strong sustain + control.
- Rewards:
  - Objective defence credit for:
    - Keeping shrines active,
    - Preventing enemy flanks.

### 3.5 Field Support (Healers & Buffers)

- Focus:
  - Keeping infantry alive on the front line,
  - Providing important buffs/debuffs.
- Rewards:
  - Assist credit,
  - Healing contribution,
  - Buff uptime in proximity to objectives.

---

## 4. Vehicle Tuning Guidelines

### 4.1 Damage & Durability

Vehicles should:

- Deal **high siege damage** (vs walls/gates),
- Deal **moderate** or even **low** damage vs players directly,
- Have:
  - Good HP vs ambient AoE,
  - Weaknesses vs anti-siege abilities and bombs.

Thus:

- Infantry combat remains lethal and dynamic,
- Vehicles are “siege tools,” not kill machines.

### 4.2 Cost & Availability

- Tied to `supply_stockpile` and **Siege Prep Contracts**:
  - More prep → more engines,
  - But still capped.
- Example:
  - Max 4–6 major engines, some lighter engines (catapults, etc),
  - No infinite respawn of top-tier vehicles.

---

## 5. Siege Map Variants & Vehicle Density

To account for player preference diversity:

### 5.1 Fortress Siege (Wintergrasp-Heavy)

- Classic fortress with:
  - Walls, towers, engines.
- Best for:
  - Big guild vs guild wars,
  - High-coordination battles.

### 5.2 Citadel Siege (Medium Engines)

- More emphasis on:
  - Doors, corridors, inner flags.
- Fewer:
  - Engine spawn points,
  - Wide open fields.

### 5.3 Field Stronghold (Low Engines)

- Almost entirely:
  - Infantry combat with barricades, fieldworks, and deployables.
- Engines:
  - Maybe 1–2 rams or carts as “super-siege-bombs,” not full vehicles.

This ensures:

- Players who hate heavy engine play can gravitate toward Field/Citadel sieges,
- Wintergrasp remains the “big showpiece” but not the only siege experience.

---

## 6. Communication to Players

To avoid misconceptions (“this is a vehicle game now”), we:

1. **Tutorial & Onboarding**
   - Shipwreck/Mainland NPCs explain:
     - “Engines help crack walls, but wars are decided by warriors.”
   - Siege intro text mentions:
     - Infantry roles, sabotage options, bombs.

2. **Wiki & Atlas**
   - Siege pages clearly state:
     - “Vehicles are optional force multipliers; infantry can breach via bombs and sabotage.”

3. **MortalUI Hints**
   - In siege overlay:
     - Show role hints:
       - “Bring bombs to breach weak sections.”
       - “Saboteurs wanted: lever objectives active behind enemy lines.”

---

## 7. Summary

This addendum guarantees that:

- **Sieges remain true to the fantasy of guilds clashing**, not just machines trading shots.
- Vehicles are powerful and important, but:
  - Cannot win by themselves,
  - Cannot hold or capture objectives,
  - Are limited in number, and vulnerable to coordinated infantry.
- Players who never want to touch a vehicle still have:
  - Frontline, anti-siege, sabotage, shrine guard, and full support roles,
  - With full access to rewards and impact on the outcome.

Implementers should treat this file as **binding constraints** when tuning Wintergrasp-based and future siege scenarios.
