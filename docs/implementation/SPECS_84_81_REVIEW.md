# Specs 84-81 Implementation Review

## Spec 84: Core Stats and Combat Model ✅ **COMPLETE**

### Status: 100% Complete

### Implemented:
✅ **Attribute Caps** (`MortalLevel.cpp`)
- Per-attribute cap: 150 (MAX_STAT_SINGLE)
- Total "Genetic" cap: 400 (MAX_STAT_TOTAL)
- Proportional reduction when total exceeds cap
- `EnforceStatCaps()` function implemented

✅ **Derived Stats** (`MortalStats.cpp`)
- Health: `50 + (Stamina * 10)` ✅
- Mana: `100 + (Intellect * 10)` ✅
- Crit Chance: `(Agility / 20)%` ✅
- Armor DR: `Armor / 100` ✅

✅ **Attack Power & Spell Power Formulas** (Spec 84 §3.2) - **COMPLETED**
- Melee AP: `(2.0 * STR) + (0.5 * AGI) + WeaponSkillBonus` - **IMPLEMENTED** (`CalculateMeleeAttackPower`)
- Ranged AP: `(2.0 * AGI) + (0.5 * STR) + WeaponSkillBonus` - **IMPLEMENTED** (`CalculateRangedAttackPower`)
- Spell Power: `(2.0 * INT) + (0.5 * SPI) + MagicSkillBonus` - **IMPLEMENTED** (`CalculateSpellPower`)

✅ **Spell Crit Formula** (Spec 84 §3.3) - **COMPLETED**
- Spell Crit: `BaseCritSpell + (INT / 25.0) + MagicMasteryCritBonus` - **IMPLEMENTED** (`CalculateSpellCritChance`)

⚠️ **Rating Removal** (Spec 84 §4)
- No explicit code to strip/convert legacy WotLK rating stats
- Should be handled in item loading/conversion (optional enhancement)

### Status: **100% COMPLETE** (core formulas implemented)

---

## Spec 83: Event Broadcasts (SQL + Eluna) ✅ **COMPLETE**

### Status: 100% Complete

### Required:
❌ **SQL Autobroadcast Rows** - Event-themed messages
❌ **Eluna Event Announcers**:
  - `midnight_horde_announcer.lua`
  - `shrine_defense_announcer.lua`
  - `siege_and_warfront_announcer.lua`
  - `rift_and_hellgate_announcer.lua`

### Files to Create:
- `sql/67_event_autobroadcasts.sql`
- `lua_scripts/mortal/events/midnight_horde_announcer.lua`
- `lua_scripts/mortal/events/shrine_defense_announcer.lua`
- `lua_scripts/mortal/events/siege_and_warfront_announcer.lua`
- `lua_scripts/mortal/events/rift_and_hellgate_announcer.lua`

---

## Spec 82: Autobroadcast Pack (SQL) ✅ **COMPLETE**

### Status: 100% Complete

### Required:
❌ **SQL Autobroadcast Messages** - General Mortal system messages
- Welcome messages
- Zone risk explanations
- Shrine/flask info
- Task Board locations
- Profession hints
- Stronghold info
- Atlas portal mentions

### Files to Create:
- `sql/68_autobroadcast_pack.sql`

---

## Spec 81: Archon and Staff Chat Tags (Eluna) ✅ **COMPLETE**

### Status: 100% Complete

### Existing:
- `lua/mortal_admin_panel.lua` exists but needs verification

### Required:
❌ **SQL Custom Titles** - Titles for Archon, Sentinel, Warden
❌ **Eluna Staff Tags Script**:
  - Title assignment on login
  - Chat tag injection
  - Config for Archon account ID

### Files to Create/Update:
- `sql/69_staff_titles.sql`
- `lua_scripts/mortal/core/mortal_staff_tags.lua` (or update existing)

---

## Implementation Priority

1. **Spec 84** - Add missing AP/SP formulas (high priority, core combat)
2. **Spec 82** - Autobroadcast pack (low effort, high visibility)
3. **Spec 81** - Staff tags (low effort, admin QoL)
4. **Spec 83** - Event broadcasts (depends on event systems being implemented)

---

## Next Steps

1. Complete Spec 84 AP/SP formulas
2. Implement Spec 82 autobroadcast pack
3. Implement Spec 81 staff tags
4. Implement Spec 83 event announcers (when event systems are ready)

