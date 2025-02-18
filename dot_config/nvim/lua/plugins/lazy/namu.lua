return {
    {
        "bassamsdata/namu.nvim",
        keys = {
            { "<leader>ss", function() require("namu.namu_symbols").show() end, desc = "LSP Symbol Jump"},
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
