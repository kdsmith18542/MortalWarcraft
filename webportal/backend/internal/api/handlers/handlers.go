package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/config"
	"github.com/gin-gonic/gin"
)

type Handlers struct {
	db  *sql.DB
	cfg *config.Config
}

func New(db *sql.DB, cfg *config.Config) *Handlers {
	return &Handlers{
		db:  db,
		cfg: cfg,
	}
}

// Auth handlers are implemented in auth.go

// Territory handlers are implemented in territory.go

// Siege handlers are implemented in sieges.go

// Map handlers are implemented in map.go

// Killboard handlers are implemented in killboard.go

// Market handlers are implemented in market.go

// Character handlers are implemented in character.go

// GetDashboard is implemented in dashboard.go

// GetWorldBosses is implemented in dashboard.go

// GetMidnightHorde is implemented in dashboard.go

// Shop handlers are implemented in shop.go

// Discourse handlers are implemented in discourse.go

// AuthMiddleware is implemented in auth.go

