# AzerothCore Modules & 3.3.5a Addons Analysis

## Purpose

This document analyzes available AzerothCore modules and WoW 3.3.5a addons that can be embedded or leveraged for Mortal Warcraft customization. This research will inform final spec document updates.

**Workflow:**
1. ✅ Gap/feature analysis of original game and AzerothCore (COMPLETE)
2. 🔄 **Current Step:** AzerothCore modules and 3.3.5a addons analysis
3. ⏳ Document findings
4. ⏳ Finalize spec docs with all research

---

## AzerothCore Modules Analysis

### Currently Installed Modules

#### 1. **mod-aio** (AIO - AzerothCore IO)

**Purpose:** Pure Lua server-client communication system for Eluna and WoW.

**Key Features:**
- Server-to-client addon delivery
- Client-to-server messaging
- Addon caching system
- Code obfuscation and compression
- Frame position saving
- Saved variables (account/character bound)

**Mortal Warcraft Usage:**
- ✅ **Already Using:** Spec 20 (AIO UI Basics), Spec 14 (Admin Tools)
- ✅ **Perfect Fit:** Server-driven UI system aligns with our design
- ✅ **Opportunities:**
  - Task board UI (spec 76)
  - Warfront signup UI (spec 96)
  - Faction standing UI (spec 51)
  - Stronghold management UI (spec 08)
  - Mortal Control Panel (spec 14)

**Integration Status:**
- ✅ Installed and configured
- ✅ Used in `mortal_overhaul` module
- ✅ Examples available in `mod-aio/Examples/`

**Recommendation:** Continue leveraging AIO for all server-driven UI needs.

---

#### 2. **mod-eluna** (ALE - AzerothCore Lua Engine)

**Purpose:** AzerothCore-specific Lua scripting engine.

**Key Features:**
- Native AzerothCore integration
- Enhanced API beyond original Eluna
- Multiple Lua version support (LuaJIT, 5.2, 5.3, 5.4)
- Event hooks system
- Full server-side scripting

**Mortal Warcraft Usage:**
- ✅ **Already Using:** All Lua scripts in `mortal_overhaul/lua/`
- ✅ **Perfect Fit:** Core scripting infrastructure
- ✅ **Opportunities:**
  - All game mechanics (combat, economy, PvP, etc.)
  - Event system (spec 42)
  - World simulation (spec 12)
  - Dynamic tasks (spec 76)

**Integration Status:**
- ✅ Installed and configured
- ✅ All Mortal Lua scripts use ALE
- ⚠️ **Note:** ALE is NOT compatible with original Eluna (by design)

**Recommendation:** Continue using ALE as our Lua scripting foundation.

---

#### 3. **mod-autobalance**

**Purpose:** Scales instance mobs and bosses based on number of players.

**Key Features:**
- Dynamic health/mana/damage scaling
- Player count-based difficulty
- Inflection point curves
- Map-specific scaling
- Real-time combat adjustments
- Combat locking/unlocking

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Public dungeon scaling (spec 06)
- ⚠️ **Potential Use:** Extraction raid scaling (spec 74)
- ❌ **Not Applicable:** We have custom tier system (M-T1 to M-T5)
- ⚠️ **Consideration:** Could adapt for group size scaling in public dungeons

**Integration Status:**
- ✅ Installed but not configured
- ❌ Not currently used

**Recommendation:**
- **Evaluate:** Could be useful for public dungeon group scaling
- **Decision Needed:** Use AutoBalance or custom scaling system?
- **Action:** Test AutoBalance for public dungeon mechanics

---

#### 4. **mod-transmog**

**Purpose:** Transmogrification system for changing item appearance.

**Key Features:**
- Visual item appearance changes
- Cost-based transmog
- NPC-based interface
- Database-driven system

**Mortal Warcraft Usage:**
- ✅ **Already Designed:** Spec 57 (Appearance Codex and Transmog)
- ⚠️ **Potential Use:** Our transmog system could leverage this module
- ⚠️ **Consideration:** Need to adapt for our itemization system

**Integration Status:**
- ✅ Installed but not configured
- ❌ Not currently used

**Recommendation:**
- **Evaluate:** Review mod-transmog for compatibility with our transmog spec
- **Decision Needed:** Use mod-transmog or build custom?
- **Action:** Compare mod-transmog features with spec 57 requirements

---

#### 5. **mod-costumes**

**Purpose:** Temporary character morphing system.

