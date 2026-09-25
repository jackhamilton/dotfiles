local function open_containing_fold_at_cursor()
    local win = vim.api.nvim_get_current_win()
    require("utils.origami_outline").openContainingFolds(win, vim.api.nvim_win_get_cursor(win)[1])
end

local function next_inline_hunk()
    require("diffview.actions").next_inline_hunk()
    vim.schedule(open_containing_fold_at_cursor)
end

local function previous_inline_hunk()
    require("diffview.actions").prev_inline_hunk()
    vim.schedule(open_containing_fold_at_cursor)
end

return {
    {
        "dlyongemallo/diffview-plus.nvim",
        keys = {
            { "<leader>jC", "<Cmd>DiffviewClose<CR>", desc = "Close diff view" },
        },
        opts = {
            preferred_adapter = "jj",
            enhanced_diff_hl = true,
            view = {
                default = {
                    layout = "diff1_inline",
                },
                file_history = {
                    layout = "diff1_inline",
                },
                inline = {
                    style = "overleaf",
                    fold_unchanged = true,
                },
                cycle_layouts = {
                    default = {
                        "diff2_horizontal",
                        "diff1_inline",
                        "diff2_vertical",
                        "diff1_plain",
                    },
                },
            },
            hooks = {
                diff_buf_win_enter = function(_, winid)
                    vim.schedule(function()
                        if vim.api.nvim_win_is_valid(winid) then
                            local line = vim.api.nvim_win_get_cursor(winid)[1]
                            require("utils.origami_outline").openContainingFolds(winid, line)
                        end
                    end)
                end,
            },
            keymaps = {
                diff1_inline = {
                    { "n", "]c", next_inline_hunk, { desc = "Jump to the next inline-diff hunk and open folds" } },
                    { "n", "[c", previous_inline_hunk, { desc = "Jump to the previous inline-diff hunk and open folds" } },
                },
            },
            file_panel = {
                listing_style = "tree",
                win_config = { position = "left", width = 35 },
            },
        },
    },
}
