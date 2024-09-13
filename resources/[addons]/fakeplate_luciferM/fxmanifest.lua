fx_version 'cerulean'
game 'gta5'

lua54 'yes' -- Activation de Lua 5.4

description 'Système de fabrication et collecte pour plaques fausses'

shared_script '@es_extended/imports.lua'

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'es_extended',
    'ox_inventory',
    'ox_lib'
}
