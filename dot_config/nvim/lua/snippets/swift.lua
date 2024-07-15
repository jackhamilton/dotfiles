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

return {
    s("grheader", {
        t({
            "//",
            "//",
            "// Copyright 2024 by Grindr LLC,",
            "// All rights reserved.",
            "//",
            "// This software is confidential and proprietary information of",
            "// Grindr LLC (\"Confidential Information\").",
            "// You shall not disclose such Confidential Information and shall use",
            "// it only in accordance with the terms of the license agreement",
            "// you entered into with Grindr LLC.",
            "//",
        })
    }),
    -- Grindr simple view snippet
    s("grview", {
        t({
            "//",
            "//",
            "// Copyright 2024 by Grindr LLC,",
            "// All rights reserved.",
            "//"    s("example2", fmt([[
  if {} then
    {}
  end
  ]], {
        -- i(1) is at nodes[1], i(2) at nodes[2].
        i(1, "not now"), i(2, "when")
    })),
            "// This software is confidential and proprietary information of",
            "// Grindr LLC (\"Confidential Information\").",
            "// You shall not disclose such Confidential Information and shall use",
            "// it only in accordance with the terms of the license agreement",
            "// you entered into with Grindr LLC.",
            "//",
            "import Foundation",
            "import GrindrDesignKit",
            "import RxCocoa",
            "import RxSwift",
            ""
        }),
        t("class "), i(1, "Name"), t(": UIView {"),
        t({
            "   init() {",
            "       super.init(frame: .zero)",
            "",
            "       installSubviews()",
            "   }",
            "",
            "   @available(*, unavailable)",
            "   required init?(coder: NSCoder) {",
            "       fatalError(\"init(coder:) has not been implemented\")",
            "   }",
            "",
            "   private func installSubviews() {",
            "",
            "   }",
            "}",
        })
    }),
    s("grtest", fmt([[
    //
    // Copyright 2024 by Grindr LLC,
    // All rights reserved.
    //
    // This software is confidential and proprietary information of
    // Grindr LLC ("Confidential Information").
    // You shall not disclose such Confidential Information and shall use
    // it only in accordance with the terms of the license agreement
    // you entered into with Grindr LLC.

    import Factory
    @testable import grindrx
    import XCTest

    class <>: XCTestCase {
        override func setUpWithError() throws {
            try super.setUpWithError()
            Container.shared.reset()
        }
    }
    ]], {
            i(1, "Name")
        }, {
            delimiters = "<>"
        })),
    -- Grindr label
    s("grlabel", fmt([[
    private lazy var rateLabel = UILabel.with {
         $0.text = "<>".localized()
         $0.font = .<>
         $0.textColor = .Text.<>
         $0.textAlignment = .<>
     }
     ]], {
        i(1, "Text"),
        i(2, "Font"),
        i(3, "Text Color"),
        i(4, "Alignment"),
    }, {
            delimiters = "<>"
        })),
}
