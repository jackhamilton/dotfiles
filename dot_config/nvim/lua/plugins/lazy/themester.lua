return {
    'jackhamilton/themester.nvim',
    -- dir = "~/Documents/GitHub/themester.nvim",
    lazy = false,
    opts = {
        themester_plugin_env_var = "NVIM_THEME_PLUGIN",
        themester_theme_env_var = "NVIM_THEME",
        notify = true,
    },
    dependencies = {
        'rcarriga/nvim-notify'
    },
    -- keys = {
    --     { "<leader>a",  mode = { "n" }, "<CMD>AerialToggle<CR>",                   desc = "Aerial toggle" },
    --     { "{",  mode = { "n" }, "<CMD>AerialPrev<CR>",                   desc = "Go to next aerial marker" },
    --     { "}",  mode = { "n" }, "<CMD>AerialNext<CR>",                   desc = "Go to prev aerial marker" },
    -- }
}
