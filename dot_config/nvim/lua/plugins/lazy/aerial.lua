return {
    'stevearc/aerial.nvim',
    opts = {},
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    keys = {
        { "<leader>a",  mode = { "n" }, "<CMD>AerialToggle<CR>",                   desc = "Aerial toggle" },
        { "{",  mode = { "n" }, "<CMD>AerialPrev<CR>",                   desc = "Go to next aerial marker" },
        { "}",  mode = { "n" }, "<CMD>AerialNext<CR>",                   desc = "Go to prev aerial marker" },
    }
}
