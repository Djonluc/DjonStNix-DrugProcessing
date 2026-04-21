-- ==============================================================================
-- 👑 DJONSTNIX 
-- ==============================================================================
-- DEVELOPED BY: DjonStNix (DjonLuc)
-- GITHUB: https://github.com/Djonluc
-- DISCORD: https://discord.gg/s7GPUHWrS7
-- YOUTUBE: https://www.youtube.com/@Djonluc
-- EMAIL: djonstnix@gmail.com
-- ==============================================================================

Config = {}

-- ==============================================================================
-- GENERAL SYSTEM SETTINGS
-- ==============================================================================
Config.Locale = "en" -- Language for notifications
Config.Debug = true -- Print debug logs to console (SET TO false FOR PRODUCTION)
Config.KeyRequired = true -- Requires laboratory keys for access
Config.KeyItem = "weedkey" -- Default key item for lab access
Config.NotifyRadius = 5.0 -- Distance to show target/interaction prompts

-- ==============================================================================
-- TOXICITY EXPOSURE SETTINGS (Requires DjonStNix-Overdose)
-- ==============================================================================
Config.ToxicityExposure = {
    enabled = true,            -- Adds toxicity to player during/after drug processing
    exposurePerCycle = 10,      -- Toxicity points added per successful process
    requireProtection = true,  -- If true, wearing a mask reduces/prevents exposure
    protectionItems = {        -- Items that count as protection
        "gas_mask",
        "industrial_mask"
    },
    protectionReduction = 0.8  -- 0.8 = 80% reduction in toxicity gained if protected
}

-- ==============================================================================
-- SKILL CHECK SETTINGS (Interactive Refining)
-- ==============================================================================
Config.SkillCheck = {
    enabled = true,                -- Toggle skill checks on/off globally
    spoilMultiplier = 0.5,         -- Failed checks reduce purity by this factor (0.5 = 50% of rolled purity)
    -- Fallback difficulty if a station doesn't define its own skillCheck table
    defaultDifficulty = { 'easy', 'easy' },
    -- Number of key presses required for each tier
    defaultInputs = { 'w', 'a', 's', 'd' }
}

-- ==============================================================================
-- DEALER REPUTATION SYSTEM
-- ==============================================================================
Config.Reputation = {
    enabled = true,                -- Toggle reputation system on/off
    pointsPerSale = 1,             -- Rep points gained per successful sale
    lowPurityThreshold = 40,       -- Purity below this = "trash" (triggers penalty)
    lowPurityPenalty = -2,         -- Rep points lost when selling trash quality
    
    -- Level thresholds: { requiredPoints, payoutBonusPercent, perks }
    levels = {
        { points = 0,   bonus = 0,   label = "Unknown" },         -- Level 1
        { points = 10,  bonus = 2,   label = "Associate" },        -- Level 2
        { points = 25,  bonus = 5,   label = "Trusted" },          -- Level 3
        { points = 50,  bonus = 8,   label = "Connected" },        -- Level 4
        { points = 100, bonus = 12,  label = "Made Man" },         -- Level 5
        { points = 200, bonus = 15,  label = "Lieutenant" },       -- Level 6
        { points = 350, bonus = 18,  label = "Underboss" },        -- Level 7
        { points = 500, bonus = 20,  label = "Boss", perks = { "protection" } } -- Level 8 (MAX)
    }
}

-- ==============================================================================
-- DYNAMIC MARKET (Supply & Demand)
-- ==============================================================================
Config.DynamicMarket = {
    enabled = true,                -- Toggle dynamic market on/off
    resetIntervalHours = 6,        -- Hours between market resets (0 = only on restart)
    saturationThreshold = 50,      -- Total sales before market starts dropping
    priceFloor = 0.6,              -- Minimum price modifier (60% of base)
    priceCeiling = 1.4,            -- Maximum price modifier (140% of base — demand spike)
    dropPerSale = 0.01,            -- Price drops by 1% per sale above threshold
    recoveryPerReset = 0.1         -- Price recovers 10% toward 1.0 per reset cycle
}

