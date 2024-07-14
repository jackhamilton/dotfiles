return {
    {
        'L3MON4D3/LuaSnip',
        event = "LspAttach",
        dependencies = { "rafamadriz/friendly-snippets" },
        postinstall = "make install_jsregexp",
        config = function()
            local luaload = require("luasnip.loaders.from_lua")
            luaload.load({ paths = { "./lua/snippets" } })
        end,
    },
    { 'rafamadriz/friendly-snippets' },
}
