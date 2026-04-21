-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — REPUTATION SYSTEM
-- ==============================================================================
-- Run this SQL to create the dealer reputation table.
-- Compatible with oxmysql / mysql-async / ghmattimysql
-- ==============================================================================

CREATE TABLE IF NOT EXISTS `djonstnix_drug_rep` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizenid` VARCHAR(50) NOT NULL,
    `dealer_id` VARCHAR(50) NOT NULL,
    `points` INT DEFAULT 0,
    `level` INT DEFAULT 1,
    `total_sales` INT DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `unique_player_dealer` (`citizenid`, `dealer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
