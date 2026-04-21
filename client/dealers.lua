-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — DEALER NPC SYSTEM
-- ==============================================================================
-- Spawns Dealer NPCs and handles selling interactions.
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()
local spawnedDealers = {}

-- ==============================================================================
-- NPC MANAGEMENT
-- ==============================================================================

local function SpawnDealerNPC(dealerId, data)
    local model = GetHashKey(data.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    local npc = CreatePed(4, model, data.coords.x, data.coords.y, data.coords.z - 1.0, data.coords.w, false, true)
    SetEntityHeading(npc, data.coords.w)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    TaskStartScenarioInPlace(npc, "WORLD_HUMAN_SMOKING", 0, true)

    exports.ox_target:addLocalEntity(npc, {
        {
            name = 'djonstnix_dealer_talk',
            icon = 'fas fa-comments',
            label = "Talk to " .. data.label,
            onSelect = function()
                OpenDealerMenu(dealerId, data)
            end
        }
    })

    spawnedDealers[dealerId] = npc
    SetModelAsNoLongerNeeded(model)
end

-- ==============================================================================
-- SELLING MENU
-- ==============================================================================

function OpenDealerMenu(dealerId, data)
    -- Fetch reputation data from server
    Core.Functions.TriggerCallback('DjonStNix-DrugProcessing:server:getDealerRep', function(repData)
        local options = {}
        local repBonus = (repData and repData.bonus) or 0
        local repLabel = (repData and repData.label) or "Unknown"
        local repLevel = (repData and repData.level) or 1
        local repPoints = (repData and repData.points) or 0

        -- Add reputation status header
        table.insert(options, {
            title = string.format("⭐ Rank: %s (Level %d)", repLabel, repLevel),
            description = string.format("Points: %d | Payout Bonus: +%d%%", repPoints, repBonus),
            icon = 'fas fa-star',
            readOnly = true
        })

        for itemName, itemData in pairs(data.buyItems) do
            local itemInfo = Core.Items.GetItemData and Core.Items.GetItemData(itemName) or { label = itemName }
            local label = itemInfo.label or itemName
            local effectivePrice = math.floor(itemData.basePrice * (1 + repBonus / 100))
            table.insert(options, {
                title = "Sell " .. label,
                description = string.format("Base: $%d | Your Price: $%d (+%d%%)", itemData.basePrice, effectivePrice, repBonus),
                icon = 'fas fa-money-bill-wave',
                onSelect = function()
                    TriggerServerEvent('DjonStNix-DrugProcessing:server:sellToDealer', dealerId, { name = itemName })
                end
            })
        end

        lib.registerContext({
            id = 'djonstnix_dealer_menu',
            title = data.label .. " — " .. repLabel,
            options = options
        })
        lib.showContext('djonstnix_dealer_menu')
    end, dealerId)
end

-- ==============================================================================
-- LIFE CYCLE
-- ==============================================================================

CreateThread(function()
    Wait(2000) -- Ensure target and config are loaded
    for id, data in pairs(Config.Dealers) do
        SpawnDealerNPC(id, data)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, npc in pairs(spawnedDealers) do
            DeleteEntity(npc)
        end
    end
end)
