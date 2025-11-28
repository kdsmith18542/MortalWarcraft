package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (h *Handlers) GetStrongholds(c *gin.Context) {
	query := `
		SELECT 
			tcp.id,
			tcp.zone_id,
			tcp.point_name,
			tcp.location_x,
			tcp.location_y,
			tcp.location_z,
			tcp.controlling_guild,
			g.guildname,
			tcp.tax_rate,
			tcp.owner_message,
			TIMESTAMPDIFF(SECOND, tcp.control_start_time, NOW()) as control_duration
		FROM territory_control_points tcp
		LEFT JOIN guild g ON tcp.controlling_guild = g.guildid
		ORDER BY tcp.zone_id, tcp.point_name
	`

	rows, err := h.db.Query(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query strongholds"})
		return
	}
	defer rows.Close()

	var strongholds []models.Stronghold
	for rows.Next() {
		var s models.Stronghold
		var guildID sql.NullInt64
		var guildName sql.NullString
		var taxRate sql.NullFloat64
		var ownerMessage sql.NullString
		var controlDuration sql.NullInt64

		err := rows.Scan(
			&s.ID,
			&s.ZoneID,
			&s.PointName,
			&s.LocationX,
			&s.LocationY,
			&s.LocationZ,
			&guildID,
			&guildName,
			&taxRate,
			&ownerMessage,
			&controlDuration,
		)
		if err != nil {
			continue
		}

		if guildID.Valid {
			s.ControllingGuild = int(guildID.Int64)
		}
		if guildName.Valid {
			s.GuildName = guildName.String
		}
		if taxRate.Valid {
			s.TaxRate = taxRate.Float64
		}
		if ownerMessage.Valid {
			s.OwnerMessage = ownerMessage.String
		}
		if controlDuration.Valid {
			s.ControlDuration = int(controlDuration.Int64)
		}

		strongholds = append(strongholds, s)
	}

	c.JSON(http.StatusOK, gin.H{"strongholds": strongholds, "count": len(strongholds)})
}

func (h *Handlers) GetStronghold(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid stronghold ID"})
		return
	}

	query := `
		SELECT 
			tcp.id,
			tcp.zone_id,
			tcp.point_name,
			tcp.location_x,
			tcp.location_y,
			tcp.location_z,
			tcp.controlling_guild,
			g.guildname,
			tcp.tax_rate,
			tcp.owner_message,
			TIMESTAMPDIFF(SECOND, tcp.control_start_time, NOW()) as control_duration
		FROM territory_control_points tcp
		LEFT JOIN guild g ON tcp.controlling_guild = g.guildid
		WHERE tcp.id = ?
	`

	var s models.Stronghold
	var guildID sql.NullInt64
	var guildName sql.NullString
	var taxRate sql.NullFloat64
	var ownerMessage sql.NullString
	var controlDuration sql.NullInt64

	err = h.db.QueryRow(query, id).Scan(
		&s.ID,
		&s.ZoneID,
		&s.PointName,
		&s.LocationX,
		&s.LocationY,
		&s.LocationZ,
		&guildID,
		&guildName,
		&taxRate,
		&ownerMessage,
		&controlDuration,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Stronghold not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query stronghold"})
		return
	}

	if guildID.Valid {
		s.ControllingGuild = int(guildID.Int64)
	}
	if guildName.Valid {
		s.GuildName = guildName.String
	}
	if taxRate.Valid {
		s.TaxRate = taxRate.Float64
	}
	if ownerMessage.Valid {
		s.OwnerMessage = ownerMessage.String
	}
	if controlDuration.Valid {
		s.ControlDuration = int(controlDuration.Int64)
	}

	c.JSON(http.StatusOK, s)
}

