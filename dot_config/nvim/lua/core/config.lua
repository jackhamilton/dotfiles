-- Set C syntax for '.h' header files (default is C++)
vim.g.c_syntax_for_h = true

-- Use clipboard outside Neovim
vim.opt.clipboard = "unnamedplus"
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Enable mouse input
vim.opt.mouse = "a"

-- Disable swapfiles and enable undofiles
vim.cmd([[
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif
set undodir=~/.vim/undo/
]])
vim.opt.swapfile = false
vim.opt.undofile = true

--- UI-related options
-- Smooth all the way!
vim.opt.smoothscroll = true

-- Smooth mouse scrolling
vim.opt.mousescroll = { "hor:1", "ver:1" }

-- Disable ruler
vim.opt.ruler = false

-- Numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- True-color
vim.opt.termguicolors = true

-- Columns and characters
-- vim.opt.signcolumn = "auto:1-3"
-- vim.opt.foldenable = true
-- vim.opt.foldlevel = 99
-- vim.opt.foldcolumn = "auto:2"

vim.opt.fillchars = {
  eob = " ",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
  fold = " ",
  diff = "─",
  msgsep = "‾",
  foldsep = "│",
  foldopen = "▾",
  foldclose = "▸",
}

local space = "·"
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  -- multispace = space,
  -- lead = space,
  trail = space,
  -- nbsp = space
}

-- Set windows width
vim.opt.winwidth = 40

-- Highlight current cursor line
vim.opt.cursorline = true

-- Hide command-line
vim.opt.cmdheight = 0

--- Buffer options
-- Never wrap unless I manually tweak this again
vim.opt.wrap = false

-- Every wrapped line will continue visually indented, preserving horizontal spacing
vim.opt.breakindent = true

-- Smart search
vim.opt.smartcase = true

-- Case-insensitive search
vim.opt.ignorecase = true

-- Indentation rules
vim.opt.copyindent = true
vim.opt.smartindent = true
vim.opt.preserveindent = true

-- Indentation level
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Autowrite
vim.opt.autowrite = true

-- Expand tabs
vim.opt.expandtab = true

-- Enable concealing
vim.opt.conceallevel = 2

-- Automatic split locations
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Scroll off
vim.opt.scrolloff = 999
vim.opt.sidescrolloff = 8

-- Freely move cursor in buffer while in Visual block mode
vim.opt.virtualedit = "block"

-- Spelling
vim.opt.spelllang = "en,es"
vim.opt.spelloptions = "camel,noplainbuffer"
vim.opt.spellsuggest = "best,6"

--- config.lua ends here
