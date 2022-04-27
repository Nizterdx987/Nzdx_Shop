fx_version 'adamant'

game 'gta5'
author 'Nizterdx987#9220'
description 'Nzdx Shop'
version '1.0.0'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'server/*.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'client/*.lua'
}
