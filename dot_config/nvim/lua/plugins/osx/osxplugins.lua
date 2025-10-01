return {
    {
        "wojciech-kulik/xcodebuild.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "MunifTanjim/nui.nvim",
            "ibhagwan/fzf-lua",
            "nvim-treesitter/nvim-treesitter", -- (optional) for Quick tests support (required Swift parser)
        },
        lazy = false,
        opts = {
          integrations = {
            pymobiledevice = {
              enabled = true,
            },
          }
        },
    },
    {
        "mfussenegger/nvim-dap",
        event = 'LspAttach',
        dependencies = {
            { "wojciech-kulik/xcodebuild.nvim" },
        },
        config = function()
            local xcodebuild = require("xcodebuild.integrations.dap")
            local codelldbPath = os.getenv("HOME") .. "/Documents/codelldb-darwin-arm64/extension/adapter/codelldb"

            xcodebuild.setup(codelldbPath)
            vim.keymap.set("n", "<leader>Xf", "<cmd>XcodebuildProjectManager<cr>",
                { desc = "Show Project Manager Actions" })

            vim.keymap.set("n", "<leader>Xb", "<cmd>XcodebuildBuild<cr>", { desc = "Build Project" })
            vim.keymap.set("n", "<leader>XB", "<cmd>XcodebuildBuildForTesting<cr>", { desc = "Build For Testing" })
            vim.keymap.set("n", "<leader>Xr", "<cmd>XcodebuildBuildRun<cr>", { desc = "Build & Run Project" })
            vim.keymap.set("n", "<leader>XD", "<cmd>XcodebuildDebug<cr>", { desc = "Debug Project" })
            vim.keymap.set("n", "<leader>Xt", "<cmd>XcodebuildTest<cr>", { desc = "Run Tests" })
            vim.keymap.set("v", "<leader>Xt", "<cmd>XcodebuildTestSelected<cr>", { desc = "Run Selected Tests" })
            vim.keymap.set("n", "<leader>XT", "<cmd>XcodebuildTestClass<cr>", { desc = "Run Current Test Class" })
            vim.keymap.set("n", "<leader>X.", "<cmd>XcodebuildTestRepeat<cr>", { desc = "Repeat Last Test Run" })
            vim.keymap.set("n", "<leader>Xl", "<cmd>XcodebuildToggleLogs<cr>", { desc = "Toggle Xcodebuild Logs" })
            vim.keymap.set("n", "<leader>Xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",
                { desc = "Toggle Code Coverage" })
            vim.keymap.set("n", "<leader>XC", "<cmd>XcodebuildShowCodeCoverageReport<cr>",
                { desc = "Show Code Coverage Report" })
            vim.keymap.set("n", "<leader>Xe", "<cmd>XcodebuildTestExplorerToggle<cr>",
                { desc = "Toggle Test Explorer" })
            vim.keymap.set("n", "<leader>Xs", "<cmd>XcodebuildFailingSnapshots<cr>",
                { desc = "Show Failing Snapshots" })
            vim.keymap.set("n", "<leader>Xd", "<cmd>XcodebuildSelectDevice<cr>", { desc = "Select Device" })
            vim.keymap.set("n", "<leader>Xp", "<cmd>XcodebuildSelectTestPlan<cr>", { desc = "Select Test Plan" })
            vim.keymap.set("n", "<leader>Xq", "<cmd>Telescope quickfix<cr>", { desc = "Show QuickFix List" })
            vim.keymap.set("n", "<leader>Xx", "<cmd>XcodebuildQuickfixLine<cr>", { desc = "Quickfix Line" })
            vim.keymap.set("n", "<leader>Xa", "<cmd>XcodebuildCodeActions<cr>", { desc = "Show Code Actions" })
        end,
    },
}
