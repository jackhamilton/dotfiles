return {
    {
        "bassamsdata/namu.nvim",
        keys = {
            { "<leader>ss", function() require("namu.namu_symbols").show() end, desc = "LSP Symbol Jump"},
            { "<leader>sS", function() require("namu.namu_watchtower").show() end, desc = "All buffer symbols"},
            { "<leader>sW", function() require("namu.namu_workspace").show() end, desc = "Namu workspace"},
            { "<leader>snd", function() require("namu.namu_diagnostics").show() end, desc = "Namu diagnostics"},
            { "<leader>snc", function() require("namu.namu_callhierarchy").show_both_calls() end, desc = "Namu call hierarchy"},
        },
        config = function()
            require("namu").setup({
                -- Enable the modules you want
                namu_symbols = {
                    enable = true,
                    options = {}, -- here you can configure namu
                },
                -- Optional: Enable other modules if needed
                ui_select = { enable = false }, -- vim.ui.select() wrapper
                colorscheme = { enable = false },
            })
        end,
    }
}
