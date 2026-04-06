local isPickingUp, isProcessing = false, false
local QBCore = exports['qb-core']:GetCoreObject()

local function Processlsd()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	if lib.progressBar({
		duration = 15000,
		label = Lang:t("progressbar.processing"),
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true, move = true, combat = true, mouse = false
		}
	}) then
		TriggerServerEvent('DjonStNix-DrugProcessing:Processlsd')

		local timeLeft = Config.Delays.lsdProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.lsdProcessing.coords) > 5 then
				QBCore.Functions.Notify(Lang:t("error.too_far"))
				TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isProcessing = false
	else
		ClearPedTasks(playerPed)
		isProcessing = false
	end
end

local function Processthionylchloride()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	if lib.progressBar({
		duration = 15000,
		label = Lang:t("progressbar.processing"),
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true, move = true, combat = true, mouse = false
		}
	}) then
		TriggerServerEvent('DjonStNix-DrugProcessing:processThionylChloride')
		local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.thionylchlorideProcessing.coords) > 5 then
				QBCore.Functions.Notify(Lang:t("error.too_far"))
				TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isProcessing = false
	else
		ClearPedTasks(playerPed)
		isProcessing = false
	end
end

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if #(coords-Config.CircleZones.lsdProcessing.coords) < 2 then
            if not isProcessing then
                local pos = GetEntityCoords(PlayerPedId())
                QBCore.Functions.DrawText3D(pos.x, pos.y, pos.z, Lang:t("drawtext.process_lsd"))
            end
            if IsControlJustReleased(0, 38) and not isProcessing then
				QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
					if result.ret then
                        Processlsd()
					else
						QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
					end
				end, {lsa = 1, thionyl_chloride = 1})
            end
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent('DjonStNix-DrugProcessing:processingThiChlo', function()
	local coords = GetEntityCoords(PlayerPedId(source))
	
	if #(coords-Config.CircleZones.thionylchlorideProcessing.coords) < 5 then
		if not isProcessing then
			QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
				if result.ret then
					Processthionylchloride()
				else
					QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
				end
			end, {lsa = 1, chemicals = 1})
		end
	end
end)
