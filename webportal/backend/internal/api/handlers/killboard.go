package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

func (h *Handlers) GetRecentKills(c *gin.Context) {
	limit := 50
	if limitStr := c.Query("limit"); limitStr != "" {
		if parsed, err := strconv.Atoi(limitStr); err == nil && parsed > 0 && parsed <= 100 {
			limit = parsed
		}
	}

	query := `
		SELECT 
			k.kill_id,
			k.killer_guid,
			k.killer_name,
			k.victim_guid,
			k.victim_name,
			k.zone_id,
			k.zone_name,
			k.loot_value,
			k.notoriety_gain,
			k.is_zerg,
			k.kill_time,
			kg.guildname as killer_guild,
			vg.guildname as victim_guild
		FROM pvp_killboard k
		LEFT JOIN guild kg ON k.killer_guild_id = kg.guildid
		LEFT JOIN guild vg ON k.victim_guild_id = vg.guildid
		ORDER BY k.kill_time DESC
		LIMIT ?
	`

	rows, err := h.db.Query(query, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query kills"})
		return
	}
	defer rows.Close()

	var kills []models.Kill
	for rows.Next() {
		var kill models.Kill
		var killerGuild, victimGuild sql.NullString

		err := rows.Scan(
			&kill.ID,
			&kill.KillerGUID,
			&kill.KillerName,
			&kill.VictimGUID,
			&kill.VictimName,
			&kill.ZoneID,
			&kill.ZoneName,
			&kill.LootValue,
			&kill.Notoriety,
			&kill.IsZerg,
			&kill.KillTime,
			&killerGuild,
			&victimGuild,
		)
		if err != nil {
			continue
		}

		if killerGuild.Valid {
			kill.KillerGuild = killerGuild.String
		}
		if victimGuild.Valid {
			kill.VictimGuild = victimGuild.String
		}

		kills = append(kills, kill)
	}

	c.JSON(http.StatusOK, gin.H{"kills": kills, "count": len(kills)})
}

func (h *Handlers) GetKill(c *gin.Context) {
	killID, err := strconv.ParseInt(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid kill ID"})
		return
	}

	// Get kill details
	query := `
		SELECT 
			k.kill_id,
			k.killer_guid,
			k.killer_name,
			k.victim_guid,
			k.victim_name,
			k.zone_id,
			k.zone_name,
			k.map_id,
			k.location_x,
			k.location_y,
			k.location_z,
			k.loot_value,
			k.notoriety_gain,
			k.is_zerg,
			k.kill_time,
			kg.guildname as killer_guild,
			vg.guildname as victim_guild
		FROM pvp_killboard k
		LEFT JOIN guild kg ON k.killer_guild_id = kg.guildid
		LEFT JOIN guild vg ON k.victim_guild_id = vg.guildid
		WHERE k.kill_id = ?
	`

	var kill models.Kill
	var killerGuild, victimGuild sql.NullString
	var mapID int

	err = h.db.QueryRow(query, killID).Scan(
		&kill.ID,
		&kill.KillerGUID,
		&kill.KillerName,
		&kill.VictimGUID,
		&kill.VictimName,
		&kill.ZoneID,
		&kill.ZoneName,
		&mapID,
		&kill.KillTime,
		&kill.LootValue,
		&kill.Notoriety,
		&kill.IsZerg,
		&kill.KillTime,
		&killerGuild,
		&victimGuild,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Kill not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query kill"})
		return
	}

	if killerGuild.Valid {
		kill.KillerGuild = killerGuild.String
	}
	if victimGuild.Valid {
		kill.VictimGuild = victimGuild.String
	}

	// Get participants
	participantsQuery := `
		SELECT 
			character_guid,
			character_name,
			guild_id,
			damage_dealt,
			is_killer
		FROM pvp_killboard_participants
		WHERE kill_id = ?
		ORDER BY damage_dealt DESC
	`

	participantRows, err := h.db.Query(participantsQuery, killID)
	if err == nil {
		defer participantRows.Close()
		
		// Add participants to kill object
		participants := []map[string]interface{}{}
		for participantRows.Next() {
			var participantName string
			var participantRole string
			var damageDealt int
			
			if err := participantRows.Scan(&participantName, &participantRole, &damageDealt); err == nil {
				participants = append(participants, map[string]interface{}{
					"name":   participantName,
					"role":   participantRole,
					"damage": damageDealt,
				})
			}
		}
		
		if len(participants) > 0 {
			kill["participants"] = participants
		}
	}

	// Get loot
	lootQuery := `
		SELECT 
			item_entry,
			item_count,
			item_value
		FROM pvp_killboard_loot
		WHERE kill_id = ?
	`

	lootRows, err := h.db.Query(lootQuery, killID)
	if err == nil {
		defer lootRows.Close()
		var items []models.KillItem
		for lootRows.Next() {
			var item models.KillItem
			if err := lootRows.Scan(&item.ItemEntry, &item.Count, &item.Value); err == nil {
				// Get item name from item_template
				nameQuery := `SELECT name FROM item_template WHERE entry = ?`
				h.db.QueryRow(nameQuery, item.ItemEntry).Scan(&item.ItemName)
				items = append(items, item)
			}
		}
		kill.Items = items
	}

	c.JSON(http.StatusOK, kill)
}

