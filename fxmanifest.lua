fx_version 'cerulean'
game 'gta5'

version '1.0.0'
description 'Evidence system for ox_inventory'
use_fxv2_oal 'yes'
lua54        'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client.lua'
}