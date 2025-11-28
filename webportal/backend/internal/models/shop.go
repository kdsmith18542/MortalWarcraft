package models

import "time"

type Product struct {
	ID              uint    `json:"id"`
	Code            string  `json:"code"`
	Name            string  `json:"name"`
	Description     string  `json:"description"`
	Category        string  `json:"category"`
	PriceUSD        float64 `json:"price_usd"`
	PriceCredits    *int    `json:"price_credits,omitempty"`
	GameItemEntry   *int    `json:"game_item_entry,omitempty"`
	GameEffectType  *string `json:"game_effect_type,omitempty"`
	GameEffectValue *string `json:"game_effect_value,omitempty"`
	IsActive        bool    `json:"is_active"`
	IsSubscription bool    `json:"is_subscription"`
	SubscriptionDays *int  `json:"subscription_days,omitempty"`
}

type PurchaseRequest struct {
	ProductID    uint   `json:"product_id" binding:"required"`
	PaymentMethod string `json:"payment_method" binding:"required,oneof=stripe paypal credits"`
}

type Purchase struct {
	ID            uint      `json:"id"`
	UserID        uint      `json:"user_id"`
	ProductID     uint      `json:"product_id"`
	Product       *Product  `json:"product,omitempty"`
	PaymentMethod string    `json:"payment_method"`
	PaymentID     *string   `json:"payment_id,omitempty"`
	AmountPaid    float64   `json:"amount_paid"`
	Currency      string    `json:"currency"`
	Status        string    `json:"status"`
	GameDelivered bool      `json:"game_delivered"`
	CreatedAt     time.Time `json:"created_at"`
}

type Subscription struct {
	ID            uint       `json:"id"`
	UserID        uint       `json:"user_id"`
	ProductID     uint       `json:"product_id"`
	Product       *Product   `json:"product,omitempty"`
	Status        string     `json:"status"`
	StartedAt     time.Time  `json:"started_at"`
	ExpiresAt     time.Time  `json:"expires_at"`
	CancelledAt   *time.Time `json:"cancelled_at,omitempty"`
	AutoRenew     bool       `json:"auto_renew"`
	PaymentMethod string     `json:"payment_method"`
}

