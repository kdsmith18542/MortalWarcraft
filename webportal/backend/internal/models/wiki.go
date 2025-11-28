package models

import "time"

// Wiki Models
type WikiPage struct {
	ID                int       `json:"id"`
	Slug              string    `json:"slug"`
	Title             string    `json:"title"`
	Summary           string    `json:"summary,omitempty"`
	ContentMarkdown   string    `json:"content_markdown"`
	ContentHTML       string    `json:"content_html,omitempty"` // Rendered HTML
	Category          string    `json:"category"`
	Tags              []string  `json:"tags,omitempty"`
	Icon              string    `json:"icon,omitempty"`
	IsPublished       bool      `json:"is_published"`
	IsLocked          bool      `json:"is_locked"`
	Visibility        string    `json:"visibility"` // "public", "logged_in", "char_gated"
	MinRoleRequired   string    `json:"min_role_required"`
	CodexRequirements []string  `json:"codex_requirements,omitempty"`
	CreatedByUserID   int       `json:"created_by_user_id"`
	UpdatedByUserID   int       `json:"updated_by_user_id"`
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
}

type WikiPageVersion struct {
	ID                int       `json:"id"`
	PageID            int       `json:"page_id"`
	VersionNumber     int       `json:"version_number"`
	Title             string    `json:"title"`
	Summary           string    `json:"summary,omitempty"`
	ContentMarkdown   string    `json:"content_markdown"`
	Category          string    `json:"category"`
	Tags              []string  `json:"tags,omitempty"`
	Icon              string    `json:"icon,omitempty"`
	Visibility        string    `json:"visibility"`
	MinRoleRequired   string    `json:"min_role_required"`
	CodexRequirements []string  `json:"codex_requirements,omitempty"`
	EditedByUserID    int       `json:"edited_by_user_id"`
	EditedAt          time.Time `json:"edited_at"`
	Comment           string    `json:"comment,omitempty"`
}

type WikiPageLink struct {
	ID          int       `json:"id"`
	FromPageID  int       `json:"from_page_id"`
	ToPageID    int       `json:"to_page_id"`
	LinkText    string    `json:"link_text,omitempty"`
	CreatedAt   time.Time `json:"created_at"`
}

type WikiPageListResponse struct {
	Pages      []WikiPage `json:"pages"`
	Total      int        `json:"total"`
	Page       int        `json:"page"`
	PageSize   int        `json:"page_size"`
	Categories []string   `json:"categories,omitempty"`
}

type WikiSearchRequest struct {
	Query      string   `json:"query"`
	Category   string   `json:"category,omitempty"`
	Tags       []string `json:"tags,omitempty"`
	Page       int      `json:"page"`
	PageSize   int      `json:"page_size"`
}

