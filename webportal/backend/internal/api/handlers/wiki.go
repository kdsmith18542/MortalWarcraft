package handlers

import (
	"database/sql"
	"encoding/json"
	"mortal-atlas-api/internal/models"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

// GetWikiPages - List wiki pages with pagination and filters
func (h *Handlers) GetWikiPages(c *gin.Context) {
	page := 1
	pageSize := 20
	category := c.Query("category")
	tag := c.Query("tag")
	search := c.Query("search")
	visibility := c.Query("visibility") // "public", "logged_in", "char_gated"

	if pageStr := c.Query("page"); pageStr != "" {
		if parsed, err := strconv.Atoi(pageStr); err == nil && parsed > 0 {
			page = parsed
		}
	}
	if pageSizeStr := c.Query("page_size"); pageSizeStr != "" {
		if parsed, err := strconv.Atoi(pageSizeStr); err == nil && parsed > 0 && parsed <= 100 {
			pageSize = parsed
		}
	}

	offset := (page - 1) * pageSize

	// Build query
	query := `
		SELECT 
			id, slug, title, summary, content_markdown, category, tags, icon,
			is_published, is_locked, visibility, min_role_required, codex_requirements,
			created_by_user_id, updated_by_user_id, created_at, updated_at
		FROM wiki_pages
		WHERE is_published = 1
	`
	args := []interface{}{}

	if category != "" {
		query += " AND category = ?"
		args = append(args, category)
	}

	if tag != "" {
		query += " AND tags LIKE ?"
		args = append(args, "%"+tag+"%")
	}

	if search != "" {
		query += " AND (title LIKE ? OR summary LIKE ? OR content_markdown LIKE ?)"
		searchPattern := "%" + search + "%"
		args = append(args, searchPattern, searchPattern, searchPattern)
	}

	if visibility != "" {
		query += " AND visibility = ?"
		args = append(args, visibility)
	} else {
		// Default to public only for unauthenticated users
		query += " AND visibility = 'public'"
	}

	query += " ORDER BY updated_at DESC LIMIT ? OFFSET ?"
	args = append(args, pageSize, offset)

	rows, err := h.db.Query(query, args...)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query wiki pages"})
		return
	}
	defer rows.Close()

	var pages []models.WikiPage
	for rows.Next() {
		var page models.WikiPage
		var tagsStr, codexJSON sql.NullString

		err := rows.Scan(
			&page.ID,
			&page.Slug,
			&page.Title,
			&page.Summary,
			&page.ContentMarkdown,
			&page.Category,
			&tagsStr,
			&page.Icon,
			&page.IsPublished,
			&page.IsLocked,
			&page.Visibility,
			&page.MinRoleRequired,
			&codexJSON,
			&page.CreatedByUserID,
			&page.UpdatedByUserID,
			&page.CreatedAt,
			&page.UpdatedAt,
		)
		if err != nil {
			continue
		}

		// Parse tags
		if tagsStr.Valid {
			page.Tags = strings.Split(tagsStr.String, ",")
		}

		// Parse codex requirements
		if codexJSON.Valid && codexJSON.String != "" {
			json.Unmarshal([]byte(codexJSON.String), &page.CodexRequirements)
		}

		pages = append(pages, page)
	}

	// Get total count
	countQuery := strings.Replace(query, "SELECT id, slug, title", "SELECT COUNT(*)", 1)
	countQuery = strings.Split(countQuery, "ORDER BY")[0]
	var total int
	h.db.QueryRow(countQuery, args[:len(args)-2]...).Scan(&total)

	c.JSON(http.StatusOK, models.WikiPageListResponse{
		Pages:    pages,
		Total:    total,
		Page:     page,
		PageSize: pageSize,
	})
}

// GetWikiPage - Get a single wiki page by slug
func (h *Handlers) GetWikiPage(c *gin.Context) {
	slug := c.Param("slug")

	query := `
		SELECT 
			id, slug, title, summary, content_markdown, category, tags, icon,
			is_published, is_locked, visibility, min_role_required, codex_requirements,
			created_by_user_id, updated_by_user_id, created_at, updated_at
		FROM wiki_pages
		WHERE slug = ? AND is_published = 1
	`

	var page models.WikiPage
	var tagsStr, codexJSON sql.NullString

	err := h.db.QueryRow(query, slug).Scan(
		&page.ID,
		&page.Slug,
		&page.Title,
		&page.Summary,
		&page.ContentMarkdown,
		&page.Category,
		&tagsStr,
		&page.Icon,
		&page.IsPublished,
		&page.IsLocked,
		&page.Visibility,
		&page.MinRoleRequired,
		&codexJSON,
		&page.CreatedByUserID,
		&page.UpdatedByUserID,
		&page.CreatedAt,
		&page.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Page not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query wiki page"})
		return
	}

	// Parse tags
	if tagsStr.Valid {
		page.Tags = strings.Split(tagsStr.String, ",")
	}

	// Parse codex requirements
	if codexJSON.Valid && codexJSON.String != "" {
		json.Unmarshal([]byte(codexJSON.String), &page.CodexRequirements)
	}

	c.JSON(http.StatusOK, page)
}

