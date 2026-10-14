local overseer = require("overseer")

return {
    name = "swift build",
    tags = { overseer.TAG.BUILD },
    condition = {
        filetype = { "swift" },
    },
    generator = function(_, callback)
        local package = vim.fs.find("Package.swift", {
            upward = true,
            type = "file",
            path = vim.fn.expand("%:p:h"),
        })[1]

        if not package then
            callback("No Package.swift found")
            return
        end

        callback({
            {
                name = "swift build",
                builder = function()
                    return {
                        cmd = { "swift", "build" },
                        cwd = vim.fs.dirname(package),
                        default_component_params = {
                            errorformat = [[%E%f:%l:%c: error: %m,%W%f:%l:%c: warning: %m]],
                        },
                    }
                end,
            },
        })
    end,
}
