return {
    { "neovim/nvim-lspconfig" }, -- enable LSP
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "jose-elias-alvarez/null-ls.nvim" }, -- for formatters and linters
    { "nvim-lua/plenary.nvim" },           -- Dependency

    -- Autocompletion
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },
    { "hrsh7th/nvim-cmp" }, -- Code autocompletion
    { "hrsh7th/cmp-nvim-lsp" },

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
    { 'kassio/neoterm' },
    {
        'nanozuki/tabby.nvim',
        event = 'VimEnter',
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    { 'lewis6991/gitsigns.nvim' },
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
    },

    -- Themes
    { 'christianchiarulli/nvcode-color-schemes.vim' },
    { 'Th3Whit3Wolf/onebuddy' },
    { 'sainnhe/edge' },
    { 'sainnhe/sonokai' },
    { 'EdenEast/nightfox.nvim' },
    { 'nvim-tree/nvim-web-devicons' },

    { "ellisonleao/glow.nvim",                      config = true, cmd = "Glow" }, -- Markdown preview, :Glow/:Glow!
}
