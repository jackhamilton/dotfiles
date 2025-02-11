vim.api.nvim_create_user_command("SudoWrite", function()
  require("utils.sudo_write").write()
end, { desc = "Write file with sudo permissions" })

vim.api.nvim_create_user_command("XCRebuild", function()
  require("utils.sudo_write").write()
    local Job = require("plenary.job")
    local job = Job:new({
	    cwd = "/Users/jackhamilton/Documents/GitHub/grindr/",
	    command = "xcreset",
	    on_exit = function(j, return_val)
	        require("notify")("Finished XCode Rebuild")
	    end,
    })
    job:start()
end, { desc = "Rebuild XCWorkspace and regenerate buildServer.json" })

