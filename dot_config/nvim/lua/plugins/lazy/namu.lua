return {
    {
        "bassamsdata/namu.nvim",
        keys = {
            { "<leader>lsb", function() require("namu.namu_symbols").show() end, desc = "Buffer symbols"},
            { "<leader>lsB", function() require("namu.namu_watchtower").show() end, desc = "All open-buffer symbols"},
            { "<leader>lsw", function() require("namu.namu_workspace").show() end, desc = "Workspace symbols"},
            { "<leader>sD", function() require("namu.namu_diagnostics").show() end, desc = "Buffer diagnostics"},
            { "<leader>lcb", function() require("namu.namu_callhierarchy").show_both_calls() end, desc = "Both call directions"},
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
