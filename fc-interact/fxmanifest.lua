fx_version 'cerulean'
game 'gta5'
author 'piotreq discord.gg/piotreqscripts'
description '5City 4.0 Interactions Inspired'
lua54 'yes'

client_scripts {
    'client/*.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}