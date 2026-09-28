local M = {}

local states = {}

function M.get(win)
    return states[win]
end

function M.set(win, state)
    states[win] = state
end

function M.clear(win)
    states[win] = nil
end

function M.reset()
    states = {}
end

return M