// GetWikiPageVersions - Get version history for a wiki page
func (h *Handlers) GetWikiPageVersions(c *gin.Context) {
	pageID, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid page ID"})
		return
	}

	query := `
		SELECT 
			id, page_id, version_number, title, summary, content_markdown,
			category, tags, icon, visibility, min_role_required, codex_requirements,
			edited_by_user_id, edited_at, comment
		FROM wiki_page_versions
		WHERE page_id = ?
		ORDER BY version_number DESC
	`

	rows, err := h.db.Query(query, pageID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query versions"})
		return
	}
	defer rows.Close()

	var versions []models.WikiPageVersion
	for rows.Next() {
		var version models.WikiPageVersion
		var tagsStr, codexJSON sql.NullString

		err := rows.Scan(
			&version.ID,
			&version.PageID,
			&version.VersionNumber,
			&version.Title,
			&version.Summary,
			&version.ContentMarkdown,
			&version.Category,
			&tagsStr,
			&version.Icon,
			&version.Visibility,
			&version.MinRoleRequired,
			&codexJSON,
			&version.EditedByUserID,
			&version.EditedAt,
			&version.Comment,
		)
		if err != nil {
			continue
		}

		if tagsStr.Valid {
			version.Tags = strings.Split(tagsStr.String, ",")
		}

		if codexJSON.Valid && codexJSON.String != "" {
			json.Unmarshal([]byte(codexJSON.String), &version.CodexRequirements)
		}

		versions = append(versions, version)
	}

	c.JSON(http.StatusOK, gin.H{"versions": versions})
}

// CreateWikiPage - Create a new wiki page (requires auth)
func (h *Handlers) CreateWikiPage(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	userRole, _ := c.Get("user_role")
	role := "user"
	if userRole != nil {
		role = userRole.(string)
	}

	var req models.WikiPage
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Validate required fields
	if req.Title == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Title is required"})
		return
	}

	// Generate slug from title if not provided
	slug := req.Slug
	if slug == "" {
		slug = strings.ToLower(strings.ReplaceAll(req.Title, " ", "-"))
		slug = strings.ReplaceAll(slug, "'", "")
		slug = strings.ReplaceAll(slug, "\"", "")
		// Remove special characters
		slug = strings.Map(func(r rune) rune {
			if (r >= 'a' && r <= 'z') || (r >= '0' && r <= '9') || r == '-' {
				return r
			}
			return -1
		}, slug)
	}

	// Check if slug already exists
	var existingID int
	err := h.db.QueryRow("SELECT id FROM wiki_pages WHERE slug = ?", slug).Scan(&existingID)
	if err == nil {
		c.JSON(http.StatusConflict, gin.H{"error": "Slug already exists"})
		return
	}

	// Validate permissions
	if req.MinRoleRequired != "" && role == "user" && req.MinRoleRequired != "reader" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Insufficient permissions"})
		return
	}

	// Prepare tags
	tagsStr := ""
	if len(req.Tags) > 0 {
		tagsStr = strings.Join(req.Tags, ",")
	}

	// Prepare codex requirements
	codexJSON := "null"
	if len(req.CodexRequirements) > 0 {
		codexBytes, _ := json.Marshal(req.CodexRequirements)
		codexJSON = string(codexBytes)
	}

	// Default values
	if req.Category == "" {
		req.Category = "general"
	}
	if req.Visibility == "" {
		req.Visibility = "public"
	}
	if req.MinRoleRequired == "" {
		req.MinRoleRequired = "reader"
	}

	// Insert page
	result, err := h.db.Exec(
		`INSERT INTO wiki_pages 
		 (slug, title, summary, content_markdown, category, tags, icon, 
		  is_published, is_locked, visibility, min_role_required, codex_requirements,
		  created_by_user_id, updated_by_user_id)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		slug, req.Title, req.Summary, req.ContentMarkdown, req.Category, tagsStr, req.Icon,
		req.IsPublished, req.IsLocked, req.Visibility, req.MinRoleRequired, codexJSON,
		userID, userID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create page"})
		return
	}

	pageID, _ := result.LastInsertId()

	// Create initial version
	h.db.Exec(
		`INSERT INTO wiki_page_versions 
		 (page_id, version_number, title, summary, content_markdown, category, tags, icon,
		  visibility, min_role_required, codex_requirements, edited_by_user_id, comment)
		 VALUES (?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		pageID, req.Title, req.Summary, req.ContentMarkdown, req.Category, tagsStr, req.Icon,
		req.Visibility, req.MinRoleRequired, codexJSON, userID, "Initial version",
	)

	// Return created page
	req.ID = int(pageID)
	req.Slug = slug
	req.CreatedByUserID = userID.(int)
	req.UpdatedByUserID = userID.(int)

	c.JSON(http.StatusCreated, req)
}

