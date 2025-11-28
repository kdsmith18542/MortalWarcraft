# Heirloom → Transmog Conversion Recommendation

## Purpose

This document recommends repurposing WoW 3.3.5a **Heirloom items** as **Transmog appearance unlocks** rather than removing them entirely. This leverages the existing `mod-transmog` module and aligns with Mortal Warcraft's mission.

---

## Current Situation

### Heirlooms in Original WoW
- **Purpose**: Bind-on-account items that scale with level
- **Function**: Provide XP bonuses and starter gear
- **Problem**: No XP system in Mortal = heirlooms have no purpose

### Previous Recommendation
- **Decision**: Remove entirely
- **Rationale**: No XP system = no need for heirlooms

### New Opportunity
- **mod-transmog**: Already installed and supports heirloom items
- **Spec 57**: Appearance Codex system already designed
- **Mission Alignment**: Supports "Modern Retention & Social Systems" pillar

---

## Recommended Solution: Heirloom → Transmog Conversion

### Core Concept

Convert heirlooms from **stat-boosting starter gear** to **cosmetic appearance unlocks** that:
- Provide familiar, polished appearances
- Support cosmetic progression
- Create economy opportunities
- Don't break classless progression
- Leverage existing `mod-transmog` module

---

## Implementation Strategy

### 1. **Heirloom Items Become Transmog Unlocks**

**Conversion Process:**
- Remove all stat bonuses from heirloom items
- Convert to "Appearance Unlock" items
- When used, unlock the appearance in Appearance Codex
- Item is consumed (or becomes soulbound cosmetic item)

**Benefits:**
- Maintains WoW polish (familiar items)
- Supports cosmetic progression
- Creates collection goals
- No stat advantages (classless progression maintained)

### 2. **Leverage mod-transmog Module**

**Module Features We Can Use:**
- ✅ **Collection System**: `UseCollectionSystem = 1` (Legion-style)
- ✅ **Heirloom Support**: `AllowHeirloom = 1` (already enabled)
- ✅ **Token Cost**: Can require Appearance Tokens
- ✅ **Preset System**: Save transmog sets
- ✅ **Ignore Requirements**: `IgnoreReqClass = 1` (classless system)

**Integration:**
- Use `mod-transmog` as the base system
- Extend with Mortal's Appearance Codex (spec 57)
- Add Mortal-specific features (faction unlocks, seasonal rewards)

### 3. **Heirloom Acquisition & Distribution**

**Starter Heirlooms:**
- New players receive 1-2 heirloom transmog items
- Provides familiar starting appearance
- Creates early cosmetic progression goal

**Heirloom Rewards:**
- Task board rewards
- Faction standing rewards
- Seasonal event rewards
- Crafted items (heirloom recipes)

**Heirloom Trading:**
- Can be traded (economy opportunity)
- Can be sold on market stalls
- Creates economy loop

### 4. **Heirloom Appearance Categories**

**By Type:**
- **Starter Heirlooms**: Basic appearances (Common/Uncommon)
- **Faction Heirlooms**: Faction-themed appearances
- **Seasonal Heirlooms**: Event-specific appearances
- **Rare Heirlooms**: Premium appearances (Rare/Epic)

**By Source:**
- Starter rewards
- Faction vendors
- Task board rewards
- Crafted items
- Seasonal events

---

## Technical Implementation

### 1. **Database Changes**

**Convert Heirloom Items:**
```sql
-- Remove stat bonuses, keep appearance
UPDATE item_template 
SET Quality = 7, -- Heirloom quality (cosmetic)
    ItemLevel = 1,
    RequiredLevel = 1,
    -- Remove all stat bonuses
    stat_type1 = 0, stat_value1 = 0,
    -- ... etc
WHERE Quality = 7 AND Flags & 0x40000; -- Heirloom flag
```

**Appearance Codex Integration:**
```sql
-- Add heirloom appearances to Appearance Codex
INSERT INTO mortal_appearances (code, name, item_entry, slot_id, category, source_type, source_tag, rarity)
SELECT 
    CONCAT('HEIRLOOM_', entry, '_', name),
    name,
    entry,
    InventoryType,
    'ARMOR' or 'WEAPON',
    'STARTER' or 'FACTION' or 'SEASONAL',
    'HEIRLOOM',
    'COMMON' or 'UNCOMMON' or 'RARE'
FROM item_template
WHERE Quality = 7 AND Flags & 0x40000;
```

### 2. **mod-transmog Configuration**

