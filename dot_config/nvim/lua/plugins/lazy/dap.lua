return {
	{
		"mfussenegger/nvim-dap",
		event = 'LspAttach',
		keys = {
			{
				"<leader>Dc",
				mode = "n",
				function()
					require("dap").continue()
				end,
				desc = "Continue"
			},
			{
				"<leader>Ds",
				desc = "Step"
			},
			{
				"<leader>Dsi",
				mode = "n",
				function()
					require("dap").step_into()
				end,
				desc = "Into"
			},
			{
				"<leader>Dso",
				mode = "n",
				function()
					require("dap").step_out()
				end,
				desc = "Out"
			},
			{
				"<leader>Dsb",
				mode = "n",
				function()
					require("dap").step_back()
				end,
				desc = "Back"
			},
			{
				"<leader>DsO",
				mode = "n",
				function()
					require("dap").step_over()
				end,
				desc = "Over"
			},
			{
				"<leader>Dr",
				mode = "n",
				function()
					require("dap").repl.open()
				end,
				desc = "Repl"
			},
			{
				"<leader>Dl",
				mode = "n",
				function()
					require("dap").run_last()
				end,
				desc = "Run last"
			},
			{
				"<leader>Dh",
				mode = "n",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Hover"
			},
			{
				"<leader>Dp",
				mode = "n",
				function()
					require("dap.ui.widgets").preview()
				end,
				desc = "Preview"
			},
			{
				"<leader>DB",
				mode = "n",
				function()
					require("dap").clear_breakpoints()
				end,
				desc = "Clear breakpoints"
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text"
		},
		lazy = true,
		keys = {
			{
				"<leader>Dt",
				mode = "n",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle"
			},
			{
				"<leader>Db",
				mode = "n",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Breakpoint"
			}
		},
		config = function()
			require("dapui").setup({
				controls = {
					element = "repl",
					enabled = true,
				},
				floating = {
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				icons = { collapsed = "", expanded = "", current_frame = "" },
				layouts = {
					{
						elements = {
							{ id = "stacks",      size = 0.25 },
							{ id = "scopes",      size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "watches",     size = 0.25 },
						},
						position = "left",
						size = 60,
					},
					{
						elements = {
							{ id = "repl",    size = 0.35 },
							{ id = "console", size = 0.65 },
						},
						position = "bottom",
						size = 10,
					},
				},
			})

			require("nvim-dap-virtual-text").setup({
			    virt_text_pos = 'inline'
			})

			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
}
