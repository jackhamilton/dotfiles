return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 300,                      -- optional; matches timeoutlen nicely
            triggers = {
                { "<auto>", mode = "nxsot" }, -- keep auto detection
                -- a/i already exist as mini.ai mappings, so which-key's auto
                -- trigger deliberately skips them.
                { "a",      mode = { "x", "o" } },
                { "i",      mode = { "x", "o" } },
                { "S",      mode = { "n", "x" } }, -- explicitly trigger on S
            },
        }
    },
}
