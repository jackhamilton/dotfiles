local M = {}

local function read_lines(cache, filename)
    local lines = cache[filename]
    if lines ~= nil then
        return lines
    end

    local bufnr = vim.fn.bufnr(filename)
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
        lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    else
        local ok, disk_lines = pcall(vim.fn.readfile, filename)
        lines = ok and disk_lines or false
    end
    cache[filename] = lines
    return lines
end

local function valid_position(lines, position, encoding)
    if type(position) ~= 'table' or type(position.line) ~= 'number' or type(position.character) ~= 'number' then
        return false
    end

    local line = lines[position.line + 1]
    if not line or position.character < 0 then
        return false
    end
    return position.character <= vim.str_utfindex(line, encoding)
end

function M.filter(locations, encoding)
    local valid = {}
    local discarded = 0
    local files = {}

    for _, location in ipairs(locations or {}) do
        local uri = location.uri or location.targetUri
        local range = location.range or location.targetSelectionRange
        local ok, filename = pcall(vim.uri_to_fname, uri)
        local lines = ok and filename and vim.uv.fs_stat(filename) and read_lines(files, filename)

        if lines and type(range) == 'table'
            and valid_position(lines, range.start, encoding)
            and valid_position(lines, range['end'], encoding) then
            valid[#valid + 1] = location
        else
            discarded = discarded + 1
        end
    end

    return valid, discarded
end

function M.wrap_client(client)
    if client._codex_filters_references then
        return
    end
    client._codex_filters_references = true

    local request = client.request
    client.request = function(self, method, params, handler, ...)
        if method ~= 'textDocument/references' then
            return request(self, method, params, handler, ...)
        end

        local function filtered_handler(err, result, ctx, config)
            if not err and result then
                local filtered, discarded = M.filter(result, self.offset_encoding)
                result = filtered
                if discarded > 0 then
                    vim.notify(
                        ('Discarded %d invalid reference location%s; purge the project DerivedData and rebuild if this persists')
                            :format(discarded, discarded == 1 and '' or 's'),
                        vim.log.levels.WARN
                    )
                end
            end
            if handler then
                return handler(err, result, ctx, config)
            end
            return vim.lsp.handlers[method](err, result, ctx, config)
        end

        return request(self, method, params, filtered_handler, ...)
    end
end

return M
