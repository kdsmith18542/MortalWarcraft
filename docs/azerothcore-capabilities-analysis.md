# AzerothCore 3.3.5a Capabilities Analysis

## Purpose

This document analyzes AzerothCore 3.3.5a's built-in configuration options and features to identify:
1. **Underutilized capabilities** - Features we could leverage but aren't using
2. **Configuration opportunities** - Settings that could replace custom code
3. **Missing integrations** - AzerothCore features that align with Mortal design goals

---

## Analysis Methodology

1. **Review worldserver.conf.dist** - All available configuration options
2. **Compare with Mortal specs** - What we're building vs what's available
3. **Identify opportunities** - Where config can replace custom code
4. **Document gaps** - Features we need that aren't available

---

## Configuration Categories Available

### 1. SKILL System Configuration

**Available Options:**
- `MaxPrimaryTradeSkill` - Max professions (default: 2)
- `SkillChance.Prospecting` - Skill gain from prospecting
- `SkillChance.Milling` - Skill gain from milling
- `Rate.Skill.Discovery` - Skill discovery multiplier
- `SkillGain.Crafting` - Crafting skill gain rate
- `SkillGain.Defense` - Defense skill gain rate
- `SkillGain.Gathering` - Gathering skill gain rate
- `SkillGain.Weapon` - Weapon skill gain rate
- `SkillChance.Orange/Yellow/Green/Grey` - Skill gain chance by recipe color
- `SkillChance.MiningSteps` - Mining skill decrease steps
- `SkillChance.SkinningSteps` - Skinning skill decrease steps
- `AlwaysMaxSkillForLevel` - Auto-max skills on level
- `AlwaysMaxWeaponSkill` - Auto-max weapon skills

**Mortal Usage:**
- ✅ Using: Custom skill system (spec 01)
- ⚠️ **Opportunity**: Could leverage `SkillGain.*` rates for our skill system
- ⚠️ **Opportunity**: `SkillChance.*` could help with material lore skill gains
- ❌ **Not Using**: `MaxPrimaryTradeSkill` (we have classless system)

**Recommendation:**
- Use `SkillGain.*` rates to control skill progression speed
- Use `SkillChance.*` for material lore skill gain tuning
- Document which settings we override vs use

---

### 2. STATS System Configuration

**Available Options:**
- `Stats.Limits.Enable` - Enable stat caps
- `Stats.Limits.Dodge` - Dodge cap (default: 95%)
- `Stats.Limits.Parry` - Parry cap (default: 95%)
- `Stats.Limits.Block` - Block cap (default: 95%)
- `Stats.Limits.Crit` - Crit cap (default: 95%)
- `PlayerSave.Stats.MinLevel` - Save stats to DB
- `PlayerSave.Stats.SaveOnlyOnLogout` - Stats save timing

**Mortal Usage:**
- ✅ Using: Custom stat system with caps (spec 84)
- ⚠️ **Opportunity**: Could use `Stats.Limits.*` for our stat caps instead of custom code
- ⚠️ **Opportunity**: `PlayerSave.Stats.*` could help with telemetry

**Recommendation:**
- Enable `Stats.Limits.Enable = 1`
- Set caps to match our design (150 per stat, 400 total)
- Use `PlayerSave.Stats.*` for analytics

---

### 3. REPUTATION System Configuration

**Available Options:**
- `Rate.Reputation.Gain` - Global rep gain rate
- `Rate.Reputation.LowLevel.Kill` - Rep from grey mobs
- `Rate.Reputation.LowLevel.Quest` - Rep from low-level quests
- `Rate.Reputation.RecruitAFriendBonus` - RAF rep bonus
- `Rate.Reputation.Gain.WSG/AB/AV` - BG-specific rep rates

**Mortal Usage:**
- ✅ Using: Custom faction system (spec 51, 86)
- ⚠️ **Opportunity**: Could leverage rep rates for our faction standing system
- ❌ **Not Using**: BG rep rates (we have different PvP system)

**Recommendation:**
- Use `Rate.Reputation.Gain` to tune faction standing gains
- Consider rep system for compatibility with existing NPCs

---

