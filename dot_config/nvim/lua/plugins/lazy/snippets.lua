return {
    {
        'L3MON4D3/LuaSnip',
        event = "BufEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local luaload = require("luasnip.loaders.from_lua")
            luaload.lazy_load({ paths = { "./lua/snippets" } })
            local ls = require("luasnip")
            vim.keymap.set({"i", "s"}, "<C-E>", function()
	            if ls.choice_active() then
		            ls.change_choice(1)
	            end
            end, {silent = true})
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
