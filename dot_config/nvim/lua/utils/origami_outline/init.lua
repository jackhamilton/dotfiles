local refresh = require("utils.origami_outline.refresh")
local setup = require("utils.origami_outline.setup")

return {
    openContainingFolds = refresh.openContainingFolds,
    refresh = refresh.refresh,
    refreshPicker = refresh.refreshPicker,
    setup = setup.setup,
}
