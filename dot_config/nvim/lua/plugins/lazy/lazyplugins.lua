return {
    {
        'williamboman/mason.nvim',
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
        opts = { ensure_installed = {}, max_concurrent_installers = #vim.loop.cpu_info(), pip = { upgrade_pip = true } },
        build = ':MasonUpdate',
    },
    -- {
    --     'williamboman/mason-lspconfig.nvim',
    --     config = function(_, opts)
    --         require("mason-lspconfig").setup(opts)
    --     end,
    --     dependencies = {
    --         'williamboman/mason.nvim',
    --     },
    --     opts = { ensure_installed = {}, automatic_installation = true },
    -- },
    {
        'neovim/nvim-lspconfig',
        event = 'LspAttach',
        -- dependencies = {
        --     -- main one
        --     { "ms-jpq/coq_nvim",                  branch = "coq" },

        --     -- 9000+ Snippets
        --     { "ms-jpq/coq.artifacts",             branch = "artifacts" },

        --     -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
        --     -- Need to **configure separately**
        --     { 'ms-jpq/coq.thirdparty',            branch = "3p" },
        --     -- - shell repl
        --     -- - nvim lua api
        --     -- - scientific calculator
        --     -- - comment banner
        --     -- - etc
        --     --
        -- },
        init = function()
            -- update lsp floating window settings
            -- local max_width = 80
            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {}) --, { max_width = max_width })

            -- cursorhold
            vim.opt.updatetime = 250

            -- diagnostics
            vim.diagnostic.config({
                update_in_insert = false,
                virtual_text = false,
            })

            -- vim.g.coq_settings = {
            --     auto_start = true, -- if you want to start COQ at startup
            --     -- Your COQ settings here
            -- }
        end,
        config = function()
            -- require("coq_3p") {
            --     { src = "nvimlua", short_name = "nLUA" },
            --     { src = "bc",      short_name = "MATH", precision = 6 },
            -- }
        end,
        opts = {
            servers = {},
        },
    },
    {
        "brenoprata10/nvim-highlight-colors",
        event = "LspAttach",
        config = function()
            require('nvim-highlight-colors').setup({})
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-cmdline",          -- source for text in buffer
            "hrsh7th/cmp-buffer",           -- source for text in buffer
            "hrsh7th/cmp-path",             -- source for file system paths
            "hrsh7th/cmp-nvim-lsp",         -- source for file system paths
            "L3MON4D3/LuaSnip",             -- snippet engine
            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "lukas-reineke/cmp-rg",
            "onsails/lspkind.nvim",         -- vs-code like pictograms
        },
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0,
            })
        end,
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-e>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-n>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-Space>"] = cmp.mapping.complete(),     -- show completion suggestions
                    ["<C-c>"] = cmp.mapping.abort(),            -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior
                            .Replace
                    }),
                    ["<C-b>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-f>"] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                -- sources for autocompletion
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- snippets
                    { name = "rg",      keyword_length = 3 },
                    { name = "buffer" },  -- text within current buffer
                    { name = "path" },    -- file system paths
                }),

                cmp.setup.cmdline({ '/', '?' }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = 'buffer' }
                    }
                }),

                -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = 'path' }
                    }, {
                        { name = 'cmdline' }
                    }),
                    matching = { disallow_symbol_nonprefix_matching = false }
                }),

                -- configure lspkind for vs-code like pictograms in completion menu
                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })
        end,
    },
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        enabled = function() return jit.os ~= "Linux" end,
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                swift = { "swiftlint" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
                group = lint_augroup,
                callback = function()
                    require("lint").try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>ml", function()
                require("lint").try_lint()
            end, { desc = "Lint file" })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {
                    swift = { "swiftformat" },
                },
                format_on_save = function(bufnr)
                    return { timeout_ms = 500, lsp_fallback = true }
                end,
                log_level = vim.log.levels.ERROR,
            })

            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                conform.format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },
    { "nvim-lua/plenary.nvim" }, -- Dependency

    -- General
    {
        'echasnovski/mini.nvim',
        version = false
    },

    -- Lsp
    -- {
    --  'nvimdev/lspsaga.nvim',
    --  event = 'LspAttach',
    --  config = function()
    --      require('lspsaga').setup({})
    --  end,
    --  dependencies = {
    --      'nvim-treesitter/nvim-treesitter',
    --      'nvim-tree/nvim-web-devicons',
    --  },
    -- },
    -- Debugging
    {
        "mfussenegger/nvim-dap",
        event = 'LspAttach',
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        lazy = true,
        config = function()
            require("dapui").setup({
                controls = {
                    element = "repl",
                    enabled = true,
                },
                floating = {
                    border = "single",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
                icons = { collapsed = "", expanded = "", current_frame = "" },
                layouts = {
                    {
                        elements = {
                            { id = "stacks",      size = 0.25 },
                            { id = "scopes",      size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "watches",     size = 0.25 },
                        },
                        position = "left",
                        size = 60,
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.35 },
                            { id = "console", size = 0.65 },
                        },
                        position = "bottom",
                        size = 10,
                    },
                },
            })

            local dap, dapui = require("dap"), require("dapui")

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true,
    },
    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    -- Misc
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        config = function()
            require('nvim-treesitter').setup()
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                }
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    -- { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
    {
        "danielfalk/smart-open.nvim",
        branch = "0.2.x",
        config = function()
            require("telescope").load_extension("smart_open")
        end,
        dependencies = {
            "kkharji/sqlite.lua",
            -- Only required if using match_algorithm fzf
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
            { "nvim-telescope/telescope-fzy-native.nvim" },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        lazy = true,
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close
                        },
                    },
                },
            }
        end,
    },
    { 'kevinhwang91/nvim-bqf' },
    { 'nvim-pack/nvim-spectre', event = "VimEnter" },
    {
        'kevinhwang91/nvim-ufo',
        event = "VimEnter",
        dependencies = {
            'kevinhwang91/promise-async'
        },
        config = function()
            vim.o.foldcolumn = '1' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            local wk = require('which-key')
            wk.register({
                name = "UFO",
                R = { require('ufo').openAllFolds, "Open all folds" },
                M = { require('ufo').closeAllFolds, "Close all folds" },
            }, { prefix = 'z' })

            require('ufo').setup({})
        end,
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { 'kassio/neoterm' },
    {
        'nanozuki/tabby.nvim',
        event = 'VimEnter',
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {
        'lewis6991/gitsigns.nvim',
        event = 'VimEnter',
        opts = {},
    },
    {
        "tris203/precognition.nvim",
        config = function()
            require("precognition").toggle()
        end,
        opts = {
            startVisible = true,
        },
        lazy = false
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
        }
    },
    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        lazy = false,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
        },
        event = "LspAttach",
        cmd = "Trouble",
        config = function()
            require('trouble').setup {}
            local wk = require('which-key')
            wk.register({
                x = {
                    name = "Trouble",
                    x = { "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)", },
                    X = { "<cmd>Trouble diagnostics toggle filter<cr>", "Buffer Diagnostics (Trouble)", },
                    s = { "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)", },
                    l = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references / ... (Trouble)", },
                    L = { "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)", },
                    Q = { "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)", },
                }
            }, { prefix = "<leader>" })
        end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        }
    },
    {
        'smoka7/hop.nvim',
        version = "*",
        opts = {
            keys = 'arstgmneioxcdhwfpluy',
        },
        keys = {
            { "ss", mode = { "n", "x", "o" }, function() require('hop').hint_char1() end,                 desc = "Hop to character" },
            { "sS", mode = { "n", "x", "o" }, function() require('hop').hint_char2() end,                 desc = "Hop to two characters" },
            { "sl", mode = { "n", "x", "o" }, function() require('hop').hint_lines_skip_whitespace() end, desc = "Hop to line" },
            { "sp", mode = { "n", "x", "o" }, function() require('hop').hint_patterns() end,              desc = "Hop to pattern" },
            { "sw", mode = { "n", "x", "o" }, function() require('hop').hint_words() end,                 desc = "Hop to word" },
            { "sy", mode = { "n", "x", "o" }, function() require('hop-yank').yank_char1() end,            desc = "Yank at character" },
            { "sp", mode = { "n", "x", "o" }, function() require('hop-yank').paste_char1() end,           desc = "Paste at character" },
            { "st", mode = { "n", "x", "o" }, function() require('hop-treesitter').hint_nodes() end,      desc = "Hop to treesitter obj" },
        }
    },
    -- {
    --     "folke/flascolorscheme sonokaih.nvim",
    --     event = "VeryLazy",
    --     ---@type Flash.Config
    --     opts = {},
    --     -- stylua: ignore
    --     keys = {
    --         { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    --         { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    --         { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --         { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --         { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    --     },
    -- },
    {
        "danymat/neogen",
        config = true,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },
    {
        "OXY2DEV/markview.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("markview").setup()
        end,
    },
    -- Themes
    { 'christianchiarulli/nvcode-color-schemes.vim' },
    { 'Th3Whit3Wolf/onebuddy' },
    { 'sainnhe/edge' },
    {
        'sainnhe/sonokai',
        config = function()
            vim.cmd([[
            colorscheme sonokai
            ]])
        end,
    },
    { 'EdenEast/nightfox.nvim' },
    {
        'codethread/qmk.nvim',
        config = function()
            ---@type qmk.UserConfig
            local conf = {
                name = 'LAYOUT_preonic_grid',
                layout = {
                    '_ x x x x x x _ x x x x x x',
                    '_ x x x x x x _ x x x x x x',
                    '_ x x x x x x _ x x x x x x',
                    '_ x x x x x x _ x x x x x x',
                    '_ x x x x x x _ x x x x x x',
                }
            }
            require('qmk').setup(conf)
        end
    },
    { 'nvim-tree/nvim-web-devicons' },

    { "ellisonleao/glow.nvim",      config = true, cmd = "Glow" }, -- Markdown preview, :Glow/:Glow!
}