// UpdateWikiPage - Update a wiki page (requires auth)
func (h *Handlers) UpdateWikiPage(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	userRole, _ := c.Get("user_role")
	role := "user"
	if userRole != nil {
		role = userRole.(string)
	}

	slug := c.Param("slug")

	// Check if page exists
	var existingPage models.WikiPage
	var existingTags, existingCodex sql.NullString
	err := h.db.QueryRow(
		`SELECT id, slug, title, summary, content_markdown, category, tags, icon,
		 is_published, is_locked, visibility, min_role_required, codex_requirements,
		 created_by_user_id, updated_by_user_id
		 FROM wiki_pages WHERE slug = ?`,
		slug,
	).Scan(
		&existingPage.ID, &existingPage.Slug, &existingPage.Title, &existingPage.Summary,
		&existingPage.ContentMarkdown, &existingPage.Category, &existingTags, &existingPage.Icon,
		&existingPage.IsPublished, &existingPage.IsLocked, &existingPage.Visibility,
		&existingPage.MinRoleRequired, &existingCodex, &existingPage.CreatedByUserID,
		&existingPage.UpdatedByUserID,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Page not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query page"})
		return
	}

	// Check permissions
	if existingPage.IsLocked && role != "admin" && role != "moderator" {
		c.JSON(http.StatusForbidden, gin.H{"error": "Page is locked"})
		return
	}

	if existingPage.MinRoleRequired != "" {
		roleHierarchy := map[string]int{"reader": 1, "contributor": 2, "moderator": 3, "admin": 4}
		userLevel := roleHierarchy[role]
		requiredLevel := roleHierarchy[existingPage.MinRoleRequired]
		if userLevel < requiredLevel {
			c.JSON(http.StatusForbidden, gin.H{"error": "Insufficient permissions"})
			return
		}
	}

	var req models.WikiPage
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Get current version number
	var maxVersion int
	h.db.QueryRow("SELECT COALESCE(MAX(version_number), 0) FROM wiki_page_versions WHERE page_id = ?", existingPage.ID).Scan(&maxVersion)
	nextVersion := maxVersion + 1

	// Create version snapshot before update
	var oldTags, oldCodex string
	if existingTags.Valid {
		oldTags = existingTags.String
	}
	if existingCodex.Valid {
		oldCodex = existingCodex.String
	}

	h.db.Exec(
		`INSERT INTO wiki_page_versions 
		 (page_id, version_number, title, summary, content_markdown, category, tags, icon,
		  visibility, min_role_required, codex_requirements, edited_by_user_id, comment)
		 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		existingPage.ID, nextVersion, existingPage.Title, existingPage.Summary,
		existingPage.ContentMarkdown, existingPage.Category, oldTags, existingPage.Icon,
		existingPage.Visibility, existingPage.MinRoleRequired, oldCodex,
		existingPage.UpdatedByUserID, "Version before update",
	)

	// Prepare update fields
	tagsStr := oldTags
	if len(req.Tags) > 0 {
		tagsStr = strings.Join(req.Tags, ",")
	}

	codexJSON := oldCodex
	if len(req.CodexRequirements) > 0 {
		codexBytes, _ := json.Marshal(req.CodexRequirements)
		codexJSON = string(codexBytes)
	} else if req.CodexRequirements == nil && oldCodex == "" {
		codexJSON = "null"
	}

	// Update page
	_, err = h.db.Exec(
		`UPDATE wiki_pages SET
		 title = COALESCE(NULLIF(?, ''), title),
		 summary = COALESCE(NULLIF(?, ''), summary),
		 content_markdown = COALESCE(NULLIF(?, ''), content_markdown),
		 category = COALESCE(NULLIF(?, ''), category),
		 tags = ?,
		 icon = COALESCE(NULLIF(?, ''), icon),
		 is_published = COALESCE(?, is_published),
		 is_locked = COALESCE(?, is_locked),
		 visibility = COALESCE(NULLIF(?, ''), visibility),
		 min_role_required = COALESCE(NULLIF(?, ''), min_role_required),
		 codex_requirements = ?,
		 updated_by_user_id = ?,
		 updated_at = NOW()
		 WHERE slug = ?`,
		req.Title, req.Summary, req.ContentMarkdown, req.Category, tagsStr, req.Icon,
		req.IsPublished, req.IsLocked, req.Visibility, req.MinRoleRequired, codexJSON,
		userID, slug,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update page"})
		return
	}

	// Return updated page
	h.GetWikiPage(c)
}

// SearchWiki - Search wiki pages
func (h *Handlers) SearchWiki(c *gin.Context) {
	query := c.Query("q")
	if query == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Query parameter required"})
		return
	}

	// Use GetWikiPages with search parameter
	h.GetWikiPages(c)
}