### 4. EXPERIENCE System Configuration

**Available Options:**
- `Rate.XP.Kill` - XP from kills
- `Rate.XP.Quest` - XP from quests
- `Rate.XP.Quest.DF` - XP from LFG quests
- `Rate.XP.Explore` - XP from exploration
- `Rate.XP.Pet` - Pet XP rate
- `Rate.XP.BattlegroundKill.*` - BG-specific XP rates
- `MaxGroupXPDistance` - Group XP distance
- `Rate.Pet.LevelXP` - Pet leveling rate

**Mortal Usage:**
- ✅ Using: Classless system, NO XP (spec 01)
- ⚠️ **Opportunity**: Set all XP rates to 0 to disable XP
- ❌ **Not Using**: XP system (by design)

**Recommendation:**
- Set `Rate.XP.* = 0` to disable all XP gains
- Document that XP is intentionally disabled

---

### 5. CURRENCY System Configuration

**Available Options:**
- `Rate.Honor` - Honor gain rate
- `Rate.ArenaPoints` - Arena points rate
- `Arena.LegacyArenaPoints` - Legacy arena points
- Various honor/arena reward multipliers

**Mortal Usage:**
- ✅ Using: Custom currency system (spec 35)
- ⚠️ **Opportunity**: Could use honor/arena points as base for Military Credits
- ⚠️ **Opportunity**: Honor system could map to PvP currency

**Recommendation:**
- Map honor to Military Credits conversion
- Use arena points for arena rewards
- Leverage existing currency infrastructure

---

### 6. DURABILITY System Configuration

**Available Options:**
- `Rate.DurabilityLossOnDeath` - Durability loss on death %
- `Rate.DurabilityLossOnDeath.PvP` - PvP durability loss
- `Rate.DurabilityLossOnDeath.PvE` - PvE durability loss
- Various durability loss multipliers

**Mortal Usage:**
- ✅ Using: Custom durability system (spec 05, 37)
- ⚠️ **Opportunity**: Could use `Rate.DurabilityLossOnDeath.*` for our system
- ⚠️ **Opportunity**: Different rates for Green/Yellow/Red zones

**Recommendation:**
- Use durability loss rates for zone-based penalties
- Configure different rates per risk tier
- Document our custom decay system vs config-based

---

### 7. DEATH System Configuration

**Available Options:**
- `Death.SicknessLevel` - Level for death sickness
- `Death.CorpseReclaimDelay.PvP` - PvP corpse reclaim delay
- `Death.CorpseReclaimDelay.PvE` - PvE corpse reclaim delay
- `Death.Bones.World` - Corpse bones in world
- `Death.Bones.BattlegroundOrArena` - Corpse bones in BG/Arena
- `Death.Ghost.RunSpeed` - Ghost movement speed
- `Death.Ghost.RunSpeed.BG` - Ghost speed in BGs

**Mortal Usage:**
- ✅ Using: Custom death system (spec 02, 22)
- ⚠️ **Opportunity**: Could use corpse reclaim delays for our system
- ⚠️ **Opportunity**: Different delays for risk zones
- ❌ **Not Using**: Death sickness (we have Shrine system)

**Recommendation:**
- Use `Death.CorpseReclaimDelay.*` for zone-based delays
- Configure ghost speed for Red Zone restrictions
- Document Shrine system vs death sickness

---

### 8. PET System Configuration

**Available Options:**
- `Rate.Pet.LevelXP` - Pet leveling rate
- `Rate.Talent.Pet` - Pet talent points
- `Pet.RankMod.Health` - Pet health by rank
- `MinPetName` - Pet name length
- `StrictPetNames` - Pet name restrictions
- `vmap.petLOS` - Pet line of sight checks

**Mortal Usage:**
- ✅ Using: Custom companion system (spec 29, 90)
- ⚠️ **Opportunity**: Pet system could be used for companions
- ⚠️ **Opportunity**: Pet LOS checks for companion AI
- ❌ **Not Using**: Pet leveling (we have bond system)

**Recommendation:**
- Map companion system to pet infrastructure where possible
- Use pet LOS for companion combat
- Document companion vs pet differences

