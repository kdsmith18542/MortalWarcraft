package handlers

import (
	"crypto/hmac"
	"crypto/sha256"
	"database/sql"
	"encoding/hex"
	"fmt"
	"mortal-atlas-api/internal/util"
	"net/http"
	"net/url"

	"github.com/gin-gonic/gin"
)

// DiscourseSSO - Handle Discourse SSO login request
// GET /api/v1/discourse/sso?sso=...&sig=...
func (h *Handlers) DiscourseSSO(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	// Get SSO payload and signature from query
	ssoPayload := c.Query("sso")
	sig := c.Query("sig")

	if ssoPayload == "" || sig == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing sso or sig parameters"})
		return
	}

	// Validate signature
	payload, err := util.ValidateDiscourseSSO(ssoPayload, sig, h.cfg.Discourse.Secret)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid SSO signature"})
		return
	}

	// Get user info
	var email, role string
	err = h.db.QueryRow(
		"SELECT email, role FROM atlas_users WHERE id = ?",
		userID,
	).Scan(&email, &role)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	// Get character name (if linked to game account)
	var characterName sql.NullString
	var accountID sql.NullInt64
	
	// Get linked account ID
	err = h.db.QueryRow(
		"SELECT account_id FROM atlas_user_game_link WHERE atlas_user_id = ? LIMIT 1",
		userID,
	).Scan(&accountID)
	
	if err == nil && accountID.Valid {
		// Get character name from linked account
		h.db.QueryRow(
			"SELECT name FROM characters WHERE account = ? ORDER BY guid ASC LIMIT 1",
			accountID.Int64,
		).Scan(&characterName)
	}
	
	charName := ""
	if characterName.Valid {
		charName = characterName.String
	}

	// Build response payload
	responseData := map[string]string{
		"nonce":        payload["nonce"],
		"email":        email,
		"external_id":  fmt.Sprintf("%d", userID), // Discourse user ID
		"username":     email,                      // Use email as username, or character name if available
		"name":         charName,                   // Character name if available
		"admin":        "false",                    // Set based on role
		"moderator":    "false",                    // Set based on role
		"require_activation": "false",
	}

	if role == "admin" {
		responseData["admin"] = "true"
		responseData["moderator"] = "true"
	} else if role == "moderator" {
		responseData["moderator"] = "true"
	}

	// Generate response
	responsePayload, err := util.GenerateDiscourseResponse(responseData, h.cfg.Discourse.Secret)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate response"})
		return
	}

	// Redirect to Discourse
	discourseURL := h.cfg.Discourse.URL
	if discourseURL == "" {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Discourse URL not configured"})
		return
	}

	// Extract signature from responsePayload (format: "payload&sig=signature")
	parts := util.SplitSSOResponse(responsePayload)
	if len(parts) != 2 || parts[0] == "" || parts[1] == "" {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid response format"})
		return
	}

	redirectURL := fmt.Sprintf("%s/session/sso_login?sso=%s&sig=%s",
		discourseURL,
		url.QueryEscape(parts[0]), // payload
		url.QueryEscape(parts[1]), // signature
	)

	c.Redirect(http.StatusFound, redirectURL)
}

// DiscourseSync - Sync user data with Discourse (webhook from Discourse)
func (h *Handlers) DiscourseSync(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	var req struct {
		DiscourseUserID int    `json:"discourse_user_id"`
		Email           string `json:"email"`
		Username        string `json:"username"`
		Admin           bool   `json:"admin"`
		Moderator       bool   `json:"moderator"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Update user role based on Discourse status
	newRole := "user"
	if req.Admin {
		newRole = "admin"
	} else if req.Moderator {
		newRole = "moderator"
	}

	// Update atlas_users if email matches
	_, err := h.db.Exec(
		"UPDATE atlas_users SET role = ? WHERE id = ? AND email = ?",
		newRole, userID, req.Email,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to sync user"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "User synced successfully",
		"user_id": userID,
		"role":    newRole,
	})
}

