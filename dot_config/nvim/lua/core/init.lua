require("core.config")

-- Commands
require("core.commands")

--- Autocommands
require("core.autocmds")

--- Keybindings
require("core.maps")

--- LSP
require("core.lsp")

--- Better notifications
local ok, notify = pcall(require, "notify")
if ok then
  ---@diagnostic disable-next-line
  notify.setup({ level = 0 })
  vim.notify = notify
end
