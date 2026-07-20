return {
    {
        'L3MON4D3/LuaSnip',
        event = "BufEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            local luaload = require("luasnip.loaders.from_lua")
            luaload.lazy_load({ paths = { "./lua/snippets" } })
            local types = require("luasnip.util.types")
            require'luasnip'.config.setup({
	            -- Drop stale jump sessions when their text is deleted or the
	            -- cursor leaves their region.
	            delete_check_events = { "TextChanged", "TextChangedI" },
	            region_check_events = { "CursorMoved", "CursorMovedI" },
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
