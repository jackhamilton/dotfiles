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
    -- Attributed string
    s("subscribe", fmt([[
        .subscribe(<>
            <>
        }
        .disposed(by: disposeBag)
    ]], {
        c(1, {
            t("with: self, onNext: { base, _ in"),
            t("onNext: { _ in"),
        }),
        i(0)
    }, {
        delimiters = "<>"
    })),
    -- Attributed string
    s("attributedstring", fmt([[
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.<>
        ]
        let attributedText = NSAttributedString(string: "<>".localized())
    ]], {
        i(1, "Font"),
        i(2, "Text")
    }, {
        delimiters = "<>"
    })),
    s("grheader", {
        t({
            "//",
            "//",
            "// Copyright 2025 by Grindr LLC,",
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
            "// Copyright 2025 by Grindr LLC,",
            "// All rights reserved.",
            "//",
            "// This software is confidential and proprietary information of",
            "// Grindr LLC (\"Confidential Information\").",
            "// You shall not disclose such Confidential Information and shall use",
            "// it only in accordance with the terms of the license agreement",
            "// you entered into with Grindr LLC.",
            "//",
            "import Foundation",
            "import GrindrDesignKit",
            "import GrindrMacros",
            "import RxCocoa",
            "import RxSwift"
        }),
        t({"", "@RequiredCoderInit"}),
        t("class "), i(1, "Name"), t(": UIView {"),
        t({
            "",
            "   init() {",
            "       super.init(frame: .zero)",
            "",
            "       installSubviews()",
            "   }",
            "",
            "   private func installSubviews() {",
            "",
            "   }",
            "}",
        })
    }),
    s("grvc", fmt([[
    //
    // Copyright 2025 by Grindr LLC,
    // All rights reserved.
    //
    // This software is confidential and proprietary information of
    // Grindr LLC ("Confidential Information").
    // You shall not disclose such Confidential Information and shall use
    // it only in accordance with the terms of the license agreement
    // you entered into with Grindr LLC.

    import Foundation
    import GrindrMacros
    import RxSwift

    @RequiredCoderInit
    class <>Controller: UIViewController {
        let viewModel: <>ViewModel
        private lazy var hostedView = <>View()
        private let disposeBag = DisposeBag()

        //MARK: Lifecycle
        init(viewModel: <>ViewModel) {
            self.viewModel = viewModel

            super.init(nibName: nil, bundle: nil)
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            installSubviews()
            installBindings()
        }

        func installSubviews() {
            hostedView
                .disableAutoresizingMask()
                .addedToSuperview(view)
                .anchorToSuperviewEdges()
        }

        //MARK: Bindings
        func installBindings() {

        }
    }

    class <>ViewModel {

    }
    ]], {
        i(1, "Name"),
        d(2, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(3, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(4, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
        d(5, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 1 }),
    }, {
        delimiters = "<>"
    })),
    s("grtest", fmt([[
    //
    // Copyright 2025 by Grindr LLC,
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
        var sut: <>

        override func setUp() {
            super.setUp()
            Container.shared.reset()

            sut = <>(<>)
        }

        override func tearDown() {
            sut = nil
        }
    }
    ]], {
        i(1, "Class Name"),
        i(2, "SUT Type"),
        d(3, function(args)
            return sn(nil, {
                i(1, args[1])
            })
        end, { 2 }),
        i(0)
    }, {
        delimiters = "<>"
    })),
    -- Grindr constraint setup
    s("grconstraint", fmt([[
        <>
            .addedToSuperview(self)
            .disableAutoresizingMask()
            .anchorToSuperviewLeading()
            .anchorToSuperviewTop()
            .anchorToSuperviewBottom()
            .anchorToSuperviewTrailing()
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
