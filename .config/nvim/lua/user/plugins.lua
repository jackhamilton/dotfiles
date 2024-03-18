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
    { 'nvim-treesitter' },
    { 'treesitter-context' },
    { 'nvim-telescope/telescope.nvim',    tag = '0.1.5' },
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

    { "ellisonleao/glow.nvim", config = true, cmd = "Glow" }, -- Markdown preview, :Glow/:Glow!
}
