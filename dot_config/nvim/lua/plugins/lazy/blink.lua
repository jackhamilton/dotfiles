local function select_and_accept_with_indent(cmp)
	local item = cmp.get_selected_item() or cmp.get_items()[1]
	if not item or item.source_id ~= 'lsp' then
		return cmp.select_and_accept()
	end

	local new_text = item.textEdit and item.textEdit.newText
		or item.textEditText
		or item.insertText
		or item.label
	local inserted_line_count = new_text and select(2, new_text:gsub('\n', '\n')) + 1 or 1
	if inserted_line_count < 2 then
		return cmp.select_and_accept()
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
	local namespace = vim.api.nvim_create_namespace('blink_lsp_completion_indent')
	-- Mark column zero so the mark follows additional edits (such as imports)
	-- without moving to the end of the completion inserted later on this line.
	local start_mark = vim.api.nvim_buf_set_extmark(bufnr, namespace, cursor_line, 0, {
		right_gravity = false,
	})

	local accepted = cmp.select_and_accept({
		callback = function()
			vim.schedule(function()
				if not vim.api.nvim_buf_is_valid(bufnr) then return end

				local start = vim.api.nvim_buf_get_extmark_by_id(bufnr, namespace, start_mark, {})
				if #start ~= 2 then return end
				local changed_first = start[1]
				local changed_last = math.min(changed_first + inserted_line_count, vim.api.nvim_buf_line_count(bufnr))

				local winid = vim.fn.bufwinid(bufnr)
				local cursor_mark
				if winid ~= -1 then
					local cursor = vim.api.nvim_win_get_cursor(winid)
					cursor_mark = vim.api.nvim_buf_set_extmark(bufnr, namespace, cursor[1] - 1, cursor[2], {
						right_gravity = true,
					})
				end

				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd(('keepjumps silent %d,%dnormal! =='):format(changed_first + 1, changed_last))
				end)

				if cursor_mark and winid ~= -1 and vim.api.nvim_win_is_valid(winid) then
					local cursor = vim.api.nvim_buf_get_extmark_by_id(bufnr, namespace, cursor_mark, {})
					if #cursor == 2 then
						vim.api.nvim_win_set_cursor(winid, { cursor[1] + 1, cursor[2] })
					end
				end
				vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
			end)
		end,
	})

	if not accepted then
		vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
	end
	return accepted
end

return {
	'saghen/blink.cmp',

	-- use a release tag to download pre-built binaries
	version = '*',

	-- optional: provides snippets for the snippet source
	dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = {
			preset = 'default',
			-- blink currently applies multiline LSP text edits "as is". Reindent
			-- their changed lines with the filetype's indentexpr after accepting.
			['<C-y>'] = { select_and_accept_with_indent, 'fallback' },
			-- Cycle a LuaSnip choice when one is active; otherwise retain blink's
			-- cancel behavior and the normal Insert-mode fallback for <C-e>.
			['<C-e>'] = {
				function()
					local ok, luasnip = pcall(require, 'luasnip')
					if ok and luasnip.choice_active() then
						luasnip.change_choice(1)
						return true
					end
				end,
				'cancel',
				'fallback',
			},
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono'
		},

		completion = {
			keyword = {
				-- Match against the text on both sides of the cursor when editing
				-- an identifier in place.
				range = 'full',
			},
			trigger = {
				-- Offer completions while filling SourceKit's argument placeholders.
				show_in_snippet = true,
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
			ghost_text = {
				enabled = true,
			},
			menu = {
				draw = {
					-- We don't need label_description now because label and label_description are already
					-- combined together in label by colorful-menu.nvim.
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
		},

		-- Automatically complete Ex commands, but keep searches unobtrusive.
		cmdline = {
			completion = {
				menu = {
					auto_show = function(ctx)
						return ctx.mode == 'cmdline' and vim.fn.getcmdtype() == ':'
					end,
				},
			},
		},

		-- Show the active function signature while editing an argument list.
		signature = {
			enabled = true,
			trigger = {
				-- Also request signature help when re-entering Insert mode inside
				-- an existing call, rather than only immediately after `(` or `,`.
				show_on_insert = true,
			},
			window = {
				border = 'rounded',
				show_documentation = false,
			},
		},

		snippets = { preset = 'luasnip' },

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { 'lazydev', 'snippets', 'lsp', 'path', 'buffer' },
			providers = {
				lazydev = {
					name = 'LazyDev',
					module = 'lazydev.integrations.blink',
					score_offset = 100,
				},
			},
		},
	},
	opts_extend = { "sources.default" }
}