-- ==============================================================================
-- UNDERCOVER RISK (Phase 5)
-- ==============================================================================
Config.UndercoverRisk = {
    enabled = true,                -- Toggle undercover system on/off
    chance = 2,                    -- % chance per sale that dealer is undercover (2% default)
    wantedLevel = 3,               -- Stars applied to player on bust
    bustMessage = "BUSTED! The dealer was an undercover cop!",
    cooldown = 300                 -- Seconds before undercover can trigger again for same player
}

-- ==============================================================================
-- LAB MAINTENANCE (Phase 4)
-- ==============================================================================
Config.Maintenance = {
    enabled = true,                -- Toggle maintenance system on/off
    maxCondition = 100,            -- Maximum lab condition
    degradePerCycle = 5,           -- Points lost per successful batch
    failureThreshold = 30,         -- Condition below this = "Dirty Lab" (penalties apply)
    purityPenalty = 0.8,           -- Purity multiplier if condition is below threshold (0.8 = 20% loss)
    fumeExposureMultiplier = 1.5,  -- Toxicity multiplier if condition is below threshold (1.5 = 50% increase)
    explosionChance = 5,           -- % chance of batch failure/fire if condition is < 10%
    maintenanceItem = "lab_maintenance_kit" -- Item required to fix the lab
}

-- ==============================================================================
-- PHARMACEUTICAL REFINEMENT (Phase 6)
-- ==============================================================================
Config.Pharmaceuticals = {
    ["pressed_pills"] = {
        health = 10,               -- HP restored (out of 100)
        stress = 10,               -- Stress reduction (out of 100)
        toxicity = 5,              -- Minimal toxicity (vs 25-50 for street drugs)
        useTime = 3000,            -- Time in msec to consume
        animation = {
            dict = "mp_suicide",
            clip = "pill",
            flag = 48
        }
    }
}

