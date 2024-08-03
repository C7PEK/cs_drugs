ESX = exports["es_extended"]:getSharedObject()

local markers = {
    
    -- Zbieranie
    
    {displayName = "Weed", itemName = "weed", pos = vector3(1705.85, 3266.55, 41.15), radius = 1.5, color = {2, 117, 0}, collectSpeed = 5000, collectAmount = {min = 1, max = 5}, type = "collect", enabled = true},
    {displayName = "Kokaina", itemName = "coke", pos = vector3(1706.84, 3261.06, 41.15), radius = 1.5, color = {255, 255, 255}, collectSpeed = 3000, collectAmount = {min = 2, max = 6}, type = "collect", enabled = true},
    {displayName = "Opium", itemName = "opium", pos = vector3(1708.11, 3256.33, 41.15), radius = 1.5, color = {255, 111, 0}, collectSpeed = 3000, collectAmount = {min = 2, max = 6}, type = "collect", enabled = true},
    
    -- Przeróbka
    
    {displayName = "Weed", itemName = "weed_pouch", sourceItem = "weed", pos = vector3(1697.62, 3264.25, 41.15), radius = 1.5, color = {2, 117, 0}, processSpeed = 1000, processAmount = {min = 1, max = 3}, type = "process", enabled = true},
    {displayName = "Kokainę", itemName = "coke_pouch", sourceItem = "coke", pos = vector3(1699.67, 3258.85, 41.15), radius = 1.5, color = {255, 255, 255}, processSpeed = 1000, processAmount = {min = 1, max = 3}, type = "process", enabled = true},
    {displayName = "Opium", itemName = "opium_pouch", sourceItem = "opium", pos = vector3(1701.44, 3254.46, 41.15), radius = 1.5, color = {255, 111, 0}, processSpeed = 1000, processAmount = {min = 1, max = 3}, type = "process", enabled = true}
}

local pedy = {
    {model = 'g_m_m_chigoon_02', coords = vector3(1691.41, 3262.48, 40.89-1), heading = 290.0, name = 'Ped1'},
    {model = 'g_m_y_famca_01', coords = vector3(1692.33, 3257.02, 40.89-1), heading = 290.0, name = 'Ped2'},
    {model = 'g_m_y_salvaboss_01', coords = vector3(1694.16, 3251.84, 40.89-1), heading = 290.0, name = 'Ped3'}
}

local Sellzone = {
    {coords = vector3(1691.41, 3262.48, 41.89), radius = 2.0, options = {{name = "weedsell", icon = "fas fa-dollar-sign", label = "Sprzedaj Weed", event ='cs_drugs:pedweedsell'}}},
    {coords = vector3(1692.33, 3257.02, 41.89), radius = 2.0, options = {{name = "cokesell", icon = "fas fa-dollar-sign", label = "Sprzedaj Kokainę", event ='cs_drugs:pedcokesell'}}},
    {coords = vector3(1694.16, 3251.84, 41.89), radius = 2.0, options = {{name = "opiumsell", icon = "fas fa-dollar-sign", label = "Sprzedaj Opium", event ='cs_drugs:pedopiumsell'}}}

    -- PAMIĘTAJ ABY ZMIENIĆ EVENT KTORY UŻYWA POSZCZEGÓLNY PED!!!!!!!
}

RegisterNetEvent('getMarkers')
AddEventHandler('getMarkers', function()
    TriggerClientEvent('sendMarkers', source, markers)
end)

RegisterNetEvent('getPedy')
AddEventHandler('getPedy', function()
    TriggerClientEvent('sendPedy', source, pedy)
end)

RegisterNetEvent('getSellzone')
AddEventHandler('getSellzone', function()
    TriggerClientEvent('sendSellzone', source, Sellzone)
end)

--------------------
-- Zbiórka Dragów --
--------------------

RegisterServerEvent('cypek:zbierz')
AddEventHandler('cypek:zbierz', function(itemName, minAmount, maxAmount)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local item = xPlayer.getInventoryItem(itemName)

        if item.count >= 100 then

            TriggerClientEvent('ox_lib:notify', source, {title= 'Uwaga!', description ='Nie możesz więcej zbierać', position = 'center-left', type ='error'})

        else

            local amount = math.random(minAmount, maxAmount)
            xPlayer.addInventoryItem(itemName, amount)

        end
    end
end)

----------------------
-- Przeróbka Dragów --
----------------------

RegisterServerEvent('cypek:przerob')
AddEventHandler('cypek:przerob', function(sourceItem, processedItem, minAmount, maxAmount)

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local item = xPlayer.getInventoryItem(sourceItem)

        if item.count < minAmount then
            
            TriggerClientEvent('ox_lib:notify', source, {title= 'Uwaga!', description ='Nie masz wystarczającej ilości przedmiotów do przeróbki', position = 'center-left', type ='error'})

        else

            local amount = math.random(minAmount, maxAmount)
            xPlayer.removeInventoryItem(sourceItem, amount)
            xPlayer.addInventoryItem(processedItem, amount)

        end
    end
end)

-------------------
-- Sprzedaz Weed --
-------------------

RegisterServerEvent('cs_drugs:weedsell')
AddEventHandler('cs_drugs:weedsell', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem('weed_pouch') -- item co sprzedajesz
    local itemCount = xPlayer.getInventoryItem('weed_pouch').count
    local losowailosc = math.random(15, 25) -- min,max cena sprzedazy

    if item.count < 1 then 

        TriggerClientEvent('ox_lib:notify', source, {title= 'Informacja', description ='Nie masz nic do sprzedania!', position = 'center-left',type ='info'})

    else
        xPlayer.removeInventoryItem('weed_pouch', itemCount)
        xPlayer.addInventoryItem('money', losowailosc * itemCount)
    end
end)

----------------------
-- Sprzedaz Kokaina --
----------------------

RegisterServerEvent('cs_drugs:cokesell')
AddEventHandler('cs_drugs:cokesell', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem('coke_pouch') -- item co sprzedajesz
    local itemCount = xPlayer.getInventoryItem('coke_pouch').count
    local losowailosc = math.random(15, 25) -- min,max cena sprzedazy

    if item.count < 1 then 

        TriggerClientEvent('ox_lib:notify', source, {title= 'Informacja', description ='Nie masz nic do sprzedania!', position = 'center-left',type ='info'})

    else
        xPlayer.removeInventoryItem('coke_pouch', itemCount)
        xPlayer.addInventoryItem('money', losowailosc * itemCount)
    end
end)

--------------------
-- Sprzedaz Opium --
--------------------

RegisterServerEvent('cs_drugs:opiumsell')
AddEventHandler('cs_drugs:opiumsell', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem('opium_pouch') -- item co sprzedajesz
    local itemCount = xPlayer.getInventoryItem('opium_pouch').count
    local losowailosc = math.random(15, 25) -- min,max cena sprzedazy

    if item.count < 1 then 

        TriggerClientEvent('ox_lib:notify', source, {title= 'Informacja', description ='Nie masz nic do sprzedania!', position = 'center-left',type ='info'})

    else
        xPlayer.removeInventoryItem('opium_pouch', itemCount)
        xPlayer.addInventoryItem('money', losowailosc * itemCount)
    end
end)

-------------------------------------------------------------------------------------------------------------
-- ABY DODAĆ KOLEJNĄ SPRZEDARZ NARKO SKOPIUJ EVENT POWYŻEJ I POZMIENIAJ NAZWY Z OPIUM NP. NA FENTALNYL!!!! --
-------------------------------------------------------------------------------------------------------------