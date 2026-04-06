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

local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

-- ==============================================================================
-- DRUG PROCESSING & HARVESTING CORE
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

local function HarvestDrug(drugKey, entity)
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
        
        -- DELETING THE HARVESTED ENTITY
        if entity and DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, false, true)
            DeleteObject(entity)
        end

        TriggerServerEvent('DjonStNix-DrugProcessing:server:harvestDrug', drugKey)
        isProcessing = false
        DebugLog("Harvesting Cycle Complete: " .. drugKey)
    else
        StopAnimTask(ped, drug.anim.dict, drug.anim.clip, 1.0)
        QBCore.Functions.Notify("Harvesting canceled.", "error")
        isProcessing = false
    end
end

-- ==============================================================================
-- HARVESTING SPAWNING LOGIC
-- ==============================================================================
local spawnedHarvestables = {}

local function SpawnHarvestables(drugKey)
    local data = Config.Drugs[drugKey]
    if not data or data.type ~= "harvest" or not data.model then return end

    -- Cleanup existing
    if spawnedHarvestables[drugKey] then
        for _, entity in pairs(spawnedHarvestables[drugKey]) do
            if DoesEntityExist(entity) then DeleteObject(entity) end
        end
    end
    spawnedHarvestables[drugKey] = {}

    LoadModel(data.model)

    -- Spawn Loop: Create a cluster of harvestable items
    for i = 1, 15 do
        local offset = vector3(math.random(-data.radius, data.radius), math.random(-data.radius, data.radius), 0)
        local spawnPos = data.coords + offset
        
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 50.0, 0)
        if foundGround then
            local obj = CreateObject(data.model, spawnPos.x, spawnPos.y, groundZ, false, false, false)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            table.insert(spawnedHarvestables[drugKey], obj)
        end
    end
    SetModelAsNoLongerNeeded(data.model)
end

local function InitHarvestingZones()
    for key, data in pairs(Config.Drugs) do
        if data.type == "harvest" then
            lib.zones.sphere({
                coords = data.coords,
                radius = data.radius + 10.0,
                debug = Config.Debug,
                onEnter = function()
                    SpawnHarvestables(key)
                end,
                onExit = function()
                    if spawnedHarvestables[key] then
                        for _, entity in pairs(spawnedHarvestables[key]) do
                            if DoesEntityExist(entity) then DeleteObject(entity) end
                        end
                        spawnedHarvestables[key] = {}
                    end
                end
            })
        end
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
local function InitTarget()
    -- TRACK MODELS TO AVOID MULTIPLE REGISTERING
    local registeredModels = {}

    -- DRUG SYSTEM (PROCESSING & HARVESTING)
    for key, data in pairs(Config.Drugs) do
        if data.type == "processing" then
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
        elseif data.type == "harvest" and data.model then
            -- ADD MODEL-BASED TARGETING
            if not registeredModels[data.model] then
                exports.ox_target:addModel(data.model, {
                    {
                        name = "DjonStNix_Harvest_"..key,
                        onSelect = function(args) HarvestDrug(key, args.entity) end,
                        icon = "fas fa-leaf",
                        label = data.label,
                        distance = 2.0
                    }
                })
                registeredModels[data.model] = true
            end
        end
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
    InitHarvestingZones()
    DebugLog("Client Initialized. Core Ready.")
end)
