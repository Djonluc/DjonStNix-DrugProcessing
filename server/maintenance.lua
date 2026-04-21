-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — LAB MAINTENANCE SYSTEM
-- ==============================================================================
-- Manages persistent laboratory conditions and maintenance state.
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()
local LabConditions = {}

-- ==============================================================================
-- SQL DATA HANDLING
-- ==============================================================================

-- Load lab conditions from DB or Initialize
local function LoadLabConditions()
    MySQL.Async.fetchAll('SELECT lab_id, `condition` FROM djonstnix_drug_labs', {}, function(results)
        if results and #results > 0 then
            for _, row in ipairs(results) do
                LabConditions[row.lab_id] = row.condition
                if Config.Debug then print("[DjonStNix-Maintenance] Loaded Lab: " .. row.lab_id .. " | Condition: " .. row.condition .. "%") end
            end
        else
            -- Fallback: Initialize if table is empty
            for labId, _ in pairs(Config.LabAccess) do
                LabConditions[labId] = 100
            end
        end
    end)
end

-- Save specific lab condition
local function SaveLabCondition(labId)
    MySQL.Async.execute('UPDATE djonstnix_drug_labs SET `condition` = ?, last_maintained = CURRENT_TIMESTAMP WHERE lab_id = ?', {
        LabConditions[labId], labId
    })
end

-- ==============================================================================
-- EXPORTS & UTILITIES
-- ==============================================================================

function GetLabCondition(labId)
    return LabConditions[labId] or 100
end

function DegradeLab(labId, amount)
    if not Config.Maintenance.enabled or not LabConditions[labId] then return end
    
    LabConditions[labId] = math.max(0, LabConditions[labId] - (amount or Config.Maintenance.degradePerCycle))
    SaveLabCondition(labId)
    
    if Config.Debug then print("[DjonStNix-Maintenance] Lab Degraded: " .. labId .. " | Current: " .. LabConditions[labId] .. "%") end
end

exports('GetLabCondition', GetLabCondition)
exports('DegradeLab', DegradeLab)

-- ==============================================================================
-- NET EVENTS & CALLBACKS
-- ==============================================================================

-- Callback to get condition for client UI/Target
Core.Functions.CreateCallback('DjonStNix-DrugProcessing:server:getLabCondition', function(source, cb, labId)
    cb(GetLabCondition(labId))
end)

-- Event to perform maintenance
RegisterNetEvent('DjonStNix-DrugProcessing:server:PerformMaintenance', function(labId)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    if not Player or not Config.Maintenance.enabled then return end

    if Core.Items.RemoveItem(src, Config.Maintenance.maintenanceItem or "maintenance_kit", 1) then
        -- Reset condition to max
        LabConditions[labId] = Config.Maintenance.maxCondition or 100
        SaveLabCondition(labId)
        
        Core.UI.Notify(src, "Lab maintenance complete. Condition restored to 100%.", "success")
        if Config.Debug then print("[DjonStNix-Maintenance] Lab Restored: " .. labId .. " by " .. GetPlayerName(src)) end
    else
        Core.UI.Notify(src, "You need a maintenance kit!", "error")
    end
end)

-- ==============================================================================
-- INITIALIZATION
-- ==============================================================================
MySQL.ready(function()
    LoadLabConditions()
end)
