-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — REPUTATION SYSTEM
-- ==============================================================================
-- Persistent dealer reputation tracking with level-based payout bonuses.
-- Requires: oxmysql
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()

-- ==============================================================================
-- REPUTATION CACHE (In-memory for performance)
-- ==============================================================================
local RepCache = {} -- RepCache[citizenid][dealerId] = { points, level }

-- ==============================================================================
-- DATABASE HELPERS
-- ==============================================================================

local function GetCitizenId(src)
    return Core.Player.GetIdentifier(src)
end

local function LoadReputation(citizenid, dealerId, cb)
    exports.oxmysql:execute(
        'SELECT points, level, total_sales FROM djonstnix_drug_rep WHERE citizenid = ? AND dealer_id = ?',
        { citizenid, dealerId },
        function(result)
            if result and result[1] then
                cb(result[1])
            else
                -- First time interaction: insert default row
                exports.oxmysql:execute(
                    'INSERT INTO djonstnix_drug_rep (citizenid, dealer_id, points, level, total_sales) VALUES (?, ?, 0, 1, 0)',
                    { citizenid, dealerId }
                )
                cb({ points = 0, level = 1, total_sales = 0 })
            end
        end
    )
end

local function SaveReputation(citizenid, dealerId, points, level, totalSales)
    exports.oxmysql:execute(
        'UPDATE djonstnix_drug_rep SET points = ?, level = ?, total_sales = ? WHERE citizenid = ? AND dealer_id = ?',
        { points, level, totalSales, citizenid, dealerId }
    )
end

-- ==============================================================================
-- LEVEL CALCULATION
-- ==============================================================================

local function CalculateLevel(points)
    local levels = Config.Reputation.levels
    local currentLevel = 1
    for i, lvl in ipairs(levels) do
        if points >= lvl.points then
            currentLevel = i
        else
            break
        end
    end
    return currentLevel
end

local function GetLevelData(level)
    return Config.Reputation.levels[level] or Config.Reputation.levels[1]
end

-- ==============================================================================
-- PUBLIC API (Used by selling.lua)
-- ==============================================================================

-- Get a player's reputation data for a specific dealer
function GetDealerReputation(src, dealerId, cb)
    if not Config.Reputation.enabled then
        return cb({ points = 0, level = 1, total_sales = 0, bonus = 0, label = "Unknown", perks = {} })
    end

    local citizenid = GetCitizenId(src)
    if not citizenid then return cb(nil) end

    -- Check cache first
    if RepCache[citizenid] and RepCache[citizenid][dealerId] then
        local cached = RepCache[citizenid][dealerId]
        local levelData = GetLevelData(cached.level)
        cb({
            points = cached.points,
            level = cached.level,
            total_sales = cached.total_sales,
            bonus = levelData.bonus or 0,
            label = levelData.label or "Unknown",
            perks = levelData.perks or {}
        })
        return
    end

    -- Load from DB
    LoadReputation(citizenid, dealerId, function(data)
        -- Cache it
        if not RepCache[citizenid] then RepCache[citizenid] = {} end
        RepCache[citizenid][dealerId] = data

        local levelData = GetLevelData(data.level)
        cb({
            points = data.points,
            level = data.level,
            total_sales = data.total_sales,
            bonus = levelData.bonus or 0,
            label = levelData.label or "Unknown",
            perks = levelData.perks or {}
        })
    end)
end

-- Award reputation points after a successful sale
function AwardReputation(src, dealerId, purity)
    if not Config.Reputation.enabled then return end

    local citizenid = GetCitizenId(src)
    if not citizenid then return end

    local function processRep(data)
        local pointsChange = Config.Reputation.pointsPerSale

        -- Penalty for selling trash quality
        if purity < (Config.Reputation.lowPurityThreshold or 40) then
            pointsChange = Config.Reputation.lowPurityPenalty or -2
            Core.UI.Notify(src, "The dealer is unimpressed with the quality... Rep lost.", "error")
        end

        local newPoints = math.max(0, data.points + pointsChange)
        local newLevel = CalculateLevel(newPoints)
        local newTotalSales = data.total_sales + 1

        -- Level up notification
        if newLevel > data.level then
            local levelData = GetLevelData(newLevel)
            Core.UI.Notify(src, 
                string.format("🔥 Rep Level Up! You are now: %s (+%d%% payout bonus)", levelData.label, levelData.bonus), 
                "success"
            )
            print(string.format("[DjonStNix-Rep] %s leveled up to %s (Level %d) with dealer %s", citizenid, levelData.label, newLevel, dealerId))
        end

        -- Update cache
        if not RepCache[citizenid] then RepCache[citizenid] = {} end
        RepCache[citizenid][dealerId] = { points = newPoints, level = newLevel, total_sales = newTotalSales }

        -- Save to DB
        SaveReputation(citizenid, dealerId, newPoints, newLevel, newTotalSales)
    end

    -- Use cache if available, otherwise load
    if RepCache[citizenid] and RepCache[citizenid][dealerId] then
        processRep(RepCache[citizenid][dealerId])
    else
        LoadReputation(citizenid, dealerId, processRep)
    end
end

-- ==============================================================================
-- CLIENT CALLBACK: Get rep data for dealer menu display
-- ==============================================================================
Core.Functions.CreateCallback('DjonStNix-DrugProcessing:server:getDealerRep', function(source, cb, dealerId)
    GetDealerReputation(source, dealerId, function(repData)
        cb(repData)
    end)
end)

-- ==============================================================================
-- CLEANUP ON DISCONNECT
-- ==============================================================================
AddEventHandler('playerDropped', function()
    local src = source
    local citizenid = GetCitizenId(src)
    if citizenid and RepCache[citizenid] then
        RepCache[citizenid] = nil
    end
end)
