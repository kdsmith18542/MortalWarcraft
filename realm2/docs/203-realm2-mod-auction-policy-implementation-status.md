# Realm 2 Auction Policy Module - Implementation Status

**Module:** `mod_auction_policy_legacy`  
**Status:** In Progress  
**Date:** 2025-11-23

---

## ✅ Completed

1. **Database Schema** (`sql/01_create_tables.sql`)
   - `legacy_auction_usage` table for daily tracking
   - `legacy_commodity_items` table with 200+ common materials pre-populated
   - Herbs, ores, cloth, leather, enchanting mats, fish, trade goods

2. **Module Structure**
   - CMakeLists.txt configured
   - Config file template created (`config/mod_auction_policy_legacy.conf.dist`)
   - Header file structure (`src/LegacyAuctionPolicy.h`)

3. **Design Document**
   - Complete specification in `202-realm2-mod-auction-policy.md`

---

## 🚧 In Progress

1. **Core Implementation** (`src/LegacyAuctionPolicy.cpp`)
   - Singleton pattern
   - Config loading
   - Database queries
   - Policy enforcement logic
   - Daily usage tracking
   - Deposit/fee scaling calculations

2. **Script Hooks** (`src/LegacyAuctionPolicyScript.cpp`)
   - AuctionHouseScript for OnAuctionAdd hook
   - Policy validation before auction is finalized
   - Violation handling (remove auction, refund deposit)
   - Cancel fee scaling

3. **Module Loader** (`src/LegacyAuctionPolicyLoader.cpp`)
   - Script registration
   - Module initialization

---

## 📋 Remaining Tasks

1. Complete `LegacyAuctionPolicy.cpp` implementation:
   - Initialize() method
   - LoadConfig() method
   - LoadCommodityItems() method
   - CanCreateAuction() validation logic
   - Daily usage tracking with DB persistence
   - Deposit/fee multiplier calculations
   - Active auction counting queries

2. Complete `LegacyAuctionPolicyScript.cpp`:
   - AuctionHouseScript class
   - OnAuctionAdd() hook implementation
   - Policy checks and violation handling
   - Refund logic for rejected auctions
   - OnAuctionRemove() for cancel tracking

3. Complete `LegacyAuctionPolicyLoader.cpp`:
   - Module loader function
   - Script registration

4. **Testing & Integration:**
   - Build module
   - Test policy enforcement
   - Verify deposit scaling
   - Test commodity stack rules
   - Test daily limits

---

## 📝 Implementation Notes

### Key Challenge: Auction Creation Hook
The `OnAuctionAdd` hook is called AFTER the deposit is already taken. The implementation will:
1. Check policy in `OnAuctionAdd`
2. If violated, immediately remove the auction
3. Refund the deposit to the player
4. Send error message

### Database Queries Needed
- Count active auctions per character: `SELECT COUNT(*) FROM auction WHERE owner = ?`
- Count active auctions per account: Join with characters table
- Load daily usage: `SELECT * FROM legacy_auction_usage WHERE guid = ?`
- Update daily usage: `INSERT ... ON DUPLICATE KEY UPDATE`
- Count single-stack auctions: `SELECT COUNT(*) FROM auction WHERE owner = ? AND item_template = ? AND itemCount = 1`

### Configuration Integration
Module uses `sConfigMgr->GetOption<bool>("LegacyAuctionPolicy.Enable", false)` pattern.

---

## 🎯 Next Steps

1. Complete core implementation files
2. Build and test module
3. Integrate with Realm 2 worldserver
4. Test policy enforcement in-game
5. Document usage and configuration

---

**Estimated Completion:** Core implementation ~2-3 hours of focused work.

