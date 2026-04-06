-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — INVENTORY BREAKDOWN
-- ==============================================================================
-- Allows players to use bulk items (bricks/trays) from their inventory to
-- break them down into 90-100 individual baggies.
-- ==============================================================================

local QBCore = exports['qb-core']:GetCoreObject()
local isOxInventory = GetResourceState('ox_inventory') == 'started'

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

local function BreakDownBulkItem(source, bulkItem, rewardItem, amountMin, amountMax, animDict, animClip)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    -- Check for high quality scales
    local scaleCount = GetItemCount(source, "highqualityscales")
    if scaleCount < 1 then
        TriggerClientEvent('QBCore:Notify', source, "You need a high quality scale to weigh this properly.", "error")
        return
    end

    -- Check for empty baggies
    local bagsCount = GetItemCount(source, "empty_weed_bag")
    if bagsCount < 100 then
        TriggerClientEvent('QBCore:Notify', source, "You need at least 100 empty baggies to break this down.", "error")
        return
    end

    -- Remove the bulk item and empty baggies
    if RemoveItem(source, bulkItem, 1) and RemoveItem(source, "empty_weed_bag", 100) then
        -- Play optional breakdown animation via client event
        TriggerClientEvent('DjonStNix-DrugProcessing:client:PlayBreakdownAnim', source, animDict, animClip)

        -- Give the player a random amount of baggies (90-100)
        local amount = math.random(amountMin, amountMax)
        
        -- Small wait to simulate breaking it down before giving items
        SetTimeout(4000, function()
            AddItem(source, rewardItem, amount)
            TriggerClientEvent('QBCore:Notify', source, string.format("You broke down the bulk product into %d baggies. %d baggies were wasted/ripped.", amount, 100 - amount), "success")
        end)
    end
end

-- ==============================================================================
-- REGISTER USABLE ITEMS
-- ==============================================================================

-- Weed Brick -> 90-100 Weed Baggies
QBCore.Functions.CreateUseableItem("weed_brick", function(source, item)
    BreakDownBulkItem(source, "weed_brick", "weed_baggy", 90, 100, "amb@prop_human_parking_meter@male@idle_a", "idle_a")
end)

-- Cocaine Brick -> 90-100 Coke Baggies
QBCore.Functions.CreateUseableItem("coke_brick", function(source, item)
    BreakDownBulkItem(source, "coke_brick", "cokebaggy", 90, 100, "amb@prop_human_parking_meter@male@idle_a", "idle_a")
end)

-- Meth Tray -> 90-100 Meth Baggies
QBCore.Functions.CreateUseableItem("methtray", function(source, item)
    BreakDownBulkItem(source, "methtray", "meth", 90, 100, "amb@prop_human_parking_meter@male@idle_a", "idle_a")
end)
