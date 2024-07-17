return {
    -- Lazy.nvim
    {
        'xvzc/chezmoi.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        lazy = false,
        config = function()
            require("chezmoi").setup {}
            local telescope = require("telescope")
            telescope.load_extension('chezmoi')
            vim.keymap.set('n', '<leader>td', telescope.extensions.chezmoi.find_files, {})
            --  e.g. ~/.local/share/chezmoi/*
            vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
                pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
                callback = function()
                    vim.schedule(require("chezmoi.commands.__edit").watch)
                end,
            })
        end
    },
}
