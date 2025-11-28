package handlers

import (
	"database/sql"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// Siege represents a siege event
type Siege struct {
	SiegeID           int    `json:"siege_id"`
	StrongholdID      int    `json:"stronghold_id"`
	StrongholdName    string `json:"stronghold_name"`
	ZoneID            int    `json:"zone_id"`
	AttackerGuildID   int    `json:"attacker_guild_id"`
	AttackerGuildName string `json:"attacker_guild_name"`
	DefenderGuildID   int    `json:"defender_guild_id"`
	DefenderGuildName string `json:"defender_guild_name"`
	StartTime         int64  `json:"start_time"`
	EndTime           int64  `json:"end_time"`
	IsActive          bool   `json:"is_active"`
	LifecycleStage    string `json:"lifecycle_stage"`
	AttackerCount     int    `json:"attacker_count"`
	DefenderCount     int    `json:"defender_count"`
	MinimumLevel      int    `json:"minimum_level"`
	MinimumStanding   int    `json:"minimum_standing"`
}

// GetUpcomingSieges returns upcoming sieges
func (h *Handlers) GetUpcomingSieges(c *gin.Context) {
	limitStr := c.DefaultQuery("limit", "10")
	limit, err := strconv.Atoi(limitStr)
	if err != nil || limit < 1 || limit > 50 {
		limit = 10
	}

	now := time.Now().Unix()
	query := `
		SELECT 
			s.siege_id,
			s.zone_id,
			s.vulnerability_start,
			s.vulnerability_end,
			s.attacker_guild_id,
			s.defender_guild_id,
			sh.id AS stronghold_id,
			sh.stronghold_name,
			s.lifecycle_stage,
			s.minimum_level,
			s.minimum_standing
		FROM guild_sieges s
		LEFT JOIN guild_strongholds sh ON sh.zone_id = s.zone_id
		WHERE s.phase < 4 AND s.vulnerability_start > ?
		ORDER BY s.vulnerability_start ASC
		LIMIT ?
	`

	rows, err := h.db.Query(query, now, limit)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query sieges"})
		return
	}
	defer rows.Close()

	var sieges []Siege
	for rows.Next() {
		var s Siege
		var strongholdID sql.NullInt64
		var strongholdName sql.NullString
		var lifecycleStage sql.NullInt64
		var minimumLevel sql.NullInt64
		var minimumStanding sql.NullInt64

		err := rows.Scan(
			&s.SiegeID,
			&s.ZoneID,
			&s.StartTime,
			&s.EndTime,
			&s.AttackerGuildID,
			&s.DefenderGuildID,
			&strongholdID,
			&strongholdName,
			&lifecycleStage,
			&minimumLevel,
			&minimumStanding,
		)
		if err != nil {
			continue
		}

		if strongholdID.Valid {
			s.StrongholdID = int(strongholdID.Int64)
		}
		if strongholdName.Valid {
			s.StrongholdName = strongholdName.String
		} else {
			s.StrongholdName = "Unknown Stronghold"
		}

		// Get guild names
		s.AttackerGuildName = h.getGuildName(s.AttackerGuildID)
		s.DefenderGuildName = h.getGuildName(s.DefenderGuildID)

		// Determine lifecycle stage
		if lifecycleStage.Valid {
			stage := lifecycleStage.Int64
			if stage == 0 {
				s.LifecycleStage = "announced"
			} else if stage == 1 {
				s.LifecycleStage = "signup"
			} else if stage == 2 {
				s.LifecycleStage = "lock_in"
			} else if stage == 3 {
				s.LifecycleStage = "active"
				s.IsActive = true
			} else if stage == 4 {
				s.LifecycleStage = "complete"
			}
		}

		if minimumLevel.Valid {
			s.MinimumLevel = int(minimumLevel.Int64)
		}
		if minimumStanding.Valid {
			s.MinimumStanding = int(minimumStanding.Int64)
		}

		// Get participant counts (rounded for intel protection)
		attackerCount, defenderCount := h.getSiegeParticipantCounts(s.SiegeID)
		s.AttackerCount = attackerCount
		s.DefenderCount = defenderCount

		sieges = append(sieges, s)
	}

	c.JSON(http.StatusOK, gin.H{"sieges": sieges, "count": len(sieges)})
}

