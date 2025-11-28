-- ==================================================
-- Project Mortal Warcraft
-- Feature: Itemization ETL Foundation
-- Description: Foundation tables for itemization bulk reworks
-- Based on: docs/specs/19-itemization.md
-- ==================================================

-- Item Transformation Rules
CREATE TABLE IF NOT EXISTS `mortal_item_transforms` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `source_item_entry` INT UNSIGNED NOT NULL COMMENT 'item_template.entry to transform',
    `target_item_entry` INT UNSIGNED NULL COMMENT 'New item entry (if creating new)',
    `transform_type` VARCHAR(32) NOT NULL COMMENT 'STAT_ADJUST, TIER_REASSIGN, VISUAL_UPDATE, FULL_REPLACE',
    `stat_adjustments_json` JSON NULL COMMENT 'Stat changes to apply',
    `tier_reassignment` VARCHAR(16) NULL COMMENT 'M-T1, M-T2, M-T3, M-T4, M-T5',
    `visual_update_id` INT UNSIGNED NULL COMMENT 'mortal_gear_visuals.id',
    `is_bulk_operation` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 if part of bulk transform',
    `batch_id` VARCHAR(64) NULL COMMENT 'Batch identifier for grouped transforms',
    `status` VARCHAR(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING, APPLIED, FAILED, ROLLED_BACK',
    `applied_at` INT UNSIGNED NULL,
    `applied_by` VARCHAR(64) NULL COMMENT 'Admin/system identifier',
    `notes` VARCHAR(255) NULL,
    INDEX `idx_source` (`source_item_entry`),
    INDEX `idx_batch` (`batch_id`),
    INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Item transformation rules';

-- Item Transformation Log
CREATE TABLE IF NOT EXISTS `mortal_item_transform_log` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `transform_id` INT UNSIGNED NOT NULL,
    `item_entry` INT UNSIGNED NOT NULL,
    `operation` VARCHAR(32) NOT NULL COMMENT 'TRANSFORM, ROLLBACK, VERIFY',
    `before_state_json` JSON NULL COMMENT 'Item state before transform',
    `after_state_json` JSON NULL COMMENT 'Item state after transform',
    `result` VARCHAR(16) NOT NULL COMMENT 'SUCCESS, FAILED, SKIPPED',
    `error_message` TEXT NULL,
    `executed_at` INT UNSIGNED NOT NULL DEFAULT 0,
    INDEX `idx_transform` (`transform_id`),
    INDEX `idx_item` (`item_entry`),
    INDEX `idx_result` (`result`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Item transformation execution log';

-- Bulk Transform Batches
CREATE TABLE IF NOT EXISTS `mortal_bulk_transform_batches` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `batch_name` VARCHAR(128) NOT NULL,
    `batch_description` TEXT NULL,
    `transform_type` VARCHAR(32) NOT NULL,
    `item_filter_json` JSON NULL COMMENT 'Filter criteria for items to transform',
    `total_items` INT UNSIGNED NOT NULL DEFAULT 0,
    `processed_items` INT UNSIGNED NOT NULL DEFAULT 0,
    `successful_items` INT UNSIGNED NOT NULL DEFAULT 0,
    `failed_items` INT UNSIGNED NOT NULL DEFAULT 0,
    `status` VARCHAR(16) NOT NULL DEFAULT 'PENDING' COMMENT 'PENDING, RUNNING, COMPLETED, FAILED, ROLLED_BACK',
    `started_at` INT UNSIGNED NULL,
    `completed_at` INT UNSIGNED NULL,
    `created_by` VARCHAR(64) NULL,
    INDEX `idx_status` (`status`),
    INDEX `idx_type` (`transform_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bulk transform batch tracking';

-- Summary
SELECT 
    'Itemization ETL Foundation Created' as summary,
    'Ready for bulk transforms' as status;

