local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key
local r = require("luasnip.extras").rep

local function to_uppercase(args)
    local str = args[1][1]
    local snacks = require('snacks')
    if str == nil or str == "" then
        return str
    end
    local converted = str:gsub("^([a-z])", function(char)
        return char:upper()
    end)
    snacks.notify.info(converted)
    return converted
end

return {
    -- Attributed string
    s("gdrclass", fmt([[
use godot::{prelude::*};

#[derive(GodotClass, Debug)]
#[class(base='")]
pub struct '" {
    pub base: Base<'">
}

impl '" {}

#[godot_api]
impl I'" for '" {
    fn init(base: Base<'">) -> Self {
        Self {
            base
        }
    }
}
    ]], {
        i(1, "Base class"),
        i(2, "Class name"),
        d(3, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(4, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(5, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(6, function(args)
            return sn(nil, {
                i(2, args[1])
            })
        end, { 2 }),
        d(7, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
    }, {
        delimiters = "'\""
    })),
    -- gdexport
    s({trig="gdexport", dscr="Godot GD wrapped export"},
        fmt([[
            #[export]
            pub {}: Option<Gd<{}>>,
            {}
        ]], {
            i(1,"variable_name"),
            i(2,"Class_Name"),
            i(0)
        }, {
            delimiters = "{}"
        })
    ),
}
