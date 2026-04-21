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

local Core = exports['DjonStNix-Bridge']:GetCore()
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
    local timeout = 0
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 5000 then
            print("[DjonStNix-DrugProcessing] WARNING: Animation dict failed to load: " .. dict)
            return false
        end
    end
    return true
end

local function LoadModel(model)
    local hash = type(model) == "string" and joaat(model) or model
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
end

-- ==============================================================================
-- DRUG PROCESSING & HARVESTING CORE
-- ==============================================================================
local function StartProcessing(drugKey)
    print("[DjonStNix-DrugProcessing] StartProcessing called with key: " .. tostring(drugKey))
    local drug = Config.Drugs[drugKey]
    if not drug then
        print("[DjonStNix-DrugProcessing] ERROR: Drug key not found in Config.Drugs: " .. tostring(drugKey))
        return
    end
    if isProcessing then
        print("[DjonStNix-DrugProcessing] ERROR: Already processing, skipping.")
        return
    end

    print("[DjonStNix-DrugProcessing] Triggering server callback canProcess...")
    Core.Functions.TriggerCallback('DjonStNix-DrugProcessing:server:canProcess', function(canProcess, missingItem)
        print("[DjonStNix-DrugProcessing] Callback returned: canProcess=" .. tostring(canProcess) .. " missingItem=" .. tostring(missingItem))
        if not canProcess then
            lib.notify({
                title = 'Missing Items',
                description = 'You are missing: ' .. (missingItem or 'Unknown'),
                type = 'error'
            })
            return
        end

        print("[DjonStNix-DrugProcessing] Callback success, starting processing...")
        isProcessing = true
        local ped = PlayerPedId()

        -- ANIMATION LOADING (supports both dict/clip and scenario)
        if drug.anim then
            if drug.anim.scenario then
                print("[DjonStNix-DrugProcessing] Playing scenario: " .. drug.anim.scenario)
                TaskStartScenarioInPlace(ped, drug.anim.scenario, 0, true)
            elseif drug.anim.dict then
                print("[DjonStNix-DrugProcessing] Loading animation: " .. drug.anim.dict)
                LoadAnimation(drug.anim.dict)
                TaskPlayAnim(ped, drug.anim.dict, drug.anim.clip, 5.0, 1.0, -1, 16, 0, false, false, false)
            end
        end

        print("[DjonStNix-DrugProcessing] Starting progress bar...")
        if lib.progressBar({
            duration = drug.duration,
            label = drug.progressBarLabel or drug.label,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true, move = true, combat = true, mouse = false
            }
        }) then
            ClearPedTasks(ped)

            -- SKILL CHECK SYSTEM (Interactive Refining)
            local skillPassed = true -- Default: pass (for stations without skill checks)
            if Config.SkillCheck.enabled and drug.purityRange then
                local sc = drug.skillCheck or {}
                local difficulty = sc.difficulty or Config.SkillCheck.defaultDifficulty
                local inputs = sc.inputs or Config.SkillCheck.defaultInputs

                DebugLog("Running skill check with difficulty: " .. json.encode(difficulty))
                skillPassed = lib.skillCheck(difficulty, inputs)

                if skillPassed then
                    lib.notify({
                        title = 'Perfect Batch!',
                        description = 'Your technique was flawless.',
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = 'Spoiled Batch!',
                        description = 'Your hand slipped... quality reduced.',
                        type = 'error'
                    })
                end
            end

            TriggerServerEvent('DjonStNix-DrugProcessing:server:processDrug', drugKey, skillPassed)
            isProcessing = false
            DebugLog("Processing Cycle Complete: " .. drugKey .. " | SkillPassed: " .. tostring(skillPassed))
        else
            ClearPedTasks(ped)
            lib.notify({
                title = 'Cancelled',
                description = 'Processing cancelled.',
                type = 'error'
            })
            isProcessing = false
        end
    end, drugKey)
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
        Core.UI.Notify("Harvesting canceled.", "error")
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

    local hash = type(data.model) == "string" and joaat(data.model) or data.model
    LoadModel(hash)

    -- Spawn Loop: Create a cluster of harvestable items
    for i = 1, 15 do
        -- Proper float randomization for natural spreading
        local randomX = (math.random() * 2.0 - 1.0) * data.radius
        local randomY = (math.random() * 2.0 - 1.0) * data.radius
        local offset = vector3(randomX, randomY, 0)
        local spawnPos = data.coords + offset
        
        -- Try to find the ground Z. If chunks aren't loaded, fallback to defined Z
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z + 50.0, 0)
        if not foundGround then
            groundZ = spawnPos.z
        end

        local obj = CreateObject(hash, spawnPos.x, spawnPos.y, groundZ, false, true, false)
        PlaceObjectOnGroundProperly(obj)
        FreezeEntityPosition(obj, true)

        table.insert(spawnedHarvestables[drugKey], obj)
        Wait(10)
    end
    SetModelAsNoLongerNeeded(hash)
