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
    s("lorem", t("Lorem ipsum dolor sit amet consectetur adipiscing elot sed do eiusmod tempor.")),
    -- Subscription
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
    s("gruiview", {
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
    s("gruivc", fmt([[
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
    s("grunittest", fmt([[
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

    class <>Tests: XCTestCase {
        var sut: <>!

        override func setUp() {
            super.setUp()
            @resetDependencies

            sut = <>(<>)
        }

        override func tearDown() {
            sut = nil
        }
    }
    ]], {
        i(1, "SUT Type"),
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
        i(0)
    }, {
        delimiters = "<>"
    })),
    -- Grindr SwiftUI View
    s({trig="grview", dscr="Grindr SwiftUI View"},
        fmt([[
        //
        // Copyright 2025 by Grindr LLC,
        // All rights reserved.
        //
        // This software is confidential and proprietary information of
        // Grindr LLC ("Confidential Information").
        // You shall not disclose such Confidential Information and shall use
        // it only in accordance with the terms of the license agreement
        // you entered into with Grindr LLC.
        //

        import SwiftUI

        /// <>
        public struct <>View: View {
            public var body: some View {
                <>
            }
        }

        #Preview {
            <>View_Previews.previews
        }
        ]], {
            i(1, "Description"),
            i(2, "Name"),
            i(0),
            d(3, function(args)
                return sn(nil, {
                    i(2, args[1])
                })
            end, { 2 }),
        }, {
            delimiters = "<>"
        })
    ),
    -- Grindr View Model
    s({trig="grviewmodel", dscr="Grindr View Model"},
        fmt([[
        //
        // Copyright 2025 by Grindr LLC,
        // All rights reserved.
        //
        // This software is confidential and proprietary information of
        // Grindr LLC ("Confidential Information").
        // You shall not disclose such Confidential Information and shall use
        // it only in accordance with the terms of the license agreement
        // you entered into with Grindr LLC.
        //

        import Combine

        public struct <>ViewModel {
            public init() {
                <>
            }
        }
        ]], {
            i(1,"Name"),
            i(0),
        }, {
            delimiters = "<>"
        })
    ),
    -- Grindr Preview Provider
    s({trig="grpreview", dscr="Grindr Preview Provider"},
        fmt([[
        //
        // Copyright 2025 by Grindr LLC,
        // All rights reserved.
        //
        // This software is confidential and proprietary information of
        // Grindr LLC ("Confidential Information").
        // You shall not disclose such Confidential Information and shall use
        // it only in accordance with the terms of the license agreement
        // you entered into with Grindr LLC.
        //

        import GrindrxFeatureUI
        import GrindrSwiftUI
        import SwiftUI

        public struct <>View_Previews: PreviewProvider {
            public static var previews: some View {
                snapshots.previews
        #if DEBUG
                    .grindrPreview()
        #endif
            }

            public static var snapshots: PreviewSnapshots<<PreviewState>> {
                PreviewSnapshots(
                    states: [
                        .init(name: "basic"),
                    ],
                    configure: { config in
                        <>View()
                    }
                )
            }

            public struct PreviewState: NamedPreviewState {
                public var name: String
            }
        }
        ]], {
            i(1,"Name"),
            d(2, function(args)
                return sn(nil, {
                    i(1, args[1])
                })
            end, { 1 }),
        }, {
            delimiters = "<>"
        })
    ),
    -- Grindr Sheet Preview Provider
    s({trig="grsheetpreview", dscr="Grindr Sheet-Style Preview Provider"},
        fmt([[
        //
        // Copyright 2025 by Grindr LLC,
        // All rights reserved.
        //
        // This software is confidential and proprietary information of
        // Grindr LLC ("Confidential Information").
        // You shall not disclose such Confidential Information and shall use
        // it only in accordance with the terms of the license agreement
        // you entered into with Grindr LLC.
        //

        import GrindrSwiftUI
        import SwiftUI

        public static var previews: some View {
            snapshots.previews
        #if DEBUG
                .grindrPreviews()
        #endif
        }

        public struct <>View_Previews: PreviewProvider {
            public static var snapshots: PreviewSnapshots<<PreviewState>> {
                PreviewSnapshots(
                    states: [
                        .init(name: "basic"),
                    ],
                    configure: { config in
                        Color.swatch(\.fill.highlightPrimary)
                        .sheet(isPresented: .constant(true)) {
                            <>View()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.swatch(\.fill.secondaryDarkBg))
                        }
                    }
                )
            }

            public struct PreviewState: NamedPreviewState {
                public var name: String
            }
        }
        ]], {
            i(1,"Name"),
            d(2, function(args)
                return sn(nil, {
                    i(1, args[1])
                })
            end, { 1 }),
        }, {
            delimiters = "<>"
        })
    ),
    -- Grindr Snapshot Test
    s({trig="grsnapshot", dscr="Grindr Snapshot Test"},
        fmt([[
        //
        // Copyright 2025 by Grindr LLC,
        // All rights reserved.
        //
        // This software is confidential and proprietary information of
        // Grindr LLC ("Confidential Information").
        // You shall not disclose such Confidential Information and shall use
        // it only in accordance with the terms of the license agreement
        // you entered into with Grindr LLC.
        //

        import GrindrSwiftUI
        import SwiftUI
        import XCTest

        final class <>SnapshotTests: BaseSnapshotTestCase {
            func test_<>Snapshots() {
                <>_Previews
                    .snapshots
                    .assertSnapshots(as: .testStrategy())
            }
        }
        ]], {
            i(1,"Name"),
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
        }, {
            delimiters = "<>"
        })
    ),
    -- Grindr UIKit Snapshot Test
    s({trig="gruikitsnapshot", dscr="Grindr Snapshot Test"},
        fmt([[
        //
        // Copyright 2025 by Grindr LLC,
        // All rights reserved.
        //
        // This software is confidential and proprietary information of
        // Grindr LLC ("Confidential Information").
        // You shall not disclose such Confidential Information and shall use
        // it only in accordance with the terms of the license agreement
        // you entered into with Grindr LLC.
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
            i(1,"Name"),
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
        }, {
            delimiters = "<>"
        })
    ),
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
    s("grimagebutton", fmt([[
    private let <> = UIButton.with {
        $0.setImageType(.<>, for: .normal)
        $0.tintColor = .swatch(.pureWhite)
    }
    ]], {
        i(1, "Variable name"),
        i(2, "ImageType"),
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

    -- Grindr event tracking
    s({trig="grtracking", dscr="Grindr event tracking"},
        fmt([[
//
// Copyright 2025 by Grindr LLC,
// All rights reserved.
//
// This software is confidential and proprietary information of
// Grindr LLC ("Confidential Information").
// You shall not disclose such Confidential Information and shall use
// it only in accordance with the terms of the license agreement
// you entered into with Grindr LLC.
//
import Factory
import GrindrCore
import GrindrDataModels
import GrindrMacros

protocol *;Tracking {
    func track*;()
}

@ResolveDependencies(immediate: \.eventTracker)
final class *;Tracker: *;Tracking {
    func track*;() {
        eventTracker.track(
            *;Event.*;()
        )
    }
}

private enum *;Event: EventLoggable {
    case *;

    func toEvents() -> [any RoutedEvent] {
        switch self {
        case .*;:
            [
                IdentifiableEvent(
                    name: "*;",
                    attributes: [
                        *;
                    ]
                ),
            ]
}
        ]], {
            i(1,"EventType", {key="type"}),
            d(3, function()
                return sn(nil, {
                    f(to_uppercase, k("name")),
                })
            end, k("name")),
            d(4, function(args)
                return sn(nil, {
                    t(args[1])
                })
            end, k("type")),
            d(5, function(args)
                return sn(nil, {
                    t(args[1])
                })
            end, k("type")),
            d(6, function()
                return sn(nil, {
                    f(to_uppercase, k("name")),
                })
            end, k("name")),
            d(7, function(args)
                return sn(nil, {
                    t(args[1])
                })
            end, k("type")),
            d(8, function(args)
                return sn(nil, {
                    t(args[1])
                })
            end, k("name")),
            d(9, function(args)
                return sn(nil, {
                    t(args[1])
                })
            end, k("type")),
            i(2, "eventName", {key="name"}),
            d(10, function(args)
                return sn(nil, {
                    t(args[1])
                })
            end, k("name")),
            i(11, "event_tracking_id"),
            i(0)
        }, {
            delimiters = "*;"
        })
    ),
}