-- ==============================================================================
-- DRUG PROCESSING CORE
-- ==============================================================================
-- This table handles ALL drugs. The system dynamically reads this.
-- ==============================================================================
Config.Drugs = {
    -- ==============================================================================
    -- HARVESTING (FIELDS & FARMS)
    -- ==============================================================================
    ["weed_harvest"] = {
        label = "Harvest Cannabis",
        type = "harvest",
        model = "prop_weed_01",
        coords = vector3(2224.64, 5577.03, 53.85),
        radius = 8.0,
        rewardItems = { { item = "cannabis", minAmount = 1, maxAmount = 3 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Picking Cannabis...",
        exposureTier = "low"
    },
    ["coke_harvest"] = {
        label = "Harvest Coca Leaves",
        type = "harvest",
        model = "h4_prop_bush_cocaplant_01",
        coords = vector3(5317.79, -5221.78, 32.21),
        radius = 8.0,
        rewardItems = { { item = "coca_leaf", minAmount = 1, maxAmount = 3 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Picking Coca Leaves...",
        exposureTier = "low"
    },
    ["heroin_harvest"] = {
        label = "Harvest Poppy",
        type = "harvest",
        model = "prop_plant_01b",
        coords = vector3(-2339.15, -54.32, 95.05),
        radius = 8.0,
        rewardItems = { { item = "poppyresin", minAmount = 1, maxAmount = 3 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Harvesting Poppies...",
        exposureTier = "low"
    },
    ["chemicals_harvest"] = {
        label = "Scavenge Chemicals",
        type = "harvest",
        model = "prop_barrel_exp_01a",
        coords = vector3(1264.97, 1803.96, 82.94),
        radius = 8.0,
        rewardItems = { { item = "chemicals", minAmount = 1, maxAmount = 3 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Gathering Chemicals...",
        exposureTier = "medium"
    },
    ["hydrochloric_harvest"] = {
        label = "Siphon Hydrochloric Acid",
        type = "harvest",
        model = "prop_barrel_exp_01b",
        coords = vector3(-1069.25, 4945.57, 212.18),
        radius = 5.0,
        rewardItems = { { item = "hydrochloric_acid", minAmount = 1, maxAmount = 2 } },
        duration = 6000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Siphoning Acid...",
        exposureTier = "medium"
    },
    ["sulfuric_harvest"] = {
        label = "Siphon Sulfuric Acid",
        type = "harvest",
        model = "prop_barrel_02b",
        coords = vector3(-3026.89, 3334.91, 10.04),
        radius = 5.0,
        rewardItems = { { item = "sulfuric_acid", minAmount = 1, maxAmount = 2 } },
        duration = 6000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Siphoning Acid...",
        exposureTier = "medium"
    },
    ["sodium_harvest"] = {
        label = "Gather Sodium Hydroxide",
        type = "harvest",
        model = "prop_barrel_01a",
        coords = vector3(-389.35, -1874.85, 20.53),
        radius = 5.0,
        rewardItems = { { item = "sodium_hydroxide", minAmount = 1, maxAmount = 2 } },
        duration = 6000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Gathering Sodium...",
        exposureTier = "medium"
    },

    -- ==============================================================================
    -- PROCESSING & REFINING
    -- ==============================================================================

    -- WEED CHAIN: cannabis → marijuana → weed_brick
    ["weed"] = {
        label = "Dry Cannabis",
        type = "processing",
        coords = vector3(1038.33, -3204.44, -38.17),
        radius = 2.0,
        requiredItems = { { item = "cannabis", amount = 25 } },
        rewardItems = { { item = "marijuana", amount = 10 } },
        duration = 30000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Drying Cannabis Batches...",
        exposureTier = "low"
    },
    ["weed_brick"] = {
        label = "Press Weed Brick",
        type = "processing",
        coords = vector3(1042.0, -3200.0, -38.17), 
        radius = 2.0,
        requiredItems = { { item = "marijuana", amount = 100 } },
        rewardItems = { { item = "weed_brick", amount = 1 } },
        purityRange = { min = 50, max = 100 }, -- UPDATED: All drugs can be 100%
        skillCheck = { difficulty = { 'easy' }, inputs = { 'w', 'a', 's', 'd' } }, -- WEED: Easy
        duration = 20000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressing Weed Brick...",
        exposureTier = "low",
        labId = "weed_lab"
    },

    -- COKE CHAIN: coca_leaf (100) → coke (50) → coke (50) → coke_small_brick (1) → coke_small_brick (2) → coke_brick (1)
    ["coke_process"] = {
        label = "Extract Cocaine Powder",
        type = "processing",
        coords = vector3(1087.14, -3195.31, -38.99),
        radius = 2.0,
        requiredItems = { { item = "coca_leaf", amount = 100 } },
        rewardItems = { { item = "coke", amount = 50 } },
        duration = 40000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Extracting Cocaine...",
        exposureTier = "medium"
    },
    ["coke_powder_cut"] = {
        label = "Press Small Coke Brick",
        type = "processing",
        coords = vector3(1092.89, -3195.78, -38.99),
        radius = 2.0,
        requiredItems = { { item = "coke", amount = 50 } },
        rewardItems = { { item = "coke_small_brick", amount = 1 } },
        duration = 20000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressing Small Coke Brick...",
        exposureTier = "high"
    },
    ["coke_brick"] = {
        label = "Press Big Cocaine Brick",
        type = "processing",
        coords = vector3(1099.57, -3194.35, -38.99),
        radius = 2.0,
        requiredItems = { { item = "coke_small_brick", amount = 2 } },
        rewardItems = { { item = "coke_brick", amount = 1 } },
        purityRange = { min = 70, max = 100 }, -- NEW: Purity hierarchy
        skillCheck = { difficulty = { 'easy', 'medium' }, inputs = { 'w', 'a', 's', 'd' } }, -- COKE: Medium
        duration = 15000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressing Big Cocaine Brick...",
        exposureTier = "high",
        labId = "coke_lab"
    },

    -- METH CHAIN (High Volume Batch Cook)
    ["meth_process"] = {
        label = "Mix Chemical Batch",
        type = "processing",
        coords = vector3(978.17, -147.98, -48.53),
        radius = 2.0,
        requiredItems = {
            { item = "sulfuric_acid", amount = 25 },
            { item = "hydrochloric_acid", amount = 25 },
            { item = "sodium_hydroxide", amount = 25 }
        },
        rewardItems = { { item = "liquidmix", amount = 1 } },
        duration = 60000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Reacting Chemicals...",
        exposureTier = "high"
    },
    ["meth_temp_up"] = {
        label = "Raise Temperature",
        type = "processing",
        coords = vector3(979.59, -144.14, -48.55),
        radius = 2.0,
        requiredItems = { { item = "liquidmix", amount = 1 } },
        rewardItems = { { item = "chemicalvapor", amount = 1 } },
        duration = 30000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressurizing Vapors...",
        exposureTier = "high"
    },
    ["meth_temp_down"] = {
        label = "Lower Temperature",
        type = "processing",
        coords = vector3(979.59, -144.14, -48.55),
        radius = 2.0,
        requiredItems = { { item = "chemicalvapor", amount = 1 } },
        rewardItems = { { item = "methtray", amount = 1 } },
        purityRange = { min = 80, max = 100 }, -- UPDATED: All drugs can be 100%
        skillCheck = { difficulty = { 'medium', 'hard' }, inputs = { 'w', 'a', 's', 'd' } }, -- METH: Hard
        duration = 30000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Cooling Blue Crystal...",
        exposureTier = "high",
        labId = "meth_lab"
    },

    -- HEROIN CHAIN: poppyresin (25) → paste → heroin (retail)
    ["heroin_cook"] = {
        label = "Cook Heroin Paste",
        type = "processing",
        coords = vector3(1413.37, -2041.74, 52.0),
        radius = 2.0, -- Proposed: 2.0
        requiredItems = { { item = "poppyresin", amount = 25 } },
        rewardItems = { { item = "heroin_paste", amount = 1 } },
        purityRange = { min = 90, max = 100 }, -- NEW: Purity hierarchy
        skillCheck = { difficulty = { 'hard', 'hard' }, inputs = { 'w', 'a', 's', 'd' } }, -- HEROIN: Very Hard
        duration = 45000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Cooking Heroin Paste...",
        exposureTier = "high"
    },
    ["heroin_process"] = {
        label = "Prepare Heroin Doses",
        type = "processing",
        coords = vector3(1384.9, -2080.61, 52.21),
        radius = 2.0, -- Proposed: 2.0
        requiredItems = { 
            { item = "heroin_paste", amount = 1 },
            { item = "syringe", amount = 5 }
        },
        rewardItems = { { item = "heroin", amount = 30 } }, -- UPDATED: Standardized yield for premium payout
        duration = 20000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Preparing Injectable Doses...",
        exposureTier = "high"
    },

    -- CHEMICAL CONVERSION (High Volume)
    ["chem_lsa"] = {
        label = "Process LSA",
        type = "processing",
        coords = vector3(3535.66, 3661.69, 28.32),
        radius = 2.0,
        requiredItems = { { item = "chemicals", amount = 1 } },
        rewardItems = { { item = "lsa", amount = 10 } },
        duration = 10000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Synthesizing LSA...",
        exposureTier = "medium"
    },

    -- LSD CHAIN
    ["thionyl_process"] = {
        label = "Synthesize Thionyl Chloride",
        type = "processing",
        coords = vector3(-679.59, 5800.46, 17.33),
        radius = 2.0,
        requiredItems = {
            { item = "lsa", amount = 10 },
            { item = "chemicals", amount = 5 }
        },
        rewardItems = { { item = "thionyl_chloride", amount = 1 } },
        duration = 20000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Oxidizing Chemicals...",
        exposureTier = "high"
    },
    ["lsd_process"] = {
        label = "Synthesize LSD",
        type = "processing",
        coords = vector3(2503.84, -428.11, 92.99),
        radius = 2.0,
        requiredItems = {
            { item = "lsa", amount = 10 },
            { item = "thionyl_chloride", amount = 1 }
        },
        rewardItems = { { item = "lsd_sheet", amount = 1 } }, -- NEW: Wholesale item
        purityRange = { min = 60, max = 100 }, -- UPDATED: All drugs can be 100%
        skillCheck = { difficulty = { 'medium', 'medium' }, inputs = { 'w', 'a', 's', 'd' } }, -- LSD: Medium
        duration = 30000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Cooking Tabs...",
        exposureTier = "high"
    },

    -- PHARMACEUTICAL CHAIN
    ["pill_press"] = {
        label = "Press Medical Pills",
        type = "processing",
        coords = vector3(985.0, -142.0, -49.0), -- Placed in Meth Lab area for now
        radius = 2.0,
        requiredItems = {
            { item = "lsa", amount = 5 },
            { item = "industrial_powder", amount = 10 }
        },
        rewardItems = { { item = "pressed_pills", amount = 10 } },
        purityRange = { min = 80, max = 100 },
        skillCheck = { difficulty = { 'easy', 'medium' }, inputs = { 'w', 'a', 's', 'd' } },
        duration = 15000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressing Meds...",
        exposureTier = "low"
    },
}

-- ==============================================================================
-- DRUG SELLING & GLOBAL SETTINGS
-- ==============================================================================
Config.Selling = {
    account = "black_money",    -- Account to receive money (black_money, markedbills, etc.)
    policeAlertChance = 15,     -- % chance for police to be alerted on a sale (GLOBAL FALLBACK)
    requirePolice = 2,          -- Minimum police required to sell (0 = disabled)
    
    -- Specific risk levels per rank (Overrides global chance)
    -- High value = High risk.
    riskLevels = {
        ["heroin"] = 35,        -- SOVEREIGN: Extreme Risk
        ["meth"] = 25,          -- PRINCE: High Risk
        ["lsd"] = 15,           -- BARON: Medium Risk
        ["cokebaggy"] = 15,     -- KNIGHT: Medium Risk
        ["weed_baggy"] = 5,     -- COMMON: Low Risk
        ["pressed_pills"] = 2   -- CLINIC: Lowest Risk
    }
}

Config.Dealers = {
    ["west_side"] = {
        coords = vector4(-1171.9, -1571.4, 3.4, 120.0),
        radius = 200.0, -- SOVEREIGN ZONE: 200m radius
        model = "a_m_m_salton_01",
        label = "Street Hustler",
        buyItems = {
            -- Retail options
            ["heroin"] = { basePrice = 1500 }, -- THE KING: Heroin
            ["meth"] = { basePrice = 400 }, -- THE PRINCE: Meth
            ["lsd"] = { basePrice = 750 }, -- THE BARON: LSD
            ["cokebaggy"] = { basePrice = 250 }, -- THE KNIGHT: Cocaine
            ["weed_baggy"] = { basePrice = 120 }, -- THE COMMON: Weed
            ["pressed_pills"] = { basePrice = 200 }, -- THE CLINIC: Pills
            -- Wholesale options
            ["heroin_paste"] = { basePrice = 25000 }, -- ~55% of retail ($45k)
            ["methtray"] = { basePrice = 20000 }, -- ~50% of retail ($40k)
            ["lsd_sheet"] = { basePrice = 15000 }, -- ~50% of retail ($30k)
            ["coke_brick"] = { basePrice = 12000 }, -- ~48% of retail ($25k)
            ["weed_brick"] = { basePrice = 6000 } -- ~50% of retail ($12k)
        }
    },
    ["marabunta"] = {
        coords = vector4(1443.0, -1486.0, 65.6, 180.0),
        radius = 100.0, -- ZONE: 100m radius
        model = "g_m_y_salvagoon_01",
        label = "Marabunta Contact",
        buyItems = {
            ["heroin"] = { basePrice = 1650 }, -- Premium buy
            ["heroin_paste"] = { basePrice = 28000 },
            ["meth"] = { basePrice = 450 },
            ["methtray"] = { basePrice = 22000 }
        }
    }
}


-- ==============================================================================
-- LABORATORY ACCESS
-- ==============================================================================
Config.LabAccess = {
    ["weed_lab"] = {
        label = "Weed Laboratory",
        key = "weedkey",
        enter = vector4(102.07, 175.09, 104.59, 165.63),
        exit = vector4(1066.01, -3183.38, -39.16, 93.01),
        maintenanceCoords = vector3(1048.24, -3203.49, -38.17)
    },
    ["coke_lab"] = {
        label = "Cocaine Laboratory",
        key = "cokekey",
        enter = vector4(5124.24, -5141.05, 2.19, 0.00),
        exit = vector4(1088.68, -3187.68, -38.99, 176.04),
        maintenanceCoords = vector3(1101.42, -3198.81, -38.99)
    },
    ["meth_lab"] = {
        label = "Meth Laboratory",
        key = "methkey",
        enter = vector4(-1187.17, -446.24, 43.91, 306.59),
        exit = vector4(969.57, -147.07, -46.4, 267.52),
        maintenanceCoords = vector3(984.7, -137.9, -49.0)
    }
}
