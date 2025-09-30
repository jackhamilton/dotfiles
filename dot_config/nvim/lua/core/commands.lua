vim.api.nvim_create_user_command("SudoWrite", function()
  require("utils.sudo_write").write()
end, { desc = "Write file with sudo permissions" })

vim.api.nvim_create_user_command("DeleteMarks", function()
    vim.cmd [[delmarks a-zA-Z0-9]]
end, { desc = "Write file with sudo permissions" })
