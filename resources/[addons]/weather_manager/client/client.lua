local ESX = exports["es_extended"]:getSharedObject()
local currentWeather = 'CLEAR'
local currentHour = 12
local currentMinute = 0

-- Appliquer la météo et l'heure
function setWeatherAndTime(weatherType, hour, minute)
    currentWeather = weatherType
    currentHour = hour
    currentMinute = minute
    -- Changer la météo
    SetWeatherTypeOverTime(weatherType, 15.0)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNowPersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetOverrideWeather(weatherType)
    
    -- Changer l'heure
    NetworkOverrideClockTime(hour, minute, 0)
end

-- Charger les paramètres depuis la DB au démarrage
Citizen.CreateThread(function()
    ESX.TriggerServerCallback('weather_manager:getSettings', function(weatherType, hour, minute)
        setWeatherAndTime(weatherType, hour, minute)
    end)
end)

-- Synchronisation des paramètres météo et heure depuis le serveur
RegisterNetEvent('weather_manager:syncWeatherAndTime')
AddEventHandler('weather_manager:syncWeatherAndTime', function(weatherType, hour, minute)
    setWeatherAndTime(weatherType, hour, minute)
end)

-- Création du menu pour changer la météo et l'heure
function openWeatherMenu()
    local elements = {
        {label = "Type de Météo : " .. currentWeather, value = "weather", type = "select", options = {
            {label = "Clair", value = "CLEAR"},
            {label = "Pluie", value = "RAIN"},
            {label = "Neige", value = "XMAS"},
            {label = "Orage", value = "THUNDER"},
            {label = "Nuit", value = "EXTRASUNNY"},
            {label = "Nuageux", value = "CLOUDS"},
        }},
        {label = "Heure : " .. currentHour, value = "hour", type = "slider", min = 0, max = 23},
        {label = "Minute : " .. currentMinute, value = "minute", type = "slider", min = 0, max = 59},
        {label = "Valider", value = "validate"}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weather_menu', {
        title = "Gestion du Temps et de la Météo",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == "weather" then
            currentWeather = data.current.options[data.current.index].value
            setWeatherAndTime(currentWeather, currentHour, currentMinute)
        elseif data.current.value == "hour" then
            currentHour = data.current.value
            setWeatherAndTime(currentWeather, currentHour, currentMinute)
        elseif data.current.value == "minute" then
            currentMinute = data.current.value
            setWeatherAndTime(currentWeather, currentHour, currentMinute)
        elseif data.current.value == "validate" then
            TriggerServerEvent('weather_manager:saveSettings', currentWeather, currentHour, currentMinute)
            ESX.ShowNotification("Paramètres du temps et de la météo sauvegardés !")
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)
end

-- Commande pour ouvrir le menu
RegisterCommand('weathermenu', function()
    openWeatherMenu()
end, false)
