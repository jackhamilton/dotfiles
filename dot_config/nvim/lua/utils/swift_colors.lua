local M = {}

local namespace = vim.api.nvim_create_namespace('swift-color-literals')
local color_argument = '()([Hh][Ee][Xx])%s*:%s*()(\")(%x+)'

local function highlight_name(value)
	return 'SwiftColorLiteral' .. value:sub(1, 8):upper()
end

local function add_color_mark(buffer, row, column, value)
	local hex = value:sub(1, 6)
	local group = highlight_name(value)
	vim.api.nvim_set_hl(0, group, { fg = '#' .. hex, default = true })
	vim.api.nvim_buf_set_extmark(buffer, namespace, row, column + #value, {
		virt_text = { { '■ ', group } },
		virt_text_pos = 'inline',
		hl_mode = 'combine',
	})
end

local function refresh(buffer)
	if vim.bo[buffer].filetype ~= 'swift' then
		return
	end

	vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)
	for row, line in ipairs(vim.api.nvim_buf_get_lines(buffer, 0, -1, false)) do
		local search_column = 1
		while true do
			local start, _, _, _, quote_start, quote, value = line:find(color_argument, search_column)
			if not start then
				break
			end

			if (#value == 6 or #value == 8) and quote == '"' then
				add_color_mark(buffer, row - 1, quote_start, value)
			end
			search_column = quote_start + 1
		end
	end
end

function M.setup()
	local group = vim.api.nvim_create_augroup('swift-color-literals', {})
	vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'TextChangedI', 'InsertLeave', 'WinScrolled' }, {
		group = group,
		pattern = '*.swift',
		callback = function(event)
			refresh(event.buf)
		end,
	})
	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buffer) then
			refresh(buffer)
		end
	end
end

return M
