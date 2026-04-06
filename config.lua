-- ==============================================================================
-- 👑 DJONSTNIX BRANDING
-- ==============================================================================
-- DEVELOPED BY: DjonStNix (DjonLuc)
-- GITHUB: https://github.com/Djonluc
-- DISCORD: https://discord.gg/s7GPUHWrS7
-- YOUTUBE: https://www.youtube.com/@Djonluc
-- EMAIL: djonstnix@gmail.com
-- LICENSE: MIT License (c) 2026 DjonStNix (DjonLuc)
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
        radius = 15.0,
        rewardItems = { { item = "cannabis", amount = 1 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Picking Cannabis...",
        exposureTier = "low"
    },
    ["coke_harvest"] = {
        label = "Harvest Coca Leaves",
        type = "harvest",
        model = "h4_prop_bush_cocaplant_01",
        coords = vector3(2806.5, 4774.46, 46.98),
        radius = 15.0,
        rewardItems = { { item = "coca_leaf", amount = 1 } },
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
        radius = 15.0,
        rewardItems = { { item = "poppyresin", amount = 1 } },
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
        radius = 15.0,
        rewardItems = { { item = "chemicals", amount = 1 } },
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
        radius = 10.0,
        rewardItems = { { item = "hydrochloric_acid", amount = 1 } },
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
        radius = 10.0,
        rewardItems = { { item = "sulfuric_acid", amount = 1 } },
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
        radius = 10.0,
        rewardItems = { { item = "sodium_hydroxide", amount = 1 } },
        duration = 6000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Gathering Sodium...",
        exposureTier = "medium"
    },
    ["thionyl_harvest"] = {
        label = "Siphon Thionyl Chloride",
        type = "harvest",
        model = "prop_barrel_exp_01a",
        coords = vector3(-679.59, 5800.46, 17.33),
        radius = 10.0,
        rewardItems = { { item = "thionyl_chloride", amount = 1 } },
        duration = 6000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Siphoning Chemical...",
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
        radius = 5.0,
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
        radius = 5.0,
        requiredItems = { { item = "marijuana", amount = 100 } },
        rewardItems = { { item = "weed_brick", amount = 1 } },
        duration = 20000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressing Weed Brick...",
        exposureTier = "low"
    },

    -- COKE CHAIN: coca_leaf (100) → coke (50) → coke (50) → coke_small_brick (1) → coke_small_brick (2) → coke_brick (1)
    ["coke_process"] = {
        label = "Extract Cocaine Powder",
        type = "processing",
        coords = vector3(1087.14, -3195.31, -38.99),
        radius = 5.0,
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
        radius = 5.0,
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
        radius = 5.0,
        requiredItems = { { item = "coke_small_brick", amount = 2 } },
        rewardItems = { { item = "coke_brick", amount = 1 } },
        duration = 15000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Pressing Big Cocaine Brick...",
        exposureTier = "high"
    },

    -- METH CHAIN (High Volume Batch Cook)
    ["meth_process"] = {
        label = "Mix Chemical Batch",
        type = "processing",
        coords = vector3(978.17, -147.98, -48.53),
        radius = 5.0,
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
        coords = vector3(982.56, -145.59, -48.8),
        radius = 5.0,
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
        radius = 5.0,
        requiredItems = { { item = "chemicalvapor", amount = 1 } },
        rewardItems = { { item = "methtray", amount = 1 } },
        duration = 30000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Cooling Blue Crystal...",
        exposureTier = "high"
    },
    ["meth_bag"] = {
        label = "Package Meth",
        type = "processing",
        coords = vector3(987.81, -140.43, -49.0),
        radius = 5.0,
        requiredItems = { { item = "methtray", amount = 1 } }, -- Wait, no, req should be methtray? No, Stage 4 takes methtray and bags it? Wait.
        -- Original request for packing was "turn it into a brick/tray".
        -- Let's trace meth again.
        -- Stage 3 (meth_temp_down) rewards methtray.
        -- So Stage 4 (meth_bag) should take METHTRAY and reward METH (90 baggies)?
        -- BUT the user wants consistency with COKE where Stage 3 (Brick) -> Inventory Breakdown -> Baggies.
        -- So for Meth, Stage 4 (meth_bagging) should BE THE PACKING that gives the BULK item?
        -- Actually, meth_temp_down gives the tray. So why a 4th stage? 
        -- In original ps-drugprocessing, bagging WAS the breakdown station. 
        -- I'll make meth_bag (Stage 4) reward the methtray IF it doesn't already exist.
        -- Actually, I'll just change Stage 4 to "Seal Meth Tray" and keep the rewards as 1x methtray if they want it.
        -- Let me check the user's specific audio: "How does someone break down a brick into 90-100 bags... how do they do that?".
        -- So for Meth, I'll make it so Stage 3 gives the tray, and they use it in inventory.
        -- Stage 4 (Bagging station) will be renamed "Finalize Packaging" or something.
        -- OR I'll make it so Stage 3 gives "Meth Liquid" and Stage 4 gives the tray.
        -- Let's just follow the Coke pattern.
        -- Meth Chain:
        -- Stage 1: Mix -> LiquidMix
        -- Stage 2: Temp Up -> ChemicalVapor
        -- Stage 3: Temp Down -> Methtray (Bulk)
        -- Stage 4 (Bagging station): NOT NEEDED if they allow inventory breakdown!
        -- However, I'll keep Stage 4 as an alternative "Station-based Bagging" if they want, but the player is asking for inventory breakdown.
        -- I'll make Stage 4 reward the 1x methtray (as a final check/seal) so they have to go through ALL 4 stages.
        rewardItems = { { item = "methtray", amount = 1 } },
        duration = 10000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Finalizing Meth Packaging...",
        exposureTier = "high"
    },

    -- HEROIN CHAIN: poppyresin (25) → paste → heroin (retail)
    ["heroin_cook"] = {
        label = "Cook Heroin Paste",
        type = "processing",
        coords = vector3(1413.37, -2041.74, 52.0),
        radius = 5.0,
        requiredItems = { { item = "poppyresin", amount = 25 } },
        rewardItems = { { item = "heroin_paste", amount = 1 } },
        duration = 45000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Cooking Heroin Paste...",
        exposureTier = "high"
    },
    ["heroin_process"] = {
        label = "Prepare Heroin Doses",
        type = "processing",
        coords = vector3(1384.9, -2080.61, 52.21),
        radius = 5.0,
        requiredItems = { 
            { item = "heroin_paste", amount = 1 },
            { item = "syringe", amount = 5 }
        },
        rewardItems = { { item = "heroin", amount = 10 } },
        duration = 20000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Preparing Injectable Doses...",
        exposureTier = "high"
    },

    -- CHEMICAL CONVERSION (High Volume)
    ["chem_hydrochloric"] = {
        label = "Process Hydrochloric Acid",
        type = "processing",
        coords = vector3(3535.66, 3661.69, 28.32),
        radius = 5.0,
        requiredItems = { { item = "chemicals", amount = 1 } },
        rewardItems = { { item = "hydrochloric_acid", amount = 10 } },
        duration = 10000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Synthesizing Acid...",
        exposureTier = "medium"
    },
    ["chem_sodium"] = {
        label = "Process Sodium Hydroxide",
        type = "processing",
        coords = vector3(3535.66, 3661.69, 28.32),
        radius = 5.0,
        requiredItems = { { item = "chemicals", amount = 1 } },
        rewardItems = { { item = "sodium_hydroxide", amount = 10 } },
        duration = 10000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Synthesizing Sodium...",
        exposureTier = "medium"
    },
    ["chem_sulfuric"] = {
        label = "Process Sulfuric Acid",
        type = "processing",
        coords = vector3(3535.66, 3661.69, 28.32),
        radius = 5.0,
        requiredItems = { { item = "chemicals", amount = 1 } },
        rewardItems = { { item = "sulfuric_acid", amount = 10 } },
        duration = 10000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Synthesizing Acid...",
        exposureTier = "medium"
    },
    ["chem_lsa"] = {
        label = "Process LSA",
        type = "processing",
        coords = vector3(3535.66, 3661.69, 28.32),
        radius = 5.0,
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
        radius = 5.0,
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
        radius = 5.0,
        requiredItems = {
            { item = "lsa", amount = 10 },
            { item = "thionyl_chloride", amount = 1 }
        },
        rewardItems = { { item = "lsd", amount = 25 } },
        duration = 30000,
        anim = { scenario = "PROP_HUMAN_PARKING_METER" },
        progressBarLabel = "Cooking Tabs...",
        exposureTier = "high"
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
        exit = vector4(1066.01, -3183.38, -39.16, 93.01)
    },
    ["coke_lab"] = {
        label = "Cocaine Laboratory",
        key = "cokekey",
        enter = vector4(813.21, -2398.69, 23.66, 171.51),
        exit = vector4(1088.68, -3187.68, -38.99, 176.04)
    },
    ["meth_lab"] = {
        label = "Meth Laboratory",
        key = "methkey",
        enter = vector4(-1187.17, -446.24, 43.91, 306.59),
        exit = vector4(969.57, -147.07, -46.4, 267.52)
    }
}
