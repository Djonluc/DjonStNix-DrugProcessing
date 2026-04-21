-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — DYNAMIC MARKET
-- ==============================================================================
-- Run this SQL to create the dynamic market tracking table.
-- Compatible with oxmysql / mysql-async / ghmattimysql
-- ==============================================================================

CREATE TABLE IF NOT EXISTS `djonstnix_drug_market` (
    `drug_name` VARCHAR(50) PRIMARY KEY,
    `total_sold` INT DEFAULT 0,
    `current_modifier` FLOAT DEFAULT 1.0,
    `last_reset` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pre-populate with all sellable drugs
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