**Key Features:**
- Item-based costume activation
- Display ID morphing
- Sound effects
- Scale modification
- Duration and cooldown system
- Database-driven configuration

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Event costumes (spec 42, 43)
- ⚠️ **Potential Use:** Seasonal content (spec 52)
- ⚠️ **Potential Use:** Faction trials (spec 59)
- ❌ **Not Critical:** Nice-to-have feature

**Integration Status:**
- ✅ Installed but not configured
- ❌ Not currently used

**Recommendation:**
- **Low Priority:** Consider for future event system
- **Action:** Document as optional enhancement

---

#### 6. **mod-anticheat**

**Purpose:** Anti-cheat and security system.

**Key Features:**
- Movement validation
- Speed hack detection
- Teleport detection
- Fly hack detection
- Water walking detection
- Configuration-based tuning

**Mortal Warcraft Usage:**
- ✅ **Already Designed:** Spec 40 (Anti-Bot, RMT, and Security)
- ⚠️ **Potential Use:** Security layer for our systems
- ⚠️ **Consideration:** May conflict with our custom movement systems

**Integration Status:**
- ✅ Installed but not configured
- ❌ Not currently used

**Recommendation:**
- **Evaluate:** Test compatibility with our systems
- **Decision Needed:** Use mod-anticheat or custom security?
- **Action:** Review mod-anticheat for false positives with our mechanics

---

### Additional AzerothCore Modules (Not Installed)

#### 7. **mod-playerbots** (Available but not installed)

**Purpose:** AI-controlled player bots for testing and solo play.

**Key Features:**
- Automated player bots
- Bot AI system
- Group formation
- Quest completion
- Combat AI

**Mortal Warcraft Usage:**
- ❌ **Not Applicable:** We have custom systems that may conflict
- ⚠️ **Potential Use:** Testing and development only

**Recommendation:**
- **Skip:** Not needed for production
- **Optional:** Could be useful for testing

---

#### 8. **mod-account-mounts** (Available but not installed)

**Purpose:** Account-wide mount system.

**Key Features:**
- Account-bound mounts
- Mount sharing across characters

**Mortal Warcraft Usage:**
- ❌ **Not Applicable:** We have living mounts system (spec 07, 28)
- ❌ **Conflicts:** Our mounts are items, not account-bound

**Recommendation:**
- **Skip:** Conflicts with our mount design

---

#### 9. **mod-solo-lfg** (Available but not installed)

**Purpose:** Solo dungeon finder system.

**Key Features:**
- Solo dungeon queue
- Instance scaling for solo play

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Delve system (spec 06)
- ⚠️ **Consideration:** Could adapt for safe solo PvE

**Recommendation:**
- **Evaluate:** Review for delve system compatibility
- **Action:** Research mod-solo-lfg features

---

#### 10. **mod-world-chat** (Available but not installed)

**Purpose:** Global world chat system.

**Key Features:**
- Cross-zone chat
- Global communication

**Mortal Warcraft Usage:**
- ❌ **Not Applicable:** We have regional chat restrictions (spec 85)
- ❌ **Conflicts:** Our design limits global communication

**Recommendation:**
- **Skip:** Conflicts with regional economy design

---

## WoW 3.3.5a Addons Analysis

### Client-Side Addons (Embeddable)

#### 1. **UI Enhancement Addons**

**Categories:**
- **Unit Frames:** XPerl, PitBull, Shadowed Unit Frames
- **Action Bars:** Bartender4, Dominos
- **Minimap:** SexyMap, Chinchilla
- **Bags:** Bagnon, AdiBags
- **Tooltips:** TipTac, TinyTooltip
- **Chat:** Prat, Chatter

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Client UI customization (spec 15)
- ⚠️ **Consideration:** Addon policy (spec 101) may restrict some
- ⚠️ **Opportunity:** Embed approved addons via AIO

**Recommendation:**
- **Evaluate:** Review addon policy (spec 101) for allowed addons
- **Action:** Create list of approved embeddable addons

---

#### 2. **Quest & Task Addons**

**Categories:**
- **Quest Trackers:** QuestHelper, Carbonite
- **Quest Logs:** EveryQuest, QuestGuru
- **Task Management:** LightHeaded, QuestCompletist

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Task board UI (spec 76)
- ⚠️ **Consideration:** Need to adapt for contract system
- ⚠️ **Opportunity:** Embed quest tracker for task board

