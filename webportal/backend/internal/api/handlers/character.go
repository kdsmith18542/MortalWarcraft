package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func (h *Handlers) GetCharacterProfile(c *gin.Context) {
	name := c.Param("name")
	if name == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Character name required"})
		return
	}

	// Get character basic info
	query := `
		SELECT 
			c.guid,
			c.name,
			c.level,
			c.race,
			c.class,
			gm.guildid,
			g.guildname
		FROM characters c
		LEFT JOIN guild_member gm ON c.guid = gm.guid
		LEFT JOIN guild g ON gm.guildid = g.guildid
		WHERE c.name = ?
	`

	var profile models.CharacterProfile
	var guildID sql.NullInt64
	var guildName sql.NullString
	var race, class int

	err := h.db.QueryRow(query, name).Scan(
		&profile.GUID,
		&profile.Name,
		&profile.DynamicLevel,
		&race,
		&class,
		&guildID,
		&guildName,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Character not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query character"})
		return
	}

	if guildID.Valid {
		profile.GuildID = int(guildID.Int64)
	}
	if guildName.Valid {
		profile.GuildName = guildName.String
	}

	// Get skills
	skills, err := h.getCharacterSkills(profile.GUID)
	if err == nil {
		profile.Skills = skills
		// Calculate total primary skills
		total := 0.0
		for _, skill := range skills {
			total += skill.Value
		}
		profile.TotalSkills = int(total)
	}

	// Get notoriety
	notorietyQuery := `SELECT notoriety_level FROM character_notoriety WHERE guid = ?`
	var notoriety sql.NullInt64
	h.db.QueryRow(notorietyQuery, profile.GUID).Scan(&notoriety)
	if notoriety.Valid {
		profile.Notoriety = int(notoriety.Int64)
	}

	// Determine criminal status
	criminalQuery := `SELECT criminal_until FROM character_criminal_flags WHERE guid = ? AND criminal_until > UNIX_TIMESTAMP()`
	var criminalUntil sql.NullInt64
	h.db.QueryRow(criminalQuery, profile.GUID).Scan(&criminalUntil)

	if criminalUntil.Valid {
		profile.CriminalStatus = "murderer"
	} else {
		// Check for thief status (would need pickpocket tracking)
		profile.CriminalStatus = "innocent"
	}

	// Get kill/death stats
	killStats, err := h.getCharacterKillStats(profile.GUID)
	if err == nil {
		profile.KillDeathRatio = killStats.KDRatio
	}

	// Get blueprints (if table exists)
	blueprints, err := h.getCharacterBlueprints(profile.GUID)
	if err == nil {
		profile.Blueprints = blueprints
	}

	c.JSON(http.StatusOK, profile)
}

func (h *Handlers) GetCharacterSkills(c *gin.Context) {
	name := c.Param("name")
	if name == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Character name required"})
		return
	}

	// Get character GUID
	var guid int
	err := h.db.QueryRow("SELECT guid FROM characters WHERE name = ?", name).Scan(&guid)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Character not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query character"})
		return
	}

	skills, err := h.getCharacterSkills(guid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query skills"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"skills": skills})
}

func (h *Handlers) GetCharacterReputation(c *gin.Context) {
	name := c.Param("name")
	if name == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Character name required"})
		return
	}

	// Get character GUID
	var guid int
	err := h.db.QueryRow("SELECT guid FROM characters WHERE name = ?", name).Scan(&guid)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Character not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query character"})
		return
	}

	// Get notoriety
	var notoriety sql.NullInt64
	h.db.QueryRow("SELECT notoriety_level FROM character_notoriety WHERE guid = ?", guid).Scan(&notoriety)

	// Get criminal status
	var criminalUntil sql.NullInt64
	h.db.QueryRow("SELECT criminal_until FROM character_criminal_flags WHERE guid = ? AND criminal_until > UNIX_TIMESTAMP()", guid).Scan(&criminalUntil)

	criminalStatus := "innocent"
	if criminalUntil.Valid {
		criminalStatus = "murderer"
	}

	// Check bounty board for active bounties on this character
	var activeBounty sql.NullInt64
	bountyQuery := `
		SELECT bounty_amount 
		FROM mortal_bounty_board 
		WHERE target_name = ? AND status = 'active' 
		ORDER BY bounty_amount DESC 
		LIMIT 1
	`
	
	hasBounty := false
	bountyAmount := int64(0)
	
	if err := h.db.QueryRow(bountyQuery, name).Scan(&activeBounty); err == nil && activeBounty.Valid {
		hasBounty = true
		bountyAmount = activeBounty.Int64
	}
	
	c.JSON(http.StatusOK, gin.H{
		"notoriety":       notoriety.Int64,
		"criminal_status": criminalStatus,
		"bounty_status":   hasBounty,
		"bounty_amount":   bountyAmount,
	})
}

func (h *Handlers) GetCharacterBlueprints(c *gin.Context) {
	name := c.Param("name")
	if name == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Character name required"})
		return
	}

	// Get character GUID
	var guid int
	err := h.db.QueryRow("SELECT guid FROM characters WHERE name = ?", name).Scan(&guid)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Character not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query character"})
		return
	}

	blueprints, err := h.getCharacterBlueprints(guid)
	if err != nil {
		// Table might not exist, return empty
		c.JSON(http.StatusOK, gin.H{"blueprints": []models.Blueprint{}})
		return
	}

	c.JSON(http.StatusOK, gin.H{"blueprints": blueprints})
}

// Helper functions

func (h *Handlers) getCharacterSkills(guid int) ([]models.Skill, error) {
	query := `
		SELECT 
			skill_id,
			skill_name,
			skill_value,
			skill_max_value
		FROM character_mortal_skills
		WHERE guid = ?
		ORDER BY skill_value DESC
	`

	rows, err := h.db.Query(query, guid)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var skills []models.Skill
	for rows.Next() {
		var skill models.Skill
		err := rows.Scan(
			&skill.SkillID,
			&skill.SkillName,
			&skill.Value,
			&skill.MaxValue,
		)
		if err != nil {
			continue
		}
		skills = append(skills, skill)
	}

	return skills, nil
}

type KillStats struct {
	Kills   int
	Deaths  int
	KDRatio float64
}

func (h *Handlers) getCharacterKillStats(guid int) (KillStats, error) {
	var stats KillStats

	// Get kills
	killQuery := `SELECT COUNT(*) FROM pvp_killboard WHERE killer_guid = ?`
	err := h.db.QueryRow(killQuery, guid).Scan(&stats.Kills)
	if err != nil {
		return stats, err
	}

	// Get deaths
	deathQuery := `SELECT COUNT(*) FROM pvp_killboard WHERE victim_guid = ?`
	err = h.db.QueryRow(deathQuery, guid).Scan(&stats.Deaths)
	if err != nil {
		return stats, err
	}

	// Calculate K/D ratio
	if stats.Deaths > 0 {
		stats.KDRatio = float64(stats.Kills) / float64(stats.Deaths)
	} else if stats.Kills > 0 {
		stats.KDRatio = float64(stats.Kills)
	}

	return stats, nil
}

func (h *Handlers) getCharacterBlueprints(guid int) ([]models.Blueprint, error) {
	// Check if table exists first
	// For now, return empty - blueprint system would need its own table
	return []models.Blueprint{}, nil
}
