package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"mortal-atlas-api/internal/util"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

// Register - Create a new user account
func (h *Handlers) Register(c *gin.Context) {
	var req models.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Check if user already exists
	var existingID int
	err := h.db.QueryRow("SELECT id FROM atlas_users WHERE email = ?", req.Email).Scan(&existingID)
	if err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Email already registered"})
		return
	}
	if err != sql.ErrNoRows {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	// Hash password
	hashedPassword, err := util.HashPassword(req.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to hash password"})
		return
	}

	// Create user
	result, err := h.db.Exec(
		"INSERT INTO atlas_users (email, password_hash, role) VALUES (?, ?, 'user')",
		req.Email, hashedPassword,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	userID, _ := result.LastInsertId()

	// Generate token
	expiryHours := 24
	if expiryStr := h.cfg.JWT.Expiry; expiryStr != "" {
		if hours, err := strconv.Atoi(strings.TrimSuffix(expiryStr, "h")); err == nil {
			expiryHours = hours
		}
	}

	token, err := util.GenerateToken(int(userID), req.Email, "user", h.cfg.JWT.Secret, expiryHours)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, models.AuthResponse{
		Token:     token,
		User: models.User{
			ID:    int(userID),
			Email: req.Email,
			Role:  "user",
		},
		ExpiresIn: expiryHours * 3600,
	})
}

// Login - Authenticate user and return JWT token
func (h *Handlers) Login(c *gin.Context) {
	var req models.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Get user
	var user models.User
	var passwordHash string
	err := h.db.QueryRow(
		"SELECT id, email, password_hash, role FROM atlas_users WHERE email = ?",
		req.Email,
	).Scan(&user.ID, &user.Email, &passwordHash, &user.Role)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	// Check password
	if !util.CheckPasswordHash(req.Password, passwordHash) {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	// Generate token
	expiryHours := 24
	if expiryStr := h.cfg.JWT.Expiry; expiryStr != "" {
		if hours, err := strconv.Atoi(strings.TrimSuffix(expiryStr, "h")); err == nil {
			expiryHours = hours
		}
	}

	token, err := util.GenerateToken(user.ID, user.Email, user.Role, h.cfg.JWT.Secret, expiryHours)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, models.AuthResponse{
		Token:     token,
		User:      user,
		ExpiresIn: expiryHours * 3600,
	})
}

// RefreshToken - Refresh JWT token
func (h *Handlers) RefreshToken(c *gin.Context) {
	// Get token from Authorization header
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Missing authorization header"})
		return
	}

	tokenString := strings.TrimPrefix(authHeader, "Bearer ")

	// Validate token
	claims, err := util.ValidateToken(tokenString, h.cfg.JWT.Secret)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
		return
	}

	// Get user
	var user models.User
	err = h.db.QueryRow(
		"SELECT id, email, role FROM atlas_users WHERE id = ?",
		claims.UserID,
	).Scan(&user.ID, &user.Email, &user.Role)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	// Generate new token
	expiryHours := 24
	if expiryStr := h.cfg.JWT.Expiry; expiryStr != "" {
		if hours, err := strconv.Atoi(strings.TrimSuffix(expiryStr, "h")); err == nil {
			expiryHours = hours
		}
	}

	token, err := util.GenerateToken(user.ID, user.Email, user.Role, h.cfg.JWT.Secret, expiryHours)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to generate token"})
		return
	}

	c.JSON(http.StatusOK, models.AuthResponse{
		Token:     token,
		User:      user,
		ExpiresIn: expiryHours * 3600,
	})
}

// Logout - Logout (client-side token removal, server can blacklist if needed)
func (h *Handlers) Logout(c *gin.Context) {
	// For now, logout is handled client-side by removing the token
	// In production, you might want to implement token blacklisting
	c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
}

// AuthMiddleware - JWT authentication middleware
func (h *Handlers) AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Missing authorization header"})
			c.Abort()
			return
		}

		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		claims, err := util.ValidateToken(tokenString, h.cfg.JWT.Secret)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid token"})
			c.Abort()
			return
		}

		// Set user info in context
		c.Set("user_id", claims.UserID)
		c.Set("user_email", claims.Email)
		c.Set("user_role", claims.Role)

		c.Next()
	}
}

// GetMe - Get current user info
func (h *Handlers) GetMe(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	var user models.User
	err := h.db.QueryRow(
		"SELECT id, email, role, created_at FROM atlas_users WHERE id = ?",
		userID,
	).Scan(&user.ID, &user.Email, &user.Role, &user.CreatedAt)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	c.JSON(http.StatusOK, user)
}

