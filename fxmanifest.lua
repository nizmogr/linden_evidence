fx_version 'cerulean'
game 'gta5'

version '1.0.0'
description 'Evidence system for hsn-inventory'

shared_script 'config.lua'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client.lua'
}