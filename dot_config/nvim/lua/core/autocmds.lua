local au = vim.api.nvim_create_autocmd

au({ "InsertLeave", "FocusLost" }, {
    pattern = "<buffer>",
    command = "silent! write",
})

-- Update file on external changes
au({ "FocusGained", "TermClose", "TermLeave" }, {
    pattern = "<buffer>",
    command = "checktime",
})

-- Sync rocks.nvim on save
-- au("BufWritePost", {
--   pattern = "rocks.toml",
--   command = "Rocks sync",
-- })

-- Auto cd to current buffer path
-- au("BufEnter", {
--     pattern = "*",
--     command = "silent! lcd %:p:h",
-- })

--minifiles rename integrations
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

local uv = vim.uv

vim.api.nvim_create_autocmd({ 'VimEnter', 'VimLeave' }, {
	callback = function()
		if vim.env.TMUX_PLUGIN_MANAGER_PATH then
			uv.spawn(vim.env.TMUX_PLUGIN_MANAGER_PATH .. '/tmux-window-name/scripts/rename_session_windows.py', {})
		end
	end,
})

-- Automatically create directory when saving a file in case it does not exist
au("BufWritePre", {
    pattern = "*",
    callback = function()
        require("core.autocmds.utils").create_directory_on_save()
    end,
})

-- Preserve last editing position
au("BufReadPost", {
    pattern = "*",
    callback = function()
        require("core.autocmds.utils").preserve_position()
    end,
})


-- Quickly exit help pages
au("FileType", {
    pattern = { "help", "notify", "checkhealth" },
    callback = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            silent = true,
            buffer = true,
        })
    end,
})

-- Trim trailing whitespaces
au("BufWritePre", {
    pattern = "*",
    callback = function()
        local save = vim.fn.winsaveview()
        vim.api.nvim_exec2([[keepjumps keeppatterns silent! %s/\s\+$//e]], {})
        vim.fn.winrestview(save)
    end,
})

-- Wrap and check for spelling
au("FileType", {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Do not conceal JSON files
au("FileType", {
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Disable numbering, folding and signcolumn in Man pages and terminal buffers
local function disable_ui_settings()
    local opts = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        foldcolumn = "0",
        foldlevel = 999,
    }
    for opt, val in pairs(opts) do
        vim.opt_local[opt] = val
    end
end

local function start_term_mode()
    disable_ui_settings()
    vim.cmd("startinsert!")
end

au({ "BufEnter", "BufWinEnter" }, {
    pattern = "man://*",
    callback = disable_ui_settings,
})

au("TermOpen", {
    pattern = "term://*",
    callback = start_term_mode,
})

local function toggle_lsp_client()
    local buf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = buf })
    if not vim.tbl_isempty(clients) then
        vim.cmd("LspStop")
        vim.notify("[nvim] LSP client has been temporarily disabled in this buffer")
    else
        vim.cmd("LspStart")
        vim.notify("[nvim] LSP client has been enabled again in this buffer")
    end
end

vim.api.nvim_create_user_command("LspToggle", toggle_lsp_client, {
    desc = "Toggle LSP for the current buffer",
})

local mac = vim.fn.OSX()
if mac == 1 then
    if vim.fn.executable("sourcekit-lsp") == 1 then
        local function refresh_xcodeproj()
            io.popen("~/Documents/GitHub/grindr/scripts/nvim_clean.sh")
        end
        vim.api.nvim_create_user_command("Xcrefresh", refresh_xcodeproj, {
            desc = "Clean, build, and generate buildServer.json for the grindr project.",
        })
        local function remake_buildserver()
            os.execute(
                'cd ~/Documents/GitHub/grindr & xcode-build-server config -scheme Grindr -workspace *.xcworkspace')
            io.popen("~/Documents/GitHub/grindr/scripts/nvim_clean.sh")
        end
        vim.api.nvim_create_user_command("Xcbuildserver", remake_buildserver, {
            desc = "Generate buildServer.json for the grindr project.",
        })
    end
end
