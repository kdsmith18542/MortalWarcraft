package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// SearchMarket - Search market stalls and items
func (h *Handlers) SearchMarket(c *gin.Context) {
	query := c.Query("q")
	zoneID := c.Query("zone_id")
	itemID := c.Query("item_id")

	searchQuery := `
		SELECT 
			ms.id,
			ms.owner_guid,
			c.name as owner_name,
			ms.location_name,
			ms.zone_id,
			z.zone_name,
			msi.item_entry,
			it.name as item_name,
			msi.price_per_unit,
			msi.stock_quantity,
			zp.risk_tier
		FROM market_stalls ms
		INNER JOIN characters c ON ms.owner_guid = c.guid
		INNER JOIN zone_pvp_config zp ON ms.zone_id = zp.zone_id
		LEFT JOIN market_stall_items msi ON ms.id = msi.stall_id
		LEFT JOIN item_template it ON msi.item_entry = it.entry
		LEFT JOIN zones z ON ms.zone_id = z.zone_id
		WHERE ms.is_active = 1
	`

	args := []interface{}{}

	if query != "" {
		searchQuery += " AND (it.name LIKE ? OR c.name LIKE ? OR ms.location_name LIKE ?)"
		searchPattern := "%" + query + "%"
		args = append(args, searchPattern, searchPattern, searchPattern)
	}

	if zoneID != "" {
		if zid, err := strconv.Atoi(zoneID); err == nil {
			searchQuery += " AND ms.zone_id = ?"
			args = append(args, zid)
		}
	}

	if itemID != "" {
		if iid, err := strconv.Atoi(itemID); err == nil {
			searchQuery += " AND msi.item_entry = ?"
			args = append(args, iid)
		}
	}

	searchQuery += " ORDER BY msi.price_per_unit ASC LIMIT 100"

	rows, err := h.db.Query(searchQuery, args...)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to search market"})
		return
	}
	defer rows.Close()

	var items []models.MarketItem
	for rows.Next() {
		var item models.MarketItem
		var riskTier sql.NullString

		err := rows.Scan(
			&item.ItemEntry,
			&item.SellerName,
			&item.Location,
			&item.ZoneID,
			&item.Price,
			&item.Stock,
			&riskTier,
		)
		if err != nil {
			continue
		}

		if riskTier.Valid && riskTier.String == "RED" {
			item.IsRedZone = true
		}

		items = append(items, item)
	}

	c.JSON(http.StatusOK, gin.H{"items": items, "count": len(items)})
}

// GetPriceHistory - Get price history for an item
func (h *Handlers) GetPriceHistory(c *gin.Context) {
	itemID, err := strconv.Atoi(c.Param("itemId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid item ID"})
		return
	}

	days := 30
	if daysStr := c.Query("days"); daysStr != "" {
		if parsed, err := strconv.Atoi(daysStr); err == nil && parsed > 0 && parsed <= 365 {
			days = parsed
		}
	}

	// Query market stall sales history
	// This would need a market_stall_sales table for full implementation
	// For now, return placeholder data structure
	query := `
		SELECT 
			msi.item_entry,
			msi.price_per_unit,
			ms.updated_at
		FROM market_stall_items msi
		INNER JOIN market_stalls ms ON msi.stall_id = ms.id
		WHERE msi.item_entry = ? AND ms.updated_at > DATE_SUB(NOW(), INTERVAL ? DAY)
		ORDER BY ms.updated_at DESC
		LIMIT 100
	`

	rows, err := h.db.Query(query, itemID, days)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query price history"})
		return
	}
	defer rows.Close()

	var history []models.PriceHistory
	for rows.Next() {
		var ph models.PriceHistory
		var updatedAt time.Time

		err := rows.Scan(&ph.ItemEntry, &ph.Price, &updatedAt)
		if err != nil {
			continue
		}

		ph.Date = updatedAt
		ph.Volume = 1 // Would need actual volume data

		history = append(history, ph)
	}

	c.JSON(http.StatusOK, gin.H{"history": history})
}

// GetArbitrage - Find arbitrage opportunities
func (h *Handlers) GetArbitrage(c *gin.Context) {
	// Find items with price differences across zones
	query := `
		SELECT 
			msi.item_entry,
			it.name as item_name,
			MIN(msi.price_per_unit) as min_price,
			MAX(msi.price_per_unit) as max_price,
			(SELECT ms.zone_id FROM market_stalls ms 
			 INNER JOIN market_stall_items msi2 ON ms.id = msi2.stall_id 
			 WHERE msi2.item_entry = msi.item_entry AND msi2.price_per_unit = MIN(msi.price_per_unit) LIMIT 1) as buy_zone,
			(SELECT ms.zone_id FROM market_stalls ms 
			 INNER JOIN market_stall_items msi2 ON ms.id = msi2.stall_id 
			 WHERE msi2.item_entry = msi.item_entry AND msi2.price_per_unit = MAX(msi.price_per_unit) LIMIT 1) as sell_zone
		FROM market_stall_items msi
		INNER JOIN item_template it ON msi.item_entry = it.entry
		INNER JOIN market_stalls ms ON msi.stall_id = ms.id
		WHERE ms.is_active = 1
		GROUP BY msi.item_entry, it.name
		HAVING (MAX(msi.price_per_unit) - MIN(msi.price_per_unit)) > 1000
		ORDER BY (MAX(msi.price_per_unit) - MIN(msi.price_per_unit)) DESC
		LIMIT 20
	`

	rows, err := h.db.Query(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query arbitrage"})
		return
	}
	defer rows.Close()

	var opportunities []models.ArbitrageOpportunity
	for rows.Next() {
		var opp models.ArbitrageOpportunity
		var buyZone, sellZone sql.NullInt64
		var minPrice, maxPrice int64

		err := rows.Scan(
			&opp.ItemEntry,
			&opp.ItemName,
			&minPrice,
			&maxPrice,
			&buyZone,
			&sellZone,
		)
		if err != nil {
			continue
		}

		opp.BuyPrice = minPrice
		opp.SellPrice = maxPrice
		opp.Profit = maxPrice - minPrice

		// Determine risk level based on zones
		if buyZone.Valid && sellZone.Valid {
			// Check if zones are red zones
			var buyRisk, sellRisk string
			h.db.QueryRow("SELECT risk_tier FROM zone_pvp_config WHERE zone_id = ?", buyZone.Int64).Scan(&buyRisk)
			h.db.QueryRow("SELECT risk_tier FROM zone_pvp_config WHERE zone_id = ?", sellZone.Int64).Scan(&sellRisk)

			if buyRisk == "RED" || sellRisk == "RED" {
				opp.RiskLevel = "high"
			} else if buyRisk == "YELLOW" || sellRisk == "YELLOW" {
				opp.RiskLevel = "medium"
			} else {
				opp.RiskLevel = "low"
			}
		}

		opportunities = append(opportunities, opp)
	}

	c.JSON(http.StatusOK, gin.H{"opportunities": opportunities})
}

