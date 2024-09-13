ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('collectMaterials')
AddEventHandler('collectMaterials', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getInventoryItem('usb_black').count >= 1 then
        -- Ajouter du métal et du plastique à l'inventaire du joueur
        xPlayer.addInventoryItem('metal', 1)
        xPlayer.addInventoryItem('plastic', 1)

        -- Notifier le joueur
        TriggerClientEvent('esx:showNotification', source, 'Vous avez ramassé du métal et du plastique.')
    else
        TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas de clé USB Black.")
    end
end)
