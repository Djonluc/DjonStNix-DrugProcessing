local  isProcessing, isTempChangeU, isTempChangeD, isBagging = false, false, false, false
local Methlab = false
local QBCore = exports['qb-core']:GetCoreObject()
local Bridge = exports['DjonStNix-Bridge']:GetCore()

local function ProcessChemicals()
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
		TriggerServerEvent('DjonStNix-DrugProcessing:processChemicals')

		local timeLeft = Config.Delays.MethProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.MethProcessing.coords) > 2 then
				QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
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

local function ProcessTempUp()
	isTempChangeU = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	if lib.progressBar({
		duration = 15000,
		label = Lang:t("progressbar.temp_up"),
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true, move = true, combat = true, mouse = false
		}
	}) then
		TriggerServerEvent('DjonStNix-DrugProcessing:processTempUp')

		local timeLeft = Config.Delays.MethProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.MethTemp.coords) > 2 then
				QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
				TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isTempChangeU = false
	else
		ClearPedTasks(playerPed)
		isTempChangeU = false
	end
end

local function ProcessTempDown()
	isTempChangeD = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	if lib.progressBar({
		duration = 15000,
		label = Lang:t("progressbar.temp_down"),
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true, move = true, combat = true, mouse = false
		}
	}) then
		TriggerServerEvent('DjonStNix-DrugProcessing:processTempDown')

		local timeLeft = Config.Delays.MethProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.MethTemp.coords) > 2 then
				QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
				TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isTempChangeD = false
	else
		ClearPedTasks(playerPed)
		isTempChangeD = false
	end
end

local function ProcessProduct()
	isBagging = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	if lib.progressBar({
		duration = 15000,
		label = Lang:t("progressbar.packing"),
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true, move = true, combat = true, mouse = false
		}
	}) then
		TriggerServerEvent('DjonStNix-DrugProcessing:processMeth')

		local timeLeft = Config.Delays.MethProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.MethBag.coords) > 2 then
				QBCore.Functions.Notify(Lang:t("error.too_far"), "error")
				TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
				break
			end
		end
		ClearPedTasks(playerPed)
		isBagging = false
	else
		ClearPedTasks(playerPed)
		isBagging = false
	end
end

local function LoadAnimationDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(1)
    end
end

local function OpenDoorAnimation()
    local ped = PlayerPedId()
    LoadAnimationDict("anim@heists@keycard@") 
    TaskPlayAnim(ped, "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(ped)
end

local function EnterMethlab()
    local ped = PlayerPedId()
    OpenDoorAnimation()
    Methlab = true
    Wait(500)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.MethLab["exit"].coords.x, Config.MethLab["exit"].coords.y, Config.MethLab["exit"].coords.z - 0.98)
    SetEntityHeading(ped, Config.MethLab["exit"].coords.w)
    Wait(1000)
    DoScreenFadeIn(250)
end

local function ExitMethlab()
    local ped = PlayerPedId()
    local dict = "mp_heists@keypad@"
    local keypad = {coords = {x = 969.04, y = -146.17, z = -46.4, h = 94.5, r = 1.0}}
    SetEntityCoords(ped, keypad.coords.x, keypad.coords.y, keypad.coords.z - 0.98)
    SetEntityHeading(ped, keypad.coords.h)
	Methlab = true
    LoadAnimationDict(dict) 
    TaskPlayAnim(ped, "mp_heists@keypad@", "idle_a", 8.0, 8.0, -1, 0, 0, false, false, false)
    Wait(2500)
    TaskPlayAnim(ped, "mp_heists@keypad@", "exit", 2.0, 2.0, -1, 0, 0, false, false, false)
    Wait(1000)
    DoScreenFadeOut(250)
    Wait(250)
    SetEntityCoords(ped, Config.MethLab["enter"].coords.x, Config.MethLab["enter"].coords.y, Config.MethLab["enter"].coords.z - 0.98)
    SetEntityHeading(ped, Config.MethLab["enter"].coords.w)
    Methlab = false
    Wait(1000)
    DoScreenFadeIn(250)
end

RegisterNetEvent('DjonStNix-DrugProcessing:ProcessChemicals', function()
	local coords = GetEntityCoords(PlayerPedId(source))
	
	if #(coords-Config.CircleZones.MethProcessing.coords) < 5 then
		if not isProcessing then
			QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
				if result.ret then
					ProcessChemicals()
				else
					QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
				end
			end, {sulfuric_acid = Config.MethProcessing.SulfAcid, hydrochloric_acid = Config.MethProcessing.HydAcid, sodium_hydroxide = Config.MethProcessing.SodHyd})
		else
			QBCore.Functions.Notify(Lang:t("error.already_processing"), 'error')
		end
	end
end)

RegisterNetEvent('DjonStNix-DrugProcessing:ChangeTemp', function()
	if not isTempChangeU then
		QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
			if result.ret then
				Bridge.UI.Thermite(function(success)
					if success then
						QBCore.Functions.Notify(Lang:t("success.temp_up"), 'success')
						ProcessTempUp()
					else
						TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
						TriggerServerEvent('DjonStNix-DrugProcessing:processFailUp')
					end
				end, 10, 5, 3)
			else
				QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
			end
		end, {liquidmix = 1})
	else
		QBCore.Functions.Notify(Lang:t("error.enough_temp"), 'error')
	end
end)

RegisterNetEvent('DjonStNix-DrugProcessing:ChangeTemp2', function()
	if not isTempChangeD then
		QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
			if result.ret then
				Bridge.UI.Thermite(function(success)
					if success then
						QBCore.Functions.Notify(Lang:t("success.temp_down"), 'success')
						ProcessTempDown()
					else
						TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
						TriggerServerEvent('DjonStNix-DrugProcessing:processFailDown')
					end
				end, 10, 5, 3)
			else
				QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
			end
		end, {chemicalvapor = 1})
	else
		QBCore.Functions.Notify(Lang:t("error.enough_temp"), 'error')
	end
end)


RegisterNetEvent('DjonStNix-DrugProcessing:ProcessProduct', function()
	local coords = GetEntityCoords(PlayerPedId(source))
	
	if #(coords-Config.CircleZones.MethBag.coords) < 5 then
		if not isBagging then
			QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
				if result.ret then
					ProcessProduct()
				else
					QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
				end
			end, {methtray=1})
		else
			QBCore.Functions.Notify(Lang:t("error.already_processing"), 'error')
		end
	end
end)

RegisterNetEvent('DjonStNix-DrugProcessing:EnterLab', function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local dist = #(pos - vector3(Config.MethLab["enter"].coords.x, Config.MethLab["enter"].coords.y, Config.MethLab["enter"].coords.z))
	if dist < 2 then
		if not Methlab then
			if Config.KeyRequired then
				QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
					if result.ret then
						EnterMethlab()
					else
						QBCore.Functions.Notify(Lang:t("error.no_item", {item = result.item}))
					end
				end, { methkey = 1 } )
			else
				EnterMethlab()
			end
		end
	end
end)

RegisterNetEvent('DjonStNix-DrugProcessing:ExitLab', function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
    local dist = #(pos - vector3(Config.MethLab["exit"].coords.x, Config.MethLab["exit"].coords.y, Config.MethLab["exit"].coords.z))
    if dist < 2 then
		ExitMethlab()
	end
end)
