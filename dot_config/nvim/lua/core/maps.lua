-- Set space as leader key
vim.g.mapleader = " "

local kbd = vim.keymap.set

kbd("n", "<C-A-Left>", "<C-w>h")
kbd("n", "<C-A-Up>", "<C-w>k")
kbd("n", "<C-A-Down>", "<C-w>j")
kbd("n", "<C-A-Right>", "<C-w>l")
kbd("n", "<leader>o", "<cmd>Telescope smart_open<cr>", { desc = "Omnibar" })
kbd("n", "<leader>b", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
kbd("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Search Files" })
kbd("n", "<leader>fs", "<cmd lua MiniFiles.open()<cr>", { desc = "Filesystem" })
