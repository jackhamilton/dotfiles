-- Run with: nvim --headless -u NONE -l tests/type_constructions.lua
vim.opt.rtp:prepend(vim.fn.getcwd())
package.path = vim.fn.getcwd() .. '/lua/?.lua;' .. package.path

local constructions = require('utils.type_constructions')
local file = vim.fn.tempname()
vim.fn.writefile({
    'let a = SuperBrowserItem.init(foo)',
    'let b = SuperBrowserItem<Detail>(foo)',
    'let c = SuperBrowserItem { foo }',
    'struct SuperBrowserItem { let foo: Int }',
    'let d = make(SuperBrowserItem.self)',
    'let e = SuperBrowserItem',
    '    .init(foo)',
    'let f = SuperBrowserItem',
    '    { foo }',
    'extension SuperBrowserItem {',
    'func makeItem() -> SuperBrowserItem {',
    'var computed: SuperBrowserItem {',
}, file)

local uri = vim.uri_from_fname(file)
local lines = vim.fn.readfile(file)
local function location(line, name)
    local character = assert(lines[line + 1]:find(name, 1, true)) - 1
    return {
        uri = uri,
        range = {
            start = { line = line, character = character },
            ['end'] = { line = line, character = character + #name },
        },
    }
end

local name = 'SuperBrowserItem'
assert(constructions._is_construction(location(0, name)), 'init construction should match')
assert(constructions._is_construction(location(1, name)), 'generic construction should match')
assert(constructions._is_construction(location(2, name)), 'struct literal should match')
assert(not constructions._is_construction(location(3, name)), 'type declaration should not match')
assert(not constructions._is_construction(location(4, name)), 'metatype reference should not match')
assert(constructions._is_construction(location(5, name)), 'multiline init construction should match')
assert(constructions._is_construction(location(7, name)), 'multiline literal should match')
assert(not constructions._is_construction(location(9, name), name), 'extension declaration should not match')
assert(not constructions._is_construction(location(10, name), name), 'return type should not match')
assert(not constructions._is_construction(location(11, name), name), 'property type should not match')
assert(constructions._is_construction({
    uri = uri,
    range = { start = { line = 0, character = 0 }, ['end'] = { line = 0, character = 1 } },
}, name), 'name fallback should match a broad server range')

vim.fn.delete(file)
print('type constructions: ok')
