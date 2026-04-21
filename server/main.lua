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

local Core = exports['DjonStNix-Bridge']:GetCore()

local isOxInventory = GetResourceState('ox_inventory') == 'started'

-- ==============================================================================
-- LOGGING UTILITY
-- ==============================================================================
local function LogAction(src, action, detail)
    local playerName = GetPlayerName(src) or "Unknown"
    print(string.format("[DjonStNix-DrugProcessing] [LOG] ID: %s | Name: %s | Action: %s | Details: %s", src, playerName, action, detail))
end

-- ==============================================================================
-- INVENTORY WRAPPERS (Multi-Inventory Support)
-- ==============================================================================
local function GetItemCount(source, itemName)
    if isOxInventory then
        return exports.ox_inventory:Search(source, 'count', itemName)
    else
        return Core.Items.GetItemCount(source, itemName)
    end
end

local function RemoveItem(source, itemName, amount)
    if isOxInventory then
        return exports.ox_inventory:RemoveItem(source, itemName, amount)
    else
        return Core.Items.RemoveItem(source, itemName, amount)
    end
end

local function AddItem(source, itemName, amount, metadata)
    if isOxInventory then
        return exports.ox_inventory:AddItem(source, itemName, amount, metadata)
    else
        return Core.Items.AddItem(source, itemName, amount, metadata)
    end
end

-- ==============================================================================
-- VALIDATION CALLBACKS
-- ==============================================================================
Core.Functions.CreateCallback('DjonStNix-DrugProcessing:server:canProcess', function(source, cb, drugKey)
    local drug = Config.Drugs[drugKey]
    if not drug or not drug.requiredItems then 
        cb(true, nil)
        return
    end

    for _, req in pairs(drug.requiredItems) do
        local count = GetItemCount(source, req.item)
        if count < req.amount then
            local itemData = Core.Items.GetItemData(req.item)
            cb(false, req.amount .. "x " .. (itemData and itemData.label or req.item))
            return
        end
    end

    cb(true, nil)
end)

-- ==============================================================================
-- PROCESS VALIDATION & REWARDS
-- ==============================================================================
-- Main event for processing drugs.
-- Validates: 1. Distance | 2. Required Items | 3. Reward Generation
-- ==============================================================================
RegisterNetEvent('DjonStNix-DrugProcessing:server:processDrug', function(drugKey, skillPassed)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
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

        -- ADD REWARDS (with Skill Check purity adjustment)
        if drug.rewardItems then
            local metadata = nil
            local labId = drug.labId
            local labCondition = 100
            local isDirty = false
            local criticalFailure = false

            -- LAB MAINTENANCE PENALTIES (Phase 4)
            if Config.Maintenance.enabled and labId then
                labCondition = GetLabCondition(labId)
                
                -- Check for Dirty Lab penalties
                if labCondition < Config.Maintenance.failureThreshold then
                    isDirty = true
                end

                -- Check for Critical Failure (Explosion Risk)
                if labCondition < 10 and math.random(1, 100) <= (Config.Maintenance.explosionChance or 5) then
                    criticalFailure = true
                end

                -- Degrade Lab Condition
                DegradeLab(labId, Config.Maintenance.degradePerCycle)
            end

            -- ABORT IF CRITICAL FAILURE
            if criticalFailure then
                Core.UI.Notify(src, "CRITICAL FAILURE! The lab equipment malfunctioned due to poor maintenance!", "error")
                LogAction(src, "LAB_EXPLOSION", "Processing failed due to critical lab condition: " .. labId)
                -- Optional: Catch fire? We'll just fail the batch for now as it's a "clean" but punishing mechanic.
                return
            end

            if drug.purityRange then
                local purity = math.random(drug.purityRange.min, drug.purityRange.max)

                -- SKILL CHECK PURITY ADJUSTMENT
                -- Server authority: only uses boolean, never trusts client values
                if Config.SkillCheck.enabled and skillPassed == false then
                    purity = math.floor(purity * (Config.SkillCheck.spoilMultiplier or 0.5))
                    LogAction(src, "SKILL_CHECK_FAILED", "Spoiled: " .. drug.rewardItems[1].item .. " | Reduced Purity: " .. purity .. "%")
                elseif Config.SkillCheck.enabled and skillPassed == true then
                    purity = drug.purityRange.max
                    LogAction(src, "SKILL_CHECK_PASSED", "Perfect: " .. drug.rewardItems[1].item .. " | Max Purity: " .. purity .. "%")
                end

                -- MAINTENANCE PENALTY (Dirty Lab)
                if isDirty then
                    purity = math.floor(purity * (Config.Maintenance.purityPenalty or 0.8))
                    Core.UI.Notify(src, "Warning: Dirty equipment has reduced your batch purity!", "error")
                end

                metadata = { purity = purity }
                LogAction(src, "PURITY_GENERATED", "Item: " .. drug.rewardItems[1].item .. " | Purity: " .. purity .. "%")
            end

            for _, reward in pairs(drug.rewardItems) do
                AddItem(src, reward.item, reward.amount, metadata)
            end
        end

        -- TOXICITY INTEGRATION (Requires DjonStNix-Overdose)
        if Config.ToxicityExposure.enabled then
            local exposure = Config.ToxicityExposure.exposurePerCycle
            local protected = false
            local labId = drug.labId
            
            -- MAINTENANCE PENALTY: TOXIC FUMES (Dirty Lab)
            if Config.Maintenance.enabled and labId then
                local labCondition = GetLabCondition(labId)
                if labCondition < Config.Maintenance.failureThreshold then
                    exposure = math.floor(exposure * (Config.Maintenance.fumeExposureMultiplier or 1.5))
                    Core.UI.Notify(src, "The fumes are worse than usual... this lab is filthy.", "error")
                end
            end

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
        Core.UI.Notify(src, "You don't have all the required items!", "error")
    end
end)

-- ==============================================================================
-- HARVESTING VALIDATION & REWARDS
-- ==============================================================================
RegisterNetEvent('DjonStNix-DrugProcessing:server:harvestDrug', function(drugKey)
    local src = source
    local Player = Core.Functions.GetPlayer(src)
    local drug = Config.Drugs[drugKey]

    if not Player or not drug or drug.type ~= "harvest" then return end

    -- SECURITY: PROXIMITY CHECK (Server Side Authority)
    local coords = GetEntityCoords(GetPlayerPed(src))
    local dist = #(coords.xy - drug.coords.xy)
    
    -- Fields are larger than processing stations, using radius + large buffer to account for float offsets
    if dist > (drug.radius + 30.0) then 
        LogAction(src, "SECURITY_VIOLATION", "Attempted to harvest from distance XY: " .. dist)
        return
    end

    -- ADD REWARDS
    if drug.rewardItems then
        for _, reward in pairs(drug.rewardItems) do
            local amount = reward.amount
            if reward.minAmount and reward.maxAmount then
                amount = math.random(reward.minAmount, reward.maxAmount)
            end
            AddItem(src, reward.item, amount)
        end
        LogAction(src, "DRUG_HARVESTED", "Harvested: " .. drugKey)
    end
end)

-- ==============================================================================
-- VALIDATE LAB KEYS
-- ==============================================================================
Core.Functions.CreateCallback('DjonStNix-DrugProcessing:server:validateKey', function(source, cb, keyItem)
    if not Core.Functions.GetPlayer(source) then return cb(false) end

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
