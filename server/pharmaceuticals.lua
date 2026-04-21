-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — PHARMACEUTICAL REFINEMENT
-- ==============================================================================
-- Manages the consumption and effects of refined pharmaceutical products.
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()

-- ==============================================================================
-- CONSUMPTION LOGIC: PRESSED PILLS
-- ==============================================================================

CreateThread(function()
    for pillName, _ in pairs(Config.Pharmaceuticals) do
        Core.Items.RegisterUsableItem(pillName, function(source, item)
            TriggerClientEvent('DjonStNix-DrugProcessing:client:UseMedication', source, pillName)
        end)
    end
end)

-- Event from client after progress bar completes
RegisterNetEvent('DjonStNix-DrugProcessing:server:ApplyMedicationEffects', function(pillName)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    local pillConfig = Config.Pharmaceuticals[pillName]
    
    if not Player or not pillConfig then return end

    -- 1. Consume Item
    if Core.Items.RemoveItem(src, pillName, 1) then
        -- 2. Restore Health
        local currentHealth = GetEntityHealth(GetPlayerPed(src))
        local newHealth = math.min(200, currentHealth + pillConfig.health)
        SetEntityHealth(GetPlayerPed(src), newHealth)

        -- 3. Reduce Stress (Bridged)
        local currentStress = Core.Player.GetMetaData(src, "stress") or 0
        Core.Player.SetMetaData(src, "stress", math.max(0, currentStress - pillConfig.stress))

        -- 4. Toxicity Integration (DjonStNix-Overdose)
        if GetResourceState('DjonStNix-Overdose') == 'started' then
            TriggerClientEvent('DjonStNix-Overdose:addDrugUse', src, "pill", pillConfig.toxicity)
        end

        Core.UI.Notify(src, "You feel the tension leaving your body...", "success")
        if Config.Debug then print("[DjonStNix-Pharmaceuticals] " .. GetPlayerName(src) .. " consumed " .. pillName) end
    else
        Core.UI.Notify(src, "This medication seems ineffective... you feel nothing.", "error")
    end
end)