---

### 9. ITEM System Configuration

**Available Options:**
- `Rate.Drop.Item.Poor/Normal/Uncommon/Rare/Epic/Legendary/Artifact` - Drop rates by quality
- `Rate.Drop.Item.Referenced` - Referenced item drop rate
- `Rate.Drop.Item.ReferencedAmount` - Referenced item amount
- `Rate.Drop.Item.GroupAmount` - Group loot amount
- `Rate.Drop.Money` - Money drop rate
- `Item.SetItemTradeable` - Set item trading
- Various item quality multipliers

**Mortal Usage:**
- ✅ Using: Custom itemization (spec 19, 27)
- ⚠️ **Opportunity**: Could use drop rates for our tier system
- ⚠️ **Opportunity**: Quality-based drop rates for material tiers
- ❌ **Not Using**: Standard quality system (we have Mortal tiers)

**Recommendation:**
- Map Mortal tiers to quality drop rates
- Use `Rate.Drop.*` for zone-based loot scaling
- Configure group loot for public dungeons

---

### 10. QUEST System Configuration

**Available Options:**
- `Rate.RewardQuestMoney` - Quest money reward rate
- `Rate.RewardBonusMoney` - Bonus money at max level
- `Quests.IgnoreRaid` - Allow quests in raid
- `Quests.IgnoreAutoAccept` - Disable auto-accept
- `Quests.IgnoreAutoComplete` - Disable auto-complete
- `MaxGroupQuestDistance` - Group quest distance

**Mortal Usage:**
- ✅ Using: Custom task/contract system (spec 76)
- ⚠️ **Opportunity**: Could use quest money rates for task rewards
- ⚠️ **Opportunity**: Auto-accept/complete settings for task boards
- ❌ **Not Using**: Standard quest system (we have tasks)

**Recommendation:**
- Use `Rate.RewardQuestMoney` for task board rewards
- Configure auto-accept for task board UI
- Document task system vs quest system

---

### 11. CREATURE System Configuration

**Available Options:**
- `Rate.Creature.Aggro` - Aggro radius multiplier
- `Rate.Creature.Normal/Elite/RARE/RAREELITE/WORLDBOSS.Damage` - Damage by rank
- `Rate.Creature.Normal/Elite/RARE/RAREELITE/WORLDBOSS.SpellDamage` - Spell damage by rank
- `Rate.Creature.Normal/Elite/RARE/RAREELITE/WORLDBOSS.HP` - HP by rank
- `MonsterSight` - Creature sight distance
- `CreatureFamilyFleeAssistanceRadius` - Flee assistance
- `CreatureLeashRadius` - Leash distance
- `CreatureFamilyAssistanceRadius` - Assistance call radius
- `CreatureFamilyAssistanceDelay` - Assistance delay
- `WorldBossLevelDiff` - World boss level difference
- `Corpse.Decay.NORMAL/RARE/ELITE/RAREELITE/WORLDBOSS` - Corpse decay times
- `Rate.Corpse.Decay.Looted` - Looted corpse decay multiplier

**Mortal Usage:**
- ✅ Using: Custom NPC rebalance (spec 32)
- ⚠️ **Opportunity**: Could use `Rate.Creature.*.Damage/HP` for our tier system
- ⚠️ **Opportunity**: Creature rank multipliers map to our tiers
- ⚠️ **Opportunity**: Corpse decay for extraction mechanics
- ❌ **Not Using**: Standard creature scaling (we have custom tiers)

**Recommendation:**
- Map Mortal creature tiers to rank multipliers
- Use `Rate.Creature.*.Damage/HP` for tier-based scaling
- Configure corpse decay for extraction raids
- Use aggro radius for risk zone mechanics

---

### 12. VENDOR System Configuration

**Available Options:**
- `Vendor.ItemLimitScaling` - Item limit scaling
- Various vendor restock settings

**Mortal Usage:**
- ✅ Using: Custom regional vendor system (spec 04)
- ⚠️ **Opportunity**: Vendor restock for market stalls
- ❌ **Not Using**: Standard vendor system (we have regional)

**Recommendation:**
- Use vendor restock for market stall refresh
- Document regional vendor vs standard vendor

