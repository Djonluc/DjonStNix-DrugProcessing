-- ==============================================================================
-- 👑 DJONSTNIX BRANDING
-- ==============================================================================
-- DEVELOPED BY: DjonStNix (DjonLuc)
-- GITHUB: https://github.com/Djonluc
-- DISCORD: https://discord.gg/s7GPUHWrS7
-- YOUTUBE: https://www.youtube.com/@Djonluc
-- EMAIL: djonstnix@gmail.com
-- LICENSE: MIT License (c) 2026 DjonStNix (DjonLuc)
-- ==============================================================================

fx_version 'cerulean'
game 'gta5'

author 'DjonStNix'
description 'DjonStNix Drug Processing — Modular, secure, and toxicity-integrated'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'locales/en.lua', -- Defaulting to en, can be changed in config
}

client_scripts {
    'client/main.lua',
    'client/target.lua',
    'client/dealers.lua',
    'client/pharmaceuticals.lua'
}

server_scripts {
    'server/main.lua',
    'server/maintenance.lua',
    'server/pharmaceuticals.lua',
    'server/breakdown.lua',
    'server/reputation.lua',
    'server/market.lua',
    'server/selling.lua'
}

lua54 'yes'

dependencies {
    'DjonStNix-Bridge',
    'ox_target',
    'ox_lib',
    'DjonStNix-Overdose'
}
