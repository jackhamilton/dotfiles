return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
	    lazygit = { enabled = true },
	    quickfile = { enabled = true },
	    words = { enabled = true },
	    gitbrowse = { enabled = true },
	    rename = { enabled = true },
        dashboard = {
            enabled = true,
            sections = {
                { section = "header" },
                {
                    pane = 2,
                    section = "terminal",
                    cmd = "if command -v colorscript; then\ncolorscript -e square\nfi",
                    height = 5,
                    padding = 1,
                },
                { section = "keys", gap = 1, padding = 1 },
                {
                    pane = 2,
                    icon = " ",
                    desc = "Browse Repo",
                    padding = 1,
                    key = "b",
                    action = function()
                        Snacks.gitbrowse()
                    end,
                },
                function()
                    local in_git = Snacks.git.get_root() ~= nil
                    local cmds = {
                        {
                            title = "Notifications",
                            cmd = "gh notify -s -a -n5",
                            action = function()
                                vim.ui.open("https://github.com/notifications")
                            end,
                            key = "n",
                            icon = " ",
                            height = 5,
                            enabled = true,
                        },
                        {
                            title = "Open Issues",
                            cmd = "gh issue list -L 3",
                            key = "i",
                            action = function()
                                vim.fn.jobstart("gh issue list --web", { detach = true })
                            end,
                            icon = " ",
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Open PRs",
                            cmd = "gh pr list -L 3",
                            key = "p",
                            action = function()
                                vim.fn.jobstart("gh pr list --web", { detach = true })
                            end,
                            height = 7,
                        },
                        {
                            icon = " ",
                            title = "Git Status",
                            cmd = "git --no-pager diff --stat -B -M -C",
                            height = 10,
                        },
                    }
                    return vim.tbl_map(function(cmd)
                        return vim.tbl_extend("force", {
                            pane = 2,
                            section = "terminal",
                            enabled = in_git,
                            padding = 1,
                            ttl = 5 * 60,
                            indent = 3,
                        }, cmd)
                    end, cmds)
                end,
                { section = "startup" },
            },
        }
    },
    keys = {
        {
            "<leader>gg",
            mode = { "n" },
            function()
                ---@param opts? snacks.lazygit.Config
                Snacks.lazygit.open(opts)
            end,
            desc = "Lazygit"
        },
        {
            "<leader>go",
            mode = { "n" },
            function()
                ---@param opts? snacks.gitbrowse.Config
                Snacks.gitbrowse.open(opts)
            end,
            desc = "Open branch in browser"
        },
        {
            "<leader>fr",
            mode = { "n" },
            function()
                Snacks.rename.rename_file()
            end,
            desc = "Rename file"
        },
    }
}