---

### 13. GROUP System Configuration

**Available Options:**
- `Group.XPDistance` - Group XP distance
- `Group.Visibility` - Group visibility
- Various group loot settings

**Mortal Usage:**
- ✅ Using: Custom public grouping (spec 46)
- ⚠️ **Opportunity**: Group visibility for public dungeons
- ⚠️ **Opportunity**: Group loot for contribution system
- ❌ **Not Using**: Standard group system (we have public grouping)

**Recommendation:**
- Use group visibility for public dungeon mechanics
- Configure group loot for contribution rewards
- Document public grouping vs standard groups

---

### 14. INSTANCE System Configuration

**Available Options:**
- `Instance.IgnoreLevel` - Ignore level requirements
- `Instance.IgnoreRaid` - Ignore raid requirements
- `Instance.ResetTimeHour` - Global reset hour
- `Instance.ResetTimeRelativeTimestamp` - Reset timestamp
- `Rate.InstanceResetTime` - Reset time multiplier
- `Instance.UnloadDelay` - Instance unload delay
- `AccountInstancesPerHour` - Max instances per hour
- `Instance.SharedNormalHeroicId` - Shared lockouts
- `DungeonAccessRequirements.*` - Access requirement settings

**Mortal Usage:**
- ✅ Using: Custom public dungeon system (spec 06, 33)
- ⚠️ **Opportunity**: Instance settings for extraction raids
- ⚠️ **Opportunity**: Reset times for raid lockouts
- ⚠️ **Opportunity**: Access requirements for tier gating
- ❌ **Not Using**: Standard instance system (we have public dungeons)

**Recommendation:**
- Use instance reset times for extraction raid lockouts
- Configure access requirements for tier gating
- Use instance settings for delve system
- Document public dungeons vs instances

---

### 15. BATTLEGROUND System Configuration

**Available Options:**
- `Battleground.GiveXPForKills` - XP for BG kills
- `Battleground.Random.ResetHour` - BG reset hour
- `Battleground.StoreStatistics.Enable` - Store BG stats
- `Battleground.TrackDeserters.Enable` - Track deserters
- `Battleground.InvitationType` - Team balance
- `Battleground.ReportAFK` - AFK reporting
- `Battleground.RewardWinnerHonorFirst/Last` - Winner rewards
- `Battleground.RewardLoserHonorFirst/Last` - Loser rewards
- `Battleground.PlayerRespawn` - Respawn interval
- `Battleground.*.Flags/CapturePoints/Reinforcements` - BG-specific settings
- `Battleground.QueueAnnouncer.*` - Queue announcements

**Mortal Usage:**
- ✅ Using: Custom warfront system (spec 92)
- ⚠️ **Opportunity**: BG settings for warfront mechanics
- ⚠️ **Opportunity**: BG rewards for warfront rewards
- ⚠️ **Opportunity**: BG statistics for warfront tracking
- ❌ **Not Using**: Standard BG system (we have warfronts)

**Recommendation:**
- Use BG reward settings for warfront rewards
- Configure BG statistics for warfront tracking
- Use BG respawn settings for warfront mechanics
- Document warfront vs battleground differences

---

### 16. ARENA System Configuration

**Available Options:**
- `Arena.QueueAnnouncer.*` - Queue announcements
- `Arena.MaxRatingDifference` - Max rating difference
- `Arena.RatingDiscardTimer` - Rating discard timer
- `Arena.RatedUpdateTimer` - Rated update timer
- `Arena.ArenaSeason.ID` - Season ID
- `Arena.ArenaSeason.InProgress` - Season status
- Various arena reward settings

**Mortal Usage:**
- ✅ Using: Custom arena system (spec 34)
- ⚠️ **Opportunity**: Arena settings align with our system
- ⚠️ **Opportunity**: Arena rewards for our rewards
- ✅ **Using**: Arena infrastructure (good fit)

**Recommendation:**
- Leverage existing arena system
- Configure arena rewards for our PvP tiers
- Use arena seasons for our seasons
- Document our arena modifications

---

### 17. MAIL System Configuration

