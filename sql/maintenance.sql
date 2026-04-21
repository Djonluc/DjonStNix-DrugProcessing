-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — LAB MAINTENANCE
-- ==============================================================================
-- Run this SQL to create the table for persistent laboratory conditions.
-- ==============================================================================

CREATE TABLE IF NOT EXISTS `djonstnix_drug_labs` (
    `lab_id` VARCHAR(50) PRIMARY KEY,
    `condition` INT DEFAULT 100,
    `last_maintained` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initialize the standard labs
INSERT IGNORE INTO `djonstnix_drug_labs` (`lab_id`, `condition`) VALUES
    ('weed_lab', 100),
    ('coke_lab', 100),
    ('meth_lab', 100);
