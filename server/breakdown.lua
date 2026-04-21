-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — INVENTORY BREAKDOWN
-- ==============================================================================
-- Allows players to use bulk items (bricks/trays) from their inventory to
-- break them down into 90-100 individual baggies.
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()
local isOxInventory = GetResourceState('ox_inventory') == 'started'

-- ==============================================================================
-- INVENTORY WRAPPERS (Multi-Inventory Support)
-- ==============================================================================
local function GetItemCount(source, itemName)
    return Core.Items.GetItemCount(source, itemName)
end

local function RemoveItem(source, itemName, amount, metadata)
    return Core.Items.RemoveItem(source, itemName, amount, metadata)
end

local function AddItem(source, itemName, amount, metadata)
    return Core.Items.AddItem(source, itemName, amount, metadata)
end

local function BreakDownBulkItem(source, bulkItem, rewardItem, amountMin, amountMax, animDict, animClip, itemData)
    local Player = Core.Functions.GetPlayer(source)
    if not Player then return end

    -- Read purity from metadata
    local purity = 100
    if isOxInventory then
        purity = itemData.metadata and itemData.metadata.purity or 100
    else
        -- If QBCore or fallback, check .info
        purity = itemData.info and itemData.info.purity or (itemData.metadata and itemData.metadata.purity or 100)
    end

    -- Check for high quality scales
    if GetItemCount(source, "finescale") < 1 then
        Core.UI.Notify(source, "You need a high quality scale to weigh this properly.", "error")
        return
    end

    -- Check for empty baggies
    if GetItemCount(source, "empty_weed_bag") < 100 then
        Core.UI.Notify(source, "You need at least 100 empty baggies to break this down.", "error")
        return
    end

    -- Remove the bulk item and empty baggies
    local metadata = isOxInventory and itemData.metadata or nil
    if RemoveItem(source, bulkItem, 1, metadata) and RemoveItem(source, "empty_weed_bag", 100) then
        -- Play optional breakdown animation via client event
        TriggerClientEvent('DjonStNix-DrugProcessing:client:PlayBreakdownAnim', source, animDict, animClip)

        -- Give the player a random amount of baggies (90-100)
        local amount = math.random(amountMin, amountMax)
        
        -- Wait to simulate work
        SetTimeout(4000, function()
            AddItem(source, rewardItem, amount, { purity = purity })
            Core.UI.Notify(source, string.format("You broke down a %d%% purity bulk product. Results: %d baggies.", purity, amount), "success")
        end)
    end
end

-- ==============================================================================
-- REGISTER USABLE ITEMS
-- ==============================================================================

CreateThread(function()
    local items = {
        ["weed_brick"] = { product = "weed_baggy", min = 90, max = 100 },
        ["coke_brick"] = { product = "cokebaggy", min = 90, max = 100 },
        ["methtray"] = { product = "meth", min = 90, max = 100 },
        ["lsd_sheet"] = { product = "lsd", min = 40, max = 40 }
    }

    for item, data in pairs(items) do
        Core.Items.RegisterUsableItem(item, function(source, itemData)
            BreakDownBulkItem(source, item, data.product, data.min, data.max, "amb@prop_human_parking_meter@male@idle_a", "idle_a", itemData)
        end)
    end
end)
