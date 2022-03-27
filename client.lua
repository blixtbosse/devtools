RegisterCommand("coords", function(source, args)		
	local playerPed = PlayerPedId()

	local types = {
		coords = GetEntityCoords(playerPed),
		heading = GetEntityHeading(playerPed),
		rotation = GetEntityRotation(playerPed),

		vector4 = vector4(GetEntityCoords(playerPed).x, GetEntityCoords(playerPed).y, GetEntityCoords(playerPed).z, GetEntityHeading(playerPed)),
	
		camrot = GetGameplayCamRot(2),
		camcoord = GetGameplayCamCoord(),
		camfov = GetGameplayCamFov(),

		vehiclecoords = IsPedInAnyVehicle(playerPed, false) and GetEntityCoords(GetVehiclePedIsIn(playerPed, false)) or nil,
		vehicleheading = IsPedInAnyVehicle(playerPed, false) and GetEntityHeading(GetVehiclePedIsIn(playerPed, false)) or nil,
		vehiclerot = IsPedInAnyVehicle(playerPed, false) and GetEntityRotation(GetVehiclePedIsIn(playerPed, false)) or nil
	}
		
	if not args[1] or (type(args[1]) ~= 'string') or not types[args[1]] then return end

	SendNUIMessage({
		coords = tostring(types[args[1]])
	})
end)

exports('Copy', function(text)
	if not text or (type(text) ~= 'string') then return end

	SendNUIMessage({
		coords = text
	})
end)
