local plug = os.getenv("NVIM_THEME_PLUGIN") or "nightfox"
local theme = os.getenv("NVIM_THEME") or "nightfox"

require(plug).setup({})
vim.cmd("colorscheme " .. theme)
require("notify")(theme)
