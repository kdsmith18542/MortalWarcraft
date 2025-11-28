-- ==================================================
-- Project Mortal Warcraft
-- Feature: Web Portal Shop System
-- Description: Monetization shop for cosmetic items, subscriptions, etc.
-- Based on: docs/specs/24-webportal-mortal-atlas.md
-- ==================================================

START TRANSACTION;

-- ------------------------------------------------------------------
-- 1. atlas_shop_products
-- Products available for purchase
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `atlas_shop_products` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `code` VARCHAR(64) NOT NULL UNIQUE COMMENT 'e.g., COSMETIC_TITLE_LEGENDARY',
    `name` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `category` VARCHAR(32) NOT NULL COMMENT 'cosmetic, subscription, boost, currency',
    `price_usd` DECIMAL(10,2) NOT NULL COMMENT 'Price in USD',
    `price_credits` INT UNSIGNED NULL COMMENT 'Alternative price in credits',
    `game_item_entry` INT UNSIGNED NULL COMMENT 'FK to item_template.entry if applicable',
    `game_effect_type` VARCHAR(32) NULL COMMENT 'title, mount, pet, boost, currency',
    `game_effect_value` VARCHAR(255) NULL COMMENT 'JSON or string value for effect',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `is_subscription` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if recurring subscription',
    `subscription_days` INT UNSIGNED NULL COMMENT 'Days for subscription (30, 90, 365)',
    `created_at` TIMESTAMP NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT 0 ,
    INDEX `idx_category` (`category`),
    INDEX `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Shop Products';

-- ------------------------------------------------------------------
-- 2. atlas_shop_purchases
-- Purchase history
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `atlas_shop_purchases` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT UNSIGNED NOT NULL COMMENT 'FK to atlas_users.id',
    `product_id` INT UNSIGNED NOT NULL COMMENT 'FK to atlas_shop_products.id',
    `payment_method` VARCHAR(32) NOT NULL COMMENT 'stripe, paypal, credits',
    `payment_id` VARCHAR(255) NULL COMMENT 'External payment ID (Stripe charge ID, etc.)',
    `amount_paid` DECIMAL(10,2) NOT NULL,
    `currency` VARCHAR(8) NOT NULL DEFAULT 'USD',
    `status` VARCHAR(16) NOT NULL DEFAULT 'pending' COMMENT 'pending, completed, failed, refunded',
    `game_delivered` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if item/effect delivered to game',
    `delivered_at` TIMESTAMP NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT 0,
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_product_id` (`product_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_payment_id` (`payment_id`),
    FOREIGN KEY (`user_id`) REFERENCES `atlas_users` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `atlas_shop_products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Shop Purchase History';

-- ------------------------------------------------------------------
-- 3. atlas_shop_subscriptions
-- Active user subscriptions
-- ------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `atlas_shop_subscriptions` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT UNSIGNED NOT NULL COMMENT 'FK to atlas_users.id',
    `product_id` INT UNSIGNED NOT NULL COMMENT 'FK to atlas_shop_products.id',
    `status` VARCHAR(16) NOT NULL DEFAULT 'active' COMMENT 'active, cancelled, expired',
    `started_at` TIMESTAMP NOT NULL DEFAULT 0,
    `expires_at` TIMESTAMP NOT NULL,
    `cancelled_at` TIMESTAMP NULL,
    `auto_renew` TINYINT(1) NOT NULL DEFAULT 1,
    `payment_method` VARCHAR(32) NOT NULL,
    `last_payment_id` VARCHAR(255) NULL,
    UNIQUE KEY `uk_user_product` (`user_id`, `product_id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_expires_at` (`expires_at`),
    FOREIGN KEY (`user_id`) REFERENCES `atlas_users` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `atlas_shop_products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='User Subscriptions';

-- Seed data: Example products
INSERT INTO `atlas_shop_products` (`code`, `name`, `description`, `category`, `price_usd`, `game_effect_type`, `game_effect_value`, `is_subscription`, `subscription_days`) VALUES
('SUBSCRIPTION_MONTHLY', 'Monthly Subscription', 'Premium subscription with exclusive benefits', 'subscription', 9.99, 'subscription', '{"benefits": ["exclusive_title", "priority_support"]}', 1, 30),
('SUBSCRIPTION_YEARLY', 'Yearly Subscription', 'Premium subscription with exclusive benefits (best value)', 'subscription', 99.99, 'subscription', '{"benefits": ["exclusive_title", "priority_support"]}', 1, 365),
('COSMETIC_TITLE_LEGENDARY', 'Legendary Title', 'Exclusive "Legendary" title for your character', 'cosmetic', 4.99, 'title', 'Legendary', 0, NULL),
('COSMETIC_MOUNT_EXCLUSIVE', 'Exclusive Mount', 'Special mount skin (requires mount ownership)', 'cosmetic', 14.99, 'mount', '{"mount_entry": 12345}', 0, NULL);

COMMIT;

SELECT 'Atlas Shop tables created successfully.' AS result;
SELECT 'Tables: atlas_shop_products, atlas_shop_purchases, atlas_shop_subscriptions' AS result;

