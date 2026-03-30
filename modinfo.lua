-- modinfo.lua

name = "Golden Hammer"

description = [[
A powerful golden hammer that guarantees 100% loot drops.

Tired of losing resources when hammering structures?
With the Golden Hammer, everything drops — no more 50% loss.

Perfect for builders and perfectionists.
]]

author = "Roberto Fernandes"
version = "1.0.0"

icon_atlas = "goldenhammer.xml"
icon = "goldenhammer.tex"


-- Compatibilidade
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
hamlet_compatible = false

-- API
api_version = 10
api_version_dst = 10

-- Configuração de mod
all_clients_require_mod = true
client_only_mod = false

-- Tags (ajuda no workshop)
server_filter_tags = {
    "items",
    "tools",
    "gameplay",
    "build"
}

-- Prioridade
priority = 0

-- Fórum
forumthread = ""

-- Configurações
configuration_options = {
    {
        name = "loot_multiplier",
        label = "Loot Drop Multiplier",
        options = {
            { description = "100% (Default)", data = 1.0 },
            { description = "150%", data = 1.5 },
            { description = "200%", data = 2.0 },
        },
        default = 1.0,
    }
}