// GetMarketTrends - Get market trends
func (h *Handlers) GetMarketTrends(c *gin.Context) {
	timeRange := c.DefaultQuery("range", "7d") // "24h", "7d", "30d"
	limit := 20

	if limitStr := c.Query("limit"); limitStr != "" {
		if parsed, err := strconv.Atoi(limitStr); err == nil && parsed > 0 && parsed <= 100 {
			limit = parsed
		}
	}

	var timeFilter string
	switch timeRange {
	case "24h":
		timeFilter = "DATE_SUB(NOW(), INTERVAL 24 HOUR)"
	case "30d":
		timeFilter = "DATE_SUB(NOW(), INTERVAL 30 DAY)"
	default:
		timeFilter = "DATE_SUB(NOW(), INTERVAL 7 DAY)"
	}

	// Get most traded items (by volume)
	volumeQuery := `
		SELECT 
			item_entry,
			COUNT(*) as trade_count,
			SUM(quantity) as total_quantity,
			AVG(price_per_unit) as avg_price,
			MIN(price_per_unit) as min_price,
			MAX(price_per_unit) as max_price
		FROM market_stall_items
		WHERE created_at > ?
		GROUP BY item_entry
		ORDER BY trade_count DESC, total_quantity DESC
		LIMIT ?
	`

	rows, err := h.db.Query(volumeQuery, timeFilter, limit)
	if err != nil {
		// If table doesn't exist, return empty trends
		c.JSON(http.StatusOK, gin.H{
			"trending_items": []interface{}{},
			"price_changes": []interface{}{},
			"most_traded":   []interface{}{},
		})
		return
	}
	defer rows.Close()

	type TrendItem struct {
		ItemEntry   int     `json:"item_entry"`
		TradeCount  int     `json:"trade_count"`
		TotalQty    int     `json:"total_quantity"`
		AvgPrice    float64 `json:"avg_price"`
		MinPrice    float64 `json:"min_price"`
		MaxPrice    float64 `json:"max_price"`
		PriceChange float64 `json:"price_change_pct"`
	}

	var trending []TrendItem
	for rows.Next() {
		var item TrendItem
		err := rows.Scan(
			&item.ItemEntry, &item.TradeCount, &item.TotalQty,
			&item.AvgPrice, &item.MinPrice, &item.MaxPrice,
		)
		if err != nil {
			continue
		}

		// Calculate price change (simplified - would need historical data for real calculation)
		if item.MaxPrice > 0 && item.MinPrice > 0 {
			item.PriceChange = ((item.MaxPrice - item.MinPrice) / item.MinPrice) * 100
		}

		trending = append(trending, item)
	}

	// Get price changes (items with biggest price swings)
	priceChangeQuery := `
		SELECT 
			item_entry,
			AVG(CASE WHEN created_at > DATE_SUB(?, INTERVAL 1 DAY) THEN price_per_unit END) as recent_avg,
			AVG(CASE WHEN created_at <= DATE_SUB(?, INTERVAL 1 DAY) THEN price_per_unit END) as old_avg
		FROM market_stall_items
		WHERE created_at > ?
		GROUP BY item_entry
		HAVING recent_avg IS NOT NULL AND old_avg IS NOT NULL AND old_avg > 0
		ORDER BY ABS((recent_avg - old_avg) / old_avg) DESC
		LIMIT ?
	`

	rows2, err := h.db.Query(priceChangeQuery, timeFilter, timeFilter, timeFilter, limit)
	var priceChanges []TrendItem
	if err == nil {
		defer rows2.Close()
		for rows2.Next() {
			var item TrendItem
			var recentAvg, oldAvg sql.NullFloat64
			err := rows2.Scan(&item.ItemEntry, &recentAvg, &oldAvg)
			if err != nil {
				continue
			}
			if recentAvg.Valid && oldAvg.Valid && oldAvg.Float64 > 0 {
				item.AvgPrice = recentAvg.Float64
				item.PriceChange = ((recentAvg.Float64 - oldAvg.Float64) / oldAvg.Float64) * 100
				priceChanges = append(priceChanges, item)
			}
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"trending_items": trending,
		"price_changes":  priceChanges,
		"most_traded":    trending[:min(len(trending), 10)],
		"time_range":     timeRange,
	})
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

