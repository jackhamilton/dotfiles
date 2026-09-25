local function jj(command)
    return function()
        vim.cmd("J " .. command)
    end
end

return {
    {
        "NicolasGB/jj.nvim",
        dependencies = {
            "folke/snacks.nvim",
            "dlyongemallo/diffview-plus.nvim",
        },
        keys = {
            { "<leader>jD", function()
                require("jj.diff").diff_revisions({ left = "@", right = "trunk()" })
            end, desc = "Review changes from trunk" },
            { "<leader>jH", jj("diff_history @..trunk()"), desc = "Review change history from trunk" },
            { "<leader>jd", function()
                require("jj.diff").diff_current({ rev = "trunk()", layout = "vertical" })
            end, desc = "Diff current file from trunk" },
            { "<leader>jj", function()
                require("jj.picker").status()
            end, desc = "Changed files picker" },
            { "<leader>jF", function()
                require("jj.picker").file_history()
            end, desc = "Current file history picker" },
            { "<leader>jX", function()
                require("jj.picker").conflict()
            end, desc = "Conflicted revisions picker" },
            { "<leader>jS", function()
                require("jj.picker").conflict_sections()
            end, desc = "Conflict sections picker" },
            { "<leader>jl", jj("log"), desc = "Jujutsu log" },
            { "<leader>js", jj("status"), desc = "Jujutsu status" },
            { "<leader>jf", jj("fetch"), desc = "Fetch" },
            { "<leader>jp", jj("push"), desc = "Push" },
            { "<leader>jc", jj("describe"), desc = "Describe change" },
            { "<leader>jn", jj("new"), desc = "Create new change" },
            { "<leader>je", jj("edit"), desc = "Edit change" },
            { "<leader>jr", jj("rebase"), desc = "Rebase change" },
            { "<leader>jq", jj("squash"), desc = "Squash change" },
            { "<leader>ja", jj("abandon"), desc = "Abandon change" },
            { "<leader>jx", jj("resolve"), desc = "Resolve conflicts" },
            { "<leader>jo", jj("open_pr"), desc = "Open PR" },
        },
        opts = {
            diff = {
                backend = "diffview",
            },
        },
    },
}
