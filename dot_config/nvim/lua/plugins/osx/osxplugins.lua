return {
    {
        "wojciech-kulik/xcodebuild.nvim",
        dependencies = {
            "folke/snacks.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
        },
        lazy = false,
        keys = {
            { "Xf", "<cmd>XcodebuildProjectManager<cr>", desc = "Show Project Manager Actions" },
            { "Xb", "<cmd>XcodebuildBuild<cr>", desc = "Build Project" },
            { "XB", "<cmd>XcodebuildBuildForTesting<cr>", desc = "Build For Testing" },
            { "Xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & Run Project" },
            { "Xt", "<cmd>XcodebuildTest<cr>", desc = "Run Tests" },
            { "<leader>Xt", "<cmd>XcodebuildTestSelected<cr>", mode = "x", desc = "Run Selected Tests" },
            { "XT", "<cmd>XcodebuildTestClass<cr>", desc = "Run Current Test Class" },
            { "X.", "<cmd>XcodebuildTestRepeat<cr>", desc = "Repeat Last Test Run" },
            { "Xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle Xcodebuild Logs" },
            { "Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>", desc = "Toggle Code Coverage" },
            { "XC", "<cmd>XcodebuildShowCodeCoverageReport<cr>", desc = "Show Code Coverage Report" },
            { "Xe", "<cmd>XcodebuildTestExplorerToggle<cr>", desc = "Toggle Test Explorer" },
            { "Xs", "<cmd>XcodebuildFailingSnapshots<cr>", desc = "Show Failing Snapshots" },
            { "Xv", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select Device" },
            { "Xp", "<cmd>XcodebuildSelectTestPlan<cr>", desc = "Select Test Plan" },
            { "Xx", "<cmd>XcodebuildQuickfixLine<cr>", desc = "Quickfix Line" },
            { "Xa", "<cmd>XcodebuildCodeActions<cr>", desc = "Show Code Actions" },
        },
        init = function()
            local group = vim.api.nvim_create_augroup("XcodebuildTrouble", { clear = true })
            local build_diagnostics_namespace = vim.api.nvim_create_namespace("xcodebuild-build-diagnostics")
            local build_server_refresh_timer

            local function schedule_build_server_refresh()
                if build_server_refresh_timer then
                    vim.fn.timer_stop(build_server_refresh_timer)
                end

                build_server_refresh_timer = vim.defer_fn(function()
                    build_server_refresh_timer = nil
                    local settings = require("xcodebuild.project.config").settings

                    -- Package-local sessions use SwiftPM's .sourcekit-lsp
                    -- configuration. Only the parent Xcode-project session
                    -- should regenerate buildServer.json.
                    if settings.projectFile and settings.scheme then
                        require("xcodebuild.integrations.xcode-build-server")
                            .run_config_if_enabled()
                    end
                end, 500)
            end

            vim.api.nvim_create_autocmd("BufWritePost", {
                group = group,
                pattern = "*",
                callback = function(event)
                    local name = vim.fs.basename(vim.api.nvim_buf_get_name(event.buf))
                    if name == "Package.swift"
                        or name == "Package.resolved"
                        or name == "project.pbxproj"
                        or name == "contents.xcworkspacedata"
                        or name:match("%.xcscheme$")
                    then
                        schedule_build_server_refresh()
                    end
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                group = group,
                pattern = "XcodebuildBuildFinished",
                callback = function(event)
                    if event.data.success then
                        require("xcodebuild.integrations.lsp").restart_sourcekit_lsp()
                    end
                end,
            })

            -- xcodebuild.nvim publishes build failures to quickfix. Mirror
            -- those entries into vim.diagnostic so the same compiler errors
            -- are available to the normal diagnostic UI as a fallback when
            -- SourceKit cannot publish them for a buffer.
            vim.api.nvim_create_autocmd("User", {
                group = group,
                pattern = "XcodebuildBuildFinished",
                callback = function()
                    vim.diagnostic.reset(build_diagnostics_namespace)

                    local diagnostics_by_buffer = {}
                    for _, item in ipairs(vim.fn.getqflist({ items = 1 }).items) do
                        if item.valid == 1 and (item.type == "E" or item.type == "W") then
                            local bufnr = item.bufnr
                            if not bufnr or bufnr == 0 then
                                bufnr = vim.fn.bufadd(item.filename)
                            end

                            diagnostics_by_buffer[bufnr] = diagnostics_by_buffer[bufnr] or {}
                            table.insert(diagnostics_by_buffer[bufnr], {
                                lnum = math.max(item.lnum - 1, 0),
                                col = math.max(item.col - 1, 0),
                                severity = item.type == "E"
                                    and vim.diagnostic.severity.ERROR
                                    or vim.diagnostic.severity.WARN,
                                source = "xcodebuild",
                                message = item.text,
                            })
                        end
                    end

                    for bufnr, diagnostics in pairs(diagnostics_by_buffer) do
                        vim.diagnostic.set(build_diagnostics_namespace, bufnr, diagnostics, {})
                    end
                end,
            })

            vim.api.nvim_create_autocmd("User", {
                group = group,
                pattern = "XcodebuildBuildFinished",
                callback = function(event)
                    if not event.data.success and not event.data.cancelled then
                        require("trouble").open({
                            mode = "qflist",
                            focus = true,
                            filter = {
                                severity = vim.diagnostic.severity.ERROR,
                            },
                        })
                    end
                end,
            })
        end,
        opts = {
            project_config = {
                -- Keep xcodebuild.nvim's project state aligned with the
                -- working-directory-based SourceKit workspace selection.
                reload_on_cwd_change = true,
            },
            logs = {
                auto_open_on_failed_build = false,
                auto_open_on_failed_tests = false,
            },
            integrations = {
                pymobiledevice = {
                    enabled = true,
                },
                xcode_build_server = {
                    guess_scheme = false,
                },
                telescope_nvim = {
                    enabled = false,
                },
                snacks_nvim = {
                    enabled = true,
                },
                fzf_lua = {
                    enabled = false,
                },
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        event = 'LspAttach',
        dependencies = {
            { "wojciech-kulik/xcodebuild.nvim" },
        },
        keys = {
            { "XdD", "<cmd>XcodebuildDebug<cr>", desc = "Debug Without Build" },
            {
                "Xdn",
                function() require("xcodebuild.integrations.dap").debug_func_test() end,
                desc = "Debug Nearest Test",
            },
            {
                "XdT",
                function() require("xcodebuild.integrations.dap").debug_class_tests() end,
                desc = "Debug Test Class",
            },
            {
                "XdF",
                function() require("xcodebuild.integrations.dap").debug_failing_tests() end,
                desc = "Debug Failing Tests",
            },
            {
                "Xdm",
                function() require("xcodebuild.integrations.dap").toggle_message_breakpoint() end,
                desc = "Toggle Message Breakpoint",
            },
        },
        config = function()
            require("xcodebuild.integrations.dap").setup()
        end,
    },
}
