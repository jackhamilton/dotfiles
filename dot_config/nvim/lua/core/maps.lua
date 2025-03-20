-- Set space as leader key
vim.g.mapleader = " "

local kbd = vim.keymap.set

kbd("n", "<C-A-Left>", "<C-w>h")
kbd("n", "<C-A-Up>", "<C-w>k")
kbd("n", "<C-A-Down>", "<C-w>j")
kbd("n", "<C-A-Right>", "<C-w>l")
kbd("n", "<C-A-m>", "<C-w>h")
kbd("n", "<C-A-n>", "<C-w>j")
kbd("n", "<C-A-e>", "<C-w>k")
kbd("n", "<C-A-i>", "<C-w>l")

kbd("n", "<leader>qq", "<CMD>cclose<CR>")

-- Resizing
kbd("n", "<C-A-Shift-Left>", "<C-w><")
kbd("n", "<C-A-Shift-Right>", "<C-w>>")
kbd("n", "<C-A-Shift-Up>", "<C-w>+")
kbd("n", "<C-A-Shift-Down>", "<C-w>-")

