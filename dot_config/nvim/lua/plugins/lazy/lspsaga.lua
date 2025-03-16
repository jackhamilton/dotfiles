return {
    {
        "nvimdev/lspsaga.nvim",
        -- opts = {
        --     lightbulb = {
        --         enable = false,
        --         enable_in_insert = false,
        --     },
        -- },
        event = 'LspAttach',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>l",  group = "LSP" },
            { "<leader>lf", mode = { "n" }, "<CMD>Lspsaga finder<CR>",                   desc = "Finder" },
            { "<leader>la", mode = { "n" }, "<CMD>Lspsaga code_actions<CR>",             desc = "Code Actions" },
            { "<leader>ld", mode = { "n" }, "<CMD>Lspsaga peek_definition<CR>",          desc = "Peek Definition" },
            { "<leader>lD", mode = { "n" }, "<CMD>Lspsaga peek_type_definition<CR>",     desc = "Peek Type Definition" },
            { "<leader>ln", mode = { "n" }, "<CMD>Lspsaga diagnostic_jump_next<CR>",     desc = "Next Diagnostic" },
            { "<leader>lp", mode = { "n" }, "<CMD>Lspsaga diagnostic_jump_previous<CR>", desc = "Previous Diagnostic" },
            { "<leader>lt", mode = { "n" }, "<CMD>Lspsaga term_toggle<CR>",              desc = "Toggle Terminal" },
            { "<leader>lh", mode = { "n" }, "<CMD>Lspsaga hover_doc<CR>",                desc = "Hover Documentation" },
            { "<leader>lo", mode = { "n" }, "<CMD>Lspsaga outline<CR>",                  desc = "Outline" },
            { "<leader>lr", mode = { "n" }, "<CMD>Lspsaga rename<CR>",                   desc = "Rename" },
            { "<leader>li", mode = { "n" }, vim.lsp.buf.implementation,                  desc = "Incoming Calls" },
            { "<leader>lF", mode = { "n" }, vim.lsp.buf.format,                          desc = "Format file" },
            { "<leader>ls", group = "Show" },
            {
                -- Show line diagnostics
                "<leader>lsd",
                function()
                    vim.diagnostic.open_float({
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = "rounded",
                        source = true,
                        prefix = " ",
                        scope = "cursor",
                    })
                end,
                desc = "Show line diagnostics"
            },
            { "<leader>lsf", vim.lsp.buf.declaration,      desc = "Display function signature" },
            { "<leader>lsh", vim.lsp.buf.signature_help,   desc = "Symbol signature help" },
            { "<leader>lc",  group = "Calls" },
            { "<leader>lci", mode = { "n" },               "<CMD>Lspsaga incoming_calls<CR>",  desc = "Incoming Calls" },
            { "<leader>lco", mode = { "n" },               "<CMD>Lspsaga outgoing_calls<CR>",  desc = "Outgoing Calls" },
            { "<leader>lg",  group = "Goto" },
            -- Go to definition
            { "<leader>lgd", vim.lsp.buf.definition,       desc = "Goto definition" },
            -- Go to declaration
            { "<leader>lgD", vim.lsp.buf.declaration,      desc = "Goto declaration" },
            { "<leader>lss", vim.lsp.buf.workspace_symbol, desc = "Workspace symbol search" },
            { "<leader>lgt", vim.lsp.buf.type_definition,  desc = "Goto type definition" },
            -- kbd("n", "<leader>lgh", vim.lsp.buf.type_hierarchy, { buffer = true, desc = "Show type hierarchy" }),
            { "<leader>lgr", vim.lsp.buf.references,       desc = "List references" },
            { "<leader>lgo", vim.lsp.buf.outgoing_calls,   desc = "List outgoing calls" },
        },
    },
}
