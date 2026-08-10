local ls = require("luasnip")
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local d = ls.dynamic_node
local sn = ls.snippet_node

return {
    ls.snippet({ trig = "suview", dscr = "SwiftUI View" },
        fmt([[
        import SwiftUI

        struct <>View: View {
            public var body: some View {

            }
        }

        #Preview {
            <>View()
        }
        ]], {
        i(1, "Name"),
        d(2, function(args)
            return sn(nil, {
                i(1, args[1]),
            })
        end, { 1 }),
    }, {
        delimiters = "<>",
    })),
}
