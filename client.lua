Devtools = {
	State = false
}

Citizen.CreateThread(function()
	Citizen.Wait(150)

	while not NetworkIsSessionStarted() do
		Citizen.Wait(150)
	end

	while true do
		local player = PlayerId()
		local playerPed = PlayerPedId()

		if Devtools.State then
			if IsPlayerFreeAiming(player) then

				if IsPedShooting(playerPed) then
					local hit, coords = GetPedLastWeaponImpactCoord(playerPed)
	
					if hit and (coords ~= nil) then
						Devtools:copy(tostring(coords))
					end
				end
			
				if not IsPedShooting(playerPed) then
					local hit, entity = GetEntityPlayerIsFreeAimingAt(player)

					if hit and DoesEntityExist(entity) then
						local entityCoords = GetEntityCoords(entity)
						local entityRotation = GetEntityRotation(entity)
	
						local entityHeading = GetEntityHeading(entity)
						local entityModel = GetEntityModel(entity)

						Devtools:copy(json.encode({
							hash = entityModel,
							coords = ('vector3(%s, %s, %s)'):format(entityCoords.x, entityCoords.y, entityCoords.z),
							rotation = ('vector3(%s, %s, %s)'):format(entityRotation.x, entityRotation.y, entityRotation.z),
							heading = entityHeading,
							vehicle = IsModelAVehicle(entityModel) and GetLabelText(GetDisplayNameFromVehicleModel(entityModel)):lower() or ''
						}, { indent = true }))
					end
				end
			end
		end

		Citizen.Wait(Devtools.State and 1 or 500)
	end
end)

function Devtools:getType(option)
	local playerPed = PlayerPedId()

	if not DoesEntityExist(playerPed) then return end

	local types = {
		coords = GetEntityCoords(playerPed),
		heading = GetEntityHeading(playerPed),
		rotation = GetEntityRotation(playerPed),

		vector4 = vector4(GetEntityCoords(playerPed), GetEntityHeading(playerPed)),
	
		camrot = GetGameplayCamRot(2),
		camcoord = GetGameplayCamCoord(),
		camfov = GetGameplayCamFov(),

		vehiclecoords = IsPedInAnyVehicle(playerPed, false) and GetEntityCoords(GetVehiclePedIsIn(playerPed, false)) or nil,
		vehicleheading = IsPedInAnyVehicle(playerPed, false) and GetEntityHeading(GetVehiclePedIsIn(playerPed, false)) or nil,
		vehiclerot = IsPedInAnyVehicle(playerPed, false) and GetEntityRotation(GetVehiclePedIsIn(playerPed, false)) or nil
	}

	if (types[option] == nil) then return end

	return types[option]
end

function Devtools:copy(text)
    if not text or (type(text) ~= 'string') then return end

    SendNUIMessage({
		text = text
    })
end

RegisterCommand('devtools', function()
	Devtools.State = not Devtools.State

	print(Devtools.State and 'Devtools är nu aktivt, sikta på en entity för att få information' or 'Devtools är nu avstängt')
end)

RegisterCommand("coords", function(source, args)		
	if not args[1] or (type(args[1]) ~= 'string') then return end
	
	local option = Devtools:getType(args[1])

    Devtools:copy(tostring(option))
end)

exports('Copy', function(...)
	Devtools:copy(...)
end)
