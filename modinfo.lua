-- modinfo.lua

name = "Golden Hammer - 100% Loot Recovery"

description = [[
Tired of losing half of your precious resources when deconstructing structures? The Golden Hammer is the ultimate tool for architects and survivors who refuse to waste a single twig!

Unlike the standard hammer, which only returns 50% of materials, this luxury tool ensures that 100% of the resources drop back to your inventory or the ground. It is the perfect tool for those who love to reorganize their base without paying the "resource tax" of the Constant.
]]

author = "Roberto Fernandes"
version = "1.0.4"

icon_atlas = "modicon.xml"
icon = "modicon.tex"

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