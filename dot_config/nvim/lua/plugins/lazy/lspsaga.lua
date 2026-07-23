local function show_workspace_folders()
    local folders = vim.lsp.buf.list_workspace_folders()
    local message = #folders == 0 and "No LSP workspace folders" or table.concat(folders, "\n")
    vim.notify(message, vim.log.levels.INFO, { title = "LSP workspace folders" })
end

return {
    {
        "nvimdev/lspsaga.nvim",
        opts = {
            devicon = true,
            callhierarchy = {
                keys = {
                    edit = "o",
                    vsplit = "v",
                    split = "s",
                    tabe = "t",
                    close = "<Esc>",
                    quit = "q",
                    shuttle = "<Tab>",
                    toggle_or_req = "<CR>",
                },
            },
            typehierarchy = {
                keys = {
                    edit = "o",
                    vsplit = "v",
                    split = "s",
                    tabe = "t",
                    close = "<Esc>",
                    quit = "q",
                    shuttle = "<Tab>",
                    toggle_or_req = "<CR>",
                },
            },
            -- lightbulb = {
            --     enable = false,
            --     enable_in_insert = false,
            -- },
        },
        event = 'LspAttach',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<leader>lf", mode = { "n" }, "<CMD>Lspsaga finder<CR>",                   desc = "Finder" },
            { "<leader>la", mode = { "n", "x" }, "<CMD>Lspsaga code_action<CR>",        desc = "Code actions" },
            { "<leader>ld", mode = { "n" }, "<CMD>Lspsaga peek_definition<CR>",          desc = "Peek Definition" },
            { "<leader>lD", mode = { "n" }, "<CMD>Lspsaga peek_type_definition<CR>",     desc = "Peek Type Definition" },
            { "<leader>lN", mode = { "n" }, "<CMD>Lspsaga diagnostic_jump_next<CR>",     desc = "Next Diagnostic" },
            { "<leader>lP", mode = { "n" }, "<CMD>Lspsaga diagnostic_jump_previous<CR>", desc = "Previous Diagnostic" },
            { "<leader>lt", mode = { "n" }, "<CMD>Lspsaga term_toggle<CR>",              desc = "Toggle Terminal" },
            { "<leader>lh", mode = { "n" }, "<CMD>Lspsaga hover_doc<CR>",                desc = "Hover Documentation" },
            { "<leader>lo", mode = { "n" }, "<CMD>Lspsaga outline<CR>",                  desc = "Outline" },
            { "<leader>lr", mode = { "n" }, "<CMD>Lspsaga rename<CR>",                   desc = "Rename" },
            { "<leader>lF", mode = { "n", "x" }, vim.lsp.buf.format,                    desc = "Format file or range" },
            { "<leader>lT", "<CMD>LspToggle<CR>",                                        desc = "Toggle LSP" },
            { "<leader>lx", vim.lsp.codelens.run,                                         desc = "Run code lens" },
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
            { "<leader>lsh", vim.lsp.buf.signature_help,   desc = "Symbol signature help" },
            { "<leader>lsD", vim.lsp.buf.workspace_diagnostics, desc = "Workspace diagnostics" },
            { "<leader>lsr", vim.lsp.buf.document_highlight, desc = "Highlight references" },
            { "<leader>lsR", vim.lsp.buf.clear_references, desc = "Clear reference highlights" },
            { "<leader>lci", mode = { "n" }, "<CMD>Lspsaga incoming_calls<CR>", desc = "Explore incoming calls" },
            { "<leader>lco", mode = { "n" }, "<CMD>Lspsaga outgoing_calls<CR>", desc = "Explore outgoing calls" },
            { "<leader>lgs", "<CMD>Lspsaga subtypes<CR>",   desc = "Explore subtypes" },
            { "<leader>lgS", "<CMD>Lspsaga supertypes<CR>", desc = "Explore supertypes" },
            { "<leader>lwa", vim.lsp.buf.add_workspace_folder, desc = "Add workspace folder" },
            { "<leader>lwl", show_workspace_folders, desc = "List workspace folders" },
            { "<leader>lwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove workspace folder" },
        },
    },
}