// GetSiege returns details for a specific siege
func (h *Handlers) GetSiege(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid siege ID"})
		return
	}

	query := `
		SELECT 
			s.siege_id,
			s.zone_id,
			s.vulnerability_start,
			s.vulnerability_end,
			s.attacker_guild_id,
			s.defender_guild_id,
			sh.id AS stronghold_id,
			sh.stronghold_name,
			s.lifecycle_stage,
			s.minimum_level,
			s.minimum_standing
		FROM guild_sieges s
		LEFT JOIN guild_strongholds sh ON sh.zone_id = s.zone_id
		WHERE s.siege_id = ?
	`

	var s Siege
	var strongholdID sql.NullInt64
	var strongholdName sql.NullString
	var lifecycleStage sql.NullInt64
	var minimumLevel sql.NullInt64
	var minimumStanding sql.NullInt64

	err = h.db.QueryRow(query, id).Scan(
		&s.SiegeID,
		&s.ZoneID,
		&s.StartTime,
		&s.EndTime,
		&s.AttackerGuildID,
		&s.DefenderGuildID,
		&strongholdID,
		&strongholdName,
		&lifecycleStage,
		&minimumLevel,
		&minimumStanding,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Siege not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query siege"})
		return
	}

	if strongholdID.Valid {
		s.StrongholdID = int(strongholdID.Int64)
	}
	if strongholdName.Valid {
		s.StrongholdName = strongholdName.String
	} else {
		s.StrongholdName = "Unknown Stronghold"
	}

	// Get guild names
	s.AttackerGuildName = h.getGuildName(s.AttackerGuildID)
	s.DefenderGuildName = h.getGuildName(s.DefenderGuildID)

	// Determine lifecycle stage
	if lifecycleStage.Valid {
		stage := lifecycleStage.Int64
		if stage == 0 {
			s.LifecycleStage = "announced"
		} else if stage == 1 {
			s.LifecycleStage = "signup"
		} else if stage == 2 {
			s.LifecycleStage = "lock_in"
		} else if stage == 3 {
			s.LifecycleStage = "active"
			s.IsActive = true
		} else if stage == 4 {
			s.LifecycleStage = "complete"
		}
	}

	if minimumLevel.Valid {
		s.MinimumLevel = int(minimumLevel.Int64)
	}
	if minimumStanding.Valid {
		s.MinimumStanding = int(minimumStanding.Int64)
	}

	// Get participant counts
	attackerCount, defenderCount := h.getSiegeParticipantCounts(s.SiegeID)
	s.AttackerCount = attackerCount
	s.DefenderCount = defenderCount

	c.JSON(http.StatusOK, s)
}

// GetSiegeSchedule returns schedule for a specific stronghold
func (h *Handlers) GetSiegeSchedule(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid stronghold ID"})
		return
	}

	now := time.Now().Unix()
	query := `
		SELECT 
			s.siege_id,
			s.zone_id,
			s.vulnerability_start,
			s.vulnerability_end,
			s.attacker_guild_id,
			s.defender_guild_id,
			sh.id AS stronghold_id,
			sh.stronghold_name,
			s.lifecycle_stage
		FROM guild_sieges s
		LEFT JOIN guild_strongholds sh ON sh.zone_id = s.zone_id
		WHERE sh.id = ? AND s.phase < 4 AND s.vulnerability_start > ?
		ORDER BY s.vulnerability_start ASC
	`

	rows, err := h.db.Query(query, id, now)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query siege schedule"})
		return
	}
	defer rows.Close()

	var sieges []Siege
	for rows.Next() {
		var s Siege
		var strongholdID sql.NullInt64
		var strongholdName sql.NullString
		var lifecycleStage sql.NullInt64

		err := rows.Scan(
			&s.SiegeID,
			&s.ZoneID,
			&s.StartTime,
			&s.EndTime,
			&s.AttackerGuildID,
			&s.DefenderGuildID,
			&strongholdID,
			&strongholdName,
			&lifecycleStage,
		)
		if err != nil {
			continue
		}

		if strongholdID.Valid {
			s.StrongholdID = int(strongholdID.Int64)
		}
		if strongholdName.Valid {
			s.StrongholdName = strongholdName.String
		}

		s.AttackerGuildName = h.getGuildName(s.AttackerGuildID)
		s.DefenderGuildName = h.getGuildName(s.DefenderGuildID)

		if lifecycleStage.Valid {
			stage := lifecycleStage.Int64
			if stage == 3 {
				s.IsActive = true
				s.LifecycleStage = "active"
			} else if stage == 2 {
				s.LifecycleStage = "lock_in"
			} else if stage == 1 {
				s.LifecycleStage = "signup"
			} else {
				s.LifecycleStage = "announced"
			}
		}

		sieges = append(sieges, s)
	}

	c.JSON(http.StatusOK, gin.H{"sieges": sieges, "count": len(sieges)})
}

// Helper functions
func (h *Handlers) getGuildName(guildID int) string {
	if guildID == 0 {
		return "Unclaimed"
	}

	query := "SELECT name FROM guild WHERE guildid = ?"
	var name string
	err := h.db.QueryRow(query, guildID).Scan(&name)
	if err != nil {
		return "Unknown"
	}
	return name
}

func (h *Handlers) getSiegeParticipantCounts(siegeID int) (int, int) {
	// Round counts to protect intel (e.g., round to nearest 5)
	attackerQuery := "SELECT COUNT(*) FROM mortal_siege_participants WHERE siege_id = ? AND is_attacker = 1"
	defenderQuery := "SELECT COUNT(*) FROM mortal_siege_participants WHERE siege_id = ? AND is_attacker = 0"

	var attackerCount, defenderCount int
	h.db.QueryRow(attackerQuery, siegeID).Scan(&attackerCount)
	h.db.QueryRow(defenderQuery, siegeID).Scan(&defenderCount)

	// Round to nearest 5 for intel protection
	attackerCount = (attackerCount + 2) / 5 * 5
	defenderCount = (defenderCount + 2) / 5 * 5

	return attackerCount, defenderCount
}

