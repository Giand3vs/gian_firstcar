fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'GianD3vs'
description 'A first car script to recive a car when u join.'

client_script 'c/client.lua'
server_scripts { 's/server.lua', '@oxmysql/lib/MySQL.lua' }
shared_script 'shared.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
}

export '_main'