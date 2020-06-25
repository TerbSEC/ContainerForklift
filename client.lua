isAttached = false
canSleep = false

Citizen.CreateThread(function()
    AddTextEntry("press_attach_vehicle", "Press ~INPUT_DETONATE~ to pick up this container up")
    AddTextEntry("press_detach_vehicle", "Press ~INPUT_DETONATE~ to detach this container")
    while true do
        Citizen.Wait(10)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetEntityModel(veh) == `handler` then  -- Hash > Handler
                local pedCoords = GetEntityCoords(ped, 0)
                local objectId = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z+5.0, 5.0, GetHashKey("prop_contr_03b_ld"), false)
                if objectId ~= 0 then
                    if isAttached then

                        if IsEntityAttachedToHandlerFrame(veh, objectId) == false then
                            isAttached = false
                            Wait(2000)
                        end

                        DisplayHelpTextThisFrame("press_detach_vehicle")
                    else
                        if IsHandlerFrameAboveContainer(veh, objectId) == 1 then
                            DisplayHelpTextThisFrame("press_attach_vehicle")
                        end
                    end
                    
                    if IsControlJustPressed(0, 47) then
                        if isAttached ~= true and IsHandlerFrameAboveContainer(veh, objectId) == 1 then
                            N_0x6a98c2ecf57fa5d4(veh, objectId) -- // Attach Container to Handler Frame (Thx Indra :3)
                            isAttached = true
                        else
                            DetachContainerFromHandlerFrame(veh)
                            isAttached = false
                            Wait(2000)
                        end
                    end
                    canSleep = false
                else
                    if not isAttached then
                        canSleep = true
                    end
                end
            end
        end
        if canSleep then
            Citizen.Wait(2000)
        end
    end
end)

RegisterCommand('handler', function(source, args, rawCommand)
	local myPed = PlayerPedId()
	local vehicle = GetHashKey('Handler')

    RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, 64.55118,116.613,78.69622, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
end)