func (h *Handlers) GetLeaderboards(c *gin.Context) {
	boardType := c.Query("type") // "valuable", "solo", "guild", "notorious", "losses"
	timeRange := c.Query("range") // "24h", "week", "month", "all"

	if boardType == "" {
		boardType = "valuable"
	}
	if timeRange == "" {
		timeRange = "week"
	}

	var timeFilter string
	switch timeRange {
	case "24h":
		timeFilter = "k.kill_time >= DATE_SUB(NOW(), INTERVAL 24 HOUR)"
	case "week":
		timeFilter = "k.kill_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)"
	case "month":
		timeFilter = "k.kill_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)"
	default:
		timeFilter = "1=1"
	}

	var query string
	var entries []models.LeaderboardEntry

	switch boardType {
	case "valuable":
		query = `
			SELECT 
				k.killer_name as name,
				kg.guildname as guild,
				SUM(k.loot_value) as total_value,
				COUNT(*) as kill_count
			FROM pvp_killboard k
			LEFT JOIN guild kg ON k.killer_guild_id = kg.guildid
			WHERE ` + timeFilter + `
			GROUP BY k.killer_guid, k.killer_name, kg.guildname
			ORDER BY total_value DESC
			LIMIT 50
		`
	case "solo":
		query = `
			SELECT 
				k.killer_name as name,
				kg.guildname as guild,
				COUNT(*) as kill_count,
				SUM(k.loot_value) as total_value
			FROM pvp_killboard k
			LEFT JOIN guild kg ON k.killer_guild_id = kg.guildid
			WHERE ` + timeFilter + ` AND k.is_zerg = 0
			GROUP BY k.killer_guid, k.killer_name, kg.guildname
			ORDER BY kill_count DESC
			LIMIT 50
		`
	case "guild":
		query = `
			SELECT 
				kg.guildname as name,
				'' as guild,
				COUNT(*) as kill_count,
				SUM(k.loot_value) as total_value
			FROM pvp_killboard k
			INNER JOIN guild kg ON k.killer_guild_id = kg.guildid
			WHERE ` + timeFilter + `
			GROUP BY k.killer_guild_id, kg.guildname
			ORDER BY kill_count DESC
			LIMIT 50
		`
	case "notorious":
		query = `
			SELECT 
				c.name as name,
				g.guildname as guild,
				COALESCE(cn.notoriety_level, 0) as notoriety,
				0 as kill_count
			FROM characters c
			LEFT JOIN character_notoriety cn ON c.guid = cn.guid
			LEFT JOIN guild_member gm ON c.guid = gm.guid
			LEFT JOIN guild g ON gm.guildid = g.guildid
			WHERE cn.notoriety_level > 0
			ORDER BY cn.notoriety_level DESC
			LIMIT 50
		`
	case "losses":
		query = `
			SELECT 
				k.victim_name as name,
				vg.guildname as guild,
				SUM(k.loot_value) as total_value,
				COUNT(*) as death_count
			FROM pvp_killboard k
			LEFT JOIN guild vg ON k.victim_guild_id = vg.guildid
			WHERE ` + timeFilter + `
			GROUP BY k.victim_guid, k.victim_name, vg.guildname
			ORDER BY total_value DESC
			LIMIT 50
		`
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid leaderboard type"})
		return
	}

	rows, err := h.db.Query(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query leaderboard"})
		return
	}
	defer rows.Close()

	rank := 1
	for rows.Next() {
		var entry models.LeaderboardEntry
		entry.Rank = rank

		var guild sql.NullString
		if boardType == "notorious" {
			err := rows.Scan(&entry.Name, &guild, &entry.Value, &entry.Count)
			if err != nil {
				continue
			}
		} else if boardType == "losses" {
			err := rows.Scan(&entry.Name, &guild, &entry.Value, &entry.Count)
			if err != nil {
				continue
			}
		} else {
			err := rows.Scan(&entry.Name, &guild, &entry.Value, &entry.Count)
			if err != nil {
				continue
			}
		}

		if guild.Valid {
			entry.Guild = guild.String
		}

		entries = append(entries, entry)
		rank++
	}

	leaderboard := models.Leaderboard{
		Type:      boardType,
		Entries:   entries,
		TimeRange: timeRange,
	}

	c.JSON(http.StatusOK, leaderboard)
}

