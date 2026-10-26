local ls = require("luasnip")
local f = ls.function_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet({ trig = "sumodifier", dscr = "SwiftUI Modifier" },
        fmt([[
import SwiftUI

public struct [name]Modifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
    }
}

extension View {
    public func [method]() -> some View {
        return modifier([type]Modifier())
    }
}

// MARK: Previews

#Preview {
    Text("Test")
        .font(.title)
        .[method]()
}
        ]], {
            name = i(1, "Name"),
            type = f(function(args)
                return args[1][1]
            end, { 1 }),
            method = f(function(args)
                return args[1][1]:sub(1, 1):lower() .. args[1][1]:sub(2)
            end, { 1 }),
        }, {
            delimiters = "[]",
        })),
}
