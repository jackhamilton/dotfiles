local M = {}

local foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- These nodes represent types whose immediate contents should remain visible
-- in the otherwise-folded initial outline. Queries are compiled lazily so a
-- missing parser or a grammar change cannot prevent Origami from loading.
local typeQuerySources = {
    swift = "(class_declaration) @type",
    rust = "[(struct_item) (impl_item)] @type",
    c = "(struct_specifier) @type",
    cpp = "[(class_specifier) (struct_specifier)] @type",
    javascript = "(class_declaration) @type",
    typescript = "(class_declaration) @type",
    tsx = "(class_declaration) @type",
}

local typeQueries = {}
local outlineState = {}

---@param buf number
---@return vim.treesitter.LanguageTree?, string?
local function parserForBuffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then return end

    local highlighter = vim.treesitter.highlighter.active[buf]
    local parser = highlighter and highlighter.tree or nil
    if not parser then
        local filetype = vim.bo[buf].filetype
        if filetype == "" or filetype == "snacks_picker_preview" then return end
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        local ok
        ok, parser = pcall(vim.treesitter.get_parser, buf, language)
        -- `get_parser()` may return `nil, error` without throwing when the
        -- buffer's filetype has no installed parser (for example, a dashboard
        -- buffer). Treat that the same as a failed lookup.
        if not ok or not parser then return end
    end

    local ok, language = pcall(parser.lang, parser)
    if not ok then return end
    return parser, language
end

---@param language string
---@return vim.treesitter.Query?
local function typeQuery(language)
    local cached = typeQueries[language]
    if cached ~= nil then return cached or nil end

    local source = typeQuerySources[language]
    if not source then
        typeQueries[language] = false
        return nil
    end

    local ok, query = pcall(vim.treesitter.query.parse, language, source)
    typeQueries[language] = ok and query or false
    return ok and query or nil
end

