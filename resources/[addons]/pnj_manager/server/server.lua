local ESX = exports["es_extended"]:getSharedObject()

-- Fonction pour charger les paramètres de la DB
function loadPNJSettings(cb)
    exports.oxmysql:execute('SELECT * FROM pnj_settings LIMIT 1', {}, function(result)
        if result[1] then
            cb(result[1].pedestrian_density, result[1].vehicle_density, result[1].aggressive)
        else
            -- Si aucune donnée trouvée, créer une entrée par défaut
            exports.oxmysql:execute('INSERT INTO pnj_settings (pedestrian_density, vehicle_density, aggressive) VALUES (@pedestrian, @vehicle, @aggressive)', {
                ['@pedestrian'] = 1.0,
                ['@vehicle'] = 1.0,
                ['@aggressive'] = false
            }, function()
                cb(1.0, 1.0, false)
            end)
        end
    end)
end

-- Fonction pour sauvegarder les paramètres dans la DB
function savePNJSettings(pedestrianDensity, vehicleDensity, aggressive)
    exports.oxmysql:execute('UPDATE pnj_settings SET pedestrian_density = @pedestrian, vehicle_density = @vehicle, aggressive = @aggressive WHERE id = 1', {
        ['@pedestrian'] = pedestrianDensity,
        ['@vehicle'] = vehicleDensity,
        ['@aggressive'] = aggressive
    })
end

RegisterNetEvent('pnj_manager:saveSettings')
AddEventHandler('pnj_manager:saveSettings', function(pedestrianDensity, vehicleDensity, aggressive)
    savePNJSettings(pedestrianDensity, vehicleDensity, aggressive)
end)

ESX.RegisterServerCallback('pnj_manager:getSettings', function(source, cb)
    loadPNJSettings(cb)
end)
