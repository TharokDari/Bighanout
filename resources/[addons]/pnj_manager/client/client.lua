local ESX = exports["es_extended"]:getSharedObject()
local pedestrianDensity = 1.0
local vehicleDensity = 1.0
local aggressivePNJ = false

-- Fonction pour régler la densité des PNJ
function setPNJDensity(pedestrian, vehicle)
    pedestrianDensity = pedestrian
    vehicleDensity = vehicle
    SetPedDensityMultiplierThisFrame(pedestrianDensity)
    SetScenarioPedDensityMultiplierThisFrame(pedestrianDensity, pedestrianDensity)
    SetRandomVehicleDensityMultiplierThisFrame(vehicleDensity)
    SetParkedVehicleDensityMultiplierThisFrame(vehicleDensity)
    SetVehicleDensityMultiplierThisFrame(vehicleDensity)
end

-- Fonction pour activer/désactiver les PNJ agressifs
function setPNJAggression(enabled)
    aggressivePNJ = enabled
    if aggressivePNJ then
        SetRelationshipBetweenGroups(5, GetHashKey("CIVMALE"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(5, GetHashKey("CIVFEMALE"), GetHashKey("PLAYER"))
    else
        SetRelationshipBetweenGroups(1, GetHashKey("CIVMALE"), GetHashKey("PLAYER"))
        SetRelationshipBetweenGroups(1, GetHashKey("CIVFEMALE"), GetHashKey("PLAYER"))
    end
end

-- Chargement des paramètres depuis la DB au démarrage
Citizen.CreateThread(function()
    ESX.TriggerServerCallback('pnj_manager:getSettings', function(pedestrian, vehicle, aggressive)
        setPNJDensity(pedestrian, vehicle)
        setPNJAggression(aggressive)
    end)
end)

-- Création du menu pour sélectionner le nombre de PNJ à pied et de véhicules
function openPNJMenu()
    local elements = {
        {label = "Densité des PNJ à pied : " .. math.floor(pedestrianDensity * 100) .. "%", type = 'slider', value = math.floor(pedestrianDensity * 10), min = 0, max = 10},
        {label = "Densité des véhicules : " .. math.floor(vehicleDensity * 100) .. "%", type = 'slider', value = math.floor(vehicleDensity * 10), min = 0, max = 10},
        {label = "PNJ Agressifs : " .. (aggressivePNJ and "Oui" or "Non"), value = "aggression"},
        {label = "Valider", value = "validate"}
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pnj_menu', {
        title = "Gestion des PNJ",
        align = 'bottom-right',  -- Positionnement du menu en bas à droite
        elements = elements
    }, function(data, menu)
        if data.current.type == 'slider' and data.current.label:find("PNJ à pied") then
            pedestrianDensity = data.current.value / 10
            setPNJDensity(pedestrianDensity, vehicleDensity)
        elseif data.current.type == 'slider' and data.current.label:find("véhicules") then
            vehicleDensity = data.current.value / 10
            setPNJDensity(pedestrianDensity, vehicleDensity)
        elseif data.current.value == 'aggression' then
            aggressivePNJ = not aggressivePNJ
            setPNJAggression(aggressivePNJ)
        elseif data.current.value == 'validate' then
            TriggerServerEvent('pnj_manager:saveSettings', pedestrianDensity, vehicleDensity, aggressivePNJ)
            ESX.ShowNotification("Paramètres des PNJ sauvegardés !")
            menu.close()  -- Fermer le menu après validation
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Commande pour ouvrir le menu
RegisterCommand('pnjmenu', function()
    openPNJMenu()
end, false)

-- Mise à jour régulière de la densité des PNJ et véhicules
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        setPNJDensity(pedestrianDensity, vehicleDensity)
    end
end)
