-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — SERVER CORE
-- ==============================================================================
-- DEVELOPED BY: DjonStNix (DjonLuc)
-- GITHUB: https://github.com/Djonluc
-- DISCORD: https://discord.gg/s7GPUHWrS7
-- YOUTUBE: https://www.youtube.com/@Djonluc
-- EMAIL: djonstnix@gmail.com
-- LICENSE: MIT License (c) 2026 DjonStNix (DjonLuc)
-- ==============================================================================

local QBCore = exports['qb-core']:GetCoreObject()

local isOxInventory = GetResourceState('ox_inventory') == 'started'

-- ==============================================================================
-- LOGGING UTILITY
-- ==============================================================================
local function LogAction(src, action, detail)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    print(string.format("[DjonStNix-DrugProcessing] [LOG] ID: %s | Name: %s | Action: %s | Details: %s", src, Player.PlayerData.name, action, detail))
end

-- ==============================================================================
-- INVENTORY WRAPPERS (Multi-Inventory Support)
-- ==============================================================================
local function GetItemCount(source, itemName)
    if isOxInventory then
        return exports.ox_inventory:Search(source, 'count', itemName)
    else
        local Player = QBCore.Functions.GetPlayer(source)
        local item = Player.Functions.GetItemByName(itemName)
        return item and item.amount or 0
    end
end

local function RemoveItem(source, itemName, amount)
    if isOxInventory then
        return exports.ox_inventory:RemoveItem(source, itemName, amount)
    else
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.RemoveItem(itemName, amount) then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[itemName], "remove")
            return true
        end
        return false
    end
end

local function AddItem(source, itemName, amount)
    if isOxInventory then
        return exports.ox_inventory:AddItem(source, itemName, amount)
    else
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.AddItem(itemName, amount) then
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[itemName], "add")
            return true
        end
        return false
    end
end

-- ==============================================================================
-- PROCESS VALIDATION & REWARDS
-- ==============================================================================
-- Main event for processing drugs.
-- Validates: 1. Distance | 2. Required Items | 3. Reward Generation
-- ==============================================================================
RegisterNetEvent('DjonStNix-DrugProcessing:server:processDrug', function(drugKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local drug = Config.Drugs[drugKey]

    if not Player or not drug then return end

    -- SECURITY: PROXIMITY CHECK (Server Side Authority)
    local coords = GetEntityCoords(GetPlayerPed(src))
    local dist = #(coords - drug.coords)
    if dist > (drug.radius + 5.0) then
        LogAction(src, "SECURITY_VIOLATION", "Attempted to process from distance: " .. dist)
        return
    end

    -- SECURITY: ITEM CHECK
    local hasAllItems = true
    if drug.requiredItems then
        for _, req in pairs(drug.requiredItems) do
            local count = GetItemCount(src, req.item)
            if count < req.amount then
                hasAllItems = false
                break
            end
        end
    end

    if hasAllItems then
        -- REMOVE ITEMS
        if drug.requiredItems then
            for _, req in pairs(drug.requiredItems) do
                RemoveItem(src, req.item, req.amount)
            end
        end

        -- ADD REWARDS
        if drug.rewardItems then
            for _, reward in pairs(drug.rewardItems) do
                AddItem(src, reward.item, reward.amount)
            end
        end

        -- TOXICITY INTEGRATION (Requires DjonStNix-Overdose)
        if Config.ToxicityExposure.enabled then
            local exposure = Config.ToxicityExposure.exposurePerCycle
            local protected = false

            if Config.ToxicityExposure.requireProtection then
                for _, protItem in pairs(Config.ToxicityExposure.protectionItems) do
                    local count = GetItemCount(src, protItem)
                    if count >= 1 then
                        protected = true
                        break
                    end
                end
            end

            if protected then
                exposure = math.floor(exposure * (1.0 - Config.ToxicityExposure.protectionReduction))
            end

            -- TRIGGER OVERDOSE TOXICITY
            if GetResourceState('DjonStNix-Overdose') == 'started' then
                TriggerClientEvent('DjonStNix-Overdose:addDrugUse', src, "exposure", exposure)
            end
        end

        LogAction(src, "DRUG_PROCESSED", "Processed: " .. drugKey)
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have all the required items!", "error")
    end
end)

-- ==============================================================================
-- VALIDATE LAB KEYS
-- ==============================================================================
QBCore.Functions.CreateCallback('DjonStNix-DrugProcessing:server:validateKey', function(source, cb, keyItem)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return cb(false) end

    local count = GetItemCount(source, keyItem)
    if count >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

-- ==============================================================================
-- INITIALIZATION
-- ==============================================================================
CreateThread(function()
    print("[DjonStNix-DrugProcessing] Server Core Initialized. Elite Mode active.")
end)
