return {
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
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
}
