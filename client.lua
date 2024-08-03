ESX = exports["es_extended"]:getSharedObject()

local markers = {}
local pedy = {}
local Sellzone = {}

Citizen.CreateThread(function()
    TriggerServerEvent('getMarkers')
    TriggerServerEvent('getPedy')
    TriggerServerEvent('getSellzone')
end)

RegisterNetEvent('sendMarkers')
AddEventHandler('sendMarkers', function(data)
    markers = data
    initializeMarkers()
end)

RegisterNetEvent('sendPedy')
AddEventHandler('sendPedy', function(data)
    pedy = data
    spawnPedy()
end)

RegisterNetEvent('sendSellzone')
AddEventHandler('sendSellzone', function(data)
    Sellzone = data
    initializeSellzone()
end)

function initializeMarkers()
    local jestwMarkerZbieranie = nil
    local loop = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local nearestMarker = nil
            local nearestDistance = math.huge

            for _, marker in ipairs(markers) do
                if marker.enabled then
                    DrawMarker(1, marker.pos.x, marker.pos.y, marker.pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, marker.radius * 2, marker.radius * 2, 1.0, marker.color[1], marker.color[2], marker.color[3], 100, false, true, 2, nil, nil, false)

                    local distance = #(playerCoords - marker.pos)

                    if distance < marker.radius and distance < nearestDistance then
                        nearestMarker = marker
                        nearestDistance = distance
                    end
                end
            end

            if nearestMarker and not jestwMarkerZbieranie then
                if nearestMarker.type == "collect" then

                    lib.showTextUI('[E] - Aby zbierać ' .. nearestMarker.displayName)

                elseif nearestMarker.type == "process" then

                    lib.showTextUI('[E] - Aby przerobić ' .. nearestMarker.displayName)

                end
                jestwMarkerZbieranie = nearestMarker
            elseif not nearestMarker and jestwMarkerZbieranie then

                lib.hideTextUI()

                jestwMarkerZbieranie = nil
                loop = false
            end

            if IsControlJustReleased(0, 38) and jestwMarkerZbieranie then

                lib.hideTextUI()

                if not loop then
                    loop = true
                    Citizen.CreateThread(function()
                        while loop do
                            if jestwMarkerZbieranie.type == "collect" then
                                Citizen.Wait(jestwMarkerZbieranie.collectSpeed)
                                if jestwMarkerZbieranie then
                                    TriggerServerEvent('cypek:zbierz', jestwMarkerZbieranie.itemName, jestwMarkerZbieranie.collectAmount.min, jestwMarkerZbieranie.collectAmount.max)
                                end
                            elseif jestwMarkerZbieranie.type == "process" then
                                Citizen.Wait(jestwMarkerZbieranie.processSpeed)
                                if jestwMarkerZbieranie then 
                                    TriggerServerEvent('cypek:przerob', jestwMarkerZbieranie.sourceItem, jestwMarkerZbieranie.itemName, jestwMarkerZbieranie.processAmount.min, jestwMarkerZbieranie.processAmount.max)
                                end
                            end
                        end
                    end)
                else
                    loop = false
                end
            end
        end
    end)
end

function initializeSellzone()
    for _, sellzone in ipairs(Sellzone) do
        exports.ox_target:addSphereZone({
            coords = sellzone.coords,
            radius = sellzone.radius,
            debug = false,
            options = sellzone.options
        })
    end
end

function spawnPedy()
    Citizen.CreateThread(function()
        for _, pedConfig in ipairs(pedy) do
            CreatePedFromConfig(pedConfig)
        end
    end)
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(500)
    end
end

function CreatePedFromConfig(config)
    LoadModel(config.model)
    local ped = CreatePed(4, config.model, config.coords, config.heading, false, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_DRUG_DEALER_HARD', 0, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end


----------
-- Pedy --
----------

RegisterNetEvent('cs_drugs:pedweedsell')
AddEventHandler('cs_drugs:pedweedsell', function()
    if lib.progressCircle({
        duration = 5000,
        label = 'Sprzedaz Weedu...',
        useWhileDead = false,
        canCancel = false,
        position = 'bottom',
        disable = {
            car = true,
            move = true,
        },
        anim = {
            scenario = 'PROP_HUMAN_STAND_IMPATIENT'
        }
    }) then 
        TriggerServerEvent('cs_drugs:weedsell')
    end
end)

RegisterNetEvent('cs_drugs:pedcokesell')
AddEventHandler('cs_drugs:pedcokesell', function()
    if lib.progressCircle({
        duration = 5000,
        label = 'Sprzedaz Kokainy...',
        useWhileDead = false,
        canCancel = false,
        position = 'bottom',
        disable = {
            car = true,
            move = true,
        },
        anim = {
            scenario = 'PROP_HUMAN_STAND_IMPATIENT'
        }
    }) then 
        TriggerServerEvent('cs_drugs:cokesell')
    end
end)

RegisterNetEvent('cs_drugs:pedopiumsell')
AddEventHandler('cs_drugs:pedopiumsell', function()
    if lib.progressCircle({
        duration = 5000,
        label = 'Sprzedaz Opium...',
        useWhileDead = false,
        canCancel = false,
        position = 'bottom',
        disable = {
            car = true,
            move = true,
        },
        anim = {
            scenario = 'PROP_HUMAN_STAND_IMPATIENT'
        }
    }) then 
        TriggerServerEvent('cs_drugs:opiumsell')
    end
end)

----------------------------------------------------------------------------------------------------
-- ABY DODAĆ KOLEJNEGO PEDA SKOPIUJ EVENT POWYŻEJ I POZMIENIAJ NAZWY Z OPIUM NP. NA FENTALNYL!!!! --
----------------------------------------------------------------------------------------------------