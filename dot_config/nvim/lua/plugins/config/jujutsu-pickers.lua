local Snacks = require("snacks")
local Job = require("plenary.job")
local function jj_global_picker()
    local items = {}
    Snacks.notify("Diffing")
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

local wk = require("which-key")
wk.add({
  -- { "<leader>j",  group = "Jujutsu", mode = { "n", "x" } },
   { "<leader>j", function() jj_global_picker() end, desc = "Jujutsu", mode = { "n", "x" } },
})

