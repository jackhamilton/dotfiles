local M = {}

local prepare_method = 'textDocument/prepareCallHierarchy'
local incoming_method = 'callHierarchy/incomingCalls'
local outgoing_method = 'callHierarchy/outgoingCalls'

local function is_preview_registry(item)
    local identity = table.concat({ item.name or '', item.detail or '' }, ' '):lower()
    return identity:find('previewregistry', 1, true)
        or identity:find('preview registry', 1, true)
        or identity:find('__preview__', 1, true)
end

local function discard(discards)
    discards.count = discards.count + 1
end

local function add_location(locations, seen, files, discards, uri, range, text)
    local ok, filename = pcall(vim.uri_to_fname, uri)
    if not ok or not filename or vim.uv.fs_stat(filename) == nil then
        discard(discards)
        return
    end

    if type(range) ~= 'table'
        or type(range.start) ~= 'table'
        or type(range['end']) ~= 'table'
        or type(range.start.line) ~= 'number'
        or type(range.start.character) ~= 'number'
        or type(range['end'].line) ~= 'number'
        or type(range['end'].character) ~= 'number' then
        discard(discards)
        return
    end

    local lines = files[filename]
    if lines == nil then
        local read_ok, loaded_lines = pcall(vim.fn.readfile, filename)
        files[filename] = read_ok and loaded_lines or false
        lines = files[filename]
    end

    local start_line = range.start.line + 1
    local end_line = range['end'].line + 1
    if not lines or start_line < 1 or end_line < start_line or end_line > #lines then
        discard(discards)
        return
    end

    local start_column = vim.str_utfindex(lines[start_line], 'utf-16')
    local end_column = vim.str_utfindex(lines[end_line], 'utf-16')
    if range.start.character < 0 or range['end'].character < 0
        or range.start.character > start_column or range['end'].character > end_column then
        discard(discards)
        return
    end

    local key = table.concat({ filename, start_line, range.start.character, end_line, range['end'].character }, ':')
    if seen[key] then
        return
    end
    seen[key] = true

    locations[#locations + 1] = {
        filename = filename,
        lnum = start_line,
        col = range.start.character + 1,
        end_lnum = end_line,
        end_col = range['end'].character + 1,
        text = text,
    }
end

local function incoming_call_sites(items)
    local locations = {}
    local seen = {}
    local files = {}
    local discards = { count = 0 }

    for _, incoming in ipairs(items or {}) do
        local caller = incoming['from']
        if not is_preview_registry(caller) then
            for _, range in ipairs(incoming.fromRanges or {}) do
                add_location(locations, seen, files, discards, caller.uri, range, caller.name)
            end
        end
    end

    return locations, discards.count
end

local function outgoing_call_sites(items, caller)
    local locations = {}
    local seen = {}
    local files = {}
    local discards = { count = 0 }

    for _, outgoing in ipairs(items or {}) do
        local callee = outgoing.to
        if not is_preview_registry(callee) then
            for _, range in ipairs(outgoing.fromRanges or {}) do
                add_location(locations, seen, files, discards, caller.uri, range, callee.name)
            end
        end
    end

    return locations, discards.count
end

local function call_sites(method, result_name, preposition, collect_locations)
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = prepare_method })
    if #clients == 0 then
        vim.notify('No LSP client supports call hierarchy in this buffer', vim.log.levels.WARN)
        return
    end

    local client = clients[1]
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client:request(prepare_method, params, function(err, prepared)
        if err then
            vim.notify(err.message or tostring(err), vim.log.levels.ERROR)
            return
        end

        local item = prepared and prepared[1]
        if not item then
            vim.notify('No call hierarchy item at the cursor', vim.log.levels.INFO)
            return
        end

        client:request(method, { item = item }, function(request_err, result)
            if request_err then
                vim.notify(request_err.message or tostring(request_err), vim.log.levels.ERROR)
                return
            end

            local locations, discarded = collect_locations(result, item)
            if discarded > 0 then
                vim.notify(
                    ('Discarded %d invalid call-hierarchy location%s; purge the project DerivedData and rebuild if this persists')
                        :format(discarded, discarded == 1 and '' or 's'),
                    vim.log.levels.WARN
                )
            end
            if #locations == 0 then
                vim.notify(('No %s found'):format(result_name:lower()), vim.log.levels.INFO)
                return
            end

            vim.fn.setqflist({}, ' ', {
                title = ('%s %s %s'):format(result_name, preposition, item.name),
                items = locations,
            })
            Snacks.picker.qflist({ title = ('%s %s %s'):format(result_name, preposition, item.name) })
        end, bufnr)
    end, bufnr)
end

function M.incoming_calls()
    call_sites(incoming_method, 'Incoming calls', 'to', incoming_call_sites)
end

function M.outgoing_calls()
    call_sites(outgoing_method, 'Outgoing calls', 'from', outgoing_call_sites)
end

return M
