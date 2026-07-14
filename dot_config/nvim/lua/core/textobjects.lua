local M = {}

local function end_position(row, col)
    if col > 0 then
        return { line = row + 1, col = col }
    end

    local line = math.max(row, 1)
    return { line = line, col = math.max(#vim.fn.getline(line), 1) }
end

local function node_region(node)
    local start_row, start_col, end_row, end_col = node:range()
    return {
        from = { line = start_row + 1, col = start_col + 1 },
        to = end_position(end_row, end_col),
    }
end

local function comma_siblings(parent)
    local children = {}
    for child in parent:iter_children() do
        table.insert(children, child)
    end

    local items = {}
    for index, child in ipairs(children) do
        if child:type() == "," then
            local before
            for previous = index - 1, 1, -1 do
                if children[previous]:named() then
                    before = children[previous]
                    break
                end
            end

            local after
            for following = index + 1, #children do
                if children[following]:named() then
                    after = children[following]
                    break
                end
            end

            if before and after then
                local before_id = before:id()
                local after_id = after:id()
                items[before_id] = items[before_id] or { node = before }
                items[after_id] = items[after_id] or { node = after }
                items[before_id].following = after
                items[after_id].previous = before
            end
        end
    end

    return items
end

---Create a mini.ai object for syntax-tree siblings separated by commas.
---Unlike mini.ai's built-in argument object, this also covers unbracketed
---lists such as Swift inheritance clauses.
function M.comma_list_item()
    return function(ai_type, _, opts)
        local ok, parser = pcall(vim.treesitter.get_parser, 0)
        if not ok or not parser then
            return {}
        end

        local reference = opts.reference_region.from
        local row = reference.line - 1
        local col = reference.col - 1
        local regions = {}
        local seen = {}

        for _, tree in ipairs(parser:parse()) do
            local node = tree:root():descendant_for_range(row, col, row, col)
            while node do
                for id, item in pairs(comma_siblings(node)) do
                    if not seen[id] then
                        local region = node_region(item.node)

                        if ai_type == "a" then
                            if item.previous then
                                local _, _, previous_end_row, previous_end_col = item.previous:range()
                                region.from = {
                                    line = previous_end_row + 1,
                                    col = previous_end_col + 1,
                                }
                            elseif item.following then
                                local following_row, following_col = item.following:range()
                                region.to = end_position(following_row, following_col)
                            end
                        end

                        table.insert(regions, region)
                        seen[id] = true
                    end
                end
                node = node:parent()
            end
        end

        return regions
    end
end

return M
