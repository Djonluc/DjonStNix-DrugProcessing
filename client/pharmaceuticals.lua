-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — PHARMACEUTICAL REFINEMENT
-- ==============================================================================
-- Handles the visualization and animation of drug consumption.
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()

-- ==============================================================================
-- MEDICATION CONSUMPTION (Phase 6)
-- ==============================================================================

RegisterNetEvent('DjonStNix-DrugProcessing:client:UseMedication', function(pillName)
    local ped = PlayerPedId()
    local config = Config.Pharmaceuticals[pillName]
    
    if not config then return end

    -- Load Animation
    RequestAnimDict(config.animation.dict)
    while not HasAnimDictLoaded(config.animation.dict) do Wait(10) end

    -- Play Animation
    TaskPlayAnim(ped, config.animation.dict, config.animation.clip, 8.0, 1.0, -1, config.animation.flag, 0, false, false, false)

    -- Progress Bar
    if lib.progressBar({
        duration = config.useTime or 3000,
        label = "Taking Medication...",
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false, car = false, combat = true, mouse = false
        }
    }) then
        StopAnimTask(ped, config.animation.dict, config.animation.clip, 1.0)
        TriggerServerEvent('DjonStNix-DrugProcessing:server:ApplyMedicationEffects', pillName)
    else
        StopAnimTask(ped, config.animation.dict, config.animation.clip, 1.0)
        lib.notify({ title = 'Cancelled', type = 'error' })
    end
end)
