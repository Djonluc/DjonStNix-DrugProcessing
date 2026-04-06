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
Config.Debug = false -- Print debug logs to console
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
    -- ==============================================================================
    -- HARVESTING (FIELDS & FARMS)
    -- ==============================================================================
    ["weed_harvest"] = {
        label = "Harvest Cannabis",
        type = "harvest",
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
        coords = vector3(2806.5, 4774.46, 46.98),
        radius = 15.0,
        rewardItems = { { item = "cokeleaf", amount = 1 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Picking Coca Leaves...",
        exposureTier = "low"
    },
    ["heroin_harvest"] = {
        label = "Harvest Poppy",
        type = "harvest",
        coords = vector3(-2339.15, -54.32, 95.05),
        radius = 15.0,
        rewardItems = { { item = "poppy", amount = 1 } },
        duration = 5000,
        anim = { dict = "amb@prop_human_bum_bin@idle_a", clip = "idle_a" },
        progressBarLabel = "Harvesting Poppies...",
        exposureTier = "low"
    },
    ["chemicals_harvest"] = {
        label = "Scavenge Chemicals",
        type = "harvest",
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
        coords = vector3(-1069.25, 4945.57, 212.18),
        radius = 10.0,
        rewardItems = { { item = "hydrochloricacid", amount = 1 } },
        duration = 6000,
        anim = { dict = "anim@heists@keycard@", clip = "exit" },
        progressBarLabel = "Siphoning Acid...",
        exposureTier = "medium"
    },
    ["sulfuric_harvest"] = {
        label = "Siphon Sulfuric Acid",
        type = "harvest",
        coords = vector3(-3026.89, 3334.91, 10.04),
        radius = 10.0,
        rewardItems = { { item = "sulfuricacid", amount = 1 } },
        duration = 6000,
        anim = { dict = "anim@heists@keycard@", clip = "exit" },
        progressBarLabel = "Siphoning Acid...",
        exposureTier = "medium"
    },
    ["sodium_harvest"] = {
        label = "Gather Sodium Hydroxide",
        type = "harvest",
        coords = vector3(-389.35, -1874.85, 20.53),
        radius = 10.0,
        rewardItems = { { item = "sodiumhydroxide", amount = 1 } },
        duration = 6000,
        anim = { dict = "anim@heists@keycard@", clip = "exit" },
        progressBarLabel = "Gathering Sodium...",
        exposureTier = "medium"
    },
    ["thionyl_harvest"] = {
        label = "Siphon Thionyl Chloride",
        type = "harvest",
        coords = vector3(-679.59, 5800.46, 17.33),
        radius = 10.0,
        rewardItems = { { item = "thionylchloride", amount = 1 } },
        duration = 6000,
        anim = { dict = "anim@heists@keycard@", clip = "exit" },
        progressBarLabel = "Siphoning Chemical...",
        exposureTier = "medium"
    },

    -- ==============================================================================
    -- PROCESSING & REFINING
    -- ==============================================================================
    ["weed"] = {
        label = "Dry Cannabis",
        type = "processing",
        coords = vector3(1038.33, -3204.44, -38.17),
        radius = 5.0,
        requiredItems = { { item = "cannabis", amount = 100 } },
        rewardItems = { { item = "marijuana", amount = 100 } },
        duration = 10000,
        anim = { dict = "anim@heists@keycard@", clip = "exit" },
        progressBarLabel = "Drying Cannabis Leaves...",
        exposureTier = "low"
    },
    ["weed_brick"] = {
        label = "Press Weed Brick",
        type = "processing",
        coords = vector3(1042.0, -3200.0, -38.17), 
        radius = 5.0,
        requiredItems = { { item = "marijuana", amount = 100 } },
        rewardItems = { { item = "weed_brick", amount = 1 } },
        duration = 15000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Pressing Weed Brick...",
        exposureTier = "low"
    },
    ["coke_process"] = {
        label = "Extract Cocaine Powder",
        type = "processing",
        coords = vector3(1087.14, -3195.31, -38.99),
        radius = 5.0,
        requiredItems = { { item = "cokeleaf", amount = 100 } },
        rewardItems = { { item = "cocaine", amount = 100 } },
        duration = 15000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Extracting Cocaine...",
        exposureTier = "medium"
    },
    ["coke_brick"] = {
        label = "Press Cocaine Brick",
        type = "processing",
        coords = vector3(1099.57, -3194.35, -38.99),
        radius = 5.0,
        requiredItems = { { item = "cocaine", amount = 100 } },
        rewardItems = { { item = "coke_brick", amount = 1 } },
        duration = 15000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Pressing Cocaine Brick...",
        exposureTier = "high"
    },
    ["meth_process"] = {
        label = "Cook Meth (Liquid Mix)",
        type = "processing",
        coords = vector3(978.17, -147.98, -48.53),
        radius = 5.0,
        requiredItems = {
            { item = "sulfuricacid", amount = 10 },
            { item = "hydrochloricacid", amount = 10 },
            { item = "sodiumhydroxide", amount = 10 }
        },
        rewardItems = { { item = "meth", amount = 100 } }, 
        duration = 10000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Cooking Meth Mix...",
        exposureTier = "high"
    },
    ["meth_tray"] = {
        label = "Pour Meth Tray",
        type = "processing",
        coords = vector3(987.81, -140.43, -49.0),
        radius = 5.0,
        requiredItems = { { item = "meth", amount = 100 } },
        rewardItems = { { item = "meth_tray", amount = 1 } },
        duration = 10000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Pouring Meth Tray...",
        exposureTier = "high"
    },
    ["heroin_process"] = {
        label = "Cook Heroin",
        type = "processing",
        coords = vector3(1413.37, -2041.74, 52.0),
        radius = 5.0,
        requiredItems = { { item = "poppy", amount = 100 } },
        rewardItems = { { item = "heroin", amount = 100 } },
        duration = 10000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Cooking Heroin...",
        exposureTier = "high"
    },
    ["lsd_process"] = {
        label = "Synthesize LSD",
        type = "processing",
        coords = vector3(2503.84, -428.11, 92.99),
        radius = 5.0,
        requiredItems = {
            { item = "thionylchloride", amount = 50 },
            { item = "chemicals", amount = 50 }
        },
        rewardItems = { { item = "lsdtab", amount = 100 } },
        duration = 10000,
        anim = { dict = "anim@amb@prop_human_atm@left@base", clip = "base" },
        progressBarLabel = "Synthesizing LSD...",
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
