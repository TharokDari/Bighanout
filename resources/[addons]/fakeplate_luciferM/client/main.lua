ESX = exports['es_extended']:getSharedObject()

-- Interaction pour collecter du métal et du plastique
local metalCollectionZone = vector3(305.578, 354.504, 105.392)
local collectionRadius = 1.5 -- Rayon pour activer la collecte

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        if #(coords - metalCollectionZone) < collectionRadius then
            ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour collecter des matériaux.')
            if IsControlJustReleased(0, 38) then -- "E" pour interagir
                if ESX.GetPlayerData().inventory['usb_black'] then
                    TriggerServerEvent('collectMaterials')
                else
                    ESX.ShowNotification("Vous avez besoin d'une clé USB Black pour collecter des matériaux.")
                end
            end
        end
    end
end)
