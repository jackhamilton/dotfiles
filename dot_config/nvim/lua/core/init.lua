require("core.config")

-- Commands
require("core.commands")

--- Autocommands
require("core.autocmds")

--- Keybindings
require("core.maps")

--- LSP
require("core.lsp")

--- FILETYPE
require("core.filetypes")

---- Make all vim.notify calls use Snacks' notifier
local Snacks = require("snacks")
vim.notify = function(msg, level, opts)
  Snacks.notifier.notify(msg, level, opts)
end
