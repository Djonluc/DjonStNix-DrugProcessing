-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — COMPLETE INSTALLATION
-- ==============================================================================
-- This SQL file contains all tables required for the drug processing resource.
-- Includes: Dynamic Market Tracking & Laboratory Maintenance System.
-- ==============================================================================

-- 1. DYNAMIC MARKET TRACKING
CREATE TABLE IF NOT EXISTS `djonstnix_drug_market` (
    `drug_name` VARCHAR(50) PRIMARY KEY,
    `total_sold` INT DEFAULT 0,
    `current_modifier` FLOAT DEFAULT 1.0,
    `last_reset` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pre-populate market data
INSERT IGNORE INTO `djonstnix_drug_market` (`drug_name`, `total_sold`, `current_modifier`) VALUES
    ('heroin', 0, 1.0),
    ('meth', 0, 1.0),
    ('lsd', 0, 1.0),
    ('cokebaggy', 0, 1.0),
    ('weed_baggy', 0, 1.0),
    ('heroin_paste', 0, 1.0),
    ('methtray', 0, 1.0),
    ('lsd_sheet', 0, 1.0),
    ('coke_brick', 0, 1.0),
    ('weed_brick', 0, 1.0),
    ('pressed_pills', 0, 1.0);

-- 2. LABORATORY MAINTENANCE
CREATE TABLE IF NOT EXISTS `djonstnix_drug_labs` (
    `lab_id` VARCHAR(50) PRIMARY KEY,
    `condition` INT DEFAULT 100,
    `last_maintained` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initialize standard labs
INSERT IGNORE INTO `djonstnix_drug_labs` (`lab_id`, `condition`) VALUES
    ('weed_lab', 100),
    ('coke_lab', 100),
    ('meth_lab', 100);
