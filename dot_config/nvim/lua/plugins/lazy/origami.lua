return {
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        opts = {}, -- required even when using default config
        config = function()
            require("origami").setup {
                useLspFoldsWithTreesitterFallback = {
                    -- The outline controller below owns Tree-sitter fold
                    -- providers so a later LSP attach cannot replace the
                    -- initialized window-local fold state.
                    enabled = false,
                    foldmethodIfNeitherIsAvailable = "indent", ---@type string|fun(bufnr: number): string
                },
                pauseFoldsOnSearch = true,
                foldtext = {
                    enabled = true,
                    padding = {
                        character = " ",
                        width = 3, ---@type number|fun(win: number, foldstart: number, currentVirtualTextLength: number): number
                        hlgroup = nil,
                    },
                    lineCount = {
                        template = "%d lines", -- `%d` is replaced with the number of folded lines
                        hlgroup = "Comment",
                    },
                    diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
                    gitsignsCount = true,    -- requires `gitsigns.nvim` or `mini.diff`
                    disableOnFt = { "snacks_picker_input" }, ---@type string[]
                },
                autoFold = {
                    -- vim.lsp.foldclose() can fail from a deferred callback while
                    -- opening a buffer (especially an empty one). This cannot be
                    -- contained with pcall here, so leave Origami's automatic
                    -- import/comment folding off until the Neovim bug is fixed.
                    enabled = false,
                    kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
                },
                foldKeymaps = {
                    setup = false,                   -- modifies `h`, `l`, `^`, and `$`
                    closeOnlyOnFirstColumn = false, -- `h` and `^` only fold in the 1st column
                    scrollLeftOnCaret = false,      -- `^` should scroll left (basically mapped to `0^`)
                },
            }

            vim.keymap.set("n", "<Left>", function() require("origami").h() end)
            vim.keymap.set("n", "<Right>", function() require("origami").l() end)
            require("utils.origami_outline").setup()
        end,

        -- recommended: disable vim's auto-folding
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },
}
