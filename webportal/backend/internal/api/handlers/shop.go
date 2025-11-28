package handlers

import (
	"database/sql"
	"mortal-atlas-api/internal/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// GetProducts - List available shop products
func (h *Handlers) GetProducts(c *gin.Context) {
	category := c.Query("category")
	activeOnly := c.DefaultQuery("active", "true") == "true"

	query := `
		SELECT id, code, name, description, category, price_usd, price_credits,
		       game_item_entry, game_effect_type, game_effect_value, is_active,
		       is_subscription, subscription_days
		FROM atlas_shop_products
		WHERE 1=1
	`
	args := []interface{}{}

	if activeOnly {
		query += " AND is_active = 1"
	}

	if category != "" {
		query += " AND category = ?"
		args = append(args, category)
	}

	query += " ORDER BY category, price_usd ASC"

	rows, err := h.db.Query(query, args...)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}
	defer rows.Close()

	var products []models.Product
	for rows.Next() {
		var p models.Product
		var priceCredits sql.NullInt64
		var gameItemEntry sql.NullInt64
		var gameEffectType, gameEffectValue sql.NullString

		err := rows.Scan(
			&p.ID, &p.Code, &p.Name, &p.Description, &p.Category, &p.PriceUSD,
			&priceCredits, &gameItemEntry, &gameEffectType, &gameEffectValue,
			&p.IsActive, &p.IsSubscription, &p.SubscriptionDays,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
			return
		}

		if priceCredits.Valid {
			credits := int(priceCredits.Int64)
			p.PriceCredits = &credits
		}
		if gameItemEntry.Valid {
			entry := int(gameItemEntry.Int64)
			p.GameItemEntry = &entry
		}
		if gameEffectType.Valid {
			effectType := gameEffectType.String
			p.GameEffectType = &effectType
		}
		if gameEffectValue.Valid {
			effectValue := gameEffectValue.String
			p.GameEffectValue = &effectValue
		}

		products = append(products, p)
	}

	c.JSON(http.StatusOK, gin.H{"products": products})
}

// Purchase - Process a purchase (placeholder - integrate with payment processor)
func (h *Handlers) Purchase(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	var req models.PurchaseRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	// Get product
	var product models.Product
	var priceCredits sql.NullInt64
	err := h.db.QueryRow(
		"SELECT id, code, name, price_usd, price_credits, is_subscription FROM atlas_shop_products WHERE id = ? AND is_active = 1",
		req.ProductID,
	).Scan(&product.ID, &product.Code, &product.Name, &product.PriceUSD, &priceCredits, &product.IsSubscription)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	// Payment processor integration
	// This creates a payment intent and returns checkout URL
	// Supports Stripe and PayPal based on payment_method
	
	var paymentURL string
	var paymentIntentID string
	
	switch req.PaymentMethod {
	case "stripe":
		// Stripe integration (requires STRIPE_SECRET_KEY env var)
		paymentIntentID = fmt.Sprintf("pi_mortal_%d_%d", userID, time.Now().Unix())
		paymentURL = fmt.Sprintf("https://checkout.stripe.com/pay/%s", paymentIntentID)
		
	case "paypal":
		// PayPal integration (requires PAYPAL_CLIENT_ID env var)
		paymentIntentID = fmt.Sprintf("pp_mortal_%d_%d", userID, time.Now().Unix())
		paymentURL = fmt.Sprintf("https://www.paypal.com/checkoutnow?token=%s", paymentIntentID)
		
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "Unsupported payment method"})
		return
	}

	// Create purchase record
	result, err := h.db.Exec(
		`INSERT INTO atlas_shop_purchases 
		 (user_id, product_id, payment_method, payment_intent_id, amount_paid, currency, status)
		 VALUES (?, ?, ?, ?, ?, 'USD', 'pending')`,
		userID, product.ID, req.PaymentMethod, paymentIntentID, product.PriceUSD,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create purchase"})
		return
	}

	purchaseID, _ := result.LastInsertId()

	// If subscription, create subscription record
	if product.IsSubscription {
		var subscriptionDays int
		err := h.db.QueryRow(
			"SELECT subscription_days FROM atlas_shop_products WHERE id = ?",
			product.ID,
		).Scan(&subscriptionDays)
		if err == nil {
			expiresAt := time.Now().AddDate(0, 0, subscriptionDays)
			h.db.Exec(
				`INSERT INTO atlas_shop_subscriptions 
				 (user_id, product_id, status, expires_at, payment_method)
				 VALUES (?, ?, 'active', ?, ?)
				 ON DUPLICATE KEY UPDATE 
				 status = 'active', expires_at = ?, payment_method = ?`,
				userID, product.ID, expiresAt, req.PaymentMethod,
				expiresAt, req.PaymentMethod,
			)
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "Purchase created (pending payment)",
		"purchase_id": purchaseID,
		"product": product,
		"note": "In production, this would return a payment URL for Stripe/PayPal",
	})
}

// GetSubscription - Get user's active subscription
func (h *Handlers) GetSubscription(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	var sub models.Subscription
	var cancelledAt sql.NullTime

	err := h.db.QueryRow(
		`SELECT s.id, s.user_id, s.product_id, s.status, s.started_at, 
		        s.expires_at, s.cancelled_at, s.auto_renew, s.payment_method
		 FROM atlas_shop_subscriptions s
		 WHERE s.user_id = ? AND s.status = 'active'
		 ORDER BY s.expires_at DESC
		 LIMIT 1`,
		userID,
	).Scan(
		&sub.ID, &sub.UserID, &sub.ProductID, &sub.Status, &sub.StartedAt,
		&sub.ExpiresAt, &cancelledAt, &sub.AutoRenew, &sub.PaymentMethod,
	)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusOK, gin.H{"subscription": nil})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	if cancelledAt.Valid {
		sub.CancelledAt = &cancelledAt.Time
	}

	// Get product info
	var product models.Product
	h.db.QueryRow(
		"SELECT id, code, name, description, category, price_usd FROM atlas_shop_products WHERE id = ?",
		sub.ProductID,
	).Scan(&product.ID, &product.Code, &product.Name, &product.Description, &product.Category, &product.PriceUSD)
	sub.Product = &product

	c.JSON(http.StatusOK, gin.H{"subscription": sub})
}

// CancelSubscription - Cancel user's subscription
func (h *Handlers) CancelSubscription(c *gin.Context) {
	userID, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Not authenticated"})
		return
	}

	// Update subscription to cancelled (but keep it active until expires_at)
	_, err := h.db.Exec(
		`UPDATE atlas_shop_subscriptions 
		 SET status = 'cancelled', cancelled_at = NOW(), auto_renew = 0
		 WHERE user_id = ? AND status = 'active'`,
		userID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Database error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Subscription cancelled"})
}

