local themenum = tonumber(os.getenv("THEMENUM"))
if themenum == 1 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight]]
    require("notify")("tokyonight")
elseif themenum == 2 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight-night]]
    require("notify")("tokyonight-night")
elseif themenum == 3 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight-moon]]
    require("notify")("tokyonight-moon")
elseif themenum == 4 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight-storm]]
    require("notify")("tokyonight-storm")
elseif themenum == 5 then
    require('catpuccin').setup({})
    vim.cmd [[colorscheme catpuccin-latte]]
    require("notify")("catpuccin-latte")
elseif themenum == 6 then
    require('catpuccin').setup({})
    vim.cmd [[colorscheme catpuccin-frappe]]
    require("notify")("catpuccin-frappe")
elseif themenum == 7 then
    require('catpuccin').setup({})
    vim.cmd [[colorscheme catpuccin-macchiato]]
    require("notify")("catpuccin-macchiato")
elseif themenum == 8 then
    require('catpuccin').setup({})
    vim.cmd [[colorscheme catpuccin-mocha]]
    require("notify")("catpuccin-mocha")
elseif themenum == 9 then
    require('gruvbox').setup({})
    vim.cmd [[colorscheme gruvbox]]
    require("notify")("gruvbox")
elseif themenum == 10 then
    vim.cmd [[colorscheme gruvbox-material]]
    require("notify")("gruvbox-material")
elseif themenum == 11 then
    require('nightfox').setup({})
    vim.cmd [[colorscheme nightfox]]
    require("notify")("nightfox")
elseif themenum == 12 then
    require('rose-pine').setup({})
    vim.cmd [[colorscheme rose-pine]]
    require("notify")("rose-pine")
elseif themenum == 13 then
    require('catpuccin').setup({})
    vim.cmd [[colorscheme catpuccin]]
    require("notify")("catpuccin")
elseif themenum == 14 then
    require('everforest').setup({})
    vim.cmd [[colorscheme everforest]]
    require("notify")("everforest")
elseif themenum == 15 then
    require('kanagawa').setup({})
    vim.cmd [[colorscheme kanagawa-wave]]
    require("notify")("kanagawa-wave")
elseif themenum == 16 then
    require('kanagawa').setup({})
    vim.cmd [[colorscheme kanagawa-dragon]]
    require("notify")("kanagawa-dragon")
elseif themenum == 17 then
    require('everblush').setup({})
    vim.cmd [[colorscheme everblush]]
    require("notify")("everblush")
elseif themenum == 18 then
    require('sonokai').setup({})
    vim.cmd [[colorscheme sonokai]]
    require("notify")("sonokai")
elseif themenum == 19 then
    require('edge').setup({})
    vim.cmd [[colorscheme edge]]
    require("notify")("edge")
end
