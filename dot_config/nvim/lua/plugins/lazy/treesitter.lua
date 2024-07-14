return {
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
}
