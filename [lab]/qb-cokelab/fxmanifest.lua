fx_version 'cerulean'
game 'gta5'

description 'QB-Methlab'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts { 
	'config.lua'
}

client_script 'client/main.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}


files {
	'*.json',
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/reset.css'
}
