local QBCore = exports['qb-core']:GetCoreObject()
local spawnedPeds = {}

CreateThread(function()
    local pedsToSpawn = {
        {
            model = `a_m_m_hillbilly_02`,
            coords = vector4(-1187.73, -445.27, 43.91, 289.45), 
            options = {
                {
                    event = "DjonStNix-DrugProcessing:EnterLab",
                    icon = "fas fa-atom",
                    label = Lang:t("target.talk_to_walter")
                }
            }
        },
        {
             model = `a_m_m_mlcrisis_01`,
             coords = vector4(812.49, -2399.59, 23.66, 223.1), 
             options = {
                {
                    event = "DjonStNix-DrugProcessing:EnterCWarehouse",
                    icon = "fas fa-key",
                    label = Lang:t("target.talk_to_draco")
                }
             }
        },
        {
             model = `mp_f_weed_01`,
             coords = vector4(102.07, 175.08, 104.59, 159.91),
             options = {
                {
                    event = "DjonStNix-DrugProcessing:EnterWWarehouse",
                    icon = "fas fa-key",
                    label = Lang:t("target.talk_to_charlotte")
                }
             }
        }
    }
    
    for i=1, #pedsToSpawn do
        local data = pedsToSpawn[i]
        RequestModel(data.model)
        while not HasModelLoaded(data.model) do Wait(0) end
        
        local ped = CreatePed(0, data.model, data.coords.x, data.coords.y, data.coords.z - 1.0, data.coords.w, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        exports.ox_target:addLocalEntity(ped, data.options)
        table.insert(spawnedPeds, ped)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i=1, #spawnedPeds do
            DeleteEntity(spawnedPeds[i])
        end
    end
end)

CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = vector3(3535.66, 3661.69, 28.32),
        size = vector3(1.65, 2.4, 1.6),
        rotation = 350.0,
        options = {
            {
                name = "chemmenu",
                event = "DjonStNix-DrugProcessing:chemicalmenu",
                icon = "fas fa-vials",
                label = Lang:t("target.chemmenu")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(978.22, -147.1, -47.93),
        size = vector3(1.6, 1.8, 4.8),
        rotation = 0,
        options = {
            {
                name = "methprocess",
                event = "DjonStNix-DrugProcessing:ProcessChemicals",
                icon = "fas fa-vials",
                label = Lang:t("target.methprocess")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(982.56, -145.59, -48.8),
        size = vector3(1.2, 1.4, 3.0),
        rotation = 0,
        options = {
            {
                name = "methtempup",
                event = "DjonStNix-DrugProcessing:ChangeTemp",
                icon = "fas fa-temperature-empty",
                label = Lang:t("target.methtempup")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(979.59, -144.14, -48.55),
        size = vector3(1.2, 0.5, 1.3),
        rotation = 354,
        options = {
            {
                name = "methtempdown",
                event = "DjonStNix-DrugProcessing:ChangeTemp2",
                icon = "fas fa-temperature-full",
                label = Lang:t("target.methtempdown")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(987.44, -140.5, -49.0),
        size = vector3(0.5, 0.7, 0.7),
        rotation = 1,
        options = {
            {
                name = "methbagging",
                event = "DjonStNix-DrugProcessing:ProcessProduct",
                icon = "fas fa-box",
                label = Lang:t("target.bagging")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(969.04, -146.17, -46.0),
        size = vector3(0.4, 0.2, 0.4),
        rotation = 0,
        options = {
            {
                name = "methkeypad",
                event = "DjonStNix-DrugProcessing:ExitLab",
                icon = "fas fa-lock",
                label = Lang:t("target.keypad")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1088.56, -3187.02, -38.64),
        size = vector3(1, 1, 0.2),
        rotation = 0,
        options = {
            {
                name = "cokeleave",
                event = "DjonStNix-DrugProcessing:ExitCWarehouse",
                icon = "fas fa-lock",
                label = Lang:t("target.keypad")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1086.2, -3194.9, -38.89),
        size = vector3(2.5, 1.4, 1.0),
        rotation = 0,
        options = {
            {
                name = "cokeleafproc",
                event = "DjonStNix-DrugProcessing:ProcessCocaFarm",
                icon = "fas fa-scissors",
                label = Lang:t("target.cokeleafproc")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1092.89, -3195.78, -38.91),
        size = vector3(7.65, 1.2, 0.95),
        rotation = 90,
        options = {
            {
                name = "cokepowdercut",
                event = "DjonStNix-DrugProcessing:ProcessCocaPowder",
                icon = "fas fa-weight-scale",
                label = Lang:t("target.cokepowdercut")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1100.51, -3199.46, -39.29),
        size = vector3(2.6, 1.0, 1.4),
        rotation = 90,
        options = {
            {
                name = "cokebricked",
                event = "DjonStNix-DrugProcessing:ProcessBricks",
                icon = "fas fa-weight-scale",
                label = Lang:t("target.bagging")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1038.37, -3206.06, -37.97),
        size = vector3(2.6, 1.0, 0.8),
        rotation = 0,
        options = {
            {
                name = "weedproces",
                event = "DjonStNix-DrugProcessing:processWeed",
                icon = "fas fa-envira",
                label = Lang:t("target.weedproces")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1066.51, -3183.44, -38.96),
        size = vector3(1.6, 0.4, 2.4),
        rotation = 0,
        options = {
            {
                name = "weedkeypad",
                event = "DjonStNix-DrugProcessing:ExitWWarehouse",
                icon = "fas fa-lock",
                label = Lang:t("target.keypad")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1384.9, -2080.61, 52.21),
        size = vector3(2.5, 2.5, 2.0),
        rotation = 223.98,
        options = {
            {
                name = "heroinproces",
                event = "DjonStNix-DrugProcessing:processHeroin",
                icon = "fas fa-envira",
                label = Lang:t("target.heroinproces")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(-679.77, 5800.7, 16.33),
        size = vector3(1, 1, 4.0),
        rotation = 340.0,
        options = {
            {
                name = "thychloride",
                event = "DjonStNix-DrugProcessing:processingThiChlo",
                icon = "fas fa-biohazard",
                label = Lang:t("target.process_thionyl_chloride")
            }
        }
    })
    
    exports.ox_target:addBoxZone({
        coords = vector3(1413.7, -2041.77, 52.0),
        size = vector3(1, 1, 2.0),
        rotation = 352.15,
        options = {
            {
                name = "heroinproc",
                event = "DjonStNix-DrugProcessing:ProcessPoppy",
                icon = "fas fa-leaf",
                label = Lang:t("target.heroinproc")
            }
        }
    })
end)
