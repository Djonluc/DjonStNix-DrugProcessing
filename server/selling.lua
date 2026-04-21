-- ==============================================================================
-- 👑 DJONSTNIX DRUG PROCESSING — DRUG SELLING SYSTEM
-- ==============================================================================
-- Secure backend for selling drugs to NPCs with purity-based pricing.
-- ==============================================================================

local Core = exports['DjonStNix-Bridge']:GetCore()
local isOxInventory = GetResourceState('ox_inventory') == 'started'
local undercoverCooldowns = {} -- undercoverCooldowns[src] = os.time() of last bust

-- ==============================================================================
-- LOGGING UTILITY
-- ==============================================================================
local function LogAction(src, action, detail)
    local playerName = GetPlayerName(src) or "Unknown"
    print(string.format("[DjonStNix-DrugSelling] [LOG] ID: %s | Action: %s | Details: %s", src, action, detail))
end

-- ==============================================================================
-- SELLING LOGIC
-- ==============================================================================

RegisterNetEvent('DjonStNix-DrugProcessing:server:sellToDealer', function(dealerId, itemData)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    local dealer = Config.Dealers[dealerId]
    
    if not Player or not dealer then return end

    -- Distance check
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local dist = #(coords.xy - dealer.coords.xy)
    local allowedDist = dealer.radius or 5.0
    
    if dist > (allowedDist + 5.0) then 
        LogAction(src, "SECURITY_ALERT", "Attempted to sell to dealer outside radius: " .. dist)
        return
    end

    -- Police Count Check
    local policeCount = Core.Player.GetDutyCount('police')
    if policeCount < (Config.Selling.requirePolice or 0) then
        Core.UI.Notify(src, "The streets are too quiet tonight... no ones buying.", "error")
        return
    end

    local itemName = itemData.name
    local itemConfig = dealer.buyItems[itemName]
    if not itemConfig then
        Core.UI.Notify(src, "The dealer isn't interested in this.", "error")
        return
    end

    -- Find the item in player's inventory to get metadata
    local item = nil
    local amount = 0
    local purity = 100 -- Default if no metadata

    if isOxInventory then
        local invItem = exports.ox_inventory:GetItem(src, itemName, nil, true)
        if invItem and invItem.count > 0 then
            item = invItem
            amount = invItem.count
            -- In Ox, metadata is often accessible via search or item object
            -- For simplicity, we search for the specific item with metadata
            local items = exports.ox_inventory:GetInventoryItems(src)
            for _, i in pairs(items) do
                if i.name == itemName then
                    purity = i.metadata and i.metadata.purity or 100
                    amount = i.count
                    item = i
                    break
                end
            end
        end
    else
        item = Player and Player.Functions and Player.Functions.GetItemByName and Player.Functions.GetItemByName(itemName) or nil
        if item then
            amount = item.amount
            purity = item.info and item.info.purity or 100
        end
    end

    if not item or amount <= 0 then
        Core.UI.Notify(src, "You don't have enough of this.", "error")
        return
    end

    -- REPUTATION-AWARE PAYOUT SYSTEM
    GetDealerReputation(src, dealerId, function(repData)
        if not repData then repData = { bonus = 0, perks = {}, label = "Unknown" } end

        -- UNDERCOVER RISK CHECK (Phase 5)
        if Config.UndercoverRisk and Config.UndercoverRisk.enabled then
            local ucChance = Config.UndercoverRisk.chance or 2

            -- Protection perk halves undercover chance
            if repData.perks then
                for _, perk in pairs(repData.perks) do
                    if perk == "protection" then
                        ucChance = math.floor(ucChance * 0.5)
                        break
                    end
                end
            end

            -- Check cooldown
            local now = os.time()
            local cooldown = Config.UndercoverRisk.cooldown or 300
            if not undercoverCooldowns[src] or (now - undercoverCooldowns[src]) > cooldown then
                if math.random(1, 100) <= ucChance then
                    -- BUSTED!
                    undercoverCooldowns[src] = now
                    Core.UI.Notify(src, Config.UndercoverRisk.bustMessage or "BUSTED!", "error")
                    TriggerClientEvent('DjonStNix-DrugProcessing:client:UndercoverBust', src, Config.UndercoverRisk.wantedLevel or 3)

                    -- Alert police via Bridge
                    if GetResourceState('DjonStNix-Bridge') == 'started' then
                        exports['DjonStNix-Bridge']:DispatchAlert(src, "undercover-bust", itemName)
                    end

                    LogAction(src, "UNDERCOVER_BUST", "Player was busted by undercover dealer: " .. dealerId)
                    return -- Sale does NOT complete
                end
            end
        end

        -- Calculate Payout with reputation bonus + market modifier
        -- FinalPrice = BasePrice * (Purity / 100) * MarketModifier * Amount * (1 + RepBonus/100)
        local repBonus = repData.bonus or 0
        local marketMod = GetMarketModifier(itemName)
        local pricePerUnit = itemConfig.basePrice * (purity / 100) * marketMod
        local basePayout = math.floor(pricePerUnit * amount)
        local bonusAmount = math.floor(basePayout * (repBonus / 100))
        local totalPayout = basePayout + bonusAmount

        -- POLICE ALERT SYSTEM (Chance based on drug rank)
        local riskChance = Config.Selling.riskLevels[itemName] or Config.Selling.policeAlertChance or 0

        -- PROTECTION PERK: "Boss" level reduces police alert chance by 50%
        local hasProtection = false
        if repData.perks then
            for _, perk in pairs(repData.perks) do
                if perk == "protection" then
                    hasProtection = true
                    break
                end
            end
        end
        if hasProtection then
            riskChance = math.floor(riskChance * 0.5)
        end

        if math.random(1, 100) <= riskChance then
            if GetResourceState('DjonStNix-Bridge') == 'started' then
                exports['DjonStNix-Bridge']:DispatchAlert(src, "drug-sale", itemName)
            else
                print("[DjonStNix-Selling] ALERT: Police notified of drug sale (Bridge not found)!")
            end
        end

        -- REMOVE ITEMS & PAY
        local removed = false
        if isOxInventory then
            removed = exports.ox_inventory:RemoveItem(src, itemName, amount, item.metadata)
        else
            removed = Core.Items.RemoveItem(src, itemName, amount)
        end

        if removed then
            Core.Money.AddMoney(src, Config.Selling.account or 'cash', totalPayout, "drug-sell")

            -- Build notification with rep + market info
            local repInfo = ""
            if repBonus > 0 then
                repInfo = string.format(" (+$%d rep bonus)", bonusAmount)
            end
            local marketInfo = ""
            if marketMod ~= 1.0 then
                local pct = math.floor((marketMod - 1.0) * 100)
                if pct > 0 then
                    marketInfo = string.format(" | 📈 Market +%d%%", pct)
                else
                    marketInfo = string.format(" | 📉 Market %d%%", pct)
                end
            end
            Core.UI.Notify(src, 
                string.format("Sold %dx %s at %d%% purity for $%d%s%s", amount, itemName, purity, totalPayout, repInfo, marketInfo), 
                "success"
            )
            LogAction(src, "DRUG_SOLD", string.format("Item: %s | Amt: %d | Pur: %d | Pay: %d | Rep: +%d%% | Mkt: x%.2f", itemName, amount, purity, totalPayout, repBonus, marketMod))

            -- AWARD REPUTATION (after successful sale)
            AwardReputation(src, dealerId, purity)

            -- RECORD MARKET SALE (track supply)
            RecordMarketSale(itemName, amount)
        else
            Core.UI.Notify(src, "Failed to remove items.", "error")
        end
    end)
end)