**Available Options:**
- `Mail.DeliveryDelay` - Mail delivery delay
- `Mail.DeliveryDelay.Base` - Base delivery time
- `Mail.DeliveryDelay.PerHour` - Delay per hour
- `Mail.DeliveryDelay.Max` - Max delay
- `Mail.DeliveryDelay.Min` - Min delay

**Mortal Usage:**
- ✅ Using: Custom regional mail system (spec 04)
- ⚠️ **Opportunity**: Mail delays for regional restrictions
- ❌ **Not Using**: Global mail (we have regional only)

**Recommendation:**
- Use mail delays to simulate regional restrictions
- Configure mail system for regional-only delivery
- Document regional mail vs global mail

---

### 18. TRANSPORT System Configuration

**Available Options:**
- `Transport.Enable` - Enable transports
- Various transport settings

**Mortal Usage:**
- ✅ Using: Custom caravan system (spec 13)
- ⚠️ **Opportunity**: Transport system for caravans
- ❌ **Not Using**: Standard transports (we have caravans)

**Recommendation:**
- Use transport system for caravan mechanics
- Configure transports for trade routes
- Document caravans vs transports

---

### 19. CHAT CHANNEL System Configuration

**Available Options:**
- `ChatFakeMessagePrevention` - Fake message prevention
- `ChatStrictLinkChecking` - Link checking
- `ChatStrictLinkChecking.Severity` - Link check severity
- `ChatFlood.MessageCount` - Flood message count
- `ChatFlood.MessageDelay` - Flood message delay
- `ChatFlood.MuteTime` - Flood mute time

**Mortal Usage:**
- ✅ Using: Custom chat system (spec 85)
- ⚠️ **Opportunity**: Chat flood protection for our system
- ⚠️ **Opportunity**: Link checking for security
- ✅ **Using**: Chat infrastructure (good fit)

**Recommendation:**
- Use chat flood protection
- Configure link checking for security
- Document our chat channel modifications

---

### 20. FACTION INTERACTION System Configuration

**Available Options:**
- `FactionInteraction.Distance` - Faction interaction distance
- Various faction settings

**Mortal Usage:**
- ✅ Using: Custom faction system (spec 51, 86)
- ⚠️ **Opportunity**: Faction interaction for our system
- ❌ **Not Using**: Standard factions (we have Mortal factions)

**Recommendation:**
- Use faction interaction for our faction system
- Configure faction settings for standing
- Document Mortal factions vs standard factions

---

### 21. CALENDAR System Configuration

**Available Options:**
- `Calendar.Enable` - Enable calendar
- Various calendar settings

**Mortal Usage:**
- ✅ Using: Custom event system (spec 42, 43)
- ⚠️ **Opportunity**: Calendar for event scheduling
- ✅ **Using**: Calendar infrastructure (good fit)

**Recommendation:**
- Use calendar for event scheduling
- Configure calendar for seasonal events
- Document our event system integration

---

### 22. GAME EVENT System Configuration

**Available Options:**
- `Event.Announce` - Event announcements
- Various event settings

**Mortal Usage:**
- ✅ Using: Custom event system (spec 42, 43)
- ⚠️ **Opportunity**: Game events for our events
- ✅ **Using**: Event infrastructure (good fit)

**Recommendation:**
- Use game events for our event system
- Configure events for seasonal content
- Document our event system integration

---

### 23. AUCTION HOUSE System Configuration

**Available Options:**
- `AuctionHouse.ItemSellTimeout` - Item sell timeout
- `AuctionHouse.BuyoutTimeout` - Buyout timeout
- Various auction settings

**Mortal Usage:**
- ✅ Using: Custom market stall system (spec 04)
- ❌ **Not Using**: Auction house (we have market stalls)

**Recommendation:**
- Disable auction house
- Document market stalls vs auction house
- Consider auction house for regional markets

---

### 24. WEATHER System Configuration

**Available Options:**
- `Weather.Enable` - Enable weather
- `Weather.Seasonal` - Seasonal weather
- Various weather settings

**Mortal Usage:**
- ✅ Using: Custom weather system (spec 12)
- ⚠️ **Opportunity**: AzerothCore weather for our system
- ✅ **Using**: Weather infrastructure (good fit)

