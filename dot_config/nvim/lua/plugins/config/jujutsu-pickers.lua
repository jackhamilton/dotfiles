local Snacks = require("snacks")
local Job = require("plenary.job")
local function jj_pr_diff()
    local items = {}
      local diffed = Job:new({
        command = "jj",
        args = { "diff", "-r", "pr", "--name-only" },
      }):sync()
      if diffed ~= nil then
          for i, item in ipairs(diffed) do
            table.insert(items, {
              idx = i,
              score = i,
              text = item,
              name = item,
              file = item,
            })
          end
      end

      return Snacks.picker({
        items = items,
      })
end

local function jj_main_diff()
    local items = {}
      local diffed = Job:new({
        command = "jj",
        args = { "diff", "--from", "main", "--name-only" },
      }):sync()
      if diffed ~= nil then
          for i, item in ipairs(diffed) do
            table.insert(items, {
              idx = i,
              score = i,
              text = item,
              name = item,
              file = item,
            })
          end
      end

      return Snacks.picker({
        items = items,
      })
end

local wk = require("which-key")
wk.add({
   { "<leader>j",  group = "Jujutsu", mode = { "n", "x" } },
   { "<leader>jp", function() jj_pr_diff() end, desc = "Files changed in PR", mode = { "n", "x" } },
   { "<leader>jm", function() jj_main_diff() end, desc = "Files changed from main", mode = { "n", "x" } },
})

