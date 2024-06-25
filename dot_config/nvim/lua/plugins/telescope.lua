-- local ivy = require("telescope.themes").get_ivy
-- local telescope = require("telescope")
--
-- telescope.setup({
--   defaults = ivy(),
--   extensions = {
--     file_browser = {
--       theme = "ivy",
--       hidden = true,
--       use_fd = false, -- I am already using zf by default
--       hijack_netrw = false,
--     },
--   },
-- })
--
-- --- Extensions, not available in LuaRocks yet
-- telescope.load_extension("zf-native")
-- telescope.load_extension("smart_open")

local wk = require('which-key')
wk.register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<cr>", "Telescope" },
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        s = { "<cmd>Telescope live_grep<cr>", "Search" },
        u = { "<cmd>Telescope grep_string<cr>", "Symbol search" },
        b = { "<cmd>Telescope buffers<cr>", "Buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
        q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
        m = { "<cmd>Telescope marks<cr>", "Marks" },
        j = { "<cmd>Telescope jumplist<cr>", "Jumplist" },
        r = { "<cmd>Telescope registers<cr>", "Registers" },
        e = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        v = { "<cmd>Telescope vim_options<cr>", "Vim options" },
        l = {
            name = "LSP",
            u = { "<cmd>Telescope lsp_references<cr>", "Symbol references" },
            b = { "<cmd>Telescope lsp_incoming_calls<cr>", "Incoming calls" },
            h = { "<cmd>Telescope lsp_outgoing_calls<cr>", "Outgoing calls" },
            c = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
            q = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace symbol search" },
            m = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "All workspace symbol search" },
            j = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
            r = { "<cmd>Telescope lsp_implementations<cr>", "Implementations" },
            e = { "<cmd>Telescope definitions<cr>", "Definitions" },
            k = { "<cmd>Telescope lsp_type_definitions<cr>", "Type definitions" },
        },
        g = {
            name = "Git",
            c = {
                name = "Commits",
                c = { "<cmd>Telescope git_commits<cr>", "Commits" },
                b = { "<cmd>Telescope git_bcommits<cr>", "Buffer commits" },
                r = { "<cmd>Telescope git_bcommits_range<cr>", "Commits for a line range (visual mode supported)" },
            },
            b = { "<cmd>Telescope git_branches<cr>", "Branches" },
            s = { "<cmd>Telescope git_status<cr>", "Status" },
            t = { "<cmd>Telescope git_stash<cr>", "Stash" },
        }
    },
}, { prefix = "<leader>" })