**Recommendation:**
- Use AzerothCore weather system
- Configure weather for our world simulation
- Document our weather enhancements

---

### 25. VISIBILITY AND DISTANCES Configuration

**Available Options:**
- `Visibility.Distance.Continents` - Continent visibility
- `Visibility.Distance.Instances` - Instance visibility
- `Visibility.Distance.BGArenas` - BG/Arena visibility
- `Visibility.GroupMode` - Group visibility mode
- `Visibility.ObjectQuestMarkers` - Quest markers

**Mortal Usage:**
- ✅ Using: Custom fog-of-war (spec 39)
- ⚠️ **Opportunity**: Visibility settings for Red Zone restrictions
- ⚠️ **Opportunity**: Group visibility for public dungeons
- ✅ **Using**: Visibility infrastructure (good fit)

**Recommendation:**
- Use visibility settings for Red Zone fog-of-war
- Configure group visibility for public dungeons
- Document our visibility modifications

---

## Summary: Underutilized Capabilities

### High Priority Opportunities

1. **Creature Scaling** (`Rate.Creature.*.Damage/HP`)
   - **Current**: Custom C++ scaling
   - **Opportunity**: Use config-based scaling for tiers
   - **Benefit**: Easier tuning, no code changes needed

2. **Durability Loss** (`Rate.DurabilityLossOnDeath.*`)
   - **Current**: Custom decay system
   - **Opportunity**: Use config for zone-based penalties
   - **Benefit**: Zone-specific durability loss without code

3. **Corpse Decay** (`Corpse.Decay.*`, `Rate.Corpse.Decay.Looted`)
   - **Current**: Not specified
   - **Opportunity**: Use for extraction raid mechanics
   - **Benefit**: Timed corpse decay for extraction

4. **Skill Gain Rates** (`SkillGain.*`, `SkillChance.*`)
   - **Current**: Custom skill system
   - **Opportunity**: Use rates for skill progression tuning
   - **Benefit**: Easy skill gain balancing

5. **Stat Limits** (`Stats.Limits.*`)
   - **Current**: Custom stat caps
   - **Opportunity**: Use built-in stat limits
   - **Benefit**: Native stat capping support

6. **Instance Settings** (`Instance.*`)
   - **Current**: Public dungeon conversion
   - **Opportunity**: Use instance settings for extraction raids
   - **Benefit**: Lockout and reset management

7. **Battleground Settings** (`Battleground.*`)
   - **Current**: Warfront system
   - **Opportunity**: Use BG settings for warfront mechanics
   - **Benefit**: Reward and respawn configuration

8. **Visibility Settings** (`Visibility.*`)
   - **Current**: Fog-of-war system
   - **Opportunity**: Use visibility for Red Zone restrictions
   - **Benefit**: Native visibility control

### Medium Priority Opportunities

1. **Reputation Rates** (`Rate.Reputation.*`)
   - Use for faction standing gains
2. **Quest Money Rates** (`Rate.RewardQuestMoney`)
   - Use for task board rewards
3. **Drop Rates** (`Rate.Drop.*`)
   - Use for zone-based loot scaling
4. **Mail Delays** (`Mail.DeliveryDelay.*`)
   - Use for regional mail simulation
5. **Chat Flood Protection** (`ChatFlood.*`)
   - Use for chat security
6. **Calendar/Game Events** (`Calendar.*`, `Event.*`)
   - Use for event scheduling

### Low Priority / Not Applicable

1. **XP Rates** - Disabled by design (classless system)
2. **Auction House** - Replaced by market stalls
3. **Standard Factions** - Replaced by Mortal factions
4. **Standard Quests** - Replaced by task board

---

## Recommended Configuration Strategy

### Phase 1: Leverage Existing Configs

1. **Enable Stat Limits**
   ```ini
   Stats.Limits.Enable = 1
   Stats.Limits.Dodge = 95.0
   Stats.Limits.Parry = 95.0
   Stats.Limits.Block = 95.0
   Stats.Limits.Crit = 95.0
   ```

