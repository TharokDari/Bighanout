fx_version 'cerulean'
game 'gta5'

author 'LuciferM'
description 'Gestion dynamique de la météo et de l’heure avec persistance dans oxmysql'
version '1.0.0'

lua54 'yes'

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'oxmysql',
    'es_extended'
}
