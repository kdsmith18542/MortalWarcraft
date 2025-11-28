package api

import (
	"database/sql"
	"mortal-atlas-api/internal/config"
	"mortal-atlas-api/internal/api/handlers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, db *sql.DB, cfg *config.Config) {
	// Initialize handlers
	h := handlers.New(db, cfg)

	// API v1 routes
	v1 := router.Group("/api/v1")
	{
		// Authentication
		auth := v1.Group("/auth")
		{
			auth.POST("/register", h.Register)
			auth.POST("/login", h.Login)
			auth.POST("/refresh", h.RefreshToken)
			auth.POST("/logout", h.Logout)
			auth.GET("/me", h.AuthMiddleware(), h.GetMe)
		}

		// Territory & Map
		territory := v1.Group("/territory")
		{
			territory.GET("/strongholds", h.GetStrongholds)
			territory.GET("/stronghold/:id", h.GetStronghold)
		}

		// Sieges
		sieges := v1.Group("/sieges")
		{
			sieges.GET("/upcoming", h.GetUpcomingSieges)
			sieges.GET("/:id", h.GetSiege)
			sieges.GET("/stronghold/:id/schedule", h.GetSiegeSchedule)
		}

		// Guild Politics
		politics := v1.Group("/politics")
		{
			politics.GET("/guild/:id", h.GetGuildPolitics)
			politics.GET("/all", h.GetAllGuildPolitics)
		}

		mapGroup := v1.Group("/map")
		{
			mapGroup.GET("/hotspots", h.GetHotspots)
			mapGroup.GET("/resources", h.GetResources)
		}

		// Killboard
		killboard := v1.Group("/killboard")
		{
			killboard.GET("/recent", h.GetRecentKills)
			killboard.GET("/kill/:id", h.GetKill)
			killboard.GET("/leaderboards", h.GetLeaderboards)
			killboard.GET("/search", h.SearchKills)
		}

		// Market
		market := v1.Group("/market")
		{
			market.GET("/search", h.SearchMarket)
			market.GET("/prices/:itemId", h.GetPriceHistory)
			market.GET("/arbitrage", h.GetArbitrage)
			market.GET("/trends", h.GetMarketTrends)
		}

		// Character Profiles
		character := v1.Group("/character")
		{
			character.GET("/:name", h.GetCharacterProfile)
			character.GET("/:name/skills", h.GetCharacterSkills)
			character.GET("/:name/reputation", h.GetCharacterReputation)
			character.GET("/:name/blueprints", h.GetCharacterBlueprints)
		}

		// Dashboard
		v1.GET("/dashboard", h.GetDashboard)

		// World Events
		events := v1.Group("/events")
		{
			events.GET("/world-bosses", h.GetWorldBosses)
			events.GET("/midnight-horde", h.GetMidnightHorde)
		}

		// Shop (protected routes)
		shop := v1.Group("/shop")
		shop.Use(h.AuthMiddleware())
		{
			shop.GET("/products", h.GetProducts)
			shop.POST("/purchase", h.Purchase)
			shop.GET("/subscription", h.GetSubscription)
			shop.POST("/subscription/cancel", h.CancelSubscription)
		}

		// Discourse SSO
		discourse := v1.Group("/discourse")
		discourse.Use(h.AuthMiddleware())
		{
			discourse.GET("/sso", h.DiscourseSSO)
			discourse.POST("/sync", h.DiscourseSync)
		}

		// Wiki
		wiki := v1.Group("/wiki")
		{
			wiki.GET("/pages", h.GetWikiPages)
			wiki.GET("/pages/:slug", h.GetWikiPage)
			wiki.GET("/pages/:id/versions", h.GetWikiPageVersions)
			wiki.GET("/search", h.SearchWiki)
			// Protected routes
			wiki.POST("/pages", h.AuthMiddleware(), h.CreateWikiPage)
			wiki.PUT("/pages/:slug", h.AuthMiddleware(), h.UpdateWikiPage)
		}
	}

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})
}