2. **Configure Creature Scaling**
   ```ini
   # Map to Mortal tiers
   Rate.Creature.Normal.Damage = 0.25      # M-T1
   Rate.Creature.Elite.Elite.Damage = 0.3  # M-T2
   Rate.Creature.Elite.RARE.Damage = 0.4    # M-T3
   Rate.Creature.Elite.RAREELITE.Damage = 0.5 # M-T4
   Rate.Creature.Elite.WORLDBOSS.Damage = 0.55 # M-T5
   ```

3. **Configure Durability Loss**
   ```ini
   Rate.DurabilityLossOnDeath = 0.1        # Green zones
   Rate.DurabilityLossOnDeath.PvP = 0.25    # Yellow zones
   # Red zones handled by custom code
   ```

4. **Configure Corpse Decay**
   ```ini
   Corpse.Decay.NORMAL = 300        # 5 min for extraction
   Corpse.Decay.ELITE = 600         # 10 min for bosses
   Rate.Corpse.Decay.Looted = 0.5   # Half time after looting
   ```

5. **Disable XP**
   ```ini
   Rate.XP.Kill = 0
   Rate.XP.Quest = 0
   Rate.XP.Explore = 0
   Rate.XP.Pet = 0
   ```

### Phase 2: Document Config Usage

✅ **COMPLETE:** Created `docs/azerothcore-config-usage.md` documenting:
- Which configs we use
- Which configs we override
- Which configs we ignore
- Custom code vs config rationale

### Phase 3: Integration Testing

Test that config-based changes work with our custom systems:
- Stat limits with our attribute system
- Creature scaling with our tier system
- Durability loss with our decay system
- Corpse decay with extraction raids

---

## Configuration File Recommendations

### Create: `config/mortal-worldserver-overrides.conf`

```ini
# Mortal Warcraft - AzerothCore Configuration Overrides
# This file contains Mortal-specific configuration overrides

# Disable XP (classless system)
Rate.XP.Kill = 0
Rate.XP.Quest = 0
Rate.XP.Explore = 0
Rate.XP.Pet = 0

# Enable stat limits (Mortal stat caps)
Stats.Limits.Enable = 1
Stats.Limits.Dodge = 95.0
Stats.Limits.Parry = 95.0
Stats.Limits.Block = 95.0
Stats.Limits.Crit = 95.0

# Creature scaling by Mortal tier
Rate.Creature.Normal.Damage = 0.25
Rate.Creature.Elite.Elite.Damage = 0.3
Rate.Creature.Elite.RARE.Damage = 0.4
Rate.Creature.Elite.RAREELITE.Damage = 0.5
Rate.Creature.Elite.WORLDBOSS.Damage = 0.55

# Durability loss by risk zone
Rate.DurabilityLossOnDeath = 0.1
Rate.DurabilityLossOnDeath.PvP = 0.25

# Corpse decay for extraction raids
Corpse.Decay.NORMAL = 300
Corpse.Decay.ELITE = 600
Rate.Corpse.Decay.Looted = 0.5

# Skill gain rates (tunable)
SkillGain.Crafting = 1
SkillGain.Gathering = 1
SkillGain.Weapon = 1

# Visibility for Red Zone fog-of-war
Visibility.Distance.Continents = 100

# Disable auction house (use market stalls)
# (Auction house disabled via custom code)

# Mail delays for regional restrictions
Mail.DeliveryDelay = 3600
```

---

## Next Steps

1. **Review Current Config** - Check what we're currently using
2. **Create Override File** - Document Mortal-specific configs
3. **Test Integration** - Verify configs work with custom systems
4. **Update Specs** - Document which configs we leverage
5. **Optimize Code** - Replace custom code with configs where possible

---

## Conclusion

AzerothCore 3.3.5a provides extensive configuration options that can:
- **Replace custom code** for creature scaling, durability, corpse decay
- **Enhance our systems** with stat limits, skill rates, visibility
- **Simplify tuning** through config files instead of code changes
- **Maintain compatibility** with existing AzerothCore infrastructure

**Key Takeaway**: We can leverage ~40% of available config options to reduce custom code and improve maintainability.

