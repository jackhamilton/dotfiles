return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()
            local opts = { noremap = true, silent = true }
            local on_attach = function(_, bufnr)
                opts.buffer = bufnr

                opts.desc = "Show line diagnostics"
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Show documentation for what is under cursor"
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            end

        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",           -- source for text in buffer
            "hrsh7th/cmp-path",             -- source for file system paths
            "L3MON4D3/LuaSnip",             -- snippet engine
            "saadparwaiz1/cmp_luasnip",     -- for autocompletion
            "rafamadriz/friendly-snippets", -- useful snippets
            "onsails/lspkind.nvim",         -- vs-code like pictograms
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview",
                },
                snippet = { -- configure how nvim-cmp interacts with snippet engine
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
                    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
                    ["<C-Space>"] = cmp.mapping.complete(),     -- show completion suggestions
                    ["<C-e>"] = cmp.mapping.abort(),            -- close completion window
                    ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
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
                    { name = "buffer" },  -- text within current buffer
                    { name = "path" },    -- file system paths
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
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        "wojciech-kulik/xcodebuild.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
        },
        config = function()
            require("xcodebuild").setup({
                -- put some options here or leave it empty to use default settings
            })
        end,
    },
    --    {
    --        "xbase-lab/xbase",
    --        run = "make install",
    --        requires = {
    --            "nvim-lua/plenary.nvim",
    --            "nvim-telescope/telescope.nvim",
    --            "neovim/nvim-lspconfig",
    --        },
    --        config = function()
    --            require("xbase").setup({})
    --        end,
    --    },

    -- Debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "wojciech-kulik/xcodebuild.nvim"
        },
        config = function()
            local xcodebuild = require("xcodebuild.integrations.dap")

            -- TODO: change it to your local codelldb path
            local codelldbPath = os.getenv("HOME") .. "/Documents/codelldb-aarch64-darwin.vsix"

            xcodebuild.setup(codelldbPath)

            vim.keymap.set("n", "<leader>dd", xcodebuild.build_and_debug, { desc = "Build & Debug" })
            vim.keymap.set("n", "<leader>dr", xcodebuild.debug_without_build, { desc = "Debug Without Building" })
            vim.keymap.set("n", "<leader>dt", xcodebuild.debug_tests, { desc = "Debug Tests" })
            vim.keymap.set("n", "<leader>dT", xcodebuild.debug_class_tests, { desc = "Debug Class Tests" })
            vim.keymap.set("n", "<leader>b", xcodebuild.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>B", xcodebuild.toggle_message_breakpoint, { desc = "Toggle Message Breakpoint" })
            vim.keymap.set("n", "<leader>dx", xcodebuild.terminate_session, { desc = "Terminate Debugger" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", },
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

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    -- Misc
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
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
        lazy = false,
    },
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    { 'ludovicchabant/vim-gutentags' },
    { 'kevinhwang91/nvim-bqf' },
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
        'freddiehaddad/feline.nvim',
        opts = {},
        --config = function(_, opts)
        --    require('feline').setup()
        --    require('feline').winbar.setup()
        --    require('feline').statuscolumn.setup()
        --    require('feline').use_theme()
        --end
    },
    {
        'nvim-orgmode/orgmode',
        dependencies = {
            { 'nvim-treesitter/nvim-treesitter', lazy = true },
        },
        event = 'VeryLazy',
        config = function()
            require('orgmode').setup_ts_grammar()
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                },
                ensure_installed = { 'org' },
            })

            require('orgmode').setup({
                org_agenda_files = '~/orgfiles/**/*',
                org_default_notes_file = '~/orgfiles/refile.org',
            })
        end,
        opts = {},
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
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      -- stylua: ignore
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
    { 
        "danymat/neogen", 
        config = true,
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*" 
    },
    -- {
    --   'stevearc/aerial.nvim',
    --   opts = {},
    --   -- Optional dependencies
    --   dependencies = {
    --      "nvim-treesitter/nvim-treesitter",
    --      "nvim-tree/nvim-web-devicons"
    --   },
    -- }
    -- Themes
    { 'christianchiarulli/nvcode-color-schemes.vim' },
    { 'Th3Whit3Wolf/onebuddy' },
    { 'sainnhe/edge' },
    { 'sainnhe/sonokai' },
    { 'EdenEast/nightfox.nvim' },
    { 'nvim-tree/nvim-web-devicons' },

    { "ellisonleao/glow.nvim",                      config = true, cmd = "Glow" }, -- Markdown preview, :Glow/:Glow!
}

