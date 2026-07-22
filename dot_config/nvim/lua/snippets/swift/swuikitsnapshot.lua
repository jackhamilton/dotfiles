local ls = require("luasnip")
local d = ls.dynamic_node
local i = ls.insert_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

local function copy_node(index)
    return d(index, function(args)
        return sn(nil, {
            i(1, args[1]),
        })
    end, { 1 })
end

return {
    ls.snippet({ trig = "swuikitsnapshot", dscr = "Snapshot Test" }, fmt([[
        //
        // Created 2026 by Jack Hamilton
        //

        import Foundation
        import UIKit
        import XCTest

        final class <>SnapshotTests: BaseSnapshotTestCase {
            func test_<>Snapshots() {
                let vc = <>ViewController
                vc.loadViewIfNeeded()
                vc.view.layoutIfNeeded()
                assertSnapshot(of: vc)
            }
        }
        ]], {
        i(1, "Name"),
        copy_node(2),
        copy_node(3),
    }, {
        delimiters = "<>",
    })),
}
