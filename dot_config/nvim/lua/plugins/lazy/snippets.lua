return {
    {
        'L3MON4D3/LuaSnip',
        event = "LspAttach",
        dependencies = { "rafamadriz/friendly-snippets" },
        postinstall = "make install_jsregexp",
        config = function()
            local luaload = require("luasnip.loaders.from_lua")
            luaload.lazy_load({ paths = { "./lua/snippets" } })
            local kbd = vim.keymap.set
            kbd("i", "<C-s>", "<cmd>lua require(\"luasnip.extras.select_choice\")()<cr>")
            local types = require("luasnip.util.types")
            require'luasnip'.config.setup({
                ext_opts = {
		            [types.choiceNode] = {
			            active = {
				            virt_text = {{"●", "GruvboxOrange"}}
			            }
		            },
		            [types.insertNode] = {
			            active = {
				            virt_text = {{"●", "GruvboxBlue"}}
			            }
		            }
	            },
            })
        end,
    },
    { 'rafamadriz/friendly-snippets' },
}
