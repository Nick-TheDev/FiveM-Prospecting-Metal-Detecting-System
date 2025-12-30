
fx_version "adamant"
game 'gta5'
author 'Nick12024'
description 'A FiveM script built with Ox Lib to manage private and other lobby types in an easy and clean way'
github 'https://github.com/Nick-TheDev'
version '1.0'
lua54 'yes'


shared_scripts {
    '@ox_lib/init.lua',
    'prospecting_cfg.lua'
}

client_scripts {
    'prospecting_cl.lua',
}
server_scripts {
    'prospecting_sv.lua'
}
data_file 'DLC_ITYP_REQUEST' 'stream/gen_w_am_metaldetector.ytyp'
