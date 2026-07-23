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