func (h *Handlers) SearchKills(c *gin.Context) {
	query := c.Query("q")
	if query == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Query parameter required"})
		return
	}

	limit := 50
	if limitStr := c.Query("limit"); limitStr != "" {
		if parsed, err := strconv.Atoi(limitStr); err == nil && parsed > 0 && parsed <= 100 {
			limit = parsed
		}
	}

	searchPattern := "%" + query + "%"

	searchQuery := `
		SELECT 
			k.kill_id,
			k.killer_guid,
			k.killer_name,
			k.victim_guid,
			k.victim_name,
			k.zone_id,
			k.zone_name,
			k.loot_value,
			k.notoriety_gain,
			k.is_zerg,
			k.kill_time,
			kg.guildname as killer_guild,
			vg.guildname as victim_guild
		FROM pvp_killboard k
		LEFT JOIN guild kg ON k.killer_guild_id = kg.guildid
		LEFT JOIN guild vg ON k.victim_guild_id = vg.guildid
		WHERE k.killer_name LIKE ? OR k.victim_name LIKE ? OR k.zone_name LIKE ?
		ORDER BY k.kill_time DESC
		LIMIT ?
	`

	rows, err := h.db.Query(searchQuery, searchPattern, searchPattern, searchPattern, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to search kills"})
		return
	}
	defer rows.Close()

	var kills []models.Kill
	for rows.Next() {
		var kill models.Kill
		var killerGuild, victimGuild sql.NullString

		err := rows.Scan(
			&kill.ID,
			&kill.KillerGUID,
			&kill.KillerName,
			&kill.VictimGUID,
			&kill.VictimName,
			&kill.ZoneID,
			&kill.ZoneName,
			&kill.LootValue,
			&kill.Notoriety,
			&kill.IsZerg,
			&kill.KillTime,
			&killerGuild,
			&victimGuild,
		)
		if err != nil {
			continue
		}

		if killerGuild.Valid {
			kill.KillerGuild = killerGuild.String
		}
		if victimGuild.Valid {
			kill.VictimGuild = victimGuild.String
		}

		kills = append(kills, kill)
	}

	c.JSON(http.StatusOK, gin.H{"kills": kills, "count": len(kills), "query": query})
}

