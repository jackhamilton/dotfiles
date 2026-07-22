local ls = require("luasnip")
local d = ls.dynamic_node
local i = ls.insert_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet({ trig = "swpreview", dscr = "Preview Provider" }, fmt([[
        import SwiftUI

        public struct []View_Previews: PreviewProvider, CaseIterablePreviewProvider {
            public enum PreviewCase: String, CaseIterablePreviewState {
                case basic

                @MainActor
                public func generatePreview() -> some View {
                    switch self {
                    case .basic:
                        return []View()
                    }
                }
            }
        }
        ]], {
        i(1, "Name"),
        d(2, function(args)
            return sn(nil, {
                i(1, args[1]),
            })
        end, { 1 }),
    }, {
        delimiters = "[]",
    })),
}
