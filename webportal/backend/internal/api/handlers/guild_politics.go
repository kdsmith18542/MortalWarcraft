package handlers

import (
	"database/sql"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

// GuildRelation represents a relationship between two guilds
type GuildRelation struct {
	GuildID      int    `json:"guild_id"`
	GuildName    string `json:"guild_name"`
	RelationType string `json:"relation_type"` // "alliance", "war", "truce"
	StartTime    int64  `json:"start_time"`
	EndTime      int64  `json:"end_time"`
	InitiatorID  int    `json:"initiator_guild_id"`
}

// GuildPolitics represents all relations for a guild
type GuildPolitics struct {
	GuildID int             `json:"guild_id"`
	GuildName string        `json:"guild_name"`
	Allies  []GuildRelation `json:"allies"`
	Wars    []GuildRelation `json:"wars"`
	Truces  []GuildRelation `json:"truces"`
}

// GetGuildPolitics returns all relations for a specific guild
func (h *Handlers) GetGuildPolitics(c *gin.Context) {
	guildIDStr := c.Param("id")
	guildID, err := strconv.Atoi(guildIDStr)
	if err != nil || guildID <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid guild ID"})
		return
	}

	// Get guild name
	var guildName string
	err = h.db.QueryRow("SELECT name FROM guild WHERE guildid = ?", guildID).Scan(&guildName)
	if err != nil {
		if err == sql.ErrNoRows {
			c.JSON(http.StatusNotFound, gin.H{"error": "Guild not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	politics := GuildPolitics{
		GuildID:   guildID,
		GuildName: guildName,
		Allies:    []GuildRelation{},
		Wars:      []GuildRelation{},
		Truces:    []GuildRelation{},
	}

	now := time.Now().Unix()

	// Get alliances (relation_type = 1)
	allianceRows, err := h.db.Query(`
		SELECT 
			CASE WHEN guild_id_a = ? THEN guild_id_b ELSE guild_id_a END AS other_guild_id,
			initiator_guild_id,
			start_time
		FROM mortal_guild_relations
		WHERE relation_type = 1 
		AND (guild_id_a = ? OR guild_id_b = ?)
	`, guildID, guildID, guildID)
	if err == nil {
		defer allianceRows.Close()
		for allianceRows.Next() {
			var otherGuildID, initiatorID int
			var startTime int64
			err := allianceRows.Scan(&otherGuildID, &initiatorID, &startTime)
			if err != nil {
				continue
			}

			// Get other guild name
			var otherGuildName string
			err = h.db.QueryRow("SELECT name FROM guild WHERE guildid = ?", otherGuildID).Scan(&otherGuildName)
			if err != nil {
				otherGuildName = "Unknown Guild"
			}
			if otherGuildName == "" {
				otherGuildName = "Unknown Guild"
			}

			politics.Allies = append(politics.Allies, GuildRelation{
				GuildID:      otherGuildID,
				GuildName:    otherGuildName,
				RelationType: "alliance",
				StartTime:    startTime,
				EndTime:      0,
				InitiatorID:  initiatorID,
			})
		}
	}

	// Get wars (relation_type = 2)
	warRows, err := h.db.Query(`
		SELECT 
			CASE WHEN guild_id_a = ? THEN guild_id_b ELSE guild_id_a END AS other_guild_id,
			initiator_guild_id,
			start_time,
			end_time
		FROM mortal_guild_relations
		WHERE relation_type = 2 
		AND (guild_id_a = ? OR guild_id_b = ?)
		AND (end_time = 0 OR end_time > ?)
	`, guildID, guildID, guildID, now)
	if err == nil {
		defer warRows.Close()
		for warRows.Next() {
			var otherGuildID, initiatorID int
			var startTime, endTime int64
			err := warRows.Scan(&otherGuildID, &initiatorID, &startTime, &endTime)
			if err != nil {
				continue
			}

			// Get other guild name
			var otherGuildName string
			err = h.db.QueryRow("SELECT name FROM guild WHERE guildid = ?", otherGuildID).Scan(&otherGuildName)
			if err != nil {
				otherGuildName = "Unknown Guild"
			}
			if otherGuildName == "" {
				otherGuildName = "Unknown Guild"
			}

			politics.Wars = append(politics.Wars, GuildRelation{
				GuildID:      otherGuildID,
				GuildName:    otherGuildName,
				RelationType: "war",
				StartTime:    startTime,
				EndTime:      endTime,
				InitiatorID:  initiatorID,
			})
		}
	}

	// Get truces (relation_type = 3)
	truceRows, err := h.db.Query(`
		SELECT 
			CASE WHEN guild_id_a = ? THEN guild_id_b ELSE guild_id_a END AS other_guild_id,
			initiator_guild_id,
			start_time,
			end_time
		FROM mortal_guild_relations
		WHERE relation_type = 3 
		AND (guild_id_a = ? OR guild_id_b = ?)
		AND end_time > ?
	`, guildID, guildID, guildID, now)
	if err == nil {
		defer truceRows.Close()
		for truceRows.Next() {
			var otherGuildID, initiatorID int
			var startTime, endTime int64
			err := truceRows.Scan(&otherGuildID, &initiatorID, &startTime, &endTime)
			if err != nil {
				continue
			}

			// Get other guild name
			var otherGuildName string
			err = h.db.QueryRow("SELECT name FROM guild WHERE guildid = ?", otherGuildID).Scan(&otherGuildName)
			if err != nil {
				otherGuildName = "Unknown Guild"
			}
			if otherGuildName == "" {
				otherGuildName = "Unknown Guild"
			}

			politics.Truces = append(politics.Truces, GuildRelation{
				GuildID:      otherGuildID,
				GuildName:    otherGuildName,
				RelationType: "truce",
				StartTime:    startTime,
				EndTime:      endTime,
				InitiatorID:  initiatorID,
			})
		}
	}

	c.JSON(http.StatusOK, politics)
}

// GetAllGuildPolitics returns a summary of all active guild relations
func (h *Handlers) GetAllGuildPolitics(c *gin.Context) {
	limitStr := c.DefaultQuery("limit", "50")
	limit, err := strconv.Atoi(limitStr)
	if err != nil || limit < 1 || limit > 100 {
		limit = 50
	}

	now := time.Now().Unix()

	// Get all active wars
	type WarSummary struct {
		Guild1ID   int    `json:"guild1_id"`
		Guild1Name string `json:"guild1_name"`
		Guild2ID   int    `json:"guild2_id"`
		Guild2Name string `json:"guild2_name"`
		StartTime  int64  `json:"start_time"`
	}

	wars := []WarSummary{}
	warRows, err := h.db.Query(`
		SELECT 
			guild_id_a,
			guild_id_b,
			start_time
		FROM mortal_guild_relations
		WHERE relation_type = 2
		AND (end_time = 0 OR end_time > ?)
		ORDER BY start_time DESC
		LIMIT ?
	`, now, limit)
	if err == nil {
		defer warRows.Close()
		for warRows.Next() {
			var guild1ID, guild2ID int
			var startTime int64
			err := warRows.Scan(&guild1ID, &guild2ID, &startTime)
			if err != nil {
				continue
			}

			// Get guild names
			var guild1Name, guild2Name string
			h.db.QueryRow("SELECT name FROM guild WHERE guildid = ?", guild1ID).Scan(&guild1Name)
			h.db.QueryRow("SELECT name FROM guild WHERE guildid = ?", guild2ID).Scan(&guild2Name)

			if guild1Name == "" {
				guild1Name = "Unknown"
			}
			if guild2Name == "" {
				guild2Name = "Unknown"
			}

			wars = append(wars, WarSummary{
				Guild1ID:   guild1ID,
				Guild1Name: guild1Name,
				Guild2ID:   guild2ID,
				Guild2Name: guild2Name,
				StartTime:  startTime,
			})
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"wars": wars,
	})
}