**Recommended Settings:**
```ini
# Enable collection system (Legion-style)
Transmogrification.UseCollectionSystem = 1

# Allow heirlooms for transmog
Transmogrification.AllowHeirloom = 1

# Ignore class requirements (classless system)
Transmogrification.IgnoreReqClass = 1

# Ignore level requirements
Transmogrification.IgnoreReqLevel = 1

# Allow mixed armor types (classless system)
Transmogrification.AllowMixedArmorTypes = 1

# Token cost (Appearance Tokens)
Transmogrification.RequireToken = 1
Transmogrification.TokenEntry = [Appearance Token Item ID]
Transmogrification.TokenAmount = 1
```

### 3. **Integration with Spec 57**

**Appearance Codex Integration:**
- Heirloom items unlock appearances in `mortal_appearances`
- Unlocks tracked in `mortal_appearance_unlocks`
- Active transmog in `mortal_transmog_state`
- Use `mod-transmog` for visual application
- Use Mortal's Appearance Codex for collection tracking

---

## Benefits Analysis

### ✅ Mission Alignment

**Pillar 1: Classless, Skill-Driven Progression**
- ✅ No stat advantages (heirlooms are cosmetic only)
- ✅ No XP bonuses (removed)
- ✅ Supports skill-based progression

**Pillar 2: Risk-Based World**
- ✅ Transmog restrictions in Red zones (readability)
- ✅ Appearance unlocks create risk/reward (lose item = lose appearance unlock opportunity)

**Pillar 3: Player-Driven Economy**
- ✅ Heirloom items can be traded
- ✅ Appearance Tokens create economy sink
- ✅ Heirloom crafting creates economy loop

**Pillar 4: Emergent Gameplay**
- ✅ Heirloom collection goals
- ✅ Faction-themed heirlooms
- ✅ Seasonal heirloom events

**Pillar 5: Modern Retention & Social Systems**
- ✅ Cosmetic progression (long-term goals)
- ✅ Collection system (retention)
- ✅ Fashion/roleplay support

### ✅ Technical Benefits

- **Leverages Existing Module**: `mod-transmog` already installed
- **Reduces Development**: Use existing system, extend with Mortal features
- **Maintains Compatibility**: Works with AzerothCore
- **Extensible**: Can add Mortal-specific features

### ✅ Player Benefits

- **Familiar Items**: Keep WoW polish (heirlooms are iconic)
- **Cosmetic Progression**: Long-term collection goals
- **No Stat Advantages**: Fair progression
- **Economy Opportunities**: Trading, crafting, rewards

---

## Comparison: Remove vs Convert

| Aspect | Remove Heirlooms | Convert to Transmog |
|--------|------------------|---------------------|
| **WoW Polish** | ❌ Loses familiar items | ✅ Maintains familiar items |
| **Cosmetic Progression** | ❌ No benefit | ✅ Creates collection goals |
| **Economy** | ❌ No opportunity | ✅ Trading, crafting, rewards |
| **Development** | ✅ Simple (just remove) | ⚠️ Moderate (conversion work) |
| **Mission Alignment** | ⚠️ Neutral | ✅ Supports all pillars |
| **Player Retention** | ❌ No benefit | ✅ Long-term goals |

---

## Implementation Priority

### Season 1 Core
- ✅ Convert heirloom items to appearance unlocks
- ✅ Configure `mod-transmog` for Mortal
- ✅ Integrate with Appearance Codex (spec 57)
- ✅ Starter heirloom distribution

### Season 1.5
- ⚠️ Faction-themed heirlooms
- ⚠️ Seasonal heirloom events
- ⚠️ Heirloom crafting recipes

---

## Updated Recommendation

### Previous: Remove Heirlooms
**New: Convert Heirlooms to Transmog Appearance Unlocks**

**Rationale:**
1. **Better Mission Alignment**: Supports all 5 core pillars
2. **Leverages Existing Module**: `mod-transmog` already installed
3. **Maintains WoW Polish**: Keeps familiar, iconic items
4. **Creates Opportunities**: Economy, progression, retention
5. **No Stat Advantages**: Maintains classless progression

**Implementation:**
- Use `mod-transmog` as base system
- Convert heirlooms to appearance unlocks
- Integrate with Spec 57 (Appearance Codex)
- Add Mortal-specific features (faction, seasonal)

---

## Next Steps

1. **Review mod-transmog**: Verify compatibility with Mortal systems
2. **Update Spec 57**: Document heirloom conversion strategy
3. **Update Itemization Spec**: Document heirloom → transmog conversion
4. **Update Recommendations**: Change from "Remove" to "Convert to Transmog"
5. **Implementation Planning**: Design conversion process

---

## Conclusion

Converting heirlooms to transmog appearance unlocks is **superior to removing them** because it:
- ✅ Better aligns with Mortal's mission
- ✅ Leverages existing `mod-transmog` module
- ✅ Maintains WoW polish
- ✅ Creates economy and progression opportunities
- ✅ Supports all 5 core pillars

This is a **win-win solution** that preserves familiar content while fully supporting Mortal's classless, skill-based, sandbox vision.