**Recommendation:**
- **Evaluate:** Review quest addons for task board integration
- **Action:** Research embeddable quest tracker addons

---

#### 3. **Map & Navigation Addons**

**Categories:**
- **World Maps:** Mapster, Cartographer
- **Minimap Enhancements:** GatherMate, Routes
- **Waypoint Systems:** TomTom, Carbonite

**Mortal Warcraft Usage:**
- ✅ **Already Designed:** Spec 39 (Navigation and Wayfinding)
- ⚠️ **Potential Use:** Map pin system (spec 58)
- ⚠️ **Opportunity:** Embed map addon for navigation

**Recommendation:**
- **Evaluate:** Review map addons for wayfinding system
- **Action:** Research embeddable map addons compatible with our design

---

#### 4. **Inventory & Item Addons**

**Categories:**
- **Item Management:** Bagnon, AdiBags, ArkInventory
- **Item Tooltips:** Informant, ItemRack
- **Equipment:** Outfitter, ItemRack

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Inventory UI (spec 15)
- ⚠️ **Consideration:** Need to adapt for our item system
- ⚠️ **Opportunity:** Embed bag addon for better inventory

**Recommendation:**
- **Evaluate:** Review inventory addons for compatibility
- **Action:** Research embeddable inventory addons

---

#### 5. **Combat & Ability Addons**

**Categories:**
- **Combat Trackers:** Recount, Skada, Details!
- **Ability Cooldowns:** OmniCC, CooldownCount
- **Combat Alerts:** Deadly Boss Mods, BigWigs

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Combat UI (spec 02, 15)
- ⚠️ **Consideration:** Need to adapt for skill-based system
- ⚠️ **Opportunity:** Embed combat tracker for damage/healing

**Recommendation:**
- **Evaluate:** Review combat addons for skill system compatibility
- **Action:** Research embeddable combat addons

---

#### 6. **Social & Group Addons**

**Categories:**
- **Group Management:** oRA3, CT_RaidAssist
- **Guild Tools:** GuildInfo, GuildEventManager
- **Communication:** WIM, Prat

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Public grouping UI (spec 46)
- ⚠️ **Potential Use:** Guild management (spec 08)
- ⚠️ **Opportunity:** Embed group addon for public dungeons

**Recommendation:**
- **Evaluate:** Review social addons for public grouping
- **Action:** Research embeddable group management addons

---

#### 7. **Economy & Trading Addons**

**Categories:**
- **Auction House:** Auctioneer, Auctionator
- **Trade:** TradeSkillMaster, Skillet
- **Currency:** CurrencyTracker, MoneyFu

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Market stall UI (spec 04)
- ⚠️ **Consideration:** Need to adapt for regional economy
- ⚠️ **Opportunity:** Embed trading addon for market stalls

**Recommendation:**
- **Evaluate:** Review economy addons for market stall integration
- **Action:** Research embeddable trading addons

---

#### 8. **Profession & Crafting Addons**

**Categories:**
- **Crafting:** Skillet, AdvancedTradeSkillWindow
- **Gathering:** GatherMate, Routes
- **Professions:** TradeSkillMaster, CraftList

**Mortal Warcraft Usage:**
- ⚠️ **Potential Use:** Crafting UI (spec 05, 10)
- ⚠️ **Consideration:** Need to adapt for material lore system
- ⚠️ **Opportunity:** Embed crafting addon for better UI

**Recommendation:**
- **Evaluate:** Review crafting addons for material lore compatibility
- **Action:** Research embeddable crafting addons

---

## Integration Strategy

### Phase 1: Evaluate Existing Modules

1. **Test mod-autobalance** for public dungeon scaling
2. **Review mod-transmog** for compatibility with spec 57
3. **Evaluate mod-anticheat** for security integration
4. **Document** module capabilities and limitations

### Phase 2: Research Embeddable Addons

1. **Create approved addon list** based on spec 101 (Addon Policy)
2. **Test compatibility** with our systems
3. **Document integration** requirements
4. **Prioritize** addons by value

### Phase 3: Integration Planning

1. **Map modules/addons** to spec requirements
2. **Identify gaps** where custom code still needed
3. **Create integration specs** for each module/addon
4. **Update existing specs** with module/addon references

---

## Module Integration Recommendations

### High Priority

1. **mod-aio** ✅
   - **Status:** Already integrated
   - **Action:** Continue using for all server-driven UI

