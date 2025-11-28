# Spec 34: Mortal Arena and Rating - Verification

**Date:** 2025-01-XX  
**Status:** ⚠️ **~40% PRODUCTION COMPLETE** (1v1 duels only, missing 2v2/3v3/5v5 teams)

---

## Overview

Spec 34 defines the Arena PvP system with 2v2, 3v3, and 5v5 rated brackets, rating bands (P1-P6), weekly rewards, and season management. The current implementation only covers 1v1 ranked duels.

---

## Implementation Status

### ✅ **1v1 Duel System**

**C++ Implementation:**
- ✅ `azerothcore/modules/mortal_overhaul/src/MortalArenaSystem.cpp`
- ✅ `azerothcore/modules/mortal_overhaul/src/MortalArenaSystem.h`

**Features:**
- ✅ Ranked duel tracking
- ✅ ELO rating system
- ✅ Leaderboard system
- ✅ Rating change calculation
- ✅ Win/loss tracking

**Database:**
- ✅ `character_duel_rankings` table (SQL: `sql/12_arena_rankings.sql`)
  - Fields: `guid`, `rank`, `rating`, `wins`, `losses`, `last_updated`

### ⚠️ **Missing: 2v2/3v3/5v5 Arena Teams**

**What's Missing:**
- ❌ `mortal_arena_seasons` table
- ❌ `mortal_arena_team_rating` table (overlay on `arena_team`)
- ❌ `mortal_arena_rating_bands` table (P1-P6 bands)
- ❌ Season management system
- ❌ Weekly reward calculation
- ❌ Team rating/MMR tracking
- ❌ Personal participation tracking
- ❌ Rating band → P-tier mapping

**Spec Requirements:**
- ❌ 2v2 bracket (Duos)
- ❌ 3v3 bracket (Trios) - **primary competitive bracket**
- ❌ 5v5 bracket (Warbands)
- ❌ Team rating per bracket
- ❌ MMR (Matchmaking Rating) system
- ❌ Weekly token/credit rewards based on rating bands
- ❌ Season configuration and management

---

## Issues Found

### 1. Incomplete Arena System
- Only 1v1 duels implemented
- Missing core 2v2/3v3/5v5 team system
- Missing season management
- Missing weekly rewards

### 2. Missing Database Tables
- `mortal_arena_seasons` - Season configuration
- `mortal_arena_team_rating` - Team rating overlay
- `mortal_arena_rating_bands` - P1-P6 rating bands

### 3. Missing Integration
- No integration with AzerothCore's `arena_team` system
- No weekly reset/reward system
- No rating band → P-tier mapping

---

## What's Missing

1. ❌ **Arena Team System** - 2v2/3v3/5v5 teams
2. ❌ **Season Management** - Season configuration and tracking
3. ❌ **Rating Bands** - P1-P6 band definitions and mapping
4. ❌ **Weekly Rewards** - Token/credit payout system
5. ❌ **MMR System** - Matchmaking rating tracking
6. ❌ **Personal Participation** - Game participation tracking

---

## Production Readiness

**Status:** ⚠️ **~40% PRODUCTION COMPLETE**

- ✅ 1v1 Duel System: Complete
- ❌ 2v2/3v3/5v5 Teams: Not implemented
- ❌ Season System: Not implemented
- ❌ Weekly Rewards: Not implemented
- ❌ Rating Bands: Not implemented

**Note:** The 1v1 duel system is functional but the spec requires a full arena team system with multiple brackets, seasons, and weekly rewards. This is a significant gap.

