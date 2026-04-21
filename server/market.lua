-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — DYNAMIC MARKET SYSTEM
-- ==============================================================================
-- Tracks global drug sales and adjusts pricing based on supply/demand.
-- Requires: oxmysql
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()

-- ==============================================================================
-- MARKET CACHE (In-memory for performance)
-- ==============================================================================
local MarketCache = {} -- MarketCache[drugName] = { total_sold, current_modifier }

-- ==============================================================================
-- DATABASE HELPERS
-- ==============================================================================

local function LoadMarketData()
    exports.oxmysql:execute('SELECT * FROM djonstnix_drug_market', {}, function(results)
        if results then
            for _, row in pairs(results) do
                MarketCache[row.drug_name] = {
                    total_sold = row.total_sold,
                    current_modifier = row.current_modifier
                }
            end
            print("[DjonStNix-Market] Loaded " .. #results .. " market entries.")
        end
    end)
end

local function SaveMarketEntry(drugName, data)
    exports.oxmysql:execute(
        'INSERT INTO djonstnix_drug_market (drug_name, total_sold, current_modifier) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE total_sold = ?, current_modifier = ?',
        { drugName, data.total_sold, data.current_modifier, data.total_sold, data.current_modifier }
    )
end

-- ==============================================================================
-- MARKET MODIFIER CALCULATION
-- ==============================================================================

local function CalculateModifier(drugName)
    local data = MarketCache[drugName]
    if not data then return 1.0 end

    local cfg = Config.DynamicMarket
    local threshold = cfg.saturationThreshold or 50
    local floor = cfg.priceFloor or 0.6
    local ceiling = cfg.priceCeiling or 1.4
    local dropRate = cfg.dropPerSale or 0.01

    local modifier = 1.0

    if data.total_sold > threshold then
        -- Market is oversaturated — price drops
        local excessSales = data.total_sold - threshold
        modifier = 1.0 - (excessSales * dropRate)
    elseif data.total_sold < (threshold * 0.3) then
        -- Market is starving — price spikes (rare drug bonus)
        local scarcity = 1.0 - (data.total_sold / (threshold * 0.3))
        modifier = 1.0 + (scarcity * (ceiling - 1.0))
    end

    -- Clamp to floor/ceiling
    modifier = math.max(floor, math.min(ceiling, modifier))
    return modifier
end

-- ==============================================================================
-- PUBLIC API (Used by selling.lua)
-- ==============================================================================

-- Get the current price modifier for a drug
function GetMarketModifier(drugName)
    if not Config.DynamicMarket.enabled then return 1.0 end

    local data = MarketCache[drugName]
    if not data then return 1.0 end

    return CalculateModifier(drugName)
end

-- Record a sale in the market tracker
function RecordMarketSale(drugName, amount)
    if not Config.DynamicMarket.enabled then return end

    if not MarketCache[drugName] then
        MarketCache[drugName] = { total_sold = 0, current_modifier = 1.0 }
    end

    MarketCache[drugName].total_sold = MarketCache[drugName].total_sold + (amount or 1)
    MarketCache[drugName].current_modifier = CalculateModifier(drugName)

    -- Save to DB
    SaveMarketEntry(drugName, MarketCache[drugName])
end

-- Get all market data for display purposes
function GetMarketOverview()
    local overview = {}
    for drugName, data in pairs(MarketCache) do
        local modifier = CalculateModifier(drugName)
        local trend = "Stable"
        if modifier > 1.05 then trend = "📈 High Demand"
        elseif modifier < 0.95 then trend = "📉 Oversaturated" end

        overview[drugName] = {
            total_sold = data.total_sold,
            modifier = modifier,
            trend = trend
        }
    end
    return overview
end

-- ==============================================================================
-- MARKET RESET TIMER
-- ==============================================================================

local function ResetMarket()
    local cfg = Config.DynamicMarket
    local recovery = cfg.recoveryPerReset or 0.1

    for drugName, data in pairs(MarketCache) do
        -- Recover sold count toward 0
        data.total_sold = math.floor(data.total_sold * (1.0 - recovery))
        data.current_modifier = CalculateModifier(drugName)
        SaveMarketEntry(drugName, data)
    end

    print("[DjonStNix-Market] Market reset complete. Prices recovering.")
end

CreateThread(function()
    -- Load initial market data
    Wait(2000)
    LoadMarketData()

    -- Periodic reset timer
    local intervalHours = Config.DynamicMarket.resetIntervalHours or 0
    if intervalHours > 0 then
        local intervalMs = intervalHours * 60 * 60 * 1000
        while true do
            Wait(intervalMs)
            if Config.DynamicMarket.enabled then
                ResetMarket()
            end
        end
    end
end)

-- ==============================================================================
-- CLIENT CALLBACK: Get market overview for dealer menu
-- ==============================================================================
Core.Functions.CreateCallback('DjonStNix-DrugProcessing:server:getMarketData', function(source, cb)
    cb(GetMarketOverview())
end)
