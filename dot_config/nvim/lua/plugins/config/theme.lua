local themenum = tonumber(os.getenv("THEMENUM"))
themenum = themenum % 19 + 1
if themenum == 1 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight-night]]
    require("notify")("tokyonight-night")
elseif themenum == 2 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight-moon]]
    require("notify")("tokyonight-moon")
elseif themenum == 3 then
    require('tokyonight').setup({})
    vim.cmd [[colorscheme tokyonight-storm]]
    require("notify")("tokyonight-storm")
elseif themenum == 4 then
    require('catppuccin').setup({})
    vim.cmd [[colorscheme catppuccin-frappe]]
    require("notify")("catppuccin-frappe")
elseif themenum == 5 then
    require('catppuccin').setup({})
    vim.cmd [[colorscheme catppuccin-macchiato]]
    require("notify")("catppuccin-macchiato")
elseif themenum == 6 then
    require('catppuccin').setup({})
    vim.cmd [[colorscheme catppuccin-mocha]]
    require("notify")("catppuccin-mocha")
elseif themenum == 7 then
    vim.cmd [[colorscheme gruvbox]]
    require("notify")("gruvbox")
elseif themenum == 8 then
    vim.cmd [[colorscheme gruvbox-material]]
    require("notify")("gruvbox-material")
elseif themenum == 9 then
    require('nightfox').setup({})
    vim.cmd [[colorscheme nightfox]]
    require("notify")("nightfox")
elseif themenum == 10 then
    require('rose-pine').setup({})
    vim.cmd [[colorscheme rose-pine]]
    require("notify")("rose-pine")
elseif themenum == 11 then
    require('kanagawa').setup({})
    vim.cmd [[colorscheme kanagawa-wave]]
    require("notify")("kanagawa-wave")
elseif themenum == 12 then
    require('kanagawa').setup({})
    vim.cmd [[colorscheme kanagawa-dragon]]
    require("notify")("kanagawa-dragon")
elseif themenum == 13 then
    require('everblush').setup({})
    vim.cmd [[colorscheme everblush]]
    require("notify")("everblush")
elseif themenum == 14 then
    vim.cmd [[colorscheme sonokai]]
    require("notify")("sonokai")
elseif themenum == 15 then
    vim.cmd [[colorscheme edge]]
    require("notify")("edge")
elseif themenum == 16 then
    require('flow').setup({})
    vim.cmd [[colorscheme flow]]
    require("notify")("flow")
-- elseif themenum == 17 then
--     -- require('nightfly').setup({})
--     vim.cmd [[colorscheme nightfly]]
--     require("notify")("nightfly")
-- elseif themenum == 18 then
--     require('cyberdream').setup({})
--     vim.cmd [[colorscheme cyberdream]]
--     require("notify")("cyberdream")
elseif themenum == 17 then
    require('solarized-osaka').setup({})
    vim.cmd [[colorscheme solarized-osaka]]
    require("notify")("solarized-osaka")
elseif themenum == 18 then
    require('fluoromachine').setup({})
    vim.cmd [[colorscheme fluoromachine]]
    require("notify")("fluoromachine")
elseif themenum == 19 then
    require('kanagawa-paper').setup({})
    vim.cmd [[colorscheme kanagawa-paper]]
    require("notify")("kanagawa-paper")
end
