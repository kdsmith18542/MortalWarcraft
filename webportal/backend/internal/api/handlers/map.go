package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// GetHotspots - Get PvP kill hotspots
func (h *Handlers) GetHotspots(c *gin.Context) {
	timeRange := c.DefaultQuery("range", "24h") // "24h", "week", "month"
	limit := 50

	if limitStr := c.Query("limit"); limitStr != "" {
		if parsed, err := strconv.Atoi(limitStr); err == nil && parsed > 0 && parsed <= 200 {
			limit = parsed
		}
	}

	var timeFilter string
	switch timeRange {
	case "week":
		timeFilter = "DATE_SUB(NOW(), INTERVAL 7 DAY)"
	case "month":
		timeFilter = "DATE_SUB(NOW(), INTERVAL 30 DAY)"
	default:
		timeFilter = "DATE_SUB(NOW(), INTERVAL 24 HOUR)"
	}

	query := `
		SELECT 
			k.zone_id,
			z.zone_name,
			ROUND(AVG(k.kill_x), 2) as avg_x,
			ROUND(AVG(k.kill_y), 2) as avg_y,
			COUNT(*) as death_count
		FROM pvp_killboard k
		LEFT JOIN zones z ON k.zone_id = z.zone_id
		WHERE k.kill_time > ?
		GROUP BY k.zone_id, z.zone_name
		ORDER BY death_count DESC
		LIMIT ?
	`

	rows, err := h.db.Query(query, timeFilter, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query hotspots"})
		return
	}
	defer rows.Close()

	var hotspots []models.Hotspot
	for rows.Next() {
		var hotspot models.Hotspot

		err := rows.Scan(
			&hotspot.ZoneID,
			&hotspot.ZoneName,
			&hotspot.X,
			&hotspot.Y,
			&hotspot.DeathCount,
		)
		if err != nil {
			continue
		}

		hotspot.TimeRange = timeRange
		hotspots = append(hotspots, hotspot)
	}

	c.JSON(http.StatusOK, gin.H{"hotspots": hotspots})
}

// GetResources - Get resource node locations (if tracked)
func (h *Handlers) GetResources(c *gin.Context) {
	zoneID := c.Query("zone_id")
	resourceType := c.Query("type") // "mining", "herbalism", "skinning", etc.

	// Try querying resource_nodes table first (Mortal custom table)
	query := `
		SELECT 
			node_id,
			node_type,
			zone_id,
			location_x as x,
			location_y as y,
			location_z as z,
			resource_tier,
			owning_guild,
			owning_player,
			current_resources,
			max_resources
		FROM resource_nodes
		WHERE 1=1
	`

	args := []interface{}{}

	if zoneID != "" {
		query += " AND zone_id = ?"
		args = append(args, zoneID)
	}

	if resourceType != "" {
		// Map resource type to node_type
		typeMap := map[string]int{
			"mining":     1,
			"herbalism":  2,
			"wood":       3,
			"special":    4,
		}
		if nodeType, ok := typeMap[resourceType]; ok {
			query += " AND node_type = ?"
			args = append(args, nodeType)
		}
	}

	query += " LIMIT 100"

	rows, err := h.db.Query(query, args...)
	if err == nil {
		defer rows.Close()

		type ResourceNode struct {
			NodeID          int     `json:"node_id"`
			NodeType        string  `json:"type"`
			ZoneID          int     `json:"zone_id"`
			X               float64 `json:"x"`
			Y               float64 `json:"y"`
			Z               float64 `json:"z"`
			ResourceTier    int     `json:"tier"`
			OwningGuild     *int    `json:"owning_guild,omitempty"`
			OwningPlayer    *int    `json:"owning_player,omitempty"`
			CurrentResources int    `json:"current_resources"`
			MaxResources    int     `json:"max_resources"`
		}

		var resources []ResourceNode
		for rows.Next() {
			var node ResourceNode
			var nodeType int
			var owningGuild, owningPlayer sql.NullInt64

			err := rows.Scan(
				&node.NodeID, &nodeType, &node.ZoneID, &node.X, &node.Y, &node.Z,
				&node.ResourceTier, &owningGuild, &owningPlayer,
				&node.CurrentResources, &node.MaxResources,
			)
			if err != nil {
				continue
			}

			// Map node_type to string
			typeNames := map[int]string{
				1: "mining",
				2: "herbalism",
				3: "wood",
				4: "special",
			}
			node.NodeType = typeNames[nodeType]
			if node.NodeType == "" {
				node.NodeType = "unknown"
			}

			if owningGuild.Valid {
				guildID := int(owningGuild.Int64)
				node.OwningGuild = &guildID
			}
			if owningPlayer.Valid {
				playerID := int(owningPlayer.Int64)
				node.OwningPlayer = &playerID
			}

			resources = append(resources, node)
		}

		if len(resources) > 0 {
			c.JSON(http.StatusOK, gin.H{"resources": resources})
			return
		}
	}

	// Fallback: Query gameobject_template for resource nodes
	fallbackQuery := `
		SELECT 
			gt.entry,
			gt.name,
			gt.type,
			ROUND(AVG(gs.position_x), 2) as avg_x,
			ROUND(AVG(gs.position_y), 2) as avg_y,
			ROUND(AVG(gs.position_z), 2) as avg_z,
			gs.map,
			gs.zoneId,
			COUNT(*) as spawn_count
		FROM gameobject_template gt
		INNER JOIN gameobject_spawns gs ON gt.entry = gs.id
		WHERE gt.type IN (3, 6, 7, 8, 10)
	`

	fallbackArgs := []interface{}{}
	if zoneID != "" {
		fallbackQuery += " AND gs.zoneId = ?"
		fallbackArgs = append(fallbackArgs, zoneID)
	}

	fallbackQuery += " GROUP BY gt.entry, gt.name, gt.type, gs.map, gs.zoneId LIMIT 100"

	rows2, err := h.db.Query(fallbackQuery, fallbackArgs...)
	if err != nil {
		c.JSON(http.StatusOK, gin.H{"resources": []interface{}{}, "note": "Resource tracking not available"})
		return
	}
	defer rows2.Close()

	type FallbackResource struct {
		Entry      int     `json:"entry"`
		Name       string  `json:"name"`
		Type       string  `json:"type"`
		X          float64 `json:"x"`
		Y          float64 `json:"y"`
		Z          float64 `json:"z"`
		MapID      int     `json:"map_id"`
		ZoneID     int     `json:"zone_id"`
		SpawnCount int     `json:"spawn_count"`
	}

	var fallbackResources []FallbackResource
	for rows2.Next() {
		var node FallbackResource
		var goType int
		err := rows2.Scan(
			&node.Entry, &node.Name, &goType, &node.X, &node.Y, &node.Z,
			&node.MapID, &node.ZoneID, &node.SpawnCount,
		)
		if err != nil {
			continue
		}

		typeNames := map[int]string{
			3:  "mining",
			6:  "herbalism",
			7:  "skinning",
			8:  "fishing",
			10: "treasure",
		}
		node.Type = typeNames[goType]
		if node.Type == "" {
			node.Type = "unknown"
		}

		fallbackResources = append(fallbackResources, node)
	}

	c.JSON(http.StatusOK, gin.H{"resources": fallbackResources})
}

