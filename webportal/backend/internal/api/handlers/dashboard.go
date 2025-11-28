package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func (h *Handlers) GetDashboard(c *gin.Context) {
	// Get territory control stats
	territoryStats, err := h.getTerritoryStats()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get territory stats"})
		return
	}

	// Get active world bosses
	activeBosses, err := h.getActiveWorldBosses()
	if err != nil {
		// Log error but continue with empty list
		activeBosses = []models.WorldBoss{}
	}

	// Get midnight horde status
	midnightHorde, err := h.getMidnightHordeStatus()
	if err != nil {
		// Default to inactive if error
		midnightHorde = models.MidnightHorde{
			IsActive:  false,
			NextEvent: time.Now().Add(24 * time.Hour),
			Duration:  60,
		}
	}

	status := models.GlobalStatus{
		TerritoryControl: territoryStats,
		ActiveBosses:     activeBosses,
		MidnightHorde:    midnightHorde,
	}

	c.JSON(http.StatusOK, status)
}

func (h *Handlers) getTerritoryStats() (models.TerritoryStats, error) {
	query := `
		SELECT 
			COUNT(CASE WHEN g.leaderguid IS NOT NULL AND g.leaderguid IN (
				SELECT guid FROM characters WHERE race IN (2, 5, 6, 8, 10)
			) THEN 1 END) as horde,
			COUNT(CASE WHEN g.leaderguid IS NOT NULL AND g.leaderguid IN (
				SELECT guid FROM characters WHERE race IN (1, 3, 4, 7, 11)
			) THEN 1 END) as alliance,
			COUNT(CASE WHEN tcp.controlling_guild IS NULL THEN 1 END) as independent,
			COUNT(*) as total
		FROM territory_control_points tcp
		LEFT JOIN guild g ON tcp.controlling_guild = g.guildid
	`

	var stats models.TerritoryStats
	err := h.db.QueryRow(query).Scan(
		&stats.Horde,
		&stats.Alliance,
		&stats.Independent,
		&stats.Total,
	)

	if err != nil {
		return stats, err
	}

	return stats, nil
}

func (h *Handlers) getActiveWorldBosses() ([]models.WorldBoss, error) {
	// Query world boss spawns from database
	query := `
		SELECT 
			boss_id,
			boss_name,
			zone_id,
			is_active,
			last_killed,
			next_spawn
		FROM world_boss_spawns
		WHERE is_active = 1
		ORDER BY boss_id
	`
	
	rows, err := h.db.Query(query)
	if err != nil {
		return []models.WorldBoss{}, err
	}
	defer rows.Close()
	
	bosses := []models.WorldBoss{}
	for rows.Next() {
		var boss models.WorldBoss
		var lastKilled, nextSpawn sql.NullTime
		
		if err := rows.Scan(&boss.ID, &boss.Name, &boss.ZoneID, &boss.IsActive, &lastKilled, &nextSpawn); err != nil {
			continue
		}
		
		if lastKilled.Valid {
			boss.LastKilled = lastKilled.Time
		}
		if nextSpawn.Valid {
			boss.NextSpawn = nextSpawn.Time
		}
		
		bosses = append(bosses, boss)
	}
	
	return bosses, nil
}

func (h *Handlers) GetWorldBosses(c *gin.Context) {
	bosses, err := h.getActiveWorldBosses()
	if err != nil {
		bosses = []models.WorldBoss{}
	}
	c.JSON(http.StatusOK, gin.H{"bosses": bosses})
}

func (h *Handlers) GetMidnightHorde(c *gin.Context) {
	status, err := h.getMidnightHordeStatus()
	if err != nil {
		status = models.MidnightHorde{
			IsActive:  false,
			NextEvent: time.Now().Add(24 * time.Hour),
			Duration:  60,
		}
	}
	c.JSON(http.StatusOK, status)
}

func (h *Handlers) getMidnightHordeStatus() (models.MidnightHorde, error) {
	// Query seasonal PvE events for Midnight Horde (event_id = 1)
	query := `
		SELECT 
			active,
			end_time,
			zone_list
		FROM seasonal_pve_events
		WHERE event_id = 1
		LIMIT 1
	`
	
	var isActive bool
	var endTime int64
	var zoneList string
	
	err := h.db.QueryRow(query).Scan(&isActive, &endTime, &zoneList)
	if err != nil {
		// Event not found or inactive, return default
		return models.MidnightHorde{
			IsActive:  false,
			NextEvent: time.Now().Add(24 * time.Hour),
			Duration:  60,
		}, nil
	}
	
	// Calculate next event time if inactive
	nextEvent := time.Now().Add(24 * time.Hour)
	if isActive {
		nextEvent = time.Unix(endTime, 0)
	}
	
	// Calculate duration (default 7 days for Midnight Horde)
	duration := int64(7 * 24 * 60) // 7 days in minutes
	
	return models.MidnightHorde{
		IsActive:  isActive,
		NextEvent: nextEvent,
		Duration:  duration,
		ZoneList:  zoneList,
	}, nil
}

