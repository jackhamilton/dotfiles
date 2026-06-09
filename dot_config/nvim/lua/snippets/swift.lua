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
    -- simple view snippet
    s("uiview", {
        t({
            "//",
            "// Created 2026 by Jack Hamilton",
            "//",
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
    // Created 2026 by Jack Hamilton
    //

    import Foundation
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
    // Created 2026 by Jack Hamilton
    //

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
    -- SwiftUI View
    s({trig="grview", dscr="SwiftUI View"},
        fmt([[
        //
        // Created 2026 by Jack Hamilton
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
    -- View Model
    s({trig="grviewmodel", dscr="View Model"},
        fmt([[
        //
        // Created 2026 by Jack Hamilton
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
    -- Preview Provider
    s({trig="swpreview", dscr="Preview Provider"},
        fmt([[
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
            i(1,"Name"),
            d(2, function(args)
                return sn(nil, {
                    i(1, args[1])
                })
            end, { 1 }),
        }, {
            delimiters = "[]"
        })
    ),
    -- Sheet Preview Provider
    s({trig="grsheetpreview", dscr="Sheet-Style Preview Provider"},
        fmt([[
        //
        // Created 2026 by Jack Hamilton
        //

        import SwiftUI

        public struct []View_Previews: PreviewProvider, CaseIterablePreviewProvider {
            public enum PreviewCase: String, CaseIterablePreviewState {
                case basic

                @MainActor
                public func generatePreview() -> some View {
                    switch self {
                    case .basic:
                        return Color.swatch(\.fill.highlightPrimary)
                        .sheet(isPresented: .constant(true)) {
                            []View()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.swatch(\.fill.secondaryDarkBg))
                        }
                    }
                }
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
            delimiters = "[]"
        })
    ),
    -- Snapshot Test
    s({trig="swsnapshot", dscr="Snapshot Test"},
        fmt([[
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
            i(1,"Name"),
        }, {
            delimiters = "<>"
        })
    ),
    -- UIKit Snapshot Test
    s({trig="swuikitsnapshot", dscr="Snapshot Test"},
        fmt([[
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
    -- constraint setup
    s("swconstraint", fmt([[
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
    s("swimagebutton", fmt([[
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
    --label
    s("swlabel", fmt([[
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

    -- event tracking
    s({trig="swtracking", dscr="Event tracking"},
        fmt([[
//
// Created 2026 by Jack Hamilton
//

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