---@param parser vim.treesitter.LanguageTree
---@param language string
---@param buf number
---@return number[]
local function typeLines(parser, language, buf)
    local query = typeQuery(language)
    if not query then return {} end

    local trees = parser:parse()
    local tree = trees and trees[1]
    if not tree then return {} end

    local lines = {}
    local seen = {}
    for _, node in query:iter_captures(tree:root(), buf) do
        local startRow = node:range()
        local line = startRow + 1
        if not seen[line] then
            seen[line] = true
            lines[#lines + 1] = line
        end
    end
    return lines
end

---@param win number
---@param line number
local function openTypeFold(win, line)
    vim.api.nvim_win_call(win, function()
        -- Open enclosing folds until the type itself is reachable, then open
        -- exactly the type's first fold. Nested functions remain closed.
        local previousStart
        for _ = 1, 20 do
            local foldstart = vim.fn.foldclosed(line)
            if foldstart < 0 then return end
            if foldstart == previousStart then return end

            previousStart = foldstart
            pcall(vim.cmd, ("silent! %dfoldopen"):format(line))
            if foldstart == line then return end
        end
    end)
end

---@param win number
---@param line number
local function openContainingFolds(win, line)
    vim.api.nvim_win_call(win, function()
        for _ = 1, 20 do
            if vim.fn.foldclosed(line) < 0 then return end
            pcall(vim.cmd, ("silent! %dfoldopen"):format(line))
        end
    end)
end

---@param buf number
---@param language string
local function exposePreviewFiletype(buf, language)
    if vim.bo[buf].filetype ~= "snacks_picker_preview" then return end
    if not language:match("^[%w_]+$") then return end

    -- Snacks resets this to `snacks_picker_preview` before loading the next
    -- item. Keeping the detected filetype for the lifetime of this item lets
    -- Neovim's native Tree-sitter foldexpr resolve the already-attached parser.
    -- `noautocmd` prevents an LSP from attaching to the scratch buffer.
    vim.api.nvim_buf_call(buf, function()
        vim.cmd(("noautocmd set filetype=%s"):format(language))
    end)

    -- foldexpr may already have cached the generic preview buffer without a
    -- parser. Replaying FileType clears that native cache. Marking the buffer
    -- as `nofile` for the duration keeps Neovim's LSP auto-enable callback
    -- from attaching a language server to the preview scratch buffer.
    local buftype = vim.bo[buf].buftype
    vim.bo[buf].buftype = "nofile"
    pcall(vim.api.nvim_exec_autocmds, "FileType", {
        buffer = buf,
        modeline = false,
    })
    if vim.api.nvim_buf_is_valid(buf) then vim.bo[buf].buftype = buftype end
end

---@param buf number
---@param win number
---@param opts? { preview?: boolean, force?: boolean, noRetry?: boolean }
function M.refresh(buf, win, opts)
    opts = opts or {}
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end
    if not vim.api.nvim_buf_is_loaded(buf) or vim.api.nvim_win_get_buf(win) ~= buf then return end

    local parser, language = parserForBuffer(buf)
    if not parser or not language then return end

    local ok, folds = pcall(vim.treesitter.query.get, language, "folds")
    if not ok or not folds then return end

    local preview = opts.preview or vim.w[win].snacks_picker_preview == true
    if preview then exposePreviewFiletype(buf, language) end

    vim.api.nvim_win_call(win, function()
        vim.wo.foldenable = true
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = foldexpr
        vim.wo.foldtext = ""
    end)
    vim.b[buf].origami_folding_provider = "treesitter"

    local generation = preview and vim.b[buf].changedtick or nil
    local state = outlineState[win]
    local rebuild = opts.force
        or not state
        or state.buf ~= buf
        or state.language ~= language
        or state.generation ~= generation
    local cursor = vim.api.nvim_win_get_cursor(win)

    if rebuild then
        vim.api.nvim_win_call(win, function()
            -- Ex fold commands do not feed Normal-mode keys into the active
            -- picker input, so this is safe while another window is in Insert.
            -- Keeping foldlevel at zero also makes later asynchronous
            -- Tree-sitter recomputations default to closed folds.
            -- Cycling through `manual` clears per-fold open flags left by the
            -- previous file displayed in a reusable preview window.
            vim.wo.foldmethod = "manual"
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = foldexpr
            vim.wo.foldlevel = 0
            pcall(vim.treesitter.foldexpr, 1)
            pcall(vim.cmd, "silent! %foldclose!")
        end)
        for _, line in ipairs(typeLines(parser, language, buf)) do
            openTypeFold(win, line)
        end
        outlineState[win] = { buf = buf, language = language, generation = generation }
    end

    -- Always reveal the requested location. This is important when a picker
    -- moves between multiple results in one unchanged preview buffer.
    openContainingFolds(win, cursor[1])

    if preview and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
        -- Reapplying the cursor makes Neovim scroll it back into view after a
        -- previously-collapsed region expands, without using `normal! zz`.
        pcall(vim.api.nvim_win_set_cursor, win, cursor)
    end

    if rebuild and not opts.noRetry then
        local expectedChangedtick = vim.b[buf].changedtick
        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then return end
            if vim.api.nvim_win_get_buf(win) ~= buf or vim.b[buf].changedtick ~= expectedChangedtick then return end
            M.refresh(buf, win, { preview = preview, force = true, noRetry = true })
        end, 20)
    end
end

---@param buf number
local function refreshWindows(buf)
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
        vim.schedule(function()
            M.refresh(buf, win)
        end)
    end
end

---@param picker snacks.Picker
function M.refreshPicker(picker)
    vim.schedule(function()
        if picker.closed or not picker.preview then return end
        local preview = picker.preview
        if not preview.win or not preview.win:valid() then return end
        M.refresh(preview.win.buf, preview.win.win, { preview = true })
    end)
end

function M.setup()
    outlineState = {}
    local group = vim.api.nvim_create_augroup("origami_source_outline", { clear = true })
    local events = {
        "FileType",
        "BufWinEnter",
        "WinEnter",
        "TextChanged",
        "TextChangedI",
        "InsertLeave",
        "LspAttach",
    }
    vim.api.nvim_create_autocmd(events, {
        group = group,
        callback = function(event) refreshWindows(event.buf) end,
    })
    vim.api.nvim_create_autocmd("WinClosed", {
        group = group,
        callback = function(event) outlineState[tonumber(event.match)] = nil end,
    })

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        vim.schedule(function() M.refresh(buf, win) end)
    end
end

return M