end

local function InitHarvestingZones()
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)

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

            -- Force spawn immediately if we restart the script while standing in the zone
            if #(pCoords - data.coords) <= (data.radius + 10.0) then
                SpawnHarvestables(key)
            end
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

local function AccessLab(labName, action)
    local lab = Config.LabAccess[labName]
    if not lab then return end

    if action == "enter" then
        if Config.KeyRequired then
            Core.Functions.TriggerCallback('DjonStNix-DrugProcessing:server:validateKey', function(hasKey)
                if hasKey then
                    TeleportLab(lab.exit)
                else
                    Core.UI.Notify("You need the " .. lab.key .. " to enter!", "error")
                end
            end, lab.key)
        else
            TeleportLab(lab.exit)
        end
    else
        TeleportLab(lab.enter)
    end

    -- Show Lab Condition (Phase 4)
    if Config.Maintenance.enabled then
        Core.Functions.TriggerCallback('DjonStNix-DrugProcessing:server:getLabCondition', function(condition)
            local type = 'inform'
            if condition < Config.Maintenance.failureThreshold then type = 'warning' end
            if condition < 10 then type = 'error' end
            
            lib.notify({
                title = lab.label .. ' Condition',
                description = 'Current Status: ' .. condition .. '%',
                type = type
            })
        end, labName)
    end
end

