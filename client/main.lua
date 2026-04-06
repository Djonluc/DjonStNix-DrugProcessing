-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — CLIENT CORE
-- ==============================================================================
-- DEVELOPED BY: DjonStNix (DjonLuc)
-- GITHUB: https://github.com/Djonluc
-- DISCORD: https://discord.gg/s7GPUHWrS7
-- YOUTUBE: https://www.youtube.com/@Djonluc
-- EMAIL: djonstnix@gmail.com
-- LICENSE: MIT License (c) 2026 DjonStNix (DjonLuc)
-- ==============================================================================

local QBCore = exports['qb-core']:GetCoreObject()
local isProcessing = false

-- ==============================================================================
-- LOGGING UTILITY
-- ==============================================================================
local function DebugLog(...)
    if Config.Debug then
        print('[DjonStNix-DrugProcessing] [DEBUG]', ...)
    end
end

-- ==============================================================================
-- ANIMATION HELPER
-- ==============================================================================
local function LoadAnimation(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

-- ==============================================================================
-- DRUG PROCESSING CORE
-- ==============================================================================
local function StartProcessing(drugKey)
    local drug = Config.Drugs[drugKey]
    if not drug or isProcessing then return end

    isProcessing = true
    local ped = PlayerPedId()

    -- ANIMATION LOADING
    if drug.anim then
        LoadAnimation(drug.anim.dict)
        TaskPlayAnim(ped, drug.anim.dict, drug.anim.clip, 5.0, 1.0, -1, 16, 0, false, false, false)
    end

    if lib.progressBar({
        duration = drug.duration,
        label = drug.progressBarLabel or drug.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true, move = true, combat = true, mouse = false
        }
    }) then
        StopAnimTask(ped, drug.anim.dict, drug.anim.clip, 1.0)
        TriggerServerEvent('DjonStNix-DrugProcessing:server:processDrug', drugKey)
        isProcessing = false
        DebugLog("Processing Cycle Complete: " .. drugKey)
    else
        StopAnimTask(ped, drug.anim.dict, drug.anim.clip, 1.0)
        QBCore.Functions.Notify("Processing canceled.", "error")
        isProcessing = false
    end
end

-- ==============================================================================
-- LABORATORY ACCESS
-- ==============================================================================
local function TeleportLab(coords)
    local ped = PlayerPedId()
    DoScreenFadeOut(500)
    Wait(500)
    SetEntityCoords(ped, coords.x, coords.y, coords.z - 0.98)
    SetEntityHeading(ped, coords.w)
    Wait(500)
    DoScreenFadeIn(500)
end

local function AccessLab(labName, type)
    local lab = Config.LabAccess[labName]
    if not lab then return end

    if type == "enter" then
        if Config.KeyRequired then
            QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:server:validateKey', function(hasKey)
                if hasKey then
                    TeleportLab(lab.exit)
                else
                    QBCore.Functions.Notify("You need the " .. lab.key .. " to enter!", "error")
                end
            end, lab.key)
        else
            TeleportLab(lab.exit)
        end
    else
        TeleportLab(lab.enter)
    end
end

-- ==============================================================================
-- TARGET INITIALIZATION
-- ==============================================================================
-- Uses qb-target to create interactive zones based on config.
-- ==============================================================================
local function InitTarget()
    -- PROCESSING ZONES
    for key, data in pairs(Config.Drugs) do
        exports.ox_target:addSphereZone({
            coords = data.coords,
            radius = data.radius or 2.0,
            options = {
                {
                    name = "DjonStNix_Process_"..key,
                    onSelect = function() StartProcessing(key) end,
                    icon = "fas fa-flask",
                    label = data.label,
                    distance = 2.5
                }
            }
        })
    end

    -- LAB ENTRANCES
    for key, data in pairs(Config.LabAccess) do
        exports.ox_target:addSphereZone({
            coords = vector3(data.enter.x, data.enter.y, data.enter.z),
            radius = 1.5,
            options = {
                {
                    name = "DjonStNix_LabEnter_"..key,
                    onSelect = function() AccessLab(key, "enter") end,
                    icon = "fas fa-door-closed",
                    label = "Enter " .. data.label,
                    distance = 2.0
                }
            }
        })

        exports.ox_target:addSphereZone({
            coords = vector3(data.exit.x, data.exit.y, data.exit.z),
            radius = 1.5,
            options = {
                {
                    name = "DjonStNix_LabExit_"..key,
                    onSelect = function() AccessLab(key, "exit") end,
                    icon = "fas fa-door-open",
                    label = "Exit " .. data.label,
                    distance = 2.0
                }
            }
        })
    end
end

-- ==============================================================================
-- INVENTORY BREAKDOWN ANIMATION
-- ==============================================================================
RegisterNetEvent('DjonStNix-DrugProcessing:client:PlayBreakdownAnim', function(animDict, animClip)
    local ped = PlayerPedId()
    
    LoadAnimation(animDict)
    TaskPlayAnim(ped, animDict, animClip, 5.0, 1.0, -1, 16, 0, false, false, false)
    if lib.progressBar({
        duration = 4000,
        label = "Breaking Down Product...",
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true, move = true, combat = true, mouse = false
        }
    }) then
        StopAnimTask(ped, animDict, animClip, 1.0)
    else
        StopAnimTask(ped, animDict, animClip, 1.0)
    end
end)

-- ==============================================================================
-- UTILITY: EXPOSURE FEEDBACK (UI)
-- ==============================================================================
-- Listens for toxicity changes to provide immersive visual feedback.
-- ==============================================================================
RegisterNetEvent('DjonStNix-Overdose:addDrugUse', function(drugType, amount)
    if drugType == "exposure" and amount > 0 then
        -- Optional: Shake cam or blur screen slightly when exposed to chemicals
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
        DebugLog("Warning: Exposure toxicity added: " .. amount)
    end
end)

-- ==============================================================================
-- INITIALIZATION
-- ==============================================================================
CreateThread(function()
    Wait(1000)
    InitTarget()
    DebugLog("Client Initialized. Core Ready.")
end)
