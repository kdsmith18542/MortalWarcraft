# Specs 89-85: Review and Status

**Date:** 2025-01-XX  
**Status:** ✅ **REVIEWED**

---

## Spec 89: Wiki Structure ✅

**Status:** Documentation/Planning Only - No Code Implementation Needed

This spec defines the information architecture for the Mortal Atlas Game Wiki. It's a content organization document that outlines:
- Top-level navigation structure
- Page organization and cross-linking
- Content guidelines

**Implementation:** This is handled by the Atlas web portal team when creating wiki content. No C++ or game code changes required.

---

## Spec 88: Progression Era Map ✅

**Status:** Documentation/Planning Only - No Code Implementation Needed

This spec describes player progression through different "eras" (Hours 0-2, 2-10, 10-50, 50+). It's a design reference document that:
- Organizes existing systems into a temporal progression view
- Provides guidance for content placement
- Serves as a player-facing "What Now?" guide

**Implementation:** This is a reference document. The systems it describes are already implemented. No new code needed.

---

## Spec 87: Archetype Grid ✅

**Status:** Documentation/Planning Only - Explicitly No C++ Needed

This spec explicitly states: **"No new C++; this document consumes existing systems"** and **"Docs only: No new C++ for archetypes."**

It provides:
- Player-facing archetype descriptions
- WoW class → Mortal archetype mappings
- Stat spread examples
- Rune family suggestions

**Implementation:** MortalUI can optionally show build presets/suggestions based on this document. No core game code changes required.

---

## Spec 86: Factions and Standing ⚠️

**Status:** Partially Covered by Spec 99, Shrine Orders Deferred

This spec defines the foundational faction system. **Spec 99 (Faction Meta)** already implements:
- ✅ Civic Authority (as FACTION_CIVIC)
- ✅ Frontier Militia (as FACTION_FRONTIER)
- ✅ Cartel Syndicate (as FACTION_CARTEL)
- ✅ Atlas Consortium (as FACTION_ATLAS)

**Remaining from Spec 86:**
- ⚠️ **Shrine Orders** - Mentioned but not fully implemented
  - Would require separate faction IDs (SHRINE_ORDER_DAWN, SHRINE_ORDER_DUSK, etc.)
  - Effects: Flask efficiency, Shrine blessings, Warden gear access
  - **Note:** This is a significant system that may be implemented separately as part of Shrine system work

**Implementation Status:**
- Core faction system: ✅ Complete (via Spec 99)
- Shrine Orders: ⏸️ Deferred (requires Shrine system integration)

---

## Spec 85: Chat and Channels ⏳

**Status:** Requires Implementation

This spec requires a C++ module for global chat with:
- Zone restrictions (Red Zone radio silence)
- Progression requirements (onboarded, skill points)
- Rate limiting (15 second cooldown)
- Optional gold cost per message

**Required Implementation:**
1. Create `mod-mortal-chat` C++ module (fork of `mod-global-chat`)
2. Add zone risk checks (Green/Yellow/Red)
3. Add progression checks (onboarded flag, skill points)
4. Add rate limiting and optional gold cost
5. MortalUI integration (optional toggle for World Chat)

**Priority:** Medium - Global chat is useful but not critical for core gameplay

---

## Summary

| Spec | Status | Notes |
|------|--------|-------|
| 89 - Wiki Structure | ✅ Complete | Documentation only |
| 88 - Progression Era Map | ✅ Complete | Documentation only |
| 87 - Archetype Grid | ✅ Complete | Documentation only, no C++ |
| 86 - Factions and Standing | ⚠️ Partial | Core factions done (Spec 99), Shrine Orders deferred |
| 85 - Chat and Channels | ⏳ Pending | Requires C++ module implementation |

---

## Next Steps

1. **Spec 85 (Chat)**: Implement when global chat becomes a priority
2. **Shrine Orders (from Spec 86)**: Implement as part of Shrine system work
3. **Wiki Content (Spec 89)**: Atlas team can begin organizing content

All documentation-only specs (89, 88, 87) are complete and require no code changes.

