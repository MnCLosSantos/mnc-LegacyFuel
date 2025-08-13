local QBCore = exports['qb-core']:GetCoreObject()
local isNearPump = nil
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local todaycost = 0
local currentCash = 0
local fuelSynced = false
local inBlacklisted = false

-- UI Management Functions
local function ShowFuelUI(usingJerryCan, jerryCanLevel)
    SetNuiFocus(false, false) -- We don't need mouse focus for this UI
    SendNUIMessage({
        action = "showFuelUI",
        fuelLevel = currentFuel,
        currentCost = currentCost,
        totalCost = todaycost,
        usingJerryCan = usingJerryCan or false,
        jerryCanLevel = jerryCanLevel or 0
    })
end

local function HideFuelUI()
    SendNUIMessage({
        action = "hideFuelUI"
    })
end

local function UpdateFuelUI(usingJerryCan, jerryCanLevel)
    SendNUIMessage({
        action = "updateFuelUI",
        fuelLevel = currentFuel,
        currentCost = currentCost,
        totalCost = todaycost,
        usingJerryCan = usingJerryCan or false,
        jerryCanLevel = jerryCanLevel or 0
    })
end

-- NUI Callback for closing UI
RegisterNUICallback('closeFuelUI', function(data, cb)
    if isFueling then
        isFueling = false
    end
    cb('ok')
end)

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, Config.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

CreateThread(function()
	DecorRegister(Config.FuelDecor, 1)

	for index = 1, #Config.Blacklist do
		if type(Config.Blacklist[index]) == 'string' then
			Config.Blacklist[GetHashKey(Config.Blacklist[index])] = true
		else
			Config.Blacklist[Config.Blacklist[index]] = true
		end
	end

	for index = #Config.Blacklist, 1, -1 do
		table.remove(Config.Blacklist, index)
	end

	while true do
		Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped, false)

			if Config.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject
			currentCash = QBCore.Functions.GetPlayerData().money['cash']
		else
			isNearPump = nil

			Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

local extraCost = math.random(3, 6)

AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)

	while isFueling do
		-- Use different settings based on refuel method
		local refuelSettings
		if pumpObject then
			-- Using pump
			refuelSettings = Config.RefuelSettings.PumpRefuel or Config.RefuelSettings
		else
			-- Using jerry can
			refuelSettings = Config.RefuelSettings.JerryCanRefuel or Config.RefuelSettings
		end

		Wait(refuelSettings.UpdateInterval or Config.RefuelSettings.UpdateInterval)

		local oldFuel = DecorGetFloat(vehicle, Config.FuelDecor)
		local fuelToAdd = math.random(
			refuelSettings.FuelPerTick.Min or Config.RefuelSettings.FuelPerTick.Min,
			refuelSettings.FuelPerTick.Max or Config.RefuelSettings.FuelPerTick.Max
		) / 10.0
		local jerryCanLevel = 0
		local usingJerryCan = false

		if not pumpObject then
			-- Using jerry can
			usingJerryCan = true
			jerryCanLevel = GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100
			
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd
				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
				jerryCanLevel = GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100 -- Update after use
			else
				isFueling = false
			end
		else
			-- Using pump
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

 		if extraCost >= 1 then
			currentCost = currentCost + extraCost
			todaycost = extraCost
			if currentCash >= currentCost then
				SetFuel(vehicle, currentFuel)
			else
				isFueling = false
			end
		end

		-- Update UI instead of drawing text
		UpdateFuelUI(usingJerryCan, jerryCanLevel)
	end

	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end

	-- Hide UI when done
	HideFuelUI()
	currentCost = 0.0
end)

AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, false, false, false)

	-- Show UI at start of fueling
	local usingJerryCan = not pumpObject
	local jerryCanLevel = 0
	if usingJerryCan then
		jerryCanLevel = GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100
	end
	ShowFuelUI(usingJerryCan, jerryCanLevel)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		for _, controlIndex in pairs(Config.DisableKeys) do
			DisableControlAction(0, controlIndex, true)
		end

		-- We no longer need DrawText3Ds calls here since we have UI
		-- But we keep the animation check
		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, false, false, false)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or (isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end

		Wait(0)
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if not isFueling and ((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)

				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, Config.Strings.ExitVehicle)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)

				if DoesEntityExist(vehicle) and #(GetEntityCoords(ped) - vehicleCoords) < 2.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if currentCash > 0 then
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.EToRefuel)

								if IsControlJustReleased(0, 38) then
									isFueling = true

									TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.JerryCanEmpty)
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.FullTank)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)

					if currentCash >= Config.JerryCanCost then
						if not HasPedGotWeapon(ped, 883325847, false) then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.PurchaseJerryCan)

							if IsControlJustReleased(0, 38) then
								TriggerServerEvent('fuel:addPetrolCan')
								TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["weapon_petrolcan"], "add")
								TriggerServerEvent('fuel:pay', Config.JerryCanCost)
							end
						else
							local refillCost = Round(Config.RefillCost * (1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

							if refillCost > 0 then
								if currentCash >= refillCost then
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.RefillJerryCan .. refillCost)

									if IsControlJustReleased(0, 38) then
										TriggerServerEvent('fuel:pay', refillCost)

										SetPedAmmo(ped, 883325847, 4500)
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCashJerryCan)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.JerryCanFull)
							end
						end
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, Config.Strings.NotEnoughCash)
					end
				else
					Wait(250)
				end
			end
		else
			Wait(250)
		end

		Wait(0)
	end
end)

if Config.ShowNearestGasStationOnly then
	CreateThread(function()
		local currentGasBlip = 0

		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords

			for _, gasStationCoords in pairs(Config.GasStations) do
				local dstcheck = #(coords - gasStationCoords)

				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
				end
			end

			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end

			if closestCoords then currentGasBlip = CreateBlip(closestCoords) end

			Wait(10000)
		end
	end)
elseif Config.ShowAllGasStations then
	CreateThread(function()
		for _, gasStationCoords in pairs(Config.GasStations) do
			CreateBlip(gasStationCoords)
		end
	end)
end