local QBCore = exports['qb-core']:GetCoreObject()
local inChemicalField = false
local SpawnedChemicals = 0
local Chemicals = {}

-- Chemical Menu Trigger & Menu Button Triggers --
local function createChemicalMenu()
    lib.registerContext({
        id = 'chem_menu',
        title = Lang:t("menu.chemMenuHeader"),
        options = {
            {
                title = Lang:t("items.hydrochloric_acid"),
                description = Lang:t("menu.chemicals"),
                event = "DjonStNix-DrugProcessing:hydrochloric_acid"
            },
            {
                title = Lang:t("items.sodium_hydroxide"),
                description = Lang:t("menu.chemicals"),
                event = "DjonStNix-DrugProcessing:sodium_hydroxide"
            },
            {
                title = Lang:t("items.sulfuric_acid"),
                description = Lang:t("menu.chemicals"),
                event = "DjonStNix-DrugProcessing:sulfuric_acid"
            },
            {
                title = Lang:t("items.lsa"),
                description = Lang:t("menu.chemicals"),
                event = "DjonStNix-DrugProcessing:lsa"
            }
        }
    })
    lib.showContext('chem_menu')
end
RegisterNetEvent('DjonStNix-DrugProcessing:chemicalmenu', createChemicalMenu)

--------------------------------------------------------------------
local function ValidatechemicalsCoord(plantCoord)
	local validate = true
	if SpawnedChemicals > 0 then
		for _, v in pairs(Chemicals) do
			if #(plantCoord-GetEntityCoords(v)) < 5 then
				validate = false
			end
		end
		if not inChemicalField then
			validate = false
		end
	end
	return validate
end

local function GetCoordZChemicals(x, y)
	local groundCheckHeights = { 1, 5.0, 10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0, 315.0, 320.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end

	return 5.9
end

local function GeneratechemicalsCoords()
	while inChemicalField do
		Wait(1)

		local chemicalsCoordX, chemicalsCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		chemicalsCoordX = Config.CircleZones.ChemicalsField.coords.x + modX
		chemicalsCoordY = Config.CircleZones.ChemicalsField.coords.y + modY

		local coordZ = GetCoordZChemicals(chemicalsCoordX, chemicalsCoordY)
		local coord = vector3(chemicalsCoordX, chemicalsCoordY, coordZ)

		if ValidatechemicalsCoord(coord) then
			return coord
		end
	end
end

local function SpawnChemicals()
	local model = `mw_chemical_barrel`
	while SpawnedChemicals < 10 do
		Wait(0)
		local chemicalsCoords = GeneratechemicalsCoords()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(100)
		end
		local obj = CreateObject(model, chemicalsCoords.x, chemicalsCoords.y, chemicalsCoords.z, false, true, false)
		PlaceObjectOnGroundProperly(obj)
		FreezeEntityPosition(obj, true)
		table.insert(Chemicals, obj)
		SpawnedChemicals += 1
	end
	SetModelAsNoLongerNeeded(model)
end

local function process_hydrochloric_acid()
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
		TriggerServerEvent('DjonStNix-DrugProcessing:processHydrochloric_acid')

		local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.ChemicalsConvertionMenu.coords) > 4 then
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

local function process_lsa()
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
		TriggerServerEvent('DjonStNix-DrugProcessing:process_lsa')

		local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.ChemicalsConvertionMenu.coords) > 4 then
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

local function process_sulfuric_acid()
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
		TriggerServerEvent('DjonStNix-DrugProcessing:processprocess_sulfuric_acid')

		local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.ChemicalsConvertionMenu.coords) > 4 then
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

local function process_sodium_hydroxide()
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
		TriggerServerEvent('DjonStNix-DrugProcessing:processsodium_hydroxide')

		local timeLeft = Config.Delays.thionylchlorideProcessing / 1000
		while timeLeft > 0 do
			Wait(1000)
			timeLeft -= 1
			if #(GetEntityCoords(playerPed)-Config.CircleZones.ChemicalsConvertionMenu.coords) > 4 then
				TriggerServerEvent('DjonStNix-DrugProcessing:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	else
		ClearPedTasks(PlayerPedId())
		isProcessing = false
	end
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for _, v in pairs(Chemicals) do
			SetEntityAsMissionEntity(v, false, true)
			DeleteObject(v)
		end
	end
end)

RegisterNetEvent("DjonStNix-DrugProcessing:hydrochloric_acid", function()
    QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
		if result then
			process_hydrochloric_acid()
		else
			QBCore.Functions.Notify(Lang:t("error.no_chemicals"), 'error')
		end
	end, {chemicals = 1})
end)

RegisterNetEvent("DjonStNix-DrugProcessing:lsa", function()
    QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
		if result then
			process_lsa()
		else
			QBCore.Functions.Notify(Lang:t("error.no_chemicals"), 'error')
		end
	end, {chemicals = 1})
end)

RegisterNetEvent("DjonStNix-DrugProcessing:sulfuric_acid", function()
    QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
		if result then
			process_sulfuric_acid()
		else
			QBCore.Functions.Notify(Lang:t("error.no_chemicals"), 'error')
		end
	end, {chemicals = 1})
end)

RegisterNetEvent("DjonStNix-DrugProcessing:sodium_hydroxide", function()
    QBCore.Functions.TriggerCallback('DjonStNix-DrugProcessing:validate_items', function(result)
		if result then
			process_sodium_hydroxide()
		else
			QBCore.Functions.Notify(Lang:t("error.no_chemicals"), 'error')
		end
	end, {chemicals=1})
end)

RegisterNetEvent("DjonStNix-DrugProcessing:pickChemicals", function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID

	for i=1, #Chemicals, 1 do
		if #(coords-GetEntityCoords(Chemicals[i])) < 2 then
			nearbyObject, nearbyID = Chemicals[i], i
		end
	end

	if nearbyObject and IsPedOnFoot(playerPed) then
		isPickingUp = true
		TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

		if lib.progressBar({
			duration = 10000,
			label = Lang:t("progressbar.pickup_chemicals"),
			useWhileDead = false,
			canCancel = true,
			disable = {
				car = true, move = true, combat = true, mouse = false
			}
		}) then
			ClearPedTasks(playerPed)
			SetEntityAsMissionEntity(nearbyObject, false, true)
			DeleteObject(nearbyObject)

			table.remove(Chemicals, nearbyID)
			SpawnedChemicals -= 1

			TriggerServerEvent('DjonStNix-DrugProcessing:pickedUpChemicals')
			isPickingUp = false
		else
			ClearPedTasks(playerPed)
			isPickingUp = false
		end
	end
end)

CreateThread(function()
	local chemZone = CircleZone:Create(Config.CircleZones.ChemicalsField.coords, 50.0, {
		name = "ps-chemzone",
		debugPoly = false
	})
	chemZone:onPlayerInOut(function(isPointInside, point, zone)
        if isPointInside then
            inChemicalField = true
            SpawnChemicals()
        else
            inChemicalField = false
        end
    end)
end)