-- ==============================================================================
-- TARGET INITIALIZATION
-- ==============================================================================
local function InitTarget()
    -- TRACK MODELS TO AVOID MULTIPLE REGISTERING
    local registeredModels = {}
    local processCount = 0
    local harvestCount = 0

    -- DRUG SYSTEM (PROCESSING & HARVESTING)
    for key, data in pairs(Config.Drugs) do
        if data.type == "processing" then
            exports.ox_target:addSphereZone({
                coords = data.coords,
                radius = data.radius or 2.0,
                debug = Config.Debug,
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
            processCount = processCount + 1
            print("[DjonStNix-DrugProcessing] Registered processing zone: " .. key .. " at " .. tostring(data.coords))
        elseif data.type == "harvest" and data.model then
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
                harvestCount = harvestCount + 1
            end
        end
    end

    print("[DjonStNix-DrugProcessing] Registered " .. processCount .. " processing zones, " .. harvestCount .. " harvest models.")

    -- LAB ENTRANCES
    for key, data in pairs(Config.LabAccess) do
        exports.ox_target:addSphereZone({
            coords = vector3(data.enter.x, data.enter.y, data.enter.z),
            radius = 1.5,
            debug = Config.Debug,
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
            debug = Config.Debug,
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

    print("[DjonStNix-DrugProcessing] InitTarget complete.")
end

-- ==============================================================================
-- UNDERCOVER BUST EFFECTS (Phase 5)
-- ==============================================================================
RegisterNetEvent('DjonStNix-DrugProcessing:client:UndercoverBust', function(wantedLevel)
    local ped = PlayerPedId()
    
    -- Apply wanted level
    SetPlayerWantedLevel(PlayerId(), wantedLevel or 3, false)
    SetPlayerWantedLevelNow(PlayerId(), false)
    
    -- Camera shake for panic effect
    ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 0.5)
    Wait(2000)
    StopGameplayCamShaking(true)
end)

    else
        StopAnimTask(ped, animDict, animClip, 1.0)
    end
end)

-- ==============================================================================
-- LAB MAINTENANCE INTERACTION (Phase 4)
-- ==============================================================================
function PerformMaintenance(labId)
    local ped = PlayerPedId()
    local lab = Config.LabAccess[labId]
    if not lab then return end

    -- Play maintenance animation
    LoadAnimation("amb@prop_human_parking_meter@male@idle_a")
    TaskPlayAnim(ped, "amb@prop_human_parking_meter@male@idle_a", "idle_a", 5.0, 1.0, -1, 16, 0, false, false, false)

    if lib.progressBar({
        duration = 10000,
        label = "Performing Lab Maintenance...",
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true, mouse = false }
    }) then
        StopAnimTask(ped, "amb@prop_human_parking_meter@male@idle_a", "idle_a", 1.0)
        TriggerServerEvent('DjonStNix-DrugProcessing:server:PerformMaintenance', labId)
    else
        StopAnimTask(ped, "amb@prop_human_parking_meter@male@idle_a", "idle_a", 1.0)
        lib.notify({ title = 'Maintenance Cancelled', type = 'error' })
    end
end

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
-- EVENT BRIDGES (target.lua fires these legacy events)
-- ==============================================================================
-- Processing events from target.lua box zones → routed to StartProcessing()
AddEventHandler('DjonStNix-DrugProcessing:processWeed', function() StartProcessing("weed") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessWeedBrick', function() StartProcessing("weed_brick") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessCocaFarm', function() StartProcessing("coke_process") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessCocaPowder', function() StartProcessing("coke_powder_cut") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessBricks', function() StartProcessing("coke_brick") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessChemicals', function() StartProcessing("meth_process") end)
AddEventHandler('DjonStNix-DrugProcessing:ChangeTemp', function() StartProcessing("meth_temp_up") end)
AddEventHandler('DjonStNix-DrugProcessing:ChangeTemp2', function() StartProcessing("meth_temp_down") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessProduct', function() StartProcessing("meth_bag") end)
AddEventHandler('DjonStNix-DrugProcessing:processHeroin', function() StartProcessing("heroin_process") end)
AddEventHandler('DjonStNix-DrugProcessing:ProcessPoppy', function() StartProcessing("heroin_cook") end)
AddEventHandler('DjonStNix-DrugProcessing:processingThiChlo', function() StartProcessing("thionyl_process") end)

-- Chemical conversion menu (ox_lib context menu)
AddEventHandler('DjonStNix-DrugProcessing:chemicalmenu', function()
    lib.registerContext({
        id = 'djonstnix_chem_menu',
        title = Lang:t("menu.chemMenuHeader"),
        options = {
            {
                title = Lang:t("items.hydrochloric_acid"),
                description = Lang:t("menu.chemicals"),
                onSelect = function() StartProcessing("chem_hydrochloric") end
            },
            {
                title = Lang:t("items.sodium_hydroxide"),
                description = Lang:t("menu.chemicals"),
                onSelect = function() StartProcessing("chem_sodium") end
            },
            {
                title = Lang:t("items.sulfuric_acid"),
                description = Lang:t("menu.chemicals"),
                onSelect = function() StartProcessing("chem_sulfuric") end
            },
            {
                title = Lang:t("items.lsa"),
                description = Lang:t("menu.chemicals"),
                onSelect = function() StartProcessing("chem_lsa") end
            }
        }
    })
    lib.showContext('djonstnix_chem_menu')
end)

-- Chemical sub-events (from menu onSelect)
AddEventHandler('DjonStNix-DrugProcessing:hydrochloric_acid', function() StartProcessing("chem_hydrochloric") end)
AddEventHandler('DjonStNix-DrugProcessing:sodium_hydroxide', function() StartProcessing("chem_sodium") end)
AddEventHandler('DjonStNix-DrugProcessing:sulfuric_acid', function() StartProcessing("chem_sulfuric") end)
AddEventHandler('DjonStNix-DrugProcessing:lsa', function() StartProcessing("chem_lsa") end)

-- Lab access events from target.lua → routed to AccessLab()
AddEventHandler('DjonStNix-DrugProcessing:EnterLab', function() AccessLab("meth_lab", "enter") end)
AddEventHandler('DjonStNix-DrugProcessing:ExitLab', function() AccessLab("meth_lab", "exit") end)
AddEventHandler('DjonStNix-DrugProcessing:EnterCWarehouse', function() AccessLab("coke_lab", "enter") end)
AddEventHandler('DjonStNix-DrugProcessing:ExitCWarehouse', function() AccessLab("coke_lab", "exit") end)
AddEventHandler('DjonStNix-DrugProcessing:EnterWWarehouse', function() AccessLab("weed_lab", "enter") end)
AddEventHandler('DjonStNix-DrugProcessing:ExitWWarehouse', function() AccessLab("weed_lab", "exit") end)


-- ==============================================================================
-- INITIALIZATION
-- ==============================================================================
CreateThread(function()
    Wait(1000)
    InitTarget()
    InitHarvestingZones()
    DebugLog("Client Initialized. Core Ready.")
end)
