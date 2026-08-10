return {
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        opts = {}, -- required even when using default config
        config = function()
            require("origami").setup {
                useLspFoldsWithTreesitterFallback = {
                    enabled = true,
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
                    enabled = true,
                    kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
                },
                foldKeymaps = {
                    setup = false,                   -- modifies `h`, `l`, `^`, and `$`
                    closeOnlyOnFirstColumn = false, -- `h` and `^` only fold in the 1st column
                    scrollLeftOnCaret = false,      -- `^` should scroll left (basically mapped to `0^`)
                },
            }

            -- Tree-sitter's Swift folds include a closing brace that SourceKit's
            -- folding ranges omit. Add that brace as a decoration instead of via
            -- `foldtext`, since a non-empty foldtext replaces syntax-highlighted
            -- source text on the folded line.
            local swiftFoldTextNs = vim.api.nvim_create_namespace("swift.foldtext")
            vim.api.nvim_set_decoration_provider(swiftFoldTextNs, {
                on_win = function(_, win, buf, topline, botline)
                    if vim.bo[buf].filetype ~= "swift" then return end

                    vim.api.nvim_win_call(win, function()
                        local lineNum = topline
                        while lineNum <= botline do
                            local foldstart = vim.fn.foldclosed(lineNum)
                            if foldstart > -1 then
                                local foldend = vim.fn.foldclosedend(foldstart)
                                local first = vim.fn.getline(foldstart)
                                local last = vim.fn.getline(foldend)

                                if first:match("{%s*$") and last:match("^%s*}%s*$") then
                                    local wininfo = vim.fn.getwininfo(win)[1]
                                    local leftcol = wininfo and wininfo.leftcol or 0
                                    local wincol = math.max(0, vim.fn.virtcol { foldstart, #first } - leftcol)
                                    vim.api.nvim_buf_set_extmark(buf, swiftFoldTextNs, foldstart - 1, 0, {
                                        virt_text = { { " }", "@punctuation.bracket" } },
                                        virt_text_win_col = wincol,
                                        ephemeral = true,
                                    })
                                end

                                lineNum = foldend
                            end
                            lineNum = lineNum + 1
                        end
                    end)
                end,
            })

            vim.keymap.set("n", "<Left>", function() require("origami").h() end)
            vim.keymap.set("n", "<Right>", function() require("origami").l() end)

            local function setupSwiftFolds(buf)
                if vim.bo[buf].filetype ~= "swift" then return end
                if not pcall(vim.treesitter.get_parser, buf) then return end

                vim.api.nvim_buf_call(buf, function()
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    -- Leave foldtext empty: Origami decorates the displayed source
                    -- line with virtual text, which retains Tree-sitter highlighting.
                    vim.wo.foldtext = ""
                end)
                vim.b[buf].origami_folding_provider = "treesitter"
            end

            local swiftFoldGroup = vim.api.nvim_create_augroup("swift_treesitter_folds", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = swiftFoldGroup,
                pattern = "swift",
                callback = function(event) setupSwiftFolds(event.buf) end,
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = swiftFoldGroup,
                callback = function(event) setupSwiftFolds(event.buf) end,
            })
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.bo[buf].buflisted then setupSwiftFolds(buf) end
            end
        end,

        -- recommended: disable vim's auto-folding
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },
}
