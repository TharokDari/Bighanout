local ESX = exports["es_extended"]:getSharedObject()

-- Fonction pour charger les paramètres de la DB
function loadWeatherSettings(cb)
    exports.oxmysql:execute('SELECT * FROM weather_settings LIMIT 1', {}, function(result)
        if result[1] then
            cb(result[1].weather_type, result[1].hour, result[1].minute)
        else
            -- Si aucune donnée trouvée, créer une entrée par défaut
            exports.oxmysql:execute('INSERT INTO weather_settings (weather_type, hour, minute) VALUES (@weather_type, @hour, @minute)', {
                ['@weather_type'] = 'CLEAR',
                ['@hour'] = 12,
                ['@minute'] = 0
            }, function()
                cb('CLEAR', 12, 0)
            end)
        end
    end)
end

-- Fonction pour sauvegarder les paramètres dans la DB
function saveWeatherSettings(weatherType, hour, minute)
    exports.oxmysql:execute('UPDATE weather_settings SET weather_type = @weather_type, hour = @hour, minute = @minute WHERE id = 1', {
        ['@weather_type'] = weatherType,
        ['@hour'] = hour,
        ['@minute'] = minute
    })
end

RegisterNetEvent('weather_manager:saveSettings')
AddEventHandler('weather_manager:saveSettings', function(weatherType, hour, minute)
    saveWeatherSettings(weatherType, hour, minute)
end)

ESX.RegisterServerCallback('weather_manager:getSettings', function(source, cb)
    loadWeatherSettings(cb)
end)

-- Synchroniser la météo et l'heure pour tous les joueurs
function syncWeatherAndTime(weatherType, hour, minute)
    TriggerClientEvent('weather_manager:syncWeatherAndTime', -1, weatherType, hour, minute)
end

-- Charger et appliquer les paramètres au démarrage du serveur
Citizen.CreateThread(function()
    loadWeatherSettings(function(weatherType, hour, minute)
        syncWeatherAndTime(weatherType, hour, minute)
    end)
end)
