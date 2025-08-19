return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 300,                      -- optional; matches timeoutlen nicely
            triggers = {
                { "<auto>", mode = "nxsot" }, -- keep auto detection
                { "S",      mode = { "n", "x" } }, -- explicitly trigger on S
            },
        }
    },
}
