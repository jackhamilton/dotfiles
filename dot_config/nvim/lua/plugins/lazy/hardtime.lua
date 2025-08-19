return {
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
		    restricted_keys = {
                ["<Up>"] = { "n", "x" },
                ["<Down>"] = { "n", "x" },
                ["<Left>"] = { "n", "x" },
                ["<Right>"] = { "n", "x" },
                ["h"] = false,
                ["j"] = false,
                ["k"] = false,
                ["l"] = false,
		    },
		    disabled_keys = {
                ["<Up>"] = false, -- Allow <Up> key
                ["<Down>"] = false,
                ["<Left>"] = false,
                ["<Right>"] = false,
		    },
		}
	},
}
