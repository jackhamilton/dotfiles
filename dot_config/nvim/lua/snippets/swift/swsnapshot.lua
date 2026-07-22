local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

return {
    ls.snippet({ trig = "swsnapshot", dscr = "Snapshot Test" }, fmt([[
        //
        // Created 2026 by Jack Hamilton
        //

        import SnapshotTesting
        import SwiftUI
        import XCTest

        @GenerateSnapshotTests(fromPreviews: <>View_Previews.PreviewCase.self,
                               withStrategy: .minimumSize,
                               testDescriptors: { previewCase in
            switch previewCase {
            case .basic:
                "Basic"
            }
        })
        ]], {
        ls.insert_node(1, "Name"),
    }, {
        delimiters = "<>",
    })),
}