2. **mod-eluna** ✅
   - **Status:** Already integrated
   - **Action:** Continue using for all Lua scripting

3. **mod-transmog** ⚠️
   - **Status:** Installed, not configured
   - **Action:** Evaluate for spec 57 compatibility
   - **Decision:** Use module or build custom?

### Medium Priority

4. **mod-autobalance** ⚠️
   - **Status:** Installed, not configured
   - **Action:** Test for public dungeon scaling
   - **Decision:** Use for group scaling or custom?

5. **mod-anticheat** ⚠️
   - **Status:** Installed, not configured
   - **Action:** Test compatibility with our systems
   - **Decision:** Use module or custom security?

### Low Priority

6. **mod-costumes** ⚠️
   - **Status:** Installed, not configured
   - **Action:** Document for future event system
   - **Decision:** Optional enhancement

---

## Addon Integration Recommendations

### High Priority

1. **Map/Navigation Addons**
   - **Use Case:** Spec 39 (Navigation and Wayfinding)
   - **Action:** Research embeddable map addons
   - **Examples:** Mapster, Cartographer, TomTom

2. **Quest/Task Addons**
   - **Use Case:** Spec 76 (Dynamic Tasks and Contracts)
   - **Action:** Research embeddable quest trackers
   - **Examples:** QuestHelper, Carbonite

### Medium Priority

3. **Inventory Addons**
   - **Use Case:** Spec 15 (UI Client)
   - **Action:** Research embeddable bag addons
   - **Examples:** Bagnon, AdiBags

4. **Combat Addons**
   - **Use Case:** Spec 02 (Combat), Spec 15 (UI)
   - **Action:** Research embeddable combat trackers
   - **Examples:** Recount, Skada

### Low Priority

5. **Crafting Addons**
   - **Use Case:** Spec 05 (Crafting)
   - **Action:** Research embeddable crafting addons
   - **Examples:** Skillet, AdvancedTradeSkillWindow

---

## Next Steps

1. ✅ **Research embeddable addons** - COMPLETE: See `mortal-approved-addons-list.md`
2. **Test mod-autobalance** for public dungeon scaling
3. **Review mod-transmog** for spec 57 compatibility
4. **Create integration specs** for selected modules/addons
5. **Update existing specs** with module/addon references
6. **Document findings** in this analysis document

---

## Documentation Updates Needed

### Specs to Update with Module/Addon References

1. **Spec 15 (UI Client)** - Add addon policy and embeddable addons
2. **Spec 20 (AIO UI Basics)** - Document AIO usage
3. **Spec 57 (Appearance Codex)** - Reference mod-transmog if used
4. **Spec 06 (PvE)** - Reference mod-autobalance if used
5. **Spec 40 (Security)** - Reference mod-anticheat if used
6. **Spec 39 (Navigation)** - Reference map addons if embedded
7. **Spec 76 (Dynamic Tasks)** - Reference quest addons if embedded
8. **Spec 101 (Addon Policy)** - Create approved addon list

---

## Conclusion

**Modules Status:**
- ✅ **2 modules fully integrated:** mod-aio, mod-eluna
- ⚠️ **4 modules installed, need evaluation:** mod-autobalance, mod-transmog, mod-anticheat, mod-costumes
- 📋 **Multiple modules available but not installed**

**Addons Status:**
- 📋 **Research needed:** Embeddable addons for UI enhancement
- 📋 **Policy needed:** Approved addon list (spec 101)
- 📋 **Integration needed:** Addon embedding via AIO

**Key Findings:**
1. AIO and ALE are perfect fits and already integrated
2. Several modules available for evaluation
3. Many addons could enhance client UI
4. Need to balance module usage vs custom code
5. Addon policy needs to be finalized

**Recommendation:**
- Continue leveraging AIO/ALE
- Evaluate mod-transmog and mod-autobalance
- Research embeddable addons
- Update specs with module/addon references
- Create integration documentation

---

## References

- [AzerothCore Module Catalogue](https://www.azerothcore.org/catalogue.html)
- [mod-aio GitHub](https://github.com/Rochet2/AIO)
- [mod-eluna (ALE) GitHub](https://github.com/azerothcore/mod-ale)
- [WoW 3.3.5a Addons Repository](https://github.com/NoM0Re/WoW-3.3.5a-Addons)
- [Warmane Addon List](https://forum.warmane.com/showthread.php?t=377278